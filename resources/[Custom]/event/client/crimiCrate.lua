local character
local smokeFx
local trailFx

RegisterNetEvent('getCharacterCallback')
AddEventHandler('getCharacterCallback', function(c)
    character = c
end)



-- Citizen.CreateThread(function()
--     TriggerServerEvent("getCharacter")
--     modelHash = GetHashKey("a_c_chimp")
--     RequestModel(modelHash)
--     while not HasModelLoaded(modelHash) do
--        	Wait(1)
--     end
--     createSingeCrimi() 
-- end)

-- -- SINGE CRIMI
-- function createSingeCrimi()
-- 	created_ped = CreatePed(5, modelHash , -1531.56, 79.34, 55.5, 0.94, false, true)
-- 	FreezeEntityPosition(created_ped, true)
-- 	SetEntityInvincible(created_ped, true)
-- 	SetBlockingOfNonTemporaryEvents(created_ped, true)
-- 	TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_DRINKING", 0, true)
-- end
-- Citizen.CreateThread(function()
--     while true do 
--         local interval = 20
--         local pos = GetEntityCoords(PlayerPedId())
--         local dest = vector3(-1531.56, 79.34, 55.5)
--         local distance = GetDistanceBetweenCoords(pos, dest, true)


--         if distance > 50 then
--             interval = 500
--         else
--             interval = 1
--             DrawMarker(1, -1531.56, 79.34, 55.6, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 0, 0, 0, 100, 0, 0, 2, 0, nil, nil, 0)
--             if distance < 2 then 
--                 if not exports.menu:isMenuOpen() then
--                     AddTextEntry("PNJ", "Faire du biz ~INPUT_CONTEXT~ AKAKAK")
--                     DisplayHelpTextThisFrame("PNJ", false)
--                     if IsControlJustPressed(1, 51) then
--                         local menu = exports.menu:CreateMenu({ name = "crimi", title = 'Le Singe', subtitle = 'Missions', footer =  'Appuyez sur Entrée'})
--                         menu.ClearItems(menu)
--                         menu.AddButton(menu, {label = "Récupération d'une voiture", type = 'action' , select = function()
--                             -- SetGpsActive(false)
--                             -- b = AddBlipForCoord(-1409.6, -67.5, 52.5)
--                             -- SetBlipRoute(b, true)
--                             -- -1409.6 -67.5 52.5 200
--                             -- test()
--                             exports.menu:closeMenu()
--                         end})
--                         menu.AddButton(menu, {label = "Largage de caisse d'armes", type = 'action' , select = function()
--                             local i = math.random(1, numberLocations)
--                             print(i)
--                             print(crateLocations[i].x, crateLocations[i].y, crateLocations[i].z-0.99)
--                             local dest = vector3(crateLocations[i].x, crateLocations[i].y, (crateLocations[i].z-0.99))
--                             TriggerServerEvent("createCrate", dest)
--                             exports.menu:closeMenu()
--                         end})
--                         menu.AddButton(menu, {label = "Vendre mes caisses d'armes", type = 'action' , select = function()
--                             TriggerServerEvent("sellCrate")
--                             exports.menu:closeMenu()
--                         end})
--                         menu.AddButton(menu, {label = "Vendre mes petits sacs", type = 'action' , select = function()
--                             TriggerServerEvent("sellPetitSac")
--                             exports.menu:closeMenu()
--                         end})
--                         exports.menu:openMenu(menu)
--                     end
--                 end
--             end
--         end
--         Citizen.Wait(interval)
--     end
-- end)



-- ??????
-- function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

-- 	-- TextEntry		-->	The Text above the typing field in the black square
-- 	-- ExampleText		-->	An Example Text, what it should say in the typing field
-- 	-- MaxStringLenght	-->	Maximum String Lenght

-- 	AddTextEntry('FMMC_KEY_TIP1', TextEntry) --Sets the Text above the typing field in the black square
-- 	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) --Actually calls the Keyboard Input
-- 	-- blockinput = true --Blocks new input while typing if **blockinput** is used

-- 	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do --While typing is not aborted and not finished, this loop waits
-- 		Citizen.Wait(0)
-- 	end
		
-- 	if UpdateOnscreenKeyboard() ~= 2 then
-- 		local result = GetOnscreenKeyboardResult() --Gets the result of the typing
-- 		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
-- 		blockinput = false --This unblocks new Input when typing is done
-- 		return result --Returns the result
-- 	else
-- 		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
-- 		blockinput = false --This unblocks new Input when typing is done
-- 		return nil --Returns nil if the typing got aborted
-- 	end
-- end


-- function test(dest)	 
--     local player = GetPlayerPed(-1)
--     local pos = GetEntityCoords(player,1)
--     local ground 
        
--     RequestModel("STRATUM")
--     while not HasModelLoaded("STRATUM") or not HasCollisionForModelLoaded("STRATUM") do --for each types of entity
--         Wait(1)
--     end
    
--     posX = pos.x+math.random(1,6)--radius example
--     posY = pos.y+math.random(1,6)--radius example
--     Z = pos.z+999.0
    
--     ground,posZ = GetGroundZFor_3dCoord(posX+.0,posY+.0,Z,1)
    
--     if(ground) then
--         entity = CreateVehicle("STRATUM",posX,posY,posZ,0.0, true, true)
--         SetEntityAsMissionEntity(entity, true, true)
        
--         local blip = AddBlipForEntity(entity)
--         SetBlipSprite(blip,66)
--         SetBlipColour(blip,46)
--         BeginTextCommandSetBlipName("STRING")
--         AddTextComponentString("Spawned entity")
--         EndTextCommandSetBlipName(blip)
--         SetBlipRoute(blip, true)	   
--     end
-- end




RegisterNetEvent('createCrateBlip')
AddEventHandler('createCrateBlip', function(dest)
    local blipCoords = {x=dest.x+math.random(-180,180), y=dest.y+math.random(-180,180), z=dest.z}

    crateBlipZone = AddBlipForRadius(blipCoords.x, blipCoords.y, blipCoords.z, 250.0)
    SetBlipRotation(crateBlipZone, 0)
    SetBlipColour(crateBlipZone, 1)
    SetBlipAlpha(crateBlipZone, 150)
    
    crateBlip = AddBlipForCoord(blipCoords.x, blipCoords.y, blipCoords.z, 250.0)
    EndTextCommandSetBlipName(crateBlip)
    SetBlipSprite(crateBlip, 550)
    SetBlipColour(crateBlip, 1)
end)


RegisterNetEvent('dropZone')
AddEventHandler('dropZone', function(dest, playerSource)
    dropZone(dest, playerSource)
end)

RegisterNetEvent('dropZoneDelete')
AddEventHandler('dropZoneDelete', function(dest)
    crateExists = false
    StopParticleFxLooped(smokeFx, false)
    StopParticleFxLooped(trailFx, false)
end)


crateExists = false

function dropZone(dest, playerSource)
    crateExists = true
    Citizen.CreateThread(function()
        
        local dict = "core"
        local smoke = "exp_grd_flare"
        local trail = "weap_heist_flare_trail"
        if not HasNamedPtfxAssetLoaded(dict) then
            RequestNamedPtfxAsset(dict)
            while not HasNamedPtfxAssetLoaded(dict) do
            Wait(1)
            end
        end
        
        UseParticleFxAssetNextCall(dict)
        smokeFx = StartParticleFxLoopedAtCoord(smoke, dest.x, dest.y, dest.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        trailFx = StartParticleFxLoopedAtCoord(trail, dest.x, dest.y, dest.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        
        local interval = 500
        while crateExists do 
            local player = GetPlayerPed(-1)
            local pos = GetEntityCoords(player,1)
            local distance = GetDistanceBetweenCoords(pos, dest, true)
            Wait(interval)
            if distance > 50 then
                interval = 1000
            else
                interval = 0
            end
            if distance < 2 then 
                AddTextEntry("CRATE", "Appuyez sur la touche ~INPUT_CONTEXT~")
                DisplayHelpTextThisFrame("CRATE", false)
                if IsControlJustPressed(1, 51) then
                    TriggerServerEvent("getCrateContent", playerSource)
                    Wait(1000)
                end
            end
        end
    end)
end


RegisterNetEvent('deleteCrateBlip')
AddEventHandler('deleteCrateBlip', function()
    deleteCrateBlip()
end)

function deleteCrateBlip()
    if DoesBlipExist(crateBlip) then
        RemoveBlip(crateBlip)
    end
    if DoesBlipExist(crateBlipZone) then
        RemoveBlip(crateBlipZone)
    end
end