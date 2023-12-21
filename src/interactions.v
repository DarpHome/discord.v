module main

import discord

fn run_interactions(token string) ! {
	mut c := discord.bot(token,
		intents: .message_content | .guild_messages | .direct_messages
	)
	c.events.on_ready.listen(fn (event discord.ReadyEvent) ! {
		println('Logged as ${event.user.username}! Bot has ${event.guilds.len} guilds')
	})
	c.events.on_message_create.listen(fn (event discord.MessageCreateEvent) ! {
		content := event.message.content
		println('Recieved a message: ${content}')
		match content {
			'!buttons' {
				event.creator.create_message(event.message.channel_id,
					content: 'Buttons:'
					components: [
						discord.ActionRow{
							components: [
								discord.Button{
									style: .primary
									custom_id: 'style:primary'
									label: 'Primary'
								},
								discord.Button{
									style: .secondary
									custom_id: 'style:secondary'
									label: 'Secondary'
								},
								discord.Button{
									style: .success
									custom_id: 'style:success'
									label: 'Success'
								},
								discord.Button{
									style: .danger
									custom_id: 'style:danger'
									label: 'Danger'
								},
								discord.Button{
									style: .link
									url: 'https://github.com/DarpHome/discord.v'
									label: 'Link'
								},
							]
						},
						discord.ActionRow{
							components: [
								discord.Button{
									style: .primary
									custom_id: 'disabled:primary'
									label: 'Primary'
									disabled: true
								},
								discord.Button{
									style: .secondary
									custom_id: 'disabled:secondary'
									label: 'Secondary'
									disabled: true
								},
								discord.Button{
									style: .success
									custom_id: 'disabled:success'
									label: 'Success'
									disabled: true
								},
								discord.Button{
									style: .danger
									custom_id: 'disabled:danger'
									label: 'Danger'
									disabled: true
								},
								discord.Button{
									style: .link
									url: 'https://darphome.github.io/discord.v/discord.html'
									label: 'Link'
									disabled: true
								},
							]
						},
						discord.ActionRow{
							components: [
								discord.Button{
									style: .secondary
									custom_id: 'emoji:guild'
									label: 'Guild emoji'
									emoji: discord.PartialEmoji{
										id: 1187456884224045167
										name: 'dv_logo'
									}
								},
								discord.Button{
									style: .secondary
									custom_id: 'emoji:unicode'
									label: 'Unicode emoji'
									emoji: discord.PartialEmoji{
										name: '🐈'
									}
								},
								discord.Button{
									style: .secondary
									custom_id: 'disabled:guild'
									emoji: discord.PartialEmoji{
										id: 1187456884224045167
										name: 'dv_logo'
									}
									disabled: true
								},
								discord.Button{
									style: .secondary
									custom_id: 'disabled:unicode'
									emoji: discord.PartialEmoji{
										name: '🐈'
									}
									disabled: true
								},
							]
						},
					]
				)!
			}
			'!selects' {
				event.creator.create_message(event.message.channel_id,
					content: 'Selects:'
					components: [
						discord.ActionRow{
							components: [
								discord.StringSelect{
									custom_id: 'select:string'
									options: [
										discord.SelectOption{
											label: 'Foo'
											value: 'foo'
										},
										discord.SelectOption{
											label: 'discord.v'
											value: 'discordv'
											emoji: discord.PartialEmoji{
												name: '❤️'
											}
										},
									]
								},
							]
						},
					]
				)!
			}
			else {}
		}
	})
	c.launch()!
}
