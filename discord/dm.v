module discord

import maps
import x.json2

pub fn (c Client) create_dm(recipient_id Snowflake) ! {
	c.request(.post, '/users/@me/channels', json: {
		'recipient_id': json2.Any(recipient_id)
	})!
}

@[params]
pub struct CreateGroupDMParams {
pub:
	access_tokens []string
	nicks map[Snowflake]string
}

pub fn (c Client) create_group_dm(params CreateGroupDMParams) ! {
	c.request(.post, '/users/@me/channels', json: {
		'access_tokens': json2.Any(params.access_tokens.map(json2.Any(it)))
		'nicks': maps.to_map[Snowflake, string, string, json2.Any](params.nicks, fn (k Snowflake, v string) (string, json2.Any) {
			return k.build(), json2.Any(v)
		})
	})!
}