local superettes
local ammunations
local pharmacies = {
    {x= 214.98, y=-1834.6, z=26.48},
    {x= 396.81, y=-793.14, z=28.29},
    {x= 303.5, y=-597.99, z=42.3},
    {x= 235.3, y=-26.9, z=68.9},
    {x= 1839.45, y=3672.7, z=33.3},
    {x= -170.69, y=6381.7, z=30.5},
}


AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' is starting.')
	MySQL.ready(function ()
        MySQL.Async.fetchAll("SELECT * FROM superettes", {
        }, function(res)
            if res[1] then
                superettes = res
            end
        end)
        MySQL.Async.fetchAll("SELECT * FROM ammunations", {
        }, function(res)
            if res[1] then
                ammunations = res
            end
        end)
    end)
    print('The resource ' .. resourceName .. ' has been started.')
end)


RegisterServerEvent("getSuperettes")
AddEventHandler("getSuperettes", function()
    local _src = source
    if superettes then 
        TriggerClientEvent("getSuperettesCallback", _src, superettes)
    else
        MySQL.Async.fetchAll("SELECT * FROM superettes", {
        }, function(res)
            if res[1] then
                TriggerClientEvent("getSuperettesCallback", _src, res)
            end
        end)
    end
end)

RegisterServerEvent("getAmmunations")
AddEventHandler("getAmmunations", function()
    local _src = source
    if ammunations then 
        TriggerClientEvent("getAmmunationsCallback", _src, ammunations)
    else
        MySQL.Async.fetchAll("SELECT * FROM ammunations", {
        }, function(res)
            if res[1] then
                TriggerClientEvent("getAmmunationsCallback", _src, res)
            end
        end)
    end
end)

RegisterServerEvent("getPharmacies")
AddEventHandler("getPharmacies", function()
    local _src = source
    TriggerClientEvent("getPharmaciesCallback", _src, pharmacies)
end)

-- RegisterServerEvent("addsup")
-- AddEventHandler("addsup", function(id, coords)
--     local _src = source
--     MySQL.Async.execute("INSERT INTO superettes (x, y, z) VALUES (@x, @y, @z)", {
--         ["x"] = coords.x,
--         ["y"] = coords.y,
--         ["z"] = coords.z,
--     }, function(alteredRow)
--         if alteredRow then
--             MySQL.Async.fetchAll("SELECT * FROM superettes ORDER BY ID DESC", {}, function(sup)
--                 TriggerClientEvent("notify", _src, "Superette créée avec succès. ID: "..sup[1].id)
--             end)
--         else
--             TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
--         end
--     end)
-- end)

-- RegisterServerEvent("addsuppnj")
-- AddEventHandler("addsuppnj", function(id, coords)
--     local _src = source
--     MySQL.Async.fetchAll("SELECT * FROM superettes WHERE id = @id", {
--         ["id"] = id
--     }, function(item)
--         if item[1] then
--             MySQL.Async.execute("UPDATE superettes SET xPNJ = @x, yPNJ = @y, zPNJ = @z, hPNJ = @h WHERE id = @id", { 
--                 ["id"] = id, 
--                 ["x"] = coords.x,
--                 ["y"] = coords.y,
--                 ["z"] = coords.z,
--                 ["h"] = coords.h,
--             }, function(alteredRow)
--                 if alteredRow then
--                     TriggerClientEvent("notify", _src, "Superette mise à jour avec succès.")
--                 else
--                     TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
--                 end
--             end)
--         else
--             TriggerClientEvent("notify", _src, "Pas de superette avec l'id "..id)
--         end
--     end)
-- end)


RegisterServerEvent("tryBraquage")
AddEventHandler("tryBraquage", function(sup)
    local _src = source
    MySQL.Async.fetchAll("SELECT * FROM superettes WHERE id = @id", {
        ["id"] = sup.id
    }, function(res)
        if res[1] then
            if res[1].lastBraquage then 
                local lb = res[1].lastBraquage/1000
                local now = os.time(os.date("!*t"))
                local dif = now-lb
                if dif > (5*60) then 
                    MySQL.Async.execute("UPDATE superettes SET lastBraquage = CURRENT_TIMESTAMP() WHERE id = @id", { 
                        ["id"] = sup.id, 
                    }, function(alteredRow)
                        if alteredRow then
                            TriggerClientEvent("tryBraquageCallback", _src, res[1])
                        else
                            TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                        end
                    end)
                else 
                    TriggerClientEvent("notify", _src, "Les caisses sont scellées.")
                end
            end            
        else
            TriggerClientEvent("notify", _src, "Pas de superette avec l'id "..id)
        end
    end)
end)


RegisterNetEvent("getPetitSac")
AddEventHandler("getPetitSac", function()
    local _src = source
    local userId = exports.lib:ExtractIdentifiers(_src, "character").id
    local itemId = 4
    MySQL.Async.fetchAll("SELECT * FROM inventory inv WHERE userId = @userId AND itemId = @itemId", {
        ["itemId"] = itemId, 
        ['userId'] = userId
    }, function(res)
        MySQL.Async.fetchAll("SELECT * FROM items WHERE id = @itemId", {
            ["itemId"] = itemId
        }, function(item)
            if res[1] then
                MySQL.Async.execute("UPDATE inventory SET quantity = @quantity WHERE userId = @userId AND itemId = @itemId", { 
                    ["itemId"] = itemId, 
                    ["quantity"] = res[1].quantity+1, 
                    ["userId"] = userId 
                }, function(alteredRow)
                    crate = false
                    if alteredRow then
                        TriggerClientEvent("notify", _src, "Vous avez récupéré 1 "..item[1].name)
                    else
                        TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                    end
                end)
            else
                MySQL.Async.execute("INSERT INTO inventory (userId, itemId, quantity) VALUES (@userId, @itemId, @quantity)", {
                    ["userId"] = userId, 
                    ["itemId"] = itemId, 
                    ["quantity"] = 1
                }, function()
                    crate = false
                    TriggerClientEvent("notify", _src, "Vous avez récupéré 1 "..item[1].name)
                end)
            end
        end)
    end)
end)