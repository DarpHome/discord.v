# discord.v

<div align="center">
<img src="assets/logo.png" height=256></img>

Discord API implementation library written in V

[Support server](https://discord.gg/k7rvtQ43cu)
[Documentation](https://darphome.github.io/discord.v/discord.html)

</div>

## Credits

Creator: [nerdarp](https://github.com/DarpHome)

- [spytheman](https://github.com/spytheman) for helping
- [sxqdt](https://github.com/HARXI) for logo

## Examples

### Ping pong


```v
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
```

<blockquote>
Don't forget toggle `Message Content` intent in Developer Portal! Otherwise, your bot will shutdown with error:
```
...
2023-12-21 18:46:20.237000 [ERROR] Websocket closed with 4014 Disallowed intent(s).
2023-12-21 18:46:20.237000 [INFO ] Quit client listener, server(false)...
2023-12-21 18:46:20.238000 [ERROR] Recieved close code 4014: Disallowed intent(s): You sent a disallowed intent for a Gateway Intent. You may have tried to specify an intent that you have not enabled or are not approved for.
V panic: result not set (Disallowed intent(s): You sent a disallowed intent for a Gateway Intent. You may have tried to specify an intent that you have not enabled or are not approved for.)      
...
```
</blockquote>