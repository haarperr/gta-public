local isOpen = false
local disable = true
local character

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' is starting on the client.')
	while character == nil do 
        Wait(500)
        TriggerServerEvent("getCharacter")
    end
    print('The resource ' .. resourceName .. ' has been started on the client.')
end)

RegisterNetEvent('getCharacterCallback')
AddEventHandler('getCharacterCallback', function(c)
    character = c
	local organisationId 
	if c.organisationId and c.organisationId < 5 then 
		organisationId = character.organisationId
	end
	SendNUIMessage({
		type = "setcid",
		phone = character.phone,
		cid = character.id,
		organisationId = organisationId,
	})
end)

function sendMessage()
	SendNUIMessage({
		type = data.type,
		data = data.data,
	})
end

function toggleShow(shouldShow)
	local ped = GetPlayerPed(-1)
	if not IsPedRagdoll(ped) and DoesEntityExist(ped) and not IsEntityDead(ped) and not IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) then
		SendNUIMessage({
			type = "enableui",
			enable = shouldShow,
		})
		SetNuiFocus(shouldShow, false)
		SetNuiFocusKeepInput(shouldShow)
		isOpen = shouldShow
		showPhone = shouldShow
		if shouldShow then 
			local t, h = GetCurrentPedWeapon(GetPlayerPed(-1))
			if GetCurrentPedWeapon(GetPlayerPed(-1)) and h ~= -2000187721 then
				SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263)
			end
			ePhoneInAnim()
		else
			ePhoneOutAnim()
		end
	end
end

RegisterNetEvent('togglePhoneEnable')
AddEventHandler('togglePhoneEnable', function(data)
	disable = data
	SendNUIMessage({
		type = "disable",
		disable = disable,
	})
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        if IsControlJustPressed(1, 288) then
			local ped = GetPlayerPed(-1)
			if (DoesEntityExist(ped) and not IsEntityDead(ped) and not IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) and not disable and not IsPedRagdoll(ped)) then
				if isOpen == false then
					toggleShow(true)
				else
					toggleShow(false)
				end
			end
        end
    end
end)

RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
	isOpen = false
	ePhoneOutAnim()
	showPhone = false
    cb("")
end)


RegisterNUICallback('inputs', function(data, cb)
	if data.enable then 
		SetNuiFocus(true, false)
		SetNuiFocusKeepInput(true)
	else
		SetNuiFocus(true, true)
		SetNuiFocusKeepInput(false)
	end
    cb("")
end)


RegisterNUICallback('notify', function(data, cb)
	TriggerEvent("notify", data.message)
    cb("")
end)


RegisterNUICallback('openchannel', function(data, cb)
	if data.enable then
		exports['pma-voice']:addPlayerToCall(tonumber(data.id))
	else
		exports['pma-voice']:removePlayerFromCall(tonumber(data.id))
	end
    cb("")
end)

RegisterNUICallback('getCoord', function(data, cb)
    local curCoords = GetEntityCoords(PlayerPedId())
    local retData = { x = curCoords.x, y = curCoords.y, z = curCoords.z }
    cb(retData)
end)


RegisterNetEvent('sendSos')
AddEventHandler('sendSos', function(c)
	local coords = GetEntityCoords(GetPlayerPed(-1),1)
	SendNUIMessage({
		type = "sendSos",
		coords = {
			x = coords.x,
			y = coords.y,
			z = coords.z
		}
	})
end)


RegisterNetEvent('sendPoliceMsg')
AddEventHandler('sendPoliceMsg', function(msg)
	local coords = GetEntityCoords(GetPlayerPed(-1),1)
	SendNUIMessage({
		type = "sendPoliceMsg",
		coords = {
			x = coords.x,
			y = coords.y,
			z = coords.z
		},
		message = msg
	})
end)


RegisterNUICallback('setGPS', function(data, cb)
    SetNewWaypoint(data.x, data.y)
    cb('')
end)



-- *************** ANIMATION **************************************************************

enable_phone = true
showPhone = false
--------------------------------------------------------------------------------
--					Threads
--------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1)
		-- if IsPlayerPlayingAnimation() and showPhone then
		-- 	ePhoneHide()
		-- 	SetPedCanRagdoll(GetPlayerPed(-1), false)
		-- else
		-- 	SetPedCanRagdoll(GetPlayerPed(-1), true)
		-- end

		-- Hide phone if player is dead
		if IsPlayerDead(PlayerId()) or IsPedRagdoll(GetPlayerPed(-1)) then
			-- ePhoneHide()
			toggleShow(false)
		end

		-- Enable phone
		-- if enable_phone then
		-- 	if IsControlJustPressed(0, 288) then
		-- 		ePhoneShow()
		-- 	elseif IsControlJustPressed(0, 288) then
		-- 		ePhoneHide()
		-- 	elseif IsControlJustPressed(0, 177) then
		-- 		ePhoneHide()
		-- 	end
		-- end

		-- Hide phone if player holds a weapon
		local t, h = GetCurrentPedWeapon(GetPlayerPed(-1))
		if GetCurrentPedWeapon(GetPlayerPed(-1)) and h ~= -2000187721 then
            if isOpen == true then 
                toggleShow(false)
            end
		end


		if not isOpen then 
			local playerPed = GetPlayerPed(-1)
			local coords = GetEntityCoords(playerPed)
			local closestPhone = GetClosestObjectOfType(coords.x, coords.y, coords.z, 0.3, 'prop_npc_phone_02', false)
			if closestPhone and GetEntityAttachedTo(closestPhone) == playerPed then  
				SetEntityAsMissionEntity(closestPhone, true, true)
				DeleteObject(closestPhone)
				SetEntityAsNoLongerNeeded(closestPhone)
			end
		end
	end
end)

--------------------------------------------------------------------------------
--									CALLBACKS
--------------------------------------------------------------------------------
RegisterNUICallback("phoneClose", function(data, cb)
	toggleShow(false)
    cb("")
end)

function IsPlayerPlayingAnimation()
	if IsPlayerClimbing(PlayerId()) or IsPlayerDead(PlayerId()) or
	 IsPedJumpingOutOfVehicle(GetPlayerPed(-1))
	or IsPedTryingToEnterALockedVehicle(GetPlayerPed(-1)) or
	GetCurrentPedWeapon(GetPlayerPed(-1)) then
		return true
	else
		return false
	end
end

function ePhoneShow()
	local ped = GetPlayerPed(-1)
	if not showPhone and not IsPedRagdoll(ped) and DoesEntityExist(ped) and not IsEntityDead(ped) and not IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) then
		local t, h = GetCurrentPedWeapon(GetPlayerPed(-1))
		if GetCurrentPedWeapon(GetPlayerPed(-1)) and h ~= -2000187721 then
			SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263)
		end
		ePhoneInAnim()
		showPhone = true
	end
end

function ePhoneHide()
	if showPhone then
		toggleShow(false)
	end
end

function IsPlayerUsingPhone()
	if showPhone then
		return true
	else
		return false
	end
end

--------------------------------------------------------------------------------
--									EVENTS
--------------------------------------------------------------------------------

-- RegisterNetEvent("telefon:deschide")
-- AddEventHandler("telefon:deschide", function()
-- 	enable_phone = true
-- end)

-- RegisterNetEvent("telefon:inchide")
-- AddEventHandler("telefon:inchide", function()
-- 	enable_phone = false
-- 	ePhoneHide()
-- end)

-- RegisterNetEvent("telefon:arata")
-- AddEventHandler("telefon:arata", function()
-- 	ePhoneShow()
-- end)

-- RegisterNetEvent("telefon:ascunde")
-- AddEventHandler("telefon:ascunde", function()
-- 	ePhoneHide()
-- end)



local inAnim = "cellphone_text_in"
local outAnim = "cellphone_text_out"
local idleAnim = "cellphone_text_read_base"

local phoneProp = 0
local phoneModel = "prop_npc_phone_02"

--------------------------------------------------------------------------------
--								FUNCTIONS
--------------------------------------------------------------------------------
function newPhoneProp()
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	RequestModel(phoneModel)
	while not HasModelLoaded(phoneModel) do
		Citizen.Wait(100)
	end
	return CreateObject(phoneModel, 1.0, 1.0, 1.0, 1, 1, 0)
end

function ePhoneInAnim()
	if IsPlayerDead(PlayerId()) then
		return
	end
	local bone = GetPedBoneIndex(GetPlayerPed(-1), 28422)
	local dict = "cellphone@"
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		dict = dict .. "in_car@ds"
	end

	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end

	TaskPlayAnim(GetPlayerPed(-1), dict, inAnim, 4.0, -1, -1, 50, 0, false, false, false)
	Citizen.Wait(157)
	phoneProp = newPhoneProp()
	AttachEntityToEntity(phoneProp, GetPlayerPed(-1), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
end

function ePhoneIdleAnim()
	if IsPlayerDead(PlayerId()) then
		return
	end
	local dict = "cellphone@"
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		dict = dict .. "in_car@ds"
	end
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end
	TaskPlayAnim(GetPlayerPed(-1), dict, idleAnim, 1.0, -1, -1, 50, 0, false, false, false)
end

function ePhoneOutAnim()
	if IsPlayerDead(PlayerId()) then
		return
	end
	local dict = "cellphone@"
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		dict = dict .. "in_car@ds"
	end

	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(1)
	end
	if GetCurrentPedWeapon == 1 then
		ClearPedSecondaryTask(GetPlayerPed(-1))
		return
	end
	if inCall then
		StopAnimTask(GetPlayerPed(-1), dict, callAnim, 1.0)
		TaskPlayAnim(GetPlayerPed(-1), dict, outAnim, 5.0, -1, -1, 50, 0, false, false, false)
		inCall = false
	elseif not inCall then
		StopAnimTask(GetPlayerPed(-1), dict, inAnim, 1.0)
		TaskPlayAnim(GetPlayerPed(-1), dict, outAnim, 100.0, -1, -1, 50, 0, false, false, false)
	end
	Citizen.Wait(700)
	DeleteObject(phoneProp)
	Citizen.Wait(500)
	StopAnimTask(GetPlayerPed(-1), dict, outAnim, 10.0)
end

AddEventHandler('onResourceStop', function(resourceName)
	DeleteObject(phoneProp)
end)

RegisterNetEvent('removePhone')
AddEventHandler('removePhone', function(c)
	DeleteObject(phoneProp)
	SendNUIMessage({
		type = "enableui",
		isOpen = false,
		phone = character.phone,
		cid = character.id,
	})
end)