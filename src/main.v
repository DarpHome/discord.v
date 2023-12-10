module main

import discord
import os
import strconv
import x.json2

fn main() {
	token := os.read_file('token.txt')!
	mut c := discord.bot(token,
		intents: .guild_messages | .message_content
	)
	c.on_raw_event.listen(fn (event discord.DispatchEvent[discord.GatewayClient]) ! {
		if event.name == 'MESSAGE_CREATE' {
			d := event.data.as_map()
			channel_id := d['channel_id']! as string
			message_id := d['id']! as string
			content := d['content']! as string
			if !content.starts_with('!') {
				return
			}
			args := content[1..].split(' ')
			if args[0] == 'square' {
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
		}
	})
	c.launch()!
}
