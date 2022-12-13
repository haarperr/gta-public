local PlayerTable = {
    name = 'Joueurs connectés',
    description = 'Liste des joueurs connectés au serveur',
    length = 0,
    players = {}
}
 

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' is starting on the client.')
    MySQL.Async.execute("UPDATE users SET serverId = NULL WHERE serverId IS NOT NULL", { 
    }, function(alteredRow)
        if not alteredRow then
            print("ERROR : Mise à jour des users impossibles")
        end
    end)
    MySQL.Async.execute("UPDATE characters SET serverId = NULL WHERE serverId IS NOT NULL", { 
    }, function(alteredRow)
        if not alteredRow then
            print("ERROR : Mise à jour des characters impossibles")
        end
    end)
    print('The resource ' .. resourceName .. ' has been started on the client.')
end)



function printlib(message, type)
    local typeText
    if type == 1 then
        typeText = "[^4INFO^7]"
    elseif type == 2 then
        typeText = "[^3WARNING^7]"
    elseif type == 3 then
        typeText = "[ERROR]"
    end
    print("[^4CORE^7]"..typeText.." "..message)
end
 
-- @func tableLength
-- @description Retourne la longueur d'une table.
-- @param T Table à calculer
function tableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end
 
-- @func getPlayer
-- @description Retourne un joueur à partir du steamID.
-- @param discordId Identifiant steam
function getPlayer(discordId)
    for i,p in pairs(PlayerTable.players) do
        if p.discordId == discordId then
            return p
        end
    end
    printlib("Aucun joueur n'a été trouvé avec "..discordId, 2)
end
 
-- @func getCharacter
-- @description Retourne le personnage d'un joueur à partir du steamID.
-- @param discordId Identifiant steam
function getCharacter(discordId)
    local res
    if discordId then
        for i,p in pairs(PlayerTable.players) do
            if p.discordId == discordId then
                res = p.character 
            end
        end
    end
    if res == nil then 
        local r1 = MySQL.Sync.fetchAll("SELECT * FROM users WHERE discordId = @discordId", {['discordId'] = discordId})
        if r1[1] then 
            res = MySQL.Sync.fetchAll("SELECT * FROM characters WHERE id = @cId", {['cId'] = r1[1].currentCharacter})
        end    
    end
    return res
end

-- @func printPlayer
-- @description Affiche dans la console un joueur.
-- @param p Joueur à afficher
function printPlayer(p)
    if p then
        -- printlib("Joueur : ID = "..p.id..", ServerID = "..p.serverId..", SteamID = "..p.steamId..", SteamName = '"..p.steamName.."', Personnage actif : '"..p.character.prenom.." "..p.character.nom.."'", 1)
        printlib("Joueur : ID = "..p.id..", ServerID = "..p.serverId..", SteamID = "..p.steamId..", Personnage actif : '"..p.character.firstName.." "..p.character.lastName.."'", 1)
    end
end
 
-- @func printPlayers
-- @description Affiche dans la console tous les joueurs.
function printPlayers()
    printlib('- AFFICHAGE DE LA TABLE DES JOUEURS CONNECTÉS -', 1)
    printlib('Nombre de joueurs connectés : '..PlayerTable.length, 1)
    for i,p in pairs(PlayerTable.players) do
        printPlayer(p)
    end
end
 
-- @func addPlayer
-- @description Supprime un joueur dans la liste des joueurs.
function addPlayer(player)
    for i,p in pairs(PlayerTable.players) do 
        if p.steamId == player.steamId then
            return printlib("Impossible d'ajouter le joueur "..player.steamId.." car il existe déjà.", 3)
        end
    end
    table.insert(PlayerTable.players, player)
    PlayerTable.length = PlayerTable.length + 1
    printlib("Ajout de "..player.steamId.." aux joueurs actifs.", 1)
end
 
-- @func removePlayer
-- @description Supprime un joueur dans la liste des joueurs.
function removePlayer(serverId)
    for i,p in pairs(PlayerTable.players) do
        if p.serverId == serverId then
            table.remove(PlayerTable.players, i)
            PlayerTable.length = PlayerTable.length - 1
            return printlib("Suppression de "..p.steamId.." des joueurs actifs.", 1)
        end
    end
    printlib("Aucun joueur n'a été trouvé avec serverId = "..serverId, 2)
end
 


-- @func printCharacter
-- @description Affiche dans la console un personnage.
-- @param c Personnage à afficher
function printCharacter(c)
    if c then
        -- printlib("Personnage : Prénom = '"..c.prenom.."', Nom = '"..c.nom.."', x = "..c.x..", y = "..c.y..", z = "..c.z..", Cash = "..c.cash.."$, Bank = "..c.bank.."$", 1)
        printlib("Personnage : Nom = '"..c.fristname.." "..c.lastName.."', x = "..c.x..", y = "..c.y..", z = "..c.z..", Cash = "..c.cash.."$", 1)
    end
end

function getLocalIds(_src)
    local identifiers = {}
    
    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(_src) - 1 do
        local id = GetPlayerIdentifier(_src, i)

        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id:gsub("steam:", "")
        elseif string.find(id, "ip") then
            identifiers.ip = id:gsub("ip:", "")
        elseif string.find(id, "discord") then
            identifiers.discord = id:gsub("discord:", "")
        end
    end
    return identifiers
end
 
exports("ExtractIdentifiers", ExtractIdentifiers)
function ExtractIdentifiers(_src, type)
    local identifiers = {}
    identifiers = getLocalIds(_src)

    if (type=='local') then
        return identifiers
    elseif (type=='character') then 
        return getCharacter(identifiers.discord)
    elseif (type=='player') then 
        return getPlayer(identifiers.discord)
    elseif (type=='all') then
        identifiers.character = getCharacter(identifiers.discord)
        identifiers.player = getPlayer(identifiers.discord)
        return identifiers
    end
    return identifiers
end



exports("getSteamId", getSteamId)
function getSteamId(_src)
    local identifiers = {
        steam = "",
        ip = ""
    }
    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(_src) - 1 do
        local id = GetPlayerIdentifier(_src, i)
        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id:gsub("steam:", "")
        end
    end
    local steamId = identifiers.steam:gsub("steam:", "")
    return steamId
end

-- ["x"] = -802.311, ["y"] = 175.056, ["z"] = 72.8446, ["h"] = 0}
RegisterNetEvent("onJoin")
AddEventHandler("onJoin", function()
    local _src = source
    local username = GetPlayerName(_src)
    print("^2[JOIN] ^7Le joueur '^4"..username.."^7' vient de se connecter! ^7")
    local userIds = ExtractIdentifiers(_src)
    local discordId = userIds.discord:gsub("discord:", "")
    local steamId = userIds.steam:gsub("steam:", "")
    local userIp = userIds.ip:gsub("ip:", "")
    print(discordId)
    MySQL.Async.fetchAll("SELECT * FROM users WHERE discordId = @discordId", {['discordId'] = discordId}, function(res)
        if res[1] then 
            local player = res[1]
            MySQL.Async.execute("UPDATE users SET serverId = @serverId, steamName = @steamName, steamId = @steamId, ip = @ip, lastJoin = @date WHERE id = @id", { ["serverId"] = _src , ["steamName"] = username, ["steamId"] = steamId, ["ip"] = userIp, ['date'] = os.date('%Y-%m-%d %H:%M:%S'), ["id"] = res[1].id}, function()
                print("^3[SQL] UPDATE ^7user '^4"..username.."^7' in database.")
            end)
            MySQL.Async.execute("UPDATE characters SET serverId = @serverId WHERE id = @id", { ["serverId"] = _src, ["id"] = player.currentCharacter}, function()
                print("^3[SQL] UPDATE ^7user '^4"..username.."^7' in database.")
            end)
            MySQL.Async.fetchAll("SELECT * FROM characters WHERE id = @cId", {['cId'] = player.currentCharacter}, function(res2)
                if res2[1] then 
                    player.serverId = _src
                    player.character = res2[1]
                    addPlayer(player)
                    printPlayers()
                    local coords = {x = player.character.x, y = player.character.y, z = player.character.z, h = player.character.h}
                    local model = player.character.model
                    TriggerClientEvent("spawnPlayerEvent", _src , coords, model, player.character.hp, player.character.mp_ped)
                    TriggerClientEvent("getCharacterCallback", _src, player.character)
                else
                    print('PROBLEM')
                end
            end)
        else
            print('PROBLEM')
        end
    end)
end)


RegisterServerEvent("savePosition")
AddEventHandler("savePosition", function(LastPosX, LastPosY, LastPosZ, LastPosH)
    local _src = source 
    local username = GetPlayerName(_src)
    local userIds = ExtractIdentifiers(_src)
    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE steamId = @steamId", {['steamId'] = userIds.steam})
    if result[1] then
        MySQL.Async.execute("UPDATE characters SET x = @x, y = @y, z = @z, h = @h WHERE id = @id", { ["x"] = LastPosX, ["y"] = LastPosY, ["z"] = LastPosZ, ["h"] = LastPosH, ["id"] = result[1].currentCharacter}, function(alteredRow)
            if alteredRow then
                TriggerClientEvent("notify", _src, "Position sauvegardée")
            else
                TriggerClientEvent("notify", _src, "Une erreur s'est produite lors de la sauvegarde de la position.")
            end
        end)
    else
        print("error : no character found")
    end
end)




RegisterNetEvent("getCharacter")
AddEventHandler("getCharacter", function()
    local _src = source
    local c = exports.lib:ExtractIdentifiers(_src, 'character')
    TriggerClientEvent("getCharacterCallback", _src, c)
end)



RegisterNetEvent("getCharacterIdFromServerIdWithCallback")
AddEventHandler("getCharacterIdFromServerIdWithCallback", function(serverId, callback)
    local _src = source
    local res = 0
    for i,p in pairs(PlayerTable.players) do
        if p.serverId == serverId then
            res = p.character.id
        end
    end
    TriggerClientEvent(callback, _src, res)
end)

RegisterNetEvent("refreshCharacterEvent")
AddEventHandler("refreshCharacterEvent", function(_src, c)
    local steamId = getSteamId(_src)
    for i,v in pairs(PlayerTable.players) do 
        if v.character.id == c.id then 
            PlayerTable.players[i].character = c 
            TriggerClientEvent("getCharacterCallback", _src, c)
            break
        end
    end
end)

RegisterNetEvent("changeCharacterEvent")
AddEventHandler("changeCharacterEvent", function(cid)
    local _src = source
    local id = exports.lib:ExtractIdentifiers(_src, 'player').id
    MySQL.Async.fetchAll("SELECT * FROM characters WHERE id = @id", {['id'] = cid}, function(res)
        if res[1] then 
            MySQL.Async.execute("UPDATE characters SET serverId = NULL WHERE id = @id", { 
                ["id"] = cid, 
            }, function(alteredRow)
                if not alteredRow then 
                    print("ERROR At set serverId null")
                end
            end)
            MySQL.Async.execute("UPDATE users SET currentCharacter = @cid WHERE id = @id", { 
                ["id"] = id, 
                ["cid"] = cid, 
            }, function(alteredRow)
                if alteredRow then 
                    for i,v in pairs(PlayerTable.players) do 
                        if v.id == id then 
                            PlayerTable.players[i].currentCharacter = res[1].id
                            PlayerTable.players[i].character = res[1] 
                            TriggerClientEvent("getCharacterCallback", _src, res[1])
                            local coords = {x = res[1].x, y = res[1].y, z = res[1].z, h = res[1].h}
                            local model = res[1].model
                            TriggerClientEvent("spawnPlayerEvent", _src , coords, model, res[1].hp, res[1].mp_ped)
                            break
                        end
                    end
                else
                    TriggerClientEvent("notify", _src, "Une erreur est survenue.")
                end
            end)
        else
            TriggerClientEvent("notify", _src, "Ce personnage n'existe pas.")
        end
    end)
end)

 
RegisterServerEvent("savePedModel")
AddEventHandler("savePedModel", function(model)
    local _src = source 
    local c = exports.lib:ExtractIdentifiers("character")
    MySQL.Async.execute("UPDATE characters SET model = @model WHERE id = @id", { 
        ["model"] = model, 
        ["id"] = c.id 
    }, function(alteredRow)
        if alteredRow then
            TriggerClientEvent("notify", _src, "Model mise à jour.")
        else
            TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
        end
    end)
end)


RegisterServerEvent("updateCharacterName")
AddEventHandler("updateCharacterName", function(model)
    local _src = source 
    local c = exports.lib:ExtractIdentifiers("character")
    MySQL.Async.execute("UPDATE characters SET model = @model WHERE id = @id", { 
        ["model"] = model, 
        ["id"] = c.id 
    }, function(alteredRow)
        if alteredRow then
            TriggerClientEvent("notify", _src, "Model mise à jour.")
        else
            TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
        end
    end)
end)


RegisterNetEvent("sonnetteRequest")
AddEventHandler("sonnetteRequest", function(cid, coords)
    local _src = source
    for i,v in pairs(PlayerTable.players) do 
        if v.character.id == cid then 
            TriggerClientEvent("sonnetteRequest", v.serverId, _src, coords)
            break
        end
    end
end)




RegisterNetEvent("baseevents:onPlayerDied")
AddEventHandler('baseevents:onPlayerDied', function(killerType, deathCoords)
	local _src = source
    TriggerClientEvent("deathScreen", _src)
    TriggerClientEvent("hideInv", _src)
end)

AddEventHandler('playerDropped', function (reason)
    local _src = source 
    local id = exports.lib:ExtractIdentifiers(_src, 'character').id
    MySQL.Async.execute("UPDATE characters SET serverId = NULL WHERE id = @id", { 
        ["id"] = id, 
    }, function(alteredRow)
        if not alteredRow then 
            print("ERROR At set serverId null")
        end
    end)
    removePlayer(_src)
    print('Player ' .. GetPlayerName(_src) .. ' dropped (Reason: ' .. reason .. ')')
    printPlayers()
end)



RegisterNetEvent("updateCharacterHp")
AddEventHandler('updateCharacterHp', function(hp)
	local _src = source
    local cid = exports.lib:ExtractIdentifiers(_src, 'character').id
    MySQL.Async.execute("UPDATE characters SET hp = @hp WHERE id = @id", { 
        ["hp"] = hp, 
        ["id"] = cid, 
    }, function(alteredRow)
        if not alteredRow then 
            print("ERROR updating character hp")
        end
    end)
end)


RegisterNetEvent("updateCharacterFood")
AddEventHandler('updateCharacterFood', function(food)
	local _src = source
    local cid = exports.lib:ExtractIdentifiers(_src, 'character').id
    MySQL.Async.fetchAll("SELECT * FROM characters WHERE id = @id", {['id'] = cid}, function(res)
        if res[1] then 
            local newFood = res[1].food + food
            if newFood > 100 then 
                newFood = 100
            elseif newFood < 0 then 
                TriggerClientEvent("setCharacterHp", _src, 0)
                newFood = 0
            end
            MySQL.Async.execute("UPDATE characters SET food = @food WHERE id = @id", { 
                ["food"] = newFood, 
                ["id"] = cid, 
            }, function(alteredRow)
                if not alteredRow then 
                    print("ERROR updating character food")
                else
                    TriggerClientEvent("setCharacterFood", _src, newFood)
                end
            end)
        else
            print("ERROR updating character food")
        end
    end)
end)

RegisterNetEvent("updateCharacterWater")
AddEventHandler('updateCharacterWater', function(water)
	local _src = source
    local cid = exports.lib:ExtractIdentifiers(_src, 'character').id
    MySQL.Async.fetchAll("SELECT * FROM characters WHERE id = @id", {['id'] = cid}, function(res)
        if res[1] then 
            local newWater = res[1].water + water
            if newWater > 100 then 
                newWater = 100
            elseif newWater < 0 then 
                TriggerClientEvent("setCharacterHp", _src, 0)
                newWater = 0
            end
            MySQL.Async.execute("UPDATE characters SET water = @water WHERE id = @id", { 
                ["water"] = newWater, 
                ["id"] = cid, 
            }, function(alteredRow)
                if not alteredRow then 
                    print("ERROR updating character water")
                else
                    TriggerClientEvent("setCharacterWater", _src, newWater)
                end
            end)
        else
            print("ERROR updating character water")
        end
    end)
end)



RegisterServerEvent("saveMpPed")
AddEventHandler("saveMpPed", function(jsonString)
    local _src = source
    local id = exports.lib:ExtractIdentifiers(_src, "character").id
	MySQL.Async.execute("UPDATE characters SET mp_ped = @mp_ped, model = 1885233650 WHERE id = @id", { 
		["mp_ped"] = jsonString, 
		["id"] = id
	}, function(alteredRow)
		if alteredRow then
			TriggerClientEvent("notify", _src, "Ped sauvegardé")
		else
			TriggerClientEvent("notify", _src, "Une erreur s'est produite lors de la sauvegarde de la position.")
		end
	end)
end)


