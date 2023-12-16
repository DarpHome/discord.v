module discord

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

pub struct Reaction {
	
}