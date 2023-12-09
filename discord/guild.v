module discord

import time
import x.json2

pub type GuildFeature = string

pub struct PartialGuild {
pub:
	id                         Snowflake
	name                       string
	icon                       ?string
	owner                      bool
	permissions                Permissions
	features                   []GuildFeature
	approximate_member_count   ?int
	approximate_presence_count ?int
}

pub enum VerificationLevel {
	none_
	low
	medium
	high
	very_high
}

pub enum MessageNotificationsLevel {
	all_messages
	only_mentions
}

pub enum ExplicitContentFilterLevel {
	disabled
	members_without_roles
	all_members
}

pub enum MFALevel {
	none_
	elevated
}

pub struct RoleTags {
pub:
	// the id of the bot this role belongs to
	bot_id ?Snowflake
	// the id of the integration this role belongs to
	integration_id ?Snowflake
	// whether this is the guild's Booster role
	premium_subscriber bool
	// the id of this role's subscription sku and listing
	subscription_listing_id ?Snowflake
	// whether this role is available for purchase
	available_for_purchase bool
	// whether this role is a guild's linked role
	guild_connections bool
}

pub fn RoleTags.parse(j json2.Any) !RoleTags {
	match j {
		map[string]json2.Any {
			return RoleTags{
				bot_id: if s := j['bot_id'] {
					Snowflake.parse(s)!
				} else {
					none
				}
				integration_id: if s := j['integration_id'] {
					Snowflake.parse(s)!
				} else {
					none
				}
				premium_subscriber: 'premium_subscriber' in j
				subscription_listing_id: if s := j['subscription_listing_id'] {
					Snowflake.parse(s)!
				} else {
					none
				}
				available_for_purchase: 'available_for_purchase' in j
				guild_connections: 'guild_connections' in j
			}
		}
		else {
			return error('expected role tags to be object, got ${j.type_name()}')
		}
	}
}

@[flag]
pub enum RoleFlags {
	// role can be selected by members in an onboarding prompt
	in_prompt
}

pub struct Role {
pub:
	// role id
	id Snowflake
	// role name
	name string
	// integer representation of hexadecimal color code
	color int
	// if this role is pinned in the user listing
	hoist bool
	// role icon hash
	icon ?string
	// role unicode emoji
	unicode_emoji ?string
	// position of this role
	position int
	// permission bit set
	permissions Permissions
	// whether this role is managed by an integrations
	managed bool
	// whether this role is mentionable
	mentionable bool
	// the tags this role has
	tags ?RoleTags
	// role flags combined as a bitfield
	flags RoleFlags
}

pub fn Role.parse(j json2.Any) !Role {
	match j {
		map[string]json2.Any {
			return Role{
				id: Snowflake.parse(j['id']!)!
				name: j['name']! as string
				color: int(j['color']! as i64)
				hoist: j['hoist']! as bool
				icon: if s := j['icon'] {
					if s is string {
						s
					} else {
						none
					}
				} else {
					none
				}
				unicode_emoji: if s := j['unicode_emoji'] {
					if s is string {
						s
					} else {
						none
					}
				} else {
					none
				}
				position: int(j['position']! as i64)
				permissions: unsafe { Permissions(j['permissions']! as string) }
				managed: j['managed']! as bool
				mentionable: j['mentionable']! as bool
				tags: if o := j['tags'] {
					RoleTags.parse(o)!
				} else {
					none
				}
				flags: unsafe { RoleFlags(j['flags']! as i64) }
			}
		}
		else {
			return error('expected role to be object, got ${j.type_name()}')
		}
	}
}

@[flag]
pub enum SystemChannelFlags {
	suppress_join_notifications
	suppress_premium_subscriptions
	suppress_guild_reminder_notifications
	suppress_join_notification_replies
	suppress_role_subscription_purchase_notifications
	suppress_role_subscription_purchase_notifications_replies
}

pub enum PremiumTier {
	none_
	tier_1
	tier_2
	tier_3
}

pub enum NSFWLevel {
	default
	explicit
	safe
	age_restricted
}

pub struct WelcomeChannel {
pub:
	// the channel's id
	channel_id ?Snowflake
	// the description shown for the channel
	description string
	// the emoji id, if the emoji is custom
	emoji_id ?Snowflake
	// the emoji name if custom, the unicode character if standard, or `none` if no emoji is set
	emoji_name ?string
}

pub struct WelcomeScreen {
pub:
	// the server description shown in the welcome screen
	description ?string
	// the channels shown in the welcome screen, up to 5
	welcome_channels []WelcomeChannel
}

pub struct Guild {
pub:
	// guild id
	id Snowflake
	// guild name (2-100 characterrs, excluding trailing and leading whitespace)
	name string
	// icon hash
	icon ?string
	// icon hash, returned when in the template object
	icon_hash ?string
	// splash hash
	splash ?string
	// discovery splash hash; only present for guilds with the "DISCOVERABLE" feature
	discovery_splash ?string
	// id of owner
	owner_id Snowflake
	// id of afk channel
	afk_channel_id ?Snowflake
	// afk timeout
	afk_timeout time.Duration
	// true if the server widget is enabled
	widget_enabled ?bool
	// the channel id that the widget will generate an invite to, or `none` if set to no invite
	widget_channel_id ?Snowflake
	// verification level required for the guild
	verification_level VerificationLevel
	// default message notifications level
	default_message_notifications MessageNotificationsLevel
	// explicit content filter level
	explicit_content_filter ExplicitContentFilterLevel
	// roles in the guild
	roles []Role
	// custom guild emojis
	emojis []Emoji
	// enabled guild features
	features []GuildFeature
	// required MFA level for the guild
	mfa_level MFALevel
	// application id of the guild creator if it is bot-created
	application_id ?Snowflake
	// the id of the channel where guild notices such as welcome messages and boost events are posted
	system_channel_id ?Snowflake
	// system channel flags
	system_channel_flags SystemChannelFlags
	// the id of the channel where Community guilds can display rules and/or guidelines
	rules_channel_id ?Snowflake
	// the maximum number of presences for the guild (`none` is always returned, apart from largest of guilds)
	max_presences ?int
	// the maximum number of members for the guild
	max_members ?int
	// the vanity url code for the guild
	vanity_url_code ?string
	// the description of a guild
	description ?string
	// banner hash
	banner ?string
	// premium tier (Server Boost level)
	premium_tier PremiumTier
	// the number of boosts this guild currently has
	premium_subscription_count ?int
	// the preferred locale of a Community guild; used in server discovery and notices from Discord, and sent in interactions; defaults to "en-US"
	preferred_locale string
	// the id of the channel where admins and moderators of Community guilds receive notices from Discord
	public_updates_channel_id ?Snowflake
	// the maximum amount of users in a video channel
	max_video_channel_users ?int
	// // the maximum amount of users in a stage video channel
	max_stage_video_channel_users ?int
	// approximate number of members in this guild, returned from the `GET /guilds/<id>` and `/users/@me/guilds` endpoints when `with_counts` is `true`
	approximate_member_count ?int
	// approximate number of non-offline members in this guild, returned from the `GET /guilds/<id>` and `/users/@me/guilds` endpoints when `with_counts` is `true`
	approximate_presence_count ?int
	// the welcome screen of a Community guild, shown to new members, returned in an Invite's guild object
	welcome_screen ?WelcomeScreen
	// guild NSFW level
	nsfw_level NSFWLevel
	// custom guild stickers
	stickers []Sticker
	// whether the guild has the boost progress bar enabled
	premium_progress_bar_enabled bool
	// the id of the channel where admins and moderators of Community guilds receive safety alerts from Discord
	safety_alerts_channel_id ?Snowflake
}
