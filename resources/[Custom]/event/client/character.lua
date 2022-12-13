local character 
AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
    TriggerServerEvent("getCharacter")
end)

-- **************************************** EVENTS ************************************* 


RegisterNetEvent('getCharacterCallback')
AddEventHandler('getCharacterCallback', function(c)
    character = c
end)


RegisterNetEvent('deathScreen')
AddEventHandler('deathScreen', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped, true)
    TriggerEvent("sendSos")
    StartScreenEffect('DeathFailOut', 0, false)
    if not IsPedInAnyVehicle(ped, false) then
        SetEntityCoords(ped, pos.x, pos.y, pos.z, true, true, true)
    end
end)

RegisterNetEvent('requestReviveCallback')
AddEventHandler('requestReviveCallback', function()
    StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped, true)
	NetworkResurrectLocalPlayer(pos, true, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
    Wait(0)
end)





-- ******************************* DEATH CAM ********************************************************************

local cam = nil

local isDead = false

local angleY = 0.0
local angleZ = 0.0

Cfg = {}

-- maximum radius the camera will orbit at (in meters)
Cfg.radius = 4.5
--------------------------------------------------
---------------------- LOOP ----------------------
--------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        
        -- process cam controls if cam exists and player is dead
        if (cam and isDead) then
            ProcessCamControls()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        
        if (not isDead and NetworkIsPlayerActive(PlayerId()) and IsPedFatallyInjured(PlayerPedId())) then
            isDead = true
            
            StartDeathCam()
        elseif (isDead and NetworkIsPlayerActive(PlayerId()) and not IsPedFatallyInjured(PlayerPedId())) then
            isDead = false
            
            EndDeathCam()
        end
    end
end)



--------------------------------------------------
------------------- FUNCTIONS --------------------
--------------------------------------------------

-- initialize camera
function StartDeathCam()
    ClearFocus()

    local playerPed = PlayerPedId()
    
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(playerPed), 0, 0, 0, GetGameplayCamFov())

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, false)

    -- StartScreenEffect('DeathFailOut', 0, false)
    SetTimecycleModifier("spectator4")


end

-- destroy camera
function EndDeathCam()
    ClearFocus()

    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(cam, false)
    -- StopScreenEffect('DeathFailOut')
	ClearTimecycleModifier()
    
    cam = nil
end

-- process camera controls
function ProcessCamControls()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    -- disable 1st person as the 1st person camera can cause some glitches
    DisableFirstPersonCamThisFrame()
    
    -- calculate new position
    local newPos = ProcessNewPosition()

    -- focus cam area
    SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)
    
    -- set coords of cam
    SetCamCoord(cam, newPos.x, newPos.y, newPos.z)
    
    -- set rotation
    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 0.5)
end

function ProcessNewPosition()
    local mouseX = 0.0
    local mouseY = 0.0
    
    -- keyboard
    if (IsInputDisabled(0)) then
        -- rotation
        mouseX = GetDisabledControlNormal(1, 1) * 8.0
        mouseY = GetDisabledControlNormal(1, 2) * 8.0
        
    -- controller
    else
        -- rotation
        mouseX = GetDisabledControlNormal(1, 1) * 1.5
        mouseY = GetDisabledControlNormal(1, 2) * 1.5
    end

    angleZ = angleZ - mouseX -- around Z axis (left / right)
    angleY = angleY + mouseY -- up / down
    -- limit up / down angle to 90°
    if (angleY > 89.0) then angleY = 89.0 elseif (angleY < -89.0) then angleY = -89.0 end
    
    local pCoords = GetEntityCoords(PlayerPedId())
    
    local behindCam = {
        x = pCoords.x + ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * (Cfg.radius + 0.5),
        y = pCoords.y + ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * (Cfg.radius + 0.5),
        z = pCoords.z + ((Sin(angleY))) * (Cfg.radius + 0.5)
    }
    local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, PlayerPedId(), 0)
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    
    local maxRadius = Cfg.radius
    if (hitBool and Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords) < Cfg.radius + 0.5) then
        maxRadius = Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords)
    end
    
    local offset = {
        x = ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * maxRadius,
        y = ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * maxRadius,
        z = ((Sin(angleY))) * maxRadius
    }
    
    local pos = {
        x = pCoords.x + offset.x,
        y = pCoords.y + offset.y,
        z = pCoords.z + offset.z
    }
    
    
    -- Debug x,y,z axis
    --DrawMarker(1, pCoords.x, pCoords.y, pCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.03, 0.03, 5.0, 0, 0, 255, 255, false, false, 2, false, 0, false)
    --DrawMarker(1, pCoords.x, pCoords.y, pCoords.z, 0.0, 0.0, 0.0, 0.0, 90.0, 0.0, 0.03, 0.03, 5.0, 255, 0, 0, 255, false, false, 2, false, 0, false)
    --DrawMarker(1, pCoords.x, pCoords.y, pCoords.z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.03, 0.03, 5.0, 0, 255, 0, 255, false, false, 2, false, 0, false)
    
    return pos
end



local lastHp
-- ****** STYLE DE MARCHE BLESSÉ
Citizen.CreateThread(function()
    lastHp = GetEntityHealth(GetPlayerPed(-1))
	while true do
        if lastHp ~= GetEntityHealth(GetPlayerPed(-1)) then 
            TriggerServerEvent("updateCharacterHp", GetEntityHealth(GetPlayerPed(-1)))
            lastHp = GetEntityHealth(GetPlayerPed(-1))
        end
		Wait(0)
		if GetEntityHealth(GetPlayerPed(-1)) <= 130 then
            DisableControlAction(0,21,true)
			setHurt()
		elseif GetEntityHealth(GetPlayerPed(-1)) > 131 then
			setNotHurt()
		end
	end
end)
function setHurt()
	RequestAnimSet("move_m@injured")
	SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
end
function setNotHurt()
	ResetPedMovementClipset(GetPlayerPed(-1))
	ResetPedWeaponMovementClipset(GetPlayerPed(-1))
	ResetPedStrafeClipset(GetPlayerPed(-1))
end
-- ****** FIN



RegisterNetEvent('setCharacterHp')
AddEventHandler('setCharacterHp', function(hp)
    SetEntityHealth(GetPlayerPed(-1), hp)
end)





 -- **************** FOOD *****************
 Citizen.CreateThread(function()
	while true do
        Wait(60000)
        if not isDead then 
            -- TriggerServerEvent("updateCharacterFood", -2)
            -- TriggerServerEvent("updateCharacterWater", -3)
        end
    end
end)












-- **************** MENOTTES *****************************

local handcuffed

RegisterNetEvent('requestHandcuffCallback')
AddEventHandler('requestHandcuffCallback', function(bool)
    exports.qtarget:AllowTargeting(not bool)
    handcuffed = bool
    if bool then 
        Citizen.CreateThread(function()
            RequestAnimDict('mp_arresting')
    
            while not HasAnimDictLoaded('mp_arresting') do
                Citizen.Wait(0)
            end
            while handcuffed do
                if handcuffed and not IsEntityPlayingAnim(PlayerPedId(), 'mp_arresting', 'idle', 3) or IsPedRagdoll(GetPlayerPed(-1)) then
                    Citizen.Wait(0)
                    TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
                end
                Citizen.Wait(0)
            end
        end)
    else
        ClearPedTasks(GetPlayerPed(-1))
    end        
end)

RegisterNetEvent('requestHandcuffClient')
AddEventHandler('requestHandcuffClient', function(d)
    RequestAnimDict('mp_arresting')
    while not HasAnimDictLoaded('mp_arresting') do
        Citizen.Wait(0)
    end
    TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
    TriggerEvent("progressBar", 2)
	Citizen.Wait(2000)
    TriggerServerEvent("requestHandcuff", d.player, d.bool)
    ClearPedTasks(GetPlayerPed(-1))
end)

function GetPlayerFromPed(ped)
	for a = 0, 256 do
        if GetPlayerPed(a) == ped then
			return a
		end
	end
	return -1
end

AddEventHandler('menotter', function(data)
    if not IsEntityPlayingAnim(data.entity, 'mp_arresting', 'idle', 3) then
        TriggerServerEvent("updateInventoryWithCallback", "requestHandcuffClient", {player=GetPlayerServerId(GetPlayerFromPed(data.entity)),bool=true}, 40, -1)
    else
        TriggerEvent("notifynui", "error", "Menotte", "Ce personnage est déjà menotté.")
    end
end)


AddEventHandler('demenotter', function(data)
    if IsEntityPlayingAnim(data.entity, 'mp_arresting', 'idle', 3) then
        TriggerServerEvent("updateInventoryWithCallback", "requestHandcuffClient", {player=GetPlayerServerId(GetPlayerFromPed(data.entity)),bool=false}, 41, -1)
    else
        TriggerEvent("notifynui", "error", "Menotte", "Ce personnage n'est pas menotté.")
    end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)


		if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "mp_arresting", "idle", 3) or handcuffed then
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
			SetPedPathCanUseLadders(GetPlayerPed(PlayerId()), false)
			if IsPedInAnyVehicle(GetPlayerPed(PlayerId()), false) then
				DisableControlAction(0, 59, true)
			end
            if IsPedArmed(GetPlayerPed(-1), 7) then
                SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263, true)
            end
            DisableControlAction(1, 18, true)
            DisableControlAction(1, 24, true)
            DisableControlAction(1, 69, true)
            DisableControlAction(1, 92, true)
            DisableControlAction(1, 106, true)
            DisableControlAction(1, 122, true)
            DisableControlAction(1, 135, true)
            DisableControlAction(1, 142, true)
            DisableControlAction(1, 144, true)
            DisableControlAction(1, 176, true)
            DisableControlAction(1, 223, true)
            DisableControlAction(1, 229, true)
            DisableControlAction(1, 237, true)
            DisableControlAction(1, 257, true)
            DisableControlAction(1, 329, true)
            DisableControlAction(1, 80, true)
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 250, true)
            DisableControlAction(1, 263, true)
            DisableControlAction(1, 310, true)
            DisableControlAction(1, 37, true)

            DisableControlAction(1, 22, true)
            DisableControlAction(1, 55, true)
            DisableControlAction(1, 76, true)
            DisableControlAction(1, 102, true)
            DisableControlAction(1, 114, true)
            DisableControlAction(1, 143, true)
            DisableControlAction(1, 179, true)
            DisableControlAction(1, 193, true)
            DisableControlAction(1, 203, true)
            DisableControlAction(1, 216, true)
            DisableControlAction(1, 255, true)
            DisableControlAction(1, 298, true)
            DisableControlAction(1, 321, true)
            DisableControlAction(1, 328, true)
            DisableControlAction(1, 331, true)
            DisableControlAction(0, 63, false)
            DisableControlAction(0, 64, false)
            DisableControlAction(0, 59, false)
            DisableControlAction(0, 278, false)
            DisableControlAction(0, 279, false)
            DisableControlAction(0, 68, false)
            DisableControlAction(0, 69, false)
            DisableControlAction(0, 76, false)
            DisableControlAction(0, 102, false) 
            DisableControlAction(0, 81, false)
            DisableControlAction(0, 82, false)
            DisableControlAction(0, 83, false)
            DisableControlAction(0, 84, false)
            DisableControlAction(0, 85, false)
            DisableControlAction(0, 86, false) 
            DisableControlAction(0, 106, false)
            DisableControlAction(0, 25, false)
		end

	end
end)




Citizen.CreateThread(function()
    Wait(1000)
    exports.qtarget:RemovePlayer({'Fouiller'})
    exports.qtarget:RemovePlayer({'Menotter'})
    exports.qtarget:RemovePlayer({'Démenotter'})
    exports.qtarget:Player({
        options = {
            {
                event = "fouiller",
                icon = "fas fa-magnifying-glass",
                label = "Fouiller",
                canInteract = function(entity)
                    return character and character.organisationId == 1
                end,
                num = 1
            },{
                event = "menotter",
                icon = "fas fa-handcuffs",
                label = "Menotter",
                canInteract = function(entity)
                    return character and character.organisationId == 1
                end,
                num = 2
            },{
                event = "demenotter",
                icon = "fas fa-key",
                label = "Démenotter",
                canInteract = function(entity)
                    return character and character.organisationId == 1
                end,
                num = 3
            },
        },
        distance = 2
    })
end)
