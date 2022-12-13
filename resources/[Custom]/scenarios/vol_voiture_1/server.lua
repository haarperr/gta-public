local doors = {
    {
        id = 431362,
        x = -1529.0, 
        y = -41.5, 
        z = 56.86, 
        hash = -1918480350,
        locked = true
    }, -- PORTE DE GAUCHE FACE A L'ENTREE
    {
        id = 430082,
        x = -1533.9, 
        y = -42.7, 
        z = 56.9,
        hash = -349730013,
        locked = true
    }, -- PORTE DE DROITE FACE A L'ENTREE
}

local boitierStatut = true

RegisterNetEvent('getDoorsStatut')
AddEventHandler('getDoorsStatut', function()
    for i,v in pairs(doors) do 
        TriggerClientEvent("updateDoorStatut", source, v)
    end
    TriggerClientEvent("setBoitierPortailStatut", source, boitierStatut)
end)

RegisterNetEvent('unlockDoors')
AddEventHandler('unlockDoors', function()
    boitierStatut = false
    TriggerClientEvent("setBoitierPortailStatut", -1, boitierStatut)
    for i,v in pairs(doors) do 
        doors[i].locked = false
        v.locked = false
        TriggerClientEvent("updateDoorStatut", -1, v)
        Wait(100)
    end
end)

