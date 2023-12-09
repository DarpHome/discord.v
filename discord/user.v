module discord

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
	id                Snowflake
	username          string
	discriminator     string
	global_name       ?string
	avatar            ?string
	bot               ?bool
	system            ?bool
	mfa_enabled       ?bool
	banner            ?string
	accent_color      ?int
	locale            ?string
	verified          ?bool
	email             ?string
	flags             ?UserFlags
	premium_type      ?PremiumType
	public_flags      ?UserFlags
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

pub fn (c Client) fetch_my_user() !User {
	return User.parse(json2.raw_decode(c.request(.get, '/users/@me')!.body)!)!
}

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

pub fn (c Client) edit_my_user(params MyUserEdit) !User {
	return User.parse(json2.raw_decode(c.request(.patch, '/users/@me', json: params.build())!.body)!)!
}

pub fn (c Client) leave_guild(guild_id Snowflake) ! {
	c.request(.delete, '/users/@me/guilds/${urllib.path_escape(guild_id.build())}')!
}
