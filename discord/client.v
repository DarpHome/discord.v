module discord

import net.http
import net.websocket
import time
import x.json2

pub struct Properties {
	os      string @[required]
	browser string @[required]
	device  string @[required]
}

pub struct Client {
pub:
	token      string
	intents    int
	properties ?Properties

	base_url    string = 'https://discord.com/api/v10'
	gateway_url string = 'wss://gateway.discord.gg'
mut:
	ws       &websocket.Client = unsafe { nil }
	ready    bool
	sequence ?int
}

fn (mut c Client) recv() !WSMessage {
	return ws_recv_message(mut c.ws)!
}

fn (mut c Client) send(message WSMessage) ! {
	println('send ${message}')
	ws_send_message(mut c.ws, message)!
}

fn (mut c Client) heartbeat() ! {
	c.send(WSMessage{
		opcode: 1
		data: if c.sequence == none { json2.Null{} } else { json2.Any(c.sequence) }
	})!
}

fn (mut c Client) dispatch(event string, data json2.Any) ! {
	if event == 'MESSAGE_CREATE' {
		dm := data.as_map()
		channel_id := dm['channel_id']! as string
		content := dm['content']! as string
		dump(content)
		if content.starts_with('!ping') {
			println('bro ${channel_id}')

			/*mut req := http.new_request(http.Method.post, 'https://discord.com/api/v10/channels/${channel_id}/messages',
				json2.Any({
				'content': json2.Any('pong')
			}).json_str())
			req.add_header(http.CommonHeader.authorization, c.token)
			req.add_header(http.CommonHeader.content_type, 'application/json')
			req.do()!*/
		}
		if content == '!gateway' {
			print('what')
			s := c.fetch_gateway_url()!
			print('why')
			c.request(.post, '/channels/${channel_id}/messages',
				json: {
					'content': json2.Any(s)
				}
			)!
		}
		c.heartbeat()!
	}
}

fn (mut c Client) spawn_heart(interval i64) {
	spawn fn (mut client Client, heartbeat_interval time.Duration) !int {
		for client.ready {
			time.sleep(heartbeat_interval)
			client.heartbeat()!
		}
		return 0
	}(mut c, time.millisecond * interval)
}

pub fn (mut c Client) init() ! {
	mut ws := websocket.new_client(c.gateway_url.trim_right('/?') + '?v=10&encoding=json')!
	c.ws = ws
	c.ready = false
	ws.on_close_ref(fn (mut _ websocket.Client, code int, reason string, r voidptr) ! {
		mut client := unsafe { &Client(r) }
		client.str()
	}, &mut c)
	ws.on_message_ref(fn (mut _ websocket.Client, m &websocket.Message, r voidptr) ! {
		mut client := unsafe { &Client(r) }
		println('recv')
		message := decode_websocket_message(m)!
		println('decode')
		if !client.ready {
			if message.opcode != 10 {
				return error('message is not HELLO')
			}
			client.ready = true
			props := if o := client.properties {
				o
			} else {
				Properties{
					os: 'windows'
					browser: 'V'
					device: 'V'
				}
			}
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
			client.spawn_heart(message.data.as_map()['heartbeat_interval']! as i64)
			return
		}
		if message.opcode == 0 {
			println('dispatch!')
			println('event: ${message.event}')
			println('data: ${message.data}')
			client.dispatch(message.event, message.data)!
		}
	}, &c)
}

pub fn (mut c Client) run() ! {
	c.ws.connect()!
	c.ws.listen()!
}

pub fn (mut c Client) launch() ! {
	c.init()!
	c.run()!
}

pub type Prepare = fn (mut http.Request) !

@[params]
pub struct RequestOptions {
	prepare        ?Prepare
	authenticate   bool = true
	reason         ?string
	json           ?json2.Any
	body           ?string
	common_headers map[http.CommonHeader]string
	headers        map[string]string
}

pub fn (c Client) request(method http.Method, route string, options RequestOptions) !http.Response {
	if options.json != none && options.body != none {
		return error('cannot have json and body')
	}
	mut req := http.new_request(method, c.base_url.trim_right('/') + '/' + route, if json := options.json {
		json.json_str()
	} else if body := options.body {
		body
	} else {
		''
	})
	req.header = http.Header{}
	if options.authenticate {
		req.header.add(.authorization, c.token)
	}
	if options.json != none {
		req.header.add(.content_type, 'application/json')
	}
	if reason := options.reason {
		req.header.add_custom('X-Audit-Log-Reason', reason)!
	}
	for k, v in options.common_headers {
		req.header.add(k, v)
	}
	for k, v in options.headers {
		req.header.add_custom(k, v)!
	}
	if f := options.prepare {
		f(mut &req)!
	}
	res := req.do()!
	if res.status_code >= 400 {
		status := res.status()
		er := json2.raw_decode(res.body)! as map[string]json2.Any
		code := int(er['code'] or { 0 } as i64)
		message := er['message'] or { '' } as string
		errors := er['errors'] or {
			map[string]json2.Any{}
		} as map[string]json2.Any
		if res.status_code >= 500 {
			return InternalServerError{
				code: code
				message: message
				errors: errors
				status: status
			}
		}
		match res.status_code {
			401 {
				return Unauthorized{
					code: code
					message: message
					errors: errors
					status: status
				}
			}
			403 {
				return Forbidden{
					code: code
					message: message
					errors: errors
					status: status
				}
			}
			404 {
				return NotFound{
					code: code
					message: message
					errors: errors
					status: status
				}
			}
			429 {
				return Ratelimit{
					code: code
					message: message
					errors: errors
					status: status
					retry_after: er['retry_after']! as f32
				}
			}
			else {
				return RestError{
					code: code
					message: message
					errors: errors
					status: status
				}
			}
		}
	}
	return res
}

pub type IntentsOrInt = Intents | int

pub fn bot(token string, botIntents ...IntentsOrInt) Client {
	mut computed_intents := 0
	for e in botIntents {
		computed_intents |= match e {
			Intents { int(e) }
			int { e }
		}
	}

	return Client{
		token: 'Bot ${token}'
		intents: computed_intents
	}
}

pub fn bearer(token string) Client {
	return Client{
		token: 'Bearer ${token}'
	}
}
