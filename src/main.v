module main

import os

fn main() {
	op := os.args[1] or {
		eprintln('No operation specified (must be bot or rpc)')
		exit(1)
	}
	match op {
		'bot' {
			table := {
				'pingpong':       run_pingpong
				'files':          run_files
				'test':           run_testbot
				'interactions':   run_interactions
				'concurrency':    run_concurrency
				'slash_pingpong': run_slash_pingpong
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
			f(token) or { panic(err) }
		}
		'rpc' {
			run_rpc()!
		}
		else {
			eprintln("I don't know such operation")
			exit(1)
		}
	}
}
