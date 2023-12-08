module discord

import net.urllib

@[params]
pub struct WithReason {
pub:
	reason ?string
}

pub enum ChannelType as int {
	guild_text = 0
	dm = 1
	guild_voice = 2
	group_dm = 3
	guild_category = 4
	guild_announcement = 5
	announcement_thread = 10
	public_thread = 11
	private_thread = 12
	guild_stage_voice = 13
	guild_directory = 14
	guild_forum = 15
	guild_media = 16
}

pub fn (c Client) delete_channel(id Snowflake, config WithReason) ! {
	c.request(.delete, '/channels/${urllib.path_escape(id.build())}', reason: config.reason)!
}
