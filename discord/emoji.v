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
			json2.Any(json2.Null{})
		}
		'name': pe.name
	}
	if pe.id != none {
		r['animated'] = pe.animated
	}
	return r
}
