module discord

import x.json2
import net.websocket
import time

@[flag]
pub enum GatewayClientSettings {
	ignore_unknown_events
	dont_process
	dont_cut_debug
}

@[heap]
pub struct GatewayClient {
	Client
pub:
	settings    GatewayClientSettings
	intents     int
	properties  Properties
	gateway_url string = 'wss://gateway.discord.gg'
mut:
	ws                 &websocket.Client = unsafe { nil }
	presence           ?Presence
	ready              bool
	sequence           ?int
	last_heartbeat_req ?time.Time
	last_heartbeat_res ?time.Time
	close_code         ?int
	session_id         string
	resume_gateway_url string
	read_timeout       ?time.Duration
	write_timeout      ?time.Duration
pub mut:
	events Events
}

fn (mut c GatewayClient) recv() !WSMessage {
	return ws_recv_message(mut c.ws)!
}

fn (mut c GatewayClient) send(message WSMessage) ! {
	ws_send_message(mut c.ws, message)!
}

fn (mut c GatewayClient) heartbeat() ! {
	c.send(WSMessage{
		opcode: .heartbeat
		data: if c.sequence == none { json2.null } else { json2.Any(c.sequence) }
	})!
}

fn (mut c GatewayClient) error_logger() fn (int, IError) {
	mut lr := &mut c.logger
	return fn [mut lr] (i int, e IError) {
		lr.error('Error on listener ${i}: ${e}')
	}
}

fn (mut c GatewayClient) raw_dispatch(name string, data json2.Any) ! {
	event := DispatchEvent{
		creator: &c
		name: name
		data: data
	}
	if name == 'READY' {
		m := data as map[string]json2.Any
		c.resume_gateway_url = (m['resume_gateway_url']! as string).replace('\\', '')
		c.session_id = m['session_id']! as string
	}

	if c.settings.has(.dont_process) {
		c.events.on_raw_event.emit(event, error_handler: c.error_logger())
		return
	}
	if !c.process_dispatch(event)! {
		if c.settings.has(.ignore_unknown_events) {
			return
		}
		c.logger.debug('Unknown event ${name}, emitting raw instead')
		c.events.on_raw_event.emit(event, error_handler: c.error_logger())
	}
	return
}

fn (mut c GatewayClient) spawn_heart(interval i64) {
	spawn fn (mut client GatewayClient, heartbeat_interval time.Duration) {
		client.logger.info('Heart spawned with interval: ${heartbeat_interval}')
		for client.ready {
			client.logger.debug('Sleeping')
			time.sleep(heartbeat_interval)
			s := client.last_heartbeat_res
			if rq := client.last_heartbeat_req {
				rs := s or { time.unix(0) }
				if rs < rq {
					client.logger.error('Reconnecting due to zombied connection')
					client.ws.close(1000, 'No HEARTBEAT acks') or {
						client.logger.error('Unable to close websocket: ${err}')
					}
					return
				}
			}
			client.last_heartbeat_req = time.now()
			client.logger.debug('Sending HEARTBEAT')
			client.heartbeat() or {
				client.logger.error('Got error when sending heartbeat: ${err}')
				break
			}
			client.logger.debug('Sent HEARTBEAT')
		}
	}(mut c, interval * time.millisecond)
}

fn (mut c GatewayClient) init_ws(mut ws websocket.Client) {
	$if windows && !no_vschannel ? {
		$compile_warn('Websocket connection with Discord may die at some events with vschannel. Please pass `-d no_vschannel` if you want it work correctly.')
	}
	ws.on_close_ref(fn (mut _ websocket.Client, code int, reason string, mut client GatewayClient) ! {
		if reason != 'closed by client' {
			client.close_code = code
			client.logger.error('Websocket closed with ${code} ${reason}')
		}
	}, &mut c)
	ws.on_message_ref(fn (mut _ websocket.Client, m &websocket.Message, mut client GatewayClient) ! {
		message := decode_websocket_message(m)!
		if !client.ready {
			if message.opcode != .hello {
				return error('First message was not HELLO')
			}
			client.ready = true
			if seq := client.sequence {
				client.logger.info('Sending RESUME')
				client.send(WSMessage{
					opcode: .resume
					data: json2.Any({
						'token':      json2.Any(client.token)
						'session_id': client.session_id
						'seq':        seq
					})
				})!
				client.logger.info('Sent RESUME')
			} else {
				props := client.properties
				client.logger.info('Sending IDENTIFY')
				mut data := {
					'token':      json2.Any(client.token)
					'intents':    client.intents
					'properties': json2.Any({
						'os':      json2.Any(props.os)
						'browser': props.browser
						'device':  props.device
					})
				}
				if presence := client.presence {
					data['presence'] = presence.build()
				}
				client.send(WSMessage{
					opcode: .identify
					data: data
				})!
				client.logger.debug('Spawning heart')
				client.spawn_heart(message.data.as_map()['heartbeat_interval']! as i64)
			}
			return
		}
		match message.opcode {
			.heartbeat {
				client.heartbeat()!
			}
			.heartbeat_ack {
				client.last_heartbeat_res = time.now()
			}
			.dispatch {
				data := message.data.json_str()
				if client.settings.has(.dont_cut_debug) {
					client.logger.debug('Dispatch ${message.event}: ${data}')
				} else {
					client.logger.debug('Dispatch ${message.event}: ${if data.len < 100 {
						data
					} else {
						data[..100] + '... ' + (data.len - 100).str() + ' chars'
					}}')
				}
				if seq := message.seq {
					client.sequence = seq
				}
				/* fn (creatorp voidptr, msg WSMessage) {
					mut creator := unsafe { &GatewayClient(creatorp) }
					creator.raw_dispatch(msg.event, msg.data) or {
						creator.logger.error('Dispatching ${msg.event} failed: ${err}')
					}
				}(voidptr(client), message) */
				client.raw_dispatch(message.event, message.data) or {
					client.logger.error('Dispatching ${message.event} failed: ${err}')
				}
				return
			}
			.reconnect {
				client.ws.close(1000, 'Discord restarting')!
			}
			else {}
		}
	}, &c)
}

struct GatewayCloseCode {
	message   string
	reconnect bool
}

const gateway_close_code_table = {
	1000: GatewayCloseCode{
		message: ''
		reconnect: true
	}
	4000: GatewayCloseCode{
		message: "Unknown error: We're not sure what went wrong. Try reconnecting?"
		reconnect: true
	}
	4001: GatewayCloseCode{
		message: "Unknown opcode: You sent an invalid Gateway opcode or an invalid payload for an opcode. Don't do that!"
		reconnect: true
	}
	4002: GatewayCloseCode{
		message: "Decode error: You sent an invalid payload to Dicsord. Don't do that!"
		reconnect: true
	}
	4003: GatewayCloseCode{
		message: 'Not authenticated: You sent us a payload prior to identifying'
		reconnect: true
	}
	4004: GatewayCloseCode{
		message: 'Authentication failed: The account token sent with identify payload is incorrect.'
		reconnect: false
	}
	4005: GatewayCloseCode{
		message: "Already authenticated: You sent more than one identify payload. Don't do that!"
		reconnect: true
	}
	4007: GatewayCloseCode{
		message: 'Invalid `seq`: The sequence sent when resuming the session was invalid. Reconnect and start a new session.'
		reconnect: true
	}
	4008: GatewayCloseCode{
		message: "Rate limited: Woah nelly! You're sending payloads to us too quickly. Slow it down! You will be disconnected on receiving this."
		reconnect: true
	}
	4009: GatewayCloseCode{
		message: 'Session timed out: Your session timed out. Reconnect and start a new one.'
		reconnect: true
	}
	4010: GatewayCloseCode{
		message: 'Invalid shard: You sent us an invalid shard when identifying'
		reconnect: false
	}
	4011: GatewayCloseCode{
		message: 'Sharding required: The session would have handled too many guilds - you are required to shard your connection in order to connect.'
		reconnect: false
	}
	4012: GatewayCloseCode{
		message: 'Invalid API version: You sent an invalid version for the gateway.'
		reconnect: false
	}
	4013: GatewayCloseCode{
		message: 'Invalid intent(s): You sent an invalid intent for a Gateway Intent. You may have incorrectly calculated the bitwise value.'
		reconnect: false
	}
	4014: GatewayCloseCode{
		message: 'Disallowed intent(s): You sent a disallowed intent for a Gateway Intent. You may have tried to specify an intent that you have not enabled or are not approved for.'
		reconnect: false
	}
}

fn (c GatewayClient) websocket_opts() websocket.ClientOpt {
	return websocket.ClientOpt{
		read_timeout: c.read_timeout or { 10 * time.second }
		write_timeout: c.write_timeout or { 10 * time.second }
	}
}

pub fn (mut c GatewayClient) init() ! {
	mut ws := websocket.new_client(c.gateway_url.trim_right('/?') + '?v=10&encoding=json',
		c.websocket_opts())!
	c.ws = ws
	c.ready = false
	c.init_ws(mut ws)
}

pub fn (mut c GatewayClient) run() ! {
	c.close_code = none
	for {
		c.resume_gateway_url = ''
		c.ws.connect()!
		c.ws.listen()! // blocks
		close_code := c.close_code or { 0 }
		cc := discord.gateway_close_code_table[close_code] or {
			GatewayCloseCode{
				message: 'Unknown websocket close code ${close_code}'
				reconnect: false
			}
		}
		c.logger.error('Recieved close code ${close_code}: ${cc.message}')
		c.ready = false
		if !cc.reconnect {
			return error(cc.message)
		}
		if c.resume_gateway_url != '' {
			// resume
			c.ready = false
			mut ws := websocket.new_client(c.resume_gateway_url.trim_right('/?') +
				'?v=10&encoding=json', c.websocket_opts())!
			c.ws = ws
			c.init_ws(mut ws)
		}
	}
}

pub fn (mut c GatewayClient) launch() ! {
	// vfmt off
	c.logger.info('\n' +
		'+----- Running discord.v -----+\n' +
		'|                             |\n' +
		'| HTTP:                       |-\n' +
		'| - User agent:               | ${c.user_agent}\n' +
		'|                             |\n' +
		'| Gateway:                    |-\n' +
		'| - Properties:               |--\n' +
		'| -- Operating system:        | ${c.properties.os}\n' +
		'| -- Browser:                 | ${c.properties.browser}\n' +
		'| -- Device:                  | ${c.properties.device}\n' +
		'|                             |--\n' +
		'|                             |-\n' +
		'|                             |\n' +
		'+-----------------------------+')
	// vfmt on
	c.init()!
	c.run()!
}

pub fn (c Client) fetch_gateway_url() !string {
	r1 := json2.raw_decode(c.request(.get, '/gateway', authenticate: false)!.body)!
	return match r1 {
		map[string]json2.Any {
			r2 := r1['url']!
			match r2 {
				string { r2 }
				else { error('invalid url from api') }
			}
		}
		else {
			error('invalid response from api')
		}
	}
}

@[params]
pub struct UpdatePresence {
	Presence
}

pub fn (mut gc GatewayClient) update_presence(up UpdatePresence) ! {
	gc.send(WSMessage{
		opcode: .update_presence
		data: up.build()
	})!
}
