module discord

import x.json2

pub enum StickerType {
	standard
	guild
}

pub enum StickerFormatType {
	png
	apng
	lottie
	gif
}

pub struct Sticker {
pub:
	id          Snowflake
	pack_id     ?Snowflake
	name        string
	description ?string
	tags        ?string
	typ         StickerType
	format_type StickerFormatType
	available   ?bool
	guild_id    ?Snowflake
	user        ?User
	sort_value  ?int
}

pub fn Sticker.parse(j json2.Any) !Sticker {
	match j {
		map[string]json2.Any {
			id := Snowflake.parse(j['id']!)!
			pack_id := if s := j['pack_id'] {
				Snowflake.parse(s)!
			} else {
				?Snowflake(none)
			}
			name := j['name']! as string
			description := j['description']!
			tags := j['tags']! as string
			typ := unsafe { StickerType(j['type']! as i64) }
			format_type := unsafe { StickerFormatType(j['format_type']! as i64) }
			available := if b := j['available'] {
				b as bool
			} else {
				?bool(none)
			}
			guild_id := if s := j['guild_id'] {
				Snowflake.parse(s)!
			} else {
				?Snowflake(none)
			}
			user := if o := j['user'] {
				User.parse(o)!
			} else {
				?User(none)
			}
			sort_value := if i := j['sort_value'] {
				int(i as i64)
			} else {
				?int(none)
			}
			return Sticker{
				id: id
				pack_id: pack_id
				name: name
				description: if description is string { description } else { ?string(none) }
				tags: tags
				typ: typ
				format_type: format_type
				available: available
				guild_id: guild_id
				user: user
				sort_value: sort_value
			}
		}
		else {
			return error('expected sticker to be object, got ${j.type_name()}')
		}
	}
}
