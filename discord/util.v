module discord

import time

// 2015-04-26T06:26:56.936000+00:00
pub fn format_iso8601(t time.Time) string {
	u := t.local_to_utc()
	return '${u.year:04d}-${u.month:02d}-${u.day:02d}T${u.hour:02d}:${u.minute:02d}:${u.second:02d}.${(u.nanosecond / 1_000_000):03d}+00:00'
}
