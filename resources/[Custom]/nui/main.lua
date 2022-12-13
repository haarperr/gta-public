local display = false



Citizen.CreateThread(function()
  Wait(500)
  SendNUIMessage({
    type = "ui",
    display = false
  })
  while true do
    local interval = 1000
    if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then 
      interval = 100
      local currentVehicle = GetVehiclePedIsIn(PlayerPedId())
      if  GetPedInVehicleSeat(currentVehicle, -1) == GetPlayerPed(-1) and GetVehicleClass(currentVehicle) ~= 13 then
        interval = 10
        display = true
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
        if display == true then
          SendNUIMessage({
            type = "ui",
            display = false
          })
          display = false
        end
      end
    else
      if display == true then
        SendNUIMessage({
          type = "ui",
          display = false
        })
        display = false
      end
    end
    Wait(interval)
  end
end)

