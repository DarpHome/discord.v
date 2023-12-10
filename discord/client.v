module discord

import log
import net.websocket
import time
import x.json2
import os as v_os

pub struct Properties {
pub:
	os      string = v_os.user_os()
	browser string = 'discord.v'
	device  string = 'discord.v'
}

pub const default_user_agent = 'DiscordBot (https://github.com/DarpHome/discord.v, 10.0.0) V ${@VHASH}'

pub struct DispatchEvent[T] {
pub:
	creator &T
	name    string
	data    json2.Any
}

@[heap]
pub struct Client {
pub:
	token string

	base_url   string = 'https://discord.com/api/v10'
	user_agent string = discord.default_user_agent
mut:
	logger log.Logger
pub mut:
	user_data voidptr
}

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
	println('send ${message}')
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

@[params]
pub struct ClientConfig {
pub:
	user_agent string = discord.default_user_agent
	debug      bool
}

fn (config ClientConfig) get_level() log.Level {
	return if config.debug {
		.debug
	} else {
		.info
	}
}

@[params]
pub struct BotConfig {
	ClientConfig
pub:
	intents Intents
}

pub fn bot(token string, config BotConfig) GatewayClient {
	return GatewayClient{
		token: 'Bot ${token}'
		intents: int(config.intents)
		logger: log.Log{
			level: config.get_level()
			output_label: 'discord.v'
		}
		user_agent: config.user_agent
	}
}

pub fn bearer(token string, config ClientConfig) Client {
	return Client{
		token: 'Bearer ${token}'
		logger: log.Log{
			level: config.get_level()
			output_label: 'discord.v'
		}
		user_agent: config.user_agent
	}
}
