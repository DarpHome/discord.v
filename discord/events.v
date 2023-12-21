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
	on_raw_event          EventController[DispatchEvent]
	on_ready              EventController[ReadyEvent]
	on_guild_create       EventController[GuildCreateEvent]
	on_message_create     EventController[MessageCreateEvent]
	on_interaction_create EventController[InteractionCreateEvent]
	on_typing_start       EventController[TypingStartEvent]
}

fn event_process_ready(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_ready.emit(ReadyEvent.parse(data, BaseEvent{
		creator: gc
	})!, options)
}

fn event_process_guild_create(mut gc GatewayClient, data json2.Any, options EmitOptions) ! {
	gc.events.on_guild_create.emit(GuildCreateEvent.parse(data, BaseEvent{
		creator: gc
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
	'READY':              event_process_ready
	'GUILD_CREATE':       event_process_guild_create
	'MESSAGE_CREATE':     event_process_message_create
	'INTERACTION_CREATE': event_process_interaction_create
	'TYPING_START':       event_process_typing_start
})

pub fn (mut c GatewayClient) process_dispatch(event DispatchEvent) !bool {
	f := discord.events_table[event.name] or { return false }
	f(mut c, event.data, error_handler: c.error_logger())!
	return true
}
