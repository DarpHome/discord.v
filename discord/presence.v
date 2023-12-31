module discord

import time
import x.json2

pub enum ActivityType {
	// Playing {name}: "Playing Rocket League"
	game      = 0
	// Streaming {details}: "Streaming Rocket League"
	streaming
	// Listening to {name}: "Listening to Spotify"
	listening
	// Watching {name}: "Watching YouTube Together"
	watching
	// {emoji} {state}: ":smiley: I am cool"
	custom
	// Competing in {name}: "Competing in Arena World Champions"
	competing
}

pub struct ActivityTimestamps {
pub:
	// Unix time (in milliseconds) of when the activity started
	start ?time.Time
	// Unix time (in milliseconds) of when the activity ends
	end ?time.Time
}

pub struct ActivityParty {
pub:
	// ID of the party
	id ?Snowflake
	// Used to show the party's current and maximum size
	current_size ?int
	// Used to show the party's current and maximum size
	max_size ?int
}

pub struct ActivityAssets {
pub:
	// See [Activity Asset Image](https://discord.com/developers/docs/topics/gateway-events#activity-object-activity-asset-image)
	large_image ?string
	// Text displayed when hovering over the large image of the activity
	large_text ?string
	// // See [Activity Asset Image](https://discord.com/developers/docs/topics/gateway-events#activity-object-activity-asset-image)
	small_image ?string
	// Text displayed when hovering over the small image of the activity
	small_text ?string
}

pub struct ActivitySecrets {
pub:
	// Secret for joining a party
	join ?string
	// Secret for spectating a game
	spectate ?string
	// Secret for a specific instanced match
	match_ ?string
}

@[flag]
pub enum ActivityFlags {
	instance
	join
	spectate
	join_request
	sync
	play
	party_privacy_frineds
	party_privacy_voice_channel
	embedded
}

pub struct ActivityButton {
pub:
	// Text shown on the button (1-32 characters)
	label string
	// URL opened when clicking the button (1-512 characters)
	url string
}

pub struct Activity {
pub:
	// Activity's name
	name string
	// Activity type
	typ ActivityType @[required]
	// Stream URL, is validated when type is 1
	url ?string = sentinel_string
	// Unix timestamp (in milliseconds) of when the aactivity was added to the user's session
	created_at time.Time
	// Unix timestamps for start and/or end of the game
	timestamps ?ActivityTimestamps
	// Application ID for the game
	application_id ?Snowflake
	// What the player is currently doing
	details ?string
	// User's current party status, or text used for a custom status
	state ?string = sentinel_string
	// Emoji used for a custom status
	emoji ?PartialEmoji
	// Information for the current party of the player
	party ?ActivityParty
	// Images for the presence and their hover texts
	assets ?ActivityAssets
	// Secrets for Rich Presence joining and spectating
	secrets ?ActivitySecrets
	// Whether or not the activity is an instanced game session
	instance ?bool
	// Activity flags `OR`d together, describes what the payload includes
	flags ?ActivityFlags
	// Custom buttons shown in the Rich Presence (max 2)
	buttons ?[]ActivityButton
}

pub fn (a Activity) build() json2.Any {
	mut r := {
		'name': json2.Any(a.name)
		'type': int(a.typ)
	}
	if url := a.url {
		if !is_sentinel(url) {
			r['url'] = url
		}
	} else {
		r['url'] = json2.null
	}
	if state := a.state {
		if !is_sentinel(state) {
			r['state'] = state
		}
	} else {
		r['state'] = json2.null
	}
	return r
}

pub enum Status {
	// Online (Green)
	online
	// Do Not Disturb (Red)
	dnd
	// AFK (Yellow)
	idle
	// Invisible and shown as offline (Gray)
	invisible
	// Offline (Gray)
	offline
}

pub fn (s Status) build() string {
	return match s {
		.online { 'online' }
		.dnd { 'dnd' }
		.idle { 'idle' }
		.invisible { 'invisble' }
		.offline { 'offline' }
	}
}

pub struct Presence {
pub:
	// Unix time (in milliseconds) of when the client went idle, or null if the client is not idle
	since ?time.Time
	// User's activities
	activities []Activity
	// User's new status
	status Status = .online
	// Whether or not the client is afk
	afk bool
}

pub fn (p Presence) build() json2.Any {
	return {
		'since':      if since := p.since {
			json2.Any(since.unix_time_milli())
		} else {
			json2.null
		}
		'activities': p.activities.map(|a| a.build())
		'status':     p.status.build()
		'afk':        p.afk
	}
}
