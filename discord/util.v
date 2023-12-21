module discord

import encoding.base64
import strconv
import time

// 2015-04-26T06:26:56.936000+00:00
pub fn format_iso8601(t time.Time) string {
	u := t.local_to_utc()
	return '${u.year:04d}-${u.month:02d}-${u.day:02d}T${u.hour:02d}:${u.minute:02d}:${u.second:02d}.${(u.nanosecond / 1_000_000):03d}+00:00'
}

pub fn extract_id_from_token(token string) !Snowflake {
	mut token_ := token.trim(' \a\b\t\n\v\f\r ')
	if token_ == '' {
		return error('empty token')
	}
	if token_.starts_with('Bot ') {
		token_ = token_[4..]
	}
	encoded := token_.before('.')
	if encoded == '' {
		return error('not a token')
	}
	id := base64.decode_str(encoded)
	if id == '' {
		return error('invalid base64')
	}
	return Snowflake(strconv.parse_uint(id, 10, 64) or {
		return error('not a id: ${err}')
	})
}
