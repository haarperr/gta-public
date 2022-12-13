local ateliers = {
    {organisationId = 5, x = -192.5, y = -1580.85, z = 33.74},
    {type = "minerai", x = 1122.8, y = -1997.4, z = 34.4}
}

RegisterServerEvent("getAteliers")
AddEventHandler("getAteliers", function()
    local _src = source
    TriggerClientEvent("getAteliersCallback", _src, ateliers)
end)