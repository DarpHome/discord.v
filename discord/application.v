module discord

import x.json2

@[flag]
pub enum ApplicationFlags {
	reserved_0
	reserved_1
	reserved_2
	reserved_3
	reserved_4
	reserved_5
	// Indicates if an app uses the Auto Moderation API
	application_auto_moderation_rule_create_badge
	reserved_7
	reserved_8
	reserved_9
	reserved_10
	reserved_11
	// Intent required for bots in **100 or more servers** to receive `presence_update` events
	gateway_presence
	// Intent required for bots in under 100 to receive `presence_update` events, found on the **Bot** page in your app's settings
	gateway_presence_limited
	// Intent required for bots in **100 or more servers** to receive member-related events like `guild_member_add`. See the list of member-related events under `GUILD_MEMBERS`
	gateway_guild_members
	// Intent required for bots in under 100 servers to receive member-related events like `guild_member_add`, found on the **Bot** page in your app's settings. See the list of member-related events under GUILD_MEMBERS
	gateway_guild_members_limited
	// Indicates unusual growth of an app that prevents verification
	verification_pending_guild_limit
	// Indicates if an app is embedded within the Discord client (currently unavailable publicly)
	embedded
	// Intent required for bots in **100 or more servers** to receive message content
	gateway_message_content
	// Intent required for bots in under 100 servers to receive message content, found on the **Bot** page in your app's settings
	gateway_message_content_limited
	reserved_20
	reserved_21
	reserved_22
	// Indicates if an app has registered global application commands
	application_command_badge
}

pub struct PartialApplication {
pub:
	id    Snowflake
	flags ApplicationFlags
}

pub fn PartialApplication.parse(j json2.Any) !PartialApplication {
	match j {
		map[string]json2.Any {
			return PartialApplication{
				id: Snowflake.parse(j['id']!)!
				flags: unsafe { ApplicationFlags(j['flags']! as i64) }
			}
		}
		else {
			return error('expected partial application to be object, got ${j.type_name()}')
		}
	}
}
