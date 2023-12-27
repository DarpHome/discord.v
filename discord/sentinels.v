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
pub const sentinel_snowflakes = []Snowflake{}
pub const sentinel_permissions = unsafe { Permissions(max_u64) }
pub const sentinel_image = Image(NoneImage{})
pub const sentinel_duration = time.infinite
pub const sentinel_bool = unsafe { bool(126) }

pub struct Undefined {}

pub type UndefinedOr[T] = T | Undefined

// we are not going to support JavaScript
pub fn undefined[T]() UndefinedOr[T] {
	return Undefined{}
}

pub fn (u UndefinedOr[T]) is_present[T]() bool {
	return u !is Undefined
}

pub fn (u UndefinedOr[T]) is_undefined[T]() bool {
	return u is Undefined
}

pub fn (u UndefinedOr[T]) value[T]() T {
	match u {
		T {
			return u
		}
		else {
			panic('UndefinedOr[${typeof[T]()}].value() called on none')
		}
	}
}

// is_sentinel reports whether `target` is sentinel
pub fn is_sentinel[T](target T) bool {
	$if T is Snowflake {
		return target == discord.sentinel_snowflake
	} $else $if T is []Snowflake {
		return target.data == sentinel_snowflakes.data
	} $else $if T is Permissions {
		return target == discord.sentinel_permissions
	} $else $if T is Image {
		return target == discord.sentinel_image
	} $else $if T is JpegImage || T is PngImage || T is GifImage {
		return false
	} $else $if T is NoneImage {
		return true
	} $else $if T is int {
		return target == discord.sentinel_int
	} $else $if T is time.Time {
		return target == discord.sentinel_time
	} $else $if T is string {
		return target.str == discord.sentinel_string.str
	} $else $if T is f32 || T is f64 {
		return math.is_nan(f64(target))
	} $else $if T is Undefined {
		return true
	} $else $if T is UndefinedOr {
		return target == Undefined{}
	} $else $if T is time.Duration {
		return target == discord.sentinel_duration
	} $else $if T is bool {
		return target == discord.sentinel_bool
	} $else {
		$compile_error('Unknown type')
	}
}
