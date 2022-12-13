local display = false
local character

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
  if character then 
    local food = character.food 
    local water = character.water 
    character = c
    character.food = food
    character.water = water
  else
    character = c
  end
end)

RegisterNetEvent('setCharacterFood')
AddEventHandler('setCharacterFood', function(f)
  if character then 
    character.food = f
  end
end)

RegisterNetEvent('setCharacterWater')
AddEventHandler('setCharacterWater', function(w)
  if character then 
    character.water = w
  end
end)

function getFood()
  if not character then
    return 100 
  else 
    return character.food 
  end
end

function getWater()
  if not character then
    return 100 
  else 
    return character.water 
  end
end

Citizen.CreateThread(function()
  while true do
    local interval = 1000
    local ped = GetPlayerPed(-1)
    if DoesEntityExist(ped) and not IsEntityDead(ped) then
      interval = 100
      local oxygen = null
      if(IsPedSwimmingUnderWater(GetPlayerPed(-1))) then
        oxygen = GetPlayerUnderwaterTimeRemaining(PlayerId())
        if oxygen < 0 then 
          oxygen = 0 
        end
      end
      SendNUIMessage({
        type = "ui",
        display = true, 
        id = GetPlayerServerId(PlayerId()),
        hp = GetEntityHealth(ped),
        food = getFood(),
        water = getWater(),
        oxygen = oxygen,
      })
      display = true
    else
      if display then
        display = false
        SendNUIMessage({
          type = "ui",
          display = false
        })
      end
    end
    Wait(interval)
  end
end)
