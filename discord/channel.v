module discord

import net.urllib

@[params]
pub struct ReasonParam {
pub:
	reason ?string
}

pub enum ChannelType {
	// a text channel within a server
	guild_text          = 0
	// a direct message between users
	dm                  = 1
	// a voice channel within a server
	guild_voice         = 2
	// a direct message between multiple users
	group_dm            = 3
	// an organizational category that contains up to 50 channels
	guild_category      = 4
	// a channel that users can follow and crosspost into their own server (formerly news channels)
	guild_announcement  = 5
	// a temporary sub-channel within a GUILD_ANNOUNCEMENT channel
	announcement_thread = 10
	// a temporary sub-channel within a GUILD_TEXT or GUILD_FORUM channel
	public_thread       = 11
	// a temporary sub-channel within a GUILD_TEXT channel that is only viewable by those invited and those with the MANAGE_THREADS permission
	private_thread      = 12
	// a voice channel for hosting events with an audience
	guild_stage_voice   = 13
	// the channel in a hub containing the listed servers
	guild_directory     = 14
	// Channel that can only contain threads
	guild_forum         = 15
	// Channel that can only contain threads, similar to GUILD_FORUM channels
	guild_media         = 16
}

// Delete a channel, or close a private message. Requires the `MANAGE_CHANNELS` permission for the guild, or `MANAGE_THREADS` if
// the channel is a thread. Deleting a category does not delete its child channels; they will have their parent_id removed and a
// Channel Update Gateway event will fire for each of them. Returns a channel object on success. Fires a Channel Delete Gateway
// event (or Thread Delete if the channel was a thread).
pub fn (c Client) delete_channel(id Snowflake, config ReasonParam) ! {
	c.request(.delete, '/channels/${urllib.path_escape(id.build())}', reason: config.reason)!
}
