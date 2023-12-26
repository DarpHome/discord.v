module discord

import arrays
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

pub fn (i Interaction) get_user() User {
	if u := i.user {
		return u
	}
	return i.member or { GuildMember{} }.user or { panic('corrupted interaction') }
}

pub type ApplicationCommandInteractionDataOptionValue = bool | f64 | int | string

pub fn ApplicationCommandInteractionDataOptionValue.parse(j json2.Any) !ApplicationCommandInteractionDataOptionValue {
	match j {
		string {
			return j
		}
		i8, i16, int, i64, u8, u16, u32, u64 {
			return int(j)
		}
		f32, f64 {
			return f64(j)
		}
		bool {
			return j
		}
		else {
			return error('expected application command interaction data option value to be string/int/f64/bool, got ${j.type_name()}')
		}
	}
}

pub fn (v ApplicationCommandInteractionDataOptionValue) as_string() string {
	match v {
		string {
			return v
		}
		else {
			return ''
		}
	}
}

pub fn (v ApplicationCommandInteractionDataOptionValue) as_int() int {
	match v {
		int {
			return v
		}
		else {
			return 0
		}
	}
}

pub fn (v ApplicationCommandInteractionDataOptionValue) as_f64() f64 {
	match v {
		int {
			return v
		}
		else {
			return 0.0
		}
	}
}

pub fn (v ApplicationCommandInteractionDataOptionValue) as_bool() bool {
	match v {
		bool {
			return v
		}
		else {
			return false
		}
	}
}

pub struct ApplicationCommandInteractionDataOption {
pub:
	// Name of the parameter
	name string
	// Value of application command option type
	typ ApplicationCommandOptionType
	// Value of the option resulting from user input
	value ?ApplicationCommandInteractionDataOptionValue
	// Present if this option is a group or subcommand
	options ?[]ApplicationCommandInteractionDataOption
	// true if this option is the currently focused option for autocomplete
	focused ?bool
}

pub fn ApplicationCommandInteractionDataOption.parse(j json2.Any) !ApplicationCommandInteractionDataOption {
	match j {
		map[string]json2.Any {
			return ApplicationCommandInteractionDataOption{
				name: j['name']! as string
				typ: unsafe { ApplicationCommandOptionType(j['type']!.int()) }
				value: if v := j['value'] {
					?ApplicationCommandInteractionDataOptionValue(ApplicationCommandInteractionDataOptionValue.parse(v)!)
				} else {
					none
				}
				options: if a := j['options'] {
					?[]ApplicationCommandInteractionDataOption(maybe_map[json2.Any, ApplicationCommandInteractionDataOption](a as []json2.Any,
						fn (o json2.Any) !ApplicationCommandInteractionDataOption {
						return ApplicationCommandInteractionDataOption.parse(o)!
					})!)
				} else {
					none
				}
				focused: if b := j['focused'] {
					?bool(b as bool)
				} else {
					none
				}
			}
		}
		else {
			return error('expected application command interaction data option to be object, got ${j.type_name()}')
		}
	}
}

pub struct ApplicationCommandData {
pub:
	// the ID of the invoked command
	id Snowflake
	// the name of the invoked command
	name string
	// the type of the invoked command
	typ ApplicationCommandType
	// converted users + roles + channels + attachments
	resolved ?Resolved
	// the params + values from the user
	options ?[]ApplicationCommandInteractionDataOption
	// the id of the guild the command is registered to
	guild_id ?Snowflake
	// id of the user or message targeted by a user or message command
	target_id ?Snowflake
}

pub fn ApplicationCommandData.parse(j json2.Any) !ApplicationCommandData {
	match j {
		map[string]json2.Any {
			return ApplicationCommandData{
				id: Snowflake.parse(j['id']!)!
				name: j['name']! as string
				typ: unsafe { ApplicationCommandType(j['type']!.int()) }
				resolved: if o := j['resolved'] {
					?Resolved(Resolved.parse(o)!)
				} else {
					none
				}
				options: if a := j['options'] {
					?[]ApplicationCommandInteractionDataOption(maybe_map[json2.Any, ApplicationCommandInteractionDataOption](a as []json2.Any,
						fn (o json2.Any) !ApplicationCommandInteractionDataOption {
						return ApplicationCommandInteractionDataOption.parse(o)!
					})!)
				} else {
					none
				}
				guild_id: if s := j['guild_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
				target_id: if s := j['target_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
			}
		}
		else {
			return error('expected application command data to be object, got ${j.type_name()}')
		}
	}
}

pub fn (acd ApplicationCommandData) get(option string) ?ApplicationCommandInteractionDataOptionValue {
	if opts := acd.options {
		for opt in opts {
			if opt.name == option {
				return opt.value
			}
		}
	}
	return none
}

pub fn (i Interaction) get_application_command_data() !ApplicationCommandData {
	return ApplicationCommandData.parse(i.data or { return error('no data') })!
}

pub struct MessageComponentData {
pub:
	// the custom_id of the component
	custom_id string
	// the type of the component
	component_type ComponentType
	// values the user selected in a select menu component
	values ?[]string
	// resolved entities from selected options
	resolved ?Resolved
}

pub fn MessageComponentData.parse(j json2.Any) !MessageComponentData {
	match j {
		map[string]json2.Any {
			return MessageComponentData{
				custom_id: j['custom_id']! as string
				component_type: unsafe { ComponentType(j['component_type']!.int()) }
				values: if a := j['values'] {
					?[]string((a as []json2.Any).map(|s| s as string))
				} else {
					none
				}
				resolved: if o := j['resolved'] {
					?Resolved(Resolved.parse(o)!)
				} else {
					none
				}
			}
		}
		else {
			return error('expected message component data to be object, got ${j.type_name()}')
		}
	}
}

pub fn (i Interaction) get_message_component_data() !MessageComponentData {
	return MessageComponentData.parse(i.data or { return error('no data') })!
}

pub struct ModalSubmitData {
pub:
	// the custom_id of the modal
	custom_id string
	// the values submitted by the user
	components []Component
}

pub fn ModalSubmitData.parse(j json2.Any) !ModalSubmitData {
	match j {
		map[string]json2.Any {
			return ModalSubmitData{
				custom_id: j['custom_id']! as string
				components: maybe_map[json2.Any, Component](j['components']! as []json2.Any,
					fn (o json2.Any) !Component {
					return Component.parse(o)!
				})!
			}
		}
		else {
			return error('expected modal submit data to be object, got ${j.type_name()}')
		}
	}
}

pub fn (msd ModalSubmitData) get(custom_id string) ?string {
	println('what')
	for c in msd.components {
		println('a')
		if c is ActionRow {
			println('b')
			dump(voidptr(c))
			dump(voidptr(c.components.data))
			for d in c.components {
				println('c')
				if d is TextInput {
					println('d')
					if d.custom_id == custom_id {
						println('e')
						return d.value
					}
				}
			}
		}
	}
	return none
}

pub fn (i Interaction) get_modal_submit_data() !ModalSubmitData {
	return ModalSubmitData.parse(i.data or { return error('no data') })!
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
	get_files() ?[]File
	build() json2.Any
}

pub struct MessageResponseData {
pub:
	// is the response TTS
	tts ?bool
	// message content
	content ?string
	// supports up to 10 embeds
	embeds ?[]Embed
	// allowed mentions object
	allowed_mentions ?AllowedMentions
	// message flags combined as a bitfield (only SUPPRESS_EMBEDS and EPHEMERAL can be set)
	flags ?MessageFlags
	// message components
	components ?[]Component
	// uploaded files
	files ?[]File
}

pub fn (_ MessageResponseData) is_interaction_response_data() {}

pub fn (mrd MessageResponseData) get_files() ?[]File {
	return mrd.files
}

pub fn (mrd MessageResponseData) build() json2.Any {
	mut r := map[string]json2.Any{}
	if tts := mrd.tts {
		r['tts'] = tts
	}
	if content := mrd.content {
		r['content'] = content
	}
	if embeds := mrd.embeds {
		r['embeds'] = embeds.map(|e| e.build())
	}
	if allowed_mentions := mrd.allowed_mentions {
		r['allowed_mentions'] = allowed_mentions.build()
	}
	if flags := mrd.flags {
		r['flags'] = int(flags)
	}
	if components := mrd.components {
		r['components'] = components.map(|c| c.build())
	}
	if files := mrd.files {
		r['attachments'] = arrays.map_indexed(files, fn (i int, f File) json2.Any {
			return f.build(i)
		})
	}
	return r
}

pub struct AutocompleteResponseData {
pub:
	// autocomplete choices (max of 25 choices)
	choices []ApplicationCommandOptionChoice
}

pub fn (_ AutocompleteResponseData) is_interaction_response_data() {}

pub fn (_ AutocompleteResponseData) get_files() ?[]File {
	return none
}

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

pub fn (_ ModalResponseData) get_files() ?[]File {
	return none
}

pub fn (mrd ModalResponseData) build() json2.Any {
	return {
		'custom_id':  json2.Any(mrd.custom_id)
		'title':      mrd.title
		'components': mrd.components.map(|component| component.build())
	}
}

pub interface IInteractionResponse {
	is_interaction_response()
	get_files() ?[]File
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

pub fn (ir InteractionResponse) get_files() ?[]File {
	if d := ir.data {
		return d.get_files()
	}
	return none
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

pub struct MessageInteractionResponse {
	MessageResponseData
}

fn (_ MessageInteractionResponse) is_interaction_response() {}

pub fn (r MessageInteractionResponse) get_files() ?[]File {
	return r.files
}

pub fn (mir MessageInteractionResponse) build() json2.Any {
	return {
		'type': json2.Any(int(InteractionResponseType.channel_message_with_source))
		'data': mir.MessageResponseData.build()
	}
}

pub struct UpdateMessageInteractionResponse {
	MessageResponseData
}

fn (_ UpdateMessageInteractionResponse) is_interaction_response() {}

pub fn (r UpdateMessageInteractionResponse) get_files() ?[]File {
	return r.files
}

pub fn (umir UpdateMessageInteractionResponse) build() json2.Any {
	return {
		'type': json2.Any(int(InteractionResponseType.update_message))
		'data': umir.MessageResponseData.build()
	}
}

pub struct AutocompleteInteractionResponse {
pub:
	// autocomplete choices (max of 25 choices)
	choices []ApplicationCommandOptionChoice
}

fn (_ AutocompleteInteractionResponse) is_interaction_response() {}

pub fn (_ AutocompleteInteractionResponse) get_files() ?[]File {
	return none
}

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

pub fn (_ ModalInteractionResponse) get_files() ?[]File {
	return none
}

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
	if files := response.get_files() {
		body, boundary := build_multipart_with_files(files, response.build())
		c.request(.post, '/interactions/${urllib.path_escape(interaction_id.build())}/${urllib.path_escape(interaction_token)}/callback',
			body: body
			common_headers: {
				.content_type: 'multipart/form-data; boundary="${boundary}"'
			}
			authenticate: false
		)!
	} else {
		c.request(.post, '/interactions/${urllib.path_escape(interaction_id.build())}/${urllib.path_escape(interaction_token)}/callback',
			json: response.build()
			authenticate: false
		)!
	}
}
