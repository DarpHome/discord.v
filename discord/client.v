module discord

import log
import os as v_os

pub struct Properties {
pub:
	os      string = v_os.user_os()
	browser string = 'discord.v'
	device  string = 'discord.v'
}

pub const default_user_agent = 'DiscordBot (https://github.com/DarpHome/discord.v, 10.0.0) V ${@VHASH}'

@[heap]
pub struct Client {
pub:
	token string

	base_url   string = 'https://discord.com/api/v10'
	user_agent string = discord.default_user_agent
mut:
	logger log.Logger
pub mut:
	user_data voidptr
}

@[params]
pub struct ClientConfig {
pub:
	user_agent string = discord.default_user_agent
	debug      bool
}

fn (config ClientConfig) get_level() log.Level {
	return if config.debug {
		.debug
	} else {
		.info
	}
}

@[params]
pub struct BotConfig {
	ClientConfig
pub:
	properties Properties
	intents    Intents
}

pub fn bot(token string, config BotConfig) GatewayClient {
	return GatewayClient{
		token: 'Bot ${token}'
		intents: int(config.intents)
		properties: config.properties
		logger: log.Log{
			level: config.get_level()
			output_label: 'discord.v'
		}
		user_agent: config.user_agent
	}
}

pub fn bearer(token string, config ClientConfig) Client {
	return Client{
		token: 'Bearer ${token}'
		logger: log.Log{
			level: config.get_level()
			output_label: 'discord.v'
		}
		user_agent: config.user_agent
	}
}
