
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

server_export 'getSteamId'
server_export 'ExtractIdentifiers'
client_export 'notify'
client_export 'getCharacterIdFromServerId'
client_export 'teleportTo'