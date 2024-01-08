module discord

import toml
import time
import x.json2

pub const snowflake_epoch = u64(1420070400000)

pub type Snowflake = u64

pub fn (s Snowflake) raw_timestamp() u64 {
	return (s >> 22) + discord.snowflake_epoch
}

pub fn (s Snowflake) timestamp() time.Time {
	return milliseconds_as_time(s.raw_timestamp()).as_utc()
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
		i8, i16, int, i64, u8, u16, u32, u64 { return Snowflake(u64(j)) }
		else { return error('expected snowflake to be string, got ${j.type_name()}') }
	}
}

pub fn (mut s Snowflake) from_json(f json2.Any) {
	s = Snowflake.parse(s) or { return }
}

pub fn (mut s Snowflake) from_toml(t toml.Any) {
	s = match t {
		string { Snowflake(t.u64()) }
		i8, i16, int, i64, u8, u16, u32, u64 { Snowflake(u64(t)) }
		else { return }
	}
}

pub fn (s Snowflake) str() string {
	return u64(s).str()
}

pub fn (s Snowflake) json_str() string {
	return json2.Any(s.str()).json_str()
}
