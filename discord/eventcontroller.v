module discord

import time

pub type EventListener[T] = fn (T)

struct Chan[T] {
	c chan T
}


struct EventWaiter[T] {
	check ?fn (T) bool
	c &Chan[T]
}

pub struct EventController[T] {
mut:
	id int
	wait_fors map[int]Chan[T]
	listeners map[int]EventListener[T]
}


@[params]
pub struct EventWaitParams[T] {
	check ?fn (T) bool
	timeout ?time.Duration
}

pub fn (ec EventController[T]) wait[T](params EventWaitParams[T]) ?T {
	c := Chan[T]{}
	if timeout := params.timeout {
		select {
			e := <-c.c {
				return e
			}
			timeout {
				return none
			}
		}
	}
	return <-c.c

}