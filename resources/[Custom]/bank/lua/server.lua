local banks

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' is starting.')
	MySQL.ready(function ()
        MySQL.Async.fetchAll("SELECT * FROM banks", {
        }, function(res)
            if res[1] then
                banks = res
            end
        end)
    end)
    print('The resource ' .. resourceName .. ' has been started.')
end)


RegisterServerEvent("getBanks")
AddEventHandler("getBanks", function()
    local _src = source
    if banks then 
        TriggerClientEvent("getBanksCallback", _src, banks)
    else
        MySQL.Async.fetchAll("SELECT * FROM banks", {
        }, function(res)
            if res[1] then
                TriggerClientEvent("getBanksCallback", _src, res)
            end
        end)
    end
end)



RegisterNetEvent("atm")
AddEventHandler("atm", function(t, q)
    local _src = source
    local cId = exports.lib:ExtractIdentifiers(_src, 'character').id
    MySQL.Async.fetchAll("SELECT * FROM characters WHERE id = @cId", {
        ['cId'] = cId
    }, function(c)
        if c[1] then
            local bank = 0
            local cash = 0
            if t == 'r' then 
                if c[1].bank >= q then
                    bank = -q
                    cash = q
                else 
                    TriggerClientEvent("notify", _src, "Vous n'avez pas assez d'argent sur le compte.")
                    return
                end
            elseif t == 'd' then
                if c[1].cash >= q then
                    bank = q
                    cash = -q
                else 
                    TriggerClientEvent("notify", _src, "Vous n'avez pas assez d'argent sur vous.")
                    return
                end
            else 
                return
            end
            MySQL.Async.execute("UPDATE characters SET cash = cash+@cash, bank = bank+@bank WHERE id = @cId", {
                ["cash"] = cash, 
                ["bank"] = bank, 
                ['cId'] = cId
            }, function(alteredRow)                    
                if alteredRow then
                    c[1].bank = c[1].bank + bank
                    c[1].cash = c[1].cash + cash
                    TriggerClientEvent("notify", _src, "Transaction de "..q..'$ terminée.')
                    TriggerClientEvent("getMoneyCallback", _src, c[1].bank, c[1].cash)
                else
                    TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                end
            end)
        else
            TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
        end
    end)
end)


RegisterServerEvent("addbank")
AddEventHandler("addbank", function(id, coords)
    local _src = source
    MySQL.Async.execute("INSERT INTO banks (x, y, z) VALUES (@x, @y, @z)", {
        ["x"] = coords.x,
        ["y"] = coords.y,
        ["z"] = coords.z,
    }, function(alteredRow)
        if alteredRow then
            TriggerClientEvent("notify", _src, "Banque créée avec succès.")
        else
            TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
        end
    end)
end)