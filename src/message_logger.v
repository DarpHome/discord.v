module main

import discord

fn run_message_logger(token string, _ []string) ! {
	mut c := discord.bot(token,
		cache: discord.Cache{
			messages_max_size1: 0
			messages_max_size2: 0
		}
		intents: .message_content | .guild_messages | .direct_messages
	)
	c.events.on_ready.listen(fn (event discord.ReadyEvent) ! {
		println('Logged as ${event.user.username}! Bot has ${event.guilds.len} guilds')
	})
	c.events.on_message_delete.listen(fn (event discord.MessageDeleteEvent) ! {
		message := event.creator.cache.messages[event.channel_id] or { return }[event.id] or {
			return
		}
		println('Message deleted, with content: ${message.content}')
	})
	c.launch()!
}
