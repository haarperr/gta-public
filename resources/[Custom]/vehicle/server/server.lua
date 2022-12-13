local garagesPublic
local fourrieres

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
	MySQL.ready(function ()
        MySQL.Async.fetchAll("SELECT * FROM garages WHERE type = 'public'", {
        }, function(res)
            if res[1] then
                garagesPublic = res
            end
        end)
        MySQL.Async.fetchAll("SELECT * FROM garages WHERE type = 'fourriere'", {
        }, function(res)
            if res[1] then
                fourrieres = res
            end
        end)
    end)
    print('The resource ' .. resourceName .. ' has been started.')
end)

RegisterServerEvent("getGaragesPublic")
AddEventHandler("getGaragesPublic", function()
    local _src = source
    if garagesPublic then 
        TriggerClientEvent("getGaragesPublicCallback", _src, garagesPublic)
    else
        MySQL.Async.fetchAll("SELECT * FROM garages WHERE type = 'public'", {
        }, function(res)
            if res[1] then
                TriggerClientEvent("getGaragesPublicCallback", _src, res)
            end
        end)
    end
end)

RegisterServerEvent("getFourrieres")
AddEventHandler("getFourrieres", function()
    local _src = source
    if fourrieres then 
        TriggerClientEvent("getFourriereCallback", _src, fourrieres)
    else
        MySQL.Async.fetchAll("SELECT * FROM garages WHERE type = 'fourriere'", {
        }, function(res)
            if res[1] then
                TriggerClientEvent("getFourriereCallback", _src, res)
            end
        end)
    end
end)

RegisterNetEvent("registerCar")
AddEventHandler("registerCar", function(veh)
    local _src = source
    local characterId = exports.lib:ExtractIdentifiers(_src, 'character').id
    MySQL.Async.fetchAll("SELECT * FROM ownedCar WHERE plate = @plate", {['plate'] = veh.plate}, function(res)
        if res[1] then 
            TriggerClientEvent("notify", _src, 'Cette plaque existe déjà.')
        else
            MySQL.Async.execute("INSERT INTO ownedCar (characterId, name, type, plate, model, stored) VALUES (@characterId, @name, @type, @plate, @model, @stored)", {
                ["characterId"] = characterId, 
                ["name"] = veh.name, 
                ["type"] = veh.type, 
                ["plate"] = veh.plate, 
                ["model"] = veh.model, 
                ["stored"] = 0,
            }, function(affectedRows)
                if affectedRows == 0 then
                    print("^3[SQL] ^2INSERT ^7ownedCar '^4"..veh.plate.."^7' FAILED.")
                    TriggerClientEvent("notify", _src, "Erreur lors de l'enregistrement.")
                else
                    print("^3[SQL] ^2INSERT ^7ownedCar '^4"..veh.plate.."^7' in database.")
                    TriggerClientEvent("notify", _src, "Voiture enregistrée!")
                end
            end)
        end
    end)
end)


RegisterNetEvent("buyCar")
AddEventHandler("buyCar", function(veh, price)
    local _src = source
    local characterId = exports.lib:ExtractIdentifiers(_src, 'character').id
    local characterId = exports.lib:ExtractIdentifiers(_src, "character").id
    MySQL.Async.fetchAll("SELECT * FROM characters inv WHERE id = @id", {['id'] = characterId}, function (res)
        if res[1] then
            if res[1].bank < price then 
                TriggerClientEvent("notifynui", _src, "error", "Concessionaire", "Payement refusé, pas assez de fond en banque pour finaliser l'achat.")
            else
                MySQL.Async.execute("UPDATE characters SET bank = @bank WHERE id = @id", {
                    ["bank"] = (res[1].bank - price), 
                    ["id"] = characterId
                }, function(alteredRow)
                    if alteredRow then
                        MySQL.Async.fetchAll("SELECT * FROM ownedCar WHERE plate = @plate", {['plate'] = veh.plate}, function(checkVeh)
                            local plate = veh.plate
                            if checkVeh[1] then 
                                plate = veh.plate.."0"
                            else
                                MySQL.Async.execute("INSERT INTO ownedCar (characterId, name, type, plate, model, stored, garageId) VALUES (@characterId, @name, @type, @plate, @model, 1, 13)", {
                                    ["characterId"] = characterId, 
                                    ["name"] = veh.name, 
                                    ["type"] = veh.type, 
                                    ["plate"] = plate, 
                                    ["model"] = veh.model, 
                                }, function(affectedRows)
                                    if affectedRows == 0 then
                                        TriggerClientEvent("notifynui", _src, "error", "Concessionaire", "Erreur lors de la requête.")
                                        print("^3[SQL] ^2INSERT ^7ownedCar '^4"..veh.plate.."^7' FAILED. CID = "..characterId.." Vehicle model = "..veh.model.." and price = "..price)
                                        MySQL.Async.execute("UPDATE characters SET bank = @bank WHERE id = @id", {
                                            ["bank"] = (res[1].bank + price), 
                                            ["id"] = characterId
                                        }, function(alteredRow)
                                            TriggerClientEvent("notifynui", _src, "info", "Concessionaire", "Vous avez été remboursé.")
                                        end)
                                    else
                                        print("^3[SQL] ^2INSERT ^7ownedCar '^4"..veh.plate.."^7' in database.")
                                        TriggerClientEvent("notifynui", _src, "success", "Concessionaire", "Merci pour votre achat, vous trouverez votre véhicule sur le parking de la concession.")
                                    end
                                end)
                            end
                        end)
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



RegisterNetEvent("getCarInGarage")
AddEventHandler("getCarInGarage", function(garage)
    local _src = source
    local c = exports.lib:ExtractIdentifiers(_src, 'character')
    if c.organisationId and garage.type == "entreprise" then 
        MySQL.Async.fetchAll("SELECT * FROM ownedCar WHERE garageId = @garageId AND stored = 1", {
            ['characterId'] = c.id,
            ['organisationId'] = c.organisationId,
            ['garageId'] = garage.id
        }, function(res)
            TriggerClientEvent('openGarageMenu', _src, res, garage)
        end)
    else
        MySQL.Async.fetchAll("SELECT * FROM ownedCar WHERE garageId = @garageId AND characterId = @characterId AND stored = 1", {
            ['characterId'] = c.id,
            ['garageId'] = garage.id
        }, function(res)
            TriggerClientEvent('openGarageMenu', _src, res, garage)
        end)
    end
end)

RegisterNetEvent("getCarInFourriere")
AddEventHandler("getCarInFourriere", function(garage)
    local _src = source
    local c = exports.lib:ExtractIdentifiers(_src, 'character')
    if c.organisationId then 
        MySQL.Async.fetchAll("SELECT * FROM ownedCar WHERE (characterId = @characterId OR organisationId = @organisationId) AND stored = 0", {
            ['characterId'] = c.id,
            ['organisationId'] = c.organisationId,
        }, function(res)
            TriggerClientEvent('openGarageMenu', _src, res, garage)
        end)
    else
        MySQL.Async.fetchAll("SELECT * FROM ownedCar WHERE characterId = @characterId AND stored = 0", {
            ['characterId'] = c.id,
        }, function(res)
            TriggerClientEvent('openGarageMenu', _src, res, garage)
        end)
    end
end)


RegisterServerEvent("buildApartMenuGarage")
AddEventHandler("buildApartMenuGarage", function(apart)
    local _src = source
    local characterId = exports.lib:ExtractIdentifiers(_src, 'character').id
    MySQL.Async.fetchAll("SELECT * FROM ownedCar WHERE stored = 1 AND apartId = @id", {
        ["id"] = apart.id
    }, function(cars)
        TriggerClientEvent("openGarageMenu", _src, cars, apart)
    end)
end)


RegisterNetEvent("getCarOutGarage")
AddEventHandler("getCarOutGarage", function(plate)
    local _src = source
    local c = exports.lib:ExtractIdentifiers(_src, 'character')
    MySQL.Async.fetchAll("SELECT * FROM ownedCar WHERE plate = @plate", {
        ["plate"] = plate
    }, function(res)
        if res[1] then 
            MySQL.Async.execute("UPDATE ownedCar SET stored = 0 WHERE id = @id", {
                ["id"] = res[1].id,
            }, function(alteredRow)
                if alteredRow then
                    TriggerClientEvent('spawnCar', _src, res[1])
                else
                    TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                end
            end)
        else
            TriggerClientEvent("notify", _src, "Vous n'avez pas ce véhicule.")
        end
    end)
end)

RegisterNetEvent("setCarInGarage")
AddEventHandler("setCarInGarage", function(veh, garage, gtype)
    local _src = source
    MySQL.Async.fetchAll("SELECT * FROM ownedCar WHERE plate = @plate", {
        ['plate'] = veh.plate
    }, function(res)
        if res[1] then 
            local garageId = nil
            local apartId = nil
            if gtype == "apart" then 
                apartId = garage.id 
            else
                garageId = garage.id 
            end
            --neon = @neon, neonColor = @neonColor, 
            MySQL.Async.execute("UPDATE ownedCar SET stored = 1, garageId = @garageId, apartId = @apartId, fuel = @fuel, dirt = @dirt, bodyHealth = @bodyHealth, engineHealth = @engineHealth, tankHealth = @tankHealth, spoiler = @spoiler, frontBumper = @frontBumper, rearBumper = @rearBumper, sideSkirt = @sideSkirt, exhaust = @exhaust, chassis = @chassis, grill = @grill, bonnet = @bonnet, leftFender = @leftFender, rightFender = @rightFender, roof = @roof, engine = @engine, brakes = @brakes, transmission = @transmission, horn = @horn, suspension = @suspension, armor = @armor, turbo = @turbo, subwoofer = @subwoofer, hydraulics = @hydraulics, xenonLights = @xenonLights, wheels = @wheels, sticker = @sticker, color1 = @color1, color2 = @color2, colorExtra = @colorExtra, colorWheel = @colorWheel, xenonColor = @xenonColor, livery = @livery, tint = @tint, extra1 = @extra1, extra2 = @extra2, extra3 = @extra3, extra4 = @extra4, extra5 = @extra5, extra6 = @extra6 WHERE id = @id", {
                ["id"] = res[1].id,
                ["garageId"] = garageId,
                ["apartId"] = apartId,
                ['fuel'] = veh.fuel, 
                ['dirt'] = veh.dirt,
                ['bodyHealth'] = veh.bodyHealth,
                ['engineHealth'] = veh.engineHealth,
                ['tankHealth'] = veh.tankHealth,
                ['spoiler'] = veh.spoiler,
                ['frontBumper'] = veh.frontBumper,
                ['rearBumper'] = veh.rearBumper,
                ['sideSkirt'] = veh.sideSkirt,
                ['exhaust'] = veh.exhaust,
                ['chassis'] = veh.chassis,
                ['grill'] = veh.grill,
                ['bonnet'] = veh.bonnet,
                ['leftFender'] = veh.leftFender,
                ['rightFender'] = veh.rightFender,
                ['roof'] = veh.roof,
                ['engine'] = veh.engine,
                ['brakes'] = veh.brakes,
                ['transmission'] = veh.transmission,
                ['horn'] = veh.horn,
                ['suspension'] = veh.suspension,
                ['armor'] = veh.armor,
                ['turbo'] = veh.turbo,
                ['subwoofer'] = veh.subwoofer,
                ['hydraulics'] = veh.hydraulics,
                ['xenonLights'] = veh.xenonLights,
                ['xenonColor'] = veh.xenonColor,
                ['wheels'] = veh.wheels,
                ['sticker'] = veh.sticker,
                -- ['neon'] = veh.neon,
                -- ['neonColor'] = veh.neonColor,
                ['color1'] = veh.color1,
                ['color2'] = veh.color2,
                ['colorExtra'] = veh.colorExtra,
                ['colorWheel'] = veh.colorWheel,
                ['livery'] = veh.livery,
                ['tint'] = veh.tint,
                ['extra1'] = veh.extra1,
                ['extra2'] = veh.extra2,
                ['extra3'] = veh.extra3,
                ['extra4'] = veh.extra4,
                ['extra5'] = veh.extra5,
                ['extra6'] = veh.extra6,
            }, function(alteredRow)
                if alteredRow then
                    TriggerClientEvent("notify", _src, "Voiture mise au garage.")
                    TriggerClientEvent('deleteCar', _src)
                else
                    TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
                end
            end)
        else
            TriggerClientEvent("notify", _src, "Impossible de ranger ce véhicule!")
        end
    end)
end)




RegisterNetEvent("baseevents:enteringVehicle")
AddEventHandler('baseevents:enteringVehicle', function(veh, seat, name)
	local _src = source
    TriggerClientEvent("lockHotwiredNeeded", _src, veh, seat)
end)

RegisterNetEvent("vehicule:echangeKey")
AddEventHandler('vehicule:echangeKey', function(cible, plate)
	local _src = source
    TriggerClientEvent("vehicule:recieveKey", cible, plate)
end)

RegisterNetEvent("requestUnlock")
AddEventHandler('requestUnlock', function(netid, veh)
	local _src = source
    if netid then
        TriggerClientEvent("requestUnlockClient", netid, veh)
    end
end)
