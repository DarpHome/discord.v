module discord

// TODO: use Alex M (592103446384214044/56370a07e4cbf565d5044c2530879967.png)
const test_user_id = Snowflake(1073325901825187841)
const test_user_avatar = 'bb7207ea7f32c4e2fc80841aff8a41ac'

fn test_cdn() {
	assert cdn.user_avatar(discord.test_user_id, discord.test_user_avatar) == 'https://cdn.discordapp.com/avatars/${discord.test_user_id}/${discord.test_user_avatar}.png'
	assert cdn.user_avatar(discord.test_user_id, discord.test_user_avatar, format: .jpg) == 'https://cdn.discordapp.com/avatars/${discord.test_user_id}/${discord.test_user_avatar}.jpg'
	assert cdn.user_avatar(discord.test_user_id, discord.test_user_avatar, size: 1024) == 'https://cdn.discordapp.com/avatars/${discord.test_user_id}/${discord.test_user_avatar}.png?size=1024'
	assert cdn.user_avatar(discord.test_user_id, discord.test_user_avatar, format: .jpg, size: 1024) == 'https://cdn.discordapp.com/avatars/${discord.test_user_id}/${discord.test_user_avatar}.jpg?size=1024'
}
