module discord

import x.json2
import net.websocket
import time

@[flag]
pub enum GatewayClientSettings {
	ignore_unknown_events
	dont_process
	dont_cut_debug
	dont_process_guild_events
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
	presence           ?UpdatePresenceParams
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
	user   User
	cache  Cache
	events Events
	ws     &websocket.Client = unsafe { nil }
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
		data: if seq := c.sequence {
			json2.Any(seq)
		} else {
			json2.null
		}
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
						client.logger.error('Unable to close websocket: ${err}. Making new connection.')
						client.init() or {
							client.logger.error('Unable to initialize new connection: ${err}')
							return
						}
						client.run() or {
							client.logger.error('Unable to run connection: ${err}')
							return
						}
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

fn (mut gc GatewayClient) hello() ! {
	if gc.session_id != '' {
		gc.logger.info('Sending RESUME')
		gc.send(WSMessage{
			opcode: .resume
			data: json2.Any({
				'token':      json2.Any(gc.token)
				'session_id': gc.session_id
				'seq':        if seq := gc.sequence {
					int(seq)
				} else {
					json2.null
				}
			})
		})!
		gc.logger.info('Sent RESUME')
	} else {
		props := gc.properties
		gc.logger.info('Sending IDENTIFY')
		mut data := {
			'token':      json2.Any(gc.token)
			'intents':    gc.intents
			'properties': json2.Any({
				'os':      json2.Any(props.os)
				'browser': props.browser
				'device':  props.device
			})
		}
		if presence := gc.presence {
			data['presence'] = presence.build()
		}
		gc.send(WSMessage{
			opcode: .identify
			data: data
		})!
	}
}

fn (mut c GatewayClient) init_ws(mut ws websocket.Client) {
	// did Microsoft updated vschannel, so TYPING_START does not kill bot?
	/* $if windows && !no_vschannel ? {
		$compile_warn('Websocket connection with Discord may die at some events with vschannel. Please pass `-d no_vschannel` if you want it work correctly.')
	} */
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
			client.hello()!
			if client.session_id == '' {
				client.logger.debug('Spawning heart')
				client.spawn_heart(message.data.as_map()['heartbeat_interval']!.i64())
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
					client.logger.debug('Dispatch ${message.event}: ' + if data.len < 100 {
						data
					} else {
						'${data[..100]}... ${data.len - 100} chars'
					})
				}
				if seq := message.seq {
					client.sequence = seq
				}
				client.raw_dispatch(message.event, message.data) or {
					client.logger.error('Dispatching ${message.event} failed: ${err}')
				}
				return
			}
			.reconnect {
				client.ws.close(1000, 'Discord restarting')!
			}
			.invalid_session {
				if !(message.data as bool) {
					// not resumable
					client.resume_gateway_url = ''
					client.session_id = ''
				}
				client.ws.close(1000, 'Invalid session')!
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
		message: 'Discord disconnected us for some reason'
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
		message: "Decode error: You sent an invalid payload to Discord. Don't do that!"
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
	mut reconnect := true
	mut connected := false
	for {
		$if trace ? {
			eprintln('iteration: ${reconnect}')
		}
		if reconnect {
			if connected {
				c.ws.close(1000, 'reconnect') or {}
			}
			c.resume_gateway_url = ''
			c.ws.connect() or {
				$if trace ? {
					eprintln('c.ws.connect() failed: ${err}; with code ${err.code()}')
				}
				return err
			}
			connected = true
		} else {
			reconnect = true
		}
		$if trace ? {
			eprintln('calling listen')
		}
		// blocks:
		c.ws.listen() or {
			$if trace ? {
				eprintln('listen failed: ${err}; with code ${err.code()}; message: ${err.msg()}')
			}
			if ![4, -29184].contains(err.code()) || !err.msg().contains('SSL') {
				$if trace ? {
					eprintln('returned error')
				}
				return err
			}
			// EINTR/SSL, should retry
			reconnect = true
			continue
		}
		$if trace ? {
			eprintln('listen returned')
		}
		if !reconnect {
			c.hello() or {
				reconnect = true
				continue
			}
		}
		close_code := c.close_code or { 0 }
		if close_code == 0 {
			reconnect = true
			continue
		}
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
			mut ws := websocket.new_client(c.resume_gateway_url.trim_right('/?') +
				'?v=10&encoding=json', c.websocket_opts())!
			c.ws = ws
			c.init_ws(mut ws)
		} else {
			c.init()!
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

pub type ArrayOrSnowflake = Snowflake | []Snowflake

pub fn (aos ArrayOrSnowflake) build() json2.Any {
	return match aos {
		Snowflake { json2.Any(aos.build()) }
		[]Snowflake { json2.Any(aos.map(|s| json2.Any(s.build()))) }
	}
}

// Used to request all members for a guild or a list of guilds. When initially connecting, if you don't have the GUILD_PRESENCES Gateway Intent, or if the guild is over 75k members, it will only send members who are in voice, plus the member for you (the connecting user). Otherwise, if a guild has over large_threshold members (value in the Gateway Identify), it will only send members who are online, have a role, have a nickname, or are in a voice channel, and if it has under large_threshold members, it will send all members. If a client wishes to receive additional members, they need to explicitly request them via this operation. The server will send Guild Members Chunk events in response with up to 1000 members per chunk until all members that match the request have been sent.
@[params]
pub struct RequestGuildMembersParams {
pub:
	// ID of the guild to get members for
	guild_id Snowflake @[required]
	// string that username starts with, or an empty string to return all members
	query ?string
	// maximum number of members to send matching the `query`; a limit of `0` can be used with an empty string `query` to return all members
	limit ?int
	// used to specify if we want the presences of the matched members
	presences ?bool
	// used to specify which users you wish to fetch
	user_ids ?ArrayOrSnowflake
	// nonce to identify the [Guild Members Chunk](#GuildMembersChunkEvent) response
	nonce ?string
}

pub fn (params RequestGuildMembersParams) build() json2.Any {
	mut j := {
		'guild_id': json2.Any(params.guild_id)
	}
	if query := params.query {
		j['query'] = query
	}
	if limit := params.limit {
		j['limit'] = limit
	}
	if presences := params.presences {
		j['presences'] = presences
	}
	if user_ids := params.user_ids {
		j['user_ids'] = user_ids.build()
	}
	if nonce := params.nonce {
		j['nonce'] = nonce
	}
	return j
}

pub fn (mut gc GatewayClient) request_guild_members(params RequestGuildMembersParams) ! {
	gc.send(WSMessage{
		opcode: .request_guild_members
		data: params.build()
	})!
}

@[params]
pub struct VoiceStateUpdateParams {
pub:
	// ID of the guild
	guild_id Snowflake
	// ID of the voice channel client wants to join (null if disconnecting)
	channel_id ?Snowflake
	// Whether the client is muted
	self_mute bool
	// Whether the client deafened
	self_deaf bool
}

pub fn (params VoiceStateUpdateParams) build() json2.Any {
	return {
		'guild_id':   json2.Any(params.guild_id.build())
		'channel_id': if s := params.channel_id {
			json2.Any(s.build())
		} else {
			json2.null
		}
		'self_mute':  params.self_mute
		'self_deaf':  params.self_deaf
	}
}

pub fn (mut gc GatewayClient) update_voice_state(params VoiceStateUpdateParams) ! {
	gc.send(WSMessage{
		opcode: .voice_state_update
		data: params.build()
	})!
}

@[params]
pub struct UpdatePresenceParams {
pub:
	// Unix time (in milliseconds) of when the client went idle, or null if the client is not idle
	since ?time.Time
	// User's activities
	activities []Activity
	// User's new status
	status Status = .online
	// Whether or not the client is afk
	afk bool
}

pub fn (params UpdatePresenceParams) build() json2.Any {
	return {
		'since':      if since := params.since {
			json2.Any(since.unix_time_milli())
		} else {
			json2.null
		}
		'activities': params.activities.map(|a| a.build())
		'status':     params.status.build()
		'afk':        params.afk
	}
}

pub fn (mut gc GatewayClient) update_presence(params UpdatePresenceParams) ! {
	gc.send(WSMessage{
		opcode: .update_presence
		data: params.build()
	})!
}
