import os

println('Generating docs...')
if os.system('v doc -f markdown -o docs/ -color discord/') != 0 {
	eprintln('Docs generation failed')
	exit(1)
} else {
	println('Docs successfully generated!')
}
