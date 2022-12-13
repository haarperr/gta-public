-- *** MENU ***

MenuTable = {
    name = 'Menus',
    description = 'Liste de tous les menus',
    length = 0,
    menus = {},
    submenus = {}
}

isOpen = false
currentOpenMenu = nil


-- @func uuid
-- @description Génère un identifiant unique.
local random = math.random
local randomseed = math.randomseed
local function uuid()
    randomseed(GetGameTimer() + random(30720, 92160))
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end


function SendToNUIMessage(action, data)
    SendNUIMessage({
      action = action,
      data = data
    })
end

function toggleNuiFrame(shouldShow)
    SetNuiFocus(shouldShow, false)
    SetNuiFocusKeepInput(shouldShow)
    isOpen = shouldShow
    SendToNUIMessage('setVisible', shouldShow)
    if shouldShow then
        DisableControlAction(0,24) -- INPUT_ATTACK MARCHE PAS CA
        DisableControlAction(0,69) -- INPUT_VEH_ATTACK
        DisableControlAction(0,70) -- INPUT_VEH_ATTACK2
        DisableControlAction(0,92) -- INPUT_VEH_PASSENGER_ATTACK
        DisableControlAction(0,114) -- INPUT_VEH_FLY_ATTACK
        DisableControlAction(0,257) -- INPUT_ATTACK2
        DisableControlAction(0,331) -- INPUT_VEH_FLY_ATTACK2
    else 
        currentOpenMenu = nil
        -- EnableControlAction(2, 1, true)
        -- EnableControlAction(2, 2, true)
        -- EnableControlAction(2, 12, true)
        -- EnableControlAction(2, 13, true)

    end
end

RegisterNUICallback('close', function(data, cb)
    toggleNuiFrame(false)
    cb("")
end)


RegisterNetEvent('close')
AddEventHandler('close', function(c)
    toggleNuiFrame(false)
end)
  

function openMenu(m)
    for i,v in pairs(MenuTable.menus) do 
        if v.uuid == m.uuid then
            local menu = {
                uuid = v.uuid,
                name = v.name,
                title = v.title,
                subtitle = v.subtitle,
                footer = v.footer,
                type = v.type,
                Items = v.Items,
            }
            currentOpenMenu = v
            SendToNUIMessage("sendMenu", menu)
        end
    end
    toggleNuiFrame(true)
end

function closeMenu()
    PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    toggleNuiFrame(false)
end

function isMenuOpen(menu)
    if menu then
        if currentOpenMenu and currentOpenMenu.uuid and menu.uuid == currentOpenMenu.uuid then 
            return true 
        else
            return false
        end
    else
        return isOpen
    end
end


RegisterNUICallback('triggerItem', function(data, cb)
    if data.type == "menu" then 
        for i,menu in pairs(MenuTable.menus) do 
            if menu.uuid == data.menu then 
                for i,v in pairs(menu.Items) do
                    if v.uuid == data.item.uuid then
                        local fn = v.select
                        fn()
                        cb("")
                        return
                    end
                end
            end
        end
    else 
        for i,menu in pairs(MenuTable.submenus) do 
            if menu.uuid == data.menu then 
                for i,v in pairs(menu.Items) do
                    if v.uuid == data.item.uuid then
                        local fn = v.select
                        fn()
                        cb("")
                        return
                    end
                end
            end
        end
    end
    cb("")
end)


RegisterNUICallback('requestMenu', function(data, cb)
    for i,menu in pairs(MenuTable.menus) do 
        if menu.uuid == data.uuid then
            cb(menu)
            return
        end
    end
    cb('')
end)

RegisterNUICallback('requestSubmenu', function(data, cb)
    for i,menu in pairs(MenuTable.submenus) do 
        if menu.uuid == data.uuid then
            cb(menu)
            return
        end
    end
    cb('')
end)

-- ********* GESTION DES MENUS LUA **********************************************

-- @func addMenu
-- @description AJoute un menu dans la liste des menus.
function addMenu(menu)
    for i,p in pairs(MenuTable.menus) do 
        if p.uuid == menu.uuid or menu.name and menu.name == p.name then
            MenuTable.menus[i] = menu
            return
        end
    end
    table.insert(MenuTable.menus, menu)
    MenuTable.length = MenuTable.length + 1
end

-- @func updateMenu
-- @description Update un menu dans la liste des menus.
function updateMenu(menu, item)
    for i,p in pairs(MenuTable.menus) do 
        if p.uuid == menu.uuid then
            table.insert(MenuTable.menus[i].Items, item)
            return
        end
    end
end

-- @func removeMenu
-- @description Supprime un menu dans la liste des menus.
function removeMenu(uuid)
    for i,p in pairs(MenuTable.menus) do
        if p.uuid == uuid then
            table.remove(MenuTable.menus, i)
            MenuTable.length = MenuTable.length - 1
            return printlib("Suppression de "..uuid.." des menus actifs.", 1)
        end
    end
end

-- @func addSubmenu
-- @description AJoute un menu dans la liste des menus.
function addSubmenu(submenu)
    for i,p in pairs(MenuTable.submenus) do 
        if p.uuid == submenu.uuid then
            MenuTable.submenus[i] = submenu
            return
        end
    end
    table.insert(MenuTable.submenus, submenu)
    -- MenuTable.length = MenuTable.length + 1
end

-- @func updateSubenu
-- @description Update un menu dans la liste des menus.
function updateSubmenu(submenu, item)
    for i,p in pairs(MenuTable.submenus) do 
        if p.uuid == submenu.uuid then
            table.insert(MenuTable.submenus[i].Items, item)
            return
        end
    end
end

-- @func removeMenu
-- @description Supprime un menu dans la liste des menus.
function removeSubmenu(uuid)
    for i,p in pairs(MenuTable.submenus) do
        if p.uuid == uuid then
            table.remove(MenuTable.submenus, i)
            MenuTable.length = MenuTable.length - 1
            return printlib("Suppression de "..uuid.." des submenus actifs.", 1)
        end
    end
end


--- Create a new menu
---@param infos table Menu information
---@return Menu New item
function CreateMenu(infos)
    local newMenu = {
        name = infos.name,
        title = infos.title,
        subtitle = infos.subtitle,
        footer = infos.footer,
        uuid = uuid(),
        Items = {},
        type = "menu",
        AddButton = function(t, data)
            local item = {
                uuid = uuid(),
                label = data.label,
                type = "action",
                badge = data.badge,
                select = data.select
            }
            local items = rawget(t, 'Items')
            local newIndex = #items + 1
            rawset(items, newIndex, item)
            updateMenu(t, item)
            return item
        end,
        AddCheckbox = function(t, data)
            local item = {
                uuid = uuid(),
                label = data.label,
                type = "checkbox",
                checked = data.checked,
                select = data.select
            }
            local items = rawget(t, 'Items')
            local newIndex = #items + 1
            rawset(items, newIndex, item)
            updateMenu(t, item)
            return item
        end,
        AddSlider = function(t, data)
            local item = {
                uuid = uuid(),
                label = data.label,
                type = "slider",
                select = data.select,
                value = data.value,
                list = data.list
            }
            local items = rawget(t, 'Items')
            local newIndex = #items + 1
            rawset(items, newIndex, item)
            updateMenu(t, item)
            return item
        end,
        AddSubmenu = function(t, data)
            local item = {
                type = 'submenu',
                label = data.title,
                parentType = 'menu',
                uuid = data.uuid
            }
            local items = rawget(t, 'Items')
            local newIndex = #items + 1
            rawset(items, newIndex, item)
            updateMenu(t, item)
            return item
        end,
        ClearItems = function(t)
            for i,p in pairs(MenuTable.menus) do 
                if p.uuid == t.uuid or p.name == t.name then
                    MenuTable.menus[i].Items = {}
                    return
                end
            end
            return true
        end,
    }
    addMenu(newMenu)
    return newMenu
end

--- Create a new sub menu
---@param infos table Menu information
---@return Menu New item
function CreateSubmenu(parent, infos)
    local newMenu = {
        name = infos.name,
        title = infos.title,
        subtitle = infos.subtitle,
        footer = infos.footer,
        uuid = uuid(),
        Items = {},
        type = "submenu",
        parentType = parent.type,
        parent = parent.uuid,
        AddButton = function(t, data)
            local item = {
                uuid = uuid(),
                label = data.label,
                type = "action",
                badge = data.badge,
                select = data.select
            }
            local items = rawget(t, 'Items')
            local newIndex = #items + 1
            rawset(items, newIndex, item)
            updateSubmenu(t, item)
            return item
        end,
        AddCheckbox = function(t, data)
            local item = {
                uuid = uuid(),
                label = data.label,
                type = "checkbox",
                checked = data.checked,
                select = data.select
            }
            local items = rawget(t, 'Items')
            local newIndex = #items + 1
            rawset(items, newIndex, item)
            updateSubmenu(t, item)
            return item
        end,
        AddSlider = function(t, data)
            local item = {
                uuid = uuid(),
                label = data.label,
                type = "slider",
                select = data.select,
                value = data.value,
                list = data.list
            }
            local items = rawget(t, 'Items')
            local newIndex = #items + 1
            rawset(items, newIndex, item)
            updateSubmenu(t, item)
            return item
        end,
        AddSubmenu = function(t, data)
            local item = {
                type = 'submenu',
                label = data.title,
                uuid = data.uuid,
                parentType = rawget(t, 'type'),
                parent = rawget(t, 'uuid')
            }
            local items = rawget(t, 'Items')
            local newIndex = #items + 1
            rawset(items, newIndex, item)
            updateSubmenu(t, item)
            return item
        end,
        ClearItems = function(t)
            for i,p in pairs(MenuTable.submenus) do 
                if p.uuid == t.uuid or p.name == t.name then
                    MenuTable.submenus[i].Items = {}
                    return
                end
            end
            return true
        end,
    }
    addSubmenu(newMenu)
    return newMenu
end





-- ************************************************************************************












-- *************** EXAMPLES ***************************************
Citizen.CreateThread(function()
    Wait(2000)
    -- local menu = CreateMenu("test", {title = "Mon menu", subtitle = "Mon sous-titre", footer = "En bas oé"})
    -- menu.AddButton(menu, {label = "Actionne moi", select = function() 
    --     print("testé et approuvé")
    -- end})
    -- menu.AddCheckbox(menu, {label = "Oééé checked", checked = true, select = function(checked) 
    --     print("checked")
    -- end})
    -- -- local submenu = CreateSubmenu({label = "Submenu 1"})
    -- -- submenu.AddButton(submenu, {label = "Actionne moi", select = function() 
    -- --     print("submenu 1 on y é")
    -- -- end})
    -- -- local submenu2 = CreateSubmenu({label = "Submenu 1"})
    -- -- submenu2.AddButton(submenu2, {label = "Actionne moi", select = function() 
    -- --     print("submenu 2 victoire")
    -- -- end})
    -- -- submenu.AddSubmenu(submenu, submenu2)
    -- -- menu.AddSubmenu(menu, submenu)
    -- openMenu(menu)
    

end)
-- *************** ********* ***************************************


RegisterNUICallback('sound', function(data, cb)
    PlaySoundFrontend(-1, data.type, "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    cb('')
end)




exports('CreateMenu', CreateMenu)
exports('CreateSubmenu', CreateSubmenu)
exports('openMenu', openMenu)
exports('closeMenu', closeMenu)
exports('isMenuOpen', isMenuOpen)
