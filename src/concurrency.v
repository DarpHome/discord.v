module main

import discord
import strconv
import time

fn run_concurrency(token string) ! {
	mut c := discord.bot(token,
		intents: .message_content | .guild_messages | .direct_messages
	)
	c.events.on_ready.listen(fn (event discord.ReadyEvent) ! {
		println('Logged as ${event.user.username}! Bot has ${event.guilds.len} guilds')
	})
	c.events.on_message_create.listen(fn (event discord.MessageCreateEvent) ! {
		match event.message.content {
			'!mystery' {
				message := event.creator.create_message(event.message.channel_id,
					content: 'I will delete that messsge after 5 seconds...'
				)!
				time.sleep(5 * time.second)
				event.creator.delete_message(message.channel_id, message.id)!
			}
			'!sum' {
				event.creator.create_message(event.message.channel_id,
					content: "OK, Let's sum two numbers.\nType your first number, you have 10 seconds..."
				)!
				mut controller := &event.creator.events.on_message_create
				author_id := event.message.author.id
				mut ax := controller.wait(
					check: fn [author_id] (event discord.MessageCreateEvent) bool {
						return event.message.author.id == author_id
					}
					timeout: 10 * time.second
				)
				x := strconv.parse_int(ax.do() or {
					event.creator.create_message(event.message.channel_id,
						content: "I didn't get your first number..."
					)!
					return
				}.message.content, 10, 32) or {
					event.creator.create_message(event.message.channel_id,
						content: 'I got invalid number...'
					)!
					return
				}
				event.creator.create_message(event.message.channel_id,
					content: 'Type your second number, you have 10 seconds...'
				)!
				mut ay := controller.wait(
					check: fn [author_id] (event discord.MessageCreateEvent) bool {
						return event.message.author.id == author_id
					}
					timeout: 10 * time.second
				)
				y := strconv.parse_int(ay.do() or {
					event.creator.create_message(event.message.channel_id,
						content: "I didn't get your second number..."
					)!
					return
				}.message.content, 10, 32) or {
					event.creator.create_message(event.message.channel_id,
						content: 'I got invalid number...'
					)!
					return
				}
				event.creator.create_message(event.message.channel_id,
					content: 'The sum of ${x} and ${y} is ${x + y}.'
				)!
			}
			else {}
		}
	})
	c.launch()!
}
