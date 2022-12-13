fx_version 'bodacious'
games {'gta5'}
name 'entre'

client_scripts {
    'lua/client.lua'
}

client_export 'CreateMenu'
client_export 'CreateSubmenu'
client_export 'openMenu'
client_export 'closeMenu'
client_export 'isMenuOpen'


server_scripts {
	"@mysql-async/lib/MySQL.lua",
    'lua/server.lua'
}

ui_page('dist/menu/index.html')

files({
    'dist/menu/index.html',
    'dist/menu/*.css',
    'dist/menu/*.css.map',
    'dist/menu/*.js',
    'dist/menu/*.js.map',
    'dist/menu/*.otf',
    'dist/menu/assets/*.bmp',
    'dist/menu/assets/*.png',
    'dist/menu/assets/*.jpg',
    'dist/menu/assets/*.otf',
    'dist/menu/assets/*.css',
})