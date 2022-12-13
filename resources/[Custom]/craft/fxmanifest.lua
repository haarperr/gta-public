fx_version 'bodacious'
games {'gta5'}
name 'entre'

client_scripts {
    'lua/client.lua'
}



server_scripts {
	"@mysql-async/lib/MySQL.lua",
    'lua/server.lua'
}

ui_page('dist/craft/index.html')

files({
    'dist/craft/index.html',
    'dist/craft/*.css',
    'dist/craft/*.css.map',
    'dist/craft/*.js',
    'dist/craft/*.js.map',
    'dist/craft/assets/*.bmp',
    'dist/craft/assets/*.gif',
    'dist/craft/assets/*.png',
    'dist/craft/assets/*.jpg',
})
