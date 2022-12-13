
-- Manifest data
fx_version 'bodacious'
games {'gta5'}


-- Files & scripts
client_scripts {
	"@mysql-async/lib/MySQL.lua",
    'client.lua'    
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
    'server.lua'
}