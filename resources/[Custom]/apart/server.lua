
RegisterServerEvent("setApartmentIn")
AddEventHandler("setApartmentIn", function(id, coords)
    local _src = source
    MySQL.Async.fetchAll("SELECT * FROM apart WHERE id = @id", {
        ['id'] = id,
    }, function(res)
        if res[1] then 
            MySQL.Async.execute("UPDATE apart SET xIn = @x, yIn = @y, zIn = @z, hIn = @h WHERE id = @id", {
                ["id"] = res[1].id,
                ["x"] = coords.x,
                ["y"] = coords.y,
                ["z"] = coords.z,
                ["h"] = coords.h,
            }, function(alteredRow)
                if alteredRow then
                    TriggerClientEvent("notify", _src, "Appartement mis à jour.")
                    MySQL.Async.fetchAll("SELECT * FROM apart", {}, function(aparts)
                        if aparts[1] then 
                            TriggerClientEvent("refreshApartMarkers", -1, aparts)
                        end
                    end)
                else
                    TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                end
            end)
        else
            TriggerClientEvent("notify", _src, "ERREUR : Pas d'appartement avec cet ID.")
        end
    end)
end)


RegisterServerEvent("setApartmentOut")
AddEventHandler("setApartmentOut", function(id, coords)
    local _src = source
    MySQL.Async.fetchAll("SELECT * FROM apart WHERE id = @id", {
        ['id'] = id,
    }, function(res)
        if res[1] then 
            MySQL.Async.execute("UPDATE apart SET xOut = @x, yOut = @y, zOut = @z, hOut = @h WHERE id = @id", {
                ["id"] = res[1].id,
                ["x"] = coords.x,
                ["y"] = coords.y,
                ["z"] = coords.z,
                ["h"] = coords.h,
            }, function(alteredRow)
                if alteredRow then
                    TriggerClientEvent("notify", _src, "Appartement mis à jour.")
                    MySQL.Async.fetchAll("SELECT * FROM apart", {}, function(aparts)
                        if aparts[1] then 
                            TriggerClientEvent("refreshApartMarkers", -1, aparts)
                            TriggerClientEvent("refreshApartBlips", -1, aparts)
                        end
                    end)
                else
                    TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                end
            end)
        else
            TriggerClientEvent("notify", _src, "ERREUR : Pas d'appartement avec cet ID.")
        end
    end)
end)

RegisterServerEvent("setApartmentGarage")
AddEventHandler("setApartmentGarage", function(id, coords)
    local _src = source
    MySQL.Async.fetchAll("SELECT * FROM apart WHERE id = @id", {
        ['id'] = id,
    }, function(res)
        if res[1] then 
            MySQL.Async.execute("UPDATE apart SET xGarage = @x, yGarage = @y, zGarage = @z, hGarage = @h WHERE id = @id", {
                ["id"] = res[1].id,
                ["x"] = coords.x,
                ["y"] = coords.y,
                ["z"] = coords.z,
                ["h"] = coords.h,
            }, function(alteredRow)
                if alteredRow then
                    TriggerClientEvent("notify", _src, "Appartement mis à jour.")
                    MySQL.Async.fetchAll("SELECT * FROM apart", {}, function(aparts)
                        if aparts[1] then 
                            TriggerClientEvent("refreshApartMarkers", -1, aparts)
                        end
                    end)
                else
                    TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                end
            end)
        else
            TriggerClientEvent("notify", _src, "ERREUR : Pas d'appartement avec cet ID.")
        end
    end)
end)





RegisterServerEvent("setApartCoffre")
AddEventHandler("setApartCoffre", function(id, ctype, coords)
    local _src = source
    MySQL.Async.fetchAll("SELECT * FROM apart WHERE id = @id", {
        ['id'] = id,
    }, function(res)
        if res[1] then 
            MySQL.Async.execute("INSERT INTO coffres (x, y, z, apartId, type, maxWeigh) VALUES (@x, @y, @z, @apartId, @type, @maxWeigh)", {
                ["apartId"] = res[1].id,
                ["x"] = coords.x,
                ["y"] = coords.y,
                ["z"] = coords.z,
                ["type"] = ctype,
                ["maxWeigh"] = 100,
            }, function(alteredRow)
                if alteredRow then
                    TriggerClientEvent("notify", _src, "Appartement mis à jour.")
                    MySQL.Async.fetchAll("SELECT * FROM coffres WHERE apartId IS NOT NULL", {}, function(apartscoffre)
                        if apartscoffre[1] then 
                            TriggerClientEvent("refreshApartCoffreMarkers", -1, apartscoffre)
                        end
                    end)
                else
                    TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                end
            end)
        else
            TriggerClientEvent("notify", _src, "ERREUR : Pas d'appartement avec cet ID.")
        end
    end)
end)


-- **************** FIN ADMIN





















RegisterServerEvent("getAllAparts")
AddEventHandler("getAllAparts", function()
    local _src = source
    MySQL.Async.fetchAll("SELECT * FROM apart", {}, function(aparts)
        if aparts[1] then 
            TriggerClientEvent("refreshApartMarkers", _src, aparts)
            TriggerClientEvent("refreshApartBlips", _src, aparts)
        end
    end)
    MySQL.Async.fetchAll("SELECT * FROM coffres WHERE apartId IS NOT NULL", {}, function(apartscoffre)
        if apartscoffre[1] then 
            TriggerClientEvent("refreshApartCoffreMarkers", _src, apartscoffre)
        end
    end)
end)


RegisterServerEvent("buyApart")
AddEventHandler("buyApart", function(apart)
    local _src = source
    local id = exports.lib:ExtractIdentifiers(_src, 'character').id
    MySQL.Async.fetchAll("SELECT bank FROM characters WHERE id = @id", {
        ["id"] = id,
    }, function(c)
        if c[1].bank < apart.price then 
            TriggerClientEvent("notifynui", _src, "error", "Achat", "Tu n'as pas assez d'argent sur ton compte en banque!")
        else
            MySQL.Async.execute("UPDATE characters SET bank = @bank WHERE id = @id", {
                ["id"] = id,
                ["bank"] = (c[1].bank - apart.price),
            }, function(alteredRow)
                if alteredRow then
                    MySQL.Async.execute("UPDATE apart SET characterId = @characterId WHERE id = @id", {
                        ["characterId"] = id,
                        ["id"] = apart.id,
                    }, function(alteredRow)
                        if alteredRow then
                            TriggerClientEvent("notifynui", _src, "success", "Achat", "Tu viens d'acheter cet appartemenet. Bienvenue chez toi.")
                            MySQL.Async.fetchAll("SELECT * FROM apart", {}, function(aparts)
                                if aparts[1] then 
                                    TriggerClientEvent("refreshApartBlips", -1, aparts)
                                    TriggerClientEvent("refreshApartMarkers", -1, aparts)
                                end
                            end)
                        else
                            TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                        end
                    end)
                else
                    TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                end
            end)
        end
    end)
end)

RegisterServerEvent("sellApart")
AddEventHandler("sellApart", function(apart)
    local _src = source
    local id = exports.lib:ExtractIdentifiers(_src, 'character').id
    MySQL.Async.execute("UPDATE characters SET bank = bank + @bank WHERE id = @id", {
        ["id"] = id,
        ["bank"] = apart.price,
    }, function(alteredRow)
        if alteredRow then
            MySQL.Async.execute("UPDATE apart SET characterId = NULL WHERE id = @id", {
                ["id"] = apart.id
            }, function(alteredRow)
                if alteredRow then
                    TriggerClientEvent("notifynui", _src, "success", "Vente", "Tu viens de vendre cet appartemenet.")
                    MySQL.Async.fetchAll("SELECT * FROM apart", {}, function(aparts)
                        if aparts[1] then 
                            TriggerClientEvent("refreshApartBlips", -1, aparts)
                            TriggerClientEvent("refreshApartMarkers", -1, aparts)
                        end
                    end)
                else
                    TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                end
            end)
        else
            TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
        end
    end)

end)

RegisterServerEvent("buildApartMenuOut")
AddEventHandler("buildApartMenuOut", function(apart)
    local _src = source
    MySQL.Async.fetchAll("SELECT * FROM apart WHERE id = @id", {
        ["id"] = apart.id
    }, function(res)
        if res[1] then 
            TriggerClientEvent("openApartMenu", _src, res[1])
        else
            TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
        end
    end)
end)


RegisterNetEvent("sonnetteOpen")
AddEventHandler("sonnetteOpen", function(from, coords)
    TriggerClientEvent("sonnetteOpen", from, coords)
end)