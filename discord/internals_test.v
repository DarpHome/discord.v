module discord

import net.urllib

fn test_encode_values() {
	assert encode_values(urllib.new_values()) == ''
	mut v1 := urllib.new_values()
	v1.add('foo', 'bar')
	assert encode_values(v1) == 'foo=bar'
	mut v2 := urllib.new_values()
	v2.add('foo', '')
	assert encode_values(v2) == 'foo'
	mut v3 := urllib.new_values()
	v3.add('foo', 'raw:123,456,789')
	assert encode_values(v3) == 'foo=123,456,789'

}