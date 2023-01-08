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
      local oxygen = nil
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
        action = "gauges",
      })
      display = true
    else
      if display then
        display = false
        SendNUIMessage({
          type = "ui",
          action = "gauges",
          display = false
        })
      end
    end
    Wait(interval)
  end
end)






local displayVehicle = false



Citizen.CreateThread(function()
  Wait(500)
  SendNUIMessage({
    type = "ui",
    display = false,
    action = "vehicle"
  })
  while true do
    local interval = 1000
    if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then 
      interval = 100
      local currentVehicle = GetVehiclePedIsIn(PlayerPedId())
      if  GetPedInVehicleSeat(currentVehicle, -1) == GetPlayerPed(-1) and GetVehicleClass(currentVehicle) ~= 13 then
        interval = 10
        displayVehicle = true
        -- local phare0, phare1, phare2 = GetVehicleLightsState(currentVehicle)
        -- if GetVehicleBodyHealth(currentVehicle) 
        -- local damage = GetVehicleBodyHealth(currentVehicle)
        local rpm 
        if IsVehicleEngineOn(currentVehicle) then 
          rpm = GetVehicleCurrentRpm(currentVehicle)
        else
          rpm = 0
        end
        SendNUIMessage({
          type = "ui",
          action = "vehicle",
          display = true, 
          speed = GetEntitySpeed(currentVehicle),
          rpm = rpm,
          gear = GetVehicleCurrentGear(currentVehicle),
          -- abs = (GetVehicleWheelSpeed(currentVehicle, 0) == 0.0) and (GetEntitySpeed(currentVehicle) > 0.0),
          -- hBrake = GetVehicleHandbrake(currentVehicle),
          fuel = 100 * GetVehicleFuelLevel(currentVehicle) / GetVehicleHandlingFloat(currentVehicle,"CHandlingData","fPetrolTankVolume"),
          -- crash = GetVehicleBodyHealth(currentVehicle),
          -- phare0 = phare0,
          -- phare1 = phare1,
          -- phare2 = phare2,
        })
      else
        if displayVehicle == true then
          SendNUIMessage({
            type = "ui",
            action = "vehicle",
            display = false
          })
          displayVehicle = false
        end
      end
    else
      if displayVehicle == true then
        SendNUIMessage({
          type = "ui",
          action = "vehicle",
          display = false
        })
        displayVehicle = false
      end
    end
    Wait(interval)
  end
end)




RegisterNetEvent('progressBar')
AddEventHandler('progressBar', function(duration, text)
  SendNUIMessage({
    type = "ui",
    duration = duration*1000,
    text = text,
    action = "progressbar"
  })
end)

RegisterNetEvent('stopProgressBar')
AddEventHandler('stopProgressBar', function()
  SendNUIMessage({
    type = "ui",
    action = "progressbar"
  })
end)
