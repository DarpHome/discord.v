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
	on_message_create                         EventController[MessageCreateEvent]
	on_interaction_create                     EventController[InteractionCreateEvent]
	on_typing_start                           EventController[TypingStartEvent]
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
		creator: gc,
	})!, options)
}

fn event_process_guild_ban_remove(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_ban_remove.emit(GuildBanRemoveEvent.parse(data, BaseEvent{
		creator: gc,
	})!, options)
}

fn event_process_guild_emojis_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_emojis_update.emit(GuildEmojisUpdateEvent.parse(data, BaseEvent{
		creator: gc,
	})!, options)
}

fn event_process_guild_stickers_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_stickers_update.emit(GuildStickersUpdateEvent.parse(data, BaseEvent{
		creator: gc,
	})!, options)
}

fn event_process_guild_integrations_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_integrations_update.emit(GuildIntegrationsUpdateEvent.parse(data, BaseEvent{
		creator: gc,
	})!, options)
}

fn event_process_guild_member_add(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_member_add.emit(GuildMemberAddEvent.parse(data, BaseEvent{
		creator: gc,
	})!, options)
}

fn event_process_guild_member_remove(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_member_remove.emit(GuildMemberRemoveEvent.parse(data, BaseEvent{
		creator: gc,
	})!, options)
}

fn event_process_guild_member_update(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_member_update.emit(GuildMemberUpdateEvent.parse(data, BaseEvent{
		creator: gc,
	})!, options)
}

fn event_process_message_create(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_message_create.emit(MessageCreateEvent.parse(data, BaseEvent{
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
	'MESSAGE_CREATE':                         event_process_message_create
	'INTERACTION_CREATE':                     event_process_interaction_create
	'TYPING_START':                           event_process_typing_start
})

pub fn (mut c GatewayClient) process_dispatch(event DispatchEvent) !bool {
	f := discord.events_table[event.name] or { return false }
	spawn fn (f fn (mut gc GatewayClient, data json2.Any, options EmitOptions) !, mut c GatewayClient, data json2.Any, error_handler fn (int, IError)) {
		f(mut c, data, error_handler: error_handler) or {}
	}(f, mut c, event.data, c.error_logger())
	return true
}
