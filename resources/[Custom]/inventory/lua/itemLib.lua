

function revive(item)
    Citizen.CreateThread(function()
        local ped = GetPedInFront()
        local playerPed = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped, true)
        if ped > 0 and GetEntityHealth(ped) == 0 then 
            RequestAnimDict("mini@cpr@char_a@cpr_def")
            while not HasAnimDictLoaded( "mini@cpr@char_a@cpr_def") do
                Citizen.Wait(1)
            end
            
            RequestAnimDict("mini@cpr@char_a@cpr_str")
            while not HasAnimDictLoaded( "mini@cpr@char_a@cpr_str") do
                Citizen.Wait(1)
            end
            FreezeEntityPosition(playerPed, true)
            TaskPlayAnim(GetPlayerPed(-1),"mini@cpr@char_a@cpr_def", "cpr_intro", 1.0,-1.0, 3000, 1, 1, false, false, false)
            Wait(3000)
            TaskPlayAnim(GetPlayerPed(-1),"mini@cpr@char_a@cpr_str", "cpr_pumpchest", 1.0,-1.0, 7000, 1, 1, false, false, false)
            Wait(7000)
            TaskPlayAnim(GetPlayerPed(-1),"mini@cpr@char_a@cpr_str", "cpr_success", 1.0,-1.0, 7000, 1, 1, false, false, false)
            Wait(7000)
            FreezeEntityPosition(playerPed, false)
            local player = GetPlayerFromPed(ped)
            if player ~= -1 then 
                TriggerServerEvent("requestRevive", GetPlayerServerId(player))
            else
                ReviveInjuredPed(ped)
                SetEntityHealth(ped, GetPedMaxHealth(ped))
                SetEntityCoordsNoOffset(ped, pos.x, pos.y, pos.z+1, false, false, false, true)
                SetPedToRagdoll(ped, 1000, 1000, 0, true, true, false) 
                SetPlayerInvincible(ped, false)
                ClearPedBloodDamage(ped)
            end
            TriggerServerEvent("updateInventory", item.Item.id, -1)
            TriggerEvent("notifynui", "info", "EMS", "Vous avez utilisé un défibrilateur.")
            isInAnimation = false
            -- NetworkResurrectLocalPlayer(pos, true, true, false)
            -- SetPlayerInvincible(ped, false)
            -- ClearPedBloodDamage(ped)
        else
            TriggerEvent("notifynui", "error", "EMS", "Pas de personne dans le coma devant vous.")
            isInAnimation = false
        end
    end)
end

function pansement(item)
    Citizen.CreateThread(function()
        local ped = GetPlayerPed(-1)
        RequestAnimDict('amb@medic@standing@timeofdeath@enter')
        while not HasAnimDictLoaded('amb@medic@standing@timeofdeath@enter') do
            Citizen.Wait(0)
        end
        local coords = GetEntityCoords(ped)
        TaskPlayAnim(GetPlayerPed(-1), 'amb@medic@standing@timeofdeath@enter', 'enter', 2.0, 8.0,-1, 2, 0, 0, 0, 0)
        TriggerEvent("progressBar", 8)
        Citizen.Wait(2500)
        local prop = CreateObject(GetHashKey('prop_ld_health_pack'), coords + vector3(0.0, 0.0, 0.2),  true,  true, true)
        AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 60309), 0.0, -0.02, 0.0, 90.0, 0.0, 0.0, true, true, false, true, 1, true)
        Citizen.Wait(5500)
        DeleteObject(prop)
        ClearPedTasks(ped)
        local hp = GetEntityHealth(ped)
        if hp+50 > 200 then 
            SetEntityHealth(ped, 200)
        else
            SetEntityHealth(ped, hp+50)
        end
        ClearPedBloodDamage(ped)
        TriggerServerEvent("updateInventory", item.Item.id, -1)
        TriggerEvent("notifynui", "info", "EMS", "Vous avez utilisé un pansement.")
        isInAnimation = false
    end)
end



function checkVehHp()
    local veh = GetClosestVehicleCustom()
    local ped = GetPlayerPed(-1)
    if veh ~= 0 then 
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true);
        TriggerEvent("progressBar", 2)
        Citizen.Wait(2000)
        TriggerEvent("notifynui", "info", "Valise auto", "Carrosserie : "..math.floor(GetVehicleBodyHealth(veh)/10).."%")
        Citizen.Wait(100)
        TriggerEvent("progressBar", 2)
        Citizen.Wait(2000)
        TriggerEvent("notifynui", "info", "Valise auto", "Moteur : "..math.floor(GetVehicleEngineHealth(veh)/10).."%")
        Citizen.Wait(100)
        TriggerEvent("progressBar", 2)
        Citizen.Wait(2000)
        TriggerEvent("notifynui", "info", "Valise auto", "Réservoir : "..math.floor(GetVehiclePetrolTankHealth(veh)/10).."%")
        ClearPedTasks(ped)
        isInAnimation = false
    else
        TriggerEvent("notifynui", "info", "Valise auto", "Aucun véhicule devant vous.")
        isInAnimation = false
    end
end


function kitMoteur(item)
    local veh = GetClosestVehicleCustom()
    local ped = GetPlayerPed(-1)
    if veh ~= 0 then
        TriggerServerEvent("updateInventory", item.Item.id, -1)
        SetVehicleDoorOpen(veh, 4, false, false)
        TaskStartScenarioInPlace(ped, "PROP_HUMAN_BBQ", 0, true);
        TriggerEvent("progressBar", 35)
        Citizen.Wait(35000)
        SetEntityAsMissionEntity(veh, true, true)
        NetworkRequestControlOfEntity(veh)
        SetVehicleDoorShut(veh, 4, false)
        SetVehicleEngineHealth(veh, 1000.0)
        SetVehiclePetrolTankHealth(veh, 1000.0)
        TriggerEvent("notify", "Moteur réparé")
        ClearPedTasks(ped)
        isInAnimation = false
    else
        TriggerEvent("notify", "Aucun véhicule devant vous.")
        isInAnimation = false
    end
end

function kitCarrosserie(item)
    local veh = GetClosestVehicleCustom()
    local ped = GetPlayerPed(-1)
    if veh ~= 0 then 
        TriggerServerEvent("updateInventory", item.Item.id, -1)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true);
        TriggerEvent("progressBar", 20)
        Citizen.Wait(20000)
        SetEntityAsMissionEntity(veh, true, true)
        NetworkRequestControlOfEntity(veh)
        SetVehicleFixed(veh)
        SetVehicleDeformationFixed(veh)
        SetVehicleBodyHealth(veh, 1000.0)
        TriggerEvent("notify", "Carrosserie réparée")
        ClearPedTasks(ped)
        isInAnimation = false
    else
        TriggerEvent("notify", "Aucun véhicule devant vous.")
        isInAnimation = false
    end
end



function burger(item)
    TriggerServerEvent("updateInventory", item.Item.id, -1)
    if item.Item.id == 3 then 
        local dict = "mp_player_inteat@burger"
        local anim = "mp_player_int_eat_burger_fp"
        local coords = GetEntityCoords(PlayerPedId())
        local prop = CreateObject(GetHashKey('prop_cs_burger_01'), coords + vector3(0.0, 0.0, 0.2),  true,  true, true)
        AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.12, 0.028, 0.031, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

        RequestAnimDict(dict)

        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(5)
        end
        TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, -8, -1, 49, 0, 0, 0, 0)
        TriggerEvent("progressBar", 5)
        Wait(5000)
        ClearPedSecondaryTask(PlayerPedId())
        DeleteObject(prop)
        TriggerServerEvent("updateCharacterWater", -6)
        TriggerServerEvent("updateCharacterFood", 50)
        isInAnimation = false
    end
    isInAnimation = false
end

function eau(item)
    TriggerServerEvent("updateInventory", item.Item.id, -1)
    local dict = "mp_player_intdrink"
    local anim = "loop_bottle_fp"
    local coords = GetEntityCoords(PlayerPedId())
    local prop = CreateObject(GetHashKey('prop_ld_flow_bottle'), coords + vector3(0.0, 0.0, 0.2),  true,  true, true)
    AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.12, 0.0, 0.02, -80.0, 80.0, 0.0, true, true, false, true, 1, true)

    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(5)
    end
    TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 8.0, -1, 49, 0, 0, 0, 0)
    TriggerEvent("progressBar", 2)
    Wait(2000)
    TriggerServerEvent("updateCharacterWater", 70)
    ClearPedTasks(PlayerPedId())
    ClearPedSecondaryTask(PlayerPedId())
    DeleteObject(prop)
    isInAnimation = false
end


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

function lockpick(item)
    Citizen.CreateThread(function()
        local ped = GetPlayerPed(-1)
        local veh = GetClosestVehicleCustom()
        local pos = GetEntityCoords(ped)
        if veh > 0 then
            TriggerServerEvent("updateInventory", item.Item.id, -1)
            SetVehicleAlarmTimeLeft(veh, 40000)
            RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
            while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@') do
                Citizen.Wait(0)
            end
            TaskPlayAnim(ped, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@' , 'machinic_loop_mechandplayer' ,8.0, -8.0, -1, 1, 0, false, false, false )
            TriggerEvent("progressBar", 30)
            Wait(30000)
            ClearPedTasksImmediately(ped)
            if not cancelAnimation then
                local i = math.random(1, 10)
                if i > 1 then
                    SetEntityAsMissionEntity(veh, true, true)
                    NetworkRequestControlOfEntity(veh)
                    Wait(100)
                    SetVehicleDoorsLocked(veh, 1)
                    SetVehicleDoorsLockedForAllPlayers(veh, false)
                    TriggerServerEvent("requestUnlock", playerServerId, veh)
                    TriggerEvent("notifynui", "success", "Lockpick", "Véhicule déverrouillé.")
                    -- TaskEnterVehicle(ped, veh, 10.0, -1, 1.0, 1, 0)
                else
                    TriggerEvent("notifynui", "error", "Lockpick", "Ton lockpick vient de se casser.")
                end
            end
        else
            TriggerEvent("notifynui", "error", "Lockpick", "Aucun véhicule en face de toi.")
        end
        isInAnimation = false
    end)
end

function menotter(item)
    Citizen.CreateThread(function()
        local ped = GetPlayerPed(-1)
        local nearestPed = GetPedInFront()
        if nearestPed then
            if not IsEntityPlayingAnim(nearestPed, "mp_arresting", "idle", 3) then 
                local nearestPlayer = GetPlayerServerId(GetPlayerFromPed(nearestPed))
                if nearestPlayer then 
                    TriggerServerEvent("updateInventoryWithCallback", "requestHandcuffClient", {player=nearestPlayer,bool=true}, item.Item.id, -1)
                end
            else
                TriggerEvent("notifynui", "error", "Menotte", "Ce personnage est déjà menotté.")
            end
        else
            TriggerEvent("notifynui", "error", "Menotte", "Aucun personnage trouvé devant toi.")
        end
        isInAnimation = false
    end)
end


function demenotter(item)
    Citizen.CreateThread(function()
        local ped = GetPlayerPed(-1)
        local nearestPed = GetPedInFront()
        if nearestPed then
            if IsEntityPlayingAnim(nearestPed, "mp_arresting", "idle", 3) then 
                local nearestPlayer = GetPlayerServerId(GetPlayerFromPed(nearestPed))
                if nearestPlayer then 
                    TriggerServerEvent("updateInventoryWithCallback", "requestHandcuffClient", {player=nearestPlayer,bool=false}, item.Item.id, -1)
                end
            else
                TriggerEvent("notifynui", "error", "Menotte", "Ce personnage n'est pas menotté.")
            end
        else
            TriggerEvent("notifynui", "error", "Menotte", "Aucun personnage trouvé devant toi.")
        end
        isInAnimation = false
    end)
end


function joint(item)
    Citizen.CreateThread(function()
        isInAnimation = false
        local ped = GetPlayerPed(-1)
        RequestAnimDict("amb@world_human_smoking_pot@male@base") 
        while not HasAnimDictLoaded("amb@world_human_smoking_pot@male@base") do
            Citizen.Wait(0)
        end
        TaskPlayAnim(ped, "amb@world_human_smoking_pot@male@base", "base", 8.0, 8.0,-1, 49, 0, 0, 0, 0)
        local x,y,z = table.unpack(GetEntityCoords(ped))
        local prop = CreateObject(GetHashKey('prop_sh_joint_01'), x, y, z + 0.2, true, true, true)
        AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 18905), 0.14, 0.018, 0.052, 10.0, 155.0, 90.0, true, true, false, true, 1, true)
        TriggerServerEvent("updateInventory", item.Item.id, -1)
        Wait(500)
        Citizen.CreateThread(function()
            local smoking = true
            while smoking do 
                Wait(0)
                AddTextEntry("INPUT", "Appuyez sur la touche ~INPUT_FRONTEND_RRIGHT~ pour arrêter de fumer.")
                DisplayHelpTextThisFrame("INPUT", false)
                if IsControlJustPressed(1, 194) or IsPedRagdoll(ped) or not DoesEntityExist(ped) or IsEntityDead(ped) or not IsEntityPlayingAnim(ped, "amb@world_human_smoking_pot@male@base", "base", 3) then
                    smoking = false
                    DeleteObject(prop)
                    ClearPedTasks(ped)
                end
            end
        end)
        Wait(5000)
        local ped = GetPlayerPed(-1)
        SetTimecycleModifier("drug_flying_01")
        SetPedMotionBlur(ped, true)
        Citizen.CreateThread(function()
            local ped = GetPlayerPed(-1)
            Wait(60000)
            if IsEntityPlayingAnim(ped, "amb@world_human_smoking_pot@male@base", "base", 3) then 
                DeleteObject(prop)
                ClearPedTasks(ped)
            end
            Wait(60000)
            if not IsEntityDead(ped) then
                ClearTimecycleModifier()
            end
            SetPedMotionBlur(ped, false)
        end)
        TriggerServerEvent("updateCharacterWater", -5)
        TriggerServerEvent("updateCharacterFood", -5)
    end)
end



-- *************** VENTE POCHON ************************************
local saleActive = false
local currentPed
local rand = 0
local waitForSale = false
local salePos
local clientBlip

function ventePochonWeed()
    isInAnimation = false
    if saleActive then 
		TriggerEvent("notifynui", "warning", "Vente de drogue", "Vous arrêter de chercher des clients.")
		saleActive = false 
	else 
		saleActive = true
		TriggerEvent("notifynui", "info", "Vente de drogue", "Vous commencez à chercher des clients.")
		rechercheClientPochon()
	end
end

function ifSaleActive()
	return saleActive
end

function rechercheClientPochon()
	Citizen.CreateThread(function()
		Wait(1000)
		while ifSaleActive() do
			local playerPed = GetPlayerPed(-1)
			local coords = GetEntityCoords(playerPed)
			if not waitForSale then
				Wait(10000)
				math.randomseed(GetGameTimer())
				local rangeX = math.random(20.0,35.0)+0.01
				local rangeY = math.random(20.0,35.0)+0.01
				local ped = GetRandomPedAtCoord(coords.x,coords.y,coords.z, rangeX, rangeY, 10.0, -1);
				if DoesEntityExist(ped) and IsPedDeadOrDying(ped) == false then
					if IsPedInAnyVehicle(playerPed) == false or (IsPedInAnyVehicle(playerPed) and (GetVehicleClass(GetVehiclePedIsIn(playerPed, false)) == 8 or GetVehicleClass(GetVehiclePedIsIn(playerPed, false)) == 13)) then
						local pedType = GetPedType(ped)
						if pedType ~= 28 and IsPedAPlayer(ped) == false then
							local pos = GetEntityCoords(ped)
							salePos = pos
							if ped  ~= GetPlayerPed(-1) then
								if ped ~= currentPed then
									currentPed = ped
									local rand = math.random(0,10)
									if rand > 5 and ifSaleActive() then 
										waitForSale = true
										TriggerEvent("notifynui", "info", "Vente de drogue", "Tu as trouvé un client.")
										SetEntityAsMissionEntity(ped)
										ClearPedTasks(ped)
										local dx = coords.x - pos.x
										local dy = coords.y - pos.y
										local heading = GetHeadingFromVector_2d(dx, dy)
										SetEntityHeading(ped, heading)
										TaskStandStill(ped, 9.0)
										clientBlip = AddBlipForCoord(pos.x, pos.y, pos.z)
										SetBlipColour(clientBlip,5)
										BeginTextCommandSetBlipName("STRING")
										AddTextComponentString("Client")
										EndTextCommandSetBlipName(clientBlip)
									else
							            TriggerEvent("notifynui", "info", "Vente de drogue", "Continue de chercher.")
									end
								else
                                    TriggerEvent("notifynui", "info", "Vente de drogue", "Continue de chercher.")
								end
										
							end
						end
					end
				else
                    if (IsPedInAnyVehicle(playerPed) == false or (IsPedInAnyVehicle(playerPed) and (GetVehicleClass(GetVehiclePedIsIn(playerPed, false)) == 8 or GetVehicleClass(GetVehiclePedIsIn(playerPed, false)) == 13))) and ifSaleActive() then
				        local test = GetRandomPedAtCoord(coords.x,coords.y,coords.z, 100.1, 100.1, 10.0, -1);
                        if DoesEntityExist(ped) and IsPedDeadOrDying(ped) == false then
                            TriggerEvent("notifynui", "info", "Vente de drogue", "Il n'y a personne par ici.")
                        else
                            TriggerEvent("notifynui", "info", "Vente de drogue", "Continue de chercher.")
                        end
                        Wait(10000)
                    end
				end
			else
				Wait(0)
				local pos = GetEntityCoords(currentPed)
				local distanceToPed = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)
				local distancePedToSaleLocation = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, salePos.x, salePos.y, salePos.z, true)
				DrawMarker(27, pos.x, pos.y, pos.z-0.99, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 255, 170, 0, 255, 0, 0, 2, 0, nil, nil, 0)
				if distanceToPed < 2 and not IsPedRagdoll(playerPed) and DoesEntityExist(playerPed) and not IsEntityDead(playerPed) and not IsPedInAnyVehicle(playerPed) and ifSaleActive() then 
					AddTextEntry("DEAL", "Appuyez sur la touche ~INPUT_CONTEXT~ pour vendre un pochon.")
					DisplayHelpTextThisFrame("DEAL", false)
					if IsControlJustPressed(1, 51) then
                        TriggerServerEvent("updateInventoryWithCallback", "event:inventoryCallbackVente", {}, 21, -1)
                        Wait(5000)
                        waitForSale = false
					end
				end
				if not DoesEntityExist(currentPed) or IsPedDeadOrDying(currentPed) or distanceToPed > 120 or distancePedToSaleLocation > 5 and ifSaleActive() then
					waitForSale = false
					SetPedAsNoLongerNeeded(currentPed)
					TriggerEvent("notifynui", "error", "Vente de drogue", "Le client est parti.")
					if DoesBlipExist(clientBlip) then
						RemoveBlip(clientBlip)
					end
					Wait(10000)
				end
			end
		end
	end)
end

RegisterNetEvent("event:inventoryCallbackVente")
AddEventHandler("event:inventoryCallbackVente", function(p, pochonRestant)
    local playerPed = GetPlayerPed(-1)
    local dict = "mp_common"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
    FreezeEntityPosition(playerPed,true)
    FreezeEntityPosition(currentPed,true)
    TaskPlayAnim(playerPed, dict, "givetake1_a", 8.0, 8.0, 2000, 50, 0, false, false, false)
    TaskPlayAnim(currentPed, dict, "givetake1_a", 8.0, 8.0, 2000, 50, 0, false, false, false)
    TriggerEvent("notifynui", "success", "Vente de drogue", "Vous avez vendu un pochon pour 350$.")
    TriggerServerEvent("updateInventory", 43, 350)
    waitForSale = false
    Wait(2000)
    FreezeEntityPosition(playerPed,false)
    FreezeEntityPosition(currentPed,false)
    SetPedAsNoLongerNeeded(currentPed)
    ClearPedTasks(currentPed)
    if DoesBlipExist(clientBlip) then
        RemoveBlip(clientBlip)
    end
    math.randomseed(GetGameTimer())
    local wanted = math.random(0,10)
    if wanted == 3 then
        SetPlayerWantedLevel(PlayerId(),1,true)
        SetPlayerWantedLevelNow(PlayerId(),true)
    end
    if pochonRestant == 0 then 
		TriggerEvent("notifynui", "warning", "Vente de drogue", "Vous n'avez plus de pochon.")
		saleActive = false 
    end
end)













-- Source: https://github.com/ZAUB1/ESX-Binoculars author ZAUB1
-- Source script heavily based and used many elements of https://github.com/mraes/FiveM-scripts/tree/master/heli

-- This release: Removed unused code. Changed UI to use binocular scaleform.
--				 Fixed zoom in/out. Added keybind support
--				 twitch.tv/SerpicoTV
--CONFIG--
local fov_max = 50.0
local fov_min = 5.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 10.0 -- camera zoom speed
local speed_lr = 8.0 -- speed by which the camera pans left-right
local speed_ud = 8.0 -- speed by which the camera pans up-down

local binoculars = false
local fov = (fov_max+fov_min)*0.5

local Keys = {
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

local keybindEnabled = true -- When enabled, binocular are available by keybind
local binocularKey = Keys["T"]
local storeBinoclarKey = Keys["BACKSPACE"]

--THREADS--

-- Citizen.CreateThread(function()
-- 	while true do

-- 		Citizen.Wait(10)

-- 		local lPed = GetPlayerPed(-1)
-- 		local vehicle = GetVehiclePedIsIn(lPed)

-- 		if binoculars or (keybindEnabled and IsControlJustReleased(1, binocularKey)) then
			-- binoculars = true
			-- if not ( IsPedSittingInAnyVehicle( lPed ) ) then
			-- 	Citizen.CreateThread(function()
			-- 		TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_BINOCULARS", 0, 1)
			-- 		PlayAmbientSpeech1(GetPlayerPed(-1), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
			-- 	end)
			-- end

			-- Wait(2000)

			-- SetTimecycleModifier("default")

			-- SetTimecycleModifierStrength(0.3)

			-- local scaleform = RequestScaleformMovie("BINOCULARS")

			-- while not HasScaleformMovieLoaded(scaleform) do
			-- 	Citizen.Wait(10)
			-- end

			-- local lPed = GetPlayerPed(-1)
			-- local vehicle = GetVehiclePedIsIn(lPed)
			-- local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

			-- AttachCamToEntity(cam, lPed, 0.0,0.0,1.0, true)
			-- SetCamRot(cam, 0.0,0.0,GetEntityHeading(lPed))
			-- SetCamFov(cam, fov)
			-- RenderScriptCams(true, false, 0, 1, 0)
			-- PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
			-- PushScaleformMovieFunctionParameterInt(0) -- 0 for nothing, 1 for LSPD logo
			-- PopScaleformMovieFunctionVoid()

			-- while binoculars and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == vehicle) and true do
			-- 	if IsControlJustPressed(0, storeBinoclarKey) then -- Toggle binoculars
			-- 		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
			-- 		ClearPedTasks(GetPlayerPed(-1))
			-- 		binoculars = false
			-- 	end

			-- 	local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
			-- 	CheckInputRotation(cam, zoomvalue)

			-- 	HandleZoom(cam)
			-- 	HideHUDThisFrame()

			-- 	DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
			-- 	Citizen.Wait(0)
			-- end

			-- binoculars = false
			-- ClearTimecycleModifier()
			-- fov = (fov_max+fov_min)*0.5
			-- RenderScriptCams(false, false, 0, 1, 0)
			-- SetScaleformMovieAsNoLongerNeeded(scaleform)
			-- DestroyCam(cam, false)
			-- SetNightvision(false)
			-- SetSeethrough(false)
-- 		end
-- 	end
-- end)

--EVENTS--

-- Activate binoculars
function jumelles()
    binoculars = not binoculars
    
    local lPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(lPed)

    if not ( IsPedSittingInAnyVehicle( lPed ) ) then
        Citizen.CreateThread(function()
            TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_BINOCULARS", 0, 1)
            PlayAmbientSpeech1(GetPlayerPed(-1), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
        end)
    end

    Wait(2000)

    SetTimecycleModifier("default")

    SetTimecycleModifierStrength(0.3)

    local scaleform = RequestScaleformMovie("BINOCULARS")

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(10)
    end

    local lPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(lPed)
    local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

    AttachCamToEntity(cam, lPed, 0.0,0.0,1.0, true)
    SetCamRot(cam, 0.0,0.0,GetEntityHeading(lPed))
    SetCamFov(cam, fov)
    RenderScriptCams(true, false, 0, 1, 0)
    PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
    PushScaleformMovieFunctionParameterInt(0) -- 0 for nothing, 1 for LSPD logo
    PopScaleformMovieFunctionVoid()

    while binoculars and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == vehicle) and true do
        if IsControlJustPressed(0, storeBinoclarKey) then -- Toggle binoculars
            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
            ClearPedTasks(GetPlayerPed(-1))
            binoculars = false
            isInAnimation = false
        end

        local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
        CheckInputRotation(cam, zoomvalue)

        HandleZoom(cam)
        HideHUDThisFrame()

        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
        Citizen.Wait(0)

        -- DISABLE WEAP WHEEL
        
        BlockWeaponWheelThisFrame()
    end
    isInAnimation = false
    binoculars = false
    ClearTimecycleModifier()
    fov = (fov_max+fov_min)*0.5
    RenderScriptCams(false, false, 0, 1, 0)
    SetScaleformMovieAsNoLongerNeeded(scaleform)
    DestroyCam(cam, false)
    SetNightvision(false)
    SetSeethrough(false)
end

--FUNCTIONS--
function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1) -- Wanted Stars
	HideHudComponentThisFrame(2) -- Weapon icon
	HideHudComponentThisFrame(3) -- Cash
	HideHudComponentThisFrame(4) -- MP CASH
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13) -- Cash Change
	HideHudComponentThisFrame(11) -- Floating Help Text
	HideHudComponentThisFrame(12) -- more floating help text
	HideHudComponentThisFrame(15) -- Subtitle Text
	HideHudComponentThisFrame(18) -- Game Stream
	HideHudComponentThisFrame(19) -- weapon wheel
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	local lPed = GetPlayerPed(-1)
	if not ( IsPedSittingInAnyVehicle( lPed ) ) then

		if IsControlJustPressed(0,241) then -- Scrollup
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,242) then
			fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	else
		if IsControlJustPressed(0,17) then -- Scrollup
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,16) then
			fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
	end
end


