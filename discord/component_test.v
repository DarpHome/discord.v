module discord

import x.json2

fn test_action_row() {
	assert ActionRow{}.build() == json2.Any({
		'type': json2.Any(1)
		'components': []json2.Any{}
	})
	assert ActionRow{components: [ActionRow{}]}.build() == json2.Any({
		'type': json2.Any(1)
		'components': [
			json2.Any({
				'type': json2.Any(1)
				'components': []json2.Any{}
			})
		],
	})
	assert ActionRow.parse({
		'type': json2.Any(1)
		'components': []json2.Any{}
	}) or {
		panic('action row should not return error: ${err}')
	} == ActionRow{components: []}
	assert ActionRow.parse({
		'type': json2.Any(1)
		'components': [
			json2.Any({
				'type': json2.Any(1)
				'components': []json2.Any{}
			})
		],
	}) or {
		panic('action row should not return error: ${err}')
	} == ActionRow{components: [
		ActionRow{components: []}
	]}
}