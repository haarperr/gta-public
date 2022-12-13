fx_version 'bodacious'
games {'gta5'}
name 'phone'

client_scripts {
    'lua/client.lua'
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
    'lua/server.lua'
}

ui_page('dist/phone/index.html')

files({
    'dist/phone/index.html',
    'dist/phone/*.css',
    'dist/phone/*.css.map',
    'dist/phone/*.js',
    'dist/phone/*.js.map',
    'dist/phone/assets/*.bmp',
    'dist/phone/assets/*.png',
    'dist/phone/assets/*.jpg',
    'dist/phone/assets/*.gif',
    'dist/phone/assets/*.mp3',
})