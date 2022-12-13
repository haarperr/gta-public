RegisterNetEvent("getEntreprise")
AddEventHandler("getEntreprise", function(dest)
    local _src = source
    local c = exports.lib:ExtractIdentifiers(_src, 'character')
    if c.organisationId then
        local coffres = MySQL.Sync.fetchAll("SELECT * FROM coffres WHERE organisationId = @organisationId ", {['organisationId'] = c.organisationId})
        local garages = MySQL.Sync.fetchAll("SELECT * FROM garages WHERE organisationId = @organisationId ", {['organisationId'] = c.organisationId})
        TriggerClientEvent("getEntrepriseCallback", _src, coffres, garages)
    end
end)



RegisterNetEvent("requestTransfo")
AddEventHandler("requestTransfo", function(itemId, q)
    local _src = source
    local userId = exports.lib:ExtractIdentifiers(_src, "character").id
    MySQL.Async.fetchAll("SELECT * FROM inventaireCharacter WHERE userId = @userId AND itemId = @itemId", {
        ['userId'] = userId,
        ['itemId'] = itemId
    }, function(item)
        if item[1] and item[1].quantity >= q then
            TriggerClientEvent("requestTransfo", _src, item[1].quantity)
        else
            TriggerClientEvent("notifynui", _src, "error", "Crimi", "Tu n'as rien à transformer.")
        end
    end)
end)

RegisterNetEvent("updateTransfo")
AddEventHandler("updateTransfo", function(item1, item2, quantity1, quantity2)
    local _src = source
    local userId = exports.lib:ExtractIdentifiers(_src, "character").id
    local item = MySQL.Sync.fetchAll("SELECT * FROM inventaireCharacter WHERE userId = @userId AND itemId = @itemId", {['userId'] = userId,['itemId'] = item1})
    if item[1] then
        if item[1].quantity - quantity1 > 0 then 
            local alteredRow = MySQL.Sync.execute("UPDATE inventaireCharacter SET quantity = @quantity WHERE userId = @userId AND itemId = @itemId", { 
                ["itemId"] = item1, 
                ["quantity"] = item[1].quantity - quantity1, 
                ["userId"] = userId 
            })
            if not alteredRow then
                TriggerClientEvent("notifynui", _src, "error", "Crimi", "Une erreur s'est produite.")
                return
            end
        elseif item[1].quantity - quantity1 == 0 then
            local alteredRow1 = MySQL.Sync.execute("DELETE FROM inventaireCharacter WHERE userId = @userId AND itemId = @itemId", { 
                ["itemId"] = item1, 
                ["userId"] = userId 
            })
            if not alteredRow1 then
                TriggerClientEvent("notifynui", _src, "error", "Crimi", "Une erreur s'est produite.")
                return
            end
        elseif item[1].quantity - quantity1 < 0 then
            TriggerClientEvent("notifynui", _src, "error", "Crimi", "Vous n'en avez pas assez.")
            return
        end
        local itemN = MySQL.Sync.fetchAll("SELECT * FROM inventaireCharacter WHERE userId = @userId AND itemId = @itemId", {['userId'] = userId,['itemId'] = item2})
        if itemN[1] then
            local alteredRow2 = MySQL.Sync.execute("UPDATE inventaireCharacter SET quantity = @quantity WHERE userId = @userId AND itemId = @itemId", { 
                ["itemId"] = item2, 
                ["quantity"] = itemN[1].quantity + quantity2, 
                ["userId"] = userId 
            })
            if not alteredRow2 then
                TriggerClientEvent("notifynui", _src, "error", "Crimi", "Une erreur s'est produite.")
                return
            end
        else
            local alteredRow3 = MySQL.Sync.execute("INSERT INTO inventaireCharacter (userId, itemId, quantity) VALUES (@userId, @itemId, @quantity)", {
                ["userId"] = userId, 
                ["itemId"] = item2, 
                ["quantity"] = quantity2
            })
            if not alteredRow3 then
                TriggerClientEvent("notifynui", _src, "error", "Crimi", "Une erreur s'est produite.")
                return
            end
        end
        TriggerClientEvent("notifynui", _src, "success", "Crimi", "Vous venez de fabriquer un pochon.")
    else
        TriggerClientEvent("notifynui", _src, "error", "Crimi", "Tu n'as rien à transformer.")
    end
end)














-- ************************* BLANCHISSERIE ******************************************************************

local blanchisseries 
Citizen.CreateThread(function()
	MySQL.ready(function ()
        MySQL.Async.fetchAll("SELECT * FROM blanchisseries", {
        }, function(res)
            if res[1] then
                blanchisseries = res
            end
        end)
	end)
end)
RegisterNetEvent("event:getBlanchisseries")
AddEventHandler("event:getBlanchisseries", function()
    local _src = source
	TriggerClientEvent("event:getBlanchisseriesCallBack", _src, blanchisseries)
end)

RegisterNetEvent("event:getBlanchisserieMenu")
AddEventHandler("event:getBlanchisserieMenu", function(id)
    local _src = source
	MySQL.Async.fetchAll("SELECT * FROM blanchisseries WHERE id = @id", {
		["id"]= id
	}, function(res)
		if res[1] then
			TriggerClientEvent("event:getBlanchisserieMenuCallBack", _src, res[1])
		end
	end)
end)


RegisterNetEvent("event:checkBlanchisserieDepot")
AddEventHandler("event:checkBlanchisserieDepot", function(id)
    local _src = source
	MySQL.Async.fetchAll("SELECT * FROM blanchisseries WHERE id = @id", {
		["id"]= id
	}, function(res)
		if res[1] then
			TriggerClientEvent("event:checkBlanchisserieDepotCallBack", _src, res[1].dirty, 1000000, res[1].id)
		end
	end)
end)

RegisterNetEvent("event:checkBlanchisserieRetrait")
AddEventHandler("event:checkBlanchisserieRetrait", function(id)
    local _src = source
	MySQL.Async.fetchAll("SELECT * FROM blanchisseries WHERE id = @id", {
		["id"]= id
	}, function(res)
		if res[1] then
			TriggerClientEvent("event:checkBlanchisserieRetraitCallBack", _src, res[1].cash, res[1].id)
		end
	end)
end)


RegisterNetEvent("event:blanchisserieDepot")
AddEventHandler("event:blanchisserieDepot", function(id, quantity)
	local _src = source
    local characterId = exports.lib:ExtractIdentifiers(_src, "character").id
	local itemId = 43
	MySQL.Async.fetchAll("SELECT * FROM inventaireCharacter WHERE characterId = @characterId AND itemId = @itemId", {
		['characterId'] = characterId,
		['itemId'] = itemId
	}, function(inv)
		if inv[1] then 
			if inv[1].quantity - quantity < 0 then 
				TriggerClientEvent("notifynui", _src, "error", "Blanchisserie", "Tu n'as pas suffisamment d'argent sale sur toi")
			elseif inv[1].quantity - quantity > 0 then 
				MySQL.Async.execute("UPDATE inventaireCharacter SET quantity = @quantity WHERE characterId = @characterId AND itemId = @itemId", { 
					["itemId"] = itemId, 
					["quantity"] = inv[1].quantity - quantity, 
					["characterId"] = characterId 
				}, function(alteredRow)
					if not alteredRow then
						TriggerClientEvent("notifynui", _src, "error", "Blanchisserie", "Une erreur s'est produite.")
					else
						TriggerClientEvent("refreshInventaireIfOpen", _src)
						MySQL.Async.execute("UPDATE blanchisseries SET dirty = dirty + @dirty WHERE id = @id", { 
							["dirty"] = quantity, 
							["id"] = id 
						}, function(alteredRow)
							if not alteredRow then
								print("[ERROR] Update blanchisserie, impossible d'ajouter "..quantity.."$.")
								TriggerClientEvent("notifynui", _src, "error", "Blanchisserie", "Une erreur s'est produite, merci de faire un ticket.")
							else
								TriggerClientEvent("notifynui", _src, "success", "Blanchisserie", "Tu as déposé "..quantity.."$ d'argent sale dans la blanchisserie.")
							end
						end)
					end
				end)
			else 
				MySQL.Async.execute("DELETE FROM inventaireCharacter WHERE characterId = @characterId AND itemId = @itemId", { 
					["itemId"] = itemId, 
					["characterId"] = characterId 
				}, function(alteredRow)
					if not alteredRow then
						TriggerClientEvent("notifynui", _src, "error", "Blanchisserie", "Une erreur s'est produite.")
					else
						TriggerClientEvent("refreshInventaireIfOpen", _src)
						MySQL.Async.execute("UPDATE blanchisseries SET dirty = dirty + @dirty WHERE id = @id", { 
							["dirty"] = quantity, 
							["id"] = id 
						}, function(alteredRow)
							if not alteredRow then
								print("[ERROR] Update blanchisserie, impossible d'ajouter "..quantity.."$.")
								TriggerClientEvent("notifynui", _src, "error", "Blanchisserie", "Une erreur s'est produite, merci de faire un ticket.")
							else
								TriggerClientEvent("notifynui", _src, "success", "Blanchisserie", "Tu as déposé "..quantity.."$ d'argent sale dans la blanchisserie.")
							end
						end)
					end
				end)                
			end
		else 
			TriggerClientEvent("notifynui", _src, "error", "Blanchisserie", "Tu n'as pas suffisamment d'argent sale sur toi")
		end
	end)
end)


RegisterNetEvent("event:blanchisserieRetrait")
AddEventHandler("event:blanchisserieRetrait", function(id, quantity)
	local _src = source
    local characterId = exports.lib:ExtractIdentifiers(_src, "character").id
	local itemId = 43
	MySQL.Async.fetchAll("SELECT * FROM blanchisseries WHERE id = @id", {
		["id"]= id
	}, function(res)
		if res[1] then
			if res[1].cash >= quantity then 
				MySQL.Async.execute("UPDATE blanchisseries SET cash = cash - @cash WHERE id = @id", { 
					["cash"] = quantity, 
					["id"] = id 
				}, function(alteredRow)
					if not alteredRow then
						print("[ERROR] Update blanchisserie, impossible de retirer "..quantity.."$.")
						TriggerClientEvent("notifynui", _src, "error", "Blanchisserie", "Une erreur s'est produite, merci de faire un ticket.")
					else
						MySQL.Async.execute("UPDATE characters SET cash = cash + @cash WHERE id = @id", {
							["cash"] = quantity, 
							["id"] = characterId
						}, function(alteredRow)
							if alteredRow then
								TriggerClientEvent("notifynui", _src, "success", "Blanchisserie", "Tu as récupéré "..quantity.."$ d'argent propre dans la blanchisserie.")
								MySQL.Async.fetchAll("SELECT * FROM characters inv WHERE id = @id", {['id'] = characterId}, function (res)
									if res[1] then
										TriggerClientEvent("updateCashInventaire", _src, res[1].cash + quantity)
									end
								end)
							else
								TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
							end
						end)
					end
				end)
			else
				TriggerClientEvent("notifynui", _src, "error", "Blanchisserie", "Il n'y a pas autant d'argent propre, maximum à retirer est de "..res[1].cash.."$.")
			end
		end
	end)
end)



Citizen.CreateThread(function()
	while not blanchisseries do 
		Wait(5000)
	end
	while true do 
		Wait(900000)
		for i,blanchisserie in pairs(blanchisseries) do 
			MySQL.Async.fetchAll("SELECT * FROM blanchisseries WHERE id = @id ", {['id'] = blanchisserie.id}, function(res)
				local total = 5200
				if res[1].dirty > 0 then
					if res[1].dirty < total then
						total = res[1].dirty
					end 
					MySQL.Sync.execute("UPDATE blanchisseries SET dirty = @dirty WHERE id = @id ", {['id'] = blanchisserie.id, ['dirty'] = (res[1].dirty-total)})
					MySQL.Sync.execute("UPDATE blanchisseries SET cash = @cash WHERE id = @id ", {['id'] = blanchisserie.id, ['cash'] = (res[1].cash+total)})
				end
			end)
		end
	end
end)