module discord

import net.urllib

@[params]
pub struct WithReason {
pub:
	reason ?string
}

pub fn (c Client) delete_channel(id Snowflake, config WithReason) ! {
	c.request(.delete, '/channels/${urllib.path_escape(id.build())}', reason: config.reason)!
}
