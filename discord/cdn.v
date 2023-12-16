module discord

import net.urllib

pub const default_cdn_url = 'https://cdn.discordapp.com'

pub struct CDN {
pub:
	base string
}

@[params]
pub struct NewCDNParams {
pub:
	base string = default_cdn_url
}

pub fn new_cdn(params NewCDNParams) CDN {
	return CDN{
		base: params.base.trim_right('/')
	}
}

pub enum ImageFormat {
	png
	jpg
	jpeg
	webp
	lottie
	gif
}

fn cdn_build_ext(format ?ImageFormat) string {
	return if x := format {
		match x {
			.png { 'png' }
			.jpg { 'jpg' }
			.jpeg { 'jpeg' }
			.webp { 'webp' }
			.lottie { 'json' }
			.gif { 'gif' }
		}
	} else {
		'png'
	}
}

fn cdn_build_filename(filename string, format ?ImageFormat) string {
	if filename.starts_with('a_') {
		return urllib.path_escape(filename) + '.gif'
	}
	return urllib.path_escape(filename) + '.' + cdn_build_ext(format)
}

@[params]
pub struct CDNGetParams {
pub:
	format ?ImageFormat
	size ?int
}

pub fn (params CDNGetParams) build() string {
	mut vs := urllib.new_values()
	if size := params.size {
		vs.set('size', size.str())
	}
	s := vs.encode()
	return '.${cdn_build_ext(params.format)}' + (if s == '' { '' } else { '?' + s })
}

pub fn (c CDN) custom_emoji(emoji_id Snowflake, params CDNGetParams) string {
	return '${c.base}/emojis/${urllib.path_escape(emoji_id.build())}${params.build()}'
}

pub fn (c CDN) guild_icon(guild_id Snowflake, guild_icon string, params CDNGetParams) string {
	return '${c.base}/icons/${urllib.path_escape(guild_id.build())}/${urllib.path_escape(guild_icon)}${params.build()}'
}

pub fn (c CDN) guild_splash(guild_id Snowflake, guild_icon string, params CDNGetParams) string {
	return '${c.base}/icons/${urllib.path_escape(guild_id.build())}/${urllib.path_escape(guild_icon)}${params.build()}'
}

pub fn (c CDN) guild_discovery_splash(guild_id Snowflake, guild_icon string, params CDNGetParams) string {
	return '${c.base}/discovery-splashes/${urllib.path_escape(guild_id.build())}/${urllib.path_escape(guild_icon)}${params.build()}'
}

pub fn (c CDN) guild_banner(guild_id Snowflake, guild_banner string, params CDNGetParams) string {
	return '${c.base}/banners/${urllib.path_escape(guild_id.build())}/${urllib.path_escape(guild_banner)}${params.build()}'
}

pub fn (c CDN) user_banner(user_id Snowflake, user_banner string, params CDNGetParams) string {
	return '${c.base}/banners/${urllib.path_escape(user_id.build())}/${urllib.path_escape(user_banner)}${params.build()}'
}

pub fn (c CDN) default_user_avatar(index int) string {
	return '${c.base}/embed/avatars/${urllib.path_escape(index.str())}.png'
}

pub fn (c CDN) user_avatar(user_id Snowflake, user_avatar string, params CDNGetParams) string {
	return '${c.base}/avatars/${urllib.path_escape(user_id.build())}/${urllib.path_escape(user_avatar)}${params.build()}'
}

pub fn (c CDN) guild_member_avatar(guild_id Snowflake, user_id Snowflake, member_avatar string, params CDNGetParams) string {
	return '${c.base}/guilds/${urllib.path_escape(guild_id.build())}/users/${urllib.path_escape(user_id.build())}/avatars/${urllib.path_escape(member_avatar)}${params.build()}'
}

pub fn (c CDN) user_avatar_decoration(user_id Snowflake, user_avatar_decoration string, params CDNGetParams) string {
	return '${c.base}/avatar-decorations/${urllib.path_escape(user_id.build())}/${urllib.path_escape(user_avatar_decoration)}${params.build()}'
}

pub fn (c CDN) application_icon(application_id Snowflake, icon string, params CDNGetParams) string {
	return '${c.base}/app-icons/${urllib.path_escape(application_id.build())}/${urllib.path_escape(icon)}${params.build()}'
}

pub fn (c CDN) application_cover(application_id Snowflake, cover_image string, params CDNGetParams) string {
	return '${c.base}/app-icons/${urllib.path_escape(application_id.build())}/${urllib.path_escape(cover_image)}${params.build()}'
}

pub fn (c CDN) application_asset(application_id Snowflake, asset_id string, params CDNGetParams) string {
	return '${c.base}/app-assets/${urllib.path_escape(application_id.build())}/${urllib.path_escape(asset_id)}${params.build()}'
}

pub fn (c CDN) achievement_icon(application_id Snowflake, achievement_id string, icon_hash string, params CDNGetParams) string {
	return '${c.base}/app-assets/${urllib.path_escape(application_id.build())}/achievements/${urllib.path_escape(achievement_id)}/icons/${urllib.path_escape(icon_hash)}${params.build()}'
}

pub fn (c CDN) store_page_asset(application_id Snowflake, asset_id string, params CDNGetParams) string {
	return '${c.base}/app-assets/${urllib.path_escape(application_id.build())}/store/${urllib.path_escape(asset_id)}${params.build()}'
}

pub fn (c CDN) sticker_pack_banner(application_id Snowflake, sticker_pack_banner_asset_id Snowflake, params CDNGetParams) string {
	return '${c.base}/app-assets/710982414301790216/store/${urllib.path_escape(sticker_pack_banner_asset_id.build())}${params.build()}'
}

pub fn (c CDN) team_icon(team_id Snowflake, team_icon string, params CDNGetParams) string {
	return '${c.base}/team-icons/${urllib.path_escape(team_id.build())}/${urllib.path_escape(team_icon)}${params.build()}'
}

pub fn (c CDN) sticker(sticker_id Snowflake, params CDNGetParams) string {
	return '${c.base}/stickers/${urllib.path_escape(sticker_id.build())}${params.build()}'
}

pub fn (c CDN) role_icon(role_id Snowflake, role_icon string, params CDNGetParams) string {
	return '${c.base}/role-icons/${urllib.path_escape(role_id.build())}/${urllib.path_escape(role_icon)}'
}

pub fn (c CDN) guild_scheduled_event_cover(scheduled_event_id Snowflake, scheduled_event_cover_image string, params CDNGetParams) string {
	return '${c.base}/guild-events/${urllib.path_escape(scheduled_event_id.build())}/${urllib.path_escape(scheduled_event_cover_image)}${params.build()}'
}

pub fn (c CDN) guild_member_banner(guild_id Snowflake, user_id Snowflake, member_banner string, params CDNGetParams) string {
	return '${c.base}/guilds/${urllib.path_escape(guild_id.build())}/users/${urllib.path_escape(user_id.build())}/banners/${urllib.path_escape(member_banner)}${params.build()}'
}

pub const cdn = new_cdn()