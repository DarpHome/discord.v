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
	id              Snowflake
	application_id  Snowflake
	typ             InteractionType
	data            ?json2.Any
	guild_id        ?Snowflake
	channel         ?PartialChannel
	channel_id      ?Snowflake
	member          ?GuildMember
	user            ?User
	token           string
	message         ?Message
	app_permissions ?Permissions
	locale          ?Locale
	guild_locale    ?Locale
	entitlements    []Entitlement
}

pub fn Interaction.parse(j json2.Any) !Interaction {
	match j {
		map[string]json2.Any {
			return Interaction{
				id: Snowflake.parse(j['id']!)!
				application_id: Snowflake.parse(j['application_id']!)!
				typ: unsafe { InteractionType(j['type']!.int()) }
				data: if o := j['data'] {
					?json2.Any(o)
				} else {
					none
				}
				guild_id: if s := j['guild_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
				channel: if o := j['channel'] {
					?PartialChannel(PartialChannel.parse(o)!)
				} else {
					none
				}
				channel_id: if s := j['channel_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
				member: if o := j['member'] {
					?GuildMember(GuildMember.parse(o)!)
				} else {
					none
				}
				user: if o := j['user'] {
					?User(User.parse(o)!)
				} else {
					none
				}
				token: j['token']! as string
				app_permissions: if s := j['app_permissions'] {
					?Permissions(Permissions.parse(s)!)
				} else {
					none
				}
				locale: if s := j['locale'] {
					?Locale(s as string)
				} else {
					none
				}
				guild_locale: if s := j['guild_locale'] {
					?Locale(s as string)
				} else {
					none
				}
				entitlements: (j['entitlements']! as []json2.Any).map(Entitlement.parse(it)!)
			}
		}
		else {
			return error('expected interaction to be object, got ${j.type_name()}')
		}
	}
}

pub enum InteractionResponseType {
	// ACK a `Ping`
	pong                                    = 1
	// respond to an interaction with a message
	channel_message_with_source             = 4
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

pub struct AutocompleteResponseData {
pub:
	// autocomplete choices (max of 25 choices)
	choices []ApplicationCommandOptionChoice
}

pub fn (_ AutocompleteResponseData) is_interaction_response_data() {}

pub fn (ard AutocompleteResponseData) build() json2.Any {
	return {
		'choices': json2.Any(ard.choices.map(|choice| choice.build()))
	}
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
		'custom_id':  json2.Any(mrd.custom_id)
		'title':      mrd.title
		'components': mrd.components.map(|component| component.build())
	}
}

pub interface IInteractionResponse {
	is_interaction_response()
	build() json2.Any
}

pub struct InteractionResponse {
pub:
	// the type of response
	typ InteractionResponseType
	// an optional response message
	data ?InteractionResponseData
}

fn (_ InteractionResponse) is_interaction_response() {}

pub fn (ir InteractionResponse) build() json2.Any {
	mut r := {
		'type': json2.Any(int(ir.typ))
	}
	if d := ir.data {
		r['data'] = d.build()
	}
	return r
}



pub struct AutocompleteInteractionResponse {
pub:
	// autocomplete choices (max of 25 choices)
	choices []ApplicationCommandOptionChoice
}

fn (_ AutocompleteInteractionResponse) is_interaction_response() {}

pub fn (air AutocompleteInteractionResponse) build() json2.Any {
	return {
		'type': json2.Any(int(InteractionResponseType.application_command_autocomplete_result))
		'data': {
			'choices': json2.Any(air.choices.map(|choice| choice.build()))
		}
	}
}

pub struct ModalInteractionResponse {
pub:
	// a developer-defined identifier for the modal, max 100 characters
	custom_id string
	// the title of the popup modal, max 45 characters
	title string
	// between 1 and 5 (inclusive) components that make up the modal
	components []Component
}

fn (_ ModalInteractionResponse) is_interaction_response() {}

pub fn (mir ModalInteractionResponse) build() json2.Any {
	return {
		'type': json2.Any(int(InteractionResponseType.modal))
		'data': {
			'custom_id':  json2.Any(mir.custom_id)
			'title':      mir.title
			'components': mir.components.map(|component| component.build())
		}
	}
}

pub fn (c Client) create_interaction_response(interaction_id Snowflake, interaction_token string, response IInteractionResponse) ! {
	c.request(.post, '/interactions/${urllib.path_escape(interaction_id.build())}/${urllib.path_escape(interaction_token)}/callback',
		json: response.build()
	)!
}