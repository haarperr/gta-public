RegisterNetEvent('progressBar')
AddEventHandler('progressBar', function(duration)
  SendNUIMessage({
    type = "ui",
    duration = duration
  })
end)

RegisterNetEvent('stopProgressBar')
AddEventHandler('stopProgressBar', function()
  SendNUIMessage({
    type = "ui"
  })
end)
