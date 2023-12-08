module discord

import net.urllib

pub fn (c Client) delete_message(channel_id Snowflake, id Snowflake, config WithReason) ! {
	c.request(.delete, '/channels/${urllib.path_escape(channel_id.build())}/messages/${urllib.path_escape(id.build())}',
		reason: config.reason
	)!
}
