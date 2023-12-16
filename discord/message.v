module discord

import net.urllib
import time

pub struct ChannelMention {
}

pub struct Attachment {
}

pub struct Embed {
}

pub type Nonce = int | string

pub enum MessageType {
	default
	recipient_add
	recipient_remove
	call
	channel_name_change
	channel_icon_change
	channel_pinned_message
	user_join
	guild_boost
	guild_boost_tier_1
	guild_boost_tier_2
	guild_boost_tier_3
	channel_follow_add
	guild_discovery_disqualified                = 14
	guild_discovery_requalified
	guild_discovery_grace_period_inital_warning
	guild_discovery_grace_period_final_warning
	thread_created
	reply
	chat_input_command
	thread_starter_message
	guild_invite_reminder
	context_menu_command
	auto_moderation_action
	role_subscription_purchase
	interaction_premium_upsell
	stage_start
	stage_end
	stage_speaker
	stage_topic                                 = 31
	guild_application_premium_subscription
}

pub enum MessageActivityType {
	join         = 1
	spectate
	listen
	join_request
}

pub struct MessageActivity {
pub:
	// type of message activity
	typ MessageActivityType
	// party_id from a Rich Presence event
	party_id ?Snowflake
}

pub struct MessageReference {
pub:
	// id of the originating message
	message_id ?Snowflake
	// id of the originating message's channel
	channel_id ?Snowflake
	// id of the originating message's guild
	guild_id ?Snowflake
	// when sending, whether to error if the referenced message doesn't exist instead of sending as a normal (non-reply) message, default true
	fail_if_not_exists ?bool
}

@[flags]
pub enum MessageFlags {
	crossposted
	is_crosspost
	suppress_embeds
	source_message_deleted
	urgent
	has_thread
	ephemeral
	loading
	failed_to_mention_some_roles_in_thread
	reserved_9
	reserved_10
	reserved_11
	suppress_notifications
	is_voice_message
}

pub struct MessageInteraction {
}

pub struct Message {
pub:
	id                 Snowflake
	channel_id         Snowflake
	author             User
	content            string
	timestamp          time.Time
	edited_timestamp   ?time.Time
	tts                bool
	mention_everyone   bool
	mentions           []User
	mention_roles      []Snowflake
	mention_channels   ?[]ChannelMention
	attachments        []Attachment
	embeds             []Embed
	reactions          ?[]Reaction
	nonce              ?Nonce
	pinned             bool
	webhook_id         ?Snowflake
	typ                MessageType
	activity           ?MessageActivity
	application        ?PartialApplication
	application_id     ?Snowflake
	message_reference  ?MessageReference
	flags              ?MessageFlags
	referenced_message ?&Message
	interaction        ?MessageInteraction
	thread             ?Channel
	components         ?[]Component

	guild_id ?Snowflake
	member   ?GuildMember
}

pub fn (c Client) delete_message(channel_id Snowflake, id Snowflake, config ReasonParam) ! {
	c.request(.delete, '/channels/${urllib.path_escape(channel_id.build())}/messages/${urllib.path_escape(id.build())}',
		reason: config.reason
	)!
}
