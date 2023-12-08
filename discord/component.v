module discord

import x.json2

pub enum ComponentType as int {
	action_row = 1
	button = 2
	string_select = 3
	text_input = 4
	user_select = 5
	role_select = 6
	mentionable_select = 7
	channel_select = 8
}

pub fn (ct ComponentType) build() json2.Any {
	return json2.Any(int(ct))
}

pub interface Component {
	is_component()
	build() json2.Any
}

// ignore is_component(), it is used to differ interfaces


pub struct ActionRow {
pub:
	components []Component
}

fn (ar ActionRow) is_component() {}
pub fn (ar ActionRow) build() json2.Any {
	return {
		'type': ComponentType.action_row.build()
		'components': ar.components.map(it.build())
	}
}

pub enum ButtonStyle as int {
	primary = 1
	secondary = 2
	success = 3
	danger = 4
	link = 5
}

pub fn (bs ButtonStyle) build() json2.Any {
	return json2.Any(int(bs))
}


pub struct Button {
pub:
	style ButtonStyle = .secondary
	label ?string
	emoji ?PartialEmoji
	custom_id ?string
	url ?string
	disabled ?bool
}

fn (b Button) is_component() {}
pub fn (b Button) build() json2.Any {
	mut r := {
		'style': b.style.build()
	}
	if label := b.label {
		r['label'] = label
	}
	if emoji := b.emoji {
		r['emoji'] = emoji.build()
	}
	if custom_id := b.custom_id {
		r['custom_id'] = custom_id
	}
	if url := b.url {
		r['url'] = url
	}
	if disabled := b.disabled {
		r['disabled'] = disabled
	}
	return r
}