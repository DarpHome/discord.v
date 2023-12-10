module discord

import x.json2
import net.websocket
import time

@[heap]
pub struct GatewayClient {
	Client
pub:
	intents     int
	properties  ?Properties
	gateway_url string = 'wss://gateway.discord.gg'
mut:
	ws       &websocket.Client = unsafe { nil }
	ready    bool
	sequence ?int
pub mut:
	// === events ====
	on_raw_event EventController[DispatchEvent[GatewayClient]]
}

fn (mut c GatewayClient) recv() !WSMessage {
	return ws_recv_message(mut c.ws)!
}

fn (mut c GatewayClient) send(message WSMessage) ! {
	c.logger.debug('Sending message: ')
	ws_send_message(mut c.ws, message)!
}

fn (mut c GatewayClient) heartbeat() ! {
	c.send(WSMessage{
		opcode: 1
		data: if c.sequence == none { json2.Null{} } else { json2.Any(c.sequence) }
	})!
}

fn (mut c GatewayClient) error_logger() fn (int, IError) {
	mut cr := &mut c
	return fn [mut cr] (i int, e IError) {
		cr.logger.error('Error on listener ${i}: ${e}')
	}
}

fn (mut c GatewayClient) raw_dispatch(name string, data json2.Any) ! {
	c.on_raw_event.emit(DispatchEvent[GatewayClient]{
		creator: &c
		name: name
		data: data
	},
		error_handler: c.error_logger()
	)
}

fn (mut c GatewayClient) spawn_heart(interval i64) {
	spawn fn (mut client GatewayClient, heartbeat_interval time.Duration) !int {
		client.logger.debug('Heart spawned with interval: ${heartbeat_interval}')
		for client.ready {
			client.logger.debug('Sleeping')
			time.sleep(heartbeat_interval)
			client.logger.debug('Sending HEARTBEAT')
			client.heartbeat()!
			client.logger.debug('Sent HEARTBEAT')
		}
		return 0
	}(mut c, interval * time.millisecond)
}

pub fn (mut c GatewayClient) init() ! {
	mut ws := websocket.new_client(c.gateway_url.trim_right('/?') + '?v=10&encoding=json')!
	c.ws = ws
	c.ready = false
	ws.on_close_ref(fn (mut _ websocket.Client, code int, reason string, r voidptr) ! {
		mut client := unsafe { &Client(r) }
		client.logger.error('Websocket closed with ${code} ${reason}')
	}, &mut c)
	ws.on_message_ref(fn (mut _ websocket.Client, m &websocket.Message, r voidptr) ! {
		mut client := unsafe { &GatewayClient(r) }
		message := decode_websocket_message(m)!
		if !client.ready {
			if message.opcode != 10 {
				return error('First message wasnt HELLO')
			}
			client.ready = true
			props := if o := client.properties {
				o
			} else {
				Properties{}
			}
			client.logger.debug('Sending IDENTIFY')
			client.send(WSMessage{
				opcode: 2
				data: json2.Any({
					'token':      json2.Any(client.token)
					'intents':    client.intents
					'properties': json2.Any({
						'os':      json2.Any(props.os)
						'browser': props.browser
						'device':  props.device
					})
				})
			})!
			client.logger.debug('Spawning heart')
			client.spawn_heart(message.data.as_map()['heartbeat_interval']! as i64)
			return
		}
		if message.opcode == 0 {
			client.logger.debug('Dispatch ${message.event}: ${message.data}')
			client.raw_dispatch(message.event, message.data)!
		}
	}, &c)
}

pub fn (mut c GatewayClient) run() ! {
	c.ws.connect()!
	c.ws.listen()!
}

pub fn (mut c GatewayClient) launch() ! {
	c.init()!
	c.run()!
}


fn (c Client) fetch_gateway_url() !string {
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
