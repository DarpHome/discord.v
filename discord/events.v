module discord

import time
import x.json2

pub struct BaseEvent {
pub mut:
	creator &GatewayClient
}

pub struct DispatchEvent {
	BaseEvent
pub:
	name string
	data json2.Any
}

pub struct ApplicationCommandPermissionsUpdateEvent {
	BaseEvent
pub:
	permissions GuildApplicationCommandPermissions
}

pub fn ApplicationCommandPermissionsUpdateEvent.parse(j json2.Any, base BaseEvent) !ApplicationCommandPermissionsUpdateEvent {
	return ApplicationCommandPermissionsUpdateEvent{
		BaseEvent: base
		permissions: GuildApplicationCommandPermissions.parse(j)!
	}
}

pub struct AutoModerationRuleCreateEvent {
	BaseEvent
pub:
	rule AutoModerationRule
}

pub fn AutoModerationRuleCreateEvent.parse(j json2.Any, base BaseEvent) !AutoModerationRuleCreateEvent {
	return AutoModerationRuleCreateEvent{
		BaseEvent: base
		rule: AutoModerationRule.parse(j)!
	}
}

pub struct AutoModerationRuleUpdateEvent {
	BaseEvent
pub:
	rule AutoModerationRule
}

pub fn AutoModerationRuleUpdateEvent.parse(j json2.Any, base BaseEvent) !AutoModerationRuleUpdateEvent {
	return AutoModerationRuleUpdateEvent{
		BaseEvent: base
		rule: AutoModerationRule.parse(j)!
	}
}

pub struct AutoModerationRuleDeleteEvent {
	BaseEvent
pub:
	rule AutoModerationRule
}

pub fn AutoModerationRuleDeleteEvent.parse(j json2.Any, base BaseEvent) !AutoModerationRuleDeleteEvent {
	return AutoModerationRuleDeleteEvent{
		BaseEvent: base
		rule: AutoModerationRule.parse(j)!
	}
}

pub struct ChannelCreateEvent {
	BaseEvent
pub:
	channel Channel
}

pub fn ChannelCreateEvent.parse(j json2.Any, base BaseEvent) !ChannelCreateEvent {
	return ChannelCreateEvent{
		BaseEvent: base
		channel: Channel.parse(j)!
	}
}

pub struct ChannelUpdateEvent {
	BaseEvent
pub:
	channel Channel
}

pub fn ChannelUpdateEvent.parse(j json2.Any, base BaseEvent) !ChannelUpdateEvent {
	return ChannelUpdateEvent{
		BaseEvent: base
		channel: Channel.parse(j)!
	}
}

pub struct ChannelDeleteEvent {
	BaseEvent
pub:
	channel Channel
}

pub fn ChannelDeleteEvent.parse(j json2.Any, base BaseEvent) !ChannelDeleteEvent {
	return ChannelDeleteEvent{
		BaseEvent: base
		channel: Channel.parse(j)!
	}
}

pub struct AutoModerationActionExecutionEvent {
	BaseEvent
pub:
	// ID of the guild in which action was executed
	guild_id Snowflake
	// Action which was executed
	action Action
	// ID of the rule which action belongs to
	rule_id Snowflake
	// Trigger type of rule which was triggered
	rule_trigger_type TriggerType
	// ID of the user which generated the content which triggered the rule
	channel_id ?Snowflake
	// ID of any user message which content belongs to
	message_id ?Snowflake
	// ID of any system auto moderation messages posted as a result of this action
	alert_system_message_id ?Snowflake
	// User-generated text content
	content string
	// Word or phrase configured in the rule that triggered the rule
	matched_keyword ?string
	// Substring in content that triggered the rule
	matched_content ?string
}

pub fn AutoModerationActionExecutionEvent.parse(j json2.Any, base BaseEvent) !AutoModerationActionExecutionEvent {
	match j {
		map[string]json2.Any {
			matched_keyword := j['matched_keyword']!
			matched_content := j['matched_content']!
			return AutoModerationActionExecutionEvent{
				BaseEvent: base
				guild_id: Snowflake.parse(j['guild_id']!)!
				action: Action.parse(j['action']!)!
				rule_id: Snowflake.parse(j['rule_id']!)!
				rule_trigger_type: unsafe { TriggerType(j['rule_trigger_type']!.int()) }
				channel_id: if s := j['channel_id'] {
					Snowflake.parse(s)!
				} else {
					none
				}
				message_id: if s := j['message_id'] {
					Snowflake.parse(s)!
				} else {
					none
				}
				alert_system_message_id: if s := j['alert_system_message_id'] {
					Snowflake.parse(s)!
				} else {
					none
				}
				content: j['content']! as string
				matched_keyword: if matched_keyword !is json2.Null {
					matched_keyword as string
				} else {
					none
				}
				matched_content: if matched_content !is json2.Null {
					matched_content as string
				} else {
					none
				}
			}
		}
		else {
			return error('expected auto moderation action execution event to be object, got ${j.type_name()}')
		}
	}
}

pub struct ThreadCreateEvent {
	BaseEvent
pub:
	thread Channel
}

pub fn ThreadCreateEvent.parse(j json2.Any, base BaseEvent) !ThreadCreateEvent {
	return ThreadCreateEvent{
		BaseEvent: base
		thread: Channel.parse(j)!
	}
}

pub struct ThreadUpdateEvent {
	BaseEvent
pub:
	thread Channel
}

pub fn ThreadUpdateEvent.parse(j json2.Any, base BaseEvent) !ThreadUpdateEvent {
	return ThreadUpdateEvent{
		BaseEvent: base
		thread: Channel.parse(j)!
	}
}

pub struct ThreadDeleteEvent {
	BaseEvent
pub:
	thread Channel
}

pub fn ThreadDeleteEvent.parse(j json2.Any, base BaseEvent) !ThreadDeleteEvent {
	return ThreadDeleteEvent{
		BaseEvent: base
		thread: Channel.parse(j)!
	}
}

pub struct ThreadListSyncEvent {
	BaseEvent
pub:
	// ID of the guild
	guild_id Snowflake
	// Parent channel IDs whose threads are being synced. If omitted, then threads were synced for the entire guild. This array may contain channel_ids that have no active threads as well, so you know to clear that data.
	channel_ids ?[]Snowflake
	// All active threads in the given channels that the current user can access
	threads []Channel
	// All thread member objects from the synced threads for the current user, indicating which threads the current user has been added to
	members []ThreadMember
}

pub fn ThreadListSyncEvent.parse(j json2.Any, base BaseEvent) !ThreadListSyncEvent {
	match j {
		map[string]json2.Any {
			return ThreadListSyncEvent{
				BaseEvent: base
				guild_id: Snowflake.parse(j['guild_id']!)!
				channel_ids: if a := j['channel_ids'] {
					maybe_map(a as []json2.Any, fn (k json2.Any) !Snowflake {
						return Snowflake.parse(k)!
					})!
				} else {
					none
				}
				threads: maybe_map(j['threads']! as []json2.Any, fn (k json2.Any) !Channel {
					return Channel.parse(k)!
				})!
				members: maybe_map(j['members']! as []json2.Any, fn (k json2.Any) !ThreadMember {
					return ThreadMember.parse(k)!
				})!
			}
		}
		else {
			return error('expected thread list sync event to be object, got ${j.type_name()}')
		}
	}
}

pub struct ThreadMemberUpdateEvent {
	BaseEvent
pub:
	member ThreadMember2
}

pub fn ThreadMemberUpdateEvent.parse(j json2.Any, base BaseEvent) !ThreadMemberUpdateEvent {
	return ThreadMemberUpdateEvent{
		BaseEvent: base
		member: ThreadMember2.parse(j)!
	}
}

pub struct ChannelPinsUpdateEvent {
	BaseEvent
pub:
	// ID of the guild
	guild_id ?Snowflake
	// ID of the channel
	channel_id Snowflake
	// Time at which the most recent pinned message was pinned
	last_pin_timestamp ?time.Time
}

pub fn ChannelPinsUpdateEvent.parse(j json2.Any, base BaseEvent) !ChannelPinsUpdateEvent {
	match j {
		map[string]json2.Any {
			return ChannelPinsUpdateEvent{
				BaseEvent: base
				guild_id: if s := j['guild_id'] {
					Snowflake.parse(s)!
				} else {
					none
				}
				channel_id: Snowflake.parse(j['channel_id']!)!
				last_pin_timestamp: if s := j['last_pin_timestamp'] {
					if s !is json2.Null {
						time.parse_iso8601(s as string)!
					} else {
						none
					}
				} else {
					none
				}
			}
		}
		else {
			return error('expected channel pins update event to be object, got ${j.type_name()}')
		}
	}
}

pub struct EntitlementCreateEvent {
	BaseEvent
pub:
	entitlement Entitlement
}

pub fn EntitlementCreateEvent.parse(j json2.Any, base BaseEvent) !EntitlementCreateEvent {
	return EntitlementCreateEvent{
		BaseEvent: base
		entitlement: Entitlement.parse(j)!
	}
}

pub struct EntitlementUpdateEvent {
	BaseEvent
pub:
	entitlement Entitlement
}

pub fn EntitlementUpdateEvent.parse(j json2.Any, base BaseEvent) !EntitlementUpdateEvent {
	return EntitlementUpdateEvent{
		BaseEvent: base
		entitlement: Entitlement.parse(j)!
	}
}

pub struct EntitlementDeleteEvent {
	BaseEvent
pub:
	entitlement Entitlement
}

pub fn EntitlementDeleteEvent.parse(j json2.Any, base BaseEvent) !EntitlementDeleteEvent {
	return EntitlementDeleteEvent{
		BaseEvent: base
		entitlement: Entitlement.parse(j)!
	}
}

pub struct GuildCreateEvent {
	BaseEvent
pub:
	guild Guild
}

pub fn GuildCreateEvent.parse(j json2.Any, base BaseEvent) !GuildCreateEvent {
	return GuildCreateEvent{
		BaseEvent: base
		guild: Guild.parse(j)!
	}
}

pub struct GuildUpdateEvent {
	BaseEvent
pub:
	guild Guild
}

pub fn GuildUpdateEvent.parse(j json2.Any, base BaseEvent) !GuildUpdateEvent {
	return GuildUpdateEvent{
		BaseEvent: base
		guild: Guild.parse(j)!
	}
}

pub struct GuildDeleteEvent {
	BaseEvent
pub:
	guild UnavailableGuild
}

pub fn GuildDeleteEvent.parse(j json2.Any, base BaseEvent) !GuildDeleteEvent {
	return GuildDeleteEvent{
		BaseEvent: base
		guild: UnavailableGuild.parse(j)!
	}
}

pub struct GuildBanAddEvent {
	BaseEvent
pub:
	// ID of the guild
	guild_id Snowflake
	// User who was banned
	user User
}

pub fn GuildBanAddEvent.parse(j json2.Any, base BaseEvent) !GuildBanAddEvent {
	match j {
		map[string]json2.Any {
			return GuildBanAddEvent{
				BaseEvent: base
				guild_id: Snowflake.parse(j['guild_id']!)!
				user: User.parse(j['user']!)!
			}
		}
		else {
			return error('expected guild ban add event to be object, got ${j.type_name()}')
		}
	}
}

pub struct GuildBanRemoveEvent {
	BaseEvent
pub:
	// ID of the guild
	guild_id Snowflake
	// User who was banned
	user User
}

pub fn GuildBanRemoveEvent.parse(j json2.Any, base BaseEvent) !GuildBanRemoveEvent {
	match j {
		map[string]json2.Any {
			return GuildBanRemoveEvent{
				BaseEvent: base
				guild_id: Snowflake.parse(j['guild_id']!)!
				user: User.parse(j['user']!)!
			}
		}
		else {
			return error('expected guild ban remove event to be object, got ${j.type_name()}')
		}
	}
}

pub struct GuildEmojisUpdateEvent {
	BaseEvent
pub:
	// ID of the guild
	guild_id Snowflake
	// Array of emojis
	emojis []Emoji
}

pub fn GuildEmojisUpdateEvent.parse(j json2.Any, base BaseEvent) !GuildEmojisUpdateEvent {
	match j {
		map[string]json2.Any {
			return GuildEmojisUpdateEvent{
				BaseEvent: base
				guild_id: Snowflake.parse(j['guild_id']!)!
				emojis: maybe_map(j['emojis']! as []json2.Any, fn (k json2.Any) !Emoji {
					return Emoji.parse(k)!
				})!
			}
		}
		else {
			return error('expected guild emojis update event to be object, got ${j.type_name()}')
		}
	}
}

pub struct GuildStickersUpdateEvent {
	BaseEvent
pub:
	// ID of the guild
	guild_id Snowflake
	// Array of stickers
	stickers []Sticker
}

pub fn GuildStickersUpdateEvent.parse(j json2.Any, base BaseEvent) !GuildStickersUpdateEvent {
	match j {
		map[string]json2.Any {
			return GuildStickersUpdateEvent{
				BaseEvent: base
				guild_id: Snowflake.parse(j['guild_id']!)!
				stickers: maybe_map(j['stickers']! as []json2.Any, fn (k json2.Any) !Sticker {
					return Sticker.parse(k)!
				})!
			}
		}
		else {
			return error('expected guild emojis update event to be object, got ${j.type_name()}')
		}
	}
}

pub struct GuildIntegrationsUpdateEvent {
	BaseEvent
pub:
	// ID of the guild whose integrations were updated
	guild_id Snowflake
}

pub fn GuildIntegrationsUpdateEvent.parse(j json2.Any, base BaseEvent) !GuildIntegrationsUpdateEvent {
	match j {
		map[string]json2.Any {
			return GuildIntegrationsUpdateEvent{
				BaseEvent: base
				guild_id: Snowflake.parse(j['guild_id']!)!
			}
		}
		else {
			return error('expected guild integrations update event to be object, got ${j.type_name()}')
		}
	}
}

pub struct GuildMemberAddEvent {
	BaseEvent
pub:
	member GuildMember2
}

pub fn GuildMemberAddEvent.parse(j json2.Any, base BaseEvent) !GuildMemberAddEvent {
	return GuildMemberAddEvent{
		BaseEvent: base
		member: GuildMember2.parse(j)!
	}
}

pub struct GuildMemberRemoveEvent {
	BaseEvent
pub:
	// ID of the guild
	guild_id Snowflake
	// User who was removed
	user User
}

pub fn GuildMemberRemoveEvent.parse(j json2.Any, base BaseEvent) !GuildMemberRemoveEvent {
	match j {
		map[string]json2.Any {
			return GuildMemberRemoveEvent{
				BaseEvent: base
				guild_id: Snowflake.parse(j['guild_id']!)!
				user: User.parse(j['user']!)!
			}
		}
		else {
			return error('expected guild member remove event to be object, got ${j.type_name()}')
		}
	}
}

pub struct GuildMemberUpdateEvent {
	BaseEvent
pub:
	// ID of the guild
	guild_id Snowflake
	// User role ids
	roles []Snowflake
	// User
	user User
	// Nickname of the user in the guild
	nick ?NullOr[string]
	// Member's guild avatar hash
	avatar ?string
	// When the user joined the guild
	joined_at ?time.Time
	// When the user starting boosting the guild
	premium_since ?NullOr[time.Time]
	// Whether the user is deafened in voice channels
	deaf ?bool
	// Whether the user is muted in voice channels
	mute ?bool
	// Whether the user has not yet passed the guild's Membership Screening requirements
	pending ?bool
	// When the user's timeout will expire and the user will be able to communicate in the guild again, null or a time in the past if the user is not timed out
	communication_disabled_until ?NullOr[time.Time]
}

pub fn GuildMemberUpdateEvent.parse(j json2.Any, base BaseEvent) !GuildMemberUpdateEvent {
	match j {
		map[string]json2.Any {
			avatar := j['avatar']!
			joined_at := j['joined_at']!
			return GuildMemberUpdateEvent{
				BaseEvent: base
				guild_id: Snowflake.parse(j['guild_id']!)!
				roles: maybe_map(j['roles']! as []json2.Any, fn (k json2.Any) !Snowflake {
					return Snowflake.parse(k)!
				})!
				user: User.parse(j['user']!)!
				nick: if s := j['nick'] {
					if s !is json2.Null {
						some[string](s as string)
					} else {
						null[string]()
					}
				} else {
					none
				}
				avatar: if avatar !is json2.Null {
					avatar as string
				} else {
					none
				}
				joined_at: if joined_at !is json2.Null {
					time.parse_iso8601(joined_at as string)!
				} else {
					none
				}
				premium_since: if s := j['premium_since'] {
					if s !is json2.Null {
						some[time.Time](time.parse_iso8601(s as string)!)
					} else {
						null[time.Time]()
					}
				} else {
					none
				}
				deaf: if b := j['deaf'] {
					b as bool
				} else {
					none
				}
				mute: if b := j['mute'] {
					b as bool
				} else {
					none
				}
				pending: if b := j['pending'] {
					b as bool
				} else {
					none
				}
				communication_disabled_until: if s := j['communication_disabled_until'] {
					if s !is json2.Null {
						some[time.Time](time.parse_iso8601(s as string)!)
					} else {
						null[time.Time]()
					}
				} else {
					none
				}
			}
		}
		else {
			return error('expected guild member update event to be object, got ${j.type_name()}')
		}
	}
}

pub struct GuildMembersChunkEvent {
	BaseEvent
pub:
	// ID of the guild
	guild_id Snowflake
	// Set of guild members
	members []GuildMember
	// Chunk index in the expected chunks for this response (0 <= chunk_index < chunk_count)
	chunk_index int
	// Total number of expected chunks for this response
	chunk_count int
	// When passing an invalid ID to `REQUEST_GUILD_MEMBERS`, it will be returned here
	not_found ?[]Snowflake
	// When passing true to `REQUEST_GUILD_MEMBERS`, presences of the returned members will be here
	presences ?[]Presence
	// Nonce used in the Guild Members Request
	nonce ?string
}

pub fn GuildMembersChunkEvent.parse(j json2.Any, base BaseEvent) !GuildMembersChunkEvent {
	match j {
		map[string]json2.Any {
			return GuildMembersChunkEvent{
				BaseEvent: base
				guild_id: Snowflake.parse(j['guild_id']!)!
				members: maybe_map(j['members']! as []json2.Any, fn (k json2.Any) !GuildMember {
					return GuildMember.parse(k)!
				})!
				chunk_index: j['chunk_index']!.int()
				chunk_count: j['chunk_count']!.int()
				not_found: if a := j['not_found'] {
					maybe_map(a as []json2.Any, fn (k json2.Any) !Snowflake {
						return Snowflake.parse(k)!
					})!
				} else {
					none
				}
				presences: if a := j['presences'] {
					maybe_map(a as []json2.Any, fn (k json2.Any) !Presence {
						return Presence.parse(k)!
					})!
				} else {
					none
				}
				nonce: if s := j['nonce'] {
					s as string
				} else {
					none
				}
			}
		}
		else {
			return error('expected guild members chunk event to be object, got ${j.type_name()}')
		}
	}
}

pub struct GuildRoleCreateEvent {
	BaseEvent
pub:
	guild_id Snowflake
	role     Role
}

pub fn GuildRoleCreateEvent.parse(j json2.Any, base BaseEvent) !GuildRoleCreateEvent {
	match j {
		map[string]json2.Any {
			return GuildRoleCreateEvent{
				BaseEvent: base
				guild_id: Snowflake.parse(j['guild_id']!)!
				role: Role.parse(j['role']!)!
			}
		}
		else {
			return error('expected guild role create event to be object, got ${j.type_name()}')
		}
	}
}

pub struct GuildRoleUpdateEvent {
	BaseEvent
pub:
	guild_id Snowflake
	role     Role
}

pub fn GuildRoleUpdateEvent.parse(j json2.Any, base BaseEvent) !GuildRoleUpdateEvent {
	match j {
		map[string]json2.Any {
			return GuildRoleUpdateEvent{
				BaseEvent: base
				guild_id: Snowflake.parse(j['guild_id']!)!
				role: Role.parse(j['role']!)!
			}
		}
		else {
			return error('expected guild role update event to be object, got ${j.type_name()}')
		}
	}
}

pub struct GuildRoleDeleteEvent {
	BaseEvent
pub:
	guild_id Snowflake
	role_id  Snowflake
}

pub fn GuildRoleDeleteEvent.parse(j json2.Any, base BaseEvent) !GuildRoleDeleteEvent {
	match j {
		map[string]json2.Any {
			return GuildRoleDeleteEvent{
				BaseEvent: base
				guild_id: Snowflake.parse(j['guild_id']!)!
				role_id: Snowflake.parse(j['role_id']!)!
			}
		}
		else {
			return error('expected guild role delete event to be object, got ${j.type_name()}')
		}
	}
}

pub struct GuildScheduledEventCreateEvent {
	BaseEvent
pub:
	event GuildScheduledEvent
}

pub fn GuildScheduledEventCreateEvent.parse(j json2.Any, base BaseEvent) !GuildScheduledEventCreateEvent {
	return GuildScheduledEventCreateEvent{
		BaseEvent: base
		event: GuildScheduledEvent.parse(j)!
	}
}

pub struct GuildScheduledEventUpdateEvent {
	BaseEvent
pub:
	event GuildScheduledEvent
}

pub fn GuildScheduledEventUpdateEvent.parse(j json2.Any, base BaseEvent) !GuildScheduledEventUpdateEvent {
	return GuildScheduledEventUpdateEvent{
		BaseEvent: base
		event: GuildScheduledEvent.parse(j)!
	}
}

pub struct GuildScheduledEventDeleteEvent {
	BaseEvent
pub:
	event GuildScheduledEvent
}

pub fn GuildScheduledEventDeleteEvent.parse(j json2.Any, base BaseEvent) !GuildScheduledEventDeleteEvent {
	return GuildScheduledEventDeleteEvent{
		BaseEvent: base
		event: GuildScheduledEvent.parse(j)!
	}
}

pub struct GuildScheduledEventUserAddEvent {
	BaseEvent
pub:
	// ID of the guild scheduled event
	guild_scheduled_event_id Snowflake
	// ID of the user
	user_id Snowflake
	// ID of the guild
	guild_id Snowflake
}

pub fn GuildScheduledEventUserAddEvent.parse(j json2.Any, base BaseEvent) !GuildScheduledEventUserAddEvent {
	match j {
		map[string]json2.Any {
			return GuildScheduledEventUserAddEvent{
				BaseEvent: base
				guild_scheduled_event_id: Snowflake.parse(j['guild_scheduled_event_id']!)!
				user_id: Snowflake.parse(j['user_id']!)!
				guild_id: Snowflake.parse(j['guild_id']!)!
			}
		}
		else {
			return error('expected guild scheduled event user add event to be object, got ${j.type_name()}')
		}
	}
}

pub struct GuildScheduledEventUserRemoveEvent {
	BaseEvent
pub:
	// ID of the guild scheduled event
	guild_scheduled_event_id Snowflake
	// ID of the user
	user_id Snowflake
	// ID of the guild
	guild_id Snowflake
}

pub fn GuildScheduledEventUserRemoveEvent.parse(j json2.Any, base BaseEvent) !GuildScheduledEventUserRemoveEvent {
	match j {
		map[string]json2.Any {
			return GuildScheduledEventUserRemoveEvent{
				BaseEvent: base
				guild_scheduled_event_id: Snowflake.parse(j['guild_scheduled_event_id']!)!
				user_id: Snowflake.parse(j['user_id']!)!
				guild_id: Snowflake.parse(j['guild_id']!)!
			}
		}
		else {
			return error('expected guild scheduled event user remove event to be object, got ${j.type_name()}')
		}
	}
}

pub struct IntegrationCreateEvent {
	BaseEvent
pub:
	integration Integration2
}

pub fn IntegrationCreateEvent.parse(j json2.Any, base BaseEvent) !IntegrationCreateEvent {
	return IntegrationCreateEvent{
		BaseEvent: base
		integration: Integration2.parse(j)!
	}
}

pub struct IntegrationUpdateEvent {
	BaseEvent
pub:
	integration Integration2
}

pub fn IntegrationUpdateEvent.parse(j json2.Any, base BaseEvent) !IntegrationUpdateEvent {
	return IntegrationUpdateEvent{
		BaseEvent: base
		integration: Integration2.parse(j)!
	}
}

pub struct IntegrationDeleteEvent {
	BaseEvent
pub:
	// Integration ID
	id Snowflake
	// ID of the guild
	guild_id Snowflake
	// ID of the bot/OAuth2 application for this discord integration
	application_id ?Snowflake
}

pub fn IntegrationDeleteEvent.parse(j json2.Any, base BaseEvent) !IntegrationDeleteEvent {
	match j {
		map[string]json2.Any {
			return IntegrationDeleteEvent{
				BaseEvent: base
				id: Snowflake.parse(j['id']!)!
				guild_id: Snowflake.parse(j['guild_id']!)!
				application_id: if s := j['application_id'] {
					Snowflake.parse(s)!
				} else {
					none
				}
			}
		}
		else {
			return error('expected integration delete event to be object, got ${j.type_name()}')
		}
	}
}

pub struct InviteCreateEvent {
	BaseEvent
pub:
	// Channel the invite is for
	channel_id Snowflake
	// Unique invite code
	code string
	// Time at which the invite was created
	created_at time.Time
	// Guild of the invite
	guild_id ?Snowflake
	// User that created the invite
	inviter ?User
	// How long the invite is valid for
	max_age time.Duration
	// Maximum number of times the invite can be used
	max_uses int
	// Type of target for this voice channel invite
	target_type ?InviteTargetType
	// User whose stream to display for this voice channel stream invite
	target_user ?User
	// Embedded application to open for this voice channel embedded application invite
	target_application ?PartialApplication
	// Whether or not the invite is temporary (invited users will be kicked on disconnect unless they're assigned a role)
	temporary bool
	// How many times the invite has been used (always will be 0)
	// uses int // not provided because it is always 0 in event
}

pub fn InviteCreateEvent.parse(j json2.Any, base BaseEvent) !InviteCreateEvent {
	match j {
		map[string]json2.Any {
			return InviteCreateEvent{
				BaseEvent: base
				channel_id: Snowflake.parse(j['channel_id']!)!
				code: j['code']! as string
				created_at: time.parse_iso8601(j['created_at']! as string)!
				guild_id: if s := j['guild_id'] {
					Snowflake.parse(s)!
				} else {
					none
				}
				inviter: if o := j['inviter'] {
					User.parse(o)!
				} else {
					none
				}
				max_age: j['max_age']!.int() * time.second
				max_uses: j['max_uses']!.int()
				target_type: if i := j['target_type'] {
					unsafe { InviteTargetType(i.int()) }
				} else {
					none
				}
				target_user: if o := j['target_user'] {
					User.parse(o)!
				} else {
					none
				}
				target_application: if o := j['target_application'] {
					PartialApplication.parse(o)!
				} else {
					none
				}
				temporary: j['temporary']! as bool
			}
		}
		else {
			return error('expected invite create event to be object, got ${j.type_name()}')
		}
	}
}

pub struct InviteDeleteEvent {
	BaseEvent
pub:
	// Channel the invite is for
	channel_id Snowflake
	// Unique invite code
	code string
	// Time at which the invite was created
	created_at time.Time
	// Guild of the invite
	guild_id ?Snowflake
	// User that created the invite
	inviter ?User
	// How long the invite is valid for
	max_age time.Duration
	// Maximum number of times the invite can be used
	max_uses int
	// Type of target for this voice channel invite
	target_type ?InviteTargetType
	// User whose stream to display for this voice channel stream invite
	target_user ?User
	// Embedded application to open for this voice channel embedded application invite
	target_application ?PartialApplication
	// Whether or not the invite is temporary (invited users will be kicked on disconnect unless they're assigned a role)
	temporary bool
	// How many times the invite has been used (always will be 0)
	// uses int // not provided because it is always 0 in event
}

pub fn InviteDeleteEvent.parse(j json2.Any, base BaseEvent) !InviteDeleteEvent {
	match j {
		map[string]json2.Any {
			return InviteDeleteEvent{
				BaseEvent: base
				channel_id: Snowflake.parse(j['channel_id']!)!
				guild_id: if s := j['guild_id'] {
					Snowflake.parse(s)!
				} else {
					none
				}
				code: j['code']! as string
			}
		}
		else {
			return error('expected invite delete event to be object, got ${j.type_name()}')
		}
	}
}

pub struct MessageCreateEvent {
	BaseEvent
pub:
	message Message2
}

pub fn MessageCreateEvent.parse(j json2.Any, base BaseEvent) !MessageCreateEvent {
	return MessageCreateEvent{
		BaseEvent: base
		message: Message2.parse(j)!
	}
}

pub struct MessageUpdateEvent {
	BaseEvent
pub:
	message Message2
}

pub fn MessageUpdateEvent.parse(j json2.Any, base BaseEvent) !MessageUpdateEvent {
	return MessageUpdateEvent{
		BaseEvent: base
		message: Message2.parse(j)!
	}
}

pub struct MessageDeleteEvent {
	BaseEvent
pub:
	// ID of the message
	id Snowflake
	// ID of the channel
	channel_id Snowflake
	// ID of the guild
	guild_id ?Snowflake
}

pub fn MessageDeleteEvent.parse(j json2.Any, base BaseEvent) !MessageDeleteEvent {
	match j {
		map[string]json2.Any {
			return MessageDeleteEvent{
				BaseEvent: base
				id: Snowflake.parse(j['id']!)!
				channel_id: Snowflake.parse(j['channel_id']!)!
				guild_id: if s := j['guild_id'] {
					Snowflake.parse(s)!
				} else {
					none
				}
			}
		}
		else {
			return error('expected message delete event to be object, got ${j.type_name()}')
		}
	}
}

pub struct MessageDeleteBulkEvent {
	BaseEvent
pub:
	// IDs of the messages
	ids []Snowflake
	// ID of the channel
	channel_id Snowflake
	// ID of the guild
	guild_id ?Snowflake
}

pub fn MessageDeleteBulkEvent.parse(j json2.Any, base BaseEvent) !MessageDeleteBulkEvent {
	match j {
		map[string]json2.Any {
			return MessageDeleteBulkEvent{
				BaseEvent: base
				ids: maybe_map(j['ids']! as []json2.Any, fn (k json2.Any) !Snowflake {
					return Snowflake.parse(k)!
				})!
				channel_id: Snowflake.parse(j['channel_id']!)!
				guild_id: if s := j['guild_id'] {
					Snowflake.parse(s)!
				} else {
					none
				}
			}
		}
		else {
			return error('expected message delete bulk event to be object, got ${j.type_name()}')
		}
	}
}

pub struct InteractionCreateEvent {
	BaseEvent
pub:
	interaction Interaction
}

pub fn InteractionCreateEvent.parse(j json2.Any, base BaseEvent) !InteractionCreateEvent {
	return InteractionCreateEvent{
		BaseEvent: base
		interaction: Interaction.parse(j)!
	}
}

pub struct TypingStartEvent {
	BaseEvent
pub:
	// ID of the channel
	channel_id Snowflake
	// ID of the guild
	guild_id ?Snowflake
	// ID of the user
	user_id Snowflake
	// When the user started typing
	timestamp time.Time
	// Member who started typing if this happened in a guild
	member ?GuildMember
}

pub fn TypingStartEvent.parse(j json2.Any, base BaseEvent) !TypingStartEvent {
	match j {
		map[string]json2.Any {
			return TypingStartEvent{
				BaseEvent: base
				channel_id: Snowflake.parse(j['channel_id']!)!
				guild_id: if s := j['guild_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
				user_id: Snowflake.parse(j['user_id']!)!
				timestamp: time.unix(j['timestamp']!.i64())
				member: if o := j['member'] {
					?GuildMember(GuildMember.parse(o)!)
				} else {
					none
				}
			}
		}
		else {
			return error('expected typing start event to be object, got ${j.type_name()}')
		}
	}
}

pub struct PresenceUpdateEvent {
	BaseEvent
pub:
	presence Presence
}

pub fn PresenceUpdateEvent.parse(j json2.Any, base BaseEvent) !PresenceUpdateEvent {
	return PresenceUpdateEvent{
		BaseEvent: base
		presence: Presence.parse(j)!
	}
}

pub struct Events {
pub mut:
	on_raw_event                              EventController[DispatchEvent]
	on_ready                                  EventController[ReadyEvent]
	on_application_command_permissions_update EventController[ApplicationCommandPermissionsUpdateEvent]
	on_auto_moderation_rule_create            EventController[AutoModerationRuleCreateEvent]
	on_auto_moderation_rule_update            EventController[AutoModerationRuleUpdateEvent]
	on_auto_moderation_rule_delete            EventController[AutoModerationRuleDeleteEvent]
	on_auto_moderation_action_execution       EventController[AutoModerationActionExecutionEvent]
	on_channel_create                         EventController[ChannelCreateEvent]
	on_channel_update                         EventController[ChannelUpdateEvent]
	on_channel_delete                         EventController[ChannelDeleteEvent]
	on_thread_create                          EventController[ThreadCreateEvent]
	on_thread_update                          EventController[ThreadUpdateEvent]
	on_thread_delete                          EventController[ThreadDeleteEvent]
	on_thread_list_sync                       EventController[ThreadListSyncEvent]
	on_thread_member_update                   EventController[ThreadMemberUpdateEvent]
	on_channel_pins_update                    EventController[ChannelPinsUpdateEvent]
	on_entitlement_create                     EventController[EntitlementCreateEvent]
	on_entitlement_update                     EventController[EntitlementUpdateEvent]
	on_entitlement_delete                     EventController[EntitlementDeleteEvent]
	on_guild_create                           EventController[GuildCreateEvent]
	on_guild_update                           EventController[GuildUpdateEvent]
	on_guild_delete                           EventController[GuildDeleteEvent]
	on_guild_ban_add                          EventController[GuildBanAddEvent]
	on_guild_ban_remove                       EventController[GuildBanRemoveEvent]
	on_guild_emojis_update                    EventController[GuildEmojisUpdateEvent]
	on_guild_stickers_update                  EventController[GuildStickersUpdateEvent]
	on_guild_integrations_update              EventController[GuildIntegrationsUpdateEvent]
	on_guild_member_add                       EventController[GuildMemberAddEvent]
	on_guild_member_remove                    EventController[GuildMemberRemoveEvent]
	on_guild_member_update                    EventController[GuildMemberUpdateEvent]
	on_guild_members_chunk                    EventController[GuildMembersChunkEvent]
	on_guild_role_create                      EventController[GuildRoleCreateEvent]
	on_guild_role_update                      EventController[GuildRoleUpdateEvent]
	on_guild_role_delete                      EventController[GuildRoleDeleteEvent]
	on_guild_scheduled_event_create           EventController[GuildScheduledEventCreateEvent]
	on_guild_scheduled_event_update           EventController[GuildScheduledEventUpdateEvent]
	on_guild_scheduled_event_delete           EventController[GuildScheduledEventDeleteEvent]
	on_guild_scheduled_event_user_add         EventController[GuildScheduledEventUserAddEvent]
	on_guild_scheduled_event_user_remove      EventController[GuildScheduledEventUserRemoveEvent]
	on_integration_create                     EventController[IntegrationCreateEvent]
	on_integration_update                     EventController[IntegrationUpdateEvent]
	on_integration_delete                     EventController[IntegrationDeleteEvent]
	on_invite_create                          EventController[InviteCreateEvent]
	on_invite_delete                          EventController[InviteDeleteEvent]
	on_message_create                         EventController[MessageCreateEvent]
	on_message_update                         EventController[MessageUpdateEvent]
	on_message_delete                         EventController[MessageDeleteEvent]
	on_message_delete_bulk                    EventController[MessageDeleteBulkEvent]
	on_interaction_create                     EventController[InteractionCreateEvent]
	on_typing_start                           EventController[TypingStartEvent]
	on_presence_update                        EventController[PresenceUpdateEvent]
}

fn event_process_ready(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_ready.emit(ReadyEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_application_command_permissions_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_application_command_permissions_update.emit(ApplicationCommandPermissionsUpdateEvent.parse(data,
		BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_auto_moderation_rule_create(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_auto_moderation_rule_create.emit(AutoModerationRuleCreateEvent.parse(data,
		BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_auto_moderation_rule_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_auto_moderation_rule_update.emit(AutoModerationRuleUpdateEvent.parse(data,
		BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_auto_moderation_rule_delete(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_auto_moderation_rule_delete.emit(AutoModerationRuleDeleteEvent.parse(data,
		BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_auto_moderation_action_execution(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_auto_moderation_action_execution.emit(AutoModerationActionExecutionEvent.parse(data,
		BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_channel_create(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_channel_create.emit(ChannelCreateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_channel_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_channel_update.emit(ChannelUpdateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_channel_delete(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_channel_delete.emit(ChannelDeleteEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_thread_create(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_thread_create.emit(ThreadCreateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_thread_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_thread_update.emit(ThreadUpdateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_thread_delete(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_thread_delete.emit(ThreadDeleteEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_thread_list_sync(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_thread_list_sync.emit(ThreadListSyncEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_thread_member_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_thread_member_update.emit(ThreadMemberUpdateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_channel_pins_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_channel_pins_update.emit(ChannelPinsUpdateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_entitlement_create(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_entitlement_create.emit(EntitlementCreateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_entitlement_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_entitlement_update.emit(EntitlementUpdateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_entitlement_delete(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_entitlement_delete.emit(EntitlementDeleteEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_create(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_create.emit(GuildCreateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_update.emit(GuildUpdateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_delete(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_delete.emit(GuildDeleteEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_ban_add(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_ban_add.emit(GuildBanAddEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_ban_remove(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_ban_remove.emit(GuildBanRemoveEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_emojis_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_emojis_update.emit(GuildEmojisUpdateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_stickers_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_stickers_update.emit(GuildStickersUpdateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_integrations_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_integrations_update.emit(GuildIntegrationsUpdateEvent.parse(data,
		BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_member_add(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_member_add.emit(GuildMemberAddEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_member_remove(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_member_remove.emit(GuildMemberRemoveEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_member_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_member_update.emit(GuildMemberUpdateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_members_chunk(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_members_chunk.emit(GuildMembersChunkEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_role_create(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_role_create.emit(GuildRoleCreateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_role_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_role_update.emit(GuildRoleUpdateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_role_delete(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_role_delete.emit(GuildRoleDeleteEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_scheduled_event_create(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_scheduled_event_create.emit(GuildScheduledEventCreateEvent.parse(data,
		BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_scheduled_event_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_scheduled_event_update.emit(GuildScheduledEventUpdateEvent.parse(data,
		BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_scheduled_event_delete(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_scheduled_event_delete.emit(GuildScheduledEventDeleteEvent.parse(data,
		BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_scheduled_event_user_add(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_scheduled_event_user_add.emit(GuildScheduledEventUserAddEvent.parse(data,
		BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_scheduled_event_user_remove(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_scheduled_event_user_remove.emit(GuildScheduledEventUserRemoveEvent.parse(data,
		BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_integration_create(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_integration_create.emit(IntegrationCreateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_integration_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_integration_update.emit(IntegrationUpdateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_integration_delete(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_integration_delete.emit(IntegrationDeleteEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_invite_create(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_invite_create.emit(InviteCreateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_invite_delete(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_invite_delete.emit(InviteDeleteEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_message_create(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_message_create.emit(MessageCreateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_message_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_message_update.emit(MessageUpdateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_message_delete(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_message_delete.emit(MessageDeleteEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_message_delete_bulk(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_message_delete_bulk.emit(MessageDeleteBulkEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_interaction_create(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_interaction_create.emit(InteractionCreateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_typing_start(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_typing_start.emit(TypingStartEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_presence_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_presence_update.emit(PresenceUpdateEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

type EventsTable = map[string]fn (mut GatewayClient, json2.Any, EmitOptions) !

const events_table = EventsTable({
	'READY':                                  event_process_ready
	'APPLICATION_COMMAND_PERMISSIONS_UPDATE': event_process_application_command_permissions_update
	'AUTO_MODERATION_RULE_CREATE':            event_process_auto_moderation_rule_create
	'AUTO_MODERATION_RULE_UPDATE':            event_process_auto_moderation_rule_update
	'AUTO_MODERATION_RULE_DELETE':            event_process_auto_moderation_rule_delete
	'AUTO_MODERATION_ACTION_EXECUTION':       event_process_auto_moderation_action_execution
	'CHANNEL_CREATE':                         event_process_channel_create
	'CHANNEL_UPDATE':                         event_process_channel_update
	'CHANNEL_DELETE':                         event_process_channel_delete
	'THREAD_CREATE':                          event_process_thread_create
	'THREAD_UPDATE':                          event_process_thread_update
	'THREAD_DELETE':                          event_process_thread_delete
	'THREAD_MEMBER_UPDATE':                   event_process_thread_member_update
	'CHANNEL_PINS_UPDATE':                    event_process_channel_pins_update
	'ENTITLEMENT_CREATE':                     event_process_entitlement_create
	'ENTITLEMENT_UPDATE':                     event_process_entitlement_update
	'ENTITLEMENT_DELETE':                     event_process_entitlement_delete
	'GUILD_CREATE':                           event_process_guild_create
	'GUILD_UPDATE':                           event_process_guild_update
	'GUILD_DELETE':                           event_process_guild_delete
	'GUILD_BAN_ADD':                          event_process_guild_ban_add
	'GUILD_BAN_REMOVE':                       event_process_guild_ban_remove
	'GUILD_EMOJIS_UPDATE':                    event_process_guild_emojis_update
	'GUILD_STICKERS_UPDATE':                  event_process_guild_stickers_update
	'GUILD_INTEGRATIONS_UPDATE':              event_process_guild_integrations_update
	'GUILD_MEMBER_ADD':                       event_process_guild_member_add
	'GUILD_MEMBER_REMOVE':                    event_process_guild_member_remove
	'GUILD_MEMBER_UPDATE':                    event_process_guild_member_update
	'GUILD_MEMBERS_CHUNK':                    event_process_guild_members_chunk
	'GUILD_ROLE_CREATE':                      event_process_guild_role_create
	'GUILD_ROLE_UPDATE':                      event_process_guild_role_update
	'GUILD_ROLE_DELETE':                      event_process_guild_role_delete
	'GUILD_SCHEDULED_EVENT_CREATE':           event_process_guild_scheduled_event_create
	'GUILD_SCHEDULED_EVENT_UPDATE':           event_process_guild_scheduled_event_update
	'GUILD_SCHEDULED_EVENT_DELETE':           event_process_guild_scheduled_event_delete
	'INVITE_CREATE':                          event_process_invite_create
	'INVITE_DELETE':                          event_process_invite_delete
	'MESSAGE_CREATE':                         event_process_message_create
	'MESSAGE_UPDATE':                         event_process_message_update
	'MESSAGE_DELETE':                         event_process_message_delete
	'MESSAGE_DELETE_BULK':                    event_process_message_delete_bulk
	'INTERACTION_CREATE':                     event_process_interaction_create
	'TYPING_START':                           event_process_typing_start
	'PRESENCE_UPDATE':                        event_process_presence_update
})

pub fn (mut c GatewayClient) process_dispatch(event DispatchEvent) !bool {
	f := discord.events_table[event.name] or { return false }
	spawn fn (f fn (mut gc GatewayClient, data json2.Any, options EmitOptions) !, mut c GatewayClient, data json2.Any, error_handler fn (int, IError)) {
		f(mut c, data, error_handler: error_handler) or {}
	}(f, mut c, event.data, c.error_logger())
	return true
}
