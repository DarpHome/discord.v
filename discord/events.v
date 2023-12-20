module discord

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
	message Message
}

pub fn MessageCreateEvent.parse(j json2.Any, base BaseEvent) !MessageCreateEvent {
	return MessageCreateEvent{
		BaseEvent: base
		message: Message.parse(j)!
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

pub struct Events {
pub mut:
	on_raw_event          EventController[DispatchEvent]
	on_ready              EventController[ReadyEvent]
	on_guild_create       EventController[GuildCreateEvent]
	on_message_create     EventController[MessageCreateEvent]
	on_interaction_create EventController[InteractionCreateEvent]
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

type EventsTable = map[string]fn (mut GatewayClient, json2.Any, EmitOptions) !

const events_table = EventsTable({
	'READY':              event_process_ready
	'GUILD_CREATE':       event_process_guild_create
	'MESSAGE_CREATE':     event_process_message_create
	'INTERACTION_CREATE': event_process_interaction_create
})

pub fn (mut c GatewayClient) process_dispatch(event DispatchEvent) !bool {
	f := discord.events_table[event.name] or { return false }
	f(mut c, event.data, error_handler: c.error_logger())!
	return true
}
