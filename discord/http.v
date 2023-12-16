module discord

import net.http
import net.urllib
import x.json2

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
	req.user_agent = c.user_agent
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
		tmp := er['code'] or { json2.Any(0) }
		code := int(match tmp {
			int { i64(tmp) }
			i64 { tmp }
			else {
				return error('expected error.code to be int, got ${tmp.type_name()}')
			}
		})
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
					retry_after: er['retry_after']!.f32()
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

fn encode_query(vs urllib.Values) string {
	r := vs.encode()
	if r == '' {
		return ''
	}
	return '?${r}'
}
