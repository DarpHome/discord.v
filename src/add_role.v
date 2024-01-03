module main

import discord

fn run_add_role(token string, args []string) ! {
	bot := discord.make_client('Bot ' + token)
	guild_id := discord.Snowflake(args[0] or { return error('no guild id specified') }.u64())
	if guild_id == 0 {
		return error('invalid guild id')
	}
	user_id := discord.Snowflake(args[1] or { return error('no guild id specified') }.u64())
	if user_id == 0 {
		return error('invalid user id')
	}
	role_id := discord.Snowflake(args[2] or { return error('no role id specified') }.u64())
	if role_id == 0 {
		return error('invalid role id')
	}
	bot.add_guild_member_role(guild_id, user_id, role_id,
		reason: if s := args[3] {
			s
		} else {
			none
		}
	)!
}

fn run_remove_role(token string, args []string) ! {
	bot := discord.make_client('Bot ' + token)
	guild_id := discord.Snowflake(args[0] or { return error('no guild id specified') }.u64())
	if guild_id == 0 {
		return error('invalid guild id')
	}
	user_id := discord.Snowflake(args[1] or { return error('no guild id specified') }.u64())
	if user_id == 0 {
		return error('invalid user id')
	}
	role_id := discord.Snowflake(args[2] or { return error('no role id specified') }.u64())
	if role_id == 0 {
		return error('invalid role id')
	}
	bot.remove_guild_member_role(guild_id, user_id, role_id,
		reason: if s := args[3] {
			s
		} else {
			none
		}
	)!
}
