module discord

import x.json2

pub enum InteractionType {
	ping                             = 1
	application_command              = 2
	message_component                = 3
	application_command_autocomplete = 4
	modal_submit                     = 5
}

pub struct Interaction {
pub:
	id             Snowflake
	application_id Snowflake
	typ            InteractionType
	data           json2.Any
	guild_id       ?Snowflake
	// channel ?Channel
	channel_id ?Snowflake
	// member ?GuildMember
	user  ?User
	token string
	// message Message
	app_permissions ?Permissions
	locale          ?string
	guild_locale    ?string
	// entitlements []Entitlement
}

pub fn Interaction.parse(j json2.Any) !Interaction {
	// TODO: implement this
	panic('TODO')
}

pub struct InteractionCreateEvent {
pub:
	interaction Interaction
}
