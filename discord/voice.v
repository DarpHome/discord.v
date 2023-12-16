module discord

import x.json2

@[params]
pub struct VoiceStateUpdate {
pub:
	// ID of the guild
	guild_id Snowflake
	// ID of the voice channel client wants to join (null if disconnecting)
	channel_id ?Snowflake
	// Whether the client is muted
	self_mute bool
	// Whether the client deafened
	self_deaf bool
}

pub fn (vsu VoiceStateUpdate) build() json2.Any {
	return {
		'guild_id':   json2.Any(vsu.guild_id.build())
		'channel_id': if s := vsu.channel_id {
			json2.Any(s.build())
		} else {
			json2.Null{}
		}
		'self_mute':  vsu.self_mute
		'self_deaf':  vsu.self_deaf
	}
}

pub fn (mut gc GatewayClient) update_voice_state(params VoiceStateUpdate) ! {
	gc.send(WSMessage{
		opcode: .voice_state_update
		data: params.build()
	})!
}
