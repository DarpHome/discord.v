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

pub struct Events {
pub mut:
	on_raw_event    EventController[DispatchEvent]
	on_ready        EventController[ReadyEvent]
	on_guild_create EventController[GuildCreateEvent]
}

fn event_process_ready(mut gc GatewayClient, data json2.Any) ! {
	gc.events.on_ready.emit(ReadyEvent.parse(data, BaseEvent{
		creator: gc
	})!)
}

fn event_process_guild_create(mut gc GatewayClient, data json2.Any) ! {
	gc.events.on_guild_create.emit(GuildCreateEvent.parse(data, BaseEvent{
		creator: gc
	})!)
}

type EventsTable = map[string]fn (mut GatewayClient, json2.Any) !

const events_table = EventsTable({
	'READY':        event_process_ready
	'GUILD_CREATE': event_process_guild_create
})

pub fn (mut c GatewayClient) process_dispatch(event DispatchEvent) !bool {
	f := discord.events_table[event.name] or { return false }
	f(mut c, event.data)!
	return true
}
