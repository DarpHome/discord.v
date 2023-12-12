# module discord

## Contents
- [Constants](#Constants)
- [bot](#bot)
- [bearer](#bearer)
- [is_sentinel](#is_sentinel)
- [combine_intents](#combine_intents)
- [oauth2_app](#oauth2_app)
- [ApplicationCommandOption.parse](#ApplicationCommandOption.parse)
- [User.parse](#User.parse)
- [ApplicationCommandOptionChoice.parse](#ApplicationCommandOptionChoice.parse)
- [Interaction.parse](#Interaction.parse)
- [InstallParams.parse](#InstallParams.parse)
- [UnavailableGuild.parse](#UnavailableGuild.parse)
- [ApplicationCommandPermission.parse](#ApplicationCommandPermission.parse)
- [GuildMember.parse](#GuildMember.parse)
- [PartialApplication.parse](#PartialApplication.parse)
- [GuildApplicationCommandPermissions.parse](#GuildApplicationCommandPermissions.parse)
- [ApplicationCommand.parse](#ApplicationCommand.parse)
- [AvatarDecorationData.parse](#AvatarDecorationData.parse)
- [Guild.parse](#Guild.parse)
- [PartialUser.parse](#PartialUser.parse)
- [TeamMember.parse](#TeamMember.parse)
- [Application.parse](#Application.parse)
- [WelcomeChannel.parse](#WelcomeChannel.parse)
- [Team.parse](#Team.parse)
- [Permissions.all](#Permissions.all)
- [Permissions.all_except](#Permissions.all_except)
- [Permissions.parse](#Permissions.parse)
- [Permissions.zero](#Permissions.zero)
- [Entitlement.parse](#Entitlement.parse)
- [ReadyEvent.parse](#ReadyEvent.parse)
- [Sticker.parse](#Sticker.parse)
- [PartialGuild.parse](#PartialGuild.parse)
- [Emoji.parse](#Emoji.parse)
- [Role.parse](#Role.parse)
- [WelcomeScreen.parse](#WelcomeScreen.parse)
- [Snowflake.parse](#Snowflake.parse)
- [Snowflake.now](#Snowflake.now)
- [Snowflake.from](#Snowflake.from)
- [RoleTags.parse](#RoleTags.parse)
- [Sku.parse](#Sku.parse)
- [InteractionResponseData](#InteractionResponseData)
- [IInteractionResponse](#IInteractionResponse)
- [Image](#Image)
- [Component](#Component)
- [Snowflake](#Snowflake)
  - [raw_timestamp](#raw_timestamp)
  - [timestamp](#timestamp)
  - [build](#build)
- [ApplicationCommandOptionChoiceValue](#ApplicationCommandOptionChoiceValue)
- [TeamMemberRole](#TeamMemberRole)
- [GuildFeature](#GuildFeature)
- [Check](#Check)
- [Locale](#Locale)
- [Prepare](#Prepare)
- [EventController[T]](#EventController[T])
  - [emit](#emit)
  - [wait](#wait)
  - [override](#override)
  - [listen](#listen)
- [EventListener](#EventListener)
- [Awaitable[T]](#Awaitable[T])
  - [do](#do)
- [PremiumTier](#PremiumTier)
- [ExplicitContentFilterLevel](#ExplicitContentFilterLevel)
- [ChannelType](#ChannelType)
- [StickerType](#StickerType)
- [ButtonStyle](#ButtonStyle)
  - [build](#build)
- [SystemChannelFlags](#SystemChannelFlags)
- [Permissions](#Permissions)
- [PremiumType](#PremiumType)
- [EntitlementType](#EntitlementType)
- [TextInputStyle](#TextInputStyle)
  - [build](#build)
- [ApplicationFlags](#ApplicationFlags)
- [StickerFormatType](#StickerFormatType)
- [ApplicationCommandType](#ApplicationCommandType)
- [ApplicationCommandPermissionType](#ApplicationCommandPermissionType)
- [GuildMemberFlags](#GuildMemberFlags)
- [ComponentType](#ComponentType)
  - [build](#build)
- [RoleFlags](#RoleFlags)
- [OwnerType](#OwnerType)
- [ApplicationCommandOptionType](#ApplicationCommandOptionType)
- [Intents](#Intents)
- [DefaultValueType](#DefaultValueType)
- [UserFlags](#UserFlags)
- [NSFWLevel](#NSFWLevel)
- [MFALevel](#MFALevel)
- [SkuFlags](#SkuFlags)
- [InteractionResponseType](#InteractionResponseType)
- [InteractionType](#InteractionType)
- [MessageNotificationsLevel](#MessageNotificationsLevel)
- [VerificationLevel](#VerificationLevel)
- [MembershipState](#MembershipState)
- [SkuType](#SkuType)
- [ListEntitlementParams](#ListEntitlementParams)
- [JpegImage](#JpegImage)
  - [build](#build)
- [MentionableSelect](#MentionableSelect)
  - [build](#build)
- [InternalServerError](#InternalServerError)
- [InteractionResponse](#InteractionResponse)
  - [build](#build)
- [ModalInteractionResponse](#ModalInteractionResponse)
  - [build](#build)
- [ModalResponseData](#ModalResponseData)
  - [is_interaction_response_data](#is_interaction_response_data)
  - [build](#build)
- [MyUserEdit](#MyUserEdit)
  - [build](#build)
- [NoneImage](#NoneImage)
  - [build](#build)
- [NotFound](#NotFound)
- [InteractionCreateEvent](#InteractionCreateEvent)
- [Interaction](#Interaction)
- [InstallParams](#InstallParams)
  - [build](#build)
- [PartialApplication](#PartialApplication)
- [GuildMember](#GuildMember)
- [PartialEmoji](#PartialEmoji)
  - [build](#build)
- [PartialGuild](#PartialGuild)
- [GuildApplicationCommandPermissions](#GuildApplicationCommandPermissions)
- [PartialUser](#PartialUser)
- [Guild](#Guild)
- [GifImage](#GifImage)
  - [build](#build)
- [GatewayClient](#GatewayClient)
  - [launch](#launch)
  - [process_dispatch](#process_dispatch)
  - [run](#run)
  - [init](#init)
- [Forbidden](#Forbidden)
- [FetchMyGuildsParams](#FetchMyGuildsParams)
- [FetchGlobalApplicationCommandsParams](#FetchGlobalApplicationCommandsParams)
- [PngImage](#PngImage)
  - [build](#build)
- [EventWaitParams](#EventWaitParams)
- [Events](#Events)
- [EventController](#EventController)
- [Properties](#Properties)
- [Ratelimit](#Ratelimit)
- [ReadyEvent](#ReadyEvent)
- [Entitlement](#Entitlement)
- [RequestOptions](#RequestOptions)
- [RestError](#RestError)
  - [code](#code)
  - [msg](#msg)
- [Role](#Role)
- [Emoji](#Emoji)
- [EmitOptions](#EmitOptions)
- [RoleSelect](#RoleSelect)
  - [build](#build)
- [RoleTags](#RoleTags)
- [EditApplicationParams](#EditApplicationParams)
  - [build](#build)
- [SelectOption](#SelectOption)
  - [build](#build)
- [Sku](#Sku)
- [EditApplicationCommandPermissionsParams](#EditApplicationCommandPermissionsParams)
  - [build](#build)
- [EditApplicationCommandParams](#EditApplicationCommandParams)
  - [build](#build)
- [DispatchEvent](#DispatchEvent)
- [DefaultValue](#DefaultValue)
  - [build](#build)
- [CreateTestEntitlementParams](#CreateTestEntitlementParams)
- [CreateGroupDMParams](#CreateGroupDMParams)
- [CreateApplicationCommandParams](#CreateApplicationCommandParams)
  - [build](#build)
- [Sticker](#Sticker)
- [ClientConfig](#ClientConfig)
- [Client](#Client)
  - [bulk_overwrite_global_application_commands](#bulk_overwrite_global_application_commands)
  - [bulk_overwrite_guild_application_commands](#bulk_overwrite_guild_application_commands)
  - [create_dm](#create_dm)
  - [create_global_application_command](#create_global_application_command)
  - [create_group_dm](#create_group_dm)
  - [create_guild_application_command](#create_guild_application_command)
  - [create_interaction_response](#create_interaction_response)
  - [create_test_entitlement](#create_test_entitlement)
  - [delete_channel](#delete_channel)
  - [delete_global_application_command](#delete_global_application_command)
  - [delete_guild_application_command](#delete_guild_application_command)
  - [delete_message](#delete_message)
  - [delete_test_entitlement](#delete_test_entitlement)
  - [edit_application_command_permissions](#edit_application_command_permissions)
  - [edit_global_application_command](#edit_global_application_command)
  - [edit_guild_application_command](#edit_guild_application_command)
  - [edit_my_application](#edit_my_application)
  - [edit_my_user](#edit_my_user)
  - [fetch_application_command_permissions](#fetch_application_command_permissions)
  - [fetch_global_application_command](#fetch_global_application_command)
  - [fetch_global_application_commands](#fetch_global_application_commands)
  - [fetch_guild](#fetch_guild)
  - [fetch_guild_application_command](#fetch_guild_application_command)
  - [fetch_guild_application_command_permissions](#fetch_guild_application_command_permissions)
  - [fetch_my_application](#fetch_my_application)
  - [fetch_my_guild_member](#fetch_my_guild_member)
  - [fetch_my_guilds](#fetch_my_guilds)
  - [fetch_my_user](#fetch_my_user)
  - [fetch_user](#fetch_user)
  - [leave_guild](#leave_guild)
  - [list_entitlements](#list_entitlements)
  - [list_skus](#list_skus)
  - [request](#request)
- [ChannelSelect](#ChannelSelect)
  - [build](#build)
- [StringSelect](#StringSelect)
  - [build](#build)
- [Button](#Button)
  - [build](#build)
- [Team](#Team)
- [BotConfig](#BotConfig)
- [TeamMember](#TeamMember)
- [BaseEvent](#BaseEvent)
- [Awaitable](#Awaitable)
- [TextInput](#TextInput)
  - [build](#build)
- [AvatarDecorationData](#AvatarDecorationData)
- [Unauthorized](#Unauthorized)
- [UnavailableGuild](#UnavailableGuild)
- [ApplicationCommandPermission](#ApplicationCommandPermission)
  - [build](#build)
- [User](#User)
- [ApplicationCommandOptionChoice](#ApplicationCommandOptionChoice)
  - [build](#build)
- [ApplicationCommandOption](#ApplicationCommandOption)
  - [build](#build)
- [UserSelect](#UserSelect)
  - [build](#build)
- [ApplicationCommand](#ApplicationCommand)
- [WelcomeChannel](#WelcomeChannel)
- [Application](#Application)
- [WelcomeScreen](#WelcomeScreen)
- [ActionRow](#ActionRow)
  - [build](#build)
- [WithReason](#WithReason)
- [WSMessage](#WSMessage)

## Constants
```v
const team_member_role_admin = TeamMemberRole('admin')
```


[[Return to contents]](#Contents)

```v
const team_member_role_developer = TeamMemberRole('developer')
```


[[Return to contents]](#Contents)

```v
const team_member_role_read_only = TeamMemberRole('read_only')
```


[[Return to contents]](#Contents)

```v
const locale_id = Locale('id')
```
Indonesian (Bahasa Indonesia)

[[Return to contents]](#Contents)

```v
const locale_da = Locale('da')
```
Danish (Dansk)

[[Return to contents]](#Contents)

```v
const locale_de = Locale('de')
```
German (Deutsch)

[[Return to contents]](#Contents)

```v
const locale_en_gb = Locale('en-GB')
```
English, UK (English, UK)

[[Return to contents]](#Contents)

```v
const locale_en_us = Locale('en-US')
```
English, US (English, US)

[[Return to contents]](#Contents)

```v
const locale_es_es = Locale('es-ES')
```
Spanish (Español)

[[Return to contents]](#Contents)

```v
const locale_fr = Locale('fr')
```
French (Français)

[[Return to contents]](#Contents)

```v
const locale_hr = Locale('hr')
```
Croatian (Hrvatski)

[[Return to contents]](#Contents)

```v
const locale_it = Locale('it')
```
Italian (Italiano)

[[Return to contents]](#Contents)

```v
const locale_lt = Locale('lt')
```
Lithuanian (Lietuviškai)

[[Return to contents]](#Contents)

```v
const locale_hu = Locale('hu')
```
Hungarian (Magyar)

[[Return to contents]](#Contents)

```v
const locale_nl = Locale('nl')
```
Dutch (Nederlands)

[[Return to contents]](#Contents)

```v
const locale_no = Locale('no')
```
Norweigan (Norsk)

[[Return to contents]](#Contents)

```v
const locale_pl = Locale('pl')
```
Polish (Polski)

[[Return to contents]](#Contents)

```v
const locale_pt_br = Locale('pt-BR')
```
Portuguese, Brazilian (Português do Brasil)

[[Return to contents]](#Contents)

```v
const locale_ro = Locale('ro')
```
Romanian, Romania (Română)

[[Return to contents]](#Contents)

```v
const locale_fi = Locale('fi')
```
Finnish (Suomi)

[[Return to contents]](#Contents)

```v
const locale_sv_se = Locale('sv-SE')
```
Swedish (Svenska)

[[Return to contents]](#Contents)

```v
const locale_vi = Locale('vi')
```
Vietnamese (Tiếng Việt)

[[Return to contents]](#Contents)

```v
const locale_tr = Locale('tr')
```
Turkish (Türkçe)

[[Return to contents]](#Contents)

```v
const locale_cs = Locale('cs')
```
Czech (Čeština)

[[Return to contents]](#Contents)

```v
const locale_el = Locale('el')
```
Greek (Ελληνικά)

[[Return to contents]](#Contents)

```v
const locale_bg = Locale('bg')
```
Bulgarian (български)

[[Return to contents]](#Contents)

```v
const locale_ru = Locale('ru')
```
Russian (Pусский)

[[Return to contents]](#Contents)

```v
const locale_uk = Locale('uk')
```
Ukrainian (Українська)

[[Return to contents]](#Contents)

```v
const locale_hi = Locale('hi')
```
Hindi (हिन्दी)

[[Return to contents]](#Contents)

```v
const locale_th = Locale('th')
```
Thai (ไทย)

[[Return to contents]](#Contents)

```v
const locale_zh_cn = Locale('zh-CN')
```
Chinese, China (中文)

[[Return to contents]](#Contents)

```v
const locale_ja = Locale('ja')
```
Japanese (日本語)

[[Return to contents]](#Contents)

```v
const locale_zh_tw = Locale('zh-TW')
```
Chinese, Taiwan (繁體中文)

[[Return to contents]](#Contents)

```v
const locale_ko = Locale('ko')
```
Korean (한국어)

[[Return to contents]](#Contents)

```v
const default_user_agent = 'DiscordBot (https://github.com/DarpHome/discord.v, 10.0.0) V ${@VHASH}'
```


[[Return to contents]](#Contents)

```v
const all_intents = combine_intents(.guilds, .guild_members, .guild_moderation, .guild_emojis_and_stickers,
	.guild_integrations, .guild_webhooks, .guild_invites, .guild_voice_states, .guild_presences,
	.guild_messages, .guild_message_reactions, .guild_message_typing, .direct_messages,
	.direct_message_reactions, .direct_message_typing, .message_content, .guild_scheduled_events,
	.auto_moderation_configuration, .auto_moderation_execution)
```


[[Return to contents]](#Contents)

```v
const sentinel_int = 1886544228
```
ASCII-encoded 'darp'

[[Return to contents]](#Contents)

```v
const sentinel_time = time.Time{
	unix: 0
}
```


[[Return to contents]](#Contents)

```v
const sentinel_string = 'darp'
```
Compare using `target.str == sentinel_string.str`

[[Return to contents]](#Contents)

```v
const sentinel_number = math.nan()
```
compare using math.is_nan(target)

[[Return to contents]](#Contents)

```v
const sentinel_snowflake = Snowflake(0)
```


[[Return to contents]](#Contents)

```v
const sentinel_permissions = unsafe { Permissions(math.max_u64) }
```


[[Return to contents]](#Contents)

```v
const sentinel_image = Image(NoneImage{})
```


[[Return to contents]](#Contents)

```v
const snowflake_epoch = u64(1420070400000)
```


[[Return to contents]](#Contents)

## bot
```v
fn bot(token string, config BotConfig) GatewayClient
```
`bot` creates a new [GatewayClient] that can be used to listen events. Use `launch` to connect to gateway.

Note: token should not contain `Bot` prefix

[[Return to contents]](#Contents)

## bearer
```v
fn bearer(token string, config ClientConfig) Client
```
`bearer` accepts access token and returns Client that can be used to fetch user data

Note: token should not contain `Bearer` prefix

[[Return to contents]](#Contents)

## is_sentinel
```v
fn is_sentinel[T](target T) bool
```
is_sentinel reports whether `target` is sentinel

[[Return to contents]](#Contents)

## combine_intents
```v
fn combine_intents(list ...Intents) int
```


[[Return to contents]](#Contents)

## oauth2_app
```v
fn oauth2_app(client_id Snowflake, client_secret string, config ClientConfig) Client
```
`oauth2_app` accepts client ID and secret and returns Client with Basic token

[[Return to contents]](#Contents)

## ApplicationCommandOption.parse
```v
fn ApplicationCommandOption.parse(j json2.Any) !ApplicationCommandOption
```


[[Return to contents]](#Contents)

## User.parse
```v
fn User.parse(j json2.Any) !User
```


[[Return to contents]](#Contents)

## ApplicationCommandOptionChoice.parse
```v
fn ApplicationCommandOptionChoice.parse(j json2.Any) !ApplicationCommandOptionChoice
```


[[Return to contents]](#Contents)

## Interaction.parse
```v
fn Interaction.parse(j json2.Any) !Interaction
```


[[Return to contents]](#Contents)

## InstallParams.parse
```v
fn InstallParams.parse(j json2.Any) !InstallParams
```


[[Return to contents]](#Contents)

## UnavailableGuild.parse
```v
fn UnavailableGuild.parse(j json2.Any) !UnavailableGuild
```


[[Return to contents]](#Contents)

## ApplicationCommandPermission.parse
```v
fn ApplicationCommandPermission.parse(j json2.Any) !ApplicationCommandPermission
```


[[Return to contents]](#Contents)

## GuildMember.parse
```v
fn GuildMember.parse(j json2.Any) !GuildMember
```


[[Return to contents]](#Contents)

## PartialApplication.parse
```v
fn PartialApplication.parse(j json2.Any) !PartialApplication
```


[[Return to contents]](#Contents)

## GuildApplicationCommandPermissions.parse
```v
fn GuildApplicationCommandPermissions.parse(j json2.Any) !GuildApplicationCommandPermissions
```


[[Return to contents]](#Contents)

## ApplicationCommand.parse
```v
fn ApplicationCommand.parse(j json2.Any) !ApplicationCommand
```


[[Return to contents]](#Contents)

## AvatarDecorationData.parse
```v
fn AvatarDecorationData.parse(j json2.Any) !AvatarDecorationData
```


[[Return to contents]](#Contents)

## Guild.parse
```v
fn Guild.parse(j json2.Any) !Guild
```


[[Return to contents]](#Contents)

## PartialUser.parse
```v
fn PartialUser.parse(j json2.Any) !PartialUser
```


[[Return to contents]](#Contents)

## TeamMember.parse
```v
fn TeamMember.parse(j json2.Any) !TeamMember
```


[[Return to contents]](#Contents)

## Application.parse
```v
fn Application.parse(j json2.Any) !Application
```


[[Return to contents]](#Contents)

## WelcomeChannel.parse
```v
fn WelcomeChannel.parse(j json2.Any) !WelcomeChannel
```


[[Return to contents]](#Contents)

## Team.parse
```v
fn Team.parse(j json2.Any) !Team
```


[[Return to contents]](#Contents)

## Permissions.all
```v
fn Permissions.all() Permissions
```


[[Return to contents]](#Contents)

## Permissions.all_except
```v
fn Permissions.all_except(permissions Permissions) Permissions
```


[[Return to contents]](#Contents)

## Permissions.parse
```v
fn Permissions.parse(j json2.Any) !Permissions
```


[[Return to contents]](#Contents)

## Permissions.zero
```v
fn Permissions.zero() Permissions
```


[[Return to contents]](#Contents)

## Entitlement.parse
```v
fn Entitlement.parse(j json2.Any) !Entitlement
```


[[Return to contents]](#Contents)

## ReadyEvent.parse
```v
fn ReadyEvent.parse(j json2.Any, base BaseEvent) !ReadyEvent
```


[[Return to contents]](#Contents)

## Sticker.parse
```v
fn Sticker.parse(j json2.Any) !Sticker
```


[[Return to contents]](#Contents)

## PartialGuild.parse
```v
fn PartialGuild.parse(j json2.Any) !PartialGuild
```


[[Return to contents]](#Contents)

## Emoji.parse
```v
fn Emoji.parse(j json2.Any) !Emoji
```


[[Return to contents]](#Contents)

## Role.parse
```v
fn Role.parse(j json2.Any) !Role
```


[[Return to contents]](#Contents)

## WelcomeScreen.parse
```v
fn WelcomeScreen.parse(j json2.Any) !WelcomeScreen
```


[[Return to contents]](#Contents)

## Snowflake.parse
```v
fn Snowflake.parse(j json2.Any) !Snowflake
```


[[Return to contents]](#Contents)

## Snowflake.now
```v
fn Snowflake.now() Snowflake
```


[[Return to contents]](#Contents)

## Snowflake.from
```v
fn Snowflake.from(t time.Time) Snowflake
```


[[Return to contents]](#Contents)

## RoleTags.parse
```v
fn RoleTags.parse(j json2.Any) !RoleTags
```


[[Return to contents]](#Contents)

## Sku.parse
```v
fn Sku.parse(j json2.Any) !Sku
```


[[Return to contents]](#Contents)

## InteractionResponseData
```v
interface InteractionResponseData {
	is_interaction_response_data()
	build() json2.Any
}
```


[[Return to contents]](#Contents)

## IInteractionResponse
```v
interface IInteractionResponse {
	is_interaction_response()
	build() json2.Any
}
```


[[Return to contents]](#Contents)

## Image
```v
interface Image {
	data []u8
	is_image()
	build() string
}
```


[[Return to contents]](#Contents)

## Component
```v
interface Component {
	is_component()
	build() json2.Any
}
```
ignore is_component(), it is used to differ interfaces

[[Return to contents]](#Contents)

## Snowflake
```v
type Snowflake = u64
```


[[Return to contents]](#Contents)

## raw_timestamp
```v
fn (s Snowflake) raw_timestamp() u64
```


[[Return to contents]](#Contents)

## timestamp
```v
fn (s Snowflake) timestamp() time.Time
```


[[Return to contents]](#Contents)

## build
```v
fn (s Snowflake) build() string
```


[[Return to contents]](#Contents)

## ApplicationCommandOptionChoiceValue
```v
type ApplicationCommandOptionChoiceValue = f64 | int | string
```


[[Return to contents]](#Contents)

## TeamMemberRole
```v
type TeamMemberRole = string
```


[[Return to contents]](#Contents)

## GuildFeature
```v
type GuildFeature = string
```


[[Return to contents]](#Contents)

## Check
```v
type Check[T] = fn (T) bool
```


[[Return to contents]](#Contents)

## Locale
```v
type Locale = string
```


[[Return to contents]](#Contents)

## Prepare
```v
type Prepare = fn (mut http.Request) !
```


[[Return to contents]](#Contents)

## EventController[T]
## emit
```v
fn (mut ec EventController[T]) emit(e T, options EmitOptions)
```
`emit` broadcasts passed object to all listeners

[[Return to contents]](#Contents)

## wait
```v
fn (mut ec EventController[T]) wait(params EventWaitParams[T]) Awaitable[T]
```
`wait` returns Awaitable that can be used to get event

[[Return to contents]](#Contents)

## override
```v
fn (mut ec EventController[T]) override(listener EventListener[T]) EventController[T]
```
`override` removes all listeners and inserts `listener`

[[Return to contents]](#Contents)

## listen
```v
fn (mut ec EventController[T]) listen(listener EventListener[T]) EventController[T]
```
`listen` adds function to listener list

[[Return to contents]](#Contents)

## EventListener
```v
type EventListener[T] = fn (T) !
```


[[Return to contents]](#Contents)

## Awaitable[T]
## do
```v
fn (mut a Awaitable[T]) do() ?T
```
`do` waits for event and returns it. After it returned event, it will return none If timeout is exceeded, it returns none

[[Return to contents]](#Contents)

## PremiumTier
```v
enum PremiumTier {
	// guild has not unlocked any Server Boost perks
	none_
	// guild has unlocked Server Boost level 1 perks
	tier_1
	// guild has unlocked Server Boost level 2 perks
	tier_2
	// guild has unlocked Server Boost level 3 perks
	tier_3
}
```


[[Return to contents]](#Contents)

## ExplicitContentFilterLevel
```v
enum ExplicitContentFilterLevel {
	// media content will not be scanned
	disabled
	// media content sent by members without roles will be scanned
	members_without_roles
	// media content sent by all members will be scanned
	all_members
}
```


[[Return to contents]](#Contents)

## ChannelType
```v
enum ChannelType {
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
```


[[Return to contents]](#Contents)

## StickerType
```v
enum StickerType {
	standard
	guild
}
```


[[Return to contents]](#Contents)

## ButtonStyle
```v
enum ButtonStyle {
	// blurple
	primary   = 1
	// grey
	secondary = 2
	// green
	success   = 3
	// red
	danger    = 4
	// grey, navigates to a URL
	link      = 5
}
```


[[Return to contents]](#Contents)

## build
```v
fn (bs ButtonStyle) build() json2.Any
```


[[Return to contents]](#Contents)

## SystemChannelFlags
```v
enum SystemChannelFlags {
	// Suppress member join notifications
	suppress_join_notifications
	// Suppress server boost notifications
	suppress_premium_subscriptions
	// Suppress server setup tips
	suppress_guild_reminder_notifications
	// Hide member join sticker reply buttons
	suppress_join_notification_replies
	// Suppress role subscription purchase and renewal notifications
	suppress_role_subscription_purchase_notifications
	// Hide role subscription sticker reply buttons
	suppress_role_subscription_purchase_notifications_replies
}
```


[[Return to contents]](#Contents)

## Permissions
```v
enum Permissions as u64 {
	// Allows creation of instant invites
	create_instant_invite
	// Allows kicking members
	kick_members
	// Allows banning members
	ban_members
	// Allows all permissions and bypasses channel permission overwrites
	administrator
	// Allows management and editing of channels
	manage_channels
	// Allows management and editing of the guild
	manage_guild
	// Allows for the addition of reactions to messages
	add_reactions
	// Allows for viewing of audit logs
	view_audit_log
	// Allows for using priority speaker in a voice channel
	priority_speaker
	// Allows the user to go live
	stream
	// Allows guild members to view a channel, which includes reading messages in text channels and joining voice channels
	view_channel
	// Allows for sending messages in a channel and creating threads in a forum (does not allow sending messages in threads)
	send_messages
	// Allows for sending of `/tts` messages
	send_tts_messages
	// Allows for deletion of other users messages
	manage_messages
	// Links sent by users with this permission will be auto-embedded
	embed_links
	// Allows for uploading images and files
	attach_files
	// Allows for reading of message history
	read_message_history
	// Allows for using the `@everyone` tag to notify all users in a channel, and the `@here` tag to notify all online users in a channel
	mention_everyone
	// Allows the usage of custom emojis from other servers
	use_external_emojis
	// Allows for viewing guild insights
	view_guild_insights
	// Allows for joining of a voice channel
	connect
	// Allows for speaking in a voice channel
	speak
	// Allows for muting members in a voice channel
	mute_members
	// Allows for deafening of members in a voice channel
	deafen_members
	// Allows for moving of members between voice channels
	move_members
	// Allows for using voice-activity-detection in a voice channel
	use_vad
	// Allows for modification of own nickname
	change_nickname
	// Allows for modification of other users nicknames
	manage_nicknames
	// Allows management and editing of roles
	manage_roles
	// Allows management and editing of webhooks
	manage_webhooks
	// Allows for editing and deleting emojis, stickers, and soundboard sounds created by all users
	manage_guild_expressions
	// Allows members to use application commands, including slash commands and context menu commands.
	use_application_commands
	// Allows for requesting to speak in stage channels. (This permission is under active development and may be changed or removed.)
	request_to_speak
	// Allows for editing and deleting scheduled events created by all users
	manage_events
	// Allows for deleting and archiving threads, and viewing all private threads
	manage_threads
	// Allows for creating public and announcement threads
	create_public_threads
	// Allows for creating private threads
	create_private_threads
	// Allows the usage of custom stickers from other servers
	use_external_stickers
	// Allows for sending messages in threads
	send_messages_in_threads
	// Allows for using Activities (applications with the `EMBEDDED` flag) in a voice channel
	use_embedded_activities
	// Allows for timing out users to prevent them from sending or reacting to messages in chat and threads, and from speaking in voice and stage channels
	moderate_members
	// Allows for viewing role subscription insights
	view_creator_monetization_analytics
	// Allows for using soundboard in a voice channel
	use_soundboard
	// Allows for creating emojis, stickers, and soundboard sounds, and editing and deleting those created by the current user
	create_guild_expressions
	// Allows for creating scheduled events, and editing and deleting those created by the current user
	create_events
	// Allows the usage of custom soundboard sounds from other servers
	use_external_sounds
	// Allows sending voice messages
	send_voice_messages
}
```


[[Return to contents]](#Contents)

## PremiumType
```v
enum PremiumType {
	none_
	nitro_classic
	nitro
	nitro_basic
}
```


[[Return to contents]](#Contents)

## EntitlementType
```v
enum EntitlementType {
	// Entitlement was purchased as an app subscription
	application_subscription = 8
}
```


[[Return to contents]](#Contents)

## TextInputStyle
```v
enum TextInputStyle {
	// Single-line input
	short     = 1
	// Multi-line input
	paragraph = 2
}
```


[[Return to contents]](#Contents)

## build
```v
fn (tis TextInputStyle) build() json2.Any
```


[[Return to contents]](#Contents)

## ApplicationFlags
```v
enum ApplicationFlags {
	reserved_0
	reserved_1
	reserved_2
	reserved_3
	reserved_4
	reserved_5
	// Indicates if an app uses the Auto Moderation API
	application_auto_moderation_rule_create_badge
	reserved_7
	reserved_8
	reserved_9
	reserved_10
	reserved_11
	// Intent required for bots in **100 or more servers** to receive `presence_update` events
	gateway_presence
	// Intent required for bots in under 100 to receive `presence_update` events, found on the **Bot** page in your app's settings
	gateway_presence_limited
	// Intent required for bots in **100 or more servers** to receive member-related events like `guild_member_add`. See the list of member-related events under `GUILD_MEMBERS`
	gateway_guild_members
	// Intent required for bots in under 100 servers to receive member-related events like `guild_member_add`, found on the **Bot** page in your app's settings. See the list of member-related events under GUILD_MEMBERS
	gateway_guild_members_limited
	// Indicates unusual growth of an app that prevents verification
	verification_pending_guild_limit
	// Indicates if an app is embedded within the Discord client (currently unavailable publicly)
	embedded
	// Intent required for bots in **100 or more servers** to receive message content
	gateway_message_content
	// Intent required for bots in under 100 servers to receive message content, found on the **Bot** page in your app's settings
	gateway_message_content_limited
	reserved_20
	reserved_21
	reserved_22
	// Indicates if an app has registered global application commands
	application_command_badge
}
```


[[Return to contents]](#Contents)

## StickerFormatType
```v
enum StickerFormatType {
	png
	apng
	lottie
	gif
}
```


[[Return to contents]](#Contents)

## ApplicationCommandType
```v
enum ApplicationCommandType {
	// Slash commands; a text-based command that shows up when a user types `/`
	chat_input = 1
	// A UI-based command that shows up when you right click or tap on a user
	user
	// A UI-based command that shows up when you right click or tap on a message
	message
}
```


[[Return to contents]](#Contents)

## ApplicationCommandPermissionType
```v
enum ApplicationCommandPermissionType {
	role    = 1
	user
	channel
}
```
Guild Application Command Permissions Structure

[[Return to contents]](#Contents)

## GuildMemberFlags
```v
enum GuildMemberFlags {
	// Member has left and rejoined the guild
	did_rejoin
	// Member has completed onboarding
	completed_onboarding
	// Member is exempt from guild verification requirements
	bypasses_verification
	// Member has started onboarding
	started_onboarding
}
```


[[Return to contents]](#Contents)

## ComponentType
```v
enum ComponentType {
	// Container for other components
	action_row         = 1
	// Button object
	button             = 2
	// Select menu for picking from defined text options
	string_select      = 3
	// Text input object
	text_input         = 4
	// Select menu for users
	user_select        = 5
	// Select menu for roles
	role_select        = 6
	// Select menu for mentionables (users *and roles*)
	mentionable_select = 7
	// Select menu for channels
	channel_select     = 8
}
```


[[Return to contents]](#Contents)

## build
```v
fn (ct ComponentType) build() json2.Any
```


[[Return to contents]](#Contents)

## RoleFlags
```v
enum RoleFlags {
	// role can be selected by members in an onboarding prompt
	in_prompt
}
```


[[Return to contents]](#Contents)

## OwnerType
```v
enum OwnerType {
	// for a guild subscription
	guild = 1
	// for a user subscription
	user
}
```


[[Return to contents]](#Contents)

## ApplicationCommandOptionType
```v
enum ApplicationCommandOptionType {
	sub_command
	sub_command_group
	string
	// Any integer between -2^53 and 2^53
	integer
	boolean
	user
	// Includes all channel types + categories
	channel
	role
	// Includes users and roles
	mentionable
	// Any double between -2^53 and 2^53
	number
	attachment
}
```


[[Return to contents]](#Contents)

## Intents
```v
enum Intents {
	guilds
	guild_members
	guild_moderation
	guild_emojis_and_stickers
	guild_integrations
	guild_webhooks
	guild_invites
	guild_voice_states
	guild_presences
	guild_messages
	guild_message_reactions
	guild_message_typing
	direct_messages
	direct_message_reactions
	direct_message_typing
	message_content
	guild_scheduled_events
	reserved_17
	reserved_18
	reserved_19
	auto_moderation_configuration
	auto_moderation_execution
}
```


[[Return to contents]](#Contents)

## DefaultValueType
```v
enum DefaultValueType {
	user
	role
	channel
}
```


[[Return to contents]](#Contents)

## UserFlags
```v
enum UserFlags {
	// Discord Employee
	staff
	// Partnered Server Owner
	partner
	// HypeSquad Events Member
	hypesquad
	// Bug Hunter Level 1
	bug_hunter_level_1
	reserved_4
	reserved_5
	// House Bravery Member
	hypesquad_online_house_1
	// House Brilliance Member
	hypesquad_online_house_2
	// House Balance Member
	hypesquad_online_house_3
	// Early Nitro Supporter
	premium_early_supporter
	// User is a team
	team_pseudo_user
	reserved_11
	reserved_12
	reserved_13
	// Bug Hunter Level 2
	bug_hunter_level_2
	reserved_15
	// Verified Bot
	verified_bot
	// Early Verified Bot Developer
	verified_developer
	// Moderator Programs Alumni
	certified_moderator
	// Bot uses only HTTP interactions and is shown in the online member list
	bot_http_interactions
	reserved_20
	reserved_21
	// User is an Active Developer
	active_developer
}
```


[[Return to contents]](#Contents)

## NSFWLevel
```v
enum NSFWLevel {
	default
	explicit
	safe
	age_restricted
}
```


[[Return to contents]](#Contents)

## MFALevel
```v
enum MFALevel {
	// guild has no MFA/2FA requirement for moderation actions
	none_
	// guild has a 2FA requirement for moderation actions
	elevated
}
```


[[Return to contents]](#Contents)

## SkuFlags
```v
enum SkuFlags {
	reserved_0
	reserved_1
	// SKU is available for purchase
	available
	reserved_3
	reserved_4
	reserved_5
	reserved_6
	// Recurring SKU that can be purchased by a user and applied to a single server. Grants access to every user in that server.
	guild_subscription
	// Recurring SKU purchased by a user for themselves. Grants access to the purchasing user in every server.
	user_subscription
}
```


[[Return to contents]](#Contents)

## InteractionResponseType
```v
enum InteractionResponseType {
	// ACK a `Ping`
	pong                                    = 1
	// respond to an interaction with a message
	channel_message_with_source             = 4
	// ACK an interaction and edit a response later, the user sees a loading state
	deferred_channel_message_with_source
	// for components, ACK an interaction and edit the original message later; the user does not see a loading state
	deferred_update_message
	// for components, edit the message the component was attached to
	update_message
	// respond to an autocomplete interaction with suggested choices
	application_command_autocomplete_result
	// respond to an interaction with a popup modal
	modal
	// respond to an interaction with an upgrade button, only available for apps with monetization enabled
	premium_required
}
```


[[Return to contents]](#Contents)

## InteractionType
```v
enum InteractionType {
	ping                             = 1
	application_command              = 2
	message_component                = 3
	application_command_autocomplete = 4
	modal_submit                     = 5
}
```


[[Return to contents]](#Contents)

## MessageNotificationsLevel
```v
enum MessageNotificationsLevel {
	// members will receive notifications for all messages by default
	all_messages
	// members will receive notifications only for messages that @mention them by default
	only_mentions
}
```


[[Return to contents]](#Contents)

## VerificationLevel
```v
enum VerificationLevel {
	// unrestricted
	none_
	// must have verified email on account
	low
	// must be registered on Discord for longer than 5 minutes
	medium
	// must be a member of the server for longer than 10 minutes
	high
	// must have a verified phone number
	very_high
}
```


[[Return to contents]](#Contents)

## MembershipState
```v
enum MembershipState {
	invited  = 1
	accepted
}
```


[[Return to contents]](#Contents)

## SkuType
```v
enum SkuType {
	// Represents a recurring subscription
	subscription       = 5
	// System-generated group for each SUBSCRIPTION SKU created
	subscription_group
}
```


[[Return to contents]](#Contents)

## ListEntitlementParams
```v
struct ListEntitlementParams {
pub:
	// User ID to look up entitlements for
	user_id ?Snowflake
	// Optional list of SKU IDs to check entitlements for
	sku_ids ?[]Snowflake
	// Retrieve entitlements before this entitlement ID
	before ?Snowflake
	// Retrieve entitlements after this entitlement ID
	after ?Snowflake
	// Number of entitlements to return, 1-100, default 100
	limit ?int
	// Guild ID to look up entitlements for
	guild_id ?Snowflake
	// Whether or not ended entitlements should be omitted
	exclude_ended ?bool
}
```


[[Return to contents]](#Contents)

## JpegImage
```v
struct JpegImage {
pub:
	data []u8 @[required]
}
```


[[Return to contents]](#Contents)

## build
```v
fn (ji JpegImage) build() string
```


[[Return to contents]](#Contents)

## MentionableSelect
```v
struct MentionableSelect {
pub:
	// ID for the select menu; max 100 characters
	custom_id   string
	placeholder ?string
	// List of default values for auto-populated select menu components; number of default values must be in the range defined by `min_values` and `max_values`
	default_values ?[]DefaultValue
	// Minimum number of items that must be chosen (defaults to 1); min 0, max 25
	min_values ?int
	// Maximum number of items that can be chosen (defaults to 1); max 25
	max_values ?int
	// Whether select menu is disabled (defaults to `false`)
	disabled bool
}
```


[[Return to contents]](#Contents)

## build
```v
fn (ms MentionableSelect) build() json2.Any
```


[[Return to contents]](#Contents)

## InternalServerError
```v
struct InternalServerError {
	RestError
}
```


[[Return to contents]](#Contents)

## InteractionResponse
```v
struct InteractionResponse {
pub:
	// the type of response
	typ InteractionResponseType
	// an optional response message
	data ?InteractionResponseData
}
```


[[Return to contents]](#Contents)

## build
```v
fn (ir InteractionResponse) build() json2.Any
```


[[Return to contents]](#Contents)

## ModalInteractionResponse
```v
struct ModalInteractionResponse {
pub:
	// a developer-defined identifier for the modal, max 100 characters
	custom_id string
	// the title of the popup modal, max 45 characters
	title string
	// between 1 and 5 (inclusive) components that make up the modal
	components []Component
}
```


[[Return to contents]](#Contents)

## build
```v
fn (mir ModalInteractionResponse) build() json2.Any
```


[[Return to contents]](#Contents)

## ModalResponseData
```v
struct ModalResponseData {
pub:
	// a developer-defined identifier for the modal, max 100 characters
	custom_id string
	// the title of the popup modal, max 45 characters
	title string
	// between 1 and 5 (inclusive) components that make up the modal
	components []Component
}
```


[[Return to contents]](#Contents)

## is_interaction_response_data
```v
fn (_ ModalResponseData) is_interaction_response_data()
```


[[Return to contents]](#Contents)

## build
```v
fn (mrd ModalResponseData) build() json2.Any
```


[[Return to contents]](#Contents)

## MyUserEdit
```v
struct MyUserEdit {
pub:
	username ?string
	avatar   ?Image
}
```


[[Return to contents]](#Contents)

## build
```v
fn (mue MyUserEdit) build() json2.Any
```


[[Return to contents]](#Contents)

## NoneImage
```v
struct NoneImage {
	data []u8 = []
}
```


[[Return to contents]](#Contents)

## build
```v
fn (_ NoneImage) build() string
```


[[Return to contents]](#Contents)

## NotFound
```v
struct NotFound {
	RestError
}
```


[[Return to contents]](#Contents)

## InteractionCreateEvent
```v
struct InteractionCreateEvent {
pub:
	interaction Interaction
}
```


[[Return to contents]](#Contents)

## Interaction
```v
struct Interaction {
pub:
	id             Snowflake
	application_id Snowflake
	typ            InteractionType
	data           json2.Any
	guild_id       ?Snowflake
	// channel ?Channel
	channel_id ?Snowflake
	member     ?GuildMember
	user       ?User
	token      string
	// message ?Message
	app_permissions ?Permissions
	locale          ?string
	guild_locale    ?string
	entitlements    []Entitlement
}
```


[[Return to contents]](#Contents)

## InstallParams
```v
struct InstallParams {
pub:
	// Scopes to add the application to the server with
	scopes []string
	// Permissions to request for the bot role
	permissions Permissions
}
```


[[Return to contents]](#Contents)

## build
```v
fn (ip InstallParams) build() json2.Any
```


[[Return to contents]](#Contents)

## PartialApplication
```v
struct PartialApplication {
pub:
	id    Snowflake
	flags ApplicationFlags
}
```


[[Return to contents]](#Contents)

## GuildMember
```v
struct GuildMember {
pub:
	// the user this guild member represents
	user ?User
	// this user's guild nickname
	nick ?string
	// the member's guild avatar hash
	avatar ?string
	// array of role object ids
	roles []Snowflake
	// when the user joined the guild
	joined_at time.Time
	// when the user started boosting the guild
	premium_since ?time.Time
	// whether the user is deafened in voice channels
	deaf bool
	// whether the user is muted in voice channels
	mute bool
	// guild member flags represented as a bit set, defaults to 0
	flags GuildMemberFlags
	// whether the user has not yet passed the guild's Membership Screening requirements
	pending ?bool
	// total permissions of the member in the channel, including overwrites, returned when in the interaction object
	permissions ?Permissions
	// when the user's timeout will expire and the user will be able to communicate in the guild again, null or a time in the past if the user is not timed out
	communication_disabled_until ?time.Time
}
```


[[Return to contents]](#Contents)

## PartialEmoji
```v
struct PartialEmoji {
pub:
	id       ?Snowflake
	name     string
	animated bool
}
```


[[Return to contents]](#Contents)

## build
```v
fn (pe PartialEmoji) build() json2.Any
```


[[Return to contents]](#Contents)

## PartialGuild
```v
struct PartialGuild {
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
```


[[Return to contents]](#Contents)

## GuildApplicationCommandPermissions
```v
struct GuildApplicationCommandPermissions {
pub:
	// ID of the command or the application ID
	id Snowflake
	// ID of the application the command belongs to
	application_id Snowflake
	// ID of the guild
	guild_id Snowflake
	// Permissions for the command in the guild, max of 100
	permissions []ApplicationCommandPermission
}
```


[[Return to contents]](#Contents)

## PartialUser
```v
struct PartialUser {
pub:
	// the user's id
	id Snowflake
	// the user's username, not unique across the platform
	username string
	// the user's Discord-tag
	discriminator string
	// the user's avatar hash
	avatar ?string
}
```


[[Return to contents]](#Contents)

## Guild
```v
struct Guild {
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
```


[[Return to contents]](#Contents)

## GifImage
```v
struct GifImage {
pub:
	data []u8 @[required]
}
```


[[Return to contents]](#Contents)

## build
```v
fn (gi GifImage) build() string
```


[[Return to contents]](#Contents)

## GatewayClient
```v
struct GatewayClient {
	Client
pub:
	intents     int
	properties  ?Properties
	gateway_url string = 'wss://gateway.discord.gg'
mut:
	ws       &websocket.Client = unsafe { nil }
	ready    bool
	sequence ?int
pub mut:
	// === events ====
	events Events
	// on_raw_event EventController[DispatchEvent[GatewayClient]]
}
```


[[Return to contents]](#Contents)

## launch
```v
fn (mut c GatewayClient) launch() !
```


[[Return to contents]](#Contents)

## process_dispatch
```v
fn (mut c GatewayClient) process_dispatch(event DispatchEvent) !
```


[[Return to contents]](#Contents)

## run
```v
fn (mut c GatewayClient) run() !
```


[[Return to contents]](#Contents)

## init
```v
fn (mut c GatewayClient) init() !
```


[[Return to contents]](#Contents)

## Forbidden
```v
struct Forbidden {
	RestError
}
```


[[Return to contents]](#Contents)

## FetchMyGuildsParams
```v
struct FetchMyGuildsParams {
pub:
	before      ?Snowflake
	after       ?Snowflake
	limit       ?int
	with_counts ?bool
}
```


[[Return to contents]](#Contents)

## FetchGlobalApplicationCommandsParams
```v
struct FetchGlobalApplicationCommandsParams {
pub:
	with_localizations ?bool
}
```


[[Return to contents]](#Contents)

## PngImage
```v
struct PngImage {
pub:
	data []u8 @[required]
}
```


[[Return to contents]](#Contents)

## build
```v
fn (pi PngImage) build() string
```


[[Return to contents]](#Contents)

## EventWaitParams
```v
struct EventWaitParams[T] {
pub:
	check   ?Check[T]
	timeout ?time.Duration
}
```


[[Return to contents]](#Contents)

## Events
```v
struct Events {
pub mut:
	on_raw_event   EventController[DispatchEvent]
	on_ready_event EventController[ReadyEvent]
}
```


[[Return to contents]](#Contents)

## EventController
```v
struct EventController[T] {
mut:
	id        int
	wait_fors map[int]EventWaiter[T]
	listeners map[int]EventListener[T]
}
```


[[Return to contents]](#Contents)

## Properties
```v
struct Properties {
pub:
	os      string = v_os.user_os()
	browser string = 'discord.v'
	device  string = 'discord.v'
}
```


[[Return to contents]](#Contents)

## Ratelimit
```v
struct Ratelimit {
	RestError
	retry_after f32
}
```


[[Return to contents]](#Contents)

## ReadyEvent
```v
struct ReadyEvent {
	BaseEvent
pub:
	user               User
	guilds             []UnavailableGuild
	session_id         string
	resume_gateway_url string
	application        PartialApplication
}
```


[[Return to contents]](#Contents)

## Entitlement
```v
struct Entitlement {
pub:
	// ID of the entitlement
	id Snowflake
	// ID of the SKU
	sku_id Snowflake
	// ID of the parent application
	application_id Snowflake
	// ID of the user that is granted access to the entitlement's sku
	user_id ?Snowflake
	// Type of entitlement
	typ EntitlementType
	// Whether entitlement was deleted
	deleted bool
	// Start date at which the entitlement is valid. Not present when using test entitlements.
	starts_at ?time.Time
	// Date at which the entitlement is no longer valid. Not present when using test entitlements.
	ends_at ?time.Time
	// ID of the guild that is granted access to the entitlement's sku
	guild_id ?Snowflake
}
```


[[Return to contents]](#Contents)

## RequestOptions
```v
struct RequestOptions {
	prepare        ?Prepare
	authenticate   bool = true
	reason         ?string
	json           ?json2.Any
	body           ?string
	common_headers map[http.CommonHeader]string
	headers        map[string]string
}
```


[[Return to contents]](#Contents)

## RestError
```v
struct RestError {
	code    int
	errors  map[string]json2.Any
	message string
	status  http.Status
}
```


[[Return to contents]](#Contents)

## code
```v
fn (re RestError) code() int
```


[[Return to contents]](#Contents)

## msg
```v
fn (re RestError) msg() string
```


[[Return to contents]](#Contents)

## Role
```v
struct Role {
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
```


[[Return to contents]](#Contents)

## Emoji
```v
struct Emoji {
pub:
	id             ?Snowflake
	name           ?string
	roles          ?[]Snowflake
	user           ?User
	require_colons ?bool
	managed        ?bool
	animated       ?bool
	available      ?bool
}
```


[[Return to contents]](#Contents)

## EmitOptions
```v
struct EmitOptions {
pub:
	error_handler ?fn (int, IError)
}
```


[[Return to contents]](#Contents)

## RoleSelect
```v
struct RoleSelect {
pub:
	// ID for the select menu; max 100 characters
	custom_id string
	// Placeholder text if nothing is selected; max 150 characters
	placeholder ?string
	// List of default values for auto-populated select menu components; number of default values must be in the range defined by `min_values` and `max_values`
	default_values ?[]Snowflake
	// Minimum number of items that must be chosen (defaults to 1); min 0, max 25
	min_values ?int
	// Maximum number of items that can be chosen (defaults to 1); max 25
	max_values ?int
	// Whether select menu is disabled (defaults to false)
	disabled bool
}
```


[[Return to contents]](#Contents)

## build
```v
fn (rs RoleSelect) build() json2.Any
```


[[Return to contents]](#Contents)

## RoleTags
```v
struct RoleTags {
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
```


[[Return to contents]](#Contents)

## EditApplicationParams
```v
struct EditApplicationParams {
pub:
	// Default custom authorization URL for the app, if enabled
	custom_install_url ?string
	// Description of the app
	description ?string
	// Role connection verification URL for the app
	role_connections_verification_url ?string
	// Settings for the app's default in-app authorization link, if enabled
	install_params ?InstallParams
	// App's public flags
	flags ?ApplicationFlags
	// Icon for the app
	icon ?Image = discord.sentinel_image
	// Default rich presence invite cover image for the app
	cover_image ?Image = discord.sentinel_image
	// Interactions endpoint URL for the app
	interactions_endpoint_url ?string
	// List of tags describing the content and functionality of the app (max of 20 characters per tag). Max of 5 tags.
	tags ?[]string
}
```


[[Return to contents]](#Contents)

## build
```v
fn (params EditApplicationParams) build() json2.Any
```


[[Return to contents]](#Contents)

## SelectOption
```v
struct SelectOption {
pub:
	// User-facing name of the option; max 100 characters
	label string
	// Dev-defined value of the option; max 100 characters
	value string
	// Additional description of the option; max 100 characters
	description ?string
	// `id`, `name`, and `animated`
	emoji ?PartialEmoji
	// Will show this option as selected by default
	default ?bool
}
```


[[Return to contents]](#Contents)

## build
```v
fn (so SelectOption) build() json2.Any
```


[[Return to contents]](#Contents)

## Sku
```v
struct Sku {
pub:
	// ID of SKU
	id Snowflake
	// Type of SKU
	typ SkuType
	// ID of the parent application
	application_id Snowflake
	// Customer-facing name of your premium offering
	name string
	// System-generated URL slug based on the SKU's name
	slug string
	// SKU flags combined as a bitfield
	flags SkuFlags
}
```


[[Return to contents]](#Contents)

## EditApplicationCommandPermissionsParams
```v
struct EditApplicationCommandPermissionsParams {
pub:
	// Permissions for the command in the guild
	permissions []ApplicationCommandPermission
}
```


[[Return to contents]](#Contents)

## build
```v
fn (params EditApplicationCommandPermissionsParams) build() json2.Any
```


[[Return to contents]](#Contents)

## EditApplicationCommandParams
```v
struct EditApplicationCommandParams {
pub:
	// Name of command, 1-32 characters
	name ?string
	// Localization dictionary for the `name` field. Values follow the same restrictions as `name`
	name_localizations ?map[Locale]string
	// 1-100 character description
	description ?string
	// Localization dictionary for the `description` field. Values follow the same restrictions as `description`
	description_localizations ?map[Locale]string
	// the parameters for the command
	options ?[]ApplicationCommandOption
	// Set of permissions represented as a bit set
	default_member_permissions ?Permissions = discord.sentinel_permissions
	// Indicates whether the command is available in DMs with the app, only for globally-scoped commands. By default, commands are visible.
	dm_permission ?bool
	// Indicates whether the command is age-restricted
	nsfw ?bool
}
```


[[Return to contents]](#Contents)

## build
```v
fn (params EditApplicationCommandParams) build() json2.Any
```


[[Return to contents]](#Contents)

## DispatchEvent
```v
struct DispatchEvent {
	BaseEvent
pub:
	name string
	data json2.Any
}
```


[[Return to contents]](#Contents)

## DefaultValue
```v
struct DefaultValue {
pub:
	// ID of a user, role, or channel
	id Snowflake @[required]
	// Type of value that `id` represents. Either `.user`, `.role`, or `.channel`
	typ DefaultValueType @[required]
}
```


[[Return to contents]](#Contents)

## build
```v
fn (dv DefaultValue) build() json2.Any
```


[[Return to contents]](#Contents)

## CreateTestEntitlementParams
```v
struct CreateTestEntitlementParams {
pub:
	// ID of the SKU to grant the entitlement to
	sku_id Snowflake @[required]
	// ID of the guild or user to grant the entitlement to
	owner_id Snowflake @[required]
	// `.guild` for a guild subscription, `.user` for a user subscription
	owner_type OwnerType @[required]
}
```


[[Return to contents]](#Contents)

## CreateGroupDMParams
```v
struct CreateGroupDMParams {
pub:
	access_tokens []string
	nicks         map[Snowflake]string
}
```


[[Return to contents]](#Contents)

## CreateApplicationCommandParams
```v
struct CreateApplicationCommandParams {
pub:
	// Name of command, 1-32 characters
	name string
	// Localization dictionary for the `name` field. Values follow the same restrictions as `name`
	name_localizations ?map[Locale]string
	// 1-100 character description for `.chat_input` commands
	description ?string
	// Localization dictionary for the `description` field. Values follow the same restrictions as `description`
	description_localizations ?map[Locale]string
	// the parameters for the command
	options ?[]ApplicationCommandOption
	// Set of permissions represented as a bit set
	default_member_permissions ?Permissions
	// Indicates whether the command is available in DMs with the app, only for globally-scoped commands. By default, commands are visible.
	dm_permission ?bool
	// Type of command, defaults `.chat_input` if not set
	typ ?ApplicationCommandType
	// Indicates whether the command is age-restricted
	nsfw ?bool
}
```


[[Return to contents]](#Contents)

## build
```v
fn (params CreateApplicationCommandParams) build() json2.Any
```


[[Return to contents]](#Contents)

## Sticker
```v
struct Sticker {
pub:
	id          Snowflake
	pack_id     ?Snowflake
	name        string
	description ?string
	tags        ?string
	typ         StickerType
	format_type StickerFormatType
	available   ?bool
	guild_id    ?Snowflake
	user        ?User
	sort_value  ?int
}
```


[[Return to contents]](#Contents)

## ClientConfig
```v
struct ClientConfig {
pub:
	user_agent string = discord.default_user_agent
	debug      bool
}
```


[[Return to contents]](#Contents)

## Client
```v
struct Client {
pub:
	token string

	base_url   string = 'https://discord.com/api/v10'
	user_agent string = discord.default_user_agent
mut:
	logger log.Logger
pub mut:
	user_data voidptr
}
```


[[Return to contents]](#Contents)

## bulk_overwrite_global_application_commands
```v
fn (c Client) bulk_overwrite_global_application_commands(application_id Snowflake, commands []CreateApplicationCommandParams) ![]ApplicationCommand
```
Takes a list of application commands, overwriting the existing global command list for this application. Returns 200 and a list of application command objects. Commands that do not already exist will count toward daily application command create limits.

[[Return to contents]](#Contents)

## bulk_overwrite_guild_application_commands
```v
fn (c Client) bulk_overwrite_guild_application_commands(application_id Snowflake, guild_id Snowflake, commands []CreateApplicationCommandParams) ![]ApplicationCommand
```
Takes a list of application commands, overwriting the existing command list for this application for the targeted guild. Returns 200 and a list of application command objects.

[[Return to contents]](#Contents)

## create_dm
```v
fn (c Client) create_dm(recipient_id Snowflake) !
```


[[Return to contents]](#Contents)

## create_global_application_command
```v
fn (c Client) create_global_application_command(application_id Snowflake, params CreateApplicationCommandParams) !ApplicationCommand
```
Create a new global command. Returns 201 if a command with the same name does not already exist, or a 200 if it does (in which case the previous command will be overwritten). Both responses include an application command object.

[[Return to contents]](#Contents)

## create_group_dm
```v
fn (c Client) create_group_dm(params CreateGroupDMParams) !
```


[[Return to contents]](#Contents)

## create_guild_application_command
```v
fn (c Client) create_guild_application_command(application_id Snowflake, guild_id Snowflake, params CreateApplicationCommandParams) !ApplicationCommand
```
Create a new guild command. New guild commands will be available in the guild immediately. Returns 201 if a command with the same name does not already exist, or a 200 if it does (in which case the previous command will be overwritten). Both responses include an application command object.

[[Return to contents]](#Contents)

## create_interaction_response
```v
fn (c Client) create_interaction_response(interaction_id Snowflake, interaction_token string, response IInteractionResponse) !
```


[[Return to contents]](#Contents)

## create_test_entitlement
```v
fn (c Client) create_test_entitlement(application_id Snowflake, params CreateTestEntitlementParams) !Entitlement
```
Creates a test entitlement to a given SKU for a given guild or user. Discord will act as though that user or guild has entitlement to your premium offering. After creating a test entitlement, you'll need to reload your Discord client. After doing so, you'll see that your server or user now has premium access.

[[Return to contents]](#Contents)

## delete_channel
```v
fn (c Client) delete_channel(id Snowflake, config WithReason) !
```
Delete a channel, or close a private message. Requires the `MANAGE_CHANNELS` permission for the guild, or `MANAGE_THREADS` if the channel is a thread. Deleting a category does not delete its child channels; they will have their parent_id removed and a Channel Update Gateway event will fire for each of them. Returns a channel object on success. Fires a Channel Delete Gateway event (or Thread Delete if the channel was a thread).

[[Return to contents]](#Contents)

## delete_global_application_command
```v
fn (c Client) delete_global_application_command(application_id Snowflake, command_id Snowflake) !
```
Deletes a global command. Returns 204 No Content on success.

[[Return to contents]](#Contents)

## delete_guild_application_command
```v
fn (c Client) delete_guild_application_command(application_id Snowflake, guild_id Snowflake, command_id Snowflake) !
```
Delete a guild command. Returns 204 No Content on success.

[[Return to contents]](#Contents)

## delete_message
```v
fn (c Client) delete_message(channel_id Snowflake, id Snowflake, config WithReason) !
```


[[Return to contents]](#Contents)

## delete_test_entitlement
```v
fn (c Client) delete_test_entitlement(application_id Snowflake, entitlement_id Snowflake) !
```
Deletes a currently-active test entitlement. Discord will act as though that user or guild no longer has entitlement to your premium offering.

[[Return to contents]](#Contents)

## edit_application_command_permissions
```v
fn (c Client) edit_application_command_permissions(application_id Snowflake, guild_id Snowflake, command_id Snowflake, params EditApplicationCommandPermissionsParams) !GuildApplicationCommandPermissions
```
Edits command permissions for a specific command for your application in a guild and returns a guild application command permissions object. Fires an Application Command Permissions Update Gateway event.

You can add up to 100 permission overwrites for a command.

[[Return to contents]](#Contents)

## edit_global_application_command
```v
fn (c Client) edit_global_application_command(application_id Snowflake, command_id Snowflake, params EditApplicationCommandParams) !ApplicationCommand
```
Edit a global command. Returns application command object. All fields are optional, but any fields provided will entirely overwrite the existing values of those fields.

[[Return to contents]](#Contents)

## edit_guild_application_command
```v
fn (c Client) edit_guild_application_command(application_id Snowflake, guild_id Snowflake, command_id Snowflake, params EditApplicationCommandParams) !ApplicationCommand
```
Edit a guild command. Updates for guild commands will be available immediately. Returns application command object. All fields are optional, but any fields provided will entirely overwrite the existing values of those fields.

[[Return to contents]](#Contents)

## edit_my_application
```v
fn (c Client) edit_my_application(params EditApplicationParams) !Application
```
Edit properties of the app associated with the requesting bot user. Only properties that are passed will be updated. Returns the updated application object on success.

[[Return to contents]](#Contents)

## edit_my_user
```v
fn (c Client) edit_my_user(params MyUserEdit) !User
```
Modify the requester's user account settings. Returns a user object on success. Fires a User Update Gateway event.

[[Return to contents]](#Contents)

## fetch_application_command_permissions
```v
fn (c Client) fetch_application_command_permissions(application_id Snowflake, guild_id Snowflake, command_id Snowflake) !GuildApplicationCommandPermissions
```
Fetches permissions for a specific command for your application in a guild. Returns a guild application command permissions object.

[[Return to contents]](#Contents)

## fetch_global_application_command
```v
fn (c Client) fetch_global_application_command(application_id Snowflake, command_id Snowflake) !ApplicationCommand
```
Fetch a global command for your application. Returns an application command object.

[[Return to contents]](#Contents)

## fetch_global_application_commands
```v
fn (c Client) fetch_global_application_commands(application_id Snowflake, params FetchGlobalApplicationCommandsParams) ![]ApplicationCommand
```
Fetch all of the global commands for your application. Returns an array of application command objects.

[[Return to contents]](#Contents)

## fetch_guild
```v
fn (c Client) fetch_guild(guild_id Snowflake) !Guild
```


[[Return to contents]](#Contents)

## fetch_guild_application_command
```v
fn (c Client) fetch_guild_application_command(application_id Snowflake, guild_id Snowflake, command_id Snowflake) !ApplicationCommand
```
Fetch a guild command for your application. Returns an application command object.

[[Return to contents]](#Contents)

## fetch_guild_application_command_permissions
```v
fn (c Client) fetch_guild_application_command_permissions(application_id Snowflake, guild_id Snowflake) ![]GuildApplicationCommandPermissions
```
Fetches permissions for all commands for your application in a guild. Returns an array of guild application command permissions objects.

[[Return to contents]](#Contents)

## fetch_my_application
```v
fn (c Client) fetch_my_application() !Application
```
Returns the application object associated with the requesting bot user.

[[Return to contents]](#Contents)

## fetch_my_guild_member
```v
fn (c Client) fetch_my_guild_member(guild_id Snowflake) !GuildMember
```
Returns a guild member object for the current user. Requires the guilds.members.read OAuth2 scope.

[[Return to contents]](#Contents)

## fetch_my_guilds
```v
fn (c Client) fetch_my_guilds(params FetchMyGuildsParams) ![]PartialGuild
```


[[Return to contents]](#Contents)

## fetch_my_user
```v
fn (c Client) fetch_my_user() !User
```
Returns the user object of the requester's account. For OAuth2, this requires the `identify` scope, which will return the object without an email, and optionally the `email` scope, which returns the object _with_ an email.

[[Return to contents]](#Contents)

## fetch_user
```v
fn (c Client) fetch_user(user_id Snowflake) !User
```
Returns a user object for a given user ID.

[[Return to contents]](#Contents)

## leave_guild
```v
fn (c Client) leave_guild(guild_id Snowflake) !
```
Leave a guild. Fires a Guild Delete Gateway event and a Guild Member Remove Gateway event.

[[Return to contents]](#Contents)

## list_entitlements
```v
fn (c Client) list_entitlements(application_id Snowflake, params ListEntitlementParams) ![]Entitlement
```
Returns all entitlements for a given app, active and expired.

[[Return to contents]](#Contents)

## list_skus
```v
fn (c Client) list_skus(application_id Snowflake) ![]Sku
```


[[Return to contents]](#Contents)

## request
```v
fn (c Client) request(method http.Method, route string, options RequestOptions) !http.Response
```


[[Return to contents]](#Contents)

## ChannelSelect
```v
struct ChannelSelect {
pub:
	// ID for the select menu; max 100 characters
	custom_id string
	// List of channel types to include in the channel select component
	channel_types ?[]ChannelType
	// Placeholder text if nothing is selected; max 150 characters
	placeholder ?string
	// List of default values for auto-populated select menu components; number of default values must be in the range defined by `min_values` and `max_values`
	default_values ?[]Snowflake
	// Minimum number of items that must be chosen (defaults to 1); min 0, max 25
	min_values ?int
	// Maximum number of items that can be chosen (defaults to 1); max 25
	max_values ?int
	// Whether select menu is disabled (defaults to false)
	disabled bool
}
```


[[Return to contents]](#Contents)

## build
```v
fn (cs ChannelSelect) build() json2.Any
```


[[Return to contents]](#Contents)

## StringSelect
```v
struct StringSelect {
pub:
	// ID for the select menu; max 100 characters
	custom_id string
	// Specified choices in a select menu (only required and available for string selects (type 3); max 25
	options []SelectOption
	// Placeholder text if nothing is selected; max 150 characters
	placeholder ?string
	// Minimum number of items that must be chosen (defaults to 1); min 0, max 25
	min_values ?int
	// Maximum number of items that can be chosen (defaults to 1); max 25
	max_values ?int
	// Whether select menu is disabled (defaults to false)
	disabled bool
}
```


[[Return to contents]](#Contents)

## build
```v
fn (ss StringSelect) build() json2.Any
```


[[Return to contents]](#Contents)

## Button
```v
struct Button {
pub:
	// A button style, default is `.secondary`
	style ButtonStyle = .secondary
	// Text that appears on the button; max 80 characters
	label ?string
	// `name`, `id`, and `animated`
	emoji ?PartialEmoji
	// Developer-defined identifier for the button; max 100 characters
	custom_id ?string
	// URL for link-style buttons
	url ?string
	// Whether the button is disabled (defaults to false)
	disabled bool
}
```
Buttons are interactive components that render in messages. They can be clicked by users, and send an interaction to your app when clicked.

- Buttons must be sent inside an Action Row
- An Action Row can contain up to 5 buttons
- An Action Row containing buttons cannot also contain any select menu components
<br/>

Buttons come in a variety of styles to convey different types of actions. These styles also define what fields are valid for a button.

- Non-link buttons must have a custom_id, and cannot have a url
- Link buttons must have a url, and cannot have a custom_id
- Link buttons do not send an interaction to your app when clicked


[[Return to contents]](#Contents)

## build
```v
fn (b Button) build() json2.Any
```


[[Return to contents]](#Contents)

## Team
```v
struct Team {
pub:
	// Hash of the image of the team's icon
	icon ?string
	// Unique ID of the team
	id Snowflake
	// Members of the team
	members []TeamMember
	// Name of the team
	name string
	// User ID of the current team owner
	owner_user_id Snowflake
}
```


[[Return to contents]](#Contents)

## BotConfig
```v
struct BotConfig {
	ClientConfig
pub:
	properties Properties
	intents    Intents
}
```


[[Return to contents]](#Contents)

## TeamMember
```v
struct TeamMember {
pub:
	// User's membership state on the team
	membership_state MembershipState
	// ID of the parent team of which they are a member
	team_id Snowflake
	// Avatar, discriminator, ID, and username of the user
	user PartialUser
	// Role of the team member
	role TeamMemberRole
}
```


[[Return to contents]](#Contents)

## BaseEvent
```v
struct BaseEvent {
pub mut:
	creator &GatewayClient
}
```


[[Return to contents]](#Contents)

## Awaitable
```v
struct Awaitable[T] {
	id      int
	timeout ?time.Duration
mut:
	controller &EventController[T]
}
```


[[Return to contents]](#Contents)

## TextInput
```v
struct TextInput {
pub:
	// Developer-defined identifier for the input; max 100 characters
	custom_id string @[required]
	// The Text Input Style
	style TextInputStyle = .short
	// Label for this component; max 45 characters
	label string @[required]
	// Minimum input length for a text input; min 0, max 4000
	min_length ?int
	// Maximum input length for a text input; min 1, max 4000
	max_length ?int
	// Whether this component is required to be filled (defaults to `true`)
	required bool = true
	// Pre-filled value for this component; max 4000 characters
	value ?string
	// Custom placeholder text if the input is empty; max 100 characters
	placeholder ?string
}
```
Text inputs are an interactive component that render in modals. They can be used to collect short-form or long-form text. When defining a text input component, you can set attributes to customize the behavior and appearance of it. However, not all attributes will be returned in the text input interaction payload.

[[Return to contents]](#Contents)

## build
```v
fn (ti TextInput) build() json2.Any
```


[[Return to contents]](#Contents)

## AvatarDecorationData
```v
struct AvatarDecorationData {
pub:
	asset  string
	sku_id Snowflake
}
```


[[Return to contents]](#Contents)

## Unauthorized
```v
struct Unauthorized {
	RestError
}
```


[[Return to contents]](#Contents)

## UnavailableGuild
```v
struct UnavailableGuild {
pub:
	id          Snowflake
	unavailable bool
}
```


[[Return to contents]](#Contents)

## ApplicationCommandPermission
```v
struct ApplicationCommandPermission {
pub:
	// ID of the role, user, or channel. It can also be a permission constant
	id Snowflake
	// role (`.role`), user (`.user`), or channel (`.channel`)
	typ ApplicationCommandPermissionType
	// `true` to allow, `false`, to disallow
	permission bool
}
```


[[Return to contents]](#Contents)

## build
```v
fn (acp ApplicationCommandPermission) build() json2.Any
```


[[Return to contents]](#Contents)

## User
```v
struct User {
pub:
	// the user's id
	id Snowflake
	// the user's username, not unique across the platform
	username string
	// the user's Discord-tag
	discriminator string
	// the user's display name, if it is set. For bots, this is the application name
	global_name ?string
	// the user's avatar hash
	avatar ?string
	// whether the user belongs to an OAuth2 application
	bot ?bool
	// whether the user is an Official Discord System user (part of the urgent message system)
	system ?bool
	// whether the user has two factor enabled on their account
	mfa_enabled ?bool
	// the user's banner hash
	banner ?string
	// the user's banner color encoded as an integer representation of hexadecimal color code
	accent_color ?int
	// the user's chosen language option
	locale ?string
	// whether the email on this account has been verified
	verified ?bool
	// the user's email
	email ?string
	// the flags on a user's account
	flags ?UserFlags
	// the type of Nitro subscription on a user's account
	premium_type ?PremiumType
	// the public flags on a user's account
	public_flags ?UserFlags
	// data for the user's avatar decoration
	avatar_decoration ?AvatarDecorationData
}
```


[[Return to contents]](#Contents)

## ApplicationCommandOptionChoice
```v
struct ApplicationCommandOptionChoice {
pub:
	// 1-100 character choice name
	name string
	// Localization dictionary for the `name` field. Values follow the same restrictions as `name`
	name_localizations ?map[Locale]string
	// Value for the choice, up to 100 characters if string
	value ApplicationCommandOptionChoiceValue
}
```


[[Return to contents]](#Contents)

## build
```v
fn (acoc ApplicationCommandOptionChoice) build() json2.Any
```


[[Return to contents]](#Contents)

## ApplicationCommandOption
```v
struct ApplicationCommandOption {
pub:
	// Type of option
	typ ApplicationCommandOptionType
	// 1-32 character name
	name string
	// Localization dictionary for the `name` field. Values follow the same restrictions as `name`
	name_localizations ?map[Locale]string
	// 1-100 character description
	description string
	// Localization dictionary for the `description` field. Values follow the same restrictions as `description`
	description_localizations ?map[Locale]string
	// If the parameter is required or optional--default `false`
	required ?bool
	// Choices for `.string_`, `.integer`, and `.number` types for the user to pick from, max 25
	choices ?[]ApplicationCommandOptionChoice
	// If the option is a subcommand or subcommand group type, these nested options will be the parameters
	options ?[]ApplicationCommandOption
	// If the option is a channel type, the channels shown will be restricted to these types
	channel_types ?[]ChannelType
	// If the option is an `.integer` or `.number` type, the minimum value permitted
	min_value ?int
	// If the option is an `.integer` or `.number` type, the maximum value permitted
	max_value ?int
	// For option type `.string_`, the minimum allowed length (minimum of `0`, maximum of `6000`)
	min_length ?int
	// For option type `.string_`, the maximum allowed length (minimum of `1`, maximum of `6000`)
	max_length ?int
	// If autocomplete interactions are enabled for this `.string_`, `.integer`, or `.number` type option
	autocomplete ?bool
}
```


[[Return to contents]](#Contents)

## build
```v
fn (aco ApplicationCommandOption) build() json2.Any
```


[[Return to contents]](#Contents)

## UserSelect
```v
struct UserSelect {
pub:
	// ID for the select menu; max 100 characters
	custom_id string
	// Placeholder text if nothing is selected; max 150 characters
	placeholder ?string
	// List of default values for auto-populated select menu components; number of default values must be in the range defined by `min_values` and `max_values`
	default_values ?[]Snowflake
	// Minimum number of items that must be chosen (defaults to 1); min 0, max 25
	min_values ?int
	// Maximum number of items that can be chosen (defaults to 1); max 25
	max_values ?int
	// Whether select menu is disabled (defaults to false)
	disabled bool
}
```


[[Return to contents]](#Contents)

## build
```v
fn (us UserSelect) build() json2.Any
```


[[Return to contents]](#Contents)

## ApplicationCommand
```v
struct ApplicationCommand {
pub:
	// Unique ID of command
	id Snowflake
	// Type of command, defaults to 1
	typ ApplicationCommandType = .chat_input
	// ID of the parent application
	application_id Snowflake
	// Guild ID of the command, if not global
	guild_id ?Snowflake
	// Name of command, 1-32 characters
	name string
	// Localization dictionary for `name` field. Values follow the same restrictions as `name`
	name_localizations ?map[Locale]string
	// Description for `.chat_input` commands, 1-100 characters. Empty string for `.user` and `.message` commands
	description string
	// Localization dictionary for `description` field. Values follow the same restrictions as `description`
	description_localizations ?map[Locale]string
	// Parameters for the command, max of 25
	options ?[]ApplicationCommandOption
	// Set of permissions represented as a bit set
	default_member_permissions ?Permissions
	// Indicates whether the command is available in DMs with the app, only for globally-scoped commands. By default, commands are visible.
	dm_permission ?bool
	// Indicates whether the command is age-restricted, defaults to `false`
	nsfw ?bool
}
```


[[Return to contents]](#Contents)

## WelcomeChannel
```v
struct WelcomeChannel {
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
```


[[Return to contents]](#Contents)

## Application
```v
struct Application {
pub:
	// ID of the app
	id Snowflake
	// Name of the app
	name string
	// Icon hash of the app
	icon ?string
	// Description of the app
	description string
	// List of RPC origin URLs, if RPC is enabled
	rpc_origins ?[]string
	// When `false`, only the app owner can add the app to guilds
	bot_public bool
	// When `true`, the app's bot will only join upon completion of the full OAuth2 code grant flow
	bot_require_code_grant bool
	// Partial user object for the bot user associated with the app
	bot ?User
	// URL of the app's Terms of Service
	terms_of_service_url ?string
	// URL of the app's Privacy Policy
	privacy_policy_url ?string
	// Partial user object for the owner of the app
	owner ?User
	// Hex encoded key for verification in interactions and the GameSDK's GetTicket
	verify_key string
	// If the app belongs to a team, this will be a list of the members of that team
	team ?Team
	// Guild associated with the app. For example, a developer support server.
	guild_id ?Snowflake
	// Partial object of the associated guild
	guild ?PartialGuild
	// If this app is a game sold on Discord, this field will be the id of the "Game SKU" that is created, if exists
	primary_sku_id ?Snowflake
	// If this app is a game sold on Discord, this field will be the URL slug that links to the store page
	slug ?string
	// App's default rich presence invite cover image hash
	cover_image ?string
	// App's public flags
	flags ?ApplicationFlags
	// Approximate count of guilds the app has been added to
	approximate_guild_count ?int
	// Array of redirect URIs for the app
	redirect_uris ?[]string
	// Interactions endpoint URL for the app
	interactions_endpoint_url ?string
	// Role connection verification URL for the app
	role_connections_verification_url ?string
	// List of tags describing the content and functionality of the app. Max of 5 tags.
	tags ?[]string
	// Settings for the app's default in-app authorization link, if enabled
	install_params ?InstallParams
	// Default custom authorization URL for the app, if enabled
	custom_install_url ?string
}
```


[[Return to contents]](#Contents)

## WelcomeScreen
```v
struct WelcomeScreen {
pub:
	// the server description shown in the welcome screen
	description ?string
	// the channels shown in the welcome screen, up to 5
	welcome_channels []WelcomeChannel
}
```


[[Return to contents]](#Contents)

## ActionRow
```v
struct ActionRow {
pub:
	components []Component
}
```
An Action Row is a non-interactive container component for other types of components. It has a sub-array of components of other types.- You can have up to 5 Action Rows per message
- An Action Row cannot contain another Action Row


[[Return to contents]](#Contents)

## build
```v
fn (ar ActionRow) build() json2.Any
```


[[Return to contents]](#Contents)

## WithReason
```v
struct WithReason {
pub:
	reason ?string
}
```


[[Return to contents]](#Contents)

## WSMessage
```v
struct WSMessage {
pub:
	opcode int
	data   json2.Any
	seq    ?int
	event  string
}
```


[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 12 Dec 2023 17:15:11
