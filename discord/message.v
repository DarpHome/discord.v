module discord

import encoding.base64
import net.urllib
import time
import x.json2

pub struct ChannelMention {
pub:
	// id of the channel
	id Snowflake
	// id of the guild containing the channel
	guild_id Snowflake
	// the type of channel
	typ ChannelType
	// the name of the channel
	name string
}

pub fn ChannelMention.parse(j json2.Any) !ChannelMention {
	match j {
		map[string]json2.Any {
			return ChannelMention{
				id: Snowflake.parse(j['id']!)!
				guild_id: Snowflake.parse(j['guild_id']!)!
				typ: unsafe { ChannelType(j['type']!.int()) }
				name: j['name']! as string
			}
		}
		else {
			return error('expected channel mention to be object, got ${j.type_name()}')
		}
	}
}

@[flag]
pub enum AttachmentFlags {
	reserved_0
	reserved_1
	// this attachment has been edited using the remix feature on mobile
	is_remix
}

pub struct Attachment {
pub:
	// attachment id
	id Snowflake
	// name of file attached
	filename string
	// description for the file (max 1024 characters)
	description ?string
	// the attachment's media type
	content_type ?string
	// size of file in bytes
	size int
	// source url of file
	url string
	// a proxied url of file
	proxy_url string
	// height of file (if image)
	height ?int
	// width of file (if image)
	width ?int
	// whether this attachment is ephemeral
	ephemeral ?bool
	// the duration of the audio file (currently for voice messages)
	duration_secs ?time.Duration
	// base64 encoded bytearray representing a sampled waveform (currently for voice messages)
	waveform ?[]u8
	// attachment flags combined as a bitfield
	flags ?AttachmentFlags
}

pub fn Attachment.parse(j json2.Any) !Attachment {
	match j {
		map[string]json2.Any {
			return Attachment{
				id: Snowflake.parse(j['id']!)!
				filename: j['filename']! as string
				description: if s := j['description'] {
					?string(s as string)
				} else {
					none
				}
				content_type: if s := j['content_type'] {
					?string(s as string)
				} else {
					none
				}
				size: j['size']!.int()
				url: j['url']! as string
				proxy_url: j['proxy_url']! as string
				height: if i := j['height'] {
					if i !is json2.Null {
						?int(i.int())
					} else {
						none
					}
				} else {
					none
				}
				width: if i := j['width'] {
					if i !is json2.Null {
						?int(i.int())
					} else {
						none
					}
				} else {
					none
				}
				ephemeral: if b := j['ephemeral'] {
					?bool(b as bool)
				} else {
					none
				}
				duration_secs: if f := j['duration_secs'] {
					?time.Duration(i64(f.f64() * f64(time.second)))
				} else {
					none
				}
				waveform: if s := j['waveform'] {
					?[]u8(base64.decode(s as string))
				} else {
					none
				}
				flags: if i := j['flags'] {
					?AttachmentFlags(unsafe { AttachmentFlags(i.int()) })
				} else {
					none
				}
			}
		}
		else {
			return error('expected attachment to be object, got ${j.type_name()}')
		}
	}
}

pub struct EmbedThumbnail {
pub:
	// source url of thumbnail (only supports http(s) and attachments)
	url string
	// a proxied url of the thumbnail
	proxy_url ?string
	// height of thumbnail
	height ?int
	// width of thumbnail
	width ?int
}

pub fn EmbedThumbnail.parse(j json2.Any) !EmbedThumbnail {
	match j {
		map[string]json2.Any {
			return EmbedThumbnail{
				url: j['url']! as string
				proxy_url: if s := j['proxy_url'] {
					?string(s as string)
				} else {
					none
				}
				height: if i := j['height'] {
					?int(i.int())
				} else {
					none
				}
				width: if i := j['width'] {
					?int(i.int())
				} else {
					none
				}
			}
		}
		else {
			return error('expected embed thumbnail to be object, got ${j.type_name()}')
		}
	}
}

pub fn (et EmbedThumbnail) build() json2.Any {
	return {
		'url': json2.Any(et.url)
	}
}

pub struct EmbedVideo {
pub:
	// source url of video
	url ?string
	// a proxied url of the video
	proxy_url ?string
	// height of video
	height ?int
	// width of video
	width ?int
}

pub fn EmbedVideo.parse(j json2.Any) !EmbedVideo {
	match j {
		map[string]json2.Any {
			return EmbedVideo{
				url: if s := j['url'] {
					?string(s as string)
				} else {
					none
				}
				proxy_url: if s := j['proxy_url'] {
					?string(s as string)
				} else {
					none
				}
				height: if i := j['height'] {
					?int(i.int())
				} else {
					none
				}
				width: if i := j['width'] {
					?int(i.int())
				} else {
					none
				}
			}
		}
		else {
			return error('expected embed video to be object, got ${j.type_name()}')
		}
	}
}

pub fn (ev EmbedVideo) build() json2.Any {
	return {
		'url': json2.Any(ev.url)
	}
}

pub struct EmbedImage {
pub:
	// source url of image (only supports http(s) and attachments)
	url string
	// a proxied url of the image
	proxy_url ?string
	// height of image
	height ?int
	// width of image
	width ?int
}

pub fn EmbedImage.parse(j json2.Any) !EmbedImage {
	match j {
		map[string]json2.Any {
			return EmbedImage{
				url: j['url']! as string
				proxy_url: if s := j['proxy_url'] {
					?string(s as string)
				} else {
					none
				}
				height: if i := j['height'] {
					?int(i.int())
				} else {
					none
				}
				width: if i := j['width'] {
					?int(i.int())
				} else {
					none
				}
			}
		}
		else {
			return error('expected embed image to be object, got ${j.type_name()}')
		}
	}
}

pub fn (ei EmbedImage) build() json2.Any {
	return {
		'url': json2.Any(ei.url)
	}
}

pub struct EmbedProvider {
pub:
	// name of provider
	name string
	// url of provider
	url ?string
}

pub fn EmbedProvider.parse(j json2.Any) !EmbedProvider {
	match j {
		map[string]json2.Any {
			return EmbedProvider{
				name: j['name']! as string
				url: if s := j['url'] {
					?string(s as string)
				} else {
					none
				}
			}
		}
		else {
			return error('expected embed provider to be object, got ${j.type_name()}')
		}
	}
}

pub fn (ep EmbedProvider) build() json2.Any {
	mut r := {
		'name': json2.Any(ep.name)
	}
	if url := ep.url {
		r['url'] = url
	}
	return r
}

pub struct EmbedAuthor {
pub:
	// name of author
	name string
	// url of author (only supports http(s))
	url ?string
	// url of author icon (only supports http(s) and attachments)
	icon_url ?string
	// a proxied url of author icon
	proxy_icon_url ?string
}

pub fn EmbedAuthor.parse(j json2.Any) !EmbedAuthor {
	match j {
		map[string]json2.Any {
			return EmbedAuthor{
				name: j['name']! as string
				url: if s := j['url'] {
					?string(s as string)
				} else {
					none
				}
				icon_url: if s := j['icon_url'] {
					?string(s as string)
				} else {
					none
				}
				proxy_icon_url: if s := j['proxy_icon_url'] {
					?string(s as string)
				} else {
					none
				}
			}
		}
		else {
			return error('expected embed author to be object, got ${j.type_name()}')
		}
	}
}

pub fn (ea EmbedAuthor) build() json2.Any {
	mut r := {
		'name': json2.Any(ea.name)
	}
	if url := ea.url {
		r['url'] = url
	}
	if icon_url := ea.icon_url {
		r['icon_url'] = icon_url
	}
	return r
}

pub struct EmbedFooter {
pub:
	// footer text
	text string
	// url of footer icon (only supports http(s) and attachments)
	icon_url ?string
	// a proxied url of footer icon
	proxy_icon_url ?string
}

pub fn EmbedFooter.parse(j json2.Any) !EmbedFooter {
	match j {
		map[string]json2.Any {
			return EmbedFooter{
				text: j['text']! as string
				icon_url: if s := j['icon_url'] {
					?string(s as string)
				} else {
					none
				}
				proxy_icon_url: if s := j['proxy_icon_url'] {
					?string(s as string)
				} else {
					none
				}
			}
		}
		else {
			return error('expected embed footer to be object, got ${j.type_name()}')
		}
	}
}

pub fn (ef EmbedFooter) build() json2.Any {
	mut r := {
		'text': json2.Any(ef.text)
	}
	if icon_url := ef.icon_url {
		r['icon_url'] = icon_url
	}
	return r
}

pub struct EmbedField {
pub:
	// name of the field
	name string
	// value of the field
	value string
	// whether or not this field should display inline
	inline ?bool
}

pub fn EmbedField.parse(j json2.Any) !EmbedField {
	match j {
		map[string]json2.Any {
			return EmbedField{
				name: j['name']! as string
				value: j['value']! as string
				inline: if b := j['inline'] {
					?bool(b as bool)
				} else {
					none
				}
			}
		}
		else {
			return error('expected embed field to be object, got ${j.type_name()}')
		}
	}
}

pub fn (ef EmbedField) build() json2.Any {
	mut r := {
		'name':  json2.Any(ef.name)
		'value': ef.value
	}
	if inline := ef.inline {
		r['inline'] = inline
	}
	return r
}

pub struct Embed {
pub:
	// title of embed
	title ?string
	// description of embed
	description ?string
	// url of embed
	url ?string
	// timestamp of embed content
	timestamp ?time.Time
	// color code of the embed
	color ?int
	// footer information
	footer ?EmbedFooter
	// image information
	image ?EmbedImage
	// thumbnail information
	thumbnail ?EmbedThumbnail
	// video information
	video ?EmbedVideo
	// provider information
	provider ?EmbedProvider
	// author information
	author ?EmbedAuthor
	// fields information
	fields ?[]EmbedField
}

pub fn Embed.parse(j json2.Any) !Embed {
	match j {
		map[string]json2.Any {
			return Embed{
				title: if s := j['title'] {
					?string(s as string)
				} else {
					none
				}
				description: if s := j['description'] {
					?string(s as string)
				} else {
					none
				}
				url: if s := j['url'] {
					?string(s as string)
				} else {
					none
				}
				timestamp: if s := j['timestamp'] {
					?time.Time(time.parse_iso8601(s as string)!)
				} else {
					none
				}
				color: if i := j['color'] {
					?int(i.int())
				} else {
					none
				}
				footer: if o := j['footer'] {
					?EmbedFooter(EmbedFooter.parse(o)!)
				} else {
					none
				}
				image: if o := j['image'] {
					?EmbedImage(EmbedImage.parse(o)!)
				} else {
					none
				}
				thumbnail: if o := j['thumbnail'] {
					?EmbedThumbnail(EmbedThumbnail.parse(o)!)
				} else {
					none
				}
				video: if o := j['video'] {
					?EmbedVideo(EmbedVideo.parse(o)!)
				} else {
					none
				}
				provider: if o := j['provider'] {
					?EmbedProvider(EmbedProvider.parse(o)!)
				} else {
					none
				}
				author: if o := j['author'] {
					?EmbedAuthor(EmbedAuthor.parse(o)!)
				} else {
					none
				}
				fields: if a := j['fields'] {
					?[]EmbedField((a as []json2.Any).map(EmbedField.parse(it)!))
				} else {
					none
				}
			}
		}
		else {
			return error('expected embed to be object, got ${j.type_name()}')
		}
	}
}

pub fn (e Embed) build() json2.Any {
	mut r := map[string]json2.Any{}
	if title := e.title {
		r['title'] = title
	}
	if description := e.description {
		r['description'] = description
	}
	if url := e.url {
		r['url'] = url
	}
	if timestamp := e.timestamp {
		r['timestamp'] = format_iso8601(timestamp)
	}
	if color := e.color {
		r['color'] = color
	}
	if footer := e.footer {
		r['footer'] = footer.build()
	}
	if image := e.image {
		r['image'] = image.build()
	}
	if thumbnail := e.thumbnail {
		r['thumbnail'] = thumbnail.build()
	}
	if video := e.video {
		r['video'] = video.build()
	}
	if provider := e.provider {
		r['provider'] = provider.build()
	}
	if author := e.author {
		r['author'] = author.build()
	}
	if fields := e.fields {
		r['fields'] = fields.map(|field| field.build())
	}
	return r
}

pub type Nonce = int | string

pub enum MessageType {
	default
	recipient_add
	recipient_remove
	call
	channel_name_change
	channel_icon_change
	channel_pinned_message
	user_join
	guild_boost
	guild_boost_tier_1
	guild_boost_tier_2
	guild_boost_tier_3
	channel_follow_add
	guild_discovery_disqualified                = 14
	guild_discovery_requalified
	guild_discovery_grace_period_inital_warning
	guild_discovery_grace_period_final_warning
	thread_created
	reply
	chat_input_command
	thread_starter_message
	guild_invite_reminder
	context_menu_command
	auto_moderation_action
	role_subscription_purchase
	interaction_premium_upsell
	stage_start
	stage_end
	stage_speaker
	stage_topic                                 = 31
	guild_application_premium_subscription
}

pub enum MessageActivityType {
	join         = 1
	spectate
	listen
	join_request
}

pub struct MessageActivity {
pub:
	// type of message activity
	typ MessageActivityType
	// party_id from a Rich Presence event
	party_id ?Snowflake
}

pub fn MessageActivity.parse(j json2.Any) !MessageActivity {
	match j {
		map[string]json2.Any {
			return MessageActivity{
				typ: unsafe { MessageActivityType(j['type']!.int()) }
				party_id: if s := j['party_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
			}
		}
		else {
			return error('expected message activity to be object, got ${j.type_name()}')
		}
	}
}

pub struct MessageReference {
pub:
	// id of the originating message
	message_id ?Snowflake
	// id of the originating message's channel
	channel_id ?Snowflake
	// id of the originating message's guild
	guild_id ?Snowflake
	// when sending, whether to error if the referenced message doesn't exist instead of sending as a normal (non-reply) message, default true
	fail_if_not_exists ?bool
}

pub fn MessageReference.parse(j json2.Any) !MessageReference {
	match j {
		map[string]json2.Any {
			return MessageReference{
				message_id: if s := j['message_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
				channel_id: if s := j['channel_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
				guild_id: if s := j['guild_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
			}
		}
		else {
			return error('expected message reference to be object, got ${j.type_name()}')
		}
	}
}

pub fn (mr MessageReference) build() json2.Any {
	mut r := map[string]json2.Any{}
	if message_id := mr.message_id {
		r['message_id'] = message_id.build()
	}
	if channel_id := mr.channel_id {
		r['channel_id'] = channel_id.build()
	}
	if guild_id := mr.guild_id {
		r['guild_id'] = guild_id.build()
	}
	if fail_if_not_exists := mr.fail_if_not_exists {
		r['fail_if_not_exists'] = fail_if_not_exists
	}
	return r
}

@[flags]
pub enum MessageFlags {
	crossposted
	is_crosspost
	suppress_embeds
	source_message_deleted
	urgent
	has_thread
	ephemeral
	loading
	failed_to_mention_some_roles_in_thread
	reserved_9
	reserved_10
	reserved_11
	suppress_notifications
	is_voice_message
}

pub struct MessageInteraction {
pub:
	// ID of the interaction
	id Snowflake
	// Type of interaction
	typ InteractionType
	// Name of the application command, including subcommands and subcommand groups
	name string
	// User who invoked the interaction
	user User
	// Member who invoked the interaction in the guild
	member ?PartialGuildMember
}

pub fn MessageInteraction.parse(j json2.Any) !MessageInteraction {
	match j {
		map[string]json2.Any {
			return MessageInteraction{
				id: Snowflake.parse(j['id']!)!
				typ: unsafe { InteractionType(j['type']!.int()) }
				name: j['name']! as string
				user: User.parse(j['user']!)!
				member: if o := j['member'] {
					?PartialGuildMember(PartialGuildMember.parse(o)!)
				} else {
					none
				}
			}
		}
		else {
			return error('expected message interaction to be object, got ${j.type_name()}')
		}
	}
}

pub struct RoleSubscriptionData {
pub:
	// the id of the [Sku](#Sku) and listing that the user is subscribed to
	role_subscription_listing_id Snowflake
	// the name of the tier that the user is subscribed to
	tier_name string
	// the cumulative number of months that the user has been subscribed for
	total_months_subscribed int
	// whether this notification is for a renewal rather than a new purchase
	is_renewal bool
}

pub fn RoleSubscriptionData.parse(j json2.Any) !RoleSubscriptionData {
	match j {
		map[string]json2.Any {
			return RoleSubscriptionData{
				role_subscription_listing_id: Snowflake.parse(j['role_subscription_listing_id']!)!
				tier_name: j['tier_name']! as string
				total_months_subscribed: j['total_months_subscribed']! as int
				is_renewal: j['is_renewal']! as bool
			}
		}
		else {
			return error('expected role subscription data to be object, got ${j.type_name()}')
		}
	}
}

pub struct Message {
pub:
	// id of the message
	id                     Snowflake
	// id of the channel the message was sent in
	channel_id             Snowflake
	// the author of this message (not guaranteed to be a valid user, see below)
	author                 User
	// contents of the message
	content                string
	// when this message was sent
	timestamp              time.Time
	// when this message was edited (or null if never)
	edited_timestamp       ?time.Time
	// whether this was a TTS message
	tts                    bool
	// whether this message mentions everyone
	mention_everyone       bool
	// users specifically mentioned in the message
	mentions               []User
	// roles specifically mentioned in this message
	mention_roles          []Snowflake
	// channels specifically mentioned in this message
	mention_channels       ?[]ChannelMention
	// any attached files
	attachments            []Attachment
	// any embedded content
	embeds                 []Embed
	// reactions to the message
	reactions              ?[]Reaction
	// used for validating a message was sent
	nonce                  ?Nonce
	// whether this message is pinned
	pinned                 bool
	// if the message is generated by a webhook, this is the webhook's id
	webhook_id             ?Snowflake
	// type of message
	typ                    MessageType
	// sent with Rich Presence-related chat embeds
	activity               ?MessageActivity
	// sent with Rich Presence-related chat embeds
	application            ?PartialApplication
	// if the message is an Interaction or application-owned webhook, this is the id of the application
	application_id         ?Snowflake
	// data showing the source of a crosspost, channel follow add, pin, or reply message
	message_reference      ?MessageReference
	// message flags combined as a bitfield
	flags                  ?MessageFlags
	// the message associated with the message_reference
	referenced_message     ?&Message
	// sent if the message is a response to an Interaction
	interaction            ?MessageInteraction
	// the thread that was started from this message, includes thread member object
	thread                 ?Channel
	// sent if the message contains components like buttons, action rows, or other interactive components
	components             ?[]Component
	// sent if the message contains stickers
	sticker_items          ?[]StickerItem
	// A generally increasing integer (there may be gaps or duplicates) that represents the approximate position of the message in a thread, it can be used to estimate the relative position of the message in a thread in company with total_message_sent on parent thread
	position               ?int
	// data of the role subscription purchase or renewal that prompted this ROLE_SUBSCRIPTION_PURCHASE message
	role_subscription_data ?RoleSubscriptionData
}

pub fn Message.parse(j json2.Any) !Message {
	match j {
		map[string]json2.Any {
			edited_timestamp := j['edited_timestamp']!
			return Message{
				id: Snowflake.parse(j['id']!)!
				channel_id: Snowflake.parse(j['channel_id']!)!
				author: User.parse(j['author']!)!
				content: j['content']! as string
				timestamp: time.parse_iso8601(j['timestamp']! as string)!
				edited_timestamp: if edited_timestamp !is json2.Null {
					?time.Time(time.parse_iso8601(edited_timestamp as string)!)
				} else {
					none
				}
				tts: j['tts']! as bool
				mention_everyone: j['mention_everyone']! as bool
				mentions: (j['mentions']! as []json2.Any).map(User.parse(it)!)
				mention_roles: (j['mention_roles']! as []json2.Any).map(Snowflake.parse(it)!)
				mention_channels: if a := j['mention_channels'] {
					?[]ChannelMention((a as []json2.Any).map(ChannelMention.parse(it)!))
				} else {
					none
				}
				attachments: (j['attachments']! as []json2.Any).map(Attachment.parse(it)!)
				embeds: (j['embeds']! as []json2.Any).map(Embed.parse(it)!)
				reactions: if a := j['reactions'] {
					?[]Reaction((a as []json2.Any).map(Reaction.parse(it)!))
				} else {
					none
				}
				nonce: if o := j['nonce'] {
					match o {
						string {
							?Nonce(o)
						}
						int, i8, i16, i64, u8, u16, u32, u64 {
							?Nonce(int(o))
						}
						else {
							return error('expected nonce to be int/string, got ${o.type_name()}')
						}
					}
				} else {
					none
				}
				pinned: j['pinned']! as bool
				webhook_id: if s := j['webhook_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
				typ: unsafe { MessageType(j['type']!.int()) }
				activity: if o := j['activity'] {
					?MessageActivity(MessageActivity.parse(o)!)
				} else {
					none
				}
				application: if o := j['application'] {
					?PartialApplication(PartialApplication.parse(o)!)
				} else {
					none
				}
				application_id: if s := j['application_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
				message_reference: if o := j['message_reference'] {
					?MessageReference(MessageReference.parse(o)!)
				} else {
					none
				}
				flags: if i := j['flags'] {
					?MessageFlags(unsafe { MessageFlags(i.int()) })
				} else {
					none
				}
				referenced_message: if o := j['referenced_message'] {
					if o !is json2.Null {
						Message.parse(o)!
					} else {
						none
					}
				} else {
					none
				}
				interaction: if o := j['interaction'] {
					?MessageInteraction(MessageInteraction.parse(o)!)
				} else {
					none
				}
				thread: if o := j['thread'] {
					?Channel(Channel.parse(o)!)
				} else {
					none
				}
				components: if a := j['components'] {
					?[]Component((a as []json2.Any).map(Component.parse(it)!))
				} else {
					none
				}
				sticker_items: if a := j['sticker_items'] {
					?[]StickerItem((a as []json2.Any).map(StickerItem.parse(it)!))
				} else {
					none
				}
				position: if i := j['position'] {
					?int(i.int())
				} else {
					none
				}
				role_subscription_data: if o := j['role_subscription_data'] {
					?RoleSubscriptionData(RoleSubscriptionData.parse(o)!)
				} else {
					none
				}
			}
		}
		else {
			return error('expected message to be object, got ${j.type_name()}')
		}
	}
}

pub struct Message2 {
	Message
pub:
	// ID of the guild the message was sent in - unless it is an ephemeral message
	guild_id ?Snowflake
	// Member properties for this message's author. Missing for ephemeral messages and messages from webhooks
	member ?PartialGuildMember
}

pub fn Message2.parse(j json2.Any) !Message2 {
	match j {
		map[string]json2.Any {
			return Message2{
				Message: Message.parse(j)!
				guild_id: if s := j['guild_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
				member: if s := j['member'] {
					?PartialGuildMember(PartialGuildMember.parse(s)!)
				} else {
					none
				}
			}
		}
		else {
			return error('expected message2 to be object, got ${j.type_name()}')
		}
	}
}

@[params]
pub struct GetChannelMessagesParams {
pub:
	// Get messages around this message ID
	around ?Snowflake
	// Get messages before this message ID
	before ?Snowflake
	// Get messages after this message ID
	after ?Snowflake
	// Max number of messages to return (1-100)
	limit ?int
}

pub fn (params GetChannelMessagesParams) build_values() urllib.Values {
	mut query_params := urllib.new_values()
	if around := params.around {
		query_params.add('around', around.build())
	}
	if before := params.before {
		query_params.add('before', before.build())
	}
	if after := params.after {
		query_params.add('after', after.build())
	}
	if limit := params.limit {
		query_params.add('limit', limit.str())
	}
	return query_params
}

pub fn (c Client) fetch_messages(channel_id Snowflake, params GetChannelMessagesParams) ![]Message {
	return (json2.raw_decode(c.request(.get, '/channels/${urllib.path_escape(channel_id.build())}/messages${encode_query(params.build_values())}')!.body)! as []json2.Any).map(Message.parse(it)!)
}

pub fn (c Client) fetch_message(channel_id Snowflake, message_id Snowflake) !Message {
	return Message.parse(json2.raw_decode(c.request(.get, '/channels/${urllib.path_escape(channel_id.build())}/messages/${urllib.path_escape(message_id.build())}')!.body)!)!
}

pub fn (c Client) delete_message(channel_id Snowflake, message_id Snowflake, config ReasonParam) ! {
	c.request(.delete, '/channels/${urllib.path_escape(channel_id.build())}/messages/${urllib.path_escape(message_id.build())}',
		reason: config.reason
	)!
}
