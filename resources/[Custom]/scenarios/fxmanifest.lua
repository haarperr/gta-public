
-- Manifest data
fx_version 'bodacious'
games {'gta5'}


-- Files & scripts
client_scripts {
    'vol_voiture_1/client.lua',
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
    'vol_voiture_1/server.lua',
}
