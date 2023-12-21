module main

import os

fn main() {
	token := os.getenv_opt('DISCORD_BOT_TOKEN') or {
		eprintln('No token specified')
		exit(1)
	}
	match os.args[1] or {
		eprintln('No example specified')
		exit(1)
	} {
		'pingpong' {
			run_pingpong(token)!
		}
		'test' {
			run_testbot(token)!
		}
		else {}
	}
}
