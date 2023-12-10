module discord

import net.urllib
import strings

fn encode_values(vs urllib.Values) string {
	if vs.len == 0 || vs.data.len == 0 {
		return ''
	}
	mut b := strings.new_builder(200)
	for qv in vs.data {
		if b.len != 0 {
			b.write_byte(`&`)
		}
		b.write_string(urllib.query_escape(qv.key))
		if qv.value != '' {
			b.write_byte(`=`)
			if qv.value.starts_with('raw:') {
				b.write_string(qv.value[4..])
			} else {
				b.write_string(urllib.query_escape(qv.value))
			}
		}
	}
	return b.str()
}