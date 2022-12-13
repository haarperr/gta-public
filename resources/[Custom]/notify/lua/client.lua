
-- FUNCTIONS
function notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, true)
end

RegisterNetEvent('notify')
AddEventHandler('notify', function(msg)
    notify(msg)
end)

RegisterNetEvent('notifynui')
AddEventHandler('notifynui', function(ntype, title, text)
    SendNUIMessage({
		type = ntype,
        title = title,
        text = text,
    })
end)

RegisterNetEvent('playsound')
AddEventHandler('playsound', function(sound)
    SendNUIMessage({
		type = "sound",
        sound = sound,
    })
end)

SetNuiFocus(true, true)
SetNuiFocusKeepInput(true)