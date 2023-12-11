module discord

import maps
import net.urllib
import x.json2

pub enum ApplicationCommandType {
	// Slash commands; a text-based command that shows up when a user types `/`
	chat_input = 1
	// A UI-based command that shows up when you right click or tap on a user
	user
	// A UI-based command that shows up when you right click or tap on a message
	message
}

pub type Locale = string

// Indonesian (Bahasa Indonesia)
pub const locale_id = Locale('id')

// Danish (Dansk)
pub const locale_da = Locale('da')

// German (Deutsch)
pub const locale_de = Locale('de')

// English, UK (English, UK)
pub const locale_en_gb = Locale('en-GB')

// English, US (English, US)
pub const locale_en_us = Locale('en-US')

// Spanish (Español)
pub const locale_es_es = Locale('es-ES')

// French (Français)
pub const locale_fr = Locale('fr')

// Croatian (Hrvatski)
pub const locale_hr = Locale('hr')

// Italian (Italiano)
pub const locale_it = Locale('it')

// Lithuanian (Lietuviškai)
pub const locale_lt = Locale('lt')

// Hungarian (Magyar)
pub const locale_hu = Locale('hu')

// Dutch (Nederlands)
pub const locale_nl = Locale('nl')

// Norweigan (Norsk)
pub const locale_no = Locale('no')

// Polish (Polski)
pub const locale_pl = Locale('pl')

// Portuguese, Brazilian (Português do Brasil)
pub const locale_pt_br = Locale('pt-BR')

// Romanian, Romania (Română)
pub const locale_ro = Locale('ro')

// Finnish (Suomi)
pub const locale_fi = Locale('fi')

// Swedish (Svenska)
pub const locale_sv_se = Locale('sv-SE')

// Vietnamese (Tiếng Việt)
pub const locale_vi = Locale('vi')

// Turkish (Türkçe)
pub const locale_tr = Locale('tr')

// Czech (Čeština)
pub const locale_cs = Locale('cs')

// Greek (Ελληνικά)
pub const locale_el = Locale('el')

// Bulgarian (български)
pub const locale_bg = Locale('bg')

// Russian (Pусский)
pub const locale_ru = Locale('ru')

// Ukrainian (Українська)
pub const locale_uk = Locale('uk')

// Hindi (हिन्दी)
pub const locale_hi = Locale('hi')

// Thai (ไทย)
pub const locale_th = Locale('th')

// Chinese, China (中文)
pub const locale_zh_cn = Locale('zh-CN')

// Japanese (日本語)
pub const locale_ja = Locale('ja')

// Chinese, Taiwan (繁體中文)
pub const locale_zh_tw = Locale('zh-TW')

// Korean (한국어)
pub const locale_ko = Locale('ko')

pub enum ApplicationCommandOptionType {
	sub_command
	sub_command_group
	string_
	// Any integer between -2^53 and 2^53
	integer
	boolean
	user
	// Includes all channel types + categories
	channel
	role
	// Includes users and roles
	mentionable
	// Any double between -2^53 and 2^53
	number
	attachment
}

pub type ApplicationCommandOptionChoiceValue = f64 | int | string

pub struct ApplicationCommandOptionChoice {
pub:
	// 1-100 character choice name
	name string
	// Localization dictionary for the `name` field. Values follow the same restrictions as `name`
	name_localizations ?map[Locale]string
	// Value for the choice, up to 100 characters if string
	value ApplicationCommandOptionChoiceValue
}

pub fn ApplicationCommandOptionChoice.parse(j json2.Any) !ApplicationCommandOptionChoice {
	match j {
		map[string]json2.Any {
			value := j['value']!
			return ApplicationCommandOptionChoice{
				name: j['name']! as string
				name_localizations: if m := j['name_localizations'] {
					maps.to_map[string, json2.Any, Locale, string](m as map[string]json2.Any,
						fn (k string, v json2.Any) (Locale, string) {
						return k, v as string
					})
					// as map[Locale]string
					// i was trying to fix
				} else {
					none
				}
				value: match value {
					string {
						ApplicationCommandOptionChoiceValue(value)
					}
					i64 {
						ApplicationCommandOptionChoiceValue(int(value))
					}
					f64 {
						ApplicationCommandOptionChoiceValue(value)
					}
					else {
						return error('expected application command option choice value to be string/i64/f64, got ${value.type_name()}')
					}
				}
			}
		}
		else {
			return error('expected application command option choice to be object, got ${j.type_name()}')
		}
	}
}

pub fn (acoc ApplicationCommandOptionChoice) build() json2.Any {
	mut r := {
		'name':  json2.Any(acoc.name)
		'value': match acoc.value {
			string { json2.Any(acoc.value) }
			int { json2.Any(acoc.value) }
			f64 { json2.Any(acoc.value) }
		}
	}
	if name_localizations := acoc.name_localizations {
		r['name_localizations'] = maps.to_map[Locale, string, string, json2.Any](name_localizations,
			fn (k Locale, v string) (string, json2.Any) {
			return k, v
		})
	}
	return r
}

pub struct ApplicationCommandOption {
pub:
	// Type of option
	typ ApplicationCommandOptionType
	// 1-32 character name
	name string
	// Localization dictionary for the `name` field. Values follow the same restrictions as `name`
	name_localizations ?map[Locale]string
	// 1-100 character description
	description string
	// Localization dictionary for the `description` field. Values follow the same restrictions as `description`
	description_localizations ?map[Locale]string
	// If the parameter is required or optional--default `false`
	required ?bool
	// Choices for `.string_`, `.integer`, and `.number` types for the user to pick from, max 25
	choices ?[]ApplicationCommandOptionChoice
	// If the option is a subcommand or subcommand group type, these nested options will be the parameters
	options ?[]ApplicationCommandOption
	// If the option is a channel type, the channels shown will be restricted to these types
	channel_types ?[]ChannelType
	// If the option is an `.integer` or `.number` type, the minimum value permitted
	min_value ?int
	// If the option is an `.integer` or `.number` type, the maximum value permitted
	max_value ?int
	// For option type `.string_`, the minimum allowed length (minimum of `0`, maximum of `6000`)
	min_length ?int
	// For option type `.string_`, the maximum allowed length (minimum of `1`, maximum of `6000`)
	max_length ?int
	// If autocomplete interactions are enabled for this `.string_`, `.integer`, or `.number` type option
	autocomplete ?bool
}

pub fn ApplicationCommandOption.parse(j json2.Any) !ApplicationCommandOption {
	match j {
		map[string]json2.Any {
			return ApplicationCommandOption{
				typ: unsafe { ApplicationCommandOptionType(j['type']! as i64) }
				name: j['name']! as string
				name_localizations: if m := j['name_localizations'] {
					if m !is json2.Null {
						maps.to_map[string, json2.Any, Locale, string](m as map[string]json2.Any,
							fn (k string, v json2.Any) (Locale, string) {
							return k, v as string
						})
					} else {
						none
					}
				} else {
					none
				}
				description: j['description']! as string
				description_localizations: if m := j['description_localizations'] {
					if m !is json2.Null {
						maps.to_map[string, json2.Any, Locale, string](m as map[string]json2.Any,
							fn (k string, v json2.Any) (Locale, string) {
							return k, v as string
						})
					} else {
						none
					}
				} else {
					none
				}
				required: if b := j['required'] {
					?bool(b as bool)
				} else {
					none
				}
				choices: if a := j['choices'] {
					?[]ApplicationCommandOptionChoice((a as []json2.Any).map(ApplicationCommandOptionChoice.parse(it)!))
				} else {
					none
				}
				options: if a := j['options'] {
					?[]ApplicationCommandOption((a as []json2.Any).map(ApplicationCommandOption.parse(it)!))
				} else {
					none
				}
				channel_types: if a := j['channel_types'] {
					?[]ChannelType((a as []json2.Any).map(unsafe { ChannelType(it as i64) }))
				} else {
					none
				}
				min_value: if i := j['min_value'] {
					?int(i as i64)
				} else {
					none
				}
				max_value: if i := j['max_value'] {
					?int(i as i64)
				} else {
					none
				}
				min_length: if i := j['min_length'] {
					?int(i as i64)
				} else {
					none
				}
				max_length: if i := j['max_length'] {
					?int(i as i64)
				} else {
					none
				}
				autocomplete: if b := j['autocomplete'] {
					?bool(b as bool)
				} else {
					none
				}
			}
		}
		else {
			return error('expceted application command option to be object, got ${j.type_name()}')
		}
	}
}

pub fn (aco ApplicationCommandOption) build() json2.Any {
	mut r := {
		'type':        json2.Any(int(aco.typ))
		'name':        aco.name
		'description': aco.description
	}
	if name_localizations := aco.name_localizations {
		r['name_localizations'] = maps.to_map[Locale, string, string, json2.Any](name_localizations,
			fn (k Locale, v string) (string, json2.Any) {
			return k, v
		})
	}
	if description_localizations := aco.description_localizations {
		r['description_localizations'] = maps.to_map[Locale, string, string, json2.Any](description_localizations,
			fn (k Locale, v string) (string, json2.Any) {
			return k, v
		})
	}
	if required := aco.required {
		r['required'] = required
	}
	if choices := aco.choices {
		r['choices'] = choices.map(it.build())
	}
	if options := aco.options {
		r['options'] = options.map(it.build())
	}
	if channel_types := aco.channel_types {
		r['channel_types'] = channel_types.map(json2.Any(int(it)))
	}
	if min_value := aco.min_value {
		r['min_value'] = min_value
	}
	if max_value := aco.max_value {
		r['max_value'] = max_value
	}
	if min_length := aco.min_length {
		r['min_length'] = min_length
	}
	if max_length := aco.max_length {
		r['min_length'] = max_length
	}
	if autocomplete := aco.autocomplete {
		r['autocomplete'] = autocomplete
	}
	return r
}

pub struct ApplicationCommand {
pub:
	// Unique ID of command
	id Snowflake
	// Type of command, defaults to 1
	typ ApplicationCommandType = .chat_input
	// ID of the parent application
	application_id Snowflake
	// Guild ID of the command, if not global
	guild_id ?Snowflake
	// Name of command, 1-32 characters
	name string
	// Localization dictionary for `name` field. Values follow the same restrictions as `name`
	name_localizations ?map[Locale]string
	// Description for `.chat_input` commands, 1-100 characters. Empty string for `.user` and `.message` commands
	description string
	// Localization dictionary for `description` field. Values follow the same restrictions as `description`
	description_localizations ?map[Locale]string
	// Parameters for the command, max of 25
	options ?[]ApplicationCommandOption
	// Set of permissions represented as a bit set
	default_member_permissions ?Permissions
	// Indicates whether the command is available in DMs with the app, only for globally-scoped commands. By default, commands are visible.
	dm_permission ?bool
	// Indicates whether the command is age-restricted, defaults to `false`
	nsfw ?bool
}

pub fn ApplicationCommand.parse(j json2.Any) !ApplicationCommand {
	match j {
		map[string]json2.Any {
			return ApplicationCommand{
				id: Snowflake.parse(j['id']!)!
				typ: unsafe { ApplicationCommandType(j['type']! as i64) }
				application_id: Snowflake.parse(j['application_id']!)!
				guild_id: if s := j['guild_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
				name: j['name']! as string
				name_localizations: if m := j['name_localizations'] {
					if m !is json2.Null {
						maps.to_map[string, json2.Any, Locale, string](m as map[string]json2.Any,
							fn (k string, v json2.Any) (Locale, string) {
							return k, v as string
						})
					} else {
						none
					}
				} else {
					none
				}
				description: j['description']! as string
				description_localizations: if m := j['description_localizations'] {
					if m !is json2.Null {
						maps.to_map[string, json2.Any, Locale, string](m as map[string]json2.Any,
							fn (k string, v json2.Any) (Locale, string) {
							return k, v as string
						})
					} else {
						none
					}
				} else {
					none
				}
				options: if a := j['options'] {
					?[]ApplicationCommandOption((a as []json2.Any).map(ApplicationCommandOption.parse(it)!))
				} else {
					none
				}
				default_member_permissions: if default_member_permissions := j['default_member_permissions'] {
					?Permissions(Permissions.parse(default_member_permissions)!)
				} else {
					none
				}
				dm_permission: if b := j['dm_permission'] {
					?bool(b as bool)
				} else {
					none
				}
				nsfw: if b := j['nsfw'] {
					?bool(b as bool)
				} else {
					none
				}
			}
		}
		else {
			return error('expected application command to be object, got ${j.type_name()}')
		}
	}
}

@[params]
pub struct FetchGlobalApplicationCommandsParams {
pub:
	with_localizations ?bool
}

// Fetch all of the global commands for your application. Returns an array of application command objects.
pub fn (c Client) fetch_global_application_commands(application_id Snowflake, params FetchGlobalApplicationCommandsParams) ![]ApplicationCommand {
	mut query_params := urllib.new_values()
	if with_localizations := params.with_localizations {
		query_params.add('with_localizations', with_localizations.str())
	}
	return (json2.raw_decode(c.request(.get, '/applications/${urllib.path_escape(application_id.build())}/commands${encode_query(query_params)}')!.body)! as []json2.Any).map(ApplicationCommand.parse(it)!)
}

@[params]
pub struct CreateApplicationCommandParams {
pub:
	// Name of command, 1-32 characters
	name string
	// Localization dictionary for the `name` field. Values follow the same restrictions as `name`
	name_localizations ?map[Locale]string
	// 1-100 character description for `.chat_input` commands
	description ?string
	// Localization dictionary for the `description` field. Values follow the same restrictions as `description`
	description_localizations ?map[Locale]string
	// the parameters for the command
	options ?[]ApplicationCommandOption
	// Set of permissions represented as a bit set
	default_member_permissions ?Permissions
	// Indicates whether the command is available in DMs with the app, only for globally-scoped commands. By default, commands are visible.
	dm_permission ?bool
	// Type of command, defaults `.chat_input` if not set
	typ ?ApplicationCommandType
	// Indicates whether the command is age-restricted
	nsfw ?bool
}

pub fn (params CreateApplicationCommandParams) build() json2.Any {
	mut r := {
		'name': json2.Any(params.name)
	}
	if name_localizations := params.name_localizations {
		r['name_localizations'] = maps.to_map[Locale, string, string, json2.Any](name_localizations,
			fn (k Locale, v string) (string, json2.Any) {
			return k, v
		})
	}
	if description := params.description {
		r['description'] = description
	}
	if description_localizations := params.description_localizations {
		r['description_localizations'] = maps.to_map[Locale, string, string, json2.Any](description_localizations,
			fn (k Locale, v string) (string, json2.Any) {
			return k, v
		})
	}
	if options := params.options {
		r['options'] = options.map(it.build())
	}
	if default_member_permissions := params.default_member_permissions {
		r['default_member_permissions'] = u64(default_member_permissions).str()
	}
	if dm_permission := params.dm_permission {
		r['dm_permission'] = dm_permission
	}
	if typ := params.typ {
		r['type'] = int(typ)
	}
	if nsfw := params.nsfw {
		r['nsfw'] = nsfw
	}
	return r
}

// Create a new global command. Returns 201 if a command with the same name does not already exist, or a 200 if it does (in which case the previous command will be overwritten). Both responses include an application command object.
pub fn (c Client) create_global_application_command(application_id Snowflake, params CreateApplicationCommandParams) !ApplicationCommand {
	return ApplicationCommand.parse(json2.raw_decode(c.request(.post, '/application/${urllib.path_escape(application_id.build())}/commands',
		json: params.build()
	)!.body)!)!
}

// Fetch a global command for your application. Returns an application command object.
pub fn (c Client) fetch_global_application_command(application_id Snowflake, command_id Snowflake) !ApplicationCommand {
	return ApplicationCommand.parse(json2.raw_decode(c.request(.get, '/application/${urllib.path_escape(application_id.build())}/commands/${urllib.path_escape(command_id.build())}')!.body)!)!
}

@[params]
pub struct EditApplicationCommandParams {
pub:
	// Name of command, 1-32 characters
	name ?string
	// Localization dictionary for the `name` field. Values follow the same restrictions as `name`
	name_localizations ?map[Locale]string
	// 1-100 character description
	description ?string
	// Localization dictionary for the `description` field. Values follow the same restrictions as `description`
	description_localizations ?map[Locale]string
	// the parameters for the command
	options ?[]ApplicationCommandOption
	// Set of permissions represented as a bit set
	default_member_permissions ?Permissions = sentinel_permissions
	// Indicates whether the command is available in DMs with the app, only for globally-scoped commands. By default, commands are visible.
	dm_permission ?bool
	// Indicates whether the command is age-restricted
	nsfw ?bool
}

pub fn (params EditApplicationCommandParams) build() json2.Any {
	mut r := map[string]json2.Any{}
	if name := params.name {
		r['name'] = name
	}
	if name_localizations := params.name_localizations {
		r['name_localizations'] = maps.to_map[Locale, string, string, json2.Any](name_localizations,
			fn (k Locale, v string) (string, json2.Any) {
			return k, v
		})
	}
	if description := params.description {
		r['description'] = description
	}
	if description_localizations := params.description_localizations {
		r['description_localizations'] = maps.to_map[Locale, string, string, json2.Any](description_localizations,
			fn (k Locale, v string) (string, json2.Any) {
			return k, v
		})
	}
	if options := params.options {
		r['options'] = options.map(it.build())
	}
	if default_member_permissions := params.default_member_permissions {
		if !is_sentinel(default_member_permissions) {
			r['default_member_permissions'] = u64(default_member_permissions).str()
		}
	} else {
		r['default_member_permissions'] = json2.Null{}
	}
	if dm_permission := params.dm_permission {
		r['dm_permission'] = dm_permission
	}
	if nsfw := params.nsfw {
		r['nsfw'] = nsfw
	}
	return r
}

// Edit a global command. Returns application command object. All fields are optional, but any fields provided will entirely overwrite the existing values of those fields.
pub fn (c Client) edit_global_application_command(application_id Snowflake, command_id Snowflake, params EditApplicationCommandParams) !ApplicationCommand {
	return ApplicationCommand.parse(json2.raw_decode(c.request(.patch, '/application/${urllib.path_escape(application_id.build())}/commands/${urllib.path_escape(command_id.build())}',
		json: params.build()
	)!.body)!)!
}

// Deletes a global command. Returns 204 No Content on success.
pub fn (c Client) delete_global_application_command(application_id Snowflake, command_id Snowflake) ! {
	c.request(.delete, '/application/${urllib.path_escape(application_id.build())}/commands/${urllib.path_escape(command_id.build())}')!
}

// Takes a list of application commands, overwriting the existing global command list for this application. Returns 200 and a list of application command objects. Commands that do not already exist will count toward daily application command create limits.
pub fn (c Client) bulk_overwrite_global_application_commands(application_id Snowflake, commands []CreateApplicationCommandParams) ![]ApplicationCommand {
	return (json2.raw_decode(c.request(.put, '/applications/${urllib.path_escape(application_id.build())}/commands',
		json: commands.map(it.build())
	)!.body)! as []json2.Any).map(ApplicationCommand.parse(it)!)
}

// Create a new guild command. New guild commands will be available in the guild immediately. Returns 201 if a command with the same name does not already exist, or a 200 if it does (in which case the previous command will be overwritten). Both responses include an application command object.
pub fn (c Client) create_guild_application_command(application_id Snowflake, guild_id Snowflake, params CreateApplicationCommandParams) !ApplicationCommand {
	return ApplicationCommand.parse(json2.raw_decode(c.request(.post, '/application/${urllib.path_escape(application_id.build())}/guilds/${urllib.path_escape(guild_id.build())}/commands',
		json: params.build()
	)!.body)!)!
}

// Fetch a guild command for your application. Returns an application command object.
pub fn (c Client) fetch_guild_application_command(application_id Snowflake, guild_id Snowflake, command_id Snowflake) !ApplicationCommand {
	return ApplicationCommand.parse(json2.raw_decode(c.request(.get, '/application/${urllib.path_escape(application_id.build())}/guilds/${urllib.path_escape(guild_id.build())}/commands/${urllib.path_escape(command_id.build())}')!.body)!)!
}

// Edit a guild command. Updates for guild commands will be available immediately. Returns application command object. All fields are optional, but any fields provided will entirely overwrite the existing values of those fields.
pub fn (c Client) edit_guild_application_command(application_id Snowflake, guild_id Snowflake, command_id Snowflake, params EditApplicationCommandParams) !ApplicationCommand {
	return ApplicationCommand.parse(json2.raw_decode(c.request(.patch, '/application/${urllib.path_escape(application_id.build())}/guilds/${urllib.path_escape(guild_id.build())}/commands/${urllib.path_escape(command_id.build())}',
		json: params.build()
	)!.body)!)!
}

// Delete a guild command. Returns 204 No Content on success.
pub fn (c Client) delete_guild_application_command(application_id Snowflake, guild_id Snowflake, command_id Snowflake) ! {
	c.request(.delete, '/application/${urllib.path_escape(application_id.build())}/guilds/${urllib.path_escape(guild_id.build())}/commands/${urllib.path_escape(command_id.build())}')!
}

// Takes a list of application commands, overwriting the existing command list for this application for the targeted guild. Returns 200 and a list of application command objects.
pub fn (c Client) bulk_overwrite_guild_application_commands(application_id Snowflake, guild_id Snowflake, commands []CreateApplicationCommandParams) ![]ApplicationCommand {
	return (json2.raw_decode(c.request(.put, '/applications/${urllib.path_escape(application_id.build())}/guilds/${urllib.path_escape(guild_id.build())}/commands',
		json: commands.map(it.build())
	)!.body)! as []json2.Any).map(ApplicationCommand.parse(it)!)
}

// Guild Application Command Permissions Structure
pub enum ApplicationCommandPermissionType {
	role    = 1
	user
	channel
}

pub struct ApplicationCommandPermission {
pub:
	// ID of the role, user, or channel. It can also be a permission constant
	id Snowflake
	// role (`.role`), user (`.user`), or channel (`.channel`)
	typ ApplicationCommandPermissionType
	// `true` to allow, `false`, to disallow
	permission bool
}

pub fn (acp ApplicationCommandPermission) build() json2.Any {
	return {
		'id':         json2.Any(acp.id.build())
		'type':       int(acp.typ)
		'permission': acp.permission
	}
}

pub fn ApplicationCommandPermission.parse(j json2.Any) !ApplicationCommandPermission {
	match j {
		map[string]json2.Any {
			return ApplicationCommandPermission{
				id: Snowflake.parse(j['id']!)!
				typ: unsafe { ApplicationCommandPermissionType(j['type']! as i64) }
				permission: j['permission']! as bool
			}
		}
		else {
			return error('expected application command permission to be object ${j.type_name()}')
		}
	}
}

pub struct GuildApplicationCommandPermissions {
pub:
	// ID of the command or the application ID
	id Snowflake
	// ID of the application the command belongs to
	application_id Snowflake
	// ID of the guild
	guild_id Snowflake
	// Permissions for the command in the guild, max of 100
	permissions []ApplicationCommandPermission
}

pub fn GuildApplicationCommandPermissions.parse(j json2.Any) !GuildApplicationCommandPermissions {
	match j {
		map[string]json2.Any {
			return GuildApplicationCommandPermissions{
				id: Snowflake.parse(j['id']!)!
				application_id: Snowflake.parse(j['application_id']!)!
				guild_id: Snowflake.parse(j['guild_id']!)!
				permissions: (j['permissions']! as []json2.Any).map(ApplicationCommandPermission.parse(it)!)
			}
		}
		else {
			return error('expected guild application command permissions to be object ${j.type_name()}')
		}
	}
}

// Fetches permissions for all commands for your application in a guild. Returns an array of guild application command permissions objects.
pub fn (c Client) fetch_guild_application_command_permissions(application_id Snowflake, guild_id Snowflake) ![]GuildApplicationCommandPermissions {
	return (json2.raw_decode(c.request(.get, '/applications/${urllib.path_escape(application_id.build())}/guilds/${urllib.path_escape(guild_id.build())}/commands/permissions')!.body)! as []json2.Any).map(GuildApplicationCommandPermissions.parse(it)!)
}

// Fetches permissions for a specific command for your application in a guild. Returns a guild application command permissions object.
pub fn (c Client) fetch_application_command_permissions(application_id Snowflake, guild_id Snowflake, command_id Snowflake) !GuildApplicationCommandPermissions {
	return GuildApplicationCommandPermissions.parse(json2.raw_decode(c.request(.get, '/applications/${urllib.path_escape(application_id.build())}/guilds/${urllib.path_escape(guild_id.build())}/commands/${urllib.path_escape(command_id.build())}/permissions')!.body)!)!
}

@[params]
pub struct EditApplicationCommandPermissionsParams {
pub:
	// Permissions for the command in the guild
	permissions []ApplicationCommandPermission
}

pub fn (params EditApplicationCommandPermissionsParams) build() json2.Any {
	return {
		'permissions': json2.Any(params.permissions.map(it.build()))
	}
}

// Edits command permissions for a specific command for your application in a guild and returns a guild application command permissions object. Fires an Application Command Permissions Update Gateway event.
//
// You can add up to 100 permission overwrites for a command.
pub fn (c Client) edit_application_command_permissions(application_id Snowflake, guild_id Snowflake, command_id Snowflake, params EditApplicationCommandPermissionsParams) !GuildApplicationCommandPermissions {
	return GuildApplicationCommandPermissions.parse(json2.raw_decode(c.request(.put, '/applications/${urllib.path_escape(application_id.build())}/guilds/${urllib.path_escape(guild_id.build())}/commands/${urllib.path_escape(command_id.build())}/permissions',
		json: params.build()
	)!.body)!)!
}
