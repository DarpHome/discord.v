module discord

import x.json2
import net.urllib

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
	member ?GuildMember
	user  ?User
	token string
	// message ?Message
	app_permissions ?Permissions
	locale          ?string
	guild_locale    ?string
	entitlements []Entitlement
}

pub fn Interaction.parse(j json2.Any) !Interaction {
	// TODO: implement this
	panic('TODO')
}

pub enum InteractionResponseType {
	// ACK a `Ping`
	pong = 1
	// respond to an interaction with a message
	channel_message_with_source = 4
	// ACK an interaction and edit a response later, the user sees a loading state
	deferred_channel_message_with_source
	// for components, ACK an interaction and edit the original message later; the user does not see a loading state
	deferred_update_message
	// for components, edit the message the component was attached to
	update_message
	// respond to an autocomplete interaction with suggested choices
	application_command_autocomplete_result
	// respond to an interaction with a popup modal
	modal
	// respond to an interaction with an upgrade button, only available for apps with monetization enabled
	premium_required
}

pub interface InteractionResponseData {
	is_interaction_response_data()
	build() json2.Any
}

pub struct ModalResponseData {
pub:
	// a developer-defined identifier for the modal, max 100 characters
	custom_id string
	// the title of the popup modal, max 45 characters
	title string
	// between 1 and 5 (inclusive) components that make up the modal
	components []Component
}

pub fn (_ ModalResponseData) is_interaction_response_data() {}
pub fn (mrd ModalResponseData) build() json2.Any {
	return {
		'custom_id': json2.Any(mrd.custom_id)
		'title': mrd.title
		'components': mrd.components.map(it.build())
	}
}

pub struct InteractionResponse {
pub:
	// the type of response
	typ InteractionResponseType
	// an optional response message
	data ?InteractionResponseData
}

pub fn (ir InteractionResponse) build() json2.Any {
	mut r := {
		'type': json2.Any(int(ir.typ))
	}
	if d := ir.data {
		r['data'] = d.build()
	}
	return r
}

pub fn (c Client) create_interaction_response(interaction_id Snowflake, interaction_token string, response InteractionResponse) ! {
	c.request(
		.post,
		'/interactions/${urllib.path_escape(interaction_id.build())}/${urllib.path_escape(interaction_token)}/callback',
		json: response.build()
	)!
}

pub struct InteractionCreateEvent {
pub:
	interaction Interaction
}
