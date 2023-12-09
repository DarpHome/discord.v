module main

import discord
import os
import x.json2
import time

fn main() {
	token := os.read_file('token.txt')!
	mut c := discord.bot(token,
		intents: .guild_messages | .message_content
		debug: true
	)
	dump(c.fetch_user(1073325901825187841)!)
	channel_id := u64(1123273636984401933)
	println('sending message to ${channel_id}...')
	{
		println('yes..')
		time.sleep(10 * time.second)
		c.request(.post, '/channels/${channel_id}/messages',
			json: {
				'content':    json2.Any('Test')
				'components': [
					discord.ActionRow{
						components: [
							discord.Button{
								style: .secondary
								label: 'hey'
								custom_id: 'idk'
							},
						]
					}.build(),
				]
			}
		)!
	}
	// c.launch()!
}
