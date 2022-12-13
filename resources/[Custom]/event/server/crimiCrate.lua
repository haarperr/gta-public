local crate
local crateNumber
local crateContent
local crateObject


local crateLocations = {
    {x = -1859.82, y = -68.13, z = 110.04},
    {x = -1269.95, y = -249.13, z = 60.65},
    {x = -1092.98, y = 2.2, z = 50.9},
    {x = -1004.91, y = -955.3, z = 2.15},
    {x = -581.62, y = -1450.3, z = 10.53},
    {x = -1662.62, y = -3218.3, z = 14.53},
    {x = 1139.62, y = -3262.3, z = 5.9},
    {x = 1800.62, y = -2711.94, z = 2.05},
    {x = 2110.2, y = -1775.51, z = 188.5},
    {x = 2814.2, y = -626.51, z = 2.83},
    {x = 1449.19, y = 1068.38, z = 114.33},
    {x = 3071.19, y = 2124.38, z = 2.13},
    {x = 3348.82, y = 5151.38, z = 19.44},
    {x = 2557.82, y = 6185.38, z = 162.88},
    {x = 1226.92, y = 5967.53, z = 369.57},
    {x = 140.19, y = 7340.3, z = 9.68},
    -- {x = -900.0, y = 6046.0, z = 43.57},
    {x = -1178.3, y = 4925.9, z = 223.37},
    {x = -3000.3, y = 3343.9, z = 10.39},
    {x = -1891.3, y = 2088.9, z = 141.0},
    {x = -1546.7, y = 846.9, z = 182.09},
}

RegisterNetEvent("createCrate")
AddEventHandler("createCrate", function(cmdid, content)
    local _src = source
    -- local id = exports.lib:getSteamId(_src)
    if crate then
        TriggerClientEvent("notifynui", _src, "error", "Crimi", "Vous avez déjà une caisse en cours.")
    else
        local i = math.random(1, #crateLocations)
        print("Crate n°"..i.." - x : "..crateLocations[i].x..", y : "..crateLocations[i].y..", z : "..crateLocations[i].z-0.99)
        local dest = vector3(crateLocations[i].x, crateLocations[i].y, (crateLocations[i].z-0.99))
        crate = cmdid
        crateNumber = i
        crateContent = content.CommandeContents
        crateObject = CreateObjectNoOffset("prop_box_wood07a", crateLocations[i].x, crateLocations[i].y, (crateLocations[i].z-0.99), true, false, false)
        TriggerClientEvent("createCrateBlip", _src, dest)
        TriggerClientEvent("dropZone", -1, dest, _src)
        TriggerClientEvent("notifynui", _src, "info", "Crimi", "Livraison en cours..")
    end
end)



RegisterNetEvent("getCrateContent")
AddEventHandler("getCrateContent", function(playerSource)
    local _src = source
    local commandeWeight = 0
    for i,item in pairs(crateContent) do
        commandeWeight = commandeWeight + (item.Item.weight * item.quantity)
    end
    local characterId = exports.lib:ExtractIdentifiers(_src, "character").id
    local item = MySQL.Sync.fetchAll("SELECT * FROM items WHERE id = @itemId", {["itemId"] = itemId})[1]
    local inventaire = MySQL.Sync.fetchAll("SELECT * FROM inventaireCharacter inv RIGHT JOIN items ON inv.itemId = items.id WHERE characterId = @characterId", {['characterId'] = characterId})
    local totalWeight = 0
    for i,it in pairs(inventaire) do
        totalWeight = totalWeight + (it.weight * it.quantity)
    end
    totalWeight = totalWeight + commandeWeight
    if totalWeight > 30 then 
        TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Tu n'as plus de place dans ton inventaire.")
        return
    else 
        for i,item in pairs(crateContent) do
            TriggerEvent("updateInventory", item.itemId, item.quantity, _src)
            TriggerClientEvent("notifynui", _src, "info", "Crimi", "Tu as récupéré "..item.quantity.." x "..item.Item.name..".")        
        end
        TriggerClientEvent("dropZoneDelete", -1)
        TriggerClientEvent("deleteCrateBlip", playerSource)
        if DoesEntityExist(crateObject) then 
            DeleteEntity(crateObject)
        end
        MySQL.Async.execute("UPDATE commandes SET statut = 'done' WHERE id = @id", { 
            ["id"] = crate, 
        }, function(alteredRow)
            if not alteredRow then
                crate = nil
                crateContent = nil
                TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
            else
                crate = nil
                crateContent = nil
            end
        end)
    end
end)



RegisterNetEvent("sellCrate")
AddEventHandler("sellCrate", function()
    local _src = source
    local userId = exports.lib:ExtractIdentifiers(_src, "character").id
    local itemId = 2
    MySQL.Async.fetchAll("SELECT * FROM inventory inv RIGHT JOIN items it ON inv.itemId = it.id WHERE userId = @userId AND itemId = @itemId", {
        ["itemId"] = itemId, 
        ['userId'] = userId
    }, function(item)
        if item[1] then
            local cash = item[1].quantity*item[1].priceCrimi
            MySQL.Async.execute("DELETE FROM inventory WHERE userId = @userId AND itemId = @itemId", {
                ["itemId"] = itemId, 
                ['userId'] = userId
            }, function(alteredInv)                    
                if alteredInv then
                    MySQL.Async.execute("UPDATE characters SET cash = cash+@cash WHERE id = @userId", {
                        ["cash"] = cash, 
                        ['userId'] = userId
                    }, function(alteredRow)                    
                        if alteredRow then
                            TriggerClientEvent("notify", _src, "Vous avez vendu "..item[1].quantity..' '..item[1].name..' pour '..cash..'$')
                        else
                            TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                        end
                    end)
                else
                    TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                end
            end)
        else
            TriggerClientEvent("notify", _src, "Vous n'avez pas de caisse d'armes.")
        end
    end)
end)



RegisterNetEvent("sellPetitSac")
AddEventHandler("sellPetitSac", function()
    local _src = source
    local userId = exports.lib:ExtractIdentifiers(_src, "character").id
    local itemId = 4
    MySQL.Async.fetchAll("SELECT * FROM inventory inv RIGHT JOIN items it ON inv.itemId = it.id WHERE userId = @userId AND itemId = @itemId", {
        ["itemId"] = itemId, 
        ['userId'] = userId
    }, function(item)
        if item[1] then
            local cash = item[1].quantity*item[1].priceCrimi
            MySQL.Async.execute("DELETE FROM inventory WHERE userId = @userId AND itemId = @itemId", {
                ["itemId"] = itemId, 
                ['userId'] = userId
            }, function(alteredInv)                    
                if alteredInv then
                    MySQL.Async.execute("UPDATE characters SET cash = cash+@cash WHERE id = @userId", {
                        ["cash"] = cash, 
                        ['userId'] = userId
                    }, function(alteredRow)                    
                        if alteredRow then
                            TriggerClientEvent("notify", _src, "Vous avez vendu "..item[1].quantity..' '..item[1].name..' pour '..cash..'$')
                        else
                            TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                        end
                    end)
                else
                    TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                end
            end)
        else
            TriggerClientEvent("notify", _src, "Vous n'avez pas de petit sac d'argent.")
        end
    end)
end)





AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    if DoesEntityExist(crateObject) then 
        DeleteEntity(crateObject)
    end
    print('The resource ' .. resourceName .. ' was stopped.')
  end)