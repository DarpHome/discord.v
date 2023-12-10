module main

import discord
import os
import x.json2

fn main() {
	token := os.read_file('token.txt')!
	mut c := discord.bot(token,
		intents: .guild_messages | .message_content
	)
	c.on_raw_event.listen(fn (event discord.DispatchEvent[discord.GatewayClient]) ! {
		if event.name == 'MESSAGE_CREATE' {
			dm := event.data.as_map()
			channel_id := dm['channel_id']! as string
			content := dm['content']! as string
			if content.starts_with('!ping') {
        event.creator.request(.post, '/channels/${channel_id}/messages', json: {'content': json2.Any('pong!')})!
			}
		}
	})
	c.launch()!
}