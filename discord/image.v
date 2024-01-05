module discord

import encoding.base64

pub interface Image {
	data []u8
	is_image()
	content_type() string
	build() string
}

pub struct JPEGImage {
pub:
	data []u8 @[required]
}

fn (_ JPEGImage) is_image() {}

pub fn (ji JPEGImage) content_type() string {
	return 'image/jpeg'
}

pub fn (ji JPEGImage) build() string {
	return 'data:${ji.content_type()};base64,${base64.encode(ji.data)}'
}

pub struct PNGImage {
pub:
	data []u8 @[required]
}

fn (_ PNGImage) is_image() {}

pub fn (_ PNGImage) content_type() string {
	return 'image/png'
}

pub fn (pi PNGImage) build() string {
	return 'data:${pi.content_type()};base64,${base64.encode(pi.data)}'
}

pub struct ApngImage {
pub:
	data []u8 @[required]
}

fn (_ ApngImage) is_image() {}

pub fn (_ ApngImage) content_type() string {
	return 'image/apng'
}

pub fn (ai ApngImage) build() string {
	return 'data:${ai.content_type()};base64,${base64.encode(ai.data)}'
}

pub struct GIFImage {
pub:
	data []u8 @[required]
}

fn (_ GIFImage) is_image() {}

pub fn (_ GIFImage) content_type() string {
	return 'image/gif'
}

pub fn (gi GIFImage) build() string {
	return 'data:${gi.content_type()};base64,${base64.encode(gi.data)}'
}

pub struct NoneImage {
	data []u8 = []
}

fn (_ NoneImage) is_image() {}

pub fn (_ NoneImage) content_type() string {
	return ''
}

pub fn (_ NoneImage) build() string {
	return ''
}
