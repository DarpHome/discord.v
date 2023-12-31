module discord

import strconv
import net.urllib
import x.json2

pub struct PartialEmoji {
pub:
	id       ?Snowflake
	name     string
	animated bool
}

pub fn (pe PartialEmoji) build() json2.Any {
	mut r := {
		'id':   if id := pe.id {
			json2.Any(id.build())
		} else {
			json2.null
		}
		'name': pe.name
	}
	if pe.id != none {
		r['animated'] = pe.animated
	}
	return r
}

pub fn PartialEmoji.parse(j json2.Any) !PartialEmoji {
	match j {
		map[string]json2.Any {
			return PartialEmoji{
				id: if s := j['id'] {
					if s !is json2.Null {
						?Snowflake(Snowflake.parse(s)!)
					} else {
						none
					}
				} else {
					none
				}
				name: j['name']! as string
				animated: if b := j['animated'] {
					b as bool
				} else {
					false
				}
			}
		}
		else {
			return error('expected partial emoji to be object, got ${j.type_name()}')
		}
	}
}

pub struct Emoji {
pub:
	id             ?Snowflake
	name           ?string
	roles          ?[]Snowflake
	user           ?User
	require_colons ?bool
	managed        ?bool
	animated       ?bool
	available      ?bool
}

pub fn Emoji.parse(j json2.Any) !Emoji {
	match j {
		map[string]json2.Any {
			id := j['id']!
			name := j['name']!
			roles := if a := j['roles'] {
				?[]Snowflake((a as []json2.Any).map(Snowflake.parse(it)!))
			} else {
				?[]Snowflake(none)
			}
			user := if o := j['user'] {
				?User(User.parse(o)!)
			} else {
				?User(none)
			}
			return Emoji{
				id: if id is json2.Null { none } else { Snowflake.parse(id)! }
				name: if name is json2.Null { none } else { ?string(name as string) }
				roles: roles
				user: user
				require_colons: if b := j['require_colons'] {
					b as bool
				} else {
					?bool(none)
				}
				managed: if b := j['managed'] {
					b as bool
				} else {
					?bool(none)
				}
				animated: if b := j['animated'] {
					b as bool
				} else {
					?bool(none)
				}
				available: if b := j['available'] {
					b as bool
				} else {
					?bool(none)
				}
			}
		}
		else {
			return error('expected emoji to be object, got ${j.type_name()}')
		}
	}
}

pub struct ReactionCountDetails {
pub:
	// Count of super reactions
	burst int
	// Count of normal reactions
	normal int
}

pub fn ReactionCountDetails.parse(j json2.Any) !ReactionCountDetails {
	match j {
		map[string]json2.Any {
			return ReactionCountDetails{
				burst: j['burst']!.int()
				normal: j['normal']!.int()
			}
		}
		else {
			return error('expected reaction count details to be object, got ${j.type_name()}')
		}
	}
}

pub struct Reaction {
pub:
	// Total number of times this emoji has been used to react (including super reacts)
	count int
	// Reaction count details object
	count_details ReactionCountDetails
	// Whether the current user reacted using this emoji
	me bool
	// Whether the current user super-reacted using this emoji
	me_burst bool
	// emoji information
	emoji PartialEmoji
	// HEX colors used for super reaction
	burst_colors []int
}

pub fn Reaction.parse(j json2.Any) !Reaction {
	match j {
		map[string]json2.Any {
			return Reaction{
				count: j['count']!.int()
				count_details: ReactionCountDetails.parse(j['count_details']!)!
				me: j['me']! as bool
				me_burst: j['me_burst']! as bool
				emoji: PartialEmoji.parse(j['emoji']!)!
				burst_colors: (j['burst_colors']! as []json2.Any).map(int(strconv.parse_uint((it as string)[1..],
					16, 24)!))
			}
		}
		else {
			return error('expected reaction to be object, got ${j.type_name()}')
		}
	}
}

// Returns a list of [emoji](#Emoji) objects for the given guild. Includes user fields if the bot has the `.create_guild_expressions` or `.manage_guild_expressions` permission.
pub fn (c Client) list_guild_emojis(guild_id Snowflake) ![]Emoji {
	return maybe_map(json2.raw_decode(c.request(.get, '/guilds/${urllib.path_escape(guild_id.build())}/emojis')!.body)! as []json2.Any,
		fn (j json2.Any) !Emoji {
		return Emoji.parse(j)!
	})!
}

// Returns an [emoji](#Emoji) object for the given guild and emoji IDs. Includes the user field if the bot has the `.manage_guild_expressions` permission, or if the bot created the emoji and has the the `.create_guild_expressions` permission.
pub fn (c Client) fetch_guild_emoji(guild_id Snowflake, emoji_id Snowflake) !Emoji {
	return Emoji.parse(json2.raw_decode(c.request(.get, '/guilds/${urllib.path_escape(guild_id.build())}/emojis/${urllib.path_escape(emoji_id.build())}')!.body)!)!
}

@[params]
pub struct CreateGuildEmojiParams {
pub:
	reason ?string
	// name of the emoji
	name string @[required]
	// the 128x128 emoji image
	image Image @[required]
	// roles allowed to use this emoji
	roles ?[]Snowflake
}

pub fn (params CreateGuildEmojiParams) build() json2.Any {
	mut r := {
		'name':  json2.Any(params.name)
		'image': params.image.build()
	}
	if roles := params.roles {
		r['roles'] = roles.map(|s| json2.Any(s.build()))
	}
	return r
}

// Create a new emoji for the guild. Requires the `.create_guild_expressions` permission. Returns the new [emoji](#Emoji) object on success. Fires a Guild Emojis Update Gateway event.
pub fn (c Client) create_guild_emoji(guild_id Snowflake, params CreateGuildEmojiParams) !Emoji {
	return Emoji.parse(json2.raw_decode(c.request(.post, '/guilds/${urllib.path_escape(guild_id.build())}/emojis',
		json: params.build()
		reason: params.reason
	)!.body)!)!
}

@[params]
pub struct EditGuildEmojiParams {
pub:
	reason ?string
	// name of the emoji
	name ?string
	// roles allowed to use this emoji
	roles ?[]Snowflake = sentinel_snowflakes
}

pub fn (params EditGuildEmojiParams) build() json2.Any {
	mut r := map[string]json2.Any{}
	if name := params.name {
		r['name'] = name
	}
	if roles := params.roles {
		if !is_sentinel(roles) {
			r['roles'] = roles.map(|s| json2.Any(s.build()))
		}
	} else {
		r['roles'] = json2.null
	}
	return r
}

// Modify the given emoji. For emojis created by the current user, requires either the `.create_guild_expressions` or `.manage_guild_expressions` permission. For other emojis, requires the `.manage_guild_expressions` permission. Returns the updated [emoji](#Emoji) object on success. Fires a Guild Emojis Update Gateway event.
pub fn (c Client) edit_guild_emoji(guild_id Snowflake, emoji_id Snowflake, params EditGuildEmojiParams) !Emoji {
	return Emoji.parse(json2.raw_decode(c.request(.patch, '/guilds/${urllib.path_escape(guild_id.build())}/emojis/${urllib.path_escape(emoji_id.build())}',
		json: params.build()
		reason: params.reason
	)!.body)!)!
}

// Delete the given emoji. For emojis created by the current user, requires either the `.create_guild_expressions` or `.manage_guild_expressions` permission. For other emojis, requires the `.manage_guild_expressions` permission. Returns 204 No Content on success. Fires a Guild Emojis Update Gateway event.
pub fn (c Client) delete_guild_emoji(guild_id Snowflake, emoji_id Snowflake, params ReasonParam) ! {
	c.request(.delete, '/guilds/${urllib.path_escape(guild_id.build())}/emojis/${urllib.path_escape(emoji_id.build())}',
		reason: params.reason
	)!
}
