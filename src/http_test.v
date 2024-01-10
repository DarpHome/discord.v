module discord

import net.http
import os

fn test_http() {
	bot := make_client('Bot ' + os.getenv_opt('TEST_TOKEN') or {
		println('no test token, skipping')
		return
	})
	guild_id := Snowflake(os.getenv('TEST_GUILD').u64())
	channel_id := Snowflake(os.getenv('TEST_CHANNEL').u64())

	// from nyxx
	run_number := os.getenv('GITHUB_RUN_NUMBER')
	actor := os.getenv('GITHUB_ACTOR')
	ref := os.getenv('GITHUB_REF')
	sha := os.getenv('GITHUB_SHA')
	bot.create_message(channel_id,
		content: if run_number == '' {
			'Testing new local build'
		} else {
			'Running dv job `#${run_number}` started by `${actor}` on `${ref}` on commit `${sha}`'
		}
	) or { panic(err) }
	message := bot.create_message(channel_id, content: 'test message') or { panic(err) }
	assert message.content == 'test message'
	message2 := bot.edit_message(channel_id, message.id, content: 'new message') or { panic(err) }
	assert message2.id == message.id
	assert message2.content == 'new message'
	bot.pin_message(channel_id, message.id) or { panic(err) }
	bot.unpin_message(channel_id, message.id) or { panic(err) }
	bot.delete_message(channel_id, message.id) or { panic(err) }
	message3 := bot.create_message(channel_id,
		files: [
			File{
				filename: '1.txt'
				data: 'foo'.bytes()
			},
		]
	) or { panic(err) }
	assert message3.attachments.len == 1
	assert message3.attachments[0].filename == '1.txt'
	assert message3.attachments[0].url != ''
	assert http.get_text(message3.attachments[0].url) == 'foo'
	message4 := bot.create_message(channel_id,
		files: [
			File{
				filename: '2.txt'
				data: 'bar'.bytes()
			},
			File{
				filename: '3.txt'
				data: 'baz'.bytes()
			},
		]
	) or { panic(err) }
	assert message4.attachments.len == 2
	assert message4.attachments[0].filename == '2.txt'
	assert message4.attachments[0].url != ''
	assert http.get_text(message4.attachments[0].url) == 'bar'
	assert message4.attachments[1].filename == '3.txt'
	assert message4.attachments[1].url != ''
	assert http.get_text(message4.attachments[1].url) == 'baz'
	bot.delete_messages(channel_id, [message3.id, message4.id]) or { panic(err) }
	message5 := bot.create_message(channel_id,
		content: 'Components test'
		components: [
			ActionRow{
				components: [
					Button{
						style: .primary
						label: 'Primary'
						custom_id: 'a'
					},
					Button{
						style: .secondary
						label: 'Secondary'
						custom_id: 'b'
					},
					Button{
						style: .success
						label: 'Success'
						custom_id: 'c'
					},
					Button{
						style: .danger
						label: 'Danger'
						custom_id: 'd'
					},
					Button{
						style: .link
						label: 'Link'
						url: 'https://github.com/DarpHome/discord.v'
					},
				]
			},
			ActionRow{
				components: [
					Button{
						style: .primary
						label: 'Primary'
						custom_id: 'e'
						disabled: true
					},
					Button{
						style: .secondary
						label: 'Secondary'
						custom_id: 'f'
						disabled: true
					},
					Button{
						style: .success
						label: 'Success'
						custom_id: 'g'
						disabled: true
					},
					Button{
						style: .danger
						label: 'Danger'
						custom_id: 'h'
						disabled: true
					},
					Button{
						style: .link
						label: 'Link'
						url: 'https://github.com/DarpHome/discord.v'
						disabled: true
					},
				]
			},
			ActionRow{
				components: [
					StringSelect{
						custom_id: 'i'
						options: [
							SelectOption{
								label: 'One'
								value: '1'
							},
							SelectOption{
								label: 'Two'
								value: '2'
								emoji: ComponentEmoji{
									name: '❤️'
								}
							},
							SelectOption{
								label: 'Three'
								value: '3'
							},
						]
					},
				]
			},
		]
	) or { panic(err) }
	assert message5.content == 'Components test'
	components := message5.components or { panic(err) }
	assert components.len == 3
	assert components[0] is ActionRow
	assert components[1] is ActionRow
	assert components[2] is ActionRow
	bot.delete_message(channel_id, message5.id) or { panic(err) }
}
