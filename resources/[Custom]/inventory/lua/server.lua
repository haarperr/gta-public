
RegisterServerEvent("transfertTo")
AddEventHandler("transfertTo", function(data)

    local _src = source
    local sourceId = exports.lib:ExtractIdentifiers(_src, "character").id
    local destId = exports.lib:ExtractIdentifiers(data.to, "character").id
    local itemId = data.item.Item.id
    local item
    local continue = 1

    local item = MySQL.Sync.fetchAll("SELECT * FROM items WHERE id = @itemId", {["itemId"] = itemId})[1]

    local inventaire = MySQL.Sync.fetchAll("SELECT * FROM inventaireCharacter inv RIGHT JOIN items ON inv.itemId = items.id WHERE characterId = @characterId", {["itemId"] = itemId, ['characterId'] = destId})
    local totalWeight = 0
    for i,it in pairs(inventaire) do
        totalWeight = totalWeight + (it.weight * it.quantity)
    end
    totalWeight = totalWeight + (item.weight * data.quantity)
    if totalWeight > 30 then 
        continue = 0
        TriggerClientEvent("refreshInventaire", _src)
        TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Cette personne n'a pas assez de place sur elle.")
        TriggerClientEvent("notifynui", data.to, "error", "Inventaire", "Quelqu'un a essayé de vous donner quelque chose mais vous n'avez plus de place.")
        return
    end
    -- RETIRE L'ITEM DU PERSONNAGE SOURCE
    if continue == 1 then 
        local res = MySQL.Sync.fetchAll("SELECT * FROM inventaireCharacter inv WHERE characterId = @characterId AND itemId = @itemId", {["itemId"] = itemId, ['characterId'] = sourceId})
        if res[1] then
            if res[1].quantity > data.quantity then
                local alteredRow = MySQL.Sync.execute("UPDATE inventaireCharacter SET quantity = @quantity WHERE characterId = @characterId AND itemId = @itemId", {["itemId"] = itemId, ["quantity"] = res[1].quantity - data.quantity, ["characterId"] = sourceId})
                if not alteredRow then
                    continue = 0
                end
            elseif res[1].quantity  == data.quantity then
                local alteredRow = MySQL.Sync.execute("DELETE FROM inventaireCharacter WHERE characterId = @characterId AND itemId = @itemId", {["itemId"] = itemId, ["characterId"] = sourceId })
                if not alteredRow then            
                    continue = 0
                end
            else
                continue = 0
            end
        else
            continue = 0
        end
    end

    -- AJOUT L'ITEM AU PERSONNAGE TARGET
    if continue == 1 then 
        local res = MySQL.Sync.fetchAll("SELECT * FROM inventaireCharacter inv WHERE characterId = @characterId AND itemId = @itemId", {["itemId"] = itemId, ['characterId'] = destId})
        if res[1] then
            local alteredRow = MySQL.Sync.execute("UPDATE inventaireCharacter SET quantity = @quantity WHERE characterId = @characterId AND itemId = @itemId", {["itemId"] = itemId, ["quantity"] = res[1].quantity+data.quantity, ["characterId"] = destId})
            if not alteredRow then
                continue = 0
            end
        else
            local alteredRow = MySQL.Sync.execute("INSERT INTO inventaireCharacter (characterId, itemId, quantity) VALUES (@characterId, @itemId, @quantity)", {["characterId"] = destId, ["itemId"] = itemId, ["quantity"] = data.quantity})
            if not alteredRow then 
                continue = 0
            end
        end
    end

    if continue == 1 then 
        TriggerClientEvent("notifynui", _src, "success", "Inventaire", "Vous avez donné "..data.quantity.."x "..item.name)
        TriggerClientEvent("notifynui", data.to, "success", "Inventaire", "Vous avez reçu "..data.quantity.."x "..item.name)
        TriggerClientEvent("animationEchange", _src)
        TriggerClientEvent("animationEchange", data.to)
    else
        TriggerClientEvent("refreshInventaire", _src)
        TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Une erreur s'est produite.")
    end

end)



RegisterServerEvent("transfertCash")
AddEventHandler("transfertCash", function(data)

    local _src = source
    local sourceId = exports.lib:ExtractIdentifiers(_src, "character").id
    local destId = exports.lib:ExtractIdentifiers(data.to, "character").id
    local continue = 1

    -- RETIRE L'ITEM DU PERSONNAGE SOURCE
    if continue == 1 then 
        local res = MySQL.Sync.fetchAll("SELECT * FROM characters WHERE id = @id", {['id'] = sourceId})
        if res[1] then
            local alteredRow = MySQL.Sync.execute("UPDATE characters SET cash = @cash WHERE id = @id", {["cash"] = res[1].cash-data.quantity, ["id"] = sourceId})
            if not alteredRow then
                continue = 0
            else
                TriggerClientEvent("updateCashInventaire", _src, res[1].cash+data.quantity)
            end
        else
            continue = 0
        end
    end

    -- AJOUT L'ITEM AU PERSONNAGE TARGET
    if continue == 1 then 
        local res = MySQL.Sync.fetchAll("SELECT * FROM characters inv WHERE id = @id", {['id'] = destId})
        if res[1] then
            local alteredRow = MySQL.Sync.execute("UPDATE characters SET cash = @cash WHERE id = @id", {["cash"] = res[1].cash+data.quantity, ["id"] = destId})
            if not alteredRow then
                continue = 0
            else
                TriggerClientEvent("updateCashInventaire", _src, res[1].cash+data.quantity)
            end
        else
            continue = 0
        end
    end

    if continue == 1 then 
        TriggerClientEvent("notifynui", _src, "success", "Inventaire", "Vous avez donné $"..data.quantity)
        TriggerClientEvent("notifynui", data.to, "success", "Inventaire", "Vous avez reçu $"..data.quantity)
        TriggerClientEvent("animationEchange", _src)
        TriggerClientEvent("animationEchange", data.to)
    else
        TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Une erreur s'est produite.")
    end

end)

RegisterNetEvent("updateCash")
AddEventHandler("updateCash", function(quantity, sourcesrv)
    local _src
    if sourcesrv then 
        _src = sourcesrv
    else
        _src = source
    end
    local characterId = exports.lib:ExtractIdentifiers(_src, "character").id
    MySQL.Async.fetchAll("SELECT * FROM characters inv WHERE id = @id", {['id'] = characterId}, function (res)
        if res[1] then
            if quantity > 0 then
                MySQL.Async.execute("UPDATE characters SET cash = @cash WHERE id = @id", {
                    ["cash"] = res[1].cash + quantity, 
                    ["id"] = characterId
                }, function(alteredRow)
                    if alteredRow then
                        TriggerClientEvent("updateCashInventaire", _src, res[1].cash + quantity)
                        TriggerClientEvent("notifynui", _src, "success", "Inventaire", "Tu as reçu $"..quantity.." en cash.")
                    else
                        TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                    end
                end)
            elseif quantity < 0 then 
                if res[1].cash >= quantity then
                    MySQL.Async.execute("UPDATE characters SET cash = @cash WHERE id = @id", {
                        ["cash"] = res[1].cash + quantity, 
                        ["id"] = characterId
                    }, function(alteredRow)
                        if not alteredRow then
                            TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                        else
                            TriggerClientEvent("updateCashInventaire", _src, res[1].cash + quantity)
                        end
                    end)
                else
                    TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Tu n'as pas assez d'argent sur toi.")
                end
            end
        else
            TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
        end
    end)
end)


RegisterNetEvent("updateBank")
AddEventHandler("updateBank", function(quantity, sourcesrv)
    local _src
    if sourcesrv then 
        _src = sourcesrv
    else
        _src = source
    end
    local characterId = exports.lib:ExtractIdentifiers(_src, "character").id
    MySQL.Async.fetchAll("SELECT * FROM characters inv WHERE id = @id", {['id'] = characterId}, function (res)
        if res[1] then
            if quantity > 0 then
                MySQL.Async.execute("UPDATE characters SET bank = @bank WHERE id = @id", {
                    ["bank"] = res[1].bank + quantity, 
                    ["id"] = characterId
                }, function(alteredRow)
                    if alteredRow then
                        TriggerClientEvent("notifynui", _src, "success", "Inventaire", "Tu as reçu $"..quantity.." sur ton compte.")
                    else
                        TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                    end
                end)
            elseif quantity < 0 then 
                if res[1].bank >= quantity then
                    MySQL.Async.execute("UPDATE characters SET bank = @bank WHERE id = @id", {
                        ["bank"] = res[1].bank + quantity, 
                        ["id"] = characterId
                    }, function(alteredRow)
                        if not alteredRow then
                            TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                        end
                    end)
                else
                    TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Tu n'as pas assez d'argent sur toi.")
                end
            end
        else
            TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
        end
    end)
end)

RegisterNetEvent("updateCashWithCallback")
AddEventHandler("updateCashWithCallback", function(quantity, callback, params, sourcesrv)
    local _src
    if sourcesrv then 
        _src = sourcesrv
    else
        _src = source
    end
    local characterId = exports.lib:ExtractIdentifiers(_src, "character").id
    MySQL.Async.fetchAll("SELECT * FROM characters inv WHERE id = @id", {['id'] = characterId}, function (res)
        if res[1] then
            if quantity > 0 then
                MySQL.Async.execute("UPDATE characters SET cash = @cash WHERE id = @id", {
                    ["cash"] = (res[1].cash + quantity), 
                    ["id"] = characterId
                }, function(alteredRow)
                    if alteredRow then
                        TriggerClientEvent("updateCashInventaire", _src, res[1].cash + quantity)
                        TriggerClientEvent(callback, _src, params)
                    else
                        TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                    end
                end)
            elseif quantity < 0 then 
                if res[1].cash - quantity >= 0 then
                    MySQL.Async.execute("UPDATE characters SET cash = @cash WHERE id = @id", {
                        ["cash"] = (res[1].cash + quantity), 
                        ["id"] = characterId
                    }, function(alteredRow)
                        if alteredRow then
                            TriggerClientEvent("updateCashInventaire", _src, res[1].cash + quantity)
                            TriggerClientEvent(callback, _src, params)
                        else
                            TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                        end
                    end)
                else
                    TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Tu n'as pas assez d'argent sur toi.")
                end
            end
        else
            TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
        end
    end)
end)

RegisterNetEvent("updateBankWithCallback")
AddEventHandler("updateBankWithCallback", function(quantity, callback, params, sourcesrv)
    local _src
    if sourcesrv then 
        _src = sourcesrv
    else
        _src = source
    end
    local characterId = exports.lib:ExtractIdentifiers(_src, "character").id
    MySQL.Async.fetchAll("SELECT * FROM characters inv WHERE id = @id", {['id'] = characterId}, function (res)
        if res[1] then
            if quantity > 0 then
                MySQL.Async.execute("UPDATE characters SET bank = @bank WHERE id = @id", {
                    ["bank"] = (res[1].bank + quantity), 
                    ["id"] = characterId
                }, function(alteredRow)
                    if alteredRow then
                        TriggerClientEvent(callback, _src, params)
                    else
                        TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                    end
                end)
            elseif quantity < 0 then 
                MySQL.Async.execute("UPDATE characters SET bank = @bank WHERE id = @id", {
                    ["bank"] = (res[1].bank + quantity), 
                    ["id"] = characterId
                }, function(alteredRow)
                    if alteredRow then
                        TriggerClientEvent(callback, _src, params)
                    else
                        TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                    end
                end)
            end
        else
            TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
        end
    end)
end)





RegisterNetEvent("updateInventory")
AddEventHandler("updateInventory", function(itemId, quantity, sourcesrv)
    local _src
    if sourcesrv then 
        _src = sourcesrv
    else
        _src = source
    end
    local characterId = exports.lib:ExtractIdentifiers(_src, "character").id

    local item = MySQL.Sync.fetchAll("SELECT * FROM items WHERE id = @itemId", {["itemId"] = itemId})[1]

    if quantity > 0 then 
        local inventaire = MySQL.Sync.fetchAll("SELECT * FROM inventaireCharacter inv RIGHT JOIN items ON inv.itemId = items.id WHERE characterId = @characterId", {['characterId'] = characterId})
        local totalWeight = 0
        for i,it in pairs(inventaire) do
            totalWeight = totalWeight + (it.weight * it.quantity)
        end
        totalWeight = totalWeight + (item.weight * quantity)
        if totalWeight > 30 then 
            TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Tu n'as plus de place dans ton inventaire.")
            return
        end
    end

    MySQL.Async.fetchAll("SELECT * FROM inventaireCharacter WHERE characterId = @characterId AND itemId = @itemId", {
        ['characterId'] = characterId,
        ['itemId'] = itemId
    }, function(item)
        if quantity < 0 then
            if item[1] then 
                if item[1].quantity + quantity > 0 then 
                    MySQL.Async.execute("UPDATE inventaireCharacter SET quantity = @quantity WHERE characterId = @characterId AND itemId = @itemId", { 
                        ["itemId"] = itemId, 
                        ["quantity"] = item[1].quantity + quantity, 
                        ["characterId"] = characterId 
                    }, function(alteredRow)
                        if not alteredRow then
                            TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Une erreur s'est produite.")
                        else
                            TriggerClientEvent("refreshInventaireIfOpen", _src)
                        end
                    end)
                else 
                    MySQL.Async.execute("DELETE FROM inventaireCharacter WHERE characterId = @characterId AND itemId = @itemId", { 
                        ["itemId"] = itemId, 
                        ["characterId"] = characterId 
                    }, function(alteredRow)
                        if not alteredRow then
                            TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Une erreur s'est produite.")
                        else
                            TriggerClientEvent("refreshInventaireIfOpen", _src)
                        end
                    end)                
                end
            else 
                TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Vous n'avez pas cet item.")
            end
        elseif quantity > 0 then 
            if item[1] then 
                MySQL.Async.execute("UPDATE inventaireCharacter SET quantity = @quantity WHERE characterId = @characterId AND itemId = @itemId", { 
                    ["itemId"] = itemId, 
                    ["quantity"] = item[1].quantity + quantity, 
                    ["characterId"] = characterId 
                }, function(alteredRow)
                    if not alteredRow then
                        TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Une erreur s'est produite.")
                    else
                        TriggerClientEvent("refreshInventaireIfOpen", _src)
                    end
                end)
            else 
                MySQL.Async.execute("INSERT INTO inventaireCharacter (characterId, itemId, quantity) VALUES (@characterId, @itemId, @quantity)", {
                    ["characterId"] = characterId, 
                    ["itemId"] = itemId, 
                    ["quantity"] = quantity
                }, function(alteredRow)
                    if not alteredRow then
                        TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Une erreur s'est produite.")
                    else
                        TriggerClientEvent("refreshInventaireIfOpen", _src)
                    end
                end)
            end
        end
    end)
end)



RegisterNetEvent("updateInventoryWithCallback")
AddEventHandler("updateInventoryWithCallback", function(callback, params, itemId, quantity, sourcesrv)
    local _src
    if sourcesrv then 
        _src = sourcesrv
    else
        _src = source
    end
    local characterId = exports.lib:ExtractIdentifiers(_src, "character").id

    local item = MySQL.Sync.fetchAll("SELECT * FROM items WHERE id = @itemId", {["itemId"] = itemId})[1]
    
    if quantity > 0 then 
        local inventaire = MySQL.Sync.fetchAll("SELECT * FROM inventaireCharacter inv RIGHT JOIN items ON inv.itemId = items.id WHERE characterId = @characterId", {['characterId'] = characterId})
        local totalWeight = 0
        for i,it in pairs(inventaire) do
            totalWeight = totalWeight + (it.weight * it.quantity)
        end
        totalWeight = totalWeight + (item.weight * quantity)
        if totalWeight > 30 then 
            TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Tu n'as plus de place dans ton inventaire.")
            return
        end
    end

    MySQL.Async.fetchAll("SELECT * FROM inventaireCharacter WHERE characterId = @characterId AND itemId = @itemId", {
        ['characterId'] = characterId,
        ['itemId'] = itemId
    }, function(itemInv)
        if quantity < 0 then
            if itemInv[1] then 
                if itemInv[1].quantity + quantity > 0 then 
                    MySQL.Async.execute("UPDATE inventaireCharacter SET quantity = @quantity WHERE characterId = @characterId AND itemId = @itemId", { 
                        ["itemId"] = itemId, 
                        ["quantity"] = itemInv[1].quantity + quantity, 
                        ["characterId"] = characterId 
                    }, function(alteredRow)
                        if not alteredRow then
                            TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Une erreur s'est produite.")
                        else
                        TriggerClientEvent("refreshInventaireIfOpen", _src)
                        TriggerClientEvent(callback, _src, params, itemInv[1].quantity + quantity)
                        end
                    end)
                else 
                    MySQL.Async.execute("DELETE FROM inventaireCharacter WHERE characterId = @characterId AND itemId = @itemId", { 
                        ["itemId"] = itemId, 
                        ["characterId"] = characterId 
                    }, function(alteredRow)
                        if not alteredRow then
                            TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Une erreur s'est produite.")
                        else
                        TriggerClientEvent("refreshInventaireIfOpen", _src)
                        TriggerClientEvent(callback, _src, params, 0)
                        end
                    end)                
                end
            else 
                TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Tu n'as pas suffisamment de "..item.name)
            end
        elseif quantity > 0 then 
            if itemInv[1] then 
                MySQL.Async.execute("UPDATE inventaireCharacter SET quantity = @quantity WHERE characterId = @characterId AND itemId = @itemId", { 
                    ["itemId"] = itemId, 
                    ["quantity"] = itemInv[1].quantity + quantity, 
                    ["characterId"] = characterId 
                }, function(alteredRow)
                    if not alteredRow then
                        TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Une erreur s'est produite.")
                    else
                        TriggerClientEvent("refreshInventaireIfOpen", _src)
                        TriggerClientEvent(callback, _src, params, itemInv[1].quantity + quantity)
                    end
                end)
            else 
                MySQL.Async.execute("INSERT INTO inventaireCharacter (characterId, itemId, quantity) VALUES (@characterId, @itemId, @quantity)", {
                    ["characterId"] = characterId, 
                    ["itemId"] = itemId, 
                    ["quantity"] = quantity
                }, function(alteredRow)
                    if not alteredRow then
                        TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Une erreur s'est produite.")
                    else
                        TriggerClientEvent("refreshInventaireIfOpen", _src)
                        TriggerClientEvent(callback, _src, params, quantity)
                    end
                end)
            end
        end
    end)
end)














RegisterNetEvent("updateAmmo")
AddEventHandler("updateAmmo", function(quantity, gun)
    local _src = source
    local characterId = exports.lib:ExtractIdentifiers(_src, "character").id
    MySQL.Async.fetchAll("SELECT * FROM items WHERE action = @gun AND type = 'ammo'", {
        ['gun'] = gun
    }, function (i)
        if i[1] then 
            itemId = i[1].id
            if quantity > 0 then
                MySQL.Async.execute("UPDATE inventaireCharacter SET quantity = @quantity WHERE characterId = @characterId AND itemId = @itemId", { 
                    ["itemId"] = itemId, 
                    ["quantity"] = quantity, 
                    ["characterId"] = characterId 
                }, function(alteredRow)
                    if not alteredRow then
                        TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Une erreur s'est produite lors de la mise à jour des munitions.")
                    else
                        TriggerClientEvent("refreshInventaireIfOpen", _src)
                    end
                end)
            else
                MySQL.Async.execute("DELETE FROM inventaireCharacter WHERE characterId = @characterId AND itemId = @itemId", {
                    ["characterId"] = characterId, 
                    ["itemId"] = itemId, 
                }, function(alteredRow)
                    if not alteredRow then
                        TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Une erreur s'est produite lors de la mise à jour des munitions.")
                    else
                        TriggerClientEvent("refreshInventaireIfOpen", _src)
                    end
                end)
            end
        else
            TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Une erreur s'est produite lors de la mise à jour des munitions.")
        end
    end)
end)


RegisterNetEvent("requestRevive")
AddEventHandler("requestRevive", function(player)
    local _src = source
    TriggerClientEvent("requestReviveCallback", player)
end)
RegisterNetEvent("requestHandcuff")
AddEventHandler("requestHandcuff", function(player, bool)
    local _src = source
    TriggerClientEvent("requestHandcuffCallback", player, bool)
    if bool then 
        TriggerClientEvent("notifynui", _src, "success", "Menotte", "Vous avez menotté le joueur.")
    else
        TriggerClientEvent("notifynui", _src, "success", "Menotte", "Vous avez démenotté le joueur.")
    end
end)



RegisterNetEvent("baseevents:onPlayerDied")
AddEventHandler('baseevents:onPlayerDied', function(killerType, deathCoords)
	local _src = source
    TriggerClientEvent("hideInv", _src)
end)