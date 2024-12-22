fx_version 'adamant'

game 'gta5'

description 'fizzfau-base'

version '1.1.0'

server_scripts {
	"server/main.lua",
	'config.lua'	
}

client_scripts {
	'client/main.lua',
	'config.lua'
}

ui_page {
    'html/index.html',
}
files {
    'html/index.html',
    'html/index.js',
    'html/style.css',
    'html/map.jpg',
}