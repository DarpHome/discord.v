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
	c.events.on_ready.listen(fn (event discord.ReadyEvent) ! {
		println('Logged as ${event.user.username}! Bot has ${event.guilds.len} guilds')
	})
	c.events.on_raw_event.listen(fn (event discord.DispatchEvent) ! {
		if event.name == 'MESSAGE_CREATE' {
			d := event.data.as_map()
			channel_id := d['channel_id']! as string
			message_id := d['id']! as string
			content := d['content']! as string
			prefix := 'dv!'
			if !content.starts_with(prefix) {
				return
			}
			args := content[prefix.len..].split(' ')
			match args[0] or { '' } {
				'square' {
					if args.len != 2 {
						event.creator.request(.post, '/channels/${channel_id}/messages',
							json: {
								'content': json2.Any('Specify argument, e.g. !square 7')
							}
						)!
						return
					}
					i := strconv.atoi(args[1]) or {
						event.creator.request(.post, '/channels/${channel_id}/messages',
							json: {
								'content': json2.Any('Invalid integer')
							}
						)!
						return
					}
					event.creator.request(.post, '/channels/${channel_id}/messages',
						json: {
							'content':           json2.Any((i * i).str())
							'message_reference': {
								'message_id': json2.Any(message_id)
							}
						}
					)!
				}
				'ping' {
					event.creator.request(.post, '/channels/${channel_id}/messages',
						json: {
							'content':           json2.Any('Pong!')
							'message_reference': {
								'message_id': json2.Any(message_id)
							}
						}
					)!
				}
				'guild' {
					guild_id := discord.Snowflake.parse(d['guild_id']!)!
					dump(event.creator.fetch_guild(guild_id)!)
					event.creator.request(.post, '/channels/${channel_id}/messages',
						json: {
							'content':           json2.Any('Dumped!')
							'message_reference': {
								'message_id': json2.Any(message_id)
							}
						}
					)!
				}
				else {}
			}
		}
	})
	c.launch()!
}
