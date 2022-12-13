
-- Manifest data
fx_version 'bodacious'
games {'gta5'}


-- Files & scripts
client_scripts {
    'client/crimiCrate.lua',
    'client/supperette.lua',
    'client/character.lua',
    'client/drogue.lua',
    'client/volvoiture.lua',
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
    'server/crimiCrate.lua',
    'server/supperette.lua',
    'server/drogue.lua',
    'server/volvoiture.lua',
}
