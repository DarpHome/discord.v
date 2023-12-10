module discord

import time
import x.json2

pub const snowflake_epoch = u64(1420070400000)

pub type Snowflake = u64

pub fn (s Snowflake) raw_timestamp() u64 {
	return (s >> 22) + discord.snowflake_epoch
}

pub fn (s Snowflake) timestamp() time.Time {
	ts := s.raw_timestamp()
	return time.unix_microsecond(ts / 1000, int(ts % 1000) * 1000).as_utc()
}

pub fn Snowflake.from(t time.Time) Snowflake {
	return u64(t.unix_time_milli() - discord.snowflake_epoch) << 22
}

pub fn Snowflake.now() Snowflake {
	return Snowflake.from(time.now())
}

pub fn (s Snowflake) build() string {
	return s.str()
}

pub fn Snowflake.parse(j json2.Any) !Snowflake {
	match j {
		string { return j.u64() }
		else { return error('expected snowflake to be string, got ${j.type_name()}') }
	}
}
