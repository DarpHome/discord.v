module discord

import math
import time

// ASCII-encoded 'darp'
pub const sentinel_int = 1886544228
pub const sentinel_time = time.Time{
	unix: 0
}

// Compare using `target.str == sentinel_string.str`
pub const sentinel_string = 'darp'

// compare using math.is_nan(target)
pub const sentinel_number = math.nan()

pub const sentinel_snowflake = Snowflake(0)
pub const sentinel_permissions = unsafe { Permissions(math.max_u64) }

// is_sentinel reports whether `target` is sentinel
pub fn is_sentinel[T](target T) bool {
	$if T is Snowflake {
		return target == discord.sentinel_snowflake
	} $else $if T is Permissions {
		return target == discord.sentinel_permissions
	} $else $if T is int {
		return target == discord.sentinel_int
	} $else $if T is time.Time {
		return target == discord.sentinel_time
	} $else $if T is string {
		return target.str == discord.sentinel_string.str
	} $else $if T is f32 || T is f64 {
		return math.is_nan(f64(target))
	} $else {
		$compile_error('Unknown type')
	}
}
