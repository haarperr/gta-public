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

ui_page('dist/entreprise/index.html')

files({
    'dist/entreprise/index.html',
    'dist/entreprise/*.css',
    'dist/entreprise/*.css.map',
    'dist/entreprise/*.js',
    'dist/entreprise/*.js.map',
    'dist/entreprise/assets/*.bmp',
    'dist/entreprise/assets/*.gif',
    'dist/entreprise/assets/*.png',
    'dist/entreprise/assets/*.jpg',
})
