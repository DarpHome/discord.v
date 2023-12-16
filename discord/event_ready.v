module discord

import x.json2

pub struct UnavailableGuild {
pub:
	id          Snowflake
	unavailable bool
}

pub fn UnavailableGuild.parse(j json2.Any) !UnavailableGuild {
	match j {
		map[string]json2.Any {
			return UnavailableGuild{
				id: Snowflake.parse(j['id']!)!
				unavailable: j['unavailable']! as bool
			}
		}
		else {
			return error('expected unavailable guild to be object')
		}
	}
}

pub struct ReadyEvent {
	BaseEvent
pub:
	user               User
	guilds             []UnavailableGuild
	session_id         string
	resume_gateway_url string
	application        PartialApplication
}

pub fn ReadyEvent.parse(j json2.Any, base BaseEvent) !ReadyEvent {
	match j {
		map[string]json2.Any {
			return ReadyEvent{
				BaseEvent: base
				user: User.parse(j['user']!)!
				guilds: (j['guilds']! as []json2.Any).map(UnavailableGuild.parse(it)!)
				session_id: j['session_id']! as string
				resume_gateway_url: j['resume_gateway_url']! as string
				application: PartialApplication.parse(j['application']!)!
			}
		}
		else {
			return error('expected ready event to be object, got ${j.type_name()}')
		}
	}
}
