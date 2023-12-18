module discord

import encoding.base64
import log
import os as v_os

pub struct Properties {
pub:
	os      string = v_os.user_os()
	browser string = 'discord.v'
	device  string = 'discord.v'
}

pub const default_user_agent = 'DiscordBot (https://github.com/DarpHome/discord.v, 1.10.0) V ${@VHASH}'

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
	presence   ?Presence
	properties Properties
	intents    Intents
	settings   GatewayClientSettings
}

// `bot` creates a new [GatewayClient] that can be used to listen events.
// Use `launch` to connect to gateway.
// note: token should not contain `Bot` prefix
pub fn bot(token string, config BotConfig) GatewayClient {
	return GatewayClient{
		token: 'Bot ${token}'
		intents: int(config.intents)
		presence: config.presence
		properties: config.properties
		logger: log.Log{
			level: config.get_level()
			output_label: 'discord.v'
		}
		settings: config.settings
		user_agent: config.user_agent
	}
}

// `bearer` accepts access token and returns Client that can be used to fetch user data
// note: token should not contain `Bearer` prefix
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

// `oauth2_app` accepts client ID and secret and returns Client with Basic token
pub fn oauth2_app(client_id Snowflake, client_secret string, config ClientConfig) Client {
	return Client{
		token: 'Basic ' + base64.encode_str('${client_id.build()}:${client_secret}')
		logger: log.Log{
			level: config.get_level()
			output_label: 'discord.v'
		}
		user_agent: config.user_agent
	}
}
