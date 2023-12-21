module main

import discord

fn run_files(token string) ! {
	mut c := discord.bot(token,
		intents: .message_content | .guild_messages | .direct_messages
	)
	spam := [u8(`A`)].repeat(15483) // after 15484, it crashes
	c.events.on_ready.listen(fn (event discord.ReadyEvent) ! {
		println('Logged as ${event.user.username}! Bot has ${event.guilds.len} guilds')
	})
	c.events.on_message_create.listen(fn [spam] (event discord.MessageCreateEvent) ! {
		content := event.message.content
		println('Recieved a message: ${content}')
		match content {
			'!spam' {
				event.creator.create_message(event.message.channel_id,
					files: [
						discord.File{
							filename: 'spam.txt'
							content_type: 'text/plain'
							data: spam
						},
					]
				)!
			}
			else {}
		}
	})
	c.launch()!
}
