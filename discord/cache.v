module discord

pub struct Cache {
pub:
	guilds_check fn (Snowflake, Guild) bool = unsafe { nil }
	guilds_max_size ?int = 0

	roles_check fn (Snowflake, Snowflake, Role) bool = unsafe { nil }
	roles_max_size1 ?int = 0
	roles_max_size2 ?int = 0

	emojis_check fn (Snowflake, Snowflake, Emoji) bool = unsafe { nil }
	emojis_max_size1 ?int = 0
	emojis_max_size2 ?int = 0

	stickers_check fn (Snowflake, Snowflake, Sticker) bool = unsafe { nil }
	stickers_max_size1 ?int = 0
	stickers_max_size2 ?int = 0

	auto_moderation_rules_check fn (Snowflake, Snowflake, AutoModerationRule) bool = unsafe { nil }
	auto_moderation_rules_max_size1 ?int = 0
	auto_moderation_rules_max_size2 ?int = 0

	voice_states_check fn (Snowflake, Snowflake, VoiceState) bool = unsafe { nil }
	voice_states_max_size1 ?int = 0
	voice_states_max_size2 ?int = 0

	members_check fn (Snowflake, Snowflake, GuildMember) bool = unsafe { nil }
	members_max_size1 ?int = 0
	members_max_size2 ?int = 0

	channels_check fn (Snowflake, Channel) bool = unsafe { nil }
	channels_max_size ?int = 0

	messages_check fn (Snowflake, Snowflake, Message) bool = unsafe { nil }
	messages_max_size1 ?int = 0
	messages_max_size2 ?int = 0

	threads_check fn (Snowflake, Snowflake, Channel) bool = unsafe { nil }
	threads_max_size1 ?int = 0
	threads_max_size2 ?int = 0

	presences_check fn (Snowflake, Snowflake, Presence) bool = unsafe { nil }
	presences_max_size1 ?int = 0
	presences_max_size2 ?int = 0

	stage_instances_check fn (Snowflake, Snowflake, StageInstance) bool = unsafe { nil }
	stage_instances_max_size1 ?int = 0
	stage_instances_max_size2 ?int = 0

	guild_scheduled_events_check fn (Snowflake, Snowflake, GuildScheduledEvent) bool = unsafe { nil }
	guild_scheduled_events_max_size1 ?int = 0
	guild_scheduled_events_max_size2 ?int = 0

	entitlements_check fn (Snowflake, Snowflake, Entitlement) bool = unsafe { nil }
	entitlements_max_size1 ?int = 0
	entitlements_max_size2 ?int = 0

	users_check fn (Snowflake, User) bool = unsafe { nil }
	users_max_size ?int
pub mut:
	// {guild_id -> guild}
	guilds map[Snowflake]Guild
	// {guild_id -> {sticker_id -> role}}
	roles map[Snowflake]map[Snowflake]Role
	// {guild_id -> {sticker_id -> emoji}}
	emojis map[Snowflake]map[Snowflake]Emoji
	// {guild_id -> {sticker_id -> sticker}}
	stickers map[Snowflake]map[Snowflake]Sticker
	// {guild_id -> {rule_id -> rule}}
	auto_moderation_rules map[Snowflake]map[Snowflake]AutoModerationRule
	// {guild_id -> {user_id -> state}}
	voice_states map[Snowflake]map[Snowflake]VoiceState
	// {guild_id -> {user_id -> member}}
	members map[Snowflake]map[Snowflake]GuildMember
	// {channel_id -> channel}
	channels map[Snowflake]Channel
	// {channel_id -> {message_id -> message}}
	messages map[Snowflake]map[Snowflake]Message
	// {guild_id -> {channel_id -> thread}}
	threads map[Snowflake]map[Snowflake]Channel
	// {guild_id -> {user_id -> presence}}
	presences map[Snowflake]map[Snowflake]Presence
	// {guild_id -> {channel_id -> instance}}
	stage_instances map[Snowflake]map[Snowflake]StageInstance
	// {guild_id -> {guild_scheduled_event_id -> guild_scheduled_event}}
	guild_scheduled_events map[Snowflake]map[Snowflake]GuildScheduledEvent
	// {owner_id (user_id | guild_id) -> {entitlement_id -> entitlement}}
	entitlements map[Snowflake]map[Snowflake]Entitlement
	// {user_id -> user}
	users map[Snowflake]User
}

pub fn cache_add1[T](mut m1 map[Snowflake]T, max_size ?int, check fn (id1 Snowflake, o T) bool, id1 Snowflake, o T) {
	if check != unsafe { nil } {
		if !check(id1, o) {
			m1.delete(id1)
		}
	}
	if id1 !in m1 {
		if sz := max_size {
			if m1.len >= sz {
				for k, _ in m1 {
					m1.delete(k)
					break
				}
			}
		}
	}
	m1[id1] = o
}

pub fn cache_add2[T](mut m1 map[Snowflake]map[Snowflake]T, max_size1 ?int, max_size2 ?int, check fn (id1 Snowflake, id2 Snowflake, o T) bool, id1 Snowflake, id2 Snowflake, o T) {
	if check != unsafe { nil } {
		if !check(id1, id2, o) {
			m1.delete(id1)
		}
	}
	if id1 !in m1 {
		if sz := max_size1 {
			if m1.len >= sz {
				for k, _ in m1 {
					m1.delete(k)
					break
				}
			}
		}
	}
	if id1 !in m1 {
		m1[id1] = map[Snowflake]T{}
	}
	mut m2 := unsafe { mut m1[id1] }
	if id2 !in m1[id1] {
		if sz := max_size2 {
			if m2.len >= sz {
				for k, _ in m2 {
					m2.delete(k)
					break
				}
			}
		}
	}
	m2[id2] = o
}
