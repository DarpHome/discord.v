module discord

import net.urllib
import time
import x.json2

// Characterizes the type of content which can trigger the rule.
pub enum TriggerType {
	// check if content contains words from a user defined list of keywords
	keyword        = 1
	// check if content represents generic spam
	spam           = 3
	// check if content contains words from internal pre-defined wordsets
	keyword_preset
	// check if content contains more unique mentions than allowed
	mention_spam
}

pub enum KeywordPresetType {
	// words that may be considered forms of swearing or cursing
	profanity      = 1
	// words that refer to sexually explicit behavior or activity
	sexual_content
	// personal insults or words that may be considered hate speech
	slurs
}

// Indicates in what event context a rule should be checked.
pub enum EventType {
	// when a member sends or edits a message in the guild
	message_send = 1
}

// Additional data used to determine whether a rule should be triggered. Different fields are relevant based on the value of `trigger_type`.
pub struct TriggerMetadata {
pub:
	// substrings which will be searched for in content (Maximum of 1000)
	keyword_filter ?[]string
	// regular expression patterns which will be matched against content (Maximum of 10)
	regex_patterns ?[]string
	// the internally pre-defined wordsets which will be searched for in content
	presets ?[]KeywordPresetType
	// substrings which should not trigger the rule (Maximum of 100 or 1000)
	allow_list ?[]string
	// total number of unique role and user mentions allowed per message (Maximum of 50)
	mention_total_limit ?int
	// whether to automatically detect mention raids
	mention_raid_protection_enabled ?bool
}

pub fn (tm TriggerMetadata) build() json2.Any {
	mut r := map[string]json2.Any{}
	if keyword_filter := tm.keyword_filter {
		r['keyword_filter'] = keyword_filter.map(|s| json2.Any(s))
	}
	if regex_patterns := tm.regex_patterns {
		r['regex_patterns'] = regex_patterns.map(|s| json2.Any(s))
	}
	if presets := tm.presets {
		r['presets'] = presets.map(|i| json2.Any(int(i)))
	}
	if allow_list := tm.allow_list {
		r['allow_list'] = allow_list.map(|s| json2.Any(s))
	}
	if mention_total_limit := tm.mention_total_limit {
		r['mention_total_limit'] = mention_total_limit
	}
	if mention_raid_protection_enabled := tm.mention_raid_protection_enabled {
		r['mention_raid_protection_enabled'] = mention_raid_protection_enabled
	}
	return r
}

pub fn TriggerMetadata.parse(j json2.Any) !TriggerMetadata {
	match j {
		map[string]json2.Any {
			return TriggerMetadata{
				keyword_filter: if a := j['keyword_filter'] {
					?[]string((a as []json2.Any).map(|s| s as string))
				} else {
					none
				}
				regex_patterns: if a := j['regex_patterns'] {
					?[]string((a as []json2.Any).map(|s| s as string))
				} else {
					none
				}
				presets: if a := j['presets'] {
					?[]KeywordPresetType((a as []json2.Any).map(|i| unsafe { KeywordPresetType(i.int()) }))
				} else {
					none
				}
				allow_list: if a := j['allow_list'] {
					?[]string((a as []json2.Any).map(|s| s as string))
				} else {
					none
				}
				mention_total_limit: if i := j['mention_total_limit'] {
					?int(i.int())
				} else {
					none
				}
				mention_raid_protection_enabled: if b := j['mention_raid_protection_enabled'] {
					?bool(b as bool)
				} else {
					none
				}
			}
		}
		else {
			return error('expected trigger metadata to be object, got ${j.type_name()}')
		}
	}
}

pub enum ActionType {
	// blocks a member's message and prevents it from being posted. A custom explanation can be specified and shown to members whenever their message is blocked.
	block_message      = 1
	// logs user content to a specified channel
	send_alert_message
	// timeout user for a specified duration
	timeout
}

pub struct ActionMetadata {
pub:
	// channel to which user content should be logged
	channel_id ?Snowflake
	// timeout duration in seconds
	duration_seconds ?time.Duration
	// additional explanation that will be shown to members whenever their message is blocked
	custom_message ?string
}

pub fn (am ActionMetadata) build() json2.Any {
	mut r := map[string]json2.Any{}
	if channel_id := am.channel_id {
		r['channel_id'] = channel_id.build()
	}
	if duration_seconds := am.duration_seconds {
		r['duration_seconds'] = duration_seconds / time.second
	}
	if custom_message := am.custom_message {
		r['custom_message'] = custom_message
	}
	return r
}

pub fn ActionMetadata.parse(j json2.Any) !ActionMetadata {
	match j {
		map[string]json2.Any {
			return ActionMetadata{
				channel_id: if s := j['channel_id'] {
					?Snowflake(Snowflake.parse(s)!)
				} else {
					none
				}
				duration_seconds: if i := j['duration_seconds'] {
					?time.Duration(i.int() * time.second)
				} else {
					none
				}
				custom_message: if s := j['custom_message'] {
					?string(s as string)
				} else {
					none
				}
			}
		}
		else {
			return error('expected action metadta to be object, got ${j.type_name()}')
		}
	}
}

pub struct Action {
pub:
	// the type of action
	typ ActionType
	// additional metadata needed during execution for this specific action type
	metadata ?ActionMetadata
}

pub fn (a Action) build() json2.Any {
	mut r := {
		'type': json2.Any(int(a.typ))
	}
	if metadata := a.metadata {
		r['metadata'] = metadata.build()
	}
	return r
}

pub fn Action.parse(j json2.Any) !Action {
	match j {
		map[string]json2.Any {
			return Action{
				typ: unsafe { ActionType(j['type']!.int()) }
				metadata: if o := j['metadata'] {
					?ActionMetadata(ActionMetadata.parse(o)!)
				} else {
					none
				}
			}
		}
		else {
			return error('expected action to be object, got ${j.type_name()}')
		}
	}
}

pub struct AutoModerationRule {
pub:
	// the id of this rule
	id Snowflake
	// the id of the guild which this rule belongs to
	guild_id Snowflake
	// the rule name
	name string
	// the user which first created this rule
	creator_id Snowflake
	// the rule event type
	event_type EventType
	// the rule trigger type
	trigger_type TriggerType
	// the rule trigger metadata
	trigger_metadata TriggerMetadata
	// the actions which will execute when the rule is triggered
	actions []Action
	// whether the rule is enabled
	enabled bool
	// the role ids that should not be affected by the rule (Maximum of 20)
	exempt_roles []Snowflake
	// the channel ids that should not be affected by the rule (Maximum of 50)
	exempt_channels []Snowflake
}

pub fn AutoModerationRule.parse(j json2.Any) !AutoModerationRule {
	match j {
		map[string]json2.Any {
			return AutoModerationRule{
				id: Snowflake.parse(j['id']!)!
				guild_id: Snowflake.parse(j['guild_id']!)!
				name: j['name']! as string
				creator_id: Snowflake.parse(j['creator_id']!)!
				event_type: unsafe { EventType(j['event_type']!.int()) }
				trigger_type: unsafe { TriggerType(j['trigger_type']!.int()) }
				trigger_metadata: TriggerMetadata.parse(j['trigger_metadata']!)!
				actions: maybe_map(j['actions']! as []json2.Any, fn (k json2.Any) !Action {
					return Action.parse(k)!
				})!
				enabled: j['enabled']! as bool
				exempt_roles: maybe_map(j['exempt_roles']! as []json2.Any, fn (k json2.Any) !Snowflake {
					return Snowflake.parse(k)!
				})!
				exempt_channels: maybe_map(j['exempt_channels']! as []json2.Any, fn (k json2.Any) !Snowflake {
					return Snowflake.parse(k)!
				})!
			}
		}
		else {
			return error('expected auto moderation rule to be object, got ${j.type_name()}')
		}
	}
}

// Get a list of all rules currently configured for the guild. Returns a list of auto moderation rule objects for the given guild.
pub fn (c Client) list_auto_moderation_rules_for_guild(guild_id Snowflake) ![]AutoModerationRule {
	return maybe_map(json2.raw_decode(c.request(.get, '/guilds/${urllib.path_escape(guild_id.build())}/auto-moderation/rules')!.body)! as []json2.Any,
		fn (j json2.Any) !AutoModerationRule {
		return AutoModerationRule.parse(j)!
	})!
}

// Get a single rule. Returns an auto moderation rule object.
pub fn (c Client) fetch_auto_moderation_rule(guild_id Snowflake, auto_moderation_rule_id Snowflake) !AutoModerationRule {
	return AutoModerationRule.parse(json2.raw_decode(c.request(.get, '/guilds/${urllib.path_escape(guild_id.build())}/auto-moderation/rules/${urllib.path_escape(auto_moderation_rule_id.build())}')!.body)!)!
}

@[params]
pub struct CreateAutoModerationRuleParams {
pub:
	reason ?string
	// the rule name
	name string @[required]
	// the event type
	event_type EventType @[required]
	// the trigger type
	trigger_type TriggerType @[required]
	// the trigger metadata
	trigger_metadata ?TriggerMetadata
	// the actions which will execute when the rule is triggered
	actions []Action @[required]
	// whether the rule is enabled (False by default)
	enabled ?bool
	// the role ids that should not be affected by the rule (Maximum of 20)
	exempt_roles ?[]Snowflake
	// the channel ids that should not be affected by the rule (Maximum of 50)
	exempt_channels ?[]Snowflake
}

pub fn (params CreateAutoModerationRuleParams) build() json2.Any {
	mut r := {
		'name':         json2.Any(params.name)
		'event_type':   int(params.event_type)
		'trigger_type': int(params.trigger_type)
		'actions':      params.actions.map(|a| a.build())
	}
	if trigger_metadata := params.trigger_metadata {
		r['trigger_metadata'] = trigger_metadata.build()
	}
	if enabled := params.enabled {
		r['enabled'] = enabled
	}
	if exempt_roles := params.exempt_roles {
		r['exempt_roles'] = exempt_roles.map(|s| json2.Any(s.build()))
	}
	if exempt_channels := params.exempt_channels {
		r['exempt_channels'] = exempt_channels.map(|s| json2.Any(s.build()))
	}
	return r
}

// Create a new rule. Returns an auto moderation rule on success. Fires an Auto Moderation Rule Create Gateway event.
pub fn (c Client) create_auto_moderation_rule(guild_id Snowflake, params CreateAutoModerationRuleParams) !AutoModerationRule {
	return AutoModerationRule.parse(json2.raw_decode(c.request(.post, '/guilds/${urllib.path_escape(guild_id.build())}/auto-moderation/rules',
		json: params.build()
		reason: params.reason
	)!.body)!)!
}

@[params]
pub struct EditAutoModerationRuleParams {
pub:
	reason ?string
	// the rule name
	name ?string
	// the event type
	event_type ?EventType
	// the trigger type
	trigger_type ?TriggerType
	// the trigger metadata
	trigger_metadata ?TriggerMetadata
	// the actions which will execute when the rule is triggered
	actions ?[]Action
	// whether the rule is enabled (False by default)
	enabled ?bool
	// the role ids that should not be affected by the rule (Maximum of 20)
	exempt_roles ?[]Snowflake
	// the channel ids that should not be affected by the rule (Maximum of 50)
	exempt_channels ?[]Snowflake
}

pub fn (params EditAutoModerationRuleParams) build() json2.Any {
	mut r := map[string]json2.Any{}
	if name := params.name {
		r['name'] = name
	}
	if event_type := params.event_type {
		r['event_type'] = int(event_type)
	}
	if trigger_type := params.trigger_type {
		r['trigger_type'] = int(trigger_type)
	}
	if trigger_metadata := params.trigger_metadata {
		r['trigger_metadata'] = trigger_metadata.build()
	}
	if actions := params.actions {
		r['actions'] = actions.map(|a| a.build())
	}
	if enabled := params.enabled {
		r['enabled'] = enabled
	}
	if exempt_roles := params.exempt_roles {
		r['exempt_roles'] = exempt_roles.map(|s| json2.Any(s.build()))
	}
	if exempt_channels := params.exempt_channels {
		r['exempt_channels'] = exempt_channels.map(|s| json2.Any(s.build()))
	}
	return r
}

// Modify an existing rule. Returns an auto moderation rule on success. Fires an Auto Moderation Rule Update Gateway event.
pub fn (c Client) edit_auto_moderation_rule(guild_id Snowflake, auto_moderation_rule_id Snowflake, params EditAutoModerationRuleParams) !AutoModerationRule {
	return AutoModerationRule.parse(json2.raw_decode(c.request(.patch, '/guilds/${urllib.path_escape(guild_id.build())}/auto-moderation/rules/${urllib.path_escape(auto_moderation_rule_id.build())}',
		json: params.build()
		reason: params.reason
	)!.body)!)!
}

// Delete a rule. Returns a 204 on success. Fires an Auto Moderation Rule Delete Gateway event.
pub fn (c Client) delete_auto_moderation_rule(guild_id Snowflake, auto_moderation_rule_id Snowflake, params ReasonParam) ! {
	c.request(.delete, '/guilds/${urllib.path_escape(guild_id.build())}/auto-moderation/rules/${urllib.path_escape(auto_moderation_rule_id.build())}',
		reason: params.reason
	)!
}
