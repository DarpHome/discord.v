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

pub struct VoiceRegion {
pub:
	// unique ID for the region
	id string
	// name of the region
	name string
	// true for a single server that is closest to the current user's client
	optimal bool
	// whether this is a deprecated voice region (avoid switching to these)
	deprecated bool
	// whether this is a custom voice region (used for events/etc)
	custom bool
}

pub fn VoiceRegion.parse(j json2.Any) !VoiceRegion {
	match j {
		map[string]json2.Any {
			return VoiceRegion{
				id: j['id']! as string
				name: j['name']! as string
				optimal: j['optimal']! as bool
				deprecated: j['deprecated']! as bool
				custom: j['custom']! as bool
			}
		}
		else {
			return error('expected voice region to be object, got ${j.type_name()}')
		}
	}
}

// Returns an array of voice region objects that can be used when setting a voice or stage channel's `rtc_region`.
pub fn (c Client) list_voice_regions() ![]VoiceRegion {
	return maybe_map(json2.raw_decode(c.request(.get, '/voice/regions')!.body)! as []json2.Any,
		fn (j json2.Any) !VoiceRegion {
		return VoiceRegion.parse(j)!
	})!
}
