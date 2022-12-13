fx_version 'bodacious'
games {'gta5'}
name 'bank'

client_scripts {
    'lua/client.lua'
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
    'lua/server.lua'
}

ui_page('dist/bank/index.html')

files({
    'dist/bank/index.html',
    'dist/bank/*.css',
    'dist/bank/*.css.map',
    'dist/bank/*.js',
    'dist/bank/*.js.map',
    'dist/bank/assets/*.bmp',
    'dist/bank/assets/*.png',
    'dist/bank/assets/*.jpg',
})