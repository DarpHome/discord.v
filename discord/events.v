module discord

import x.json2

pub struct BaseEvent {
pub mut:
	creator &GatewayClient
}

pub struct DispatchEvent {
	BaseEvent
pub:
	name    string
	data    json2.Any
}

pub struct Events {
pub mut:
	on_raw_event EventController[DispatchEvent]
	on_ready_event EventController[ReadyEvent]
}

fn event_process_ready(mut gc &GatewayClient, data json2.Any) ! {
	gc.events.on_ready_event.emit(ReadyEvent.parse(data, BaseEvent{
		creator: gc
	})!)
}

type EventsTable = map[string]fn (mut &GatewayClient, json2.Any) !

const events_table = EventsTable({
	'READY': event_process_ready
})

pub fn (mut c GatewayClient) process_dispatch(event DispatchEvent) ! {
	f := events_table[event.name] or { return }
	f(mut c, event.data)!
}