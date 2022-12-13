
-- Manifest data
fx_version 'bodacious'
games {'gta5'}


-- Files & scripts
client_scripts {
    'lua/client.lua'    
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
    'lua/server.lua'
}

ui_page('dist/notify/index.html')

files({
    'dist/notify/index.html',
    'dist/notify/*.css',
    'dist/notify/*.css.map',
    'dist/notify/*.js',
    'dist/notify/*.js.map',
    'dist/notify/assets/*.bmp',
    'dist/notify/assets/*.png',
    'dist/notify/assets/*.jpg',
    'dist/notify/assets/*.mp3',
})