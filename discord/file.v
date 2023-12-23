module discord

import net.http
import x.json2

pub struct File {
pub:
	filename     string  @[required]
	content_type string = 'application/octet-stream'
	data         []u8    @[required]
	description  ?string
}

pub fn (f File) build(i int) json2.Any {
	mut r := {
		'id':       json2.Any(i)
		'filename': f.filename
	}
	if description := f.description {
		r['description'] = description
	}
	return r
}

pub fn build_multipart_with_files(files []File, j json2.Any) (string, string) {
	mut mp := {
		'payload_json': [
			http.FileData{
				content_type: 'application/json'
				data: j.json_str()
			},
		]
	}
	for i, file in files {
		mp['files[${i}]'] = [
			http.FileData{
				filename: file.filename
				content_type: file.content_type
				data: file.data.bytestr()
			},
		]
	}
	return multipart_form_body(mp)
}
