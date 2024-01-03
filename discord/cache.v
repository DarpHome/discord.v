module discord

pub struct Cache[T] {
pub:
	check    fn (id Snowflake, o T) bool = unsafe { nil }
	max_size ?int
pub mut:
	cache map[Snowflake]T
}

pub fn (mut c Cache[T]) add(id Snowflake, o T) {
	f := c.check
	if !isnil(f) {
		if !f(id, o) {
			return
		}
	}
	if id !in c.cache {
		if sz := c.max_size {
			if c.cache.len >= sz {
				for k, _ in c.cache {
					c.cache.delete(k)
					break
				}
			}
		}
	}
	c.cache[id] = o
}

pub fn (c Cache[T]) get(id Snowflake) ?T {
	return c.cache[id]
}
