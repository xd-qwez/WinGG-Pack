fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts {
	'@es_extended/imports.lua',
	'shared/config.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/server.lua',
}

-- client_script 'client/client.lua'

files {
    'web/**.*',
	'web/index.html',
}

ui_page 'web/index.html'

client_scripts {'client/client.lua'}