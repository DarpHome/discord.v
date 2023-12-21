module main

import os

fn main() {
	token := os.getenv_opt('DISCORD_BOT_TOKEN') or {
		eprintln('No token specified')
		exit(1)
	}
	arg := os.args[1] or {
		eprintln('No example specified')
		exit(1)
	}
	println('Running ${arg}...')
	match arg {
		'pingpong' {
			run_pingpong(token)!
		}
		'files' {
			run_files(token)!
		}
		'test' {
			run_testbot(token)!
		}
		'interactions' {
			run_interactions(token)!
		}
		'concurrency' {
			run_concurrency(token)!
		}
		else {
			eprintln('Not found')
		}
	}
}
