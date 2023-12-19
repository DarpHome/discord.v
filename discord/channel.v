module discord

import net.urllib
import x.json2
import time

@[params]
pub struct ReasonParam {
pub:
	reason ?string
}

pub enum ChannelType {
	// a text channel within a server
	guild_text          = 0
	// a direct message between users
	dm                  = 1
	// a voice channel within a server
	guild_voice         = 2
	// a direct message between multiple users
	group_dm            = 3
	// an organizational category that contains up to 50 channels
	guild_category      = 4
	// a channel that users can follow and crosspost into their own server (formerly news channels)
	guild_announcement  = 5
	// a temporary sub-channel within a GUILD_ANNOUNCEMENT channel
	announcement_thread = 10
	// a temporary sub-channel within a GUILD_TEXT or GUILD_FORUM channel
	public_thread       = 11
	// a temporary sub-channel within a GUILD_TEXT channel that is only viewable by those invited and those with the MANAGE_THREADS permission
	private_thread      = 12
	// a voice channel for hosting events with an audience
	guild_stage_voice   = 13
	// the channel in a hub containing the listed servers
	guild_directory     = 14
	// Channel that can only contain threads
	guild_forum         = 15
	// Channel that can only contain threads, similar to GUILD_FORUM channels
	guild_media         = 16
}

pub interface IChannel {
	id Snowflake
	is_channel()
}

pub struct PartialChannel {
pub:
	id   Snowflake
	typ  ChannelType
	name string
}

fn (_ PartialChannel) is_channel() {}

pub fn PartialChannel.parse(j json2.Any) !PartialChannel {
	match j {
		map[string]json2.Any {
			return PartialChannel{
				id: Snowflake.parse(j['id']!)!
				typ: unsafe { ChannelType(j['type']!.int()) }
				name: j['name']! as string
			}
		}
		else {
			return error('expected partial channel to be object, got ${j.type_name()}')
		}
	}
}

pub enum VideoQualityMode {
	// Discord chooses the quality for optimal performance
	auto = 1
	// 720p
	full
}

@[flag]
pub enum ChannelFlags {
	reserved_0
	// this thread is pinned to the top of its parent `.guild_forum` or `.guild_media` channel
	pinned
	reserved_2
	reserved_3
	// whether a tag is required to be specified when creating a thread in a `.guild_forum` or a `.guild_media` channel. Tags are specified in the `applied_tags` field.
	require_tag
	reserved_5
	reserved_6
	reserved_7
	reserved_8
	reserved_9
	reserved_10
	reserved_11
	reserved_12
	reserved_13
	reserved_14
	hide_media_download_options
}

pub enum SortOrderType {
	// Sort forum posts by activity
	latest_activity
	// Sort forum posts by creation time (from most recent to oldest)
	creation_date
}

pub const sentinel_sort_order_type = unsafe { SortOrderType(sentinel_int) }

pub enum ForumLayoutType {
	// No default has been set for forum channel
	not_set
	// Display posts as a list
	list_view
	// Display posts as a collection of tiles
	gallery_view
}

pub enum PermissionOverwriteType {
	role
	member
}

// See [permissions](#Permissions) for more information about the allow and deny fields.
pub struct PermissionOverwrite {
pub:
	// role or user id
	id Snowflake
	// either 0 (role) or 1 (member)
	typ PermissionOverwriteType
	// permission bit set
	allow Permissions = sentinel_permissions
	// permission bit set
	deny Permissions = sentinel_permissions
}

pub fn PermissionOverwrite.parse(j json2.Any) !PermissionOverwrite {
	match j {
		map[string]json2.Any {
			return PermissionOverwrite{
				id: Snowflake.parse(j['id']!)!
				typ: unsafe { PermissionOverwriteType(j['type']!.int()) }
				allow: Permissions.parse(j['allow']!)!
				deny: Permissions.parse(j['deny']!)!
			}
		}
		else {
			return error('expected permission overwrite to be object, got ${j.type_name()}')
		}
	}
}

pub fn (po PermissionOverwrite) build() json2.Any {
	mut r := {
		'id': json2.Any(po.id.build())
		'type': int(po.typ)
	}
	if !is_sentinel(po.allow) {
		r['allow'] = u64(po.allow).str()
	}
	if !is_sentinel(po.deny) {
		r['deny'] = u64(po.deny).str()
	}
	return r
}

pub const sentinel_permission_overwrites = []PermissionOverwrite{}

pub struct ThreadMetadata {
pub:
	// whether the thread is archived
	archived bool
	// the thread will stop showing in the channel list after auto_archive_duration `minutes` of inactivity, can be set to: 60, 1440, 4320, 10080
	auto_archive_duration time.Duration
	// timestamp when the thread's archive status was last changed, used for calculating recent activity
	archive_timestamp time.Time
	// whether the thread is locked; when a thread is locked, only users with MANAGE_THREADS can unarchive it
	locked bool
	// whether non-moderators can add other non-moderators to a thread; only available on private threads
	invitable ?bool
	// timestamp when the thread was created; only populated for threads created after 2022-01-09
	create_timestamp ?time.Time
}

pub fn ThreadMetadata.parse(j json2.Any) !ThreadMetadata {
	match j {
		map[string]json2.Any {
			return ThreadMetadata{
				archived: j['archived']! as bool
				auto_archive_duration: j['auto_archive_duration']!.int() * time.minute
				archive_timestamp: time.parse_iso8601(j['archive_timestamp']! as string)!
				locked: j['locked']! as bool
				invitable: if b := j['invitable'] {
					?bool(b as bool)
				} else {
					none
				}
				create_timestamp: if s := j['create_timestamp'] {
					if s !is json2.Null {
						?time.Time(time.parse_iso8601(s as string)!)
					} else {
						none
					}
				} else {
					none
				}
			}
		}
		else {
			return error('expected thread metadata to be object, got ${j.type_name()}')
		}
	}
}

pub struct ThreadMember {
pub:
	// ID of the thread
	id ?Snowflake
	// ID of the user
	user_id ?Snowflake
	// Time the user last joined the thread
	join_timestamp time.Time
	// Any user-thread settings, currently only used for notifications
	flags int
	// Additional information about the user
	member ?GuildMember
}

pub fn ThreadMember.parse(j json2.Any) !ThreadMember {
	match j {
		map[string]json2.Any {
			return ThreadMember{
				id: if s := j['id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
				user_id: if s := j['user_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
				join_timestamp: time.parse_iso8601(j['join_timestamp']! as string)!
				flags: j['flags']!.int()
				member: if o := j['member'] {
					?GuildMember(GuildMember.parse(o)!)
				} else {
					none
				}
			}
		}
		else {
			return error('expected thread member to be object, got ${j.type_name()}')
		}
	}
}

pub struct ForumTag {
pub:
	// the id of the tag
	id Snowflake
	// the name of the tag (0-20 characters)
	name string
	// whether this tag can only be added to or removed from threads by a member with the MANAGE_THREADS permission
	moderated bool
	// the id of a guild's custom emoji
	emoji_id ?Snowflake
	// the unicode character of the emoji
	emoji_name ?string
}

pub fn ForumTag.parse(j json2.Any) !ForumTag {
	match j {
		map[string]json2.Any {
			emoji_id := j['emoji_id']!
			emoji_name := j['emoji_name']!
			return ForumTag{
				id: Snowflake.parse(j['id']!)!
				name: j['name']! as string
				moderated: j['moderated']! as bool
				emoji_id: if emoji_id !is json2.Null {
					?Snowflake(Snowflake.parse(emoji_id)!)
				} else {
					none
				}
				emoji_name: if emoji_name !is json2.Null {
					?string(emoji_name as string)
				} else {
					none
				}
			}
		}
		else {
			return error('expected forum tag to be object, got ${j.type_name()}')
		}
	}
}

pub struct EditForumTag {
pub:
	// the id of the tag
	id Snowflake
	// the name of the tag (0-20 characters)
	name ?string
	// whether this tag can only be added to or removed from threads by a member with the MANAGE_THREADS permission
	moderated ?bool
	// the id of a guild's custom emoji
	emoji_id ?Snowflake = sentinel_snowflake
	// the unicode character of the emoji
	emoji_name ?string = sentinel_string
}

pub fn (eft EditForumTag) build() json2.Any {
	mut r := {
		'id': json2.Any(eft.id.build())
	}
	if name := eft.name {
		r['name'] = name
	}
	if moderated := eft.moderated {
		r['moderated'] = moderated
	}
	if emoji_id := eft.emoji_id {
		if !is_sentinel(emoji_id) {
			r['emoji_id'] = emoji_id.build()
		}
	} else {
		r['emoji_id'] = json2.null
	}
	if emoji_name := eft.emoji_name {
		if !is_sentinel(emoji_name) {
			r['emoji_name'] = emoji_name
		}
	} else {
		r['emoji_name'] = json2.null
	}
	return r
}

pub struct DefaultReaction {
pub:
	// the id of a guild's custom emoji
	emoji_id ?Snowflake
	// the unicode character of the emoji
	emoji_name ?string
}

pub fn DefaultReaction.parse(j json2.Any) !DefaultReaction {
	match j {
		map[string]json2.Any {
			emoji_id := j['emoji_id']!
			emoji_name := j['emoji_name']!
			return DefaultReaction{
				emoji_id: if emoji_id !is json2.Null {
					?Snowflake(Snowflake.parse(emoji_id)!)
				} else {
					none
				}
				emoji_name: if emoji_name !is json2.Null {
					?string(emoji_name as string)
				} else {
					none
				}
			}
		}
		else {
			return error('expected default reaction to be object, got ${j.type_name()}')
		}
	}
}

pub fn (dr DefaultReaction) build() json2.Any {
	return {
		'emoji_id': if s := dr.emoji_id {
			json2.Any(s.build())
		} else {
			json2.null
		}
		'emoji_name': if s := dr.emoji_name {
			json2.Any(s)
		} else {
			json2.null
		}
	}
}

pub const sentinel_default_reaction = DefaultReaction{emoji_id: sentinel_snowflake}

pub fn (dr DefaultReaction) is_sentinel() bool {
	return is_sentinel(dr.emoji_id or {
		return false
	})
}

pub struct Channel {
pub:
	// the id of this channel
	id Snowflake
	// the type of channel
	typ ChannelType
	// the id of the guild (may be missing for some channel objects received over gateway guild dispatches)
	guild_id ?Snowflake
	// sorting position of the channel
	position ?int
	// explicit permission overwrites for members and roles
	permission_overwrites ?[]PermissionOverwrite
	// the name of the channel (1-100 characters)
	name ?string
	// the channel topic (0-4096 characters for GUILD_FORUM and GUILD_MEDIA channels, 0-1024 characters for all others)
	topic ?string
	// whether the channel is nsfw
	nsfw ?bool
	// the id of the last message sent in this channel (or thread for GUILD_FORUM or GUILD_MEDIA channels) (may not point to an existing or valid message or thread)
	last_message_id ?Snowflake
	// the bitrate (in bits) of the voice channel
	bitrate ?int
	// the user limit of the voice channel
	user_limit ?int
	// amount of seconds a user has to wait before sending another message (0-21600); bots, as well as users with the permission manage_messages or manage_channel, are unaffected
	rate_limit_per_user ?time.Duration
	// the recipients of the DM
	recipients ?[]User
	// icon hash of the group DM
	icon ?string
	// id of the creator of the group DM or thread
	owner_id ?Snowflake
	// application id of the group DM creator if it is bot-created
	application_id ?Snowflake
	// for group DM channels: whether the channel is managed by an application via the gdm.join OAuth2 scope
	managed ?bool
	// for guild channels: id of the parent category for a channel (each parent category can contain up to 50 channels), for threads: id of the text channel this thread was created
	parent_id ?Snowflake
	// when the last pinned message was pinned. This may be null in events such as GUILD_CREATE when a message is not pinned.
	last_pin_timestamp ?time.Time
	// voice region id for the voice channel, automatic when set to null
	rtc_region ?string
	// the camera video quality mode of the voice channel, 1 when not present
	video_quality_mode ?VideoQualityMode
	// number of messages (not including the initial message or deleted messages) in a thread.
	message_count ?int
	// an approximate count of users in a thread, stops counting at 50
	member_count ?int
	// thread-specific fields not needed by other channels
	thread_metadata ?ThreadMetadata
	// thread member object for the current user, if they have joined the thread, only included on certain API endpoints
	member ?ThreadMember
	// default duration, copied onto newly created threads, in minutes, threads will stop showing in the channel list after the specified period of inactivity, can be set to: 60, 1440, 4320, 10080
	default_auto_archive_duration ?time.Duration
	// computed permissions for the invoking user in the channel, including overwrites, only included when part of the resolved data received on a slash command interaction. This does not include implicit permissions, which may need to be checked separately
	permissions ?Permissions
	// channel flags combined as a bitfield
	flags ?ChannelFlags
	// number of messages ever sent in a thread, it's similar to message_count on message creation, but will not decrement the number when a message is deleted
	total_message_sent ?int
	// the set of tags that can be used in a GUILD_FORUM or a GUILD_MEDIA channel
	available_tags ?[]ForumTag
	// the IDs of the set of tags that have been applied to a thread in a GUILD_FORUM or a GUILD_MEDIA channel
	applied_tags ?[]Snowflake
	// the emoji to show in the add reaction button on a thread in a GUILD_FORUM or a GUILD_MEDIA channel
	default_reaction_emoji ?DefaultReaction
	// the initial rate_limit_per_user to set on newly created threads in a channel. this field is copied to the thread at creation time and does not live update.
	default_thread_rate_limit_per_user ?time.Duration
	// the default sort order type used to order posts in GUILD_FORUM and GUILD_MEDIA channels. Defaults to null, which indicates a preferred sort order hasn't been set by a channel admin
	default_sort_order ?SortOrderType
	// the default forum layout view used to display posts in GUILD_FORUM channels. Defaults to 0, which indicates a layout view has not been set by a channel admin
	default_forum_layout ?ForumLayoutType
}

fn (_ Channel) is_channel() {}

pub fn Channel.parse(j json2.Any) !Channel {
	match j {
		map[string]json2.Any {
			return Channel{
				id: Snowflake.parse(j['id']!)!
				typ: unsafe { ChannelType(j['type']!.int()) }
				guild_id: if s := j['guild_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
				position: if i := j['position'] {
					?int(i.int())
				} else {
					none
				}
				permission_overwrites: if a := j['permission_overwrites'] {
					?[]PermissionOverwrite((a as []json2.Any).map(PermissionOverwrite.parse(it)!))
				} else {
					none
				}
				name: if s := j['name'] {
					if s !is json2.Null {
						?string(s as string)
					} else {
						none
					}
				} else {
					none
				}
				topic: if s := j['topic'] {
					if s !is json2.Null {
						?string(s as string)
					} else {
						none
					}
				} else {
					none
				}
				nsfw: if b := j['nsfw'] {
					?bool(b as bool)
				} else {
					none
				}
				last_message_id: if s := j['last_message_id'] {
					if s !is json2.Null {
						?Snowflake(Snowflake.parse(j)!)
					} else {
						none
					}
				} else {
					none
				}
				bitrate: if i := j['bitrate'] {
					?int(i.int())
				} else {
					none
				}
				user_limit: if i := j['user_limit'] {
					?int(i.int())
				} else {
					none
				}
				rate_limit_per_user: if i := j['rate_limit_per_user'] {
					?time.Duration(i.int() * time.second)
				} else {
					none
				}
				recipients: if a := j['recipients'] {
					?[]User((a as []json2.Any).map(User.parse(it)!))
				} else {
					none
				}
				icon: if s := j['icon'] {
					if s !is json2.Null {
						?string(s as string)
					} else {
						none
					}
				} else {
					none
				}
				owner_id: if s := j['owner_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
				application_id: if s := j['application_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
				managed: if b := j['managed'] {
					?bool(b as bool)
				} else {
					none
				}
				parent_id: if s := j['parent_id'] {
					if s !is json2.Null {
						?Snowflake(Snowflake.parse(s)!)
					} else {
						none
					}
				} else {
					none
				}
				last_pin_timestamp: if s := j['last_pin_timestamp'] {
					if s !is json2.Null {
						?time.Time(time.parse_iso8601(s as string)!)
					} else {
						none
					}
				} else {
					none
				}
				rtc_region: if s := j['rtc_region'] {
					if s !is json2.Null {
						?string(s as string)
					} else {
						none
					}
				} else {
					none
				}
				video_quality_mode: if i := j['video_quality_mode'] {
					?VideoQualityMode(unsafe { VideoQualityMode(i.int()) })
				} else {
					none
				}
				message_count: if i := j['message_count'] {
					?int(i.int())
				} else {
					none
				}
				member_count: if i := j['member_count'] {
					?int(i.int())
				} else {
					none
				}
				thread_metadata: if o := j['thread_metadata'] {
					?ThreadMetadata(ThreadMetadata.parse(o)!)
				} else {
					none
				}
				member: if o := j['member'] {
					?ThreadMember(ThreadMember.parse(o)!)
				} else {
					none
				}
				default_auto_archive_duration: if i := j['default_auto_archive_duration'] {
					?time.Duration(i.int() * time.minute)
				} else {
					none
				}
				permissions: if s := j['permissions'] {
					?Permissions(Permissions.parse(s)!)
				} else {
					none
				}
				flags: if i := j['flags'] {
					?ChannelFlags(unsafe { ChannelFlags(i.int()) })
				} else {
					none
				}
				total_message_sent: if i := j['total_message_sent'] {
					?int(i.int())
				} else {
					none
				}
				available_tags: if a := j['available_tags'] {
					?[]ForumTag((a as []json2.Any).map(ForumTag.parse(it)!))
				} else {
					none
				}
				applied_tags: if a := j['applied_tags'] {
					?[]Snowflake((a as []json2.Any).map(Snowflake.parse(it)!))
				} else {
					none
				}
				default_reaction_emoji: if o := j['default_reaction_emoji'] {
					if o !is json2.Null {
						?DefaultReaction(DefaultReaction.parse(o)!)
					} else {
						none
					}
				} else {
					none
				}
				default_thread_rate_limit_per_user: if i := j['default_thread_rate_limit_per_user'] {
					?time.Duration(i.int() * time.second)
				} else {
					none
				}
				default_sort_order: if i := j['default_sort_order'] {
					if i !is json2.Null {
						?SortOrderType(unsafe { SortOrderType(i.int()) })
					} else {
						none
					}
				} else {
					none
				}
				default_forum_layout: if i := j['default_forum_layout'] {
					unsafe { ForumLayoutType(i.int()) }
				} else {
					none
				}
			}
		}
		else {
			return error('expected channel to be object, got ${j.type_name()}')
		}
	}
}

// Get a channel by ID. Returns a channel object. If the channel is a thread, a thread member object is included in the returned result.
pub fn (c Client) fetch_channel(channel_id Snowflake) !Channel {
	return Channel.parse(json2.raw_decode(c.request(.get, '/channels/${urllib.path_escape((channel_id.build()))}')!.body)!)!
}

pub interface EditChannelParams {
	reason ?string
	is_edit_channel_params()
	build() json2.Any
}

@[params]
pub struct EditGroupDMChannelParams {
pub:
	reason ?string
	// 1-100 character channel name
	name   ?string
	icon   ?Image
}

fn (_ EditGroupDMChannelParams) is_edit_channel_params() {}

pub fn (params EditGroupDMChannelParams) build() json2.Any {
	mut r := map[string]json2.Any{}
	if name := params.name {
		r['name'] = name
	}
	if icon := params.icon {
		r['icon'] = icon.build()
	}
	return r
}

@[params]
pub struct EditGuildChannelParams {
pub:
	reason ?string
	// 1-100 character channel name
	name ?string
	// the type of channel; only conversion between text and announcement is supported and only in guilds with the "NEWS" feature
	typ ?ChannelType
	// the position of the channel in the left-hand listing
	position ?int = sentinel_int
	// 0-1024 character channel topic (0-4096 characters for GUILD_FORUM and GUILD_MEDIA channels)	
	topic ?string = sentinel_string
	// whether the channel is nsfw
	nsfw ?bool = sentinel_bool
	// amount of seconds a user has to wait before sending another message (0-21600); bots, as well as users with the permission manage_messages or manage_channel, are unaffected
	rate_limit_per_user ?time.Duration = sentinel_duration
	// the bitrate (in bits) of the voice or stage channel; min 8000
	bitrate ?int = sentinel_int
	// the user limit of the voice or stage channel, max 99 for voice channels and 10,000 for stage channels (0 refers to no limit)
	user_limit ?int = sentinel_int
	// channel or category-specific permissions
	permission_overwrites ?[]PermissionOverwrite = sentinel_permission_overwrites
	// id of the new parent category for a channel
	parent_id ?Snowflake = sentinel_snowflake
	// channel voice region id, automatic when set to none
	rtc_region ?string = sentinel_string
	// the camera video quality mode of the voice channel
	video_quality_mode ?VideoQualityMode
	// the default duration that the clients use (not the API) for newly created threads in the channel, in minutes, to automatically archive the thread after recent activity
	default_auto_archive_duration ?time.Duration = sentinel_duration
	// channel flags combined as a bitfield. Currently only REQUIRE_TAG (1 << 4) is supported by GUILD_FORUM and GUILD_MEDIA channels. HIDE_MEDIA_DOWNLOAD_OPTIONS (1 << 15) is supported only by GUILD_MEDIA channels
	flags ?ChannelFlags
	// the set of tags that can be used in a GUILD_FORUM or a GUILD_MEDIA channel; limited to 20
	available_tags ?[]EditForumTag
	// the emoji to show in the add reaction button on a thread in a GUILD_FORUM or a GUILD_MEDIA channel
	default_reaction_emoji ?DefaultReaction = sentinel_default_reaction
	// the initial rate_limit_per_user to set on newly created threads in a channel. this field is copied to the thread at creation time and does not live update.
	default_thread_rate_limit_per_user ?time.Duration
	// the default sort order type used to order posts in GUILD_FORUM and GUILD_MEDIA channels
	default_sort_order ?SortOrderType
	// the default forum layout type used to display posts in GUILD_FORUM channels
	default_forum_layout ?ForumLayoutType
}

fn (_ EditGuildChannelParams) is_edit_channel_params() {}

pub fn (params EditGuildChannelParams) build() json2.Any {
	mut r := map[string]json2.Any{}
	if name := params.name {
		r['name'] = name
	}
	if typ := params.typ {
		r['type'] = int(typ)
	}
	if position := params.position {
		if !is_sentinel(position) {
			r['position'] = position
		}
	} else {
		r['position'] = json2.null
	}
	if topic := params.topic {
		if !is_sentinel(topic) {
			r['topic'] = topic
		}
	} else {
		r['topic'] = json2.null
	}
	if nsfw := params.nsfw {
		if !is_sentinel(nsfw) {
			r['nsfw'] = nsfw
		}
	} else {
		r['nsfw'] = json2.null
	}
	if rate_limit_per_user := params.rate_limit_per_user {
		if !is_sentinel(rate_limit_per_user) {
			r['rate_limit_per_user'] = rate_limit_per_user / time.minute
		}
	} else {
		r['rate_limit_per_user'] = json2.null
	}
	if bitrate := params.bitrate {
		if !is_sentinel(bitrate) {
			r['bitrate'] = bitrate
		}
	} else {
		r['bitrate'] = json2.null
	}
	if user_limit := params.user_limit {
		if !is_sentinel(user_limit) {
			r['user_limit'] = user_limit
		}
	} else {
		r['user_limit'] = json2.null
	}
	if permission_overwrites := params.permission_overwrites {
		if permission_overwrites.data != sentinel_permission_overwrites.data {
			r['permission_overwrites'] = permission_overwrites.map(|po| po.build())
		}
	} else {
		r['permission_overwrites'] = json2.null
	}
	if parent_id := params.parent_id {
		if !is_sentinel(parent_id) {
			r['parent_id'] = parent_id.build()
		}
	} else {
		r['parent_id'] = json2.null
	}
	if rtc_region := params.rtc_region {
		if !is_sentinel(rtc_region) {
			r['rtc_region'] = rtc_region
		}
	} else {
		r['rtc_region'] = json2.null
	}
	if video_quality_mode := params.video_quality_mode {
		r['video_quality_mode'] = int(video_quality_mode)
	}
	if default_auto_archive_duration := params.default_auto_archive_duration {
		if !is_sentinel(default_auto_archive_duration) {
			r['default_auto_archive_duration'] = default_auto_archive_duration / time.minute
		}
	} else {
		r['default_auto_archive_duration'] = json2.null
	}
	if flags := params.flags {
		r['flags'] = int(flags)
	}
	if available_tags := params.available_tags {
		r['available_tags'] = available_tags.map(|eft| eft.build())
	}
	if default_reaction_emoji := params.default_reaction_emoji {
		if !default_reaction_emoji.is_sentinel() {
			r['default_reaction_emoji'] = default_reaction_emoji.build()
		}
	} else {
		r['default_reaction_emoji'] = json2.null
	}
	if default_thread_rate_limit_per_user := params.default_thread_rate_limit_per_user {
		r['default_thread_rate_limit_per_user'] = default_thread_rate_limit_per_user / time.second
	}
	if default_sort_order := params.default_sort_order {
		if default_sort_order != sentinel_sort_order_type {
			r['default_sort_order'] = int(default_sort_order)
		}
	} else {
		r['default_sort_order'] = json2.null
	}
	if default_forum_layout := params.default_forum_layout {
		r['default_forum_layout'] = int(default_forum_layout)
	}
	return r
}

@[params]
pub struct EditThreadChannelParams {
pub:
	reason ?string
	// 1-100 character channel name
	name ?string
	// whether the thread is archived
	archived ?bool
	// the thread will stop showing in the channel list after auto_archive_duration minutes of inactivity, can be set to: 60, 1440, 4320, 10080
	auto_archive_duration ?time.Duration = sentinel_duration
	// whether the thread is locked; when a thread is locked, only users with MANAGE_THREADS can unarchive it
	locked ?bool
	// whether non-moderators can add other non-moderators to a thread; only available on private threads
	invitable ?bool
	// amount of seconds a user has to wait before sending another message (0-21600); bots, as well as users with the permission manage_messages, manage_thread, or manage_channel, are unaffected
	rate_limit_per_user ?int = sentinel_int
	// channel flags combined as a bitfield; PINNED can only be set for threads in forum and media channels
	flags ?ChannelFlags
	// the IDs of the set of tags that have been applied to a thread in a GUILD_FORUM or a GUILD_MEDIA channel; limited to 5
	applied_tags ?[]Snowflake
}

fn (_ EditThreadChannelParams) is_edit_channel_params() {}

pub fn (params EditThreadChannelParams) build() json2.Any {
	mut r := map[string]json2.Any{}
	if name := params.name {
		r['name'] = name
	}
	if archived := params.archived {
		r['archived'] = archived
	}
	if auto_archive_duration := params.auto_archive_duration {
		r['auto_archive_duration'] = auto_archive_duration / time.minute
	}
	if flags := params.flags {
		r['flags'] = int(flags)
	}
	if applied_tags := params.applied_tags {
		r['applied_tags'] = applied_tags.map(|s| json2.Any(s.build()))
	}
	return r
}

// Update a channel's settings. Returns a channel on success, and a 400 BAD REQUEST on invalid parameters. All JSON parameters are optional.
pub fn (c Client) edit_channel(channel_id Snowflake, params EditChannelParams) !Channel {
	return Channel.parse(json2.raw_decode(c.request(.patch, '/channels/${urllib.path_escape((channel_id.build()))}',
		reason: params.reason
	)!.body)!)!
}

// Update a group DM channel's settings. Returns a channel on success, and a 400 BAD REQUEST on invalid parameters. All JSON parameters are optional.
pub fn (c Client) edit_group_dm_channel(channel_id Snowflake, params EditGroupDMChannelParams) !Channel {
	return c.edit_channel(channel_id, params)!
}

// Update a guild channel's settings. Returns a channel on success, and a 400 BAD REQUEST on invalid parameters. All JSON parameters are optional.
pub fn (c Client) edit_guild_channel(channel_id Snowflake, params EditGuildChannelParams) !Channel {
	return c.edit_channel(channel_id, params)!
}

// Update a thread's settings. Returns a channel on success, and a 400 BAD REQUEST on invalid parameters. All JSON parameters are optional.
pub fn (c Client) edit_thread_channel(channel_id Snowflake, params EditThreadChannelParams) !Channel {
	return c.edit_channel(channel_id, params)!
}

// Delete a channel, or close a private message. Requires the `MANAGE_CHANNELS` permission for the guild, or `MANAGE_THREADS` if
// the channel is a thread. Deleting a category does not delete its child channels; they will have their parent_id removed and a
// Channel Update Gateway event will fire for each of them. Returns a channel object on success. Fires a Channel Delete Gateway
// event (or Thread Delete if the channel was a thread).
pub fn (c Client) delete_channel(channel_id Snowflake, params ReasonParam) !Channel {
	return Channel.parse(json2.raw_decode(c.request(.delete, '/channels/${urllib.path_escape((channel_id.build()))}',
		reason: params.reason
	)!.body)!)!
}
