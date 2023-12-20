module discord

import strconv
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
			json2.Any(json2.null)
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
			id := j['id']!
			return PartialEmoji{
				id: if id !is json2.Null {
					?Snowflake(Snowflake.parse(id)!)
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
				burst_colors: (j['burst_colors']! as []json2.Any).map(int(strconv.parse_uint((it as string)[1..], 16, 24)!))
			}
		}
		else {
			return error('expected reaction to be object, got ${j.type_name()}')
		}
	}
}