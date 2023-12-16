module discord

const test_user_id = Snowflake(1073325901825187841)
const test_user_avatar = 'bb7207ea7f32c4e2fc80841aff8a41ac'

fn test_cdn() {
	assert cdn.user_avatar(test_user_id, test_user_avatar) == 'https://cdn.discordapp.com/avatars/${test_user_id}/${test_user_avatar}.png'
	assert cdn.user_avatar(test_user_id, test_user_avatar, format: .jpg) == 'https://cdn.discordapp.com/avatars/${test_user_id}/${test_user_avatar}.jpg'
	assert cdn.user_avatar(test_user_id, test_user_avatar, size: 1024) == 'https://cdn.discordapp.com/avatars/${test_user_id}/${test_user_avatar}.png?size=1024'
	assert cdn.user_avatar(test_user_id, test_user_avatar, format: .jpg, size: 1024) == 'https://cdn.discordapp.com/avatars/${test_user_id}/${test_user_avatar}.jpg?size=1024'
}