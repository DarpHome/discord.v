module discord

import net.http
import encoding.base64
import log
import os
import time

pub struct Properties {
pub:
	os      string = os.user_os()
	browser string = 'discord.v'
	device  string = 'discord.v'
}

pub const default_user_agent = 'DiscordBot (https://github.com/DarpHome/discord.v, 1.10.0) V ${@VHASH}'

pub interface HTTPClient {
	is_http_client()
	perform(http.Request) !http.Response
}

@[heap]
pub struct Client {
pub:
	token string

	base_url   string = 'https://discord.com/api/v10'
	user_agent string = discord.default_user_agent
	http       ?HTTPClient
pub mut:
	logger    log.Logger
	user_data map[string]voidptr
}

@[params]
pub struct ClientConfig {
pub:
	debug      bool
	http       ?HTTPClient
	user_agent string = discord.default_user_agent
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
	cache           Cache
	intents         GatewayIntents
	properties      Properties
	large_threshold ?int
	presence        ?UpdatePresenceParams
	read_timeout    ?time.Duration
	settings        GatewayClientSettings
	write_timeout   ?time.Duration
}

// `bot` creates a new [GatewayClient] that can be used to listen events.
// Use `launch` to connect to gateway.
// note: token should not contain `Bot` prefix
pub fn bot(token string, config BotConfig) GatewayClient {
	return GatewayClient{
		token: 'Bot ${token}'
		cache: config.cache
		http: config.http
		intents: int(config.intents)
		properties: config.properties
		large_threshold: config.large_threshold
		presence: config.presence
		logger: log.Log{
			level: config.get_level()
			output_label: 'discord.v'
		}
		read_timeout: config.read_timeout
		settings: config.settings
		user_agent: config.user_agent
		write_timeout: config.write_timeout
	}
}

pub fn make_client(token string, config ClientConfig) Client {
	return Client{
		token: token
		http: config.http
		logger: log.Log{
			level: config.get_level()
			output_label: 'discord.v'
		}
		user_agent: config.user_agent
	}
}

// `bearer` accepts access token and returns Client that can be used to fetch user data
// note: token should not contain `Bearer` prefix
pub fn bearer(token string, config ClientConfig) Client {
	return make_client('Bearer ${token}', config)
}

// `oauth2_app` accepts client ID and secret and returns Client with Basic token
pub fn oauth2_app(client_id Snowflake, client_secret string, config ClientConfig) Client {
	return make_client('Basic ' + base64.encode_str('${client_id.build()}:${client_secret}'),
		config)
}
