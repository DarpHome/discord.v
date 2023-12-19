module discord

import x.json2

fn test_channel_edit() {
	assert (EditGuildChannelParams{}.build() as map[string]json2.Any) == map[string]json2.Any{}
}