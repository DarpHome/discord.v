import os

println('Generating docs...')
if os.system('v doc -f html -o docs/ -color -readme discord/') != 0 {
	eprintln('HTML docs generation failed')
	exit(1)
} else {
	println('HTML docs successfully generated!')
}
