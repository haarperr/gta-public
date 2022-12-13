local character
focus = false
local cash = 0

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' is starting on the client.')
    while character == nil do 
        TriggerServerEvent("getCharacter")
        Wait(200)
    end
    Citizen.Wait(4000)
    SendNUIMessage({
        action = 'refresh',
        cid = character.id
    })
    print('The resource ' .. resourceName .. ' has been started on the client.')
end)


RegisterNetEvent('getCharacterCallback')
AddEventHandler('getCharacterCallback', function(c)
    character = c
    SendNUIMessage({
        action = 'refresh',
        cid = character.id
    })
end)

RegisterNetEvent('refreshInventaire')
AddEventHandler('refreshInventaire', function(c)
    SendNUIMessage({
        action = 'refresh',
        cid = character.id
    })
end)

RegisterNetEvent('refreshInventaireIfOpen')
AddEventHandler('refreshInventaireIfOpen', function(c)
    if focus then
        SendNUIMessage({
            action = 'refresh',
            cid = character.id
        })
    end
end)

RegisterNetEvent('updateCashInventaire')
AddEventHandler('updateCashInventaire', function(c)
    cash = c
    if cash > 20000 then
        activeValise()
    else
        disableValise()
    end
end)

RegisterNetEvent('animationEchange')
AddEventHandler('animationEchange', function(id)
    SendNUIMessage({
        action = 'refresh',
        cid = character.id
    })
    local playerPed = PlayerPedId()
    local dict = "mp_common"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(playerPed, dict, "givetake1_a", 8.0, 8.0, 2000, 50, 0, false, false, false)
end)




RegisterKeyMapping('+inventaire', 'Inventaire', 'keyboard', 'i')


RegisterCommand('+inventaire', function()
    local ped = GetPlayerPed(-1)
    if (DoesEntityExist(ped) and not IsEntityDead(ped) and not IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) and not IsPedRagdoll(ped)) then 
        if focus then 
            focus = false
            SendNUIMessage({
                action = 'isVisible',
                data = false
            })
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
        else
            if exports.menu:isMenuOpen() then 
                exports.menu:closeMenu()
            end
            focus = true
            SendNUIMessage({
                action = 'isVisible',
                data = true,
                cid = character.id,
                type = 'inventaire'
            })
            SetNuiFocus(true, true)
            SetNuiFocusKeepInput(false)
        end
    end
end, false)


RegisterCommand('-inventaire', function()
end, false)


RegisterNUICallback('close', function(_, cb)
    focus = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    if vehicleInv and vehicleInv~=0 then
        SetVehicleDoorShut(vehicleInv, 5, false, false)
        vehicleInv=0
    end
    cb("")
end)


RegisterNUICallback('transfertTo', function(data, cb)
    if data and data.to then 
        TriggerServerEvent("transfertTo", data)
        cb("ok")
    else
        cb("cancel")
    end
end)

RegisterNUICallback('transfertCash', function(data, cb)
    if data and data.to then 
        TriggerServerEvent("transfertCash", data)
        cb("ok")
    else
        cb("cancel")
    end
end)


RegisterNetEvent('hideInv')
AddEventHandler('hideInv', function(c)
    focus = false
    SendNUIMessage({
        action = 'isVisible',
        data = false
    })
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
end)


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


function isFocus()
    return focus
end

nearestPlayer = 0

function sendToNuiPlayer()
    if isFocus() then 
        if GetPlayerServerId(GetPlayerFromPed(GetPedInFront())) ~= nearestPlayer then 
            nearestPlayer = GetPlayerServerId(GetPlayerFromPed(GetPedInFront()))
            SendNUIMessage({
                action = 'nearestPlayer',
                nearestPlayer = nearestPlayer
            })
        end
    end
end

Citizen.CreateThread(function()
    local interval = 100
    while true do
        interval = 100
        sendToNuiPlayer()
        Citizen.Wait(interval)
    end
end)


isInAnimation = false
cancelAnimation = false

RegisterNUICallback('useItem', function(data, cb)
    if not isInAnimation then 
        if _G[data.Item.action] then 
            isInAnimation = true
            useItemListener()
            focus = false
            SendNUIMessage({
                action = 'isVisible',
                data = false
            })
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
            _G[data.Item.action](data)
        else 
            TriggerEvent('notifynui', "error", "Inventaire", "Une erreur s'est produite.")
        end
    else
        TriggerEvent('notifynui', "error", "Inventaire", "Vous êtes déjà occupé.")
    end
    cb("")
end)

function useItemListener()
    Citizen.CreateThread(function()
        local ped = GetPlayerPed(-1)
        while isInAnimation do
            Wait(0)
            if (not DoesEntityExist(ped) or IsEntityDead(ped) or IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) or IsPedRagdoll(ped)) then 
                isInAnimation = false
                cancelAnimation = true
                TriggerEvent("stopProgressBar")
                ClearPedTasksImmediately(ped)
            end
        end
    end)
end

RegisterNUICallback('notify', function(data, cb)
    TriggerEvent("notifynui", data.type, data.title, data.text)
    cb("")
end)

RegisterNUICallback('triggerEvent', function(event, cb)
    TriggerEvent(event.name, event.data)
    cb({})
end)


-- **************************** VALISE D'ARGENT **************************

local valised = false 

function activeValise()
    local t , h = GetCurrentPedWeapon(GetPlayerPed(-1))
    if not valised or h ~= -2000187721 then 
        valised = true
        GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_briefcase"), 1, false, true)
        Citizen.CreateThread(function()
            while valised do
                Citizen.Wait(0)
                BlockWeaponWheelThisFrame()
                DisableControlAction(0, 37, true)
                DisableControlAction(0, 199, true) 
            end
        end)
    end
end

function disableValise()
    local t , h = GetCurrentPedWeapon(GetPlayerPed(-1))
    if valised or h == -2000187721 then 
        valised = false
        RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("weapon_briefcase"))
        SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        if cash > 20000 then
            activeValise()
        else
            disableValise()
        end
    end
end)




-- ******************************** SHOP ****************************

RegisterNetEvent('menuShop')
AddEventHandler('menuShop', function(shopId)
    if focus then 
        focus = false
        SendNUIMessage({
            action = 'isVisible',
            data = false
        })
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
    else
        focus = true
        SendNUIMessage({
            action = 'isVisible',
            data = true,
            cid = character.id,
            shopId = shopId,
            type = 'shop'
        })
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(false)
    end
end)



function ObjectInFront(ped, pos)
	local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.5, 0.0)
	local car = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 30, ped, 0)
	local _, _, _, _, result = GetRaycastResult(car)
	return result
end

function GetVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
end






-- ********************** VEHICULE ********************************************

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


RegisterKeyMapping('+inventaireVoiture', 'InventaireVoiture', 'keyboard', 'o')


vehicleInv = 0


RegisterCommand('+inventaireVoiture', function()
    vehicleInv = GetClosestVehicleCustom()
        local ped = GetPlayerPed(-1)
        if vehicleInv ~= 0 and IsPedInAnyVehicle(ped, false) ~= 1 and GetVehicleDoorLockStatus(vehicleInv)==1 and (DoesEntityExist(ped) and not IsEntityDead(ped) and not IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) ) then 
        plate = GetVehicleNumberPlateText(vehicleInv)
        if focus then 
            vehicleInv=0
            focus = false
            SendNUIMessage({
                action = 'isVisible',
                data = false
            })
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
        else
            SetVehicleDoorOpen(vehicleInv, 5, false, false)
            focus = true
            SendNUIMessage({
                action = 'isVisible',
                data = true,
                cid = character.id,
                plate = plate,
                type = 'vehicule'
            })
            SetNuiFocus(true, true)
            SetNuiFocusKeepInput(false)
        end
    end
end, false)


function getVeh()
    return vehicleInv
end

Citizen.CreateThread(function()
    while true do 
        interval = 50
        if isFocus() and vehicleInv ~= 0 then 
            local posV = GetEntityCoords(vehicleInv, false) 
            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)
            if GetDistanceBetweenCoords(posV, pos, true) > 6 then
                SetVehicleDoorShut(vehicleInv, 5, false, false)
                focus = false
                SendNUIMessage({
                    action = 'isVisible',
                    data = false
                })
                SetNuiFocus(false, false)
                SetNuiFocusKeepInput(false) 
            end
        end
        Citizen.Wait(interval)
    end
end)

RegisterCommand('-inventaireVoiture', function()
end, false)


-- *****************************  COFFRE  ***************************************************************

RegisterNetEvent('openCoffre')
AddEventHandler('openCoffre', function(id, ctype)
    if not focus then 
        focus = true
        SendNUIMessage({
            action = 'isVisible',
            data = true,
            cid = character.id,
            coffreId = id,
            coffreType = ctype,
            type = 'coffre'
        })
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(false)
    end
end)





-- ************************ FOUILLE ***********************************************


RegisterNetEvent('openFouille')
AddEventHandler('openFouille', function(id)
    if not focus then 
        focus = true
        SendNUIMessage({
            action = 'isVisible',
            data = true,
            cid = character.id,
            coffreId = id,
            type = 'fouille'
        })
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(false)
    end
end)


AddEventHandler('fouiller', function(data)
    TriggerServerEvent("getCharacterIdFromServerIdWithCallback", GetPlayerServerId(GetPlayerFromPed(data.entity)), "openFouille")
end)
