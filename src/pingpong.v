module main

import discord

fn run_pingpong(token string) ! {
    mut c := discord.bot(token,
        intents: .message_content | .guild_messages | .direct_messages
    )
    c.events.on_ready.listen(fn (event discord.ReadyEvent) ! {
        println('Logged as ${event.user.username}! Bot has ${event.guilds.len} guilds')
    })
    c.events.on_message_create.listen(fn (event discord.MessageCreateEvent) ! {
        if event.message.content != '!ping' {
            return
        }
        event.creator.create_message(event.message.channel_id, content: 'Pong')!
    })
    c.launch()!
}