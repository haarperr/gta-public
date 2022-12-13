fx_version 'bodacious'
games {'gta5'}
name 'entre'

client_scripts {
    'lua/client.lua',
    'lua/itemLib.lua',
    'lua/vehicule.lua',
    'lua/weapons.lua',
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
    'lua/server.lua'
}

ui_page('dist/inventaire/index.html')

files({
    'wallet/id/*.html',
    'wallet/id/*.css',
    'wallet/*.png',
    'wallet/*.js',
    'dist/inventaire/index.html',
    'dist/inventaire/*.css',
    'dist/inventaire/*.css.map',
    'dist/inventaire/*.js',
    'dist/inventaire/*.js.map',
    'dist/inventaire/assets/*.bmp',
    'dist/inventaire/assets/*.png',
    'dist/inventaire/assets/*.jpg',
})