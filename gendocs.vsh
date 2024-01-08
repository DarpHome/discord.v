import os

println('Generating docs...')
if os.system('v doc -color -f html -o docs/ -readme src/') != 0 {
	eprintln('HTML docs generation failed')
	exit(1)
} else {
	println('HTML docs successfully generated!')
}
