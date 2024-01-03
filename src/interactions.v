module main

import discord

fn run_interactions(token string, _ []string) ! {
	mut c := discord.bot(token,
		intents: .message_content | .guild_messages | .direct_messages
	)
	c.events.on_ready.listen(fn (event discord.ReadyEvent) ! {
		println('Logged as ${event.user.username}! Bot has ${event.guilds.len} guilds')
	})
	c.bulk_overwrite_global_application_commands(discord.extract_id_from_token(token)!,
		[
		discord.CreateApplicationCommandParams{
			name: 'greet'
			description: 'Greet someone'
			options: [
				discord.ApplicationCommandOption{
					typ: .user
					name: 'user'
					description: 'The user to greet'
					required: true
				},
			]
		},
	])!
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
								discord.Button{
									style: .primary
									custom_id: 'open_modal'
									label: 'Open modal'
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
						discord.ActionRow{
							components: [
								discord.RoleSelect{
									custom_id: 'select:roles'
									placeholder: 'Select roles'
									max_values: 10
								},
							]
						},
					]
				)!
			}
			else {}
		}
	})
	c.events.on_interaction_create.listen(fn (event discord.InteractionCreateEvent) ! {
		i := event.interaction
		match i.typ {
			.application_command {
				d := i.get_application_command_data()!
				if d.name == 'greet' {
					target := discord.Snowflake((d.get('user') or { return }).as_string().u64())
					source := i.get_user().id
					if target == source {
						event.creator.create_interaction_response(i.id, i.token, discord.MessageInteractionResponse{
							content: 'You cannot greet yourself.'
							flags: .ephemeral
						})!
						return
					}
					event.creator.create_interaction_response(i.id, i.token, discord.MessageInteractionResponse{
						content: 'Greetings, <@${target}>, from <@${source}>!'
					})!
				}
			}
			.message_component {
				d := i.get_message_component_data()!
				a := d.custom_id.split(':')
				match a[0] {
					'style' {
						event.creator.create_interaction_response(i.id, i.token, discord.MessageInteractionResponse{
							content: 'You clicked on button with ${a[1]} style!'
						})!
					}
					'emoji' {
						event.creator.create_interaction_response(i.id, i.token, discord.MessageInteractionResponse{
							content: 'You clicked on button with ${a[1]} emoji!'
						})!
					}
					'open_modal' {
						event.creator.create_interaction_response(i.id, i.token, discord.ModalInteractionResponse{
							title: 'My Cool Modal'
							custom_id: 'my_cool_modal'
							components: [
								discord.ActionRow{
									components: [
										discord.TextInput{
											custom_id: 'name'
											label: 'Name'
										},
									]
								},
							]
						})!
					}
					'select' {
						vs := d.values or { [] }
						event.creator.create_interaction_response(i.id, i.token, discord.MessageInteractionResponse{
							content: 'You selected: ${vs.join(', ')}'
						})!
					}
					else {}
				}
			}
			.modal_submit {
				d := i.get_modal_submit_data()!
				name := d.get('name') or { '' }
				event.creator.create_interaction_response(i.id, i.token, discord.MessageInteractionResponse{
					content: 'Your name is **${name}**.'
				})!
			}
			else {}
		}
	})
	c.launch()!
}
