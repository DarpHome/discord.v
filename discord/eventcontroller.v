module discord

import time

pub type EventListener[T] = fn (T) !

struct Chan[T] {
	c chan T
}

pub type Check[T] = fn (T) bool

struct EventWaiter[T] {
	check ?Check[T]
	c     &Chan[T]
}

pub struct EventController[T] {
mut:
	id        int
	wait_fors map[int]EventWaiter[T]
	listeners map[int]EventListener[T]
}

fn (mut ec EventController[T]) generate_id() int {
	return ec.id++
}

@[params]
pub struct EmitOptions {
pub:
	error_handler ?fn (int, IError)
}

pub fn (mut ec EventController[T]) emit(e T, options EmitOptions) {
	for i, w in ec.wait_fors {
		mut b := false
		if w.check != none {
			b = (w.check or { panic(err) })
			e
		} else {
			b = true
		}
		if b {
			w.c.c <- e
			ec.wait_fors.delete(i)
			return
		}
	}
	mut ts := []thread{}
	for i, l in ec.listeners {
		ts << spawn fn [options] [T](f EventListener[T], j int, e T) {
			f(e) or {
				if g := options.error_handler {
					g(j, err)
				}
			}
		}(l, i, e)
	}
	ts.wait()
}

@[params]
pub struct EventWaitParams[T] {
pub:
	check   ?Check[T]
	timeout ?time.Duration
}

pub fn (mut ec EventController[T]) wait[T](params EventWaitParams[T]) ?T {
	mut c := Chan[T]{}
	id := ec.generate_id()
	ec.wait_fors[id] = EventWaiter[T]{
		check: params.check
		c: &mut c
	}
	defer {
		ec.wait_fors.delete(id)
	}
	if timeout := params.timeout {
		select {
			e := <-c.c {
				return e
			}
			timeout.nanoseconds() {
				return none
			}
		}
	}
	return <-c.c
}

pub fn (mut ec EventController[T]) override[T](listener EventListener[T]) EventController[T] {
	ec.listeners = {
		ec.generate_id(): listener
	}
	return ec
}

pub fn (mut ec EventController[T]) listen[T](listener EventListener[T]) EventController[T] {
	ec.listeners[ec.generate_id()] = listener
	return ec
}
