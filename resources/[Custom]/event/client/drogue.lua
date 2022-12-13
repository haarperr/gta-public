local animation = false
local breakAnimation = false
local goFast 
local livraison
local livraisonBlip
local champs


AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
    TriggerServerEvent("getChamps")
end)


RegisterNetEvent('getChampsCallback')
AddEventHandler('getChampsCallback', function(c)
    champs = c
end)

local refresh
local menu

-- *** CHAMP DE CANNABIS **********************************************************
Citizen.CreateThread(function()
    while not champs do 
        Wait(100)
    end
    refresh = false
    refresh = true
    for i,champ in pairs(champs) do 
        Citizen.CreateThread(function()
            while refresh do 
                local interval = 2000
                local ped = GetPlayerPed(-1)
                local pos = GetEntityCoords(ped)
                local dest = vector3(champ.x, champ.y, champ.z)
                local distance = GetDistanceBetweenCoords(pos, dest, true)
    
                if distance > 50 then
                    interval = 2000
                else
                    interval = 0
                    DrawMarker(1, champ.x, champ.y, champ.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 8.0, 8.0, 1.9, 0, 255, 80, 60, 0, 0, 2, 0, nil, nil, 0)
                    if distance < 6 and not IsPedInAnyVehicle(ped) and DoesEntityExist(ped) and not IsEntityDead(ped) and not IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) then 
                        AddTextEntry("CHAMP01", "Appuyez sur la touche ~INPUT_CONTEXT~")
                        DisplayHelpTextThisFrame("CHAMP01", false)
                        if IsControlJustPressed(1, 51) then
                            TriggerServerEvent("getChampMenu", champ.id)
                        end
                    end
                end
                Citizen.Wait(interval)
            end
        end)
    end
end)

function dialogChamp(id, typed, itemId, current, max)
    AddTextEntry('FMMC_KEY_TIP1', "Entrer une quantité. Actuellement "..current.."/"..max.."")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", 0, "", "", "", 7)
	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0);
		Wait(0);
	end
	if (GetOnscreenKeyboardResult()) then
		local result = tonumber(GetOnscreenKeyboardResult())
		if result and result > 0 then 
			if (current + result) > max then 
				TriggerEvent("notifynui", "error", "Champ", "La quantité saisie dépasse le maximum.")
			else
                if typed == "raw" then 

        		    TriggerServerEvent("champRetrait", id, result)
                else
        		    TriggerServerEvent("champDepot", id, itemId, result, typed)
                end
            end
		else
			TriggerEvent("notifynui", "error", "Champ", "La quantité saisie est invalide.")
		end
	end
end

RegisterNetEvent("getChampMenuCallback")
AddEventHandler("getChampMenuCallback", function(champ)
    menu = exports.menu:CreateMenu({name = "champs", title = 'Champ de '..champ.type, subtitle = 'Gestion du champ', footer = 'Appuyez sur Entrée'})
    menu.ClearItems(menu)
    menu.AddButton(menu, {label = "Déposez des graines", select = function()
        exports.menu:closeMenu()
        dialogChamp(champ.id, "seed", 34, champ.stockSeed, 1000)
    end})
    -- menu.AddButton(menu, {label = "Retirer de l'eau", select = function()
    --     exports.menu:closeMenu()
    --     dialogChamp(champ.id, "water", 36, champ.stockWater, 1000)
    -- end})
    menu.AddButton(menu, {label = "Déposez du fertilisant", select = function()
        exports.menu:closeMenu()
        dialogChamp(champ.id, "fertilizer", 35, champ.stockFertilizer, 1000)
    end})
    menu.AddButton(menu, {label = "Retrait de "..champ.type, select = function()
        exports.menu:closeMenu()
        dialogChamp(champ.id, "raw", champ.itemId, champ.stockItem, 10000)
    end})
    menu.AddButton(menu, {label = "Stock de graines : "..champ.stockSeed.."/1000", select = function()
    end})
    -- menu.AddButton(menu, {label = "Stock d'eau : "..champ.stockWater.."/1000", select = function()
    -- end})
    menu.AddButton(menu, {label = "Stock de fertilisant : "..champ.stockFertilizer.."/1000", select = function()
    end})
    menu.AddButton(menu, {label = "Stock de "..champ.type.." : "..champ.stockItem.."/10000", select = function()
    end})
    exports.menu:openMenu(menu)
end)




-- function startRecolteCannabis()
--     Citizen.CreateThread(function()
--         animation = true
--         local ped = GetPlayerPed(-1)
--         TaskStartScenarioInPlace(ped, "WORLD_HUMAN_GARDENER_PLANT", 0, false);
--         TriggerEvent("progressBar", 20)
--         startRecolteListener()
--         Wait(20000)
--         if animation and not breakAnimation then 
--             ClearPedTasksImmediately(ped)
--             TriggerEvent("notifynui", "info", "Crimi", "Vous ramassez 30 têtes de cannabis.")
--             TriggerServerEvent("updateInventory", 20, 30)
--             animation = false
--             breakAnimation = false
--             startRecolteCannabis()
--         end
--         breakAnimation = false
--     end)
-- end

-- function startRecolteListener()
--     Citizen.CreateThread(function()
--         while animation do
--             local ped = GetPlayerPed(-1)
--             if IsPedRagdoll(ped) or not DoesEntityExist(ped) or IsEntityDead(ped) or IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) then 
--                 animation = false
--                 breakAnimation = true
--                 ClearPedTasksImmediately(ped)
--                 TriggerEvent("stopProgressBar")
--             end
--             Citizen.Wait(0)
--         end
--     end)
-- end







-- *** GO FAST **********************************************

RegisterNetEvent('startGoFastCallback')
AddEventHandler('startGoFastCallback', function(coords)
    goFast = true
    startGoFast(coords)
end)

RegisterNetEvent('goFastFailed')
AddEventHandler('goFastFailed', function(coords)
    goFast = false
    if DoesBlipExist(livraisonBlip) then
        RemoveBlip(livraisonBlip)
    end
end)

function startGoFast(coords)
    local coords = coords
    SetGpsActive(false)
    livraisonBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipColour(livraisonBlip,5)
    BeginTextCommandSetBlipName("GOFAST")
    AddTextComponentString("Point de livraison")
    EndTextCommandSetBlipName(livraisonBlip)
    SetBlipRoute(livraisonBlip, true)
    Citizen.CreateThread(function()
        while goFast do
            local ped = GetPlayerPed(-1)
            if not DoesEntityExist(ped) or IsEntityDead(ped) or (false and false) then 
                goFast = false
                TriggerEvent("notifynui", "error", "Crimi", "Tu as échoué la livraison.")
                TriggerServerEvent("stopGoFast")
                if DoesBlipExist(livraisonBlip) then
                    RemoveBlip(livraisonBlip)
                end
            end
            local interval = 0
            local pos = GetEntityCoords(PlayerPedId())
            local dest = vector3(coords.x, coords.y, coords.z)
            local distance = GetDistanceBetweenCoords(pos, dest, true)

            if distance < 25 then
                DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 0.8, 0, 255, 80, 150, 0, 0, 2, 0, nil, nil, 0)
                if distance < 2 then 
                    AddTextEntry("GOFAST", "Appuyez sur la touche ~INPUT_CONTEXT~ pour commencer la livraison")
                    DisplayHelpTextThisFrame("GOFAST", false)
                    if IsControlJustPressed(1, 51) then
                        if DoesBlipExist(livraisonBlip) then
                            RemoveBlip(livraisonBlip)
                        end
                        TriggerServerEvent("stopGoFast")
                        startLivraison(coords)
                        goFast = false
                    end
                end
            end
            Citizen.Wait(0)
        end
    end)
end

function startLivraison(coords)
    local coords = coords
    TriggerEvent("notifynui", "info", "Crimi", "Début de la livraison.")
    livraison = true 
    Citizen.CreateThread(function()
        local dest = vector3(coords.x, coords.y, coords.z)
        local ped = GetPlayerPed(-1)
        while livraison do 
            local pos = GetEntityCoords(PlayerPedId())
            local distance = GetDistanceBetweenCoords(pos, dest, true)
            if not DoesEntityExist(ped) or IsEntityDead(ped) or IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) or distance > 5 then 
                livraison = false
                TriggerEvent("stopProgressBar")
                TriggerEvent("notifynui", "error", "Crimi", "Tu as échoué la livraison.")
                TriggerServerEvent("stopGoFast")
                if DoesBlipExist(livraisonBlip) then
                    RemoveBlip(livraisonBlip)
                end
            end
            Citizen.Wait(0)
        end
    end)
    TriggerEvent("progressBar", 20)
    Wait(20000)
    if livraison then
        TriggerServerEvent("livraisonGoFast", 21, 60)
        livraison = false
    end
end