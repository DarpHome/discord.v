module discord

pub enum AuditLogEvent {
	// Server settings were updated
	guild_update                                = 1
	// Channel was created
	channel_create                              = 10
	// Channel settings were updated
	channel_update
	// Channel was deleted
	channel_delete
	// Permission overwrite was added to a channel
	channel_overwrite_create
	// Permission overwrite was updated for a channel
	channel_overwrite_update
	// Permission overwrite was deleted from a channel
	channel_overwrite_delete
	// Member was removed from server
	member_kick                                 = 20
	// Members were pruned from server
	member_prune
	// Member was banned from server
	member_ban_add
	// Server ban was lifted for a member
	member_ban_remove
	// Member was updated in server
	member_update
	// Member was added or removed from a role
	member_role_update
	// Member was moved to a different voice channel
	member_move
	// Member was disconnected from a voice channel
	member_disconnect
	// Bot user was added to server
	bot_add
	// Role was created
	role_create                                 = 30
	// Role was edited
	role_update
	// Role was deleted
	role_delete
	// Server invite was created
	invite_create                               = 40
	// Server invite was updated
	invite_update
	// Server invite was deleted
	invite_delete
	// Webhook was created
	webhook_create
	// Webhook properties or channel were updated
	webhook_update
	// Webhook was deleted
	webhook_delete
	// Emoji was created
	emoji_create
	// Emoji name was updated
	emoji_update
	// Emoji was deleted
	emoji_delete
	// Single message was deleted
	message_delete                              = 72
	// Multiple messages were deleted
	message_bulk_delete
	// Message was pinned to a channel
	message_pin
	// Message was unpinned from a channel
	message_unpin
	// App was added to server
	integration_create                          = 80
	// App was updated (as an example, its scopes were updated)
	integration_update
	// App was removed from server
	integration_delete
	// Stage instance was created (stage channel becomes live)
	stage_instance_create
	// Stage instance details were updated
	stage_instance_update
	// Stage instance was deleted (stage channel no longer live)
	stage_instance_delete
	// Sticker was created
	sticker_create                              = 90
	// Sticker details were updated
	sticker_update
	// Sticker was deleted
	sticker_delete
	// Event was created
	guild_scheduled_event_create                = 100
	// Event was updated
	guild_scheduled_event_update
	// Event was cancelled
	guild_scheduled_event_delete
	// Thread was created in a channel
	thread_create                               = 110
	// Thread was updated
	thread_update
	// Thread was deleted
	thread_delete
	// Permissions were updated for a command
	application_command_permission_update       = 121
	// Auto Moderation rule was created
	auto_moderation_rule_create                 = 140
	// Auto Moderation rule was updated
	auto_moderation_rule_update
	// Auto Moderation rule was deleted
	auto_moderation_rule_delete
	// Message was blocked by Auto Moderation
	auto_moderation_block_message
	// Message was flagged by Auto Moderation
	auto_moderation_flag_to_channel
	// Member was timed out by Auto Moderation
	auto_moderation_user_communication_disabled
	// Creator monetization request was created
	creator_monetization_request_created        = 150
	// Creator monetization terms were accepted
	creator_monetization_terms_accepted
}
