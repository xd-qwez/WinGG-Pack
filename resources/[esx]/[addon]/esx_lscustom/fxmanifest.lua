fx_version 'adamant'

game 'gta5'

description 'ESX LS Customs'
lua54 'yes'
version '1.9.0'

shared_script '@es_extended/imports.lua'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	"@win-classes/imports.lua",
	'locales/*.lua',
	'config.lua',
	'client/main.lua'
}