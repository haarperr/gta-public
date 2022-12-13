local goFast
local goFastTimer
local champs

local livraisons = {
    {x = -1147.9, y = -2039.5, z = 13.1},
    {x = -1320.6, y = -1167.1, z = 4.8},
    {x = -1264.2, y = -828.8, z = 17.0},
    {x = -1223.9, y = -710.8, z = 22.3},
    {x = -1406.8, y = -253.9, z = 46.3},
    {x = -674.9, y = -880.8, z = 24.4},
    {x = 315.9, y = 501.5, z = 153.1},
    {x = 953.3, y = -196.7, z = 73.2},
    {x = 890.4, y = -540.8, z = 58.1},
    {x = 821.7, y = -786.7, z = 26.1},
    {x = 819.2, y = -2365.3, z = 30.1},
    {x = 475.7, y = -1324.7, z = 29.1}
}

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    MySQL.ready(function ()
        MySQL.Async.fetchAll("SELECT * FROM champs", {
        }, function(res)
            if res then
                champs = res
            end
        end)
    end)
end)


RegisterNetEvent('getChamps')
AddEventHandler('getChamps', function(c)
    while not champs do 
        Wait(100)
    end
    TriggerClientEvent("getChampsCallback", source, champs)
end)

RegisterNetEvent('getChampMenu')
AddEventHandler('getChampMenu', function(id)
    local _src = source
    MySQL.Async.fetchAll("SELECT * FROM champs WHERE id = @id", {
        ["id"] = id
    }, function(res)
        if res[1] then
            TriggerClientEvent("getChampMenuCallback", _src, res[1])
        else
            TriggerClientEvent("notifynui", _src, "error", "Cahmp", "Une erreur s'est produite.")
        end
    end)
end)


RegisterNetEvent("champDepot")
AddEventHandler("champDepot", function(id, itemId, quantity, ctype)
	local _src = source
    local characterId = exports.lib:ExtractIdentifiers(_src, "character").id
	MySQL.Async.fetchAll("SELECT * FROM inventaireCharacter WHERE characterId = @characterId AND itemId = @itemId", {
		['characterId'] = characterId,
		['itemId'] = itemId
	}, function(inv)
		if inv[1] then 
			if inv[1].quantity - quantity < 0 then 
				TriggerClientEvent("notifynui", _src, "error", "Champ", "Tu n'en as pas suffisamment sur toi")
			elseif inv[1].quantity - quantity > 0 then 
				MySQL.Async.execute("UPDATE inventaireCharacter SET quantity = @quantity WHERE characterId = @characterId AND itemId = @itemId", { 
					["itemId"] = itemId, 
					["quantity"] = inv[1].quantity - quantity, 
					["characterId"] = characterId 
				}, function(alteredRow)
					if not alteredRow then
						TriggerClientEvent("notifynui", _src, "error", "Champ", "Une erreur s'est produite.")
					else
						TriggerClientEvent("refreshInventaireIfOpen", _src)
                        if ctype == "seed" then
                            MySQL.Async.execute("UPDATE champs SET stockSeed = stockSeed + @stockSeed WHERE id = @id", { 
                                ["stockSeed"] = quantity, 
                                ["id"] = id 
                            }, function(alteredRow)
                                if not alteredRow then
                                    print("[ERROR] Update champ, impossible d'ajouter "..quantity..".")
                                    TriggerClientEvent("notifynui", _src, "error", "Champ", "Une erreur s'est produite, merci de faire un ticket.")
                                else
                                    TriggerClientEvent("notifynui", _src, "success", "Champ", "Tu as déposé "..quantity.." graines dans le champ.")
                                end
                            end)
                        elseif ctype == "water" then
                            MySQL.Async.execute("UPDATE champs SET stockWater = stockWater + @stockWater WHERE id = @id", { 
                                ["stockWater"] = quantity, 
                                ["id"] = id 
                            }, function(alteredRow)
                                if not alteredRow then
                                    print("[ERROR] Update champ, impossible d'ajouter "..quantity..".")
                                    TriggerClientEvent("notifynui", _src, "error", "Champ", "Une erreur s'est produite, merci de faire un ticket.")
                                else
                                    TriggerClientEvent("notifynui", _src, "success", "Champ", "Tu as déposé "..quantity.." d'eau dans le champ.")
                                end
                            end)
                        elseif ctype == "fertilizer" then
                            MySQL.Async.execute("UPDATE champs SET stockFertilizer = stockFertilizer + @stockFertilizer WHERE id = @id", { 
                                ["stockFertilizer"] = quantity, 
                                ["id"] = id 
                            }, function(alteredRow)
                                if not alteredRow then
                                    print("[ERROR] Update champ, impossible d'ajouter "..quantity..".")
                                    TriggerClientEvent("notifynui", _src, "error", "Champ", "Une erreur s'est produite, merci de faire un ticket.")
                                else
                                    TriggerClientEvent("notifynui", _src, "success", "Champ", "Tu as déposé "..quantity.." de fertilisant dans le champ.")
                                end
                            end)
                        end
					end
				end)
			else 
				MySQL.Async.execute("DELETE FROM inventaireCharacter WHERE characterId = @characterId AND itemId = @itemId", { 
					["itemId"] = itemId, 
					["characterId"] = characterId 
				}, function(alteredRow)
					if not alteredRow then
						TriggerClientEvent("notifynui", _src, "error", "Champ", "Une erreur s'est produite.")
					else
						TriggerClientEvent("refreshInventaireIfOpen", _src)
						if ctype == "seed" then
                            MySQL.Async.execute("UPDATE champs SET stockSeed = stockSeed + @stockSeed WHERE id = @id", { 
                                ["stockSeed"] = quantity, 
                                ["id"] = id 
                            }, function(alteredRow)
                                if not alteredRow then
                                    print("[ERROR] Update champ, impossible d'ajouter "..quantity..".")
                                    TriggerClientEvent("notifynui", _src, "error", "Champ", "Une erreur s'est produite, merci de faire un ticket.")
                                else
                                    TriggerClientEvent("notifynui", _src, "success", "Champ", "Tu as déposé "..quantity.." graines dans le champ.")
                                end
                            end)
                        elseif ctype == "water" then
                            MySQL.Async.execute("UPDATE champs SET stockWater = stockWater + @stockWater WHERE id = @id", { 
                                ["stockWater"] = quantity, 
                                ["id"] = id 
                            }, function(alteredRow)
                                if not alteredRow then
                                    print("[ERROR] Update champ, impossible d'ajouter "..quantity..".")
                                    TriggerClientEvent("notifynui", _src, "error", "Champ", "Une erreur s'est produite, merci de faire un ticket.")
                                else
                                    TriggerClientEvent("notifynui", _src, "success", "Champ", "Tu as déposé "..quantity.."d'eau dans le champ.")
                                end
                            end)
                        elseif ctype == "fertilizer" then
                            MySQL.Async.execute("UPDATE champs SET stockFertilizer = stockFertilizer + @stockFertilizer WHERE id = @id", { 
                                ["stockFertilizer"] = quantity, 
                                ["id"] = id 
                            }, function(alteredRow)
                                if not alteredRow then
                                    print("[ERROR] Update champ, impossible d'ajouter "..quantity..".")
                                    TriggerClientEvent("notifynui", _src, "error", "Champ", "Une erreur s'est produite, merci de faire un ticket.")
                                else
                                    TriggerClientEvent("notifynui", _src, "success", "Champ", "Tu as déposé "..quantity.."de fertilisant dans le champ.")
                                end
                            end)
                        end
					end
				end)                
			end
		else 
			TriggerClientEvent("notifynui", _src, "error", "Champ", "Tu n'en as pas suffisamment sur toi")
		end
	end)
end)


RegisterNetEvent("champRetrait")
AddEventHandler("champRetrait", function(id, quantity)
    local _src = source
    local characterId = exports.lib:ExtractIdentifiers(_src, "character").id
    local champ = MySQL.Sync.fetchAll("SELECT * FROM champs WHERE id = @id", {["id"] = id})[1]

    local item = MySQL.Sync.fetchAll("SELECT * FROM items WHERE id = @itemId", {["itemId"] = champ.itemId})[1]

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
    MySQL.Async.execute("UPDATE champs SET stockItem = stockItem - @stockItem WHERE id = @id", { 
        ["stockItem"] = quantity, 
        ["id"] = id 
    }, function(alteredRow)
        if not alteredRow then
            print("[ERROR] Update champ, impossible de retirer "..quantity..".")
            TriggerClientEvent("notifynui", _src, "error", "Champ", "Une erreur s'est produite, merci de faire un ticket.")
        else
            MySQL.Async.fetchAll("SELECT * FROM inventaireCharacter WHERE characterId = @characterId AND itemId = @itemId", {
                ['characterId'] = characterId,
                ['itemId'] = champ.itemId
            }, function(citem)
                if quantity > 0 then 
                    if citem[1] then 
                        MySQL.Async.execute("UPDATE inventaireCharacter SET quantity = quantity + @quantity WHERE characterId = @characterId AND itemId = @itemId", { 
                            ["itemId"] = champ.itemId, 
                            ["quantity"] = quantity, 
                            ["characterId"] = characterId 
                        }, function(alteredRow)
                            if not alteredRow then
                                TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Une erreur s'est produite.")
                            else
                                TriggerClientEvent("refreshInventaireIfOpen", _src)
                                TriggerClientEvent("notifynui", _src, "success", "Champ", "Tu as récupéré "..quantity.." "..item.name..".")
                            end
                        end)
                    else 
                        MySQL.Async.execute("INSERT INTO inventaireCharacter (characterId, itemId, quantity) VALUES (@characterId, @itemId, @quantity)", {
                            ["characterId"] = characterId, 
                            ["itemId"] = champ.itemId, 
                            ["quantity"] = quantity
                        }, function(alteredRow)
                            if not alteredRow then
                                TriggerClientEvent("notifynui", _src, "error", "Inventaire", "Une erreur s'est produite.")
                            else
                                TriggerClientEvent("refreshInventaireIfOpen", _src)
                                TriggerClientEvent("notifynui", _src, "success", "Champ", "Tu as récupéré "..quantity.." "..item.name..".")
                            end
                        end)
                    end
                end
            end)
        end
    end)
end)


Citizen.CreateThread(function()
	while not champs do 
		Wait(5000)
	end
	while true do 
		Wait(3600000)
		for i,champ in pairs(champs) do 
			MySQL.Async.fetchAll("SELECT * FROM champs WHERE id = @id ", {['id'] = champ.id}, function(res)
				local totalSeed = 100
				local totalFertilizer = 0
				local totalRaw = 500
                local c = res[1]
				if c.stockSeed > 0 and c.stockItem < 9000 then
                    if c.stockSeed >= 100 then
                        totalSeed = 100
                        totalRaw = 500
                    else
                        totalSeed = c.stockSeed
                        totalRaw = (c.stockSeed*5)
                    end
                    if c.stockFertilizer > 0 then
                        if c.stockFertilizer >= totalSeed then 
                            totalRaw = totalRaw * 5
                            totalFertilizer = totalSeed
                        else
                            totalRaw = (totalSeed - c.stockFertilizer)*5 + (c.stockFertilizer * 5)
                            totalFertilizer = c.stockFertilizer
                        end
                    end
					MySQL.Sync.execute("UPDATE champs SET stockSeed = stockSeed - @stockSeed, stockFertilizer = stockFertilizer - @stockFertilizer, stockItem = stockItem + @stockItem WHERE id = @id ", {
                        ['id'] = champ.id, 
                        ['stockSeed'] = totalSeed, 
                        ['stockFertilizer'] = totalFertilizer, 
                        ['stockItem'] = totalRaw, 
                    })
				end
			end)
		end
	end
end)
























RegisterNetEvent("startGoFast")
AddEventHandler("startGoFast", function(dest)
    local _src = source
    if goFast then
        TriggerClientEvent("notifynui", _src, "error", "Crimi", "Il y a déjà une livraison en cours.")
    elseif goFastTimer and GetGameTimer() <= goFastTimer+(60000*5) then
        TriggerClientEvent("notifynui", _src, "error", "Crimi", "Je n'ai pas de livraison à te proposer pour l'instant.")
    else
        local i = math.random(1, #livraisons)
        print("Go Fast started number "..i.." x : "..livraisons[i].x.." y : "..livraisons[i].y.." z : "..livraisons[i].z)
        local dest = vector3(livraisons[i].x, livraisons[i].y, (livraisons[i].z-0.99))
        goFast = true
        goFastTimer = GetGameTimer()+120000
        TriggerClientEvent("notifynui", _src, "info", "Crimi", "Tu as 2 minutes pour me livrer 60 pochons de cannabis ici.")
        TriggerClientEvent("startGoFastCallback", _src, dest)
        goFastListener(_src)
    end
end)

function goFastListener(_src)
    local _src = _src
    Citizen.CreateThread(function()
        while goFast do 
            if GetGameTimer() >= goFastTimer then 
                TriggerClientEvent("goFastFailed", _src)
                TriggerClientEvent("notifynui", _src, "error", "Crimi", "Tu as mis trop de temps pour livrer le client.")
                goFast = false
            end
            Citizen.Wait(0)
        end
    end)
end

RegisterNetEvent("stopGoFast")
AddEventHandler("stopGoFast", function(dest)
    local _src = source
    goFast = false
end)



RegisterNetEvent("livraisonGoFast")
AddEventHandler("livraisonGoFast", function(itemId, quantity)
    local _src = source
    local userId = exports.lib:ExtractIdentifiers(_src, "character").id
    local itemData = MySQL.Sync.fetchAll("SELECT * FROM items WHERE id = @itemId", {["itemId"] = itemId})[1]
    if not itemData then 
        TriggerClientEvent("notifynui", _src, "error", "Crimi", "Une erreur s'est produite.")
        return
    end
    local item = MySQL.Sync.fetchAll("SELECT * FROM inventaireCharacter WHERE characterId = @userId AND itemId = @itemId", {
        ['userId'] = userId,
        ['itemId'] = itemId
    })
    if item[1] then
        if item[1].quantity >= quantity then
            if (item[1].quantity - quantity) > 0 then 
                local alteredRow = MySQL.Sync.execute("UPDATE inventaireCharacter SET quantity = @quantity WHERE characterId = @userId AND itemId = @itemId", { 
                    ["itemId"] = itemId, 
                    ["quantity"] = item[1].quantity - quantity, 
                    ["userId"] = userId 
                })
                if not alteredRow then
                    TriggerClientEvent("notifynui", _src, "error", "Crimi", "Une erreur s'est produite.")
                    return
                end
            elseif (item[1].quantity - quantity) == 0 then
                local alteredRow = MySQL.Sync.execute("DELETE FROM inventaireCharacter WHERE characterId = @userId AND itemId = @itemId", { 
                    ["itemId"] = itemId, 
                    ["userId"] = userId 
                })
                if not alteredRow then
                    TriggerClientEvent("notifynui", _src, "error", "Crimi", "Une erreur s'est produite.")
                    return
                end
            end
            TriggerEvent("updateInventory", 43, (itemData.priceCrimi*quantity), _src)
            TriggerClientEvent("notifynui", _src, "success", "Crimi", "Livraison terminée, tiens voilà tes billets.")
        else
            TriggerClientEvent("notifynui", _src, "error", "Crimi", "Tu te fous de moi ?? C'est pas ce qu'on avait convenu.")
        end
    else
        TriggerClientEvent("notifynui", _src, "error", "Crimi", "Une erreur s'est produite.")
    end
end)
