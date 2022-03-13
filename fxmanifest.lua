fx_version 'cerulean'
game 'gta5'

client_scripts {
    "main-c.lua"
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "main-s.lua"
}

shared_scripts {
    "config.lua"
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
    'html/style.css',
    'html/listener.js'
}

dependencies {
    'mysql-async',
	'es_extended'
}

name 'hop_licenseplates'
description 'ESX custom license plates'
author 'H0PPP - https://github.com/H0ppp'