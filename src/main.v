module main

import discord
import os
import strconv
import x.json2

fn main() {
	token := os.read_file('token.txt')!
	mut c := discord.bot(token,
		intents: .guild_messages | .message_content
		properties: discord.Properties{
			browser: 'Discord Android'
		}
		debug: true
	)
	c.events.on_ready_event.listen(fn (event discord.ReadyEvent) ! {
		println('Logged as ${event.user.username}!')
	})
	c.events.on_raw_event.listen(fn (event discord.DispatchEvent) ! {
		if event.name == 'MESSAGE_CREATE' {
			d := event.data.as_map()
			channel_id := d['channel_id']! as string
			message_id := d['id']! as string
			content := d['content']! as string
			if !content.starts_with('!') {
				return
			}
			args := content[1..].split(' ')
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
