import time

pub type EventListener[T] = fn (T) !

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
}

@[params]
pub struct EventWaitParams[T] {
pub:
	check ?fn (T) bool
	timeout ?time.Duration
}

pub fn (mut ec EventController[T]) wait[T](params EventWaitParams[T]) ?T {
	return none
}

pub fn (mut ec EventController[T]) override[T](listener EventListener[T]) EventController[T] {
	return ec
}

pub fn (mut ec EventController[T]) listen[T](listener EventListener[T]) EventController[T] {
	return ec
}

fn main() {
	ec := EventController[int]{}
}