local character
local ateliers
local crafting

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' is starting on the client.')
    TriggerServerEvent("getAteliers")
    while character == nil do 
        TriggerServerEvent("getCharacter")
        Wait(100)
    end
    print('The resource ' .. resourceName .. ' has been started on the client.')
end)


RegisterNetEvent('getCharacterCallback')
AddEventHandler('getCharacterCallback', function(c)
    character = c
    SendNUIMessage({
        action = "refresh",
        cid = c.id,
        organisationId = c.organisationId
    })
end)

RegisterNetEvent('getAteliersCallback')
AddEventHandler('getAteliersCallback', function(a)
    ateliers = a
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



function SendReactMessage(action, data)
    SendNUIMessage({
      action = action,
      data = data
    })
end

function toggleNuiFrame(shouldShow, stype, organisationId)
    SetNuiFocus(shouldShow, shouldShow)
    SetNuiFocusKeepInput(false)
    isOpen = shouldShow
    SendReactMessage('setVisible', {
        show = shouldShow,
        type = stype,
        organisationId = organisationId
    })
end

function openMenu()
    toggleNuiFrame(true)
    isOpen = true
end

function closeMenu()
    toggleNuiFrame(false)
    isOpen = false
end

RegisterNUICallback('notify', function(data, cb)
	TriggerEvent("notifynui", data.type, "Fabrication", data.message)
    cb("")
end)

function craftingListener()
    Citizen.CreateThread(function()
        while crafting do
            local ped = GetPlayerPed(-1)
            if IsPedRagdoll(ped) or not DoesEntityExist(ped) or IsEntityDead(ped) or IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) then 
                SendReactMessage('stop', {})
                crafting = false
            end
            Citizen.Wait(0)
        end
    end)
end

RegisterNUICallback('startCraft', function(data, cb)
    crafting = true
    craftingListener()
    cb("")
end)

RegisterNUICallback('stopCraft', function(data, cb)
    crafting = false
    cb("")
end)

Citizen.CreateThread(function()
    while true do
        local interval = 5000
        if ateliers then 
            for i,atelier in pairs(ateliers) do
                if atelier.organisationId and atelier.organisationId == character.organisationId then
                    local pos = GetEntityCoords(PlayerPedId())
                    DrawMarker(1, atelier.x, atelier.y, atelier.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.8, 1.8, 0.6, 0, 140, 255, 80, 0, 0, 2, 0, nil, nil, 0)
                    local dest = vector3(atelier.x, atelier.y, atelier.z)
                    local distanceOut = GetDistanceBetweenCoords(pos, dest, true)
                    atelier.distanceOut = distanceOut
                    if atelier.distanceOut < 20 then
                        interval = 0
                        if atelier.distanceOut < 2 then
                            if not exports.menu:isMenuOpen() then
                                AddTextEntry("ATELIER", "Appuyez sur la touche ~INPUT_CONTEXT~")
                                DisplayHelpTextThisFrame("ATELIER", false)
                                if IsControlJustPressed(1, 51) then
                                    Wait(10)
                                    toggleNuiFrame(true, nil, atelier.organisationId)
                                end
                            end
                        elseif atelier.distanceOut > 5 then
                            closeMenu()
                            if crafting then
                                SendReactMessage('stop', {})
                            end
                        end
                    end
                elseif atelier.type then
                    local pos = GetEntityCoords(PlayerPedId())
                    DrawMarker(1, atelier.x, atelier.y, atelier.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.8, 1.8, 0.6, 0, 140, 255, 80, 0, 0, 2, 0, nil, nil, 0)
                    local dest = vector3(atelier.x, atelier.y, atelier.z)
                    local distanceOut = GetDistanceBetweenCoords(pos, dest, true)
                    atelier.distanceOut = distanceOut
                    if atelier.distanceOut < 20 then
                        interval = 0
                        if atelier.distanceOut < 2 then
                            if not exports.menu:isMenuOpen() then
                                AddTextEntry("ATELIER", "Appuyez sur la touche ~INPUT_CONTEXT~")
                                DisplayHelpTextThisFrame("ATELIER", false)
                                if IsControlJustPressed(1, 51) then
                                    Wait(10)
                                    toggleNuiFrame(true, atelier.type, nil)
                                end
                            end
                        elseif atelier.distanceOut > 5 then
                            closeMenu()
                            if crafting then
                                SendReactMessage('stop', {})
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(interval)
    end
end)