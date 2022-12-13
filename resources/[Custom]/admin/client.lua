local isAdmin = true
local serverId
local organisations
local persos
local items
local character
local players
local playerBlips = {}

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' is starting on the client.')
    TriggerServerEvent("getCharacter")
    TriggerServerEvent("getOrgaList")
    -- TriggerServerEvent("addAdminListener")
    TriggerServerEvent("getServerID")
    Wait(2000)
    TriggerServerEvent("getPersoList")
    TriggerServerEvent("getItemList")
    toggleAdmin(true)
    print('The resource ' .. resourceName .. ' has been started on the client.')
end)



RegisterNetEvent('getCharacterCallback')
AddEventHandler('getCharacterCallback', function(c)
    character = c
end)

RegisterNetEvent('getOrgaCallback')
AddEventHandler('getOrgaCallback', function(res)
    organisations = res
end)

RegisterNetEvent('getPersoCallback')
AddEventHandler('getPersoCallback', function(res)
    persos = res
end)

RegisterNetEvent('getItemCallback')
AddEventHandler('getItemCallback', function(res)
    items = res
end)

RegisterNetEvent('getServerIDCallback')
AddEventHandler('getServerIDCallback', function(res)
    serverId = res
end)

-- RegisterNetEvent('updatePlayerPositionClient')
-- AddEventHandler('updatePlayerPositionClient', function(res)
--     if res then
--         players = res
--         if playerBlips[1] then
--             for i, blip in pairs(playerBlips) do
--                 RemoveBlip(blip)
--             end
--             playerBlips = {}
--         end
--         for i,player in pairs(players) do
--             if player.x ~= nil and player.name and serverId and player.serverId ~= serverId then
--                 local pblip = AddBlipForCoord(player.x, player.y, player.z)
--                 table.insert(playerBlips, pblip)
--                 if player.vehicule then
--                     SetBlipSprite(pblip, 225)
--                 else
--                     SetBlipSprite(pblip, 1)
--                 end
--                 SetBlipAsShortRange(pblip, true)
--                 AddTextEntry('JOUEUR', player.name)
--                 BeginTextCommandSetBlipName('JOUEUR') 
--                 SetBlipCategory(pblip, 7) 
--                 EndTextCommandSetBlipName(pblip)
--             end
--         end
--     end
-- end)



function toggleAdmin(admin)
    if admin then
        isAdmin = false
        isAdmin = true
        Citizen.CreateThread(function()
            menu = exports.menu:CreateMenu({name = "admin", title = 'Admin', subtitle = 'Action', footer = 'Appuyer sur Entrée.'})
            while not organisations or not persos or not items do 
                Wait(100)
            end
            menu.ClearItems(menu)
            persomenu = exports.menu:CreateSubmenu(menu, {name = "persosub", title = 'Personnages', subtitle = 'Changement de personnage', footer = 'Appuyer sur Entrée.'})
            for i,perso in pairs(persos) do 
                persomenu.AddButton(persomenu, {label = 'ID: '..perso.id..' - '..perso.firstName..' '..perso.lastName, select = function()
                    TriggerServerEvent("changeCharacterEvent", perso.id)
                    exports.menu:closeMenu()
                end })
            end
            menu.AddSubmenu(menu, persomenu)
            if character.organisationId then
                orgamenu = exports.menu:CreateSubmenu(menu, {name = "orgasub", title = 'Organisations', subtitle = 'Actuelle : '..character.organisationId, footer = 'Appuyer sur Entrée.'})
            else
                orgamenu = exports.menu:CreateSubmenu(menu, {name = "orgasub", title = 'Organisations', subtitle = 'Choississez une orga ', footer = 'Appuyer sur Entrée.'})
            end
            for i,orga in pairs(organisations) do 
                orgamenu.AddButton(orgamenu, {label = 'ID: '..orga.id..' - '..orga.name, select = function()
                    TriggerServerEvent("changeOrganisation", character.id, orga.id)
                    exports.menu:closeMenu()
                end })
            end
            menu.AddSubmenu(menu, orgamenu)
            itemmenu = exports.menu:CreateSubmenu(menu, {name = "itemsub", title = 'Items', subtitle = 'Liste des items', footer = 'Appuyer sur Entrée.'})
            for i,item in pairs(items) do 
                itemmenu.AddButton(itemmenu, {label = item.name, select = function()
                    exports.menu:closeMenu()
                    AddTextEntry('FMMC_KEY_TIP1', "Quantité")
                    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", 0, "", "", "", 7)
                    while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0);
                        Wait(0);
                    end
                    if (GetOnscreenKeyboardResult()) then
                        local result = tonumber(GetOnscreenKeyboardResult())
                        if result and result > 0 then 
                            TriggerEvent("notifynui", "info", "Admin", result.." "..item.name.." ont été ajouté à l'inventaire.")
                            TriggerServerEvent("updateInventory", item.id, result)
                        else
                            TriggerEvent("notifynui", "error", "Admin", "La quantité saisie est invalide.")
                        end
                    end
                end })
            end
            menu.AddSubmenu(menu, itemmenu)
        end)
    else
        isAdmin = false
    end
end



RegisterKeyMapping('+admin', 'Admin', 'keyboard', 'F9')


RegisterCommand('+admin', function()
    if not exports.menu:isMenuOpen() then
        exports.menu:openMenu(menu)
    else
        exports.menu:closeMenu()
    end
end, false)

RegisterCommand('-admin', function()
end, false)






-- Citizen.CreateThread(function()
--     while true do 
--         Citizen.Wait(300)
--         if DoesEntityExist(GetPlayerPed(-1)) then
--             local pos = GetEntityCoords(GetPlayerPed(-1))
--             local veh = IsPedSittingInAnyVehicle(GetPlayerPed(-1))
--             TriggerServerEvent("updatePlayerPosition", pos, veh)
--         end
--     end
-- end)


Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}