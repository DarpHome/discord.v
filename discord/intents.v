module discord

import arrays

@[flag]
pub enum Intents {
	guilds
	guild_members
	guild_moderation
	guild_emojis_and_stickers
	guild_integrations
	guild_webhooks
	guild_invites
	guild_voice_states
	guild_presences
	guild_messages
	guild_message_reactions
	guild_message_typing
	direct_messages
	direct_message_reactions
	direct_message_typing
	message_content
	guild_scheduled_events
	reserved_17
	reserved_18
	reserved_19
	auto_moderation_configuration
	auto_moderation_execution
}

pub fn combine_intents(list ...Intents) Intents {
	return unsafe {
		Intents(arrays.fold(list, 0, fn (x int, y Intents) int {
			return x | int(y)
		}))
	}
}

pub const all_intents = combine_intents(.guilds, .guild_members, .guild_moderation, .guild_emojis_and_stickers,
	.guild_integrations, .guild_webhooks, .guild_invites, .guild_voice_states, .guild_presences,
	.guild_messages, .guild_message_reactions, .guild_message_typing, .direct_messages,
	.direct_message_reactions, .direct_message_typing, .message_content, .guild_scheduled_events,
	.auto_moderation_configuration, .auto_moderation_execution)
