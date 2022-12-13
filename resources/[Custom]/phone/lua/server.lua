RegisterNetEvent("baseevents:onPlayerDied")
AddEventHandler('baseevents:onPlayerDied', function(killerType, deathCoords)
	local _src = source
    TriggerClientEvent("removePhone", _src)
    TriggerClientEvent("removeRadio", _src)
end)