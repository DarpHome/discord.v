module discord

import maps
import net.urllib
import x.json2

@[flag]
pub enum UserFlags {
	// Discord Employee
	staff
	// Partnered Server Owner
	partner
	// HypeSquad Events Member
	hypesquad
	// Bug Hunter Level 1
	bug_hunter_level_1
	reserved_4
	reserved_5
	// House Bravery Member
	hypesquad_online_house_1
	// House Brilliance Member
	hypesquad_online_house_2
	// House Balance Member
	hypesquad_online_house_3
	// Early Nitro Supporter
	premium_early_supporter
	// User is a team
	team_pseudo_user
	reserved_11
	reserved_12
	reserved_13
	// Bug Hunter Level 2
	bug_hunter_level_2
	reserved_15
	// Verified Bot
	verified_bot
	// Early Verified Bot Developer
	verified_developer
	// Moderator Programs Alumni
	certified_moderator
	// Bot uses only HTTP interactions and is shown in the online member list
	bot_http_interactions
	reserved_20
	reserved_21
	// User is an Active Developer
	active_developer
}

pub enum PremiumType {
	none_
	nitro_classic
	nitro
	nitro_basic
}

pub struct AvatarDecorationData {
pub:
	asset  string
	sku_id Snowflake
}

pub fn AvatarDecorationData.parse(j json2.Any) !AvatarDecorationData {
	match j {
		map[string]json2.Any {
			return AvatarDecorationData{
				asset: j['asset']! as string
				sku_id: Snowflake.parse(j['sku_id']!)!
			}
		}
		else {
			return error('expected avatar decoration data to be object, got ${j.type_name()}')
		}
	}
}

pub struct User {
pub:
	// the user's id
	id Snowflake
	// the user's username, not unique across the platform
	username string
	// the user's Discord-tag
	discriminator string
	// the user's display name, if it is set. For bots, this is the application name
	global_name ?string
	// the user's avatar hash
	avatar ?string
	// whether the user belongs to an OAuth2 application
	bot ?bool
	// whether the user is an Official Discord System user (part of the urgent message system)
	system ?bool
	// whether the user has two factor enabled on their account
	mfa_enabled ?bool
	// the user's banner hash
	banner ?string
	// the user's banner color encoded as an integer representation of hexadecimal color code
	accent_color ?int
	// the user's chosen language option
	locale ?string
	// whether the email on this account has been verified
	verified ?bool
	// the user's email
	email ?string
	// the flags on a user's account
	flags ?UserFlags
	// the type of Nitro subscription on a user's account
	premium_type ?PremiumType
	// the public flags on a user's account
	public_flags ?UserFlags
	// data for the user's avatar decoration
	avatar_decoration ?AvatarDecorationData
}

pub fn User.parse(j json2.Any) !User {
	dump(j)
	match j {
		map[string]json2.Any {
			id := Snowflake.parse(j['id']!)!
			username := j['username']! as string
			discriminator := j['discriminator']! as string
			tmp1 := j['global_name']!
			global_name := if tmp1 is string { ?string(tmp1) } else { none }
			tmp2 := j['avatar']!
			avatar := if tmp2 is string { ?string(tmp2) } else { none }
			bot := if b := j['bot'] { ?bool(b as bool) } else { none }
			system := if b := j['system'] { ?bool(b as bool) } else { none }
			mfa_enabled := if b := j['mfa_enabled'] { ?bool(b as bool) } else { none }
			banner := if s := j['banner'] {
				if s is string {
					?string(s)
				} else {
					none
				}
			} else {
				none
			}
			accent_color := if i := j['accent_color'] {
				if i is i64 {
					?int(i)
				} else {
					none
				}
			} else {
				none
			}
			locale := if s := j['locale'] {
				?string(s as string)
			} else {
				none
			}
			verified := if b := j['verified'] {
				?bool(b as bool)
			} else {
				none
			}
			email := if s := j['email'] {
				if s is string {
					?string(s)
				} else {
					none
				}
			} else {
				none
			}
			flags := if i := j['flags'] {
				unsafe { ?UserFlags(i as i64) }
			} else {
				none
			}
			premium_type := if i := j['premium_type'] {
				unsafe { ?PremiumType(i as i64) }
			} else {
				none
			}
			public_flags := if i := j['public_flags'] {
				unsafe { ?UserFlags(i as i64) }
			} else {
				none
			}
			avatar_decoration := if o := j['avatar_decoration_data'] {
				if o is json2.Null {
					?AvatarDecorationData(none)
				} else {
					AvatarDecorationData.parse(o)!
				}
			} else {
				none
			}
			return User{
				id: id
				username: username
				discriminator: discriminator
				global_name: global_name
				avatar: avatar
				bot: bot
				system: system
				mfa_enabled: mfa_enabled
				banner: banner
				accent_color: accent_color
				locale: locale
				verified: verified
				email: email
				flags: flags
				premium_type: premium_type
				public_flags: public_flags
				avatar_decoration: avatar_decoration
			}
		}
		else {
			return error('expected user to be object, got ${j.type_name()}')
		}
	}
}

// Returns the user object of the requester's account. For OAuth2, this requires the `identify` scope, which will return the object without an email, and optionally the `email` scope, which returns the object _with_ an email.
pub fn (c Client) fetch_my_user() !User {
	return User.parse(json2.raw_decode(c.request(.get, '/users/@me')!.body)!)!
}

// Returns a user object for a given user ID.
pub fn (c Client) fetch_user(user_id Snowflake) !User {
	return User.parse(json2.raw_decode(c.request(.get, '/users/${urllib.path_escape(user_id.build())}')!.body)!)!
}

@[params]
pub struct MyUserEdit {
pub:
	username ?string
	avatar   ?Image
}

pub fn (mue MyUserEdit) build() json2.Any {
	mut r := map[string]json2.Any{}
	if username := mue.username {
		r['username'] = username
	}
	if avatar := mue.avatar {
		r['avatar'] = avatar.build()
	}
	return r
}

// Modify the requester's user account settings. Returns a user object on success. Fires a User Update Gateway event.
pub fn (c Client) edit_my_user(params MyUserEdit) !User {
	return User.parse(json2.raw_decode(c.request(.patch, '/users/@me', json: params.build())!.body)!)!
}

// Returns a guild member object for the current user. Requires the guilds.members.read OAuth2 scope.
pub fn (c Client) fetch_my_guild_member(guild_id Snowflake) !GuildMember {
	return GuildMember.parse(c.request(.get, '/users/@me/guilds/${urllib.path_escape(guild_id.build())}/member')!.body)!
}

// Leave a guild. Fires a Guild Delete Gateway event and a Guild Member Remove Gateway event.
pub fn (c Client) leave_guild(guild_id Snowflake) ! {
	c.request(.delete, '/users/@me/guilds/${urllib.path_escape(guild_id.build())}')!
}

pub fn (c Client) create_dm(recipient_id Snowflake) ! {
	c.request(.post, '/users/@me/channels',
		json: {
			'recipient_id': json2.Any(recipient_id)
		}
	)!
}

@[params]
pub struct CreateGroupDMParams {
pub:
	access_tokens []string
	nicks         map[Snowflake]string
}

pub fn (c Client) create_group_dm(params CreateGroupDMParams) ! {
	c.request(.post, '/users/@me/channels',
		json: {
			'access_tokens': json2.Any(params.access_tokens.map(json2.Any(it)))
			'nicks':         maps.to_map[Snowflake, string, string, json2.Any](params.nicks,
				fn (k Snowflake, v string) (string, json2.Any) {
				return k.build(), json2.Any(v)
			})
		}
	)!
}

pub struct PartialUser {
pub:
	// the user's id
	id Snowflake
	// the user's username, not unique across the platform
	username string
	// the user's Discord-tag
	discriminator string
	// the user's avatar hash
	avatar ?string
}

pub fn PartialUser.parse(j json2.Any) !PartialUser {
	match j {
		map[string]json2.Any {
			avatar := j['avatar']!
			return PartialUser{
				id: Snowflake.parse(j['id']!)!
				username: j['username']! as string
				discriminator: j['discriminator']! as string
				avatar: if avatar !is json2.Null {
					?string(avatar as string)
				} else {
					none
				}
			}
		}
		else {
			return error('expected partial user to be object, got ${j.type_name()}')
		}
	}
}
