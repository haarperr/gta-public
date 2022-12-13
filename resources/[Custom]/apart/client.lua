
local characterId 

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' is starting on the client.')
    Wait(2000)
    TriggerServerEvent("getCharacter")
    print('The resource ' .. resourceName .. ' has been started on the client.')
end)


RegisterNetEvent('getCharacterCallback')
AddEventHandler('getCharacterCallback', function(c)
    characterId = c.id
    TriggerServerEvent("getAllAparts")
end)


local aparts = {}


function openMenuAmenupartOut(apart)
    
    local menu = exports.menu:CreateMenu({name = "apt", title = apart.name, subtitle = 'Appartement', footer = 'Appuyer sur Entrée.'})
    menu.ClearItems(menu)

    if not exports.menu:isMenuOpen() then
        Citizen.Wait(5)
        if not apart.characterId then
            menu.AddButton(menu, {label = "Visiter l'appartement", select = function()
                exports.menu:closeMenu()
                exports.lib:teleportTo(apart.xIn, apart.yIn, apart.zIn, apart.hIn)
            end})
            menu.AddButton(menu, {label = "Acheter l'appartement pour "..apart.price.."$", type = 'confirm' , select = function()
                exports.menu:closeMenu()
                TriggerServerEvent("buyApart", apart)
            end})
        else
            if apart.characterId == characterId then
                menu.AddButton(menu, {label = "Entrer dans l'appartement", select = function()
                    exports.menu:closeMenu()
                    exports.lib:teleportTo(apart.xIn, apart.yIn, apart.zIn, apart.hIn)
                end})
                menu.AddButton(menu, {label = "Vendre l'appartement pour "..apart.price.."$", type = 'confirm' , select = function()
                    TriggerServerEvent("sellApart", apart)
                    exports.menu:closeMenu()
                end})
            else
                menu.AddButton(menu, {label = "Sonner à l'appartement", select = function()
                    TriggerEvent("notifynui", "info", "SONNETTE", "Vous sonnez à la porte.")
                    local coords = {x = apart.xIn, y = apart.yIn, z = apart.zIn, h = apart.hIn}
                    TriggerServerEvent("sonnetteRequest", apart.characterId, coords)
                    exports.menu:closeMenu()
                end})
            end
        end
        exports.menu:openMenu(menu)
    end    

    while exports.menu:isMenuOpen() do
        Citizen.Wait(5)
        local pos = GetEntityCoords(PlayerPedId())
        local dest = vector3(apart.xOut, apart.yOut, apart.zOut)
        local distance = GetDistanceBetweenCoords(pos, dest, true)
        if distance > 2 then 
            if exports.menu:isMenuOpen(menu) then 
                exports.menu:closeMenu()
                return
            end
        end
    end
end


function openApartMenuIn(apart)
    local menu = exports.menu:CreateMenu({name = "apt", title = apart.name, subtitle = 'Appartement', footer = 'Appuyer sur Entrée.'})
    menu.ClearItems(menu)

    if not exports.menu:isMenuOpen() then
        menu.AddButton(menu, { label = "Sortir à l'entrée.", type = 'action', select = function() 
            exports.menu:closeMenu()
            exports.lib:teleportTo(apart.xOut, apart.yOut, apart.zOut, apart.hOut)  
        end })
        menu.AddButton(menu, { label = "Sortir au garage.", type = 'action', select = function() 
            exports.menu:closeMenu()
            exports.lib:teleportTo(apart.xGarage, apart.yGarage, apart.zGarage, apart.hGarage)  
        end })
        exports.menu:openMenu(menu)     
    end
    
    while exports.menu:isMenuOpen() do
        Citizen.Wait(5)
        local pos = GetEntityCoords(PlayerPedId())
        local dest = vector3(apart.xIn, apart.yIn, apart.zIn)
        local distance = GetDistanceBetweenCoords(pos, dest, true)
        if distance > 2 then 
            if exports.menu:isMenuOpen(menu) then 
                exports.menu:closeMenu()
                return
            end
        end
    end
end



RegisterCommand("setaptin", function(source, args, rawcommand)
    local coords = {}
    local pos = GetEntityCoords(PlayerPedId())
    coords.x = pos.x
    coords.y = pos.y
    coords.z = pos.z-0.98
    coords.h = GetEntityHeading(GetPlayerPed(-1))
    TriggerServerEvent("setApartmentIn", args[1], coords)
end)

RegisterCommand("setaptout", function(source, args, rawcommand)
    local coords = {}
    local pos = GetEntityCoords(PlayerPedId())
    coords.x = pos.x
    coords.y = pos.y
    coords.z = pos.z-0.98
    coords.h = GetEntityHeading(GetPlayerPed(-1))
    TriggerServerEvent("setApartmentOut", args[1], coords)
end)

RegisterCommand("setaptgarage", function(source, args, rawcommand)
    local coords = {}
    local pos = GetEntityCoords(PlayerPedId())
    coords.x = pos.x
    coords.y = pos.y
    coords.z = pos.z-0.98
    coords.h = GetEntityHeading(GetPlayerPed(-1))
    TriggerServerEvent("setApartmentGarage", args[1], coords)
end)

RegisterCommand("setcoffre", function(source, args, rawcommand)
    local coords = {}
    local pos = GetEntityCoords(PlayerPedId())
    coords.x = pos.x
    coords.y = pos.y
    coords.z = pos.z-0.98
    TriggerServerEvent("setApartCoffre", args[1], args[2], coords)
end)


RegisterNetEvent('refreshApartMarkers')
AddEventHandler('refreshApartMarkers', function(v)
    aparts = v
end)

local blips = {}

RegisterNetEvent('refreshApartBlips')
AddEventHandler('refreshApartBlips', function(aparts)
    if blips[1] then
        for i, blip in pairs(blips) do
            RemoveBlip(blip)
        end
        blips = {}
    end
    for i,value in pairs(aparts) do
        if aparts[i].characterId then
            if aparts[i].characterId == characterId then
                local aptBlip = AddBlipForCoord(aparts[i].xOut, aparts[i].yOut, aparts[i].zOut)
                table.insert(blips, aptBlip)
                SetBlipSprite(aptBlip, 40)
                SetBlipAsShortRange(aptBlip, true)
                AddTextEntry('APT', "Mon appartement")
                BeginTextCommandSetBlipName('APT') 
                SetBlipCategory(aptBlip, 11) 
                EndTextCommandSetBlipName(aptBlip)
            end
        else
            local aptBlip = AddBlipForCoord(aparts[i].xOut, aparts[i].yOut, aparts[i].zOut)
            table.insert(blips, aptBlip)
            SetBlipSprite(aptBlip, 375)
            SetBlipAsShortRange(aptBlip, true)
            AddTextEntry('APT', "Appartement à vendre")
            BeginTextCommandSetBlipName('APT') 
            SetBlipCategory(aptBlip, 10) 
            EndTextCommandSetBlipName(aptBlip)
            SetBlipScale(aptBlip, 0.8)
        end
    end
end)


RegisterNetEvent('openApartMenu')
AddEventHandler('openApartMenu', function(apart)
    openMenuAmenupartOut(apart)
end)


Citizen.CreateThread(function()
    while true do
        local interval = 2000
        for i,apart in pairs(aparts) do 
            local pos = GetEntityCoords(PlayerPedId())
            if apart.xOut then
                DrawMarker(27, apart.xOut, apart.yOut, apart.zOut, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 50, 150, 255, 255, 0, 0, 2, 0, nil, nil, 0)
                local dest = vector3(apart.xOut, apart.yOut, apart.zOut)
                local distanceOut = GetDistanceBetweenCoords(pos, dest, true)
                apart.distanceOut = distanceOut
                if apart.distanceOut < 50 then
                    interval = 2
                    if apart.distanceOut < 2 then
                        if not exports.menu:isMenuOpen() then
                            AddTextEntry("APART", "Appuyez sur la touche ~INPUT_CONTEXT~")
                            DisplayHelpTextThisFrame("APART", false)
                            if IsControlJustPressed(1, 51) then
                                Wait(10)
                                TriggerServerEvent("buildApartMenuOut", apart)
                            end
                        end
                    end
                end
            end
            if apart.xIn then
                DrawMarker(27, apart.xIn, apart.yIn, apart.zIn, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 50, 150, 255, 255, 0, 0, 2, 0, nil, nil, 0)
                local dest = vector3(apart.xIn, apart.yIn, apart.zIn)
                local distanceIn = GetDistanceBetweenCoords(pos, dest, true)
                apart.distanceIn = distanceIn
                if apart.distanceIn < 50 then
                    interval = 2
                    if apart.distanceIn < 2 then
                        if not exports.menu:isMenuOpen() then
                            AddTextEntry("APART", "Appuyez sur la touche ~INPUT_CONTEXT~")
                            DisplayHelpTextThisFrame("APART", false)
                            if IsControlJustPressed(1, 51) then
                                Wait(10)
                                openApartMenuIn(apart)
                            end
                        end
                    end
                end
            end
            if apart.xGarage then
                if apart.characterId == characterId then
                    DrawMarker(27, apart.xGarage, apart.yGarage, apart.zGarage, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 50, 150, 255, 255, 0, 0, 2, 0, nil, nil, 0)
                    local dest = vector3(apart.xGarage, apart.yGarage, apart.zGarage)
                    local distanceGarage = GetDistanceBetweenCoords(pos, dest, true)
                    apart.distanceGarage = distanceGarage
                    if apart.distanceGarage < 50 then
                        interval = 2
                        if apart.distanceGarage < 2 then
                            if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                                AddTextEntry("GARAGE", "Appuyez sur la touche ~INPUT_CONTEXT~ ~s~pour ~r~rentrer ~s~le véhicule.")
                                DisplayHelpTextThisFrame("GARAGE", false)
                                if IsControlJustPressed(1, 51) then
                                    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                                    local vehMods = exports.vehicle:getVehicleMods(veh)
                                    TriggerEvent("progressBar", 5)
                                    Citizen.Wait(5000)
                                    TriggerServerEvent("setCarInGarage", vehMods, apart, "apart")
                                end
                            else
                                AddTextEntry("GARAGE", "Appuyez sur la touche ~INPUT_CONTEXT~ ~s~pour ~g~sortir ~s~un véhicule.")
                                DisplayHelpTextThisFrame("GARAGE", false)
                                if IsControlJustPressed(1, 51) then
                                    Wait(10)
                                    TriggerServerEvent("buildApartMenuGarage", apart)
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(interval)
    end
end)



local coffresApart = {}

RegisterNetEvent('refreshApartCoffreMarkers')
AddEventHandler('refreshApartCoffreMarkers', function(v)
    coffresApart = v
end)

Citizen.CreateThread(function()
    while true do
        local interval = 5000
        for i,coffre in pairs(coffresApart) do
            local pos = GetEntityCoords(PlayerPedId())
            DrawMarker(27, coffre.x, coffre.y, coffre.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 255, 170, 0, 255, 0, 0, 2, 0, nil, nil, 0)
            local dest = vector3(coffre.x, coffre.y, coffre.z)
            local distance = GetDistanceBetweenCoords(pos, dest, true)
            coffre.distance = distance
            if coffre.distance < 60 then
                interval = 100
                if coffre.distance < 20 then
                    interval = 0
                    if coffre.distance < 2 then
                        if not exports.menu:isMenuOpen() then
                            AddTextEntry("APARTCOFFRE", "Appuyez sur la touche ~INPUT_CONTEXT~")
                            DisplayHelpTextThisFrame("APARTCOFFRE", false)
                            if IsControlJustPressed(1, 51) then
                                Wait(10)
                                TriggerEvent("openCoffre", coffre.id, "apart")
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(interval)
    end
end)











-- ********** SONNETTE *****************************************

RegisterNetEvent('sonnetteRequest')
AddEventHandler('sonnetteRequest', function(from, coords)
    Citizen.CreateThread(function()
        TriggerEvent("playsound", "doorbell")
        TriggerEvent("notifynui", "info", "SONNETTE", "Quelqu'un sonne à votre porte. Appuyer sur Y pour accepter et N pour refuser.")
        local wait = 1
        Citizen.SetTimeout(7000, function()
            wait = 0
        end)
        while (wait == 1) do 
            Citizen.Wait(10)
            if IsControlJustPressed(1, 246) then
                TriggerEvent("notifynui", "success", "SONNETTE", "Vous avez accepté la demande.")
                TriggerServerEvent("sonnetteOpen", from, coords)
                break
            elseif IsControlJustPressed(1, 249) then
                TriggerEvent("notifynui", "error", "SONNETTE", "Vous avez refusé la demande.")
                break
            end
        end
    end)
end)

RegisterNetEvent('sonnetteOpen')
AddEventHandler('sonnetteOpen', function(coords)
    TriggerEvent("notifynui", "success", "SONNETTE", "Quelqu'un vous ouvre.")
    local ped = GetPlayerPed(-1)
    if (DoesEntityExist(ped) and not IsEntityDead(ped) and not (false and false)) then 
        exports.lib:teleportTo(coords.x, coords.y, coords.z, coords.h)
    end
end)
