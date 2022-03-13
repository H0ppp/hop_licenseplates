fx_version 'cerulean'
game 'gta5'

client_scripts {
    "main-c.lua",
    "config.lua"
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "main-s.lua"
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
    'html/style.css',
    'html/listener.js'
}

dependencies {
	'es_extended'
}

name 'hop_licenseplates'
description 'ESX custom license plates'
author 'H0PPP - https://github.com/H0ppp'