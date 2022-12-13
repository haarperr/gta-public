
-- Manifest data
fx_version 'bodacious'
games {'gta5'}


-- Files & scripts
client_scripts {
    'client.lua'    
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
    'server.lua'
}