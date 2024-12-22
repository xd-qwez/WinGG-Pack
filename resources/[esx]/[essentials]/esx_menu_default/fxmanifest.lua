fx_version 'adamant'

game 'gta5'

client_scripts {
	'@es_extended/imports.lua',
	'client.lua'
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/css/app.css',
	'html/js/mustache.min.js',
	'html/js/app.js',
	'html/img/cursor.png',
	'html/img/keys/enter.png',
	'html/img/keys/return.png',
}

dependency 'es_extended'