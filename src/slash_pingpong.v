module main

import discord

fn run_slash_pingpong(token string) ! {
	mut c := discord.bot(token)
	c.events.on_ready.listen(fn (event discord.ReadyEvent) ! {
		println('Logged as ${event.user.username}! Bot has ${event.guilds.len} guilds')
	})
	c.bulk_overwrite_global_application_commands(discord.extract_id_from_token(token)!,
		[
		discord.CreateApplicationCommandParams{
			name: 'ping'
			description: 'Pong!'
		},
	])!
	c.events.on_interaction_create.listen(fn (event discord.InteractionCreateEvent) ! {
		i := event.interaction
		if i.typ != .application_command {
			return
		}
		d := i.get_application_command_data()!
		if d.name != 'ping' {
			return
		}
		event.creator.create_interaction_response(i.id, i.token, discord.MessageInteractionResponse{
			content: 'Pong!'
		})!
	})
	c.launch()!
}
