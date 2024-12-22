fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts {
	'@es_extended/imports.lua'
}

ui_page 'web/index.html'

files {
	'web/*.*',
	'web/images/*.*',
	'weapons/*.meta',
}

client_scripts {
	'@win-classes/imports.lua',
	'config.lua',
	'client.lua',
	'scripts/**/client.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server.lua',
	'scripts/**/server.lua',
}

data_file 'WEAPONINFO_FILE_PATCH' 'weapons/*.meta'