local keys = {}
local menu


Citizen.CreateThread(function()
    Citizen.Wait(1000)
    menu = exports.menu:CreateMenu({name = "portecle", title = 'Porte-clés', subtitle = 'Mes véhicules', footer = "Appuyer sur 'Entrée' pour donner un double."})
end)

function openPorteCles()
    if not exports.menu:isMenuOpen() then
        exports.menu:closeMenu()
        menu.ClearItems(menu)
        for _,v in pairs(keys) do 
            menu.AddButton(menu, {label = v, select = function()
                createDoublon(v)
            end})
        end
        exports.menu:openMenu(menu)
    end
end
RegisterKeyMapping('+portecles', 'Porte-clés', 'keyboard', 'F4')

local portecles = false
RegisterCommand('+portecles', function()
    if not exports.menu:isMenuOpen() then 
        openPorteCles()
        portecles = true
    elseif portecles and exports.menu:isMenuOpen() then
        exports.menu:closeMenu()
        portecles = false
    end
end, false)


RegisterCommand('-portecles', function()
end, false)



function GetClosestVehicleCustom()
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    local entityWorld = GetOffsetFromEntityInWorldCoords(ply, 0.0, 20.0, 0.0)
    local rayHandle = CastRayPointToPoint(plyCoords["x"], plyCoords["y"], plyCoords["z"], entityWorld.x, entityWorld.y, entityWorld.z, 10, ply, 0)
    local a, b, c, d, targetVehicle = GetRaycastResult(rayHandle)

    if targetVehicle ~= nil then
        return targetVehicle
    else 
        return 0
    end
end




RegisterKeyMapping('+lockVeh', 'Verrouiller véhicule', 'keyboard', 'u')


RegisterCommand('+lockVeh', function()
    local ped = GetPlayerPed(-1)
    local veh = nil
    if IsPedInAnyVehicle(ped, false) == 1 then 
        veh = GetVehiclePedIsIn(ped)
    else
        local pos = GetEntityCoords(GetPlayerPed(-1))
        veh = GetClosestVehicleCustom()
        -- local ply = GetPlayerPed(-1)
        -- local plyCoords = GetEntityCoords(ply, 0)
        -- local entityWorld = GetOffsetFromEntityInWorldCoords(ply, 1.0, 3.0, 1.0)
        -- local rayHandle = CastRayPointToPoint(plyCoords["x"], plyCoords["y"], plyCoords["z"], entityWorld.x, entityWorld.y, entityWorld.z, 10, ply, 0)
        -- local a, b, c, d, targetVehicle = GetRaycastResult(rayHandle)
        -- veh = targetVehicle
    end
    if veh ~= nil then
        if DoesEntityExist(veh) then
            if not IsVehicleStolen(veh) then 
                if checkHasKey(GetVehicleNumberPlateText(veh)) then 
                    SetVehicleAlarm(veh, false)
                    if (GetVehicleDoorLockStatus(veh)==1) then 
                        SetVehicleDoorShut(veh, 0, false)
                        SetVehicleDoorShut(veh, 1, false)
                        SetVehicleDoorShut(veh, 2, false)
                        SetVehicleDoorShut(veh, 3, false)
                        SetVehicleDoorsLocked(veh, 2)
                        -- SetVehicleDoorsLockedForPlayer(veh, PlayerId(), true)
                        -- SetVehicleDoorsLockedForAllPlayers(veh, true)
                        PlayVehicleDoorCloseSound(veh, 1)
                        TriggerEvent("notify", "Véhicule verrouillé.")
                        StartVehicleHorn(veh, 75, "HELDDOWN", false)
                        Wait (200)
                        StartVehicleHorn(veh, 75, "HELDDOWN", false)
                    elseif (GetVehicleDoorLockStatus(veh)==2) then
                        StartVehicleHorn(veh, 75, "HELDDOWN", false)
                        TriggerEvent("notify", "Véhicule déverrouillé.")
                        SetVehicleDoorsLocked(veh, 1)
                        -- SetVehicleDoorsLockedForPlayer(veh, PlayerId(), false)
                        -- SetVehicleDoorsLockedForAllPlayers(veh, false)
                        PlayVehicleDoorOpenSound(veh, 0)
                    end
                    local dict = "anim@mp_player_intmenu@key_fob@"
                    RequestAnimDict(dict)
                    while not HasAnimDictLoaded(dict) do
                        Citizen.Wait(0)
                    end
                    if not IsPedInAnyVehicle(PlayerPedId(), true) then
                        TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                    end
                    SetVehicleLights(veh, 2)
                    Wait (200)
                    SetVehicleLights(veh, 0)
                    Wait (200)
                    SetVehicleLights(veh, 2)
                    Wait (400)
                    SetVehicleLights(veh, 0)
                else
                    TriggerEvent("notify", "Impossible de verrouiler ce véhicule.")
                end
            else
                TriggerEvent("notify", "Impossible de verrouiler ce véhicule.")
            end
        else
            TriggerEvent("notify", "Il n'y a pas de véhicule à verrouiler.")
        end
    else
        TriggerEvent("notify", "Il n'y a pas de véhicule à verrouiler.")
    end
end, false)


RegisterCommand('-lockVeh', function()
end, false)





function GetPedInFront()
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
	local _, _, _, _, ped = GetShapeTestResult(rayHandle)
	return ped
end

function GetPlayerFromPed(ped)
	for a = 0, 256 do
        if GetPlayerPed(a) == ped then
			return a
		end
	end
	return -1
end

function animateEchange()
    local playerPed = PlayerPedId()
    local dict = "mp_common"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(playerPed, dict, "givetake1_a", 8.0, 8.0, 2000, 50, 0, false, false, false)
end


function createDoublon(plate)
    local p = GetPlayerServerId(GetPlayerFromPed(GetPedInFront()))
    if p > 0 then 
        TriggerServerEvent("vehicule:echangeKey", p, plate)
        animateEchange()
    end
end



function checkHasKey(plate)
    for i,v in pairs(keys) do 
        if v == plate then 
            return true
        end            
    end
    return false            
end

RegisterNetEvent('vehicule:addKey')
AddEventHandler('vehicule:addKey', function(plate)
    table.insert(keys, plate)
end)

RegisterNetEvent('vehicule:removeKey')
AddEventHandler('vehicule:removeKey', function(plate)
    for i,v in pairs(keys) do
        if v == plate then
            table.remove(keys, i)
        end
    end
end)



RegisterNetEvent('vehicule:recieveKey')
AddEventHandler('vehicule:recieveKey', function(plate)
    if not checkHasKey(plate) then 
        TriggerEvent("notify", "Vous avez reçu des clés.")
        table.insert(keys, plate)
        animateEchange()
    end
end)