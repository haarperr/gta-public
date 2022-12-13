local organisations
local admins = {}
local players = {}

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' is starting.')
    MySQL.Async.fetchAll("SELECT * FROM organisations", {
    }, function(res)
        organisations = res
    end)
    print('The resource ' .. resourceName .. ' has been started.')
end)

-- Citizen.CreateThread(function()
--     while true do 
--         Citizen.Wait(300)
--         if admins then
--             for i,v in pairs(admins) do 
--                 TriggerClientEvent("updatePlayerPositionClient", v, players)
--             end
--         end
--     end
-- end)

-- RegisterServerEvent("getServerID")
-- AddEventHandler("getServerID", function()
--     local _src = source
--     TriggerClientEvent("getServerIDCallback", _src, _src)
-- end)


-- RegisterServerEvent("addAdminListener")
-- AddEventHandler("addAdminListener", function()
--     local _src = source 
--     if admins then
--         for i,p in pairs(admins) do
--             if p.serverId then
--                 if p.serverId == _src then
--                     return
--                 end
--             end
--         end
--     end
--     table.insert(admins, _src)
-- end)

-- RegisterServerEvent("removeAdminListener")
-- AddEventHandler("removeAdminListener", function()
--     local _src = source 
--     for i,p in pairs(admins) do
--         if p.serverId == _src then
--             table.remove(players, i)
--             return
--         end
--     end
-- end)

-- RegisterServerEvent("updatePlayerPosition")
-- AddEventHandler("updatePlayerPosition", function(pos, veh)
--     local _src = source
--     if players and pos.x then 
--         for i,p in pairs(players) do
--             if p.serverId == _src then
--                 players[i].x = pos.x
--                 players[i].y = pos.y
--                 players[i].z = pos.z
--                 players[i].name = GetPlayerName(_src)
--                 players[i].vehicule = veh
--                 return
--             end
--         end
--         local p = {
--             serverId = _src,
--             x = pos.x,
--             y = pos.y,
--             z = pos.z,
--             vehicule = veh
--         }
--         table.insert(players, p)
--     end
-- end)


-- AddEventHandler('playerDropped', function (reason)
--     local _src = source 
--     for i,p in pairs(players) do
--         if p.serverId == _src then
--             table.remove(players, i)
--             return
--         end
--     end
--     for i,p in pairs(admins) do
--         if p.serverId == _src then
--             table.remove(players, i)
--             return
--         end
--     end
-- end)

RegisterServerEvent("getOrgaList")
AddEventHandler("getOrgaList", function()
    local _src = source
    if organisations then 
        TriggerClientEvent("getOrgaCallback", _src, organisations)
    else
        MySQL.Async.fetchAll("SELECT * FROM organisations", {
        }, function(res)
            TriggerClientEvent("getOrgaCallback", _src, res)
        end)
    end
end)

RegisterServerEvent("getPersoList")
AddEventHandler("getPersoList", function()
    local _src = source
    local id = exports.lib:ExtractIdentifiers(_src, 'player').id
    MySQL.Async.fetchAll("SELECT * FROM characters WHERE userId = @userId", {
        ["userId"] = id,
    }, function(res)
        TriggerClientEvent("getPersoCallback", _src, res)
    end)
end)

RegisterServerEvent("getItemList")
AddEventHandler("getItemList", function()
    local _src = source
    local id = exports.lib:ExtractIdentifiers(_src, 'player').id
    MySQL.Async.fetchAll("SELECT * FROM items ORDER BY name ASC", {
    }, function(res)
        TriggerClientEvent("getItemCallback", _src, res)
    end)
end)

RegisterServerEvent("changeOrganisation")
AddEventHandler("changeOrganisation", function(cid, eid)
    local _src = source
    MySQL.Async.fetchAll("SELECT * FROM characters WHERE id = @id", {
        ['id'] = cid,
    }, function(res)
        if res[1] then
            MySQL.Async.execute("UPDATE characters SET organisationId = @organisationId WHERE id = @id", { 
                ["id"] = cid, 
                ["organisationId"] = eid, 
            }, function(alteredRow)
                if alteredRow then 
                    res[1].organisationId = eid
                    TriggerEvent("refreshCharacterEvent", _src, res[1])
                else
                    TriggerClientEvent("notify", "Une erreur est survenue.")
                end
            end)
        else
            TriggerClientEvent("notify", "Une erreur est survenue.")
        end
    end)
end)
