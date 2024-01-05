module main

import discord
import math
import os
import time

fn main() {
	op := os.args[1] or {
		eprintln('No operation specified (must be bot or rpc)')
		exit(1)
	}
	dump(sizeof(discord.GatewayClient))
	dump(sizeof(discord.Client))
	match op {
		'bot' {
			table := {
				'pingpong':       run_pingpong
				'files':          run_files
				'test':           run_testbot
				'interactions':   run_interactions
				'concurrency':    run_concurrency
				'slash-pingpong': run_slash_pingpong
				'add-role':       run_add_role
				'remove-role':    run_remove_role
			}
			arg1 := os.args[2] or {
				eprintln('No example specified (may be ${table.keys().join(', ')})')
				exit(1)
			}
			f := table[arg1] or {
				eprintln('That example not exists (may be ${table.keys().join(', ')})')
				exit(1)
			}
			println('Running ${arg1}...')
			token := os.getenv_opt('DISCORD_BOT_TOKEN') or {
				eprintln('No token specified')
				exit(1)
			}
			f(token, os.args[3..]) or { panic(err) }
		}
		'rpc' {
			run_rpc()!
		}
		'diff' {
			x := discord.Snowflake(os.args[2] or {
				eprintln('no first snowflake')
				exit(1)
			}.u64())
			if x == 0 {
				eprintln('first snowflake is invalid')
				exit(1)
			}
			y := discord.Snowflake(os.args[3] or {
				eprintln('no second snowflake')
				exit(1)
			}.u64())
			if y == 0 {
				eprintln('first snowflake is invalid')
				exit(1)
			}
			diff := math.abs(x.timestamp().unix_time_milli() - y.timestamp().unix_time_milli())
			println('Got ${time.Duration(diff * time.millisecond)}')
		}
		else {
			eprintln("I don't know such operation")
			exit(1)
		}
	}
}
