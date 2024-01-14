module discord

import net.websocket
import x.json2

pub enum WSMessageOpcode {
	// An event was dispatched.
	dispatch              = 0
	// Fired periodically by the client to keep the connection alive.
	heartbeat
	// Starts a new session during the initial handshake.
	identify
	// Update the client's presence.
	update_presence
	// Used to join/leave or move between voice channels.
	voice_state_update
	// Resume a previous session that was disconnected.
	resume                = 6
	// You should attempt to reconnect and resume immediately.
	reconnect
	// Request information about offline guild members in a large guild.
	request_guild_members
	// The session has been invalidated. You should reconnect and identify/resume accordingly.
	invalid_session
	// Sent immediately after connecting, contains the `heartbeat_interval` to use.
	hello
	// Sent in response to receiving a heartbeat to acknowledge that it has been received.
	heartbeat_ack
}

pub struct WSMessage {
pub:
	opcode WSMessageOpcode
	data   json2.Any
	seq    ?int
	event  string
}

fn decode_message(j json2.Any) !WSMessage {
	$if trace ? {
		eprintln('Gateway < ${j}')
	}
	if j !is map[string]json2.Any {
		return error('expected object')
	}
	mut opcode := 0
	m := j.as_map()
	if op := m['op'] {
		match op {
			i64 { opcode = int(op) }
			else { return error('opcode is not in message') }
		}
	} else {
		return error('no op')
	}
	mut seq := ?int(none)
	if s := m['s'] {
		match s {
			json2.Null {}
			i64 { seq = int(s) }
			else { return error('seq is not int') }
		}
	}
	mut event := ''
	if t := m['t'] {
		match t {
			json2.Null {}
			string { event = t }
			else { return error('event is not string') }
		}
	}
	mut data := json2.Any(json2.Null{})
	if d := m['d'] {
		data = d
	}
	return WSMessage{
		opcode: unsafe { WSMessageOpcode(opcode) }
		data: data
		seq: seq
		event: event
	}
}

fn encode_message(message WSMessage) !json2.Any {
	return {
		'op': json2.Any(int(message.opcode))
		'd':  message.data
	}
}

fn decode_websocket_message(message websocket.Message) !WSMessage {
	return decode_message(json2.raw_decode(message.payload.bytestr())!)!
}

fn ws_recv_message(mut client websocket.Client) !WSMessage {
	return decode_websocket_message(client.read_next_message()!)!
}

fn ws_send_message(mut client websocket.Client, message WSMessage) ! {
	payload := encode_message(message)!.json_str()
	$if trace ? {
		eprintln('Gateway > ${payload}')
	}
	client.write(payload.bytes(), websocket.OPCode.text_frame)!
}
