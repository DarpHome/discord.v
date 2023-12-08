module main

import discord
import os
import x.json2

fn main() {
	token := os.read_file('token.txt')!
	mut c := discord.bot(token) //, discord.intents(.guild_messages, .message_content))
	channel_id := u64(1123273636984401933)
	println('sending message to ${channel_id}...')
	c.request(.post, '/channels/${channel_id}/messages',
		json: {
			'content':    json2.Any('Test')
			'components': [
				json2.Any({
					'type':       json2.Any(1)
					'components': [
						json2.Any({
							'type':      json2.Any(2)
							'style':     2
							'label':     'hey'
							'custom_id': 'idk'
						}),
					]
				}),
			]
		}
	)!
	// c.launch()!
}
