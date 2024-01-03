module discord

import crypto.ed25519
import encoding.base64
import encoding.hex
import net.http
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
	id := base64.url_decode_str(encoded)
	if id == '' {
		return error('invalid base64')
	}
	return Snowflake(strconv.parse_uint(id, 10, 64) or { return error('not a id: ${err}') })
}

pub fn maybe_map[T, X](a []T, f fn (T) !X) ![]X {
	mut r := []X{cap: a.len}
	for v in a {
		r << f(v)!
	}
	return r
}

pub fn maybe_map_map[T, U, X, Y](m map[T]U, f fn (T, U) !(X, Y)) !map[X]Y {
	mut r := map[X]Y{}
	for k, v in m {
		nk, nv := f(k, v)!
		r[nk] = nv
	}
	return r
}

pub fn verify_request(public_key ed25519.PublicKey, req http.Request) bool {
	// fn verify(publickey PublicKey, message []u8, sig []u8) !bool
	signature := req.header.get_custom('X-Signature-Ed25519') or { return false }
	timestamp := req.header.get_custom('X-Signature-Timestamp') or { return false }
	return ed25519.verify(public_key, '${timestamp}${req.data}'.bytes(), hex.decode(signature) or {
		return false
	}) or { return false }
}

pub fn milliseconds_as_time(ts i64) time.Time {
	return time.unix_microsecond(ts / 1000, int(ts % 1000) * 1000)
}