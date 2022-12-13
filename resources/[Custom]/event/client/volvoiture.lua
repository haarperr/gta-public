RegisterNetEvent('createVolVehicule')
AddEventHandler('createVolVehicule', function(coord, model)
    RequestModel(model)
    while not HasModelLoaded(model) or not HasCollisionForModelLoaded(model) do --for each types of entity
        Wait(1)
    end
    veh = CreateVehicle(model,coord.x,coord.y,coord.z,coord.h, true, true)
    SetEntityAsMissionEntity(veh, true, true)
	SetVehicleDoorsLocked(veh, 2)
	local blipCoords = {x=coord.x+math.random(-130,130), y=coord.y+math.random(-130,130), z=coord.z}
	crateBlipZone = AddBlipForRadius(blipCoords.x, blipCoords.y, blipCoords.z, 250.0)
	SetBlipRotation(crateBlipZone, 0)
	SetBlipColour(crateBlipZone, 7)
	SetBlipAlpha(crateBlipZone, 150)
	crateBlip = AddBlipForCoord(blipCoords.x, blipCoords.y, blipCoords.z, 250.0)
    SetBlipSprite(crateBlip, 227)
    AddTextEntry("VEH", "Véhicule")
    BeginTextCommandSetBlipName("VEH") 
    SetBlipColour(crateBlip, 7)
    EndTextCommandSetBlipName(crateBlip)
    SetBlipAsShortRange(crateBlip, true)
    TriggerServerEvent("addVolVehicule", GetVehicleNumberPlateText(veh), model)
	Citizen.CreateThread(function()
		local bool = true
		while bool do 
			Citizen.Wait(1000)
			if GetVehicleDoorLockStatus(veh) ~= 2 or not veh then 
				if DoesBlipExist(crateBlip) then
					RemoveBlip(crateBlip)
				end
				if DoesBlipExist(crateBlipZone) then
					RemoveBlip(crateBlipZone)
				end
			end
		end
	end)
end)

-- Citizen.CreateThread(function()
--     while true do 
--         local pos = GetEntityCoords(PlayerPedId())
--         local dest = vector3(coords.x, coords.y, coords.z)
--         local distance = GetDistanceBetweenCoords(pos, dest, true)
--     end
-- end)


local entrepotVolLocation = {
    {name = "dehorsveh", x = 1219.5, y = -3204.7, z = 5.6, h = 176.8},
    {name = "dedansveh", x = 971.1, y = -2990.9, z = -39.6, h = 194.7},
    {name = "dehorsfoot", x = 1242.5, y = -3196.9, z = 6.0, h = 273.1},
    {name = "dedansfoot", x = 1004.6, y = -2992.0, z = -39.6, h = 91.1},
}

-- ENTREPOT VOL  
Citizen.CreateThread(function()
    while true do 
        local interval = 5000
        for i,v in pairs(entrepotVolLocation) do 
            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)
            local dest = vector3(v.x, v.y, v.z)
            local distanceOut = GetDistanceBetweenCoords(pos, dest, true)
            v.distanceOut = distanceOut
            if v.distanceOut < 100 then
                interval = 100
                if v.distanceOut < 50 then
                    if v.name == "dedansfoot" or v.name == "dedansveh" then 
                        DrawMarker(1, v.x, v.y, v.z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.4, 0, 140, 255, 110, 0, 0, 2, 0, nil, nil, 0)
                    end
                    interval = 0
                    if v.distanceOut < 2 then
                        if DoesEntityExist(ped) or not IsEntityDead(ped) or not (false and false) then
                            AddTextEntry("ENTREPOTVOL", "Appuyez sur la touche ~INPUT_CONTEXT~")
                            DisplayHelpTextThisFrame("ENTREPOTVOL", false)
                            if IsControlJustPressed(1, 51) then
                                if v.name == "dehorsfoot" and not IsPedInAnyVehicle(ped) then
                                    teleportToEntrepot("dedansfoot")
                                elseif v.name == "dedansfoot" and not IsPedInAnyVehicle(ped) then
                                    teleportToEntrepot("dehorsfoot")
                                elseif v.name == "dehorsveh" then 
                                    teleportToEntrepot("dedansveh")
                                elseif v.name == "dedansveh" then 
                                    teleportToEntrepot("dehorsveh")
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

function teleportToEntrepot(to)
    for i,v in pairs(entrepotVolLocation) do
        if v.name == to then
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then 
                exports.lib:teleportTo(v.x, v.y, v.z-0.8, v.h, 1)
            else
                exports.lib:teleportTo(v.x, v.y, v.z, v.h)
            end
        end
    end
end



Citizen.CreateThread(function()
    local v = {x = 1011.0, y = -3020.2, z = -40.65, h = 113.1}
    modelHash = GetHashKey("a_m_m_eastsa_01")
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
    local ped = CreatePed(5, modelHash , v.x, v.y, v.z, v.h, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
end)
Citizen.CreateThread(function()
    local v = {x = 1007.8, y = -3022.2, z = -40.7}
    while true do 
        local interval = 5000
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local dest = vector3(v.x, v.y, v.z)
        local distanceOut = GetDistanceBetweenCoords(pos, dest, true)
        v.distanceOut = distanceOut
        if v.distanceOut < 100 then
            interval = 10
            if v.distanceOut < 50 then
                interval = 0
                DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.3, 2.3, 0.6, 0, 140, 255, 110, 0, 0, 2, 0, nil, nil, 0)
                if v.distanceOut < 2 then
                    if DoesEntityExist(ped) or not IsEntityDead(ped) or not (false and false) and IsPedInAnyVehicle(ped) then
                        AddTextEntry("ENTREPOTVOLGARAGE", "Appuyez sur la touche ~INPUT_CONTEXT~")
                        DisplayHelpTextThisFrame("ENTREPOTVOLGARAGE", false)
                        if IsControlJustPressed(1, 51) then
                            TriggerEvent("progressBar", 5)
                            Citizen.Wait(5000)
                            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                            local plate = GetVehicleNumberPlateText(vehicle)
                            local model = GetEntityModel(vehicle)
                            TriggerServerEvent("checkVolVehicule", plate, model)
                        end
                    end
                end
            end
        end
        Citizen.Wait(interval)
    end
end)
