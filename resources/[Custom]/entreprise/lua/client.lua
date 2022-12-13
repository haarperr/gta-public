local character

local crateLocations = {
    {x = -1859.82, y = -68.13, z = 110.04},
    {x = -1269.95, y = -249.13, z = 60.65},
    {x = -1099.51, y = -10.21, z = 50.7},
    {x = -1179.23, y = -495.13, z = 35.57},
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
    {x = -900.0, y = 6046.0, z = 43.57},
    {x = -1178.3, y = 4925.9, z = 223.37},
    {x = -3000.3, y = 3343.9, z = 10.39},
    {x = -1891.3, y = 2088.9, z = 141.0},
    {x = -1546.7, y = 846.9, z = 182.09},
}
local numberLocations = 22

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' is starting on the client.')
    Wait(500)
    while character == nil do 
        TriggerServerEvent("getCharacter")
        Wait(1000)
    end
    print('The resource ' .. resourceName .. ' has been started on the client.')
end)


RegisterNetEvent('getCharacterCallback')
AddEventHandler('getCharacterCallback', function(c)
    character = c
    TriggerServerEvent("getEntreprise")
    if c.organisationId then
        if c.organisationId == 5 then
            startFamilies()
        elseif c.organisationId == 8 then
            startKkangpae()
        end
    end
    if c.organisationId then 
        SendNUIMessage({
            action = "refresh",
            cid = c.id,
            organisationId = c.organisationId
        })
    end
end)





local coffresEntreprise = {}
local garagesEntreprise = {}

RegisterNetEvent('getEntrepriseCallback')
AddEventHandler('getEntrepriseCallback', function(c, g)
    coffresEntreprise = c
    garagesEntreprise = g
end)

function getCharacter()
    return character
end


Citizen.CreateThread(function()
    while true do
        local interval = 5000
        local c = getCharacter()
        if c then 
            if c.organisationId == 1 then 
                interval = 0
                if GetPlayerWantedLevel(PlayerId()) ~= 0 then
                    SetPlayerWantedLevel(PlayerId(), 0, false)
                    SetPlayerWantedLevelNow(PlayerId(), false)
                end
            end
        end
        Citizen.Wait(interval)
    end
end)


-- AFFICHAGE DES COFFRES
Citizen.CreateThread(function()
    while true do
        local interval = 5000
        if coffresEntreprise then 
            for i,coffre in pairs(coffresEntreprise) do
                local pos = GetEntityCoords(PlayerPedId())
                DrawMarker(27, coffre.x, coffre.y, coffre.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 255, 170, 0, 255, 0, 0, 2, 0, nil, nil, 0)
                local dest = vector3(coffre.x, coffre.y, coffre.z)
                local distanceOut = GetDistanceBetweenCoords(pos, dest, true)
                coffre.distanceOut = distanceOut
                if coffre.distanceOut < 20 then
                    interval = 0
                    if coffre.distanceOut < 2 then
                        if not exports.menu:isMenuOpen() then
                            AddTextEntry("ENTRECOFFRE", "Appuyez sur la touche ~INPUT_CONTEXT~")
                            DisplayHelpTextThisFrame("ENTRECOFFRE", false)
                            if IsControlJustPressed(1, 51) then
                                Wait(10)
                                TriggerEvent("openCoffre", coffre.id, "coffre")
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(interval)
    end
end)


-- AFFICHAGE DES GARAGES
Citizen.CreateThread(function()
    while true do
        local interval = 3000
        if garagesEntreprise then 
            for i,garage in pairs(garagesEntreprise) do
                local pos = GetEntityCoords(PlayerPedId())
                local dest = vector3(garage.x, garage.y, garage.z)
                local distance = GetDistanceBetweenCoords(pos, dest, true)
                garage.distance = distance
                if garage.distance < 60 then
                    interval = 0
                    if garage.distance < 20 then
                        interval = 0
                        DrawMarker(1, garage.x, garage.y, garage.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.8, 1.8, 0.6, 0, 140, 255, 180, 0, 0, 2, 0, nil, nil, 0)
                    end
                    if garage.distance < 2 then
                        if not exports.menu:isMenuOpen() then
                            if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                                if GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
                                    AddTextEntry("ENTREGARAGE", "Appuyez sur la touche ~INPUT_CONTEXT~ ~s~pour ~r~rentrer ~s~le véhicule.")
                                    DisplayHelpTextThisFrame("ENTREGARAGE", false)
                                    if IsControlJustPressed(1, 51) then
                                        local resVeh = exports.vehicle:getVehicleMods(veh)
                                        TriggerEvent("progressBar", 5)
                                        Citizen.Wait(5000)
                                        local pos = GetEntityCoords(PlayerPedId())
                                        local distance = GetDistanceBetweenCoords(pos, dest, true)
                                        if distance < 2 then 
                                            TriggerServerEvent("setCarInGarage", resVeh, garage)
                                        else
                                            TriggerEvent("notify", "Vous êtes trop loin du garage.")
                                        end
                                    end
                                end
                            else
                                AddTextEntry("ENTREGARAGE", "Appuyez sur la touche ~INPUT_CONTEXT~ ~s~pour ~g~sortir ~s~un véhicule.")
                                DisplayHelpTextThisFrame("ENTREGARAGE", false)
                                if IsControlJustPressed(1, 51) then
                                    TriggerServerEvent("getCarInGarage", garage)
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






-- ********** DISABLE SPAWN VEHICLE *********************************
Citizen.CreateThread(function()
    local coords = {x = 449.4, y = -981.28, z = 42.73}
    while true do
        Wait(1)
        RemoveVehiclesFromGeneratorsInArea(coords.x-10, coords.y-10, coords.z-10, coords.x+10, coords.y+10, coords.z+10)
    end
end)












-- EMS *************************************************************************************************************

local emsAscenseur = {
    {name = "Accueil", x = 339.5, y = -592.2, z = 42.3, h = 62.7},
    {name = "Garage", x = 319.5, y = -559.5, z = 27.78, h = 17.7},
    {name = "Accès inférieur", x = 359.9, y = -585.1, z = 27.85, h = 239.4},
}

Citizen.CreateThread(function()
    Wait(2000)
    menu = exports.menu:CreateMenu({name = "ems", title = "Ascenseur", subtitle = 'EMS', footer = 'Appuyer sur Entrée.'})
end)

Citizen.CreateThread(function()
    Wait(3000)
    for i,v in pairs(emsAscenseur) do 
        menu.AddButton(menu, {label = v.name, select = function()
            exports.menu:closeMenu()
            exports.lib:teleportTo(v.x, v.y, v.z, v.h)
        end})
    end
end)

-- EMS 
Citizen.CreateThread(function()
    Wait(3000)
    while true do 
        local interval = 5000
        for i,v in pairs(emsAscenseur) do 
            local pos = GetEntityCoords(PlayerPedId())
            local dest = vector3(v.x, v.y, v.z)
            local distanceOut = GetDistanceBetweenCoords(pos, dest, true)
            v.distanceOut = distanceOut
            if v.distanceOut < 30 then
                interval = 0
                DrawMarker(27, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 0, 140, 255, 180, 0, 0, 2, 0, nil, nil, 0)
                if v.distanceOut < 2 then
                    if not exports.menu:isMenuOpen() then
                        AddTextEntry("EMSASC", "Appuyez sur la touche ~INPUT_CONTEXT~")
                        DisplayHelpTextThisFrame("EMSASC", false)
                        if IsControlJustPressed(1, 51) then
                            exports.menu:openMenu(menu)
                            Citizen.Wait(10)
                        end
                    end
                end
            end
        end
        Citizen.Wait(interval)
    end
end)





























-- VERTS ***************************************************************************************************

local transfo

-- PNG
Citizen.CreateThread(function()
    local modelHash = GetHashKey("mp_m_famdd_01")
    local coords = {x = -195.42, y = -1582.92, z = 33.77, h = 246.69}
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
       	Wait(1)
    end
	local created_ped = CreatePed(5, modelHash, coords.x, coords.y, coords.z, coords.h, false, true)
	FreezeEntityPosition(created_ped, true)
	SetEntityInvincible(created_ped, true)
	SetBlockingOfNonTemporaryEvents(created_ped, true)
	TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_DRINKING", 0, true)
end)
Citizen.CreateThread(function()
    local coords = {x = -195.42, y = -1582.92, z = 33.77, h = 246.69}
    while true do
        Wait(1)
        RemoveVehiclesFromGeneratorsInArea(coords.x-10, coords.y-10, coords.z-10, coords.x+10, coords.y+10, coords.z+10)
    end
end)


function startFamilies()
    local coords = {x = -195.42, y = -1582.92, z = 33.77, h = 246.69}
    Citizen.CreateThread(function()
        while character.organisationId == 5 do 
            local interval = 20
            local pos = GetEntityCoords(PlayerPedId())
            local dest = vector3(coords.x, coords.y, coords.z)
            local distance = GetDistanceBetweenCoords(pos, dest, true)

            if distance > 50 then
                interval = 500
            else
                interval = 1
                --DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 0, 0, 0, 100, 0, 0, 2, 0, nil, nil, 0)
                if distance < 2 then 
                    if not isOpen then
                        AddTextEntry("PNJCRIMI", "Parler à Darell ~INPUT_CONTEXT~")
                        DisplayHelpTextThisFrame("PNJCRIMI", false)
                        if IsControlJustPressed(1, 51) then
                            openMenu()
                        end
                    end
                elseif distance > 3 then
                    closeMenu()
                end
            end
            Citizen.Wait(interval)
        end
    end)
end



-- RegisterNetEvent('requestTransfo')
-- AddEventHandler('requestTransfo', function(q)
--     local quantity = (q/5)
--     Citizen.CreateThread(function()
--         transfo = true
--         if isOpen then 
--             closeMenu()
--         end
--         startTransfoListener()
--         for i = 0, (quantity-1) do
--             if transfo then 
--                 Citizen.Wait(200)
--                 TriggerEvent("progressBar", 10)
--                 Citizen.Wait(10000)
--                 if transfo then 
--                     TriggerServerEvent("updateTransfo", 20, 21, 10, 2)
--                 else 
--                     return
--                 end
--             else 
--                 return
--             end
--             if i == (quantity-1) then 
--                 Citizen.Wait(200)
--                 TriggerEvent("notifynui", "info", "Crimi", "Tu n'as plus rien à transformer.")
--             end
--         end
--         transfo = false
--     end)
-- end)

-- function startTransfoListener()
--     local coords = {x = -195.42, y = -1582.92, z = 33.77, h = 246.69}
--     Citizen.CreateThread(function()
--         while transfo do
--             local ped = GetPlayerPed(-1)
--             local pos = GetEntityCoords(ped)
--             local dest = vector3(coords.x, coords.y, coords.z)
--             local distance = GetDistanceBetweenCoords(pos, dest, true)
--             if IsPedRagdoll(ped) or not DoesEntityExist(ped) or IsEntityDead(ped) or IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) or distance > 4 then 
--                 TriggerEvent("stopProgressBar")
--                 transfo = false
--             end
--             Citizen.Wait(0)
--         end
--     end)
-- end

function champCannabisGPS()
    TriggerEvent("notifynui", "info", "Crimi", "Position définie sur le GPS.")
    SetNewWaypoint(1907.6, 4837.1)
end

function entrepotGPS()
    TriggerEvent("notifynui", "info", "Crimi", "Position définie sur le GPS.")
    SetNewWaypoint(1219.5, -3204.7)
end



-- KKANGPAE ***************************************************************************************************


-- PNG
Citizen.CreateThread(function()
    local modelHash = GetHashKey("csb_hao")
    local coords = {x = -674.66, y = -880.96, z = 23.46, h = 72.7}
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
       	Wait(1)
    end
	local created_ped = CreatePed(5, modelHash, coords.x, coords.y, coords.z, coords.h, false, true)
	FreezeEntityPosition(created_ped, true)
	SetEntityInvincible(created_ped, true)
	SetBlockingOfNonTemporaryEvents(created_ped, true)
	TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_DRINKING", 0, true)
end)
Citizen.CreateThread(function()
    local coords = {x = -674.66, y = -880.96, z = 23.46, h = 72.7}
    while true do
        Wait(1)
        RemoveVehiclesFromGeneratorsInArea(coords.x-10, coords.y-10, coords.z-10, coords.x+10, coords.y+10, coords.z+10)
    end
end)


function startKkangpae()
    local coords = {x = -674.66, y = -880.96, z = 23.46, h = 72.7}
    Citizen.CreateThread(function()
        while character.organisationId == 8 do 
            local interval = 20
            local pos = GetEntityCoords(PlayerPedId())
            local dest = vector3(coords.x, coords.y, coords.z)
            local distance = GetDistanceBetweenCoords(pos, dest, true)

            if distance > 50 then
                interval = 500
            else
                interval = 1
                --DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 0, 0, 0, 100, 0, 0, 2, 0, nil, nil, 0)
                if distance < 2 then 
                    if not isOpen then
                        AddTextEntry("PNJCRIMI", "Parler à Hao ~INPUT_CONTEXT~")
                        DisplayHelpTextThisFrame("PNJCRIMI", false)
                        if IsControlJustPressed(1, 51) then
                            openMenu()
                        end
                    end
                elseif distance > 3 then
                    closeMenu()
                end
            end
            Citizen.Wait(interval)
        end
    end)
end







Citizen.CreateThread(function()
    local coords = {x = 862.1, y = 2173.4, z = 51.3} 
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 477)
    AddTextEntry('FERME', "Ferme agricole")
    BeginTextCommandSetBlipName('FERME') 
    SetBlipCategory(blip, 1)
    SetBlipColour(blip, 21)
    EndTextCommandSetBlipName(blip)
    SetBlipAsShortRange(blip, true)
    while true do
        local interval = 1000
        local pos = GetEntityCoords(PlayerPedId())
        DrawMarker(27, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 255, 255, 255, 255, 0, 0, 2, 0, nil, nil, 0)
        local dest = vector3(coords.x, coords.y, coords.z)
        local distance = GetDistanceBetweenCoords(pos, dest, true)
        if distance < 20 then
            interval = 10
            if distance < 10 then 
                interval = 2
            end
            if distance < 2 then
                AddTextEntry("FERME", "Magasin de la ferme ~INPUT_CONTEXT~")
                DisplayHelpTextThisFrame("FERME", false)
                if IsControlJustPressed(1, 51) then
                    if IsControlJustPressed(1, 51) then
                        TriggerEvent("menuShop", 5)
                    end
                end
            end
        end
        Citizen.Wait(interval)
    end
end)







































































local isOpen = false

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    isOpen = false
    cb({})
end)

RegisterNUICallback('hideFrame', function(_, cb)
    toggleNuiFrame(false)
    debugPrint('Hide NUI frame')
    cb({})
end)

RegisterNUICallback('triggerEvent', function(event, cb)
    TriggerEvent(event.name, event.data)
    cb({})
end)

RegisterNUICallback('triggerServerEvent', function(event, cb)
    TriggerServerEvent(event.name, event.data, event.data2)
    cb({})
end)

RegisterNUICallback('triggerFunction', function(fc, cb)
    _G[fc.name](fc.data)
    cb({})
end)

function SendReactMessage(action, data)
    SendNUIMessage({
      action = action,
      data = data
    })
end

function toggleNuiFrame(shouldShow)
    SetNuiFocus(shouldShow, shouldShow)
    SetNuiFocusKeepInput(false)
    isOpen = shouldShow
    SendReactMessage('setVisible', shouldShow)
end

function openMenu()
    toggleNuiFrame(true)
    isOpen = true
end

function closeMenu()
    toggleNuiFrame(false)
    isOpen = false
end





local animation = false
local breakAnimation = false
-- *** CHAMP DE FER **********************************************************
Citizen.CreateThread(function()
    local coords = {x = 2949.3, y = 2769.4, z = 37.9} 
    while true do 
        local interval = 2000
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local dest = vector3(coords.x, coords.y, coords.z)
        local distance = GetDistanceBetweenCoords(pos, dest, true)

        if distance > 50 then
            interval = 2000
        else
            interval = 0
            DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 8.0, 8.0, 1.9, 0, 255, 80, 60, 0, 0, 2, 0, nil, nil, 0)
            if distance < 6 and not IsPedInAnyVehicle(ped) and DoesEntityExist(ped) and not IsEntityDead(ped) and not IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) then 
                if not animation and not breakAnimation then 
                    AddTextEntry("CHAMPFER", "Appuyez sur la touche ~INPUT_CONTEXT~")
                    DisplayHelpTextThisFrame("CHAMPFER", false)
                    if IsControlJustPressed(1, 51) then
                        Wait(100)
                        startRecolteFer()
                    end
                elseif animation and not breakAnimation then 
                    AddTextEntry("CHAMPFER", "Appuyez sur la touche ~INPUT_FRONTEND_RRIGHT~ pour arrêter la récolte.")
                    DisplayHelpTextThisFrame("CHAMPFER", false)
                    if IsControlJustPressed(1, 194) then
                        animation = false
                        breakAnimation = true
                        ClearPedTasks(ped)
                        TriggerEvent("stopProgressBar")
                        ClearAreaOfObjects(GetEntityCoords(PlayerPedId()), 1.0, 0)
                    end
                elseif not animation and breakAnimation then 
                    AddTextEntry("CHAMPFER", "Attendez quelques secondes..")
                    DisplayHelpTextThisFrame("CHAMPFER", false)
                end
            end
        end
        Citizen.Wait(interval)
    end
end)



function startRecolteFer()
    Citizen.CreateThread(function()
        animation = true
        local ped = GetPlayerPed(-1)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CONST_DRILL", 0, true);
        TriggerEvent("progressBar", 30)
        startRecolteListener()
        Wait(30000)
        if animation and not breakAnimation then 
            ClearPedTasks(ped)
            TriggerServerEvent("updateInventory", 23, 10)
            TriggerEvent("notifynui", "info", "Crimi", "Vous ramassez 10 minerais de fer.")
            animation = false
            breakAnimation = false
            ClearAreaOfObjects(GetEntityCoords(PlayerPedId()), 1.0, 0)
        end
        breakAnimation = false
    end)
end


function startRecolteListener()
    Citizen.CreateThread(function()
        while animation do
            local ped = GetPlayerPed(-1)
            if IsPedRagdoll(ped) or not DoesEntityExist(ped) or IsEntityDead(ped) or IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) then 
                animation = false
                breakAnimation = true
                ClearPedTasksImmediately(ped)
                TriggerEvent("stopProgressBar")
                ClearAreaOfObjects(GetEntityCoords(PlayerPedId()), 1.0, 0)
            end
            Citizen.Wait(0)
        end
    end)
end




























-- ************************* BLANCHISSERIE ******************************************************************

local blanchisseries

RegisterNetEvent("event:getBlanchisseriesCallBack")
AddEventHandler("event:getBlanchisseriesCallBack", function(v)
	blanchisseries = v
end)


Citizen.CreateThread(function()
	Wait(2000)
	TriggerServerEvent("event:getBlanchisseries")
    menu = exports.menu:CreateMenu({name = "blanchisserie", title = 'Blanchisserie', subtitle = 'La malette gangz.', footer = 'Appuyez sur Entrée'})
	while true do
		local interval = 1000
		if blanchisseries then
			for i,blanchisserie in pairs(blanchisseries) do 
				local pos = GetEntityCoords(PlayerPedId())
				DrawMarker(27, blanchisserie.x, blanchisserie.y, blanchisserie.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 255, 255, 255, 255, 0, 0, 2, 0, nil, nil, 0)
				local dest = vector3(blanchisserie.x, blanchisserie.y, blanchisserie.z)
				local distance = GetDistanceBetweenCoords(pos, dest, true)

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
                                        TriggerServerEvent("event:getBlanchisserieMenu", blanchisserie.id)
									end
								end
							end
						end
					else
						if exports.menu:isMenuOpen(menu) then 
							exports.menu:closeMenu()
						end
					end
				end
			end
		end
		Citizen.Wait(interval)
	end
end)


RegisterNetEvent("event:getBlanchisserieMenuCallBack")
AddEventHandler("event:getBlanchisserieMenuCallBack", function(blanchisserie)
    menu.ClearItems(menu)
    menu.AddButton(menu, {label = "Déposez de l'argent sale", select = function()
        TriggerServerEvent("event:checkBlanchisserieDepot", blanchisserie.id)
        exports.menu:closeMenu()
    end})
    menu.AddButton(menu, {label = "Retirer de l'argent propre", select = function()
        TriggerServerEvent("event:checkBlanchisserieRetrait", blanchisserie.id)
        exports.menu:closeMenu()
    end})
    menu.AddButton(menu, {label = "Argent sale : "..blanchisserie.dirty.."$", select = function()
    end})
    menu.AddButton(menu, {label = "Argent propre : "..blanchisserie.cash.."$", select = function()
    end})
    exports.menu:openMenu(menu)
end)




RegisterNetEvent("event:checkBlanchisserieDepotCallBack")
AddEventHandler("event:checkBlanchisserieDepotCallBack", function(current, max, id)
	AddTextEntry('FMMC_KEY_TIP1', "Quantité à déposer. Actuellement "..current.."$, maximum "..max.."$")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", 0, "", "", "", 7)
	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0);
		Wait(0);
	end
	if (GetOnscreenKeyboardResult()) then
		local result = tonumber(GetOnscreenKeyboardResult())
		if result and result > 0 then 
			if (current + result) > max then 
				TriggerEvent("notifynui", "error", "Blanchisserie", "La quantité saisie dépasse le maximum.")
			else
        		TriggerServerEvent("event:blanchisserieDepot", id, result)
			end
		else
			TriggerEvent("notifynui", "error", "Blanchisserie", "La quantité saisie est invalide.")
		end
	end
end)

RegisterNetEvent("event:checkBlanchisserieRetraitCallBack")
AddEventHandler("event:checkBlanchisserieRetraitCallBack", function(current, id)
	AddTextEntry('FMMC_KEY_TIP1', "Quantité à récupérer. Actuellement "..current.."$ d'argent propre.")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", 0, "", "", "", 8)
	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0);
		Wait(0);
	end
	if (GetOnscreenKeyboardResult()) then
		local result = tonumber(GetOnscreenKeyboardResult())
		if result and result > 0 then 
			TriggerServerEvent("event:blanchisserieRetrait", id, result)
		else
			TriggerEvent("notifynui", "error", "Blanchisserie", "La quantité saisie est invalide.")
		end
	end
end)
























RegisterNetEvent("recelSellItem")
AddEventHandler("recelSellItem", function(data)
    TriggerServerEvent("updateInventoryWithCallback", "recelSellItemConfirm", data.dirty, data.item, -data.quantity)
end)

RegisterNetEvent("recelSellItemConfirm")
AddEventHandler("recelSellItemConfirm", function(dirty)
    TriggerServerEvent("updateInventory", 43, dirty)
    TriggerEvent("notifynui", "success", "Recel", "Tu as récupéré "..dirty.."$ d'argent sale.")
end)
