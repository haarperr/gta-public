local character

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' is starting on the client.')
    TriggerServerEvent("onJoin")
    while not character do 
        Wait(500)
    end
    Saver()
    print('The resource ' .. resourceName .. ' has been started on the client.')
end)

RegisterNetEvent('getCharacterCallback')
AddEventHandler('getCharacterCallback', function(c)
    character = c
end)


function DisableReports()
    DisablePoliceReports()
end	


-- THREAD
Citizen.CreateThread(function()
    -- DESACTIVE LES BARRES HP ET ARMOR
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)

    while true do 		
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)

        -- DESACTIVE LA REGEN
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)

        -- DESACTIVE LE HUD ARGENT
        HideHudComponentThisFrame(1)
        HideHudComponentThisFrame(3)
        HideHudComponentThisFrame(4)

        -- DESACTIVE NOM MODEL ET RUE
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        
        
        -- DESACTIVE LES BARRES HP ET ARMOR
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()

        -- RAGDOLL
        if IsControlPressed(1, 58) and not IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) then 		
            SetPedToRagdoll(ped, 1000, 1000, 0, true, true, false) 
        end 	

        -- REMOVE WEAPON DROP
        RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
        RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
        RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun

        -- if GetPlayerWantedLevel(PlayerId()) ~= 0 then
        --     SetPlayerWantedLevel(PlayerId(), 0, false)
        --     SetPlayerWantedLevelNow(PlayerId(), false)
        -- end
        
        DisableReports()

        -- REMOVE SHOTFUN LSPD
        DisablePlayerVehicleRewards(PlayerId())

        -- PVP
        NetworkSetFriendlyFireOption(true)
        SetCanAttackFriendly(ped, true, true)
    end 
end)

-- cache les étoiles police
Citizen.CreateThread(function()
	SetPoliceRadarBlips(false)
    while true do
        Citizen.Wait(0) -- prevent crashing
		if GetPlayerWantedLevel(PlayerId()) ~= 0 then
			HideHudComponentThisFrame(1)
			-- ReplaceHudColourWithRgba(9, 140, 140, 140, 255)
			-- ReplaceHudColourWithRgba(6, 140, 140, 140, 255)
			-- ReplaceHudColourWithRgba(25, 53, 154, 71, 255)
			-- ReplaceHudColourWithRgba(26, 235, 36, 39, 255)
		else
			Citizen.Wait(1000)
		end
    end
end)




SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_HILLBILLY"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_BALLAS"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MEXICAN"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_FAMILY"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MARABUNTE"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_SALVA"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_1"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_2"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_9"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_10"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("FIREMAN"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("MEDIC"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("COP"), GetHashKey('PLAYER'))


-- CACHE RADAR A PIED
Citizen.CreateThread(function()
    while true do
	Citizen.Wait(0)
	
		local playerPed = GetPlayerPed(-1)
		local playerVeh = GetVehiclePedIsIn(playerPed, false)

		if DoesEntityExist(playerVeh) then
			DisplayRadar(true)
		else
			DisplayRadar(false)
		end
    end
end)


-- CACHE LE RETICULE JE CROIS
Citizen.CreateThread( function()
    while true do 
        local ped = GetPlayerPed( -1 )
        if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
            if ( GetFollowPedCamViewMode() ~= 4 and IsPlayerFreeAiming() ) then 
                HideHudComponentThisFrame( 14 )
            end
            Citizen.Wait( 0 )
        else 
            Citizen.Wait( 0 )
        end 
        HideHudComponentThisFrame( 14 )
    end 
end )



-- Je sais pas
Citizen.CreateThread(function() 
    while true do
      N_0xf4f2c0d4ee209e20() 
      Wait(1000)
    end 
end)


Citizen.CreateThread(function() 
    while true do
		Citizen.Wait(0)
		-- SetCanAttackFriendly(GetPlayerPed(-1), true, false) --PvP Enabled
		-- NetworkSetFriendlyFireOption(true)
        SetVehicleDensityMultiplierThisFrame(0.5)
	end
end)




-- SAUVEGARDE DE LA POSITION
function Saver()
    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(60000)
            local ped = GetPlayerPed(-1)
			if (DoesEntityExist(ped) and not IsEntityDead(ped) and not (false and false)) then
                RequestToSave()
            end
        end
    end)
end
function RequestToSave()
    LastPosX, LastPosY, LastPosZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    local LastPosH = GetEntityHeading(GetPlayerPed(-1))
    TriggerServerEvent("savePosition", LastPosX, LastPosY, LastPosZ, LastPosH)
end





-- TELEPORTATION EXPORT
function teleportTo(x, y, z, h, vehicule)
    local ped = GetPlayerPed(-1)
    local hp = GetEntityHealth(ped)
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
    if vehicule then 
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        SetEntityCoordsNoOffset(vehicle, x, y, z, 0, 0, 1)
        SetEntityHeading(vehicle,h)
    else
        RequestCollisionAtCoord(x, y, z)
        NetworkResurrectLocalPlayer(x, y, z, h, true, true, false)
    end
    SetEntityHealth(ped, hp)
    if IsScreenFadedOut() then
        DoScreenFadeIn(500)
        while not IsScreenFadedIn() do
            Citizen.Wait(0)
        end
    end                  
end

exports('teleportTo', teleportTo)


--  ********* COMMANDS  **********************

RegisterCommand("pos", function(source, args, rawcommand)
    local pos = GetEntityCoords(PlayerPedId())
    local posh = GetEntityHeading(GetPlayerPed(-1))
    print(pos.x..", "..pos.y..", "..pos.z..", "..posh)
end, false)


RegisterCommand("saveped", function(source, args, rawcommand)
    print(GetEntityModel(PlayerPedId()))
    TriggerServerEvent("savePedModel", GetEntityModel(PlayerPedId()))
end, false)


RegisterCommand("res", function(source, args, rawcommand)
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped, true)
    revive(pos, ped)
    Wait(0)
end, false)

RegisterCommand("rez", function(source, args, rawcommand)
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped, true)
    revive(pos, ped)
    Wait(0)
end, false)

function revive(pos, ped)
    StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
	NetworkResurrectLocalPlayer(pos, true, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
    TriggerServerEvent("updateCharacterHp", 200)
    TriggerServerEvent("updateCharacterWater", 5)
    TriggerServerEvent("updateCharacterFood", 5)
end


RegisterCommand("delete", function(source, args, rawcommand)
    local pos = GetEntityCoords(PlayerPedId())
    -- local veh = GetClosestVehicle(pos.x, pos.y, pos.z, 5.0, 0, 70)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh < 1 then 
        veh = GetClosestVehicleCustom()
    end
    SetEntityAsMissionEntity(veh, true, true)
    DeleteVehicle(veh)
end, false)



function GetClosestVehicleCustom()
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    local entityWorld = GetOffsetFromEntityInWorldCoords(ply, 0.0, 20.0, 0.0)
    local rayHandle = CastRayPointToPoint(plyCoords["x"], plyCoords["y"], plyCoords["z"], entityWorld.x, entityWorld.y, entityWorld.z, 10, ply, 0)
    local a, b, c, d, targetVehicle = GetRaycastResult(rayHandle)

    if targetVehicle ~= nil then
        return targetVehicle
    else 
        return 0
    end
end





-- *********** GENERAL BLIPS *****************

Citizen.CreateThread(function()

    -- ****** PDP
    local coordsPDP = {x = 428.0, y = -981.5, z = 280.9} 
    local blipPDP = AddBlipForCoord(coordsPDP.x, coordsPDP.y, coordsPDP.z)
    SetBlipSprite(blipPDP, 137)
    AddTextEntry("PDP", "Commissariat")
    BeginTextCommandSetBlipName("PDP") 
    SetBlipColour(blipPDP, 29)
    SetBlipCategory(blipPDP, 2) 
    EndTextCommandSetBlipName(blipPDP)
    SetBlipAsShortRange(blipPDP, true)


    -- ****** EMS
    local coordsEMS = {x = 295.0, y = -583.5, z = 43.9} 
    local blipEMS = AddBlipForCoord(coordsEMS.x, coordsEMS.y, coordsEMS.z)
    SetBlipSprite(blipEMS, 61)
    AddTextEntry("EMS", "Hôpital")
    BeginTextCommandSetBlipName("EMS") 
    SetBlipCategory(blipEMS, 2) 
    SetBlipColour(blipEMS, 3)
    EndTextCommandSetBlipName(blipEMS)
    SetBlipAsShortRange(blipEMS, true)

    
    -- ****** FONDERIE
    local coordsFonderie = {x = 1122.8, y = -1997.4, z = 34.4} 
    local blipFonderie = AddBlipForCoord(coordsFonderie.x, coordsFonderie.y, coordsFonderie.z)
    SetBlipSprite(blipFonderie, 618)
    AddTextEntry("FONDERIE", "Fonderie")
    BeginTextCommandSetBlipName("FONDERIE") 
    SetBlipCategory(blipFonderie, 2) 
    SetBlipColour(blipFonderie, 5)
    EndTextCommandSetBlipName(blipFonderie)
    SetBlipAsShortRange(blipFonderie, true)

    -- ****** CARRIERE DE FER
    local coordsMineFer = {x = 2949.3, y = 2769.4, z = 37.9} 
    local blipMineFer = AddBlipForCoord(coordsMineFer.x, coordsMineFer.y, coordsMineFer.z)
    SetBlipSprite(blipMineFer, 477)
    AddTextEntry("MINEFER", "Carrière de fer")
    BeginTextCommandSetBlipName("MINEFER") 
    SetBlipCategory(blipMineFer, 2)
    EndTextCommandSetBlipName(blipMineFer)
    SetBlipAsShortRange(blipMineFer, true)
end)












-- ********* ANIMATION **********************


-- ANIMATION POINTE DU DOIGT AVEC B

local mp_pointing = false
local keyPressed = false

local function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

local once = true
local oldval = false
local oldvalped = false

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if once then
            once = false
        end

        if not keyPressed then
            if IsControlPressed(0, 29) and not mp_pointing and IsPedOnFoot(PlayerPedId()) and not IsEntityPlayingAnim(GetPlayerPed(-1), "mp_arresting", "idle", 3) then
                Wait(200)
                if not IsControlPressed(0, 29) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while IsControlPressed(0, 29) do
                        Wait(50)
                    end
                end
            elseif (IsControlPressed(0, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(0, 29) then
                keyPressed = false
            end
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = GetPlayerPed(-1)
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

            end
        end
    end
end)

-- ANIMATION BRAS LEVÉ AVEC X
Citizen.CreateThread(function()
    local dict = "missminuteman_1ig_2"
    
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end
    local handsup = false
	while true do
        local ped = GetPlayerPed(-1)
		Citizen.Wait(0)
		if IsControlJustPressed(1, 323) and not IsPedInAnyVehicle(ped, false) and not IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) then --Start holding X
            if not handsup then
                TaskPlayAnim(ped, dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
                handsup = true
            else
                handsup = false
                ClearPedTasks(ped)
            end
        end
        if IsPedRagdoll(ped) or not DoesEntityExist(ped) or IsEntityDead(ped) or (false and false) then 
            handsup = false
            ClearPedTasks(ped)
        end
    end
end)










-- IMPORTATION DU PED VMENU DANS LA BDD

RegisterCommand("importvmenu", function(source, args, rawcommand)
	AddTextEntry('FMMC_KEY_TIP1', "Nom du ped vMenu enregistré")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", 0, "", "", "", 8)
	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0);
		Wait(0);
	end
	if (GetOnscreenKeyboardResult()) then
		local result = GetOnscreenKeyboardResult()
		if result then 
			local jsonString = GetExternalKvpString("vMenu","mp_ped_"..result)
			if jsonString then 
				TriggerServerEvent("saveMpPed", jsonString)
			else 
				TriggerEvent("notifynui", "error", "Save ped", "Ped non trouvé.")
			end
		else
			TriggerEvent("notifynui", "error", "Save ped", "Input invalide.")
		end
	end
end, false)



















