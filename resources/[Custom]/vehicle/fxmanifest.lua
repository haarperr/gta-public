
-- Manifest data
fx_version 'bodacious'
games {'gta5'}


-- Files & scripts
client_scripts {
    'client/keys.lua',
    'client/client.lua'
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
    'server/server.lua'
}


client_export 'getVehicleMods'
