local superettes = {}
local superettesBlips = {}
local ammunations = {}
local ammunationsBlips = {}
local pharmacies = {}
local pharmaciesBlips = {}

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' is starting on the client.')
    TriggerServerEvent("getSuperettes")
    TriggerServerEvent("getAmmunations")
    TriggerServerEvent("getPharmacies")
    print('The resource ' .. resourceName .. ' has been started on the client.')
    Wait(2000)
    menu = exports.menu:CreateMenu({name = "sup", title = 'Ginette', subtitle = 'Gentille petite dame.', footer = 'Appuyez sur Entrée'})
end)


function setSuperettesMarkers()
    Citizen.CreateThread(function()
        while true do
            local interval = 1000
            for i,sup in pairs(superettes) do 
                local pos = GetEntityCoords(PlayerPedId())
                DrawMarker(27, sup.x, sup.y, sup.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 255, 255, 255, 255, 0, 0, 2, 0, nil, nil, 0)
                local dest = vector3(sup.x, sup.y, sup.z)
                local distance = GetDistanceBetweenCoords(pos, dest, true)
                -- sup.distance = distance
    
                if distance < 20 then
                    interval = 10
                    if distance < 10 then 
                        interval = 2
                    end
                    if distance < 2 then
                        if not exports.menu:isMenuOpen() then
                            AddTextEntry("SUP", "Appuyez sur la touche ~INPUT_CONTEXT~")
                            DisplayHelpTextThisFrame("SUP", false)
                            if IsControlJustPressed(1, 51) and not IsPedInAnyVehicle(GetPlayerPed(-1)) and DoesEntityExist(GetPlayerPed(-1)) and not IsEntityDead(GetPlayerPed(-1)) and not IsEntityPlayingAnim(GetPlayerPed(-1), "mp_arresting", "idle", 3) then
                                if not exports.menu:isMenuOpen() then
                                    if IsControlJustPressed(1, 51) then
                                            -- TriggerEvent("menuShop", 1)
                                        menu.ClearItems(menu)
                                        menu.AddButton(menu, {label = "Faire des achats", select = function()
                                            exports.menu:closeMenu()
                                            TriggerEvent("menuShop", 1)
                                        end})
                                        menu.AddButton(menu, {label = "Braquer la suppérette", select = function()
                                            exports.menu:closeMenu()
                                            tryBraquage(sup)
                                        end})
                                        exports.menu:openMenu(menu)
                                    end
                                end
                            end
                        end
                    else
                        if exports.menu:isMenuOpen(menu) then 
                            exports.menu:closeMenu()
                        end
                        -- local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
                        -- if aiming then
                        --     if targetPed == sup.ped then
                        --         tryBraquage(sup)
                        --     end
                        -- end
                    end
                end
            end
            Citizen.Wait(interval)
        end
    end)
end

function spawnGinettes()
    Citizen.CreateThread(function()
        modelHash = GetHashKey("a_f_m_fatbla_01")
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(1)
        end
        for i,sup in pairs(superettes) do 
            ped = CreatePed(5, modelHash , sup.xPNJ, sup.yPNJ, sup.zPNJ, sup.hPNJ, false, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            superettes[i].ped = ped
        end
    end)
end

function setSuperettesBlips()
    Citizen.CreateThread(function()
        for i,sup in pairs(superettes) do 
            local blip = AddBlipForCoord(sup.x, sup.y, sup.z)
            SetBlipSprite(blip, 59)
            AddTextEntry('SUPP', "Commerce")
            BeginTextCommandSetBlipName('SUPP') 
            SetBlipCategory(blip, 1) 
            EndTextCommandSetBlipName(blip)
            SetBlipAsShortRange(blip, true)
            SetBlipScale(blip, 0.9)
        end
    end)
end

RegisterNetEvent("getSuperettesCallback")
AddEventHandler("getSuperettesCallback", function(sup)
    superettes = sup
    -- spawnGinettes()
    setSuperettesBlips()
    setSuperettesMarkers()
end)

-- RegisterCommand("addsup", function(source, args, rawcommand)
--     local coords = {}
--     local pos = GetEntityCoords(PlayerPedId())
--     coords.x = pos.x
--     coords.y = pos.y
--     coords.z = pos.z-0.98
--     TriggerServerEvent("addsup", args[1], coords)
-- end)

-- RegisterCommand("addsuppnj", function(source, args, rawcommand)
--     local coords = {}
--     local pos = GetEntityCoords(PlayerPedId())
--     coords.x = pos.x
--     coords.y = pos.y
--     coords.z = pos.z-0.98
--     coords.h = GetEntityHeading(GetPlayerPed(-1))
--     TriggerServerEvent("addsuppnj", args[1], coords)
-- end)

function tryBraquage(sup)
    local dest = vector3(sup.x, sup.y, sup.z)
    if IsPedArmed(PlayerPedId(),4) then 
        TriggerServerEvent("tryBraquage", sup)
    else 
        TriggerEvent("notifynui", "error", "Crimi", "Tu ne me fais pas peur.")
    end
end


function braquage(sup)
    TriggerEvent("notifynui", "info", "Crimi", "Début du braquage.")
    Citizen.CreateThread(function()
        TriggerEvent("sendPoliceMsg", "Une alarme silencieuse a sonné ici.")
        Wait(20000)
        math.randomseed(GetGameTimer())
        local luck = math.random(1,3)
        if luck > 1 then 
            SetPlayerWantedLevel(PlayerId(),luck,true)
            SetPlayerWantedLevelNow(PlayerId(),true)
        end
    end)
    math.randomseed(GetGameTimer())
    local sacs = math.random(10,40)
    TriggerEvent("progressBar", (5*sacs))
    local dest = vector3(sup.x, sup.y, sup.z)
    for i=1,sacs do
        Citizen.Wait(5000)
        local pos = GetEntityCoords(PlayerPedId())
        local distance = GetDistanceBetweenCoords(pos, dest, true)
        if distance < 5 then 
            if IsPlayerDead(PlayerId()) == false then
                TriggerEvent("notifynui", "info", "Crimi", "Vous avez récupéré un sac d'argent.")
                TriggerServerEvent("updateInventory", 4, 1)
                -- TriggerServerEvent("getPetitSac")
            else 
                TriggerEvent("stopProgressBar")
                break 
            end
        else 
            TriggerEvent("stopProgressBar")
            TriggerEvent("notifynui", "error", "Crimi", "Et que j'te revoie plus p'tit enculé !")
            break
        end
    end
    Wait(100)
    TriggerEvent("notifynui", "info", "Crimi", 'Fin du braquage')
end


RegisterNetEvent("tryBraquageCallback")
AddEventHandler("tryBraquageCallback", function(sup)
    braquage(sup)
end)










function setAmmunationsMarkers()
    Citizen.CreateThread(function()
        while true do
            local interval = 1000
            for i,ammu in pairs(ammunations) do 
                local pos = GetEntityCoords(PlayerPedId())
                DrawMarker(27, ammu.x, ammu.y, ammu.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 255, 255, 255, 255, 0, 0, 2, 0, nil, nil, 0)
                local dest = vector3(ammu.x, ammu.y, ammu.z)
                local distance = GetDistanceBetweenCoords(pos, dest, true)
                -- ammu.distance = distance
    
                if distance < 20 then
                    interval = 10
                    if distance < 10 then 
                        interval = 2
                    end
                    if distance < 2 then
                        AddTextEntry("AMMU", "Appuyez sur la touche ~INPUT_CONTEXT~")
                        DisplayHelpTextThisFrame("AMMU", false)
                        if IsControlJustPressed(1, 51) then
                            if IsControlJustPressed(1, 51) then
                                TriggerEvent("menuShop", 2)
                            end
                        end
                    end
                end
            end
            Citizen.Wait(interval)
        end
    end)
end

function spawnAmmuPNJs()
    Citizen.CreateThread(function()
        modelHash = GetHashKey("cs_russiandrunk")
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(1)
        end
        for i,ammu in pairs(ammunations) do 
            ped = CreatePed(5, modelHash , ammu.xPNJ, ammu.yPNJ, ammu.zPNJ, ammu.hPNJ, false, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            ammunations[i].ped = ped
        end
    end)
end

function setAmmunationsBlips()
    Citizen.CreateThread(function()
        for i,ammu in pairs(ammunations) do 
            local blip = AddBlipForCoord(ammu.x, ammu.y, ammu.z)
            SetBlipSprite(blip, 110)
            AddTextEntry('AMMU', "Ammunation")
            BeginTextCommandSetBlipName('AMMU') 
            SetBlipCategory(blip, 1) 
            EndTextCommandSetBlipName(blip)
            SetBlipAsShortRange(blip, true)
        end
    end)
end

RegisterNetEvent("getAmmunationsCallback")
AddEventHandler("getAmmunationsCallback", function(ammu)
    ammunations = ammu
    -- spawnAmmuPNJs()
    setAmmunationsBlips()
    setAmmunationsMarkers()
end)




























function setPharmaciesMarkers()
    Citizen.CreateThread(function()
        while true do
            local interval = 1000
            for i,pharma in pairs(pharmacies) do 
                local pos = GetEntityCoords(PlayerPedId())
                DrawMarker(27, pharma.x, pharma.y, pharma.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 255, 255, 255, 255, 0, 0, 2, 0, nil, nil, 0)
                local dest = vector3(pharma.x, pharma.y, pharma.z)
                local distance = GetDistanceBetweenCoords(pos, dest, true)
                -- pharma.distance = distance
    
                if distance < 20 then
                    interval = 10
                    if distance < 10 then 
                        interval = 2
                    end
                    if distance < 2 then
                        AddTextEntry("PHARMA", "Appuyez sur la touche ~INPUT_CONTEXT~")
                        DisplayHelpTextThisFrame("PHARMA", false)
                        if IsControlJustPressed(1, 51) then
                            if IsControlJustPressed(1, 51) then
                                TriggerEvent("menuShop", 3)
                            end
                        end
                    end
                end
            end
            Citizen.Wait(interval)
        end
    end)
end

function setPharmaciesBlips()
    Citizen.CreateThread(function()
        for i,pharma in pairs(pharmacies) do 
            local blip = AddBlipForCoord(pharma.x, pharma.y, pharma.z)
            SetBlipSprite(blip, 153)
            AddTextEntry('PHARMA', "Pharmacie")
            BeginTextCommandSetBlipName('PHARMA') 
            SetBlipCategory(blip, 1)
            SetBlipColour(blip, 2)
            EndTextCommandSetBlipName(blip)
            SetBlipAsShortRange(blip, true)
        end
    end)
end

RegisterNetEvent("getPharmaciesCallback")
AddEventHandler("getPharmaciesCallback", function(pharma)
    pharmacies = pharma
    setPharmaciesBlips()
    setPharmaciesMarkers()
end)