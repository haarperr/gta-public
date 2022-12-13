local isOpen = false

local cash
local bank
local characterId

local banks

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' is starting on the client.')
    Wait(2000)
    -- TriggerServerEvent("getMoney")
    TriggerServerEvent("getBanks")
    while getCID() == nil do 
        Wait(50)
        TriggerServerEvent("getCharacter")
    end
    print('The resource ' .. resourceName .. ' has been started on the client.')
end)

function getCID()
	return characterId
end

RegisterNetEvent('getCharacterCallback')
AddEventHandler('getCharacterCallback', function(c)
    characterId = c.id
    SendNUIMessage({
        action = "refresh",
        cid = characterId
    })
end)


RegisterNetEvent('getMoneyCallback')
AddEventHandler('getMoneyCallback', function(b, c)
    bank = b 
    cash = c
end)

RegisterNUICallback('retrait', function(q, cb)
    TriggerServerEvent("atm",'r', tonumber(q))
end)
    
RegisterNUICallback('depot', function(q, cb)
    TriggerServerEvent("atm",'d', tonumber(q))
end)


RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    isOpen = false
    cb("");
end)

RegisterNUICallback('hideFrame', function(_, cb)
    toggleNuiFrame(false)
    cb("");
end)
function SendReactMessage(action, data)
    SendNUIMessage({
      action = action,
      data = data,
      cid = characterId
    })
end

function toggleNuiFrame(shouldShow)
    SetNuiFocus(shouldShow, shouldShow)
    SetNuiFocusKeepInput(false)
    isOpen = shouldShow
    SendReactMessage('setVisible', shouldShow)
end

function openMenu()
    if not IsEntityDead(GetPlayerPed(-1)) and not IsEntityPlayingAnim(PlayerPedId(), 'mp_arresting', 'idle', 3) and not IsPedRagdoll(GetPlayerPed(-1))  then 
        toggleNuiFrame(true)
        isOpen = true
    end
end

function closeMenu()
    toggleNuiFrame(false)
    isOpen = false
end






function setBanksMarkers()
    Citizen.CreateThread(function()
        while true do
            local interval = 1000
            for i,sup in pairs(banks) do 
                local pos = GetEntityCoords(PlayerPedId())
                DrawMarker(27, sup.x, sup.y, sup.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 0, 150, 0, 255, 0, 0, 2, 0, nil, nil, 0)
                local dest = vector3(sup.x, sup.y, sup.z)
                local distance = GetDistanceBetweenCoords(pos, dest, true)
                -- sup.distance = distance
    
                if distance < 20 then
                    interval = 10
                    if distance < 10 then 
                        interval = 2
                    end
                    if distance < 2 then
                        if not isOpen then
                            AddTextEntry("BANK", "Utiliser ~INPUT_CONTEXT~")
                            DisplayHelpTextThisFrame("BANK", false)
                            if IsControlJustPressed(1, 51) then
                                if exports.menu:isMenuOpen() then
                                    exports.menu:closeMenu()
                                end
                                openMenu()
                            end
                        end
                    end
                end
            end
            Citizen.Wait(interval)
        end
    end)
end

function setBanksBlips()
    Citizen.CreateThread(function()
        for i,sup in pairs(banks) do 
            local blip = AddBlipForCoord(sup.x, sup.y, sup.z)
            SetBlipSprite(blip, 108)
            AddTextEntry('BANK', "Banque")
            BeginTextCommandSetBlipName('BANK') 
            SetBlipColour(blip, 69)
            SetBlipCategory(blip, 1) 
            EndTextCommandSetBlipName(blip)
            SetBlipAsShortRange(blip, true)
            SetBlipScale(blip, 0.8)
        end
    end)
end

RegisterNetEvent("getBanksCallback")
AddEventHandler("getBanksCallback", function(sup)
    banks = sup
    setBanksBlips()
    setBanksMarkers()
end)

-- RegisterCommand("addbank", function(source, args, rawcommand)
--     local coords = {}
--     local pos = GetEntityCoords(PlayerPedId())
--     coords.x = pos.x
--     coords.y = pos.y
--     coords.z = pos.z-0.98
--     TriggerServerEvent("addbank", args[1], coords)
-- end)

RegisterNUICallback('notify', function(data, cb)
    TriggerEvent("notifynui", data.type, data.title, data.text)
    cb("");
end)



AddEventHandler('openAtm', function(data)
	RequestAnimDict('anim@heists@keycard@')
	while not HasAnimDictLoaded('anim@heists@keycard@') do
		Citizen.Wait(0)
	end
	TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "enter", 8.0, 8.0, 2000, 16, 0, 0, 0, 0 )
    Wait(2000)
	openMenu()
end)




Citizen.CreateThread(function()
    Wait(5000)
    exports.qtarget:AddTargetModel({506770882, 506770882, -870868698, -1126237515 }, {
        options = {
            {
                event = "openAtm",
                icon = "fas fa-money-bills",
                label = "Accéder à l'ATM",
            },
        },
        distance = 1
    })
    
end)
