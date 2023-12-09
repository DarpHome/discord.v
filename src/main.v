module main

import discord
import os
import x.json2
import net.http

fn main() {
	token := os.read_file('token.txt')!
	mut c := discord.bot(token,
		intents: .guild_messages | .message_content
		debug: true
	)
	dump(c.fetch_user(1073325901825187841)!)
	channel_id := u64(1123273636984401933)
	println('sending message to ${channel_id}...')
	/* {
		println('yes..')
		time.sleep(10 * time.second)
		c.request(.post, '/channels/${channel_id}/messages',
			json: {
				'content':    json2.Any('Test')
				'components': [
					discord.ActionRow{
						components: [
							discord.Button{
								style: .secondary
								label: 'hey'
								custom_id: 'idk'
							},
						]
					}.build(),
				]
			}
		)!
	} */
	// c.launch()!
	json := {
		'content':     json2.Any('Test')
		'attachments': [
			json2.Any({
				'id':          json2.Any(0)
				'description': 'awegawgwa'
				'filename':    'hello.txt'
			}),
			json2.Any({
				'id':          json2.Any(1)
				'description': 'whether i can type here...'
				'filename':    'world.txt'
			}),
		]
	}
	mut h := http.Header{}
	h.set(.authorization, c.token)
	dump(http.post_multipart_form('https://discord.com/api/v10/channels/${channel_id}/messages',
		http.PostMultipartFormConfig{
		header: h
		files: {
			'files[0]':     [
				http.FileData{
					filename: 'hello.txt'
					content_type: 'text/plain'
					data: 'Hello world using multipart POST'
				},
			],
			'files[1]':     [
				http.FileData{
					filename: 'world.txt'
					content_type: 'text/plain'
					data: 'V IS COOLLLLL'
				},
			],
			'payload_json': [
				http.FileData{
					filename: ''
					content_type: 'application/json'
					data: json2.Any(json).json_str()
				},
			]
		}
	})!)
	// c.request(.post, '/channels/${channel_id}/messages')!
}
