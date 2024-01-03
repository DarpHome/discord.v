module discord

pub struct CacheOf {
pub mut:
	emojis   Cache[Emoji]
	users    Cache[User]
	members  Cache[GuildMember]
	messages Cache[Message]
	guilds   Cache[Guild]
}
