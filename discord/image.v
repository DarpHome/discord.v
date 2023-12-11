module discord

import encoding.base64

pub interface Image {
	data []u8
	is_image()
	build() string
}

pub struct JpegImage {
pub:
	data []u8 @[required]
}

fn (_ JpegImage) is_image() {}

pub fn (ji JpegImage) build() string {
	return 'data:image/jpeg;base64,${base64.encode(ji.data)}'
}

pub struct PngImage {
pub:
	data []u8 @[required]
}

fn (_ PngImage) is_image() {}

pub fn (pi PngImage) build() string {
	return 'data:image/png;base64,${base64.encode(pi.data)}'
}

pub struct GifImage {
pub:
	data []u8 @[required]
}

fn (_ GifImage) is_image() {}

pub fn (gi GifImage) build() string {
	return 'data:image/gif;base64,${base64.encode(gi.data)}'
}

pub struct NoneImage {
	data []u8 = []
}

fn (_ NoneImage) is_image() {}

pub fn (_ NoneImage) build() string {
	return ''
}