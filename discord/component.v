module discord

import x.json2

pub enum ComponentType {
	// Container for other components
	action_row         = 1
	// Button object
	button             = 2
	// Select menu for picking from defined text options
	string_select      = 3
	// Text input object
	text_input         = 4
	// Select menu for users
	user_select        = 5
	// Select menu for roles
	role_select        = 6
	// Select menu for mentionables (users *and roles*)
	mentionable_select = 7
	// Select menu for channels
	channel_select     = 8
}

pub fn (ct ComponentType) build() json2.Any {
	return json2.Any(int(ct))
}

// ignore is_component(), it is used to differ interfaces

pub interface Component {
	is_component()
	build() json2.Any
}

// An Action Row is a non-interactive container component for other types of components. It has a sub-array of components of other types.
// - You can have up to 5 Action Rows per message
// - An Action Row cannot contain another Action Row
pub struct ActionRow {
pub:
	components []Component
}

fn (_ ActionRow) is_component() {}

pub fn (ar ActionRow) build() json2.Any {
	return {
		'type':       ComponentType.action_row.build()
		'components': ar.components.map(it.build())
	}
}

pub enum ButtonStyle {
	// blurple
	primary   = 1
	// grey
	secondary = 2
	// green
	success   = 3
	// red
	danger    = 4
	// grey, navigates to a URL
	link      = 5
}

pub fn (bs ButtonStyle) build() json2.Any {
	return json2.Any(int(bs))
}

// Buttons are interactive components that render in messages. They can be clicked by users, and send an interaction to your app when clicked.
//
// - Buttons must be sent inside an Action Row
// - An Action Row can contain up to 5 buttons
// - An Action Row containing buttons cannot also contain any select menu components
// <br/>
//
// Buttons come in a variety of styles to convey different types of actions. These styles also define what fields are valid for a button.
//
// - Non-link buttons must have a custom_id, and cannot have a url
// - Link buttons must have a url, and cannot have a custom_id
// - Link buttons do not send an interaction to your app when clicked
pub struct Button {
pub:
	// A button style, default is `.secondary`
	style ButtonStyle = .secondary
	// Text that appears on the button; max 80 characters
	label ?string
	// `name`, `id`, and `animated`
	emoji ?PartialEmoji
	// Developer-defined identifier for the button; max 100 characters
	custom_id ?string
	// URL for link-style buttons
	url ?string
	// Whether the button is disabled (defaults to false)
	disabled bool
}

fn (_ Button) is_component() {}

pub fn (b Button) build() json2.Any {
	mut r := {
		'type':     ComponentType.button.build()
		'style':    b.style.build()
		'disabled': b.disabled
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
	return r
}

pub struct SelectOption {
pub:
	// User-facing name of the option; max 100 characters
	label string
	// Dev-defined value of the option; max 100 characters
	value string
	// Additional description of the option; max 100 characters
	description ?string
	// `id`, `name`, and `animated`
	emoji ?PartialEmoji
	// Will show this option as selected by default
	default ?bool
}

pub fn (so SelectOption) build() json2.Any {
	mut r := {
		'label': json2.Any(so.label)
		'value': so.value
	}
	if description := so.description {
		r['description'] = description
	}
	if emoji := so.emoji {
		r['emoji'] = emoji.build()
	}
	if default := so.default {
		r['default'] = default
	}
	return r
}

pub struct StringSelect {
pub:
	// ID for the select menu; max 100 characters
	custom_id string
	// Specified choices in a select menu (only required and available for string selects (type 3); max 25
	options []SelectOption
	// Placeholder text if nothing is selected; max 150 characters
	placeholder ?string
	// Minimum number of items that must be chosen (defaults to 1); min 0, max 25
	min_values ?int
	// Maximum number of items that can be chosen (defaults to 1); max 25
	max_values ?int
	// Whether select menu is disabled (defaults to false)
	disabled bool
}

fn (_ StringSelect) is_component() {}

pub fn (ss StringSelect) build() json2.Any {
	mut r := {
		'type':      ComponentType.string_select.build()
		'custom_id': ss.custom_id
		'options':   ss.options.map(it.build())
		'disabled':  ss.disabled
	}
	if placeholder := ss.placeholder {
		r['placeholder'] = placeholder
	}
	if min_values := ss.min_values {
		r['min_values'] = min_values
	}
	if max_values := ss.max_values {
		r['max_values'] = max_values
	}
	return r
}

pub struct UserSelect {
pub:
	// ID for the select menu; max 100 characters
	custom_id string
	// Placeholder text if nothing is selected; max 150 characters
	placeholder ?string
	// List of default values for auto-populated select menu components; number of default values must be in the range defined by `min_values` and `max_values`
	default_values ?[]Snowflake
	// Minimum number of items that must be chosen (defaults to 1); min 0, max 25
	min_values ?int
	// Maximum number of items that can be chosen (defaults to 1); max 25
	max_values ?int
	// Whether select menu is disabled (defaults to false)
	disabled bool
}

fn (_ UserSelect) is_component() {}

pub fn (us UserSelect) build() json2.Any {
	mut r := {
		'type':      ComponentType.user_select.build()
		'custom_id': us.custom_id
		'disabled':  us.disabled
	}
	if placeholder := us.placeholder {
		r['placeholder'] = placeholder
	}
	if default_values := us.default_values {
		r['default_values'] = default_values.map(json2.Any({
			'id':   json2.Any(it.build())
			'type': 'user'
		}))
	}
	if min_values := us.min_values {
		r['min_values'] = min_values
	}
	if max_values := us.max_values {
		r['max_values'] = max_values
	}
	return r
}

pub struct RoleSelect {
pub:
	// ID for the select menu; max 100 characters
	custom_id string
	// Placeholder text if nothing is selected; max 150 characters
	placeholder ?string
	// List of default values for auto-populated select menu components; number of default values must be in the range defined by `min_values` and `max_values`
	default_values ?[]Snowflake
	// Minimum number of items that must be chosen (defaults to 1); min 0, max 25
	min_values ?int
	// Maximum number of items that can be chosen (defaults to 1); max 25
	max_values ?int
	// Whether select menu is disabled (defaults to false)
	disabled bool
}

fn (_ RoleSelect) is_component() {}

pub fn (rs RoleSelect) build() json2.Any {
	mut r := {
		'type':      ComponentType.role_select.build()
		'custom_id': rs.custom_id
		'disabled':  rs.disabled
	}
	if placeholder := rs.placeholder {
		r['placeholder'] = placeholder
	}
	if default_values := rs.default_values {
		r['default_values'] = default_values.map(json2.Any({
			'id':   json2.Any(it.build())
			'type': 'role'
		}))
	}
	if min_values := rs.min_values {
		r['min_values'] = min_values
	}
	if max_values := rs.max_values {
		r['max_values'] = max_values
	}
	return r
}

pub enum DefaultValueType {
	user
	role
	channel
}

pub struct DefaultValue {
pub:
	// ID of a user, role, or channel
	id Snowflake @[required]
	// Type of value that `id` represents. Either `.user`, `.role`, or `.channel`
	typ DefaultValueType @[required]
}

pub fn (dv DefaultValue) build() json2.Any {
	return {
		'id':   json2.Any(dv.id.build())
		'type': match dv.typ {
			.user { 'user' }
			.role { 'role' }
			.channel { 'channel' }
		}
	}
}

pub struct MentionableSelect {
pub:
	// ID for the select menu; max 100 characters
	custom_id   string
	placeholder ?string
	// List of default values for auto-populated select menu components; number of default values must be in the range defined by `min_values` and `max_values`
	default_values ?[]DefaultValue
	// Minimum number of items that must be chosen (defaults to 1); min 0, max 25
	min_values ?int
	// Maximum number of items that can be chosen (defaults to 1); max 25
	max_values ?int
	// Whether select menu is disabled (defaults to `false`)
	disabled bool
}

fn (_ MentionableSelect) is_component() {}

pub fn (ms MentionableSelect) build() json2.Any {
	mut r := {
		'type':      ComponentType.mentionable_select.build()
		'custom_id': ms.custom_id
		'disabled':  ms.disabled
	}
	if placeholder := ms.placeholder {
		r['placeholder'] = placeholder
	}
	if default_values := ms.default_values {
		r['default_values'] = default_values.map(it.build())
	}
	if min_values := ms.min_values {
		r['min_values'] = min_values
	}
	if max_values := ms.max_values {
		r['max_values'] = max_values
	}
	return r
}

pub struct ChannelSelect {
pub:
	// ID for the select menu; max 100 characters
	custom_id string
	// List of channel types to include in the channel select component
	channel_types ?[]ChannelType
	// Placeholder text if nothing is selected; max 150 characters
	placeholder ?string
	// List of default values for auto-populated select menu components; number of default values must be in the range defined by `min_values` and `max_values`
	default_values ?[]Snowflake
	// Minimum number of items that must be chosen (defaults to 1); min 0, max 25
	min_values ?int
	// Maximum number of items that can be chosen (defaults to 1); max 25
	max_values ?int
	// Whether select menu is disabled (defaults to false)
	disabled bool
}

fn (_ ChannelSelect) is_component() {}

pub fn (cs ChannelSelect) build() json2.Any {
	mut r := {
		'type':      ComponentType.channel_select.build()
		'custom_id': cs.custom_id
		'disabled':  cs.disabled
	}
	if channel_types := cs.channel_types {
		r['channel_types'] = channel_types.map(json2.Any(int(it)))
	}
	if placeholder := cs.placeholder {
		r['placeholder'] = placeholder
	}
	if default_values := cs.default_values {
		r['default_values'] = default_values.map(json2.Any({
			'id':   json2.Any(it.build())
			'type': 'channel'
		}))
	}
	if min_values := cs.min_values {
		r['min_values'] = min_values
	}
	if max_values := cs.max_values {
		r['max_values'] = max_values
	}
	return r
}

pub enum TextInputStyle {
	// Single-line input
	short     = 1
	// Multi-line input
	paragraph = 2
}

pub fn (tis TextInputStyle) build() json2.Any {
	return json2.Any(int(tis))
}

// Text inputs are an interactive component that render in modals. They can be used to collect short-form or long-form text.
// When defining a text input component, you can set attributes to customize the behavior and appearance of it. However, not all attributes will be returned in the text input interaction payload.
pub struct TextInput {
pub:
	// Developer-defined identifier for the input; max 100 characters
	custom_id string @[required]
	// The Text Input Style
	style TextInputStyle = .short
	// Label for this component; max 45 characters
	label string @[required]
	// Minimum input length for a text input; min 0, max 4000
	min_length ?int
	// Maximum input length for a text input; min 1, max 4000
	max_length ?int
	// Whether this component is required to be filled (defaults to `true`)
	required bool = true
	// Pre-filled value for this component; max 4000 characters
	value ?string
	// Custom placeholder text if the input is empty; max 100 characters
	placeholder ?string
}

fn (_ TextInput) is_component() {}

pub fn (ti TextInput) build() json2.Any {
	mut r := {
		'type':      ComponentType.text_input.build()
		'custom_id': ti.custom_id
		'style':     ti.style.build()
		'label':     ti.label
		'required':  ti.required
	}
	if min_length := ti.min_length {
		r['min_length'] = min_length
	}
	if max_length := ti.max_length {
		r['max_length'] = max_length
	}
	if value := ti.value {
		r['value'] = value
	}
	if placeholder := ti.placeholder {
		r['placeholder'] = placeholder
	}
	return r
}
