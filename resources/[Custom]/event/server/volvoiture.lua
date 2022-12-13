local locations = {
    {x = -440.1, y = -2178.4, z = 10.3, h = 354.3},
    {x = -1082.6, y = -1670.8, z = 4.7, h = 305.5},
    {x = 480.7, y = -1321.8, z = 29.2, h = 343.7},
    {x = -1095.0, y = 536.9, z = 102.7, h = 305.6},
    {x = -1792.0, y = 461.3, z = 128.3, h = 109.3},
    {x = -1995.7, y = 295.0, z = 91.7, h = 236.2},
    {x = -1490.7, y = 21.0, z = 54.7, h = 351.5},
    {x = -811.7, y = 187.0, z = 72.4, h = 108.6},
    {x = 22.0, y = 544.5, z = 176.0, h = 58.0},
    {x = -2992.8, y = 722.7, z = 28.5, h = 116.4},
    {x = -2596.8, y = 1930.7, z = 167.3, h = 273.8},
    {x = -2784.8, y = 1432.8, z = 100.9, h = 235.3},
    {x = 258.8, y = 2589.4, z = 44.9, h = 9.2},
    {x = 1541.8, y = 6335.4, z = 24.0, h = 53.6},
    {x = 2359.4, y = 3127.8, z = 48.2, h = 20.7},
    {x = 3333.4, y = 5160.8, z = 18.3, h = 149.3},
    {x = 2529.4, y = 4983.8, z = 44.8, h = 55.8},
    {x = 758.4, y = -3195.2, z = 6.0, h = 267.3},
    {x = 150.4, y = -3182.2, z = 5.8, h = 174.4},
    {x = -130.4, y = -2676.2, z = 6.0, h = 267.6},
    {x = -314.4, y = -2778.2, z = 5.0, h = 356.4},
    -- {x = 1202.4, y = -3116.6, z = 5.5, h = 1.8},
}
local models = {
    1093792632, -- NERO2
    234062309, -- Reaper
    -2048333973, -- Italigtb
    1011753235, -- Coquette classic
}

local vol = false
local volList = {}

RegisterNetEvent('createVolVehicule')
AddEventHandler('createVolVehicule', function()
    local _src = source
    local model = 1093792632
    if vol then 
        TriggerClientEvent("notifynui", _src, "error", "Crimi", "Je n'ai rien à te donner pour l'instant.")
    else 
        vol = true
        local i = math.random(1, #locations)
        local j = math.random(1, #models)
        print("Vol véhicule n°"..i.." - x : "..locations[i].x..", y : "..locations[i].y..", z : "..locations[i].z)
        -- local coord = vector3(locations[i].x, locations[i].y, (locations[i].z))
        TriggerClientEvent("createVolVehicule", _src, locations[i], models[j])
        TriggerClientEvent("notifynui", _src, "info", "Crimi", "Mes gars ont repéré un véhicule à voler ici, dépêche toi de le récupérer.")
    end
end)

function resetVol()
    Citizen.CreateThread(function()
        Wait(60000*5)
        vol = false
    end)
end


RegisterNetEvent('addVolVehicule')
AddEventHandler('addVolVehicule', function(plate, model)
    local _src = source
    for i,v in pairs(volList) do 
        if v.plate == plate then 
            TriggerClientEvent("notify", _src, "Une erreur est survenue.")
            return
        end
    end
    local add = {
        plate = plate,
        model = model
    }
    table.insert(volList, add)
end)

RegisterNetEvent('checkVolVehicule')
AddEventHandler('checkVolVehicule', function(plate, model)
    local _src = source
    local check = false
    for i,v in pairs(volList) do 
        if v.plate == plate then
            local cid = exports.lib:ExtractIdentifiers(_src, "character").id
            TriggerEvent("updateInventory", 43, 20000, _src)
            TriggerClientEvent("notifynui", _src, "success", "Crimi", "Merci pour le véhicule mec, voilà ton fric.")
            TriggerClientEvent('deleteCar', _src)
            return
        else
            TriggerClientEvent("notify", _src, "Une erreur est survenue.")
        end
    end
    if not check then 
        TriggerClientEvent("notifynui", _src, "error", "Crimi", "Ce vehicule ne m'intéresse pas.")
    end
end)