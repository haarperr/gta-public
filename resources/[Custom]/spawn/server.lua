local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local steamIdentifier
    local identifiers = GetPlayerIdentifiers(player)
    local message = "Steam is required to connect to this server."
    deferrals.defer()

    -- mandatory wait!
    Wait(0)

    deferrals.update(string.format("Hello %s. Your Steam ID is being checked.", name))

    for _, v in pairs(identifiers) do
        if string.find(v, "discord") then
            discordIdentifier = v
        end
        if string.find(v, "steam") then
            steamIdentifier = v
        end
    end

    Wait(0)

    if not discordIdentifier or not steamIdentifier then
        deferrals.done("You are not connected to Steam AND Discord.")
    else
        print(discordIdentifier:gsub("discord:", "").." is connecting.")
        MySQL.Async.fetchAll("SELECT * FROM users WHERE discordId = @discordId", {['discordId'] = discordIdentifier:gsub("discord:", "")}, function(res)
            if res[1] then 
                if not res[1].currentCharacter then 
                    deferrals.done("Tu n'as pas de personnage, tu dois créer ton personnage sur https://swiily.ddns.net:4443/.")
                else
                    MySQL.Async.execute("UPDATE users SET steamId = @steamId, lastJoin = @date WHERE id = @id", { ["serverId"] = _src , ["steamId"] = steamIdentifier:gsub("steam:", ""), ['date'] = os.date('%Y-%m-%d %H:%M:%S'), ["id"] = res[1].id}, function()
                        print("^3[SQL] UPDATE ^7user '^4"..discordIdentifier:gsub("discord:", "").."^7' in database.")
                    end)
                    deferrals.done()
                end
            else
                deferrals.done("You are not in the whitelist.")
            end
        end)
    end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)


-- RegisterServerEvent("getIds")
-- AddEventHandler("getIds", function()
--     local _src = source 
--     identifiers = {
--         steam = "",
--         ip = ""
--     }

--     --Loop over all identifiers
--     for i = 0, GetNumPlayerIdentifiers(_src) - 1 do
--         local id = GetPlayerIdentifier(_src, i)

--         --Convert it to a nice table.
--         if string.find(id, "steam") then
--             identifiers.steam = id
--         elseif string.find(id, "ip") then
--             identifiers.ip = id
--         end
--     end

--     local steamId = identifiers.steam:gsub("steam:", "")
--     local result = MySQL.Sync.fetchAll("SELECT * FROM characters as c RIGHT JOIN users as u ON c.id = u.currentCharacter WHERE u.steamId = @steamId", {['steamId'] = steamId})
--     if result[1] then
--         res = result[1]
--         coords = { x = res.x+0.001, y = res.y+0.001, z = res.z+0.001, h = res.h+0.001 }
--     --     -- coords = { x = result[1].x, y = result[1].y, z = result[1].z, h = result[1].h }
--         model = result[1].model
--         -- model = 1885233650
--     else
--         coords = { x = -802.311, y = 175.056, z = 72.8446, h = 0 }
--         model = -50684386
--         print("error : no character found")
--     end

--     -- TriggerClientEvent("spawnPlayerEvent", _src , coords, model)
-- end)