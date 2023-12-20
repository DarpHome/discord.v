module main

import discord
import os
import strconv
import x.json2

fn main() {
	token := os.read_lines('token.txt')![0]
	mut c := discord.bot(token,
		intents: .message_content | .guild_messages | .guild_message_typing | .direct_message_typing | .guild_message_reactions | .direct_message_reactions
		presence: discord.Presence{
			activities: [
				discord.Activity{
					typ: .custom
					name: 'Custom Status'
					state: 'Testing discord.v'
				},
			]
			status: .dnd
		}
		settings: .dont_cut_debug
		debug: true
	)
	app := c.fetch_my_application() or { discord.Application{} }
	c.bulk_overwrite_global_application_commands(app.id, [
		discord.CreateApplicationCommandParams{
			name: 'greet'
			description: 'Greet'
			options: [
				discord.ApplicationCommandOption{
					name: 'user'
					description: 'The user to greet'
					typ: .user
				},
			]
		},
	]) or {}
	c.events.on_interaction_create.listen(fn (event discord.InteractionCreateEvent) ! {
		event.creator.create_interaction_response(event.interaction.id, event.interaction.token,
			discord.ModalInteractionResponse{
			title: 'Your favorites?'
			custom_id: 'my_modal'
			components: [
				discord.ActionRow{
					components: [
						discord.TextInput{
							label: 'Favorite color'
							custom_id: 'favorite_color'
						},
					]
				},
				discord.ActionRow{
					components: [
						discord.TextInput{
							label: 'Favorite programming language'
							custom_id: 'favorite_programming_language'
						},
					]
				},
			]
		})!
	})
	c.events.on_ready.listen(fn (event discord.ReadyEvent) ! {
		println('Logged as ${event.user.username}! Bot has ${event.guilds.len} guilds')
	})
	c.events.on_message_create.listen(fn (event discord.MessageCreateEvent) ! {
			prefix := 'dv!'
			if !event.message.content.starts_with(prefix) {
				return
			}
			args := event.message.content[prefix.len..].split(' ')
			match args[0] or { '' } {
				'square' {
					if args.len != 2 {
						event.creator.request(.post, '/channels/${event.message.channel_id}/messages',
							json: {
								'content': json2.Any('Specify argument, e.g. !square 7')
							}
						)!
						return
					}
					i := strconv.atoi(args[1]) or {
						event.creator.request(.post, '/channels/${event.message.channel_id}/messages',
							json: {
								'content': json2.Any('Invalid integer')
							}
						)!
						return
					}
					event.creator.request(.post, '/channels/${event.message.channel_id}/messages',
						json: {
							'content':           json2.Any((i * i).str())
							'message_reference': {
								'message_id': json2.Any(event.message.id)
							}
						}
					)!
				}
				'ping' {
					event.creator.request(.post, '/channels/${event.message.channel_id}/messages',
						json: {
							'content':           json2.Any('Pong!')
							'message_reference': {
								'message_id': json2.Any(event.message.id)
							}
						}
					)!
				}
				'guild' {
					guild_id := event.message.guild_id
					dump(event.creator.fetch_guild(guild_id or {
						event.creator.request(.post, '/channels/${event.message.channel_id}/messages',
							json: {
								'content':           json2.Any('Not an guild')
								'message_reference': {
									'message_id': json2.Any(event.message.id)
								}
							}
						)!
						return
					})!)
					event.creator.request(.post, '/channels/${event.message.channel_id}/messages',
						json: {
							'content':           json2.Any('Dumped!')
							'message_reference': {
								'message_id': json2.Any(event.message.id)
							}
						}
					)!
				}
				else {}
			}
	})
	/*c.events.on_raw_event.listen(fn (event discord.DispatchEvent) ! {
		dump(event.name)
	})*/
	c.launch()!
}
