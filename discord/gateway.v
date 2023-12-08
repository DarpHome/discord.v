module discord

import x.json2

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
