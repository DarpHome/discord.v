module discord

import arrays

pub enum Intents {
	guilds                        = 1 << 0
	guild_members                 = 1 << 1
	guild_moderation              = 1 << 2
	guild_emojis_and_stickers     = 1 << 3
	guild_integrations            = 1 << 4
	guild_webhooks                = 1 << 5
	guild_invites                 = 1 << 6
	guild_voice_states            = 1 << 7
	guild_presences               = 1 << 8
	guild_messages                = 1 << 9
	guild_message_reactions       = 1 << 10
	guild_message_typing          = 1 << 11
	direct_messages               = 1 << 12
	direct_message_reactions      = 1 << 13
	direct_message_typing         = 1 << 14
	message_content               = 1 << 15
	guild_scheduled_events        = 1 << 16
	auto_moderation_configuration = 1 << 20
	auto_moderation_execution     = 1 << 21
}

pub fn intents(list ...Intents) int {
	return arrays.fold(list, 0, fn (x int, y Intents) int {
		return x | int(y)
	})
}

pub const all_intents = intents(.guilds, .guild_members, .guild_moderation, .guild_emojis_and_stickers,
	.guild_integrations, .guild_webhooks, .guild_invites, .guild_voice_states, .guild_presences,
	.guild_messages, .guild_message_reactions, .guild_message_typing, .direct_messages,
	.direct_message_reactions, .direct_message_typing, .message_content, .guild_scheduled_events,
	.auto_moderation_configuration, .auto_moderation_execution)
