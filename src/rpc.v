module main

import discord
import net.unix

fn run_rpc() ! {
	println('asd')

	// tbh idk how to implement RPC
	mut rpc := discord.new_rpc(unix.connect_stream(r'\\?\pipe\discord-ipc-0') or {
		eprintln('failed to open RPC')
		return err
	}) or {
		eprintln('failed to create rpc')
		return err
	}
	rpc.handshake(1133061734630957207)!
}
