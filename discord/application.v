module discord

import encoding.hex
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
	// ID of the app
	id Snowflake
	// Name of the app
	name ?string
	// Icon hash of the app
	icon ?string
	// Description of the app
	description ?string
	// When `false`, only the app owner can add the app to guilds
	bot_public ?bool
	// When `true`, the app's bot will only join upon completion of the full OAuth2 code grant flow
	bot_require_code_grant ?bool
	// URL of the app's Terms of Service
	terms_of_service_url ?string
	// URL of the app's Privacy Policy
	privacy_policy_url ?string
	// Key for verification in interactions and the GameSDK's GetTicket
	verify_key ?[]u8
	// App's public flags
	flags ApplicationFlags
	// List of tags describing the content and functionality of the app. Max of 5 tags.
	tags ?[]string
}

pub fn PartialApplication.parse(j json2.Any) !PartialApplication {
	match j {
		map[string]json2.Any {
			return PartialApplication{
				id: Snowflake.parse(j['id']!)!
				name: if s := j['name'] {
					?string(s as string)
				} else {
					none
				}
				icon: if s := j['icon'] {
					if s !is json2.Null {
						?string(s as string)
					} else {
						none
					}
				} else {
					none
				}
				description: if s := j['description'] {
					?string(s as string)
				} else {
					none
				}
				bot_public: if b := j['bot_public'] {
					?bool(b as bool)
				} else {
					none
				}
				bot_require_code_grant: if b := j['bot_require_code_grant'] {
					?bool(b as bool)
				} else {
					none
				}
				terms_of_service_url: if s := j['terms_of_service_url'] {
					?string(s as string)
				} else {
					none
				}
				privacy_policy_url: if s := j['privacy_policy_url'] {
					?string(s as string)
				} else {
					none
				}
				verify_key: if s := j['verify_key'] {
					?[]u8(hex.decode(s as string)!)
				} else {
					none
				}
				flags: unsafe { ApplicationFlags(j['flags']! as i64) }
				tags: if a := j['tags'] {
					?[]string((a as []json2.Any).map(it as string))
				} else {
					none
				}
			}
		}
		else {
			return error('expected partial application to be object, got ${j.type_name()}')
		}
	}
}

pub enum MembershipState {
	invited  = 1
	accepted
}

pub type TeamMemberRole = string

pub const team_member_role_admin = TeamMemberRole('admin')
pub const team_member_role_developer = TeamMemberRole('developer')
pub const team_member_role_read_only = TeamMemberRole('read_only')

pub struct TeamMember {
pub:
	// User's membership state on the team
	membership_state MembershipState
	// ID of the parent team of which they are a member
	team_id Snowflake
	// Avatar, discriminator, ID, and username of the user
	user PartialUser
	// Role of the team member
	role TeamMemberRole
}

pub fn TeamMember.parse(j json2.Any) !TeamMember {
	match j {
		map[string]json2.Any {
			return TeamMember{
				membership_state: unsafe { MembershipState(j['membership_state']! as i64) }
				team_id: Snowflake.parse(j['team_id']!)!
				user: PartialUser.parse(j['user']!)!
				role: TeamMemberRole(j['role']! as string)
			}
		}
		else {
			return error('expected team member to be object, got ${j.type_name()}')
		}
	}
}

pub struct Team {
pub:
	// Hash of the image of the team's icon
	icon ?string
	// Unique ID of the team
	id Snowflake
	// Members of the team
	members []TeamMember
	// Name of the team
	name string
	// User ID of the current team owner
	owner_user_id Snowflake
}

pub fn Team.parse(j json2.Any) !Team {
	match j {
		map[string]json2.Any {
			icon := j['icon']!
			return Team{
				id: Snowflake.parse(j['id']!)!
				icon: if icon !is json2.Null {
					?string(icon as string)
				} else {
					none
				}
				members: (j['members']! as []json2.Any).map(TeamMember.parse(it)!)
				name: j['name']! as string
				owner_user_id: Snowflake.parse(j['owner_user_id']!)!
			}
		}
		else {
			return error('expected team member to be object, got ${j.type_name()}')
		}
	}
}

pub struct InstallParams {
pub:
	// Scopes to add the application to the server with
	scopes []string
	// Permissions to request for the bot role
	permissions Permissions
}

pub fn InstallParams.parse(j json2.Any) !InstallParams {
	match j {
		map[string]json2.Any {
			return InstallParams{
				scopes: (j['scopes']! as []json2.Any).map(it as string)
				permissions: Permissions.parse(j['permissions']!)!
			}
		}
		else {
			return error('expected install params to be object, got ${j.type_name()}')
		}
	}
}

pub fn (ip InstallParams) build() json2.Any {
	return {
		'scopes':      json2.Any(ip.scopes.map(json2.Any(it)))
		'permissions': u64(ip.permissions).str()
	}
}

pub struct Application {
pub:
	// ID of the app
	id Snowflake
	// Name of the app
	name string
	// Icon hash of the app
	icon ?string
	// Description of the app
	description string
	// List of RPC origin URLs, if RPC is enabled
	rpc_origins ?[]string
	// When `false`, only the app owner can add the app to guilds
	bot_public bool
	// When `true`, the app's bot will only join upon completion of the full OAuth2 code grant flow
	bot_require_code_grant bool
	// Partial user object for the bot user associated with the app
	bot ?User
	// URL of the app's Terms of Service
	terms_of_service_url ?string
	// URL of the app's Privacy Policy
	privacy_policy_url ?string
	// Partial user object for the owner of the app
	owner ?User
	// Key for verification in interactions and the GameSDK's GetTicket
	verify_key []u8
	// If the app belongs to a team, this will be a list of the members of that team
	team ?Team
	// Guild associated with the app. For example, a developer support server.
	guild_id ?Snowflake
	// Partial object of the associated guild
	guild ?PartialGuild
	// If this app is a game sold on Discord, this field will be the id of the "Game SKU" that is created, if exists
	primary_sku_id ?Snowflake
	// If this app is a game sold on Discord, this field will be the URL slug that links to the store page
	slug ?string
	// App's default rich presence invite cover image hash
	cover_image ?string
	// App's public flags
	flags ?ApplicationFlags
	// Approximate count of guilds the app has been added to
	approximate_guild_count ?int
	// Array of redirect URIs for the app
	redirect_uris ?[]string
	// Interactions endpoint URL for the app
	interactions_endpoint_url ?string
	// Role connection verification URL for the app
	role_connections_verification_url ?string
	// List of tags describing the content and functionality of the app. Max of 5 tags.
	tags ?[]string
	// Settings for the app's default in-app authorization link, if enabled
	install_params ?InstallParams
	// Default custom authorization URL for the app, if enabled
	custom_install_url ?string
}

pub fn Application.parse(j json2.Any) !Application {
	match j {
		map[string]json2.Any {
			icon := j['icon']!
			team := j['team']!
			return Application{
				id: Snowflake.parse(j['id']!)!
				name: j['name']! as string
				icon: if icon !is json2.Null {
					?string(icon as string)
				} else {
					none
				}
				description: j['description']! as string
				rpc_origins: if a := j['rpc_origins'] {
					?[]string((a as []json2.Any).map(it as string))
				} else {
					none
				}
				bot_public: j['bot_public']! as bool
				bot_require_code_grant: j['bot_require_code_grant']! as bool
				bot: if o := j['user'] {
					?User(User.parse(o)!)
				} else {
					none
				}
				terms_of_service_url: if s := j['terms_of_service_url'] {
					?string(s as string)
				} else {
					none
				}
				privacy_policy_url: if s := j['privacy_policy_url'] {
					?string(s as string)
				} else {
					none
				}
				owner: if o := j['owner'] {
					?User(User.parse(o)!)
				} else {
					none
				}
				verify_key: hex.decode(j['verify_key']! as string)!
				team: if team !is json2.Null {
					?Team(Team.parse(team)!)
				} else {
					none
				}
				guild_id: if s := j['guild_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
				guild: if o := j['guild'] {
					?PartialGuild(PartialGuild.parse(o)!)
				} else {
					none
				}
				primary_sku_id: if s := j['primary_sku_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
				slug: if s := j['slug'] {
					?string(s as string)
				} else {
					none
				}
				cover_image: if s := j['cover_image'] {
					?string(s as string)
				} else {
					none
				}
				flags: if i := j['flags'] {
					unsafe { ApplicationFlags(i as i64) }
				} else {
					none
				}
				approximate_guild_count: if i := j['approximate_guild_count'] {
					?int(i as i64)
				} else {
					none
				}
				redirect_uris: if a := j['redirect_uris'] {
					?[]string((a as []json2.Any).map(it as string))
				} else {
					none
				}
				interactions_endpoint_url: if s := j['interactions_endpoint_url'] {
					?string(s as string)
				} else {
					none
				}
				role_connections_verification_url: if s := j['role_connections_verification_url'] {
					?string(s as string)
				} else {
					none
				}
				tags: if a := j['tags'] {
					?[]string((a as []json2.Any).map(it as string))
				} else {
					none
				}
				install_params: if o := j['install_params'] {
					?InstallParams(InstallParams.parse(o)!)
				} else {
					none
				}
				custom_install_url: if s := j['custom_install_url'] {
					?string(s as string)
				} else {
					none
				}
			}
		}
		else {
			return error('expected application to be object, got ${j.type_name()}')
		}
	}
}

// Returns the application object associated with the requesting bot user.
pub fn (c Client) fetch_my_application() !Application {
	return Application.parse(json2.raw_decode(c.request(.get, '/applications/@me')!.body)!)!
}

@[params]
pub struct EditApplicationParams {
pub:
	// Default custom authorization URL for the app, if enabled
	custom_install_url ?string
	// Description of the app
	description ?string
	// Role connection verification URL for the app
	role_connections_verification_url ?string
	// Settings for the app's default in-app authorization link, if enabled
	install_params ?InstallParams
	// App's public flags
	flags ?ApplicationFlags
	// Icon for the app
	icon ?Image = sentinel_image
	// Default rich presence invite cover image for the app
	cover_image ?Image = sentinel_image
	// Interactions endpoint URL for the app
	interactions_endpoint_url ?string
	// List of tags describing the content and functionality of the app (max of 20 characters per tag). Max of 5 tags.
	tags ?[]string
}

pub fn (params EditApplicationParams) build() json2.Any {
	mut r := map[string]json2.Any{}
	if custom_install_url := params.custom_install_url {
		r['custom_install_url'] = custom_install_url
	}
	if description := params.description {
		r['description'] = description
	}
	if role_connections_verification_url := params.role_connections_verification_url {
		r['role_connections_verification_url'] = role_connections_verification_url
	}
	if install_params := params.install_params {
		r['install_params'] = install_params.build()
	}
	if flags := params.flags {
		r['flags'] = int(flags)
	}
	if icon := params.icon {
		if !is_sentinel(icon) {
			r['icon'] = icon.build()
		}
	} else {
		r['icon'] = json2.Null{}
	}
	if cover_image := params.cover_image {
		if !is_sentinel(cover_image) {
			r['cover_image'] = cover_image.build()
		}
	} else {
		r['cover_image'] = json2.Null{}
	}
	if interactions_endpoint_url := params.interactions_endpoint_url {
		r['interactions_endpoint_url'] = interactions_endpoint_url
	}
	if tags := params.tags {
		r['tags'] = json2.Any(tags.map(json2.Any(it)))
	}
	return r
}

// Edit properties of the app associated with the requesting bot user. Only properties that are passed will be updated. Returns the updated application object on success.
pub fn (c Client) edit_my_application(params EditApplicationParams) !Application {
	return Application.parse(json2.raw_decode(c.request(.patch, '/applications/@me',
		json: params.build()
	)!.body)!)!
}
