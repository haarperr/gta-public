AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
    TriggerServerEvent("getGaragesPublic")
    TriggerServerEvent("getFourrieres")
end)



local gasStations = {}



local allowshuffle = true

-- AIR CONTROL
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if DoesEntityExist(veh) and not IsEntityDead(veh) then
            local model = GetEntityModel(veh)
            if not IsThisModelABoat(model) and not IsThisModelAHeli(model) and not IsThisModelAPlane(model) and not IsThisModelABike(model) and not IsThisModelABicycle(model) then
				      local roll = GetEntityRoll(veh)
              if (roll > 75.0 or roll < -75.0) and GetEntitySpeed(veh) < 2 or IsEntityInAir(veh)  then
                DisableControlAction(2,59,true) -- Disable left/right
                DisableControlAction(2,60,true) -- Disable up/down
              end
            end
        end
    end
end)

-- CEINTURE
Cfg             = {}
Cfg.DiffTrigger = 0.255 
Cfg.MinSpeed    = 15.0 --THIS IS IN m/s
Cfg.Strings     = { belt_on = 'Ceinture ~g~attachée.', belt_off = 'Ceinture ~r~détachée.' }
local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false

IsCar = function(veh)
    local vc = GetVehicleClass(veh)
    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end	

Fwv = function (entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

Citizen.CreateThread(function()
	Citizen.Wait(500)
	while true do

		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn(ped)
		
        if car ~= 0 and (wasInCar or IsCar(car)) then
            
			wasInCar = true
			if beltOn then DisableControlAction(0, 75) end
			speedBuffer[2] = speedBuffer[1]
            speedBuffer[1] = GetEntitySpeed(car)
            
			if speedBuffer[2] ~= nil 
                and GetEntitySpeedVector(car, true).y > 1.0  
                and speedBuffer[1] > Cfg.MinSpeed 
                and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * Cfg.DiffTrigger) 
                then
                if not beltOn then 
                    local co = GetEntityCoords(ped)
                    local fw = Fwv(ped)
                    SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z, true, true, true)
                    SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
                    Citizen.Wait(1)
                    SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
                    ApplyDamageToPed(ped, 20, true)
                else
                    ApplyDamageToPed(ped, 5, true)
                end
			end
				
			velBuffer[2] = velBuffer[1]
			velBuffer[1] = GetEntityVelocity(car)
				
			if IsControlJustReleased(0, 311) then
				beltOn = not beltOn				  
				if beltOn then 
                    TriggerEvent('notify', Cfg.Strings.belt_on)
                    allowshuffle = false
				else 
                    TriggerEvent('notify', Cfg.Strings.belt_off)
                    allowshuffle = true
                 end 
			end
			
		elseif wasInCar then
			wasInCar = false
			beltOn = false
			speedBuffer[1], speedBuffer[2] = 0.0, 0.0
		end
		Citizen.Wait(0)
	end
end)

-- PASSAGE AUTOMATIQUE PLACE CONDUCTEUR
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
        playerped=PlayerPedId()
        currentvehicle=GetVehiclePedIsIn(playerped, false)
		if IsPedInAnyVehicle(playerped, false) and allowshuffle == false then
			--if they're trying to shuffle for whatever reason
			SetPedConfigFlag(playerped, 184, true)
			if GetIsTaskActive(playerped, 165) then
				--getting seat player is in 
				seat=0
				if GetPedInVehicleSeat(currentvehicle, -1) == playerped then
					seat=-1
				end
				--if the passenger doesn't shut the door, shut it manually
				--if GetVehicleDoorAngleRatio(currentvehicle,1) > 0.0 and seat == 0 then
					--SetVehicleDoorShut(currentvehicle,1,false)
				--end
				--move ped back into the seat right as the animation starts
				SetPedIntoVehicle(playerped, currentvehicle, seat)
			end
		elseif IsPedInAnyVehicle(playerped, false) and allowshuffle == true then
			SetPedConfigFlag(playerped, 184, false)
		end
	end
end)

function getVehicleMods(veh)
    local resVeh = {}
    resVeh.type = GetVehicleClass(veh)
    resVeh.plate = GetVehicleNumberPlateText(veh)
    resVeh.model = GetEntityModel(veh)
    resVeh.fuel = GetVehicleFuelLevel(veh)
    resVeh.dirt = GetVehicleDirtLevel(veh)
    resVeh.bodyHealth = GetVehicleBodyHealth(veh)
    resVeh.tankHealth = GetVehiclePetrolTankHealth(veh)
    resVeh.engineHealth = GetVehicleEngineHealth(veh)
    resVeh.color1, resVeh.color2 = GetVehicleColours(veh)
    resVeh.spoiler = GetVehicleMod(veh, 0)
    resVeh.frontBumper = GetVehicleMod(veh, 1)
    resVeh.rearBumper = GetVehicleMod(veh, 2)
    resVeh.sideSkirt = GetVehicleMod(veh, 3)
    resVeh.exhaust = GetVehicleMod(veh, 4)
    resVeh.chassis = GetVehicleMod(veh, 5)
    resVeh.grill = GetVehicleMod(veh, 6)
    resVeh.bonnet = GetVehicleMod(veh, 7)
    resVeh.leftFender = GetVehicleMod(veh, 8)
    resVeh.rightFender = GetVehicleMod(veh, 9)
    resVeh.roof = GetVehicleMod(veh, 10)
    resVeh.engine = GetVehicleMod(veh, 11)
    resVeh.brakes = GetVehicleMod(veh, 12)
    resVeh.transmission = GetVehicleMod(veh, 13)
    resVeh.horn = GetVehicleMod(veh, 14)
    resVeh.suspension = GetVehicleMod(veh, 15)
    resVeh.armor = GetVehicleMod(veh, 16)
    resVeh.turbo = IsToggleModOn(veh, 18)
    resVeh.subwoofer = GetVehicleMod(veh, 19)
    resVeh.hydraulics = GetVehicleMod(veh, 21)
    resVeh.xenonLights = IsToggleModOn(veh, 22)
    resVeh.xenonColor = GetVehicleXenonLightsColor(veh)
    resVeh.wheels = GetVehicleMod(veh, 23)
    resVeh.sticker = GetVehicleMod(veh, 48)
    resVeh.livery = GetVehicleLivery(veh)
    resVeh.tint = GetVehicleWindowTint(veh)
    resVeh.extra1 = not IsVehicleExtraTurnedOn(veh,1)
    resVeh.extra2 = not IsVehicleExtraTurnedOn(veh,2)
    resVeh.extra3 = not IsVehicleExtraTurnedOn(veh,3)
    resVeh.extra4 = not IsVehicleExtraTurnedOn(veh,4)
    resVeh.extra5 = not IsVehicleExtraTurnedOn(veh,5)
    resVeh.extra6 = not IsVehicleExtraTurnedOn(veh,6)
    local displaytext = GetDisplayNameFromVehicleModel(resVeh.model)
    resVeh.name = GetLabelText(displaytext)
    -- if IsVehicleNeonLightEnabled(veh, 0) or IsVehicleNeonLightEnabled(veh, 1) or IsVehicleNeonLightEnabled(veh, 2) or IsVehicleNeonLightEnabled(veh, 3) then
    --     resVeh.neon = 1
    --     resVeh.neonColor = table.pack(GetVehicleNeonLightsColour(veh))
    -- else
    --     resVeh.neon = 0
    --     resVeh.neonColor = 0
    -- end
    resVeh.colorExtra, resVeh.colorWheel = GetVehicleExtraColours(veh)
    return resVeh
end
exports('getVehicleMods', getVehicleMods)


function deleteVehicle(veh)
    SetEntityAsMissionEntity(veh, true, true)
    DeleteVehicle(veh)
end


RegisterCommand("repair", function(source, args, rawcommand)
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    SetVehicleDeformationFixed(veh)
    SetVehicleFixed(veh)
    SetVehicleBodyHealth(veh, 1000.0)
    SetVehicleEngineHealth(veh, 1000.0)
    SetVehiclePetrolTankHealth(veh, 1000.0)
    SetVehicleDirtLevel(veh, 0.0)
    -- SetVehicleWheelHealth(veh, 1, )
    TriggerEvent("notify", "Véhicule réparé !")
end)

RegisterCommand("fuel", function(source, args, rawcommand)
    exports.frfuel:setFuel(100 + 0.0)
end)


RegisterCommand("buy", function(source, args, rawcommand)
    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
        local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
        local resVeh = getVehicleMods(veh)
        TriggerServerEvent("registerCar", resVeh)
    else
        exports.lib:notify("Tu n'es pas dans un véhicule.", false)
    end
end)

RegisterCommand("spawnGarage", function()
    TriggerServerEvent("getCarInGarage")
end)


RegisterNetEvent('spawnCar')
AddEventHandler('spawnCar', function(veh)
    local pos = GetEntityCoords(PlayerPedId())
    local h = GetEntityHeading(GetPlayerPed(-1))
    if IsModelValid(veh.model) then
        RequestModel(veh.model)
        while not HasModelLoaded(veh.model) do 
            Citizen.Wait(1)
        end
        local newVeh = CreateVehicle(veh.model, pos.x, pos.y, pos.z, h, true, true)
        SetVehicleModKit(newVeh,0)
        SetVehicleNumberPlateText(newVeh, veh.plate)
        if veh.dirt then 
          SetVehicleDirtLevel(newVeh, veh.dirt + 0.0)
          SetVehicleBodyHealth(newVeh, veh.bodyHealth + 0.0)
          SetVehiclePetrolTankHealth(newVeh, veh.tankHealth + 0.0)
          SetVehicleEngineHealth(newVeh, veh.engineHealth + 0.0)
          SetVehicleColours(newVeh, veh.color1, veh.color2)
          SetVehicleExtraColours(newVeh,  veh.colorExtra,  veh.colorWheel)
          SetVehicleWindowTint(newVeh, veh.tint)
          SetVehicleMod(newVeh, 0, veh.spoiler, false)
          SetVehicleMod(newVeh, 1, veh.frontBumper, false)
          SetVehicleMod(newVeh, 2, veh.rearBumper, false)
          SetVehicleMod(newVeh, 3, veh.sideSkirt, false)
          SetVehicleMod(newVeh, 4, veh.exhaust, false)
          SetVehicleMod(newVeh, 5, veh.chassis, false)
          SetVehicleMod(newVeh, 6, veh.grill, false)
          SetVehicleMod(newVeh, 7, veh.bonnet, false)
          SetVehicleMod(newVeh, 8, veh.leftFender, false)
          SetVehicleMod(newVeh, 9, veh.rightFender, false)
          SetVehicleMod(newVeh, 10, veh.roof, false)
          SetVehicleMod(newVeh, 11, veh.engine, false)
          SetVehicleMod(newVeh, 12, veh.brakes, false)
          SetVehicleMod(newVeh, 13, veh.transmission, false)
          SetVehicleMod(newVeh, 14, veh.horn, false)
          SetVehicleMod(newVeh, 15, veh.suspension, false)
          SetVehicleMod(newVeh, 16, veh.armor, false)
          ToggleVehicleMod(newVeh, 18, veh.turbo)
          SetVehicleMod(newVeh, 19, veh.subwoofer, false)
          ToggleVehicleMod(newVeh, 20, veh.tyreSmoke)
          SetVehicleMod(newVeh, 21, veh.hydraulics, false)
          ToggleVehicleMod(newVeh, 22, veh.xenonLights)
          SetVehicleXenonLightsColor(newVeh, veh.xenonColor)
          SetVehicleMod(newVeh, 23, veh.wheels, false)
          SetVehicleMod(newVeh, 48, veh.sticker, false)
          SetVehicleLivery(newVeh, veh.livery)
          SetVehicleExtra(newVeh, 1, veh.extra1)
          SetVehicleExtra(newVeh, 2, veh.extra2)
          SetVehicleExtra(newVeh, 3, veh.extra3)
          SetVehicleExtra(newVeh, 4, veh.extra4)
          SetVehicleExtra(newVeh, 5, veh.extra5)
          SetVehicleExtra(newVeh, 6, veh.extra6)
        end
        -- if veh.neon == 1 then
        --     SetVehicleNeonLightsColour(newVeh,  newVeh.neonColor[1], newVeh.neonColor[2], newVeh.neonColor[3])
        --     SetVehicleNeonLightEnabled(newVeh, 0, true)
		-- 	SetVehicleNeonLightEnabled(newVeh, 1, true)
		-- 	SetVehicleNeonLightEnabled(newVeh, 2, true)
		-- 	SetVehicleNeonLightEnabled(newVeh, 3, true)
        -- end
        TaskWarpPedIntoVehicle(PlayerPedId(), newVeh, -1)
        SetEntityAsMissionEntity(newVeh, true, true)
        SetVehicleNeedsToBeHotwired(newVeh, false)
        SetVehicleHasBeenOwnedByPlayer(newVeh, true)
        SetEntityAsMissionEntity(newVeh, true, true)
        SetVehicleIsStolen(newVeh, false)
        SetVehicleIsWanted(newVeh, false)
        SetVehRadioStation(newVeh, 'OFF')
        TriggerEvent("vehicule:addKey", veh.plate)
        Wait(100)
        if veh.fuel then
          exports.frfuel:setFuel(veh.fuel + 0.0)
        end
    else
		exports.lib:notify("~r~Invalid Model!")
	end
end)

RegisterNetEvent('deleteCar')
AddEventHandler('deleteCar', function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    local plate = GetVehicleNumberPlateText(veh)
    deleteVehicle(veh)
    TriggerEvent("vehicule:removeKey", plate)
end)


function openGarageMenu(cars, garage)
    if garage.xGarage then
        garage.x = garage.xGarage
        garage.y = garage.yGarage
        garage.z = garage.zGarage
    end
    if not exports.menu:isMenuOpen() then
        local menu = exports.menu:CreateMenu({name = "garage", title = 'Garage', subtitle = 'Vos véhicules', footer = 'Appuyer sur Entrée'})
        menu.ClearItems(menu)
        if garage.xIn then 
          menu.AddButton(menu, {label = "Entrer dans l'appartement", select = function()
            exports.lib:teleportTo(garage.xIn, garage.yIn, garage.zIn, garage.hIn)
            exports.menu:closeMenu()
          end})
        end
        if cars[1] then
            for i,car in pairs(cars) do
                local displaytext = GetDisplayNameFromVehicleModel(car.model)
                local name = GetLabelText(displaytext)
                menu.AddButton(menu, {label = car.name, select = function()
                    TriggerServerEvent('getCarOutGarage', car.plate)
                    exports.menu:closeMenu()
                end})
            end
        else
          if garage.xIn then 
            menu.AddButton(menu, {label = "Entrer dans l'appartement", select = function()
              exports.lib:teleportTo(garage.xIn, garage.yIn, garage.zIn, garage.hIn)
              exports.menu:closeMenu()
            end})
          end
          menu.AddButton(menu, {label = "Aucune voiture n'est dans ce garage", select = function()
              exports.menu:closeMenu()
          end})
        end
        exports.menu:openMenu(menu)
    end


    while true do
        Citizen.Wait(5)
        local pos = GetEntityCoords(PlayerPedId())
        local dest = vector3(garage.x, garage.y, garage.z)
        local distance = GetDistanceBetweenCoords(pos, dest, true)
        if distance > 2 then 
            if exports.menu:isMenuOpen(menu) then 
                exports.menu:closeMenu()
                return
            end
        end
    end
end


RegisterNetEvent('openGarageMenu')
AddEventHandler('openGarageMenu', function(cars, garage)
    openGarageMenu(cars, garage)
end)




-- ***************** GARAGES PUBLICS *********************************************************************************

local garagesPublic
local garagesPublicBlips

RegisterNetEvent("getGaragesPublicCallback")
AddEventHandler("getGaragesPublicCallback", function(garages)
    garagesPublic = garages
    Citizen.CreateThread(function()
        for i,garage in pairs(garages) do 
            local blip = AddBlipForCoord(garage.x, garage.y, garage.z)
            SetBlipSprite(blip, 290)
            AddTextEntry('GARAGEPUBLIC', "Garage Public")
            BeginTextCommandSetBlipName('GARAGEPUBLIC') 
            SetBlipCategory(blip, 1) 
            EndTextCommandSetBlipName(blip)
            SetBlipAsShortRange(blip, true)
            SetBlipScale(blip, 0.9)
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        local interval = 2000
        if garagesPublic then 
            for i,garage in pairs(garagesPublic) do
                local pos = GetEntityCoords(PlayerPedId())
                local dest = vector3(garage.x, garage.y, garage.z)
                local distance = GetDistanceBetweenCoords(pos, dest, true)

                if distance < 60 then
                    interval = 500
                    if distance < 20 then
                        interval = 0
                        DrawMarker(1, garage.x, garage.y, garage.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.8, 1.8, 0.6, 0, 140, 255, 180, 0, 0, 2, 0, nil, nil, 0)
                        if distance < 2 then 
                            if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then 
                              local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                              if GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
                                AddTextEntry("GARAGERENTRER", "Appuyez sur la touche ~INPUT_CONTEXT~ ~s~pour ~r~rentrer ~s~le véhicule.")
                                DisplayHelpTextThisFrame("GARAGERENTRER", false)
                                if IsControlJustPressed(1, 51) then
                                    local resVeh = getVehicleMods(veh)
                                    TriggerEvent("progressBar", 5)
                                    Citizen.Wait(5000)
                                    local pos = GetEntityCoords(PlayerPedId())
                                    local distance = GetDistanceBetweenCoords(pos, dest, true)
                                    if distance < 2 then 
                                        TriggerServerEvent("setCarInGarage", resVeh, garage)
                                    else
                                        TriggerEvent("notify", "Vous êtes trop loin du garage.")
                                    end
                                end
                              end
                            else
                                if not exports.menu:isMenuOpen() then
                                    AddTextEntry("GARAGESORTIR", "Appuyez sur la touche ~INPUT_CONTEXT~ ~s~pour ~g~sortir ~s~un véhicule.")
                                    DisplayHelpTextThisFrame("GARAGESORTIR", false)
                                    if IsControlJustPressed(1, 51) then
                                        TriggerServerEvent("getCarInGarage", garage)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(interval)
    end
end)



-- ***************** FOURRIERE *********************************************************************************

local fourrieres
local fourrieresBlips

RegisterNetEvent("getFourriereCallback")
AddEventHandler("getFourriereCallback", function(f)
    fourrieres = f
    Citizen.CreateThread(function()
        for i,fourriere in pairs(fourrieres) do 
            local blip = AddBlipForCoord(fourriere.x, fourriere.y, fourriere.z)
            SetBlipSprite(blip, 289)
            AddTextEntry("FOURRIERE", "Fourrière")
            BeginTextCommandSetBlipName("FOURRIERE") 
            SetBlipColour(blip, 44)
            SetBlipCategory(blip, 1) 
            EndTextCommandSetBlipName(blip)
            SetBlipAsShortRange(blip, true)
            SetBlipScale(blip, 0.9)
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        local interval = 2000
        if fourrieres then 
            for i,fourriere in pairs(fourrieres) do
                local pos = GetEntityCoords(PlayerPedId())
                local dest = vector3(fourriere.x, fourriere.y, fourriere.z)
                local distance = GetDistanceBetweenCoords(pos, dest, true)

                if distance < 60 then
                    interval = 500
                    if distance < 20 then
                        interval = 0
                        DrawMarker(1, fourriere.x, fourriere.y, fourriere.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.5, 4.5, 1.0, 255, 154, 24, 100, 0, 0, 2, 0, nil, nil, 0)
                        if distance < 2 then 
                            if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                                if not exports.menu:isMenuOpen() then
                                    AddTextEntry("FOURRIERE", "Appuyez sur la touche ~INPUT_CONTEXT~ ~s~pour ~g~sortir ~s~un véhicule.")
                                    DisplayHelpTextThisFrame("FOURRIERE", false)
                                    if IsControlJustPressed(1, 51) then
                                        TriggerServerEvent("getCarInGarage", fourriere)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(interval)
    end
end)



-- Citizen.CreateThread(function()
--     local coords = {x = 403.6, y = -1634.3, z = 28.38} 
--     local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
--     SetBlipSprite(blip, 289)
--     AddTextEntry("FOURRIERE", "Fourrière")
--     BeginTextCommandSetBlipName("FOURRIERE") 
--     SetBlipColour(blip, 44)
--     SetBlipCategory(blip, 2) 
--     EndTextCommandSetBlipName(blip)
--     SetBlipAsShortRange(blip, true)
--     while true do 
--         local interval = 20
--         local pos = GetEntityCoords(PlayerPedId())
--         local dest = vector3(coords.x, coords.y, coords.z)
--         local distance = GetDistanceBetweenCoords(pos, dest, true)

--         if distance > 50 then
--             interval = 500
--         else
--             interval = 1
--             DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.5, 4.5, 1.0, 255, 154, 24, 100, 0, 0, 2, 0, nil, nil, 0)
--             if distance < 2 then 
--                 if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
--                     AddTextEntry("FOURRIERE", "Appuyez sur la touche ~INPUT_CONTEXT~ pour ~g~sortir ~s~un véhicule.")
--                     DisplayHelpTextThisFrame("FOURRIERE", false)
--                     if IsControlJustPressed(1, 51) then
--                         local garage = {}
--                         garage.x = coords.x
--                         garage.y = coords.y
--                         garage.z = coords.z
--                         TriggerServerEvent("getCarInFourriere", garage)
--                     end
--                 end
--             end
--         end
--         Citizen.Wait(interval)
--     end
-- end)






-- ***************** LS CUSTOMS *********************************************************************************


local lscustoms = { 
	{x = -337.3863,y = -136.9247,z = 38.5737, heading = 269.455},
	{x = 733.69,y = -1088.74, z = 21.733, heading = 270.528},
	{x = -1155.077,y = -2006.61, z = 12.465, heading = 162.58},
	{x = 1174.823,y = 2637.807, z = 37.045, heading = 181.19},
	{x = 108.842,y = 6628.447, z = 31.072, heading = 45.504},
}
Citizen.CreateThread(function()

    Wait(1000)

    local lscustomMenu = exports.menu:CreateMenu({name = "lscustom", title = "LS Custom Garage", subtitle = "Actions", footer = "Appuyer sur Entrée"})

    for i,v in pairs(lscustoms) do 
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipAsShortRange(blip, true)
        SetBlipSprite(blip, 446)
        AddTextEntry("LSCUSTOM", "LS Custom")
        BeginTextCommandSetBlipName("LSCUSTOM") 
        SetBlipCategory(blip, 1) 
        EndTextCommandSetBlipName(blip)
    end
    while true do 
        local interval = 5000
        for i,v in pairs(lscustoms) do
            local pos = GetEntityCoords(PlayerPedId())
            local dest = vector3(v.x, v.y, v.z)
            local distance = GetDistanceBetweenCoords(pos, dest, true)

            if distance < 40 then
                interval = 0
                DrawMarker(1, v.x, v.y, v.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 1.0, 0, 150, 255, 175, 0, 0, 2, 0, nil, nil, 0)
                if distance < 2 then 
                    if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) and not exports.menu:isMenuOpen() then
                        AddTextEntry("LSCUSTOM", "Appuyez sur la touche ~INPUT_CONTEXT~")
                        DisplayHelpTextThisFrame("LSCUSTOM", false)
                        if IsControlJustPressed(1, 51) then
                            lscustomMenu.ClearItems(lscustomMenu)
                            lscustomMenu.AddButton(lscustomMenu, {label = "Réparations - $400", select = function()
                                TriggerServerEvent("updateBankWithCallback", -400, "reparationAuto", v)
                                exports.menu:closeMenu()
                            end})
                            exports.menu:openMenu(lscustomMenu)
                        end
                    end
                else
                    if exports.menu:isMenuOpen(lscustomMenu) then 
                        exports.menu:closeMenu()
                    end
                end
            end
        end
        Citizen.Wait(interval)
    end
end)






-- ***************** BENNYS *********************************************************************************
Citizen.CreateThread(function()
    Wait(1000)

    local bennysMenu = exports.menu:CreateMenu({name = "bennys", title = "Benny's Garage", subtitle = "Actions", footer = "Appuyer sur Entrée"})

    local coords = {x = -211.0, y = -1325.5, z = 29.9} 
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 446)
    AddTextEntry("BENNY", "Benny's")
    BeginTextCommandSetBlipName("BENNY") 
    SetBlipColour(blip, 5)
    SetBlipCategory(blip, 2) 
    EndTextCommandSetBlipName(blip)
    SetBlipAsShortRange(blip, true)
    while true do 
        local interval = 20
        local pos = GetEntityCoords(PlayerPedId())
        local dest = vector3(coords.x, coords.y, coords.z)
        local distance = GetDistanceBetweenCoords(pos, dest, true)

        if distance > 50 then
            interval = 500
        else
            interval = 1
            DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 1.0, 0, 0, 255, 175, 0, 0, 2, 0, nil, nil, 0)
            if distance < 2 then 
                if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) and not exports.menu:isMenuOpen() then
                    AddTextEntry("BENNYS", "Appuyez sur la touche ~INPUT_CONTEXT~.")
                    DisplayHelpTextThisFrame("BENNYS", false)
                    if IsControlJustPressed(1, 51) then
                        bennysMenu.ClearItems(bennysMenu)
                        bennysMenu.AddButton(bennysMenu, {label = "Réparations - $400", select = function()
                            TriggerServerEvent("updateBankWithCallback", -400, "reparationAuto", coords)
                            exports.menu:closeMenu()
                        end})
                        exports.menu:openMenu(bennysMenu)
                    end
                end
            else
                if exports.menu:isMenuOpen(bennysMenu) then 
                    exports.menu:closeMenu()
                end
            end
        end
        Citizen.Wait(interval)
    end
end)

-- VENTE
Citizen.CreateThread(function()
  while true do
    local interval = 1000
    local pos = GetEntityCoords(PlayerPedId())
    DrawMarker(27, -201.0, -1318.4, 30.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 255, 255, 255, 255, 0, 0, 2, 0, nil, nil, 0)
    local dest = vector3(-201.0, -1318.4, 30.1)
    local distance = GetDistanceBetweenCoords(pos, dest, true)
    -- pharma.distance = distance

    if distance < 20 then
        interval = 10
        if distance < 10 then 
            interval = 2
        end
        if distance < 2 then
            AddTextEntry("BENNYSHOP", "Appuyez sur la touche ~INPUT_CONTEXT~ pour ouvrir le magasin.")
            DisplayHelpTextThisFrame("BENNYSHOP", false)
            if IsControlJustPressed(1, 51) then
                if IsControlJustPressed(1, 51) then
                    TriggerEvent("menuShop", 4)
                end
            end
        end
    end
    Citizen.Wait(interval)
  end
end)


RegisterNetEvent("reparationAuto")
AddEventHandler("reparationAuto", function(v)
    TriggerEvent("notify", "Réparation en cours...")
    local repa = true 
    local ped = GetPlayerPed(-1)
    Citizen.CreateThread(function()
        while repa do
            Citizen.Wait(0)
            local pos = GetEntityCoords(ped)
            local dest = vector3(v.x, v.y, v.z)
            local distance = GetDistanceBetweenCoords(pos, dest, true)
            if distance > 5 or not IsPedInAnyVehicle(ped) or not DoesEntityExist(ped) or IsEntityDead(ped) or (false and false) then
                TriggerEvent("notify", "Réparation annulée !")
                TriggerEvent("stopProgressBar")
                repa = false
            end
        end
    end)
    TriggerEvent("progressBar", 40)
    Citizen.Wait(40000)
    if repa then
        local veh = GetVehiclePedIsIn(ped, false)
        SetVehicleDeformationFixed(veh)
        SetVehicleFixed(veh)
        SetVehicleBodyHealth(veh, 1000.0)
        SetVehicleEngineHealth(veh, 1000.0)
        SetVehiclePetrolTankHealth(veh, 1000.0)
        SetVehicleDirtLevel(veh, 0.0)
        -- SetVehicleWheelHealth(veh, 1, )
        TriggerEvent("notify", "Véhicule réparé !")
        repa = false
    end
end)




-- ***************** MENU GESTION VEHICULE *********************************************************************************
Citizen.CreateThread(function()
    Wait(1000)
    local menuCar = exports.menu:CreateMenu({name = "car", title = "Gestion du vehicule", subtitle = "Actions", footer = "Appuyer sur Entrée"})
    while true do
        local interval = 1000
        if IsPedInAnyVehicle(GetPlayerPed(-1)) then
            interval = 100
            local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
            if GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
                interval = 0
                if IsControlJustPressed(1, 166) then
                      Citizen.Wait(100)
                      if not exports.menu:isMenuOpen() then -- F5
                        menuCar.ClearItems(menuCar)
                        menuCar.AddCheckbox(menuCar, {label = "Allumer le moteur", checked = IsVehicleEngineOn(veh), select = function()
                            SetVehicleEngineOn(veh, not IsVehicleEngineOn(veh), false, true)
                        end})
                        if GetIsDoorValid(veh, 0) then 
                          local isOpen = (GetVehicleDoorAngleRatio(veh, 0) > 0.1 )
                          menuCar.AddCheckbox(menuCar, {label = "Ouvrir Porte avant gauche", checked = isOpen, select = function()
                            local isOpen = (GetVehicleDoorAngleRatio(veh, 0) > 0.1 )
                            if isOpen then 
                              SetVehicleDoorShut(veh, 0, false)
                            else
                              SetVehicleDoorOpen(veh, 0, false)
                            end
                          end})
                        end
                        if GetIsDoorValid(veh, 1) then 
                          local isOpen = (GetVehicleDoorAngleRatio(veh, 1) > 0.1 )
                          menuCar.AddCheckbox(menuCar, {label = "Ouvrir Porte avant droite", checked = isOpen, select = function()
                            local isOpen = (GetVehicleDoorAngleRatio(veh, 1) > 0.1 )
                            if isOpen then 
                              SetVehicleDoorShut(veh, 1, false)
                            else
                              SetVehicleDoorOpen(veh, 1, false)
                            end
                          end})
                        end
                        if GetIsDoorValid(veh, 2) then
                          local isOpen = (GetVehicleDoorAngleRatio(veh, 2) > 0.1 )
                          menuCar.AddCheckbox(menuCar, {label = "Ouvrir Porte arrière gauche", checked = isOpen, select = function()
                            local isOpen = (GetVehicleDoorAngleRatio(veh, 2) > 0.1 )
                            if isOpen then 
                              SetVehicleDoorShut(veh, 2, false)
                            else
                              SetVehicleDoorOpen(veh, 2, false)
                            end
                          end})
                        end
                        if GetIsDoorValid(veh, 3) then 
                          local isOpen = (GetVehicleDoorAngleRatio(veh, 3) > 0.1 )
                          menuCar.AddCheckbox(menuCar, {label = "Ouvrir Porte arrière droite", checked = isOpen, select = function()
                            local isOpen = (GetVehicleDoorAngleRatio(veh, 3) > 0.1 )
                            if isOpen then 
                              SetVehicleDoorShut(veh, 3, false)
                            else
                              SetVehicleDoorOpen(veh, 3, false)
                            end
                          end})
                        end
                        if GetIsDoorValid(veh, 5) then
                          local isOpen = (GetVehicleDoorAngleRatio(veh, 5) > 0.1 )
                          menuCar.AddCheckbox(menuCar, {label = "Ouvrir Coffre", checked = isOpen, select = function()
                            local isOpen = (GetVehicleDoorAngleRatio(veh, 5) > 0.1 )
                            if isOpen then 
                              SetVehicleDoorShut(veh, 5, false)
                            else
                              SetVehicleDoorOpen(veh, 5, false)
                            end
                          end})
                        end
                        if GetIsDoorValid(veh, 4) then 
                          local isOpen = (GetVehicleDoorAngleRatio(veh, 4) > 0.1 )
                          menuCar.AddCheckbox(menuCar, {label = "Ouvrir Capot", checked = isOpen, select = function()
                            local isOpen = (GetVehicleDoorAngleRatio(veh, 4) > 0.1 )
                            if isOpen then 
                              SetVehicleDoorShut(veh, 4, false)
                            else
                              SetVehicleDoorOpen(veh, 4, false)
                            end
                          end})
                        end
                        exports.menu:openMenu(menuCar)
                        Citizen.Wait(100)
                    elseif exports.menu:isMenuOpen(menuCar) then 
                        exports.menu:closeMenu()
                        Citizen.Wait(100)
                    end
                end
            elseif exports.menu:isMenuOpen(menuCar) then 
                exports.menu:closeMenu()
            end
        elseif exports.menu:isMenuOpen(menuCar) then 
            exports.menu:closeMenu()
        end
        Citizen.Wait(interval)
    end
end)


-- -- ******************** CONCESS ******************************************************************************

local categories = {
  { 
    name = "Vehicule compact" ,
    vehicles = {
      {name = "Panto", hash = -431692672, price = 5000},
      -- {name = "Weevil", hash = -431692672, price = 5000},
      {name = "Issi Classic", hash = 931280609, price = 10000},
      {name = "Issi", hash = -1177863319 , price = 15000},
      {name = "Rhapsody", hash = 841808271, price = 20000},
      {name = "Brioso", hash = 1549126457, price = 25000},
      {name = "Club", hash = -2098954619, price = 30000},
      {name = "Kanjo", hash = 409049982, price = 35000},
    }
  },
  { 
    name = "Berline" ,
    vehicles = {
      {name = "Stafford", hash = 321186144, price = 50000},
      {name = "Primo Custom", hash = -2040426790, price = 70000},
      {name = "Cognoscenti 55", hash = 906642318, price = 80000},
      {name = "Schafter", hash = -1255452397, price = 80000},
      {name = "Cognoscenti", hash = -2030171296 , price = 90000},
      {name = "Tailgater S", hash = -1244461404, price = 120000},
      {name = "Schafter V12", hash = -1485523546, price = 150000},
      {name = "Super Diamond", hash = 1123216662, price = 150000},
    }
  },
  { 
    name = "SUV" ,
    vehicles = {
      {name = "Granger", hash = -1775728740, price = 80000},
      {name = "Rocoto", hash = 2136773105, price = 90000},
      {name = "Seminole Frontier", hash = -1810806490, price = 90000},
      {name = "Huntley", hash = 486987393, price = 120000},
      {name = "Novak", hash = -1829436850, price = 130000},
      {name = "Patriot", hash = 808457413, price = 150000},
      {name = "Squaddie", hash = -102335483, price = 150000},
      {name = "Dubsta", hash = -394074634  , price = 190000},
      {name = "Rebla", hash = 83136452, price = 200000},
      {name = "Baller", hash = 1878062887, price = 250000},
      {name = "Patriot Stretch", hash = -420911112, price = 500000},
      {name = "Dubsta 6x6", hash = -1237253773, price = 600000},
      {name = "Toros", hash = -1168952148, price = 650000},
    }
  },
  { 
    name = "Coupe" ,
    vehicles = {
      {name = "Oracle", hash = 1348744438, price = 80000},
      {name = "Sentinel", hash = 873639469, price = 90000},
      {name = "Zion Cabrio", hash = -1193103848, price = 90000},
      {name = "Cognoscenti Cabrio", hash = 330661258, price = 100000},
      {name = "Exemplar", hash = -5153954, price = 100000},
      {name = "Windsor Cabrio", hash = -1930048799, price = 130000},
    }
  },
  { 
    name = "Grosse Cylindree" ,
    vehicles = {
      {name = "Chino Custom", hash = -1361687965, price = 60000},
      {name = "Virgo Classique Custom", hash = -498054846, price = 60000},
      {name = "Buccaneer Custom", hash = -1013450936, price = 70000},
      {name = "Coquette BlackFin", hash = 784565758, price = 70000},
      {name = "Ellie", hash = -1267543371, price = 70000},
      {name = "Vamos", hash = -49115651, price = 70000},
      {name = "Nightshade", hash = -1943285540, price = 80000},
      {name = "Dominator", hash = 80636076, price = 90000},
      {name = "Gauntlet Hellfire", hash = 1934384720, price = 90000},
      {name = "Sabre Turbo Custom", hash = 223258115, price = 90000},
      {name = "Dominator GTT", hash = 736672010, price = 100000},
      {name = "Dominator GTX", hash = -986944621, price = 120000},
    }
  },
  { 
    name = "Sportive Classique" ,
    vehicles = {
      {name = "Pigalle", hash = 1078682497, price = 60000},
      {name = "GT500", hash = -2079788230, price = 80000},
      {name = "Peyote Custom", hash = 1830407356, price = 80000},
      {name = "Rapid GT Classique", hash = 2049897956, price = 80000},
      {name = "Turismo Classique", hash = -982130927, price = 80000},
      {name = "Zion Classique", hash = 1862507111, price = 80000},
      {name = "Jester Classique", hash = -214906006, price = 90000},
      {name = "Roosevelt", hash = -602287871, price = 90000},
      {name = "Stirling GT", hash = -1566741232, price = 90000},
      {name = "Stinger GT", hash = -2098947590, price = 90000},
      {name = "Ardent", hash = 159274291, price = 100000},
      {name = "Viseris", hash = -391595372, price = 100000},
      {name = "Z-Type", hash = 758895617, price = 100000},
      {name = "Fränken Stange", hash = -831834716, price = 120000},
      {name = "Monroe", hash = -433375717, price = 120000},
      {name = "Coquette Classique", hash = 1011753235, price = 130000},
      {name = "Cheetah Classique", hash = 223240013, price = 140000},
      {name = "Infernus Classique", hash = -1405937764, price = 140000},
    }
  },
  { 
    name = "Sportive" ,
    vehicles = {
      {name = "Buffalo S", hash = 736902334, price = 90000},
      {name = "Comet S2", hash = -1726022652, price = 100000},
      {name = "Issi Sport", hash = 1854776567, price = 100000},
      {name = "ZR350", hash = 	-1858654120, price = 100000},
      {name = "Coquette", hash = 108773431, price = 110000},
      {name = "Futo GTX", hash = 2016857647, price = 110000},
      {name = "Comet Rétro Custom", hash = -2022483795, price = 120000},
      {name = "Comet Safari", hash = 1561920505, price = 120000},
      {name = "Kuruma", hash = -1372848492, price = 120000},
      {name = "Carbonizzare", hash = 2072687711, price = 130000},
      {name = "Neon", hash = -1848994066, price = 130000},
      {name = "Sentinel Classique", hash = 1104234922, price = 130000},
      {name = "Omnis", hash = -777172681, price = 130000},
      {name = "V-STR", hash = 1456336509, price = 130000},
      {name = "Elegy Rétro Custom", hash = 196747873, price = 140000},
      {name = "GB200", hash = 1909189272, price = 140000},
      {name = "Paragon R", hash = -447711397, price = 140000},
      {name = "Tampa Drift", hash = -1071380347, price = 140000},
      {name = "Sultan RS Classique", hash = -295689028, price = 150000},
      {name = "Calico GTF", hash = -1193912403, price = 160000},
      {name = "Komoda", hash = -834353991, price = 160000},
      {name = "9F", hash = 1032823388, price = 160000},
      {name = "Vectre", hash = 	-1540373595, price = 160000},
      {name = "Raiden", hash = -1529242755, price = 170000},
      {name = "Revolter", hash = -410205223, price = 170000},
      {name = "Coquette D10", hash = -1728685474, price = 180000},
      {name = "Growler", hash = 1304459735, price = 18000},
      {name = "Jester RR", hash = -1582061455, price = 180000},
      {name = "Pariah", hash = 867799010, price = 180000},
      {name = "Sultan Classique", hash = 872704284, price = 180000},
      {name = "Flash GT", hash = -1259134696, price = 190000},
      {name = "Jugular", hash = -208911803, price = 200000},
      {name = "Rapid GT", hash = -1934452204, price = 200000},
      {name = "Schlagen", hash = -507495760, price = 200000},
      {name = "Imorgon", hash = -1132721664, price = 230000},
      {name = "Itali RSX", hash = -1149725334, price = 240000},
      {name = "8F Drafter", hash = 686471183, price = 250000},
    }
  },
  { 
    name = "Véhicule de luxe" ,
    vehicles = {
      {name = "Limousine", hash = -1961627517, price = 1000000},
      {name = "Limousine", hash = -1961627517, price = 1000000},
    }
  },
  { 
    name = "Vélo" ,
    vehicles = {
      {name = "BMX", hash = 1131912276, price = 800},
      {name = "Fixter", hash = -836512833, price = 900},
      {name = "Scorcher", hash = -186537451, price = 1800},
      {name = "Whippet", hash = 1127861609, price = 2000},
      {name = "Endurex", hash = -1233807380, price = 2000},
      {name = "Tri-Cycles", hash = -400295096, price = 2000},
    }
  },
  -- "Berline",
  -- "SUV",
  -- "Coupé",
  -- "Grosse cylindrée",
  -- "Sportive",
  -- "Sportive classique",
  -- "Supersportive",
  -- "Tout terrain",
  -- "Moto",
  -- "Vélo",
}
local menuConcess
local vehConcess
local priceConcess
local concessSpawn = {x = -43.5, y = -1097.4, z = 25.4}

function createVehicle(veh)
  if vehConcess then 
    DeleteVehicle(vehConcess)
  end
  
  RequestModel(veh.hash)
  while not HasModelLoaded(veh.hash) do 
      Citizen.Wait(1)
  end
  vehConcess = CreateVehicle(veh.hash,concessSpawn.x, concessSpawn.y, concessSpawn.z, 120.0,false,false)
  SetVehicleEngineOn(vehConcess, true, true, false)
  SetEntityInvincible(vehConcess, true)
  FreezeEntityPosition(vehConcess, true)
end

Citizen.CreateThread(function()
  -- Wait(1000)
  menuConcess = exports.menu:CreateMenu({name = "concess", title = "Concessionnaire", subtitle = "Sélectionner une catégorie", footer = "Appuyer sur Entrée"})
  for i,cat in pairs(categories) do 
    local submenu = exports.menu:CreateSubmenu(menuConcess, {title = cat.name, subtitle = 'Liste des véhicules disponibles', footer = 'Appuyer sur Entrée pour voir le véhicule'})
    for j,veh in pairs(cat.vehicles) do
      submenu.AddButton(submenu, {label = veh.name, badge = veh.price.."$", select = function() 
          createVehicle(veh)
          priceConcess = veh.price
      end})
    end
    menuConcess.AddSubmenu(menuConcess, submenu)

  end
end)

local isInConcess = false 
local cam = nil

local angleY = 0.0
local angleZ = 0.0


-- maximum radius the camera will orbit at (in meters)
local radiusCamMax = 6.0

function startConcessCam()
  ClearFocus()

  local playerPed = PlayerPedId()
  
  cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(playerPed), 0, 0, 0, GetGameplayCamFov())

  SetCamActive(cam, true)
  RenderScriptCams(true, true, 1000, true, false)

  -- StartScreenEffect('DeathFailOut', 0, false)
end

-- destroy camera
function endConcessCam()
  ClearFocus()

  RenderScriptCams(false, false, 0, true, false)
  DestroyCam(cam, false)
  
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
  SetFocusArea(newPos.x, newPos.y, newPos.z + 6.0, 0.0, 0.0, 0.0)
  
  -- set coords of cam
  SetCamCoord(cam, newPos.x, newPos.y, newPos.z + 6.0)
  
  -- set rotation
  PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 6.5)
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
  if (angleY > 15.0) then angleY = 15.0 elseif (angleY < -5.0) then angleY = -5.0 end
  
  local pCoords = GetEntityCoords(PlayerPedId())
  
  local behindCam = {
      x = pCoords.x + ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * (radiusCamMax + 0.5),
      y = pCoords.y + ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * (radiusCamMax + 0.5),
      z = pCoords.z + ((Sin(angleY))) * (radiusCamMax + 0.5)
  }
  local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, PlayerPedId(), 0)
  local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
  
  local maxRadius = radiusCamMax
  if (hitBool and Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords) < radiusCamMax + 0.5) then
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

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(1)
      
      -- process cam controls if cam exists and player is dead
      if isInConcess then
          ProcessCamControls()
      end
  end
end)

Citizen.CreateThread(function()
  local coords = {x = concessSpawn.x, y = concessSpawn.y, z = concessSpawn.z}
  while true do
    Wait(1)
    RemoveVehiclesFromGeneratorsInArea(coords.x-20, coords.y-20, coords.z-20, coords.x+20, coords.y+20, coords.z+20)
  end
end)


function closeConcess()
  local ped = PlayerPedId()
  exports.menu:closeMenu()
  DoScreenFadeOut(300)
  while not IsScreenFadedOut() do
    Wait(0)
  end
  if vehConcess then 
    DeleteVehicle(vehConcess)
  end
  x = -56.6
  y = -1096.4
  z = 25.43
  local hp = GetEntityHealth(ped)
  RequestCollisionAtCoord(x, y, z)
  NetworkResurrectLocalPlayer(x, y, z, h, true, true, false)
  SetEntityHealth(ped, hp)
  endConcessCam()
  FreezeEntityPosition(ped, false)
  DoScreenFadeIn(300)
  isInConcess = false
end


Citizen.CreateThread(function()
  local coords = {x = -56.6, y = -1096.4, z = 25.43} 
  local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
  SetBlipSprite(blip, 227)
  AddTextEntry("CONCESS", "Concessionnaire voiture")
  BeginTextCommandSetBlipName("CONCESS") 
  SetBlipCategory(blip, 2) 
  EndTextCommandSetBlipName(blip)
  SetBlipAsShortRange(blip, true)
  while true do 
      local interval = 20
      local pos = GetEntityCoords(PlayerPedId())
      local dest = vector3(coords.x, coords.y, coords.z)
      local distance = GetDistanceBetweenCoords(pos, dest, true)


      if distance > 50 then
          interval = 500
      else
          interval = 1
          DrawMarker(27, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 0, 0, 255, 175, 0, 0, 2, 0, nil, nil, 0)
          if distance < 2 then 
              AddTextEntry("CONCESS", "Appuyez sur la touche ~INPUT_CONTEXT~")
              DisplayHelpTextThisFrame("CONCESS", false)
              if IsControlJustPressed(1, 51) then
                Wait(200)
                isInConcess = true
                
                local ped = PlayerPedId()
                local hp = GetEntityHealth(ped)

                DoScreenFadeOut(300)
                while not IsScreenFadedOut() do
                  Wait(0)
                end
                x = concessSpawn.x
                y = concessSpawn.y
                z = concessSpawn.z-6
                RequestCollisionAtCoord(x, y, z)
                NetworkResurrectLocalPlayer(x, y, z, h, true, true, false)
                SetEntityHealth(ped, hp)
                startConcessCam()
                FreezeEntityPosition(ped, true)
                DoScreenFadeIn(300)
                exports.menu:openMenu(menuConcess)
                Wait(500)

                CreateThread(function()
                  while isInConcess do
                    Wait(0)
                    if vehConcess and priceConcess then
                      AddTextEntry("CONCESS", "Appuyez sur la touche ~INPUT_SPECIAL_ABILITY_SECONDARY~ pour ACHETER le véhicule")
                      DisplayHelpTextThisFrame("CONCESS", false)
                      if IsControlJustPressed(1, 29) then
                        TriggerServerEvent("buyCar", getVehicleMods(vehConcess), priceConcess)
                        closeConcess()
                      end
                    end
                    if IsEntityDead(ped) or not exports.menu:isMenuOpen() then
                      closeConcess()
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
                end)
              end
          end
      end
      Citizen.Wait(interval)
  end
end)


-- GARAGE CONCESS
Citizen.CreateThread(function()
  while true do
      local interval = 2000
      
      local pos = GetEntityCoords(PlayerPedId())
      local dest = vector3(-43.1,	-1113.47,	25.3)
      local distance = GetDistanceBetweenCoords(pos, dest, true)

      if distance < 60 then
          interval = 500
          if distance < 20 then
              interval = 0
              DrawMarker(1, -43.1,	-1113.47,	25.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.5, 4.5, 1.0, 255, 154, 24, 100, 0, 0, 2, 0, nil, nil, 0)
              if distance < 3 then 
                  if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                    if not exports.menu:isMenuOpen() then
                      AddTextEntry("CONCESS", "Appuyez sur la touche ~INPUT_CONTEXT~ ~s~pour ~g~sortir ~s~un véhicule.")
                      DisplayHelpTextThisFrame("CONCESS", false)
                      if IsControlJustPressed(1, 51) then
                          TriggerServerEvent("getCarInGarage", {id=13,name="Concessionnaire",x=-43.1,y=-1113.47,z=25.3})
                      end
                    end
                  else
                    AddTextEntry("FOURRIERE", "~r~Sortie de garage, merci de ne pas gêner cet espace.")
                    DisplayHelpTextThisFrame("FOURRIERE", false)
                  end
              end
          end
      end
              
      Citizen.Wait(interval)
  end
end)





-- local currentlyTowedVehicle = nil

-- RegisterNetEvent('asser:tow')
-- AddEventHandler('asser:tow', function()
	
-- 	local playerped = GetPlayerPed(-1)
-- 	local vehicle = GetVehiclePedIsIn(playerped, true)

-- 	local towmodel = GetHashKey('flatbed')
-- 	local isVehicleTow = IsVehicleModel(vehicle, towmodel)
			
-- 	if isVehicleTow then
	
--         local pos = GetEntityCoords(GetPlayerPed(-1))
--         targetVehicle = GetClosestVehicleCustom()
		
-- 		if currentlyTowedVehicle == nil then
-- 			if targetVehicle ~= 0 then
-- 				if not IsPedInAnyVehicle(playerped, true) then
-- 					if vehicle ~= targetVehicle then
-- 						AttachEntityToEntity(targetVehicle, vehicle, GetEntityBoneIndexByName(vehicle, "chassis"), 0.0, -1.2, 0.7, 0.0, 0.0, 0.0, 0, 0, 1, 0, 0, 1)
-- 						currentlyTowedVehicle = targetVehicle
-- 						TriggerEvent("chatMessage", "[TOWFuckers]", {255, 255, 0}, "Vehicle successfully attached to towtruck!")
-- 					else
-- 						TriggerEvent("chatMessage", "[TOWFuckers]", {255, 255, 0}, "Are you retarded? You cant tow your own towtruck with your own towtruck?")
-- 					end
-- 				end
-- 			else
-- 				TriggerEvent("chatMessage", "[TOWFuckers]", {255, 255, 0}, "Theres no vehicle to tow?")
-- 			end
-- 		else
-- 			AttachEntityToEntity(currentlyTowedVehicle, vehicle, GetEntityBoneIndexByName(vehicle, "chassis"), 0.0, -9.0, 0.7, 0.0, 0.0, 0.0, 0, 0, 1, 0, 0, 1)
-- 			DetachEntity(currentlyTowedVehicle, true, true)
-- 			currentlyTowedVehicle = nil
-- 			TriggerEvent("chatMessage", "[TOWFuckers]", {255, 255, 0}, "The vehicle has been successfully detached!")
-- 		end
-- 	end
-- end)

-- function getVehicleInDirection(coordFrom, coordTo)
-- 	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
-- 	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
-- 	return vehicle
-- end



-- RegisterCommand('tow', function(source, args)
-- 	TriggerEvent("asser:tow", source)
-- end, false)


RegisterNetEvent("lockHotwiredNeeded")
AddEventHandler('lockHotwiredNeeded', function(vehicle, seat)
    if IsVehicleNeedsToBeHotwired(vehicle) and GetVehicleDoorLockStatus(vehicle) == 7 then
        SetVehicleDoorsLocked(vehicle, 2)
    end
	-- local e = NetworkGetEntityOwner(vehicle)
    -- netOwnerLocalId = NetworkGetEntityOwner(vehicle);

    -- if  netOwnerLocalId ~= 0 then
    --     playerServerId = GetPlayerServerId(netOwnerLocalId)
    --     TriggerEvent("notifynui", "info", "DEBUG", playerServerId)
    --     TriggerServerEvent("requestUnlock", playerServerId, vehicle)
    -- end
    -- TriggerEvent("notify", GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
    -- print(GetEntityModel(vehicle))
    -- print(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
end)

RegisterNetEvent("requestUnlockClient")
AddEventHandler('requestUnlockClient', function(vehicle)
    SetVehicleDoorsLocked(vehicle, 1)
end)





-- ***************** STATIONS SERVICE *********************************************************************************

Citizen.CreateThread(function()
    Citizen.Wait(10)
    for i,v in pairs(gasStations) do 
      local blip = AddBlipForCoord(v.coordinates.x, v.coordinates.y, v.coordinates.z)
      SetBlipAsShortRange(blip, true)
      SetBlipSprite(blip, 361)
      AddTextEntry("GASTATION", "Station essence")
      BeginTextCommandSetBlipName("GASTATION") 
      SetBlipCategory(blip, 1) 
      EndTextCommandSetBlipName(blip)
      SetBlipScale(blip, 0.7)
      SetBlipFade(blip, 150, 0)
  end
    while true do
        local interval = 2000
        if gasStations then 
            for i,station in pairs(gasStations) do
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local dest = vector3(station.coordinates.x, station.coordinates.y, station.coordinates.z)
                local distance = GetDistanceBetweenCoords(pos, dest, true)

                if distance < 60 then
                    interval = 500
                    if distance < 20 then
                        interval = 0
                        for j,pump in pairs(station.pumps) do 
                            local destpump = vector3(station.coordinates.x, station.coordinates.y, station.coordinates.z)
                            local distancepump = GetDistanceBetweenCoords(pos, destpump, true)
                            if distancepump < 6 then 
                                  local veh = GetVehiclePedIsIn(ped)
                                  if IsPedSittingInAnyVehicle(ped) and GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
                                    AddTextEntry("GASSTATION", "Appuyez ~INPUT_CONTEXT~ pour faire le plein à $2/L")
                                    DisplayHelpTextThisFrame("GASSTATION", false)
                                    if IsControlJustPressed(1, 51) then
                                        
                                        local fuel = math.floor(GetVehicleFuelLevel(veh)+0.5)
                                        local maxfuel = math.floor(GetVehicleHandlingFloat(veh,"CHandlingData","fPetrolTankVolume"))
                                        local maxfuelleft = maxfuel - fuel
                                        AddTextEntry('FMMC_KEY_TIP1', "("..fuel.."/"..maxfuel.."L) Maximum "..maxfuelleft.."L  -  $2/L")
                                        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", maxfuelleft, "", "", "", 3)
                                        while (UpdateOnscreenKeyboard() == 0) do
                                            DisableAllControlActions(0);
                                            Wait(0);
                                        end
                                        if (GetOnscreenKeyboardResult()) then
                                            local result = tonumber(GetOnscreenKeyboardResult())
                                            if result and result > 0 then
                                                if result > maxfuelleft then 
                                                    TriggerEvent("notifynui", "error", "Station Essence", "Attention ton réservoir va déborder.")
                                                else
                                                    SetVehicleEngineOn(veh, false, false, true)
                                                    TriggerEvent("notifynui", "info", "Station Essence", "Début du plein...")
                                                    TriggerEvent("progressBar", (result/2))
                                                    local totalLitre = 0
                                                    for i=1,result do
                                                        Citizen.Wait(500)
                                                        local pos = GetEntityCoords(ped)
                                                        local distancepump = GetDistanceBetweenCoords(pos, destpump, true)
                                                        if distancepump < 6 then 
                                                            if IsPlayerDead(PlayerId()) == false and IsPedSittingInAnyVehicle(ped) and not IsVehicleEngineOn(veh) then
                                                                totalLitre = totalLitre + 1
                                                                exports.frfuel:addFuel(1.0)
                                                            else 
                                                                TriggerEvent("notifynui", "info", "Station Essence", "Vous avez interrompu le remplissage à "..totalLitre.."L.")
                                                                TriggerEvent("stopProgressBar")
                                                                break 
                                                            end
                                                        else 
                                                            TriggerEvent("stopProgressBar")
                                                            TriggerEvent("notifynui", "info", "Station Essence", "Vous avez interrompu le remplissage à "..totalLitre.."L.")
                                                            break
                                                        end
                                                    end
                                                    SetVehicleEngineOn(veh, true, false, true)
                                                    if totalLitre > 0 then
                                                        TriggerServerEvent("updateBank", -(totalLitre*2))
                                                        TriggerEvent("notifynui", "success", "Station Essence", "Merci d'avoir choisi notre station, vous avez été débité de $"..(totalLitre*2).." par carte bancaire.")
                                                    end
                                                end
                                            else
                                                TriggerEvent("notifynui", "error", "Station Essence", "Erreur de saisie, montant impossible.")
                                            end
                                        end
                                    end
                                end
                            end

                        end
                    end
                end
            end
        end
        Citizen.Wait(interval)
    end
end)



gasStations = {
    {
        coordinates= {
          x= 49.418720245361328,
          y= 2778.79296875,
          z= 58.043949127197266
        },
        pumps = {
          {
            x= 49.499210357666016,
            y= 2778.912109375,
            z= 58.043991088867188
          }
        }
      },
      {
        coordinates= {
          x= 263.8948974609375,
          y= 2606.462890625,
          z= 44.983390808105469
        },
        pumps = {
          {
            x= 263.17318725585938,
            y= 2606.514892578125,
            z= 44.9852409362793
          },
          {
            x= 265.07391357421875,
            y= 2606.89990234375,
            z= 44.9852409362793
          }
        }
      },
      {
        coordinates= {
          x= 1039.9580078125,
          y= 2671.134033203125,
          z= 39.550910949707031
        },
        pumps = {
          {
            x= 1043.2860107421875,
            y= 2668.31591796875,
            z= 39.6953010559082
          },
          {
            x= 1035.779052734375,
            y= 2667.884033203125,
            z= 39.598419189453125
          },
          {
            x= 1035.363037109375,
            y= 2674.14599609375,
            z= 39.6953010559082
          },
          {
            x= 1043.22802734375,
            y= 2674.72705078125,
            z= 39.692588806152344
          }
        }
      },
      {
        coordinates= {
          x= 1207.260009765625,
          y= 2660.175048828125,
          z= 37.899959564208984
        },
        pumps = {
          {
            x= 1208.802978515625,
            y= 2659.409912109375,
            z= 38.292949676513672
          },
          {
            x= 1209.3819580078125,
            y= 2658.550048828125,
            z= 38.292961120605469
          },
          {
            x= 1206.1639404296875,
            y= 2662.242919921875,
            z= 38.292961120605469
          }
        }
      },
      {
        coordinates= {
          x= 2539.68505859375,
          y= 2594.19189453125,
          z= 37.944881439208984
        },
        pumps = {
          {
            x= 2540.0458984375,
            y= 2594.929931640625,
            z= 37.941139221191406
          }
        }
      },
      {
        coordinates= {
          x= 2679.85791015625,
          y= 3263.946044921875,
          z= 55.240570068359375
        },
        pumps = {
          {
            x= 2680.89208984375,
            y= 3266.343994140625,
            z= 55.156509399414062
          },
          {
            x= 2678.446044921875,
            y= 3262.31201171875,
            z= 55.156818389892578
          }
        }
      },
      {
        coordinates= {
          x= 2005.0550537109375,
          y= 3773.886962890625,
          z= 32.4039306640625
        },
        pumps = {
          {
            x= 2009.2080078125,
            y= 3776.83203125,
            z= 32.147579193115234
          },
          {
            x= 2006.240966796875,
            y= 3775.010009765625,
            z= 32.1514892578125
          },
          {
            x= 2003.9210205078125,
            y= 3773.583984375,
            z= 32.14501953125
          },
          {
            x= 2001.4840087890625,
            y= 3772.196044921875,
            z= 32.146701812744141
          }
        }
      },
      {
        coordinates= {
          x= 1687.156005859375,
          y= 4929.39208984375,
          z= 42.078090667724609
        },
        pumps = {
          {
            x= 1684.635986328125,
            y= 4931.69580078125,
            z= 41.929531097412109
          },
          {
            x= 1690.1689453125,
            y= 4927.81591796875,
            z= 41.919490814208984
          }
        }
      },
      {
        coordinates= {
          x= 1701.31396484375,
          y= 6416.02783203125,
          z= 32.763950347900391
        },
        pumps = {
          {
            x= 1701.72900390625,
            y= 6416.4228515625,
            z= 32.988300323486328
          },
          {
            x= 1697.7020263671875,
            y= 6418.27587890625,
            z= 32.396610260009766
          },
          {
            x= 1705.75,
            y= 6414.47607421875,
            z= 32.471309661865234
          }
        }
      },
      {
        coordinates= {
          x= 179.8572998046875,
          y= 6602.8388671875,
          z= 31.8681697845459
        },
        pumps = {
          {
            x= 172.11669921875,
            y= 6603.4599609375,
            z= 31.767589569091797
          },
          {
            x= 179.74920654296875,
            y= 6604.9619140625,
            z= 31.750480651855469
          },
          {
            x= 187.04389953613281,
            y= 6606.25390625,
            z= 31.751010894775391
          }
        }
      },
      {
        coordinates= {
          x= -94.461990356445312,
          y= 6419.59423828125,
          z= 31.489519119262695
        },
        pumps = {
          {
            x= -97.033683776855469,
            y= 6416.826171875,
            z= 31.386800765991211
          },
          {
            x= -91.3159408569336,
            y= 6422.505859375,
            z= 31.342670440673828
          }
        }
      },
      {
        coordinates= {
          x= -2554.99609375,
          y= 2334.402099609375,
          z= 33.078029632568359
        },
        pumps = {
          {
            x= -2551.4208984375,
            y= 2327.216064453125,
            z= 33.017440795898438
          },
          {
            x= -2558.01806640625,
            y= 2327.195068359375,
            z= 33.078041076660156
          },
          {
            x= -2558.60791015625,
            y= 2334.410888671875,
            z= 32.963539123535156
          },
          {
            x= -2552.719970703125,
            y= 2334.7060546875,
            z= 32.972648620605469
          },
          {
            x= -2552.409912109375,
            y= 2341.948974609375,
            z= 33.005199432373047
          },
          {
            x= -2558.843017578125,
            y= 2340.989013671875,
            z= 33.010990142822266
          }
        }
      },
      {
        coordinates= {
          x= -1800.375,
          y= 803.66192626953125,
          z= 138.65119934082031
        },
        pumps = {
          {
            x= -1796.2939453125,
            y= 811.601806640625,
            z= 138.50579833984375
          },
          {
            x= -1790.8709716796875,
            y= 806.37408447265625,
            z= 138.20289611816406
          },
          {
            x= -1797.1510009765625,
            y= 800.720703125,
            z= 138.38909912109375
          },
          {
            x= -1802.280029296875,
            y= 806.30792236328125,
            z= 138.37510681152344
          },
          {
            x= -1808.656982421875,
            y= 799.99041748046875,
            z= 138.427001953125
          },
          {
            x= -1803.636962890625,
            y= 794.51141357421875,
            z= 138.40969848632813
          }
        }
      },
      {
        coordinates= {
          x= -1437.6219482421875,
          y= -276.74758911132812,
          z= 46.207710266113281
        },
        pumps = {
          {
            x= -1444.3399658203125,
            y= -274.1885986328125,
            z= 46.119308471679688
          },
          {
            x= -1435.3900146484375,
            y= -284.62548828125,
            z= 46.122360229492188
          },
          {
            x= -1428.98095703125,
            y= -278.96749877929688,
            z= 46.108089447021484
          },
          {
            x= -1438.0030517578125,
            y= -268.39871215820312,
            z= 46.075351715087891
          }
        }
      },
      {
        coordinates= {
          x= -2096.242919921875,
          y= -320.28671264648438,
          z= 13.168569564819336
        },
        pumps = {
          {
            x= -2089.239990234375,
            y= -327.372802734375,
            z= 13.028949737548828
          },
          {
            x= -2088.4560546875,
            y= -320.83160400390625,
            z= 12.974220275878906
          },
          {
            x= -2087.032958984375,
            y= -312.79739379882812,
            z= 12.906490325927734
          },
          {
            x= -2095.93310546875,
            y= -311.92739868164062,
            z= 12.90725040435791
          },
          {
            x= -2096.466064453125,
            y= -320.41830444335938,
            z= 13.028849601745606
          },
          {
            x= -2097.3359375,
            y= -326.397705078125,
            z= 12.88916015625
          },
          {
            x= -2105.950927734375,
            y= -325.5889892578125,
            z= 12.935210227966309
          },
          {
            x= -2105.10302734375,
            y= -319.01840209960938,
            z= 12.877900123596191
          },
          {
            x= -2104.419921875,
            y= -311.00900268554688,
            z= 12.933449745178223
          }
        }
      },
      {
        coordinates= {
          x= -724.61920166015625,
          y= -935.1630859375,
          z= 19.213859558105469
        },
        pumps = {
          {
            x= -715.043212890625,
            y= -932.56378173828125,
            z= 19.07505989074707
          },
          {
            x= -715.4774169921875,
            y= -939.2255859375,
            z= 19.350490570068359
          },
          {
            x= -723.8599853515625,
            y= -939.2935791015625,
            z= 18.862829208374023
          },
          {
            x= -723.7554931640625,
            y= -932.4473876953125,
            z= 19.402450561523438
          },
          {
            x= -732.39312744140625,
            y= -932.56280517578125,
            z= 19.413459777832031
          },
          {
            x= -732.469970703125,
            y= -939.54620361328125,
            z= 18.945060729980469
          }
        }
      },
      {
        coordinates= {
          x= -526.019775390625,
          y= -1211.0030517578125,
          z= 18.184829711914062
        },
        pumps = {
          {
            x= -518.49932861328125,
            y= -1209.4429931640625,
            z= 18.077829360961914
          },
          {
            x= -521.27471923828125,
            y= -1208.4019775390625,
            z= 18.061979293823242
          },
          {
            x= -526.128173828125,
            y= -1206.4019775390625,
            z= 18.068170547485352
          },
          {
            x= -528.5460205078125,
            y= -1204.93798828125,
            z= 18.089929580688477
          },
          {
            x= -532.3411865234375,
            y= -1212.7740478515625,
            z= 18.075939178466797
          },
          {
            x= -529.4605712890625,
            y= -1213.782958984375,
            z= 18.075889587402344
          },
          {
            x= -524.92578125,
            y= -1216.4420166015625,
            z= 18.039810180664062
          },
          {
            x= -522.18072509765625,
            y= -1217.3709716796875,
            z= 18.076009750366211
          }
        }
      },
      {
        coordinates= {
          x= -70.21484375,
          y= -1761.7919921875,
          z= 29.534019470214844
        },
        pumps = {
          {
            x= -63.784229278564453,
            y= -1767.8070068359375,
            z= 29.5849609375
          },
          {
            x= -61.2121696472168,
            y= -1760.782958984375,
            z= 29.573970794677734
          },
          {
            x= -69.465591430664062,
            y= -1758.156982421875,
            z= 29.255090713500977
          },
          {
            x= -72.028778076171875,
            y= -1765.1300048828125,
            z= 29.238740921020508
          },
          {
            x= -80.310966491699219,
            y= -1762.1650390625,
            z= 29.508279800415039
          },
          {
            x= -77.669830322265625,
            y= -1755.0770263671875,
            z= 29.527690887451172
          }
        }
      },
      {
        coordinates= {
          x= 265.64840698242188,
          y= -1261.3089599609375,
          z= 29.292940139770508
        },
        pumps = {
          {
            x= 273.88919067382812,
            y= -1268.60595703125,
            z= 29.508960723876953
          },
          {
            x= 273.91018676757812,
            y= -1261.3409423828125,
            z= 29.458410263061523
          },
          {
            x= 273.9552001953125,
            y= -1253.5550537109375,
            z= 29.004629135131836
          },
          {
            x= 265.08810424804688,
            y= -1253.458984375,
            z= 29.534889221191406
          },
          {
            x= 264.59759521484375,
            y= -1261.260986328125,
            z= 29.443119049072266
          },
          {
            x= 265.19259643554688,
            y= -1268.5030517578125,
            z= 29.069480895996094
          },
          {
            x= 256.46160888671875,
            y= -1268.6259765625,
            z= 29.551509857177734
          },
          {
            x= 256.51739501953125,
            y= -1261.2869873046875,
            z= 28.948049545288086
          },
          {
            x= 256.47250366210938,
            y= -1253.448974609375,
            z= 29.557689666748047
          }
        }
      },
      {
        coordinates= {
          x= 819.65380859375,
          y= -1028.845947265625,
          z= 26.403419494628906
        },
        pumps = {
          {
            x= 826.75128173828125,
            y= -1026.1650390625,
            z= 26.357280731201172
          },
          {
            x= 826.7982177734375,
            y= -1030.967041015625,
            z= 26.429569244384766
          },
          {
            x= 819.14111328125,
            y= -1030.9969482421875,
            z= 26.229820251464844
          },
          {
            x= 819.15008544921875,
            y= -1026.3690185546875,
            z= 26.181209564208984
          },
          {
            x= 810.82037353515625,
            y= -1026.366943359375,
            z= 26.151189804077148
          },
          {
            x= 810.8690185546875,
            y= -1031.196044921875,
            z= 26.158199310302734
          }
        }
      },
      {
        coordinates= {
          x= 1208.9510498046875,
          y= -1402.5670166015625,
          z= 35.224189758300781
        },
        pumps = {
          {
            x= 1210.22705078125,
            y= -1407.06494140625,
            z= 35.114448547363281
          },
          {
            x= 1213.0069580078125,
            y= -1404.0789794921875,
            z= 35.095840454101562
          },
          {
            x= 1207.0810546875,
            y= -1398.2960205078125,
            z= 35.157279968261719
          },
          {
            x= 1204.208984375,
            y= -1401.1009521484375,
            z= 35.131858825683594
          }
        }
      },
      {
        coordinates= {
          x= 1181.3809814453125,
          y= -330.84710693359375,
          z= 69.316513061523438
        },
        pumps = {
          {
            x= 1186.4560546875,
            y= -338.14840698242188,
            z= 69.5254135131836
          },
          {
            x= 1179.0550537109375,
            y= -339.394287109375,
            z= 69.6856689453125
          },
          {
            x= 1177.467041015625,
            y= -331.177490234375,
            z= 68.971786499023438
          },
          {
            x= 1184.803955078125,
            y= -329.97158813476562,
            z= 69.489906311035156
          },
          {
            x= 1183.2239990234375,
            y= -321.36898803710938,
            z= 69.195938110351562
          },
          {
            x= 1175.6429443359375,
            y= -322.26959228515625,
            z= 68.982192993164062
          }
        }
      },
      {
        coordinates= {
          x= 620.8433837890625,
          y= 269.10089111328125,
          z= 103.08950042724609
        },
        pumps = {
          {
            x= 629.555419921875,
            y= 263.85690307617188,
            z= 103.02239990234375
          },
          {
            x= 629.37908935546875,
            y= 273.95458984375,
            z= 102.99870300292969
          },
          {
            x= 620.789794921875,
            y= 273.88861083984375,
            z= 102.99880218505859
          },
          {
            x= 612.34820556640625,
            y= 274.08468627929688,
            z= 103.00430297851563
          },
          {
            x= 612.27130126953125,
            y= 263.88848876953125,
            z= 102.99179840087891
          },
          {
            x= 620.9271240234375,
            y= 263.83108520507812,
            z= 103.02510070800781
          }
        }
      },
      {
        coordinates= {
          x= 2581.321044921875,
          y= 362.039306640625,
          z= 108.46880340576172
        },
        pumps = {
          {
            x= 2588.462890625,
            y= 358.53900146484375,
            z= 108.39579772949219
          },
          {
            x= 2589.12890625,
            y= 363.90438842773438,
            z= 108.39949798583984
          },
          {
            x= 2581.26611328125,
            y= 364.24551391601562,
            z= 108.39980316162109
          },
          {
            x= 2581.087890625,
            y= 358.8944091796875,
            z= 108.37239837646484
          },
          {
            x= 2573.717041015625,
            y= 359.02780151367188,
            z= 108.36150360107422
          },
          {
            x= 2573.843994140625,
            y= 364.69720458984375,
            z= 108.39579772949219
          }
        }
      },
      {
        coordinates= {
          x= 1785.363037109375,
          y= 3330.3720703125,
          z= 41.381881713867188
        },
        pumps = {
          {
            x= 1785.89501953125,
            y= 3330.16796875,
            z= 41.345619201660156
          },
          {
            x= 1785.14501953125,
            y= 3331.251953125,
            z= 41.381229400634766
          }
        }
      },
      {
        coordinates= {
          x= -319.69000244140625,
          y= -1471.6099853515625,
          z= 30.030000686645508
        },
        pumps = {
          {
            x= -310.3699951171875,
            y= -1472.030029296875,
            z= 30.719999313354492
          },
          {
            x= -315.45999145507812,
            y= -1463.27001953125,
            z= 30.719999313354492
          },
          {
            x= -321.79998779296875,
            y= -1467.030029296875,
            z= 30.719999313354492
          },
          {
            x= -316.67999267578125,
            y= -1475.93994140625,
            z= 30.719999313354492
          },
          {
            x= -324.22000122070312,
            y= -1480.1700439453125,
            z= 30.719999313354492
          },
          {
            x= -329.30999755859375,
            y= -1471.3499755859375,
            z= 30.719999313354492
          }
        }
      },
      {
        coordinates= {
          x= 174.8800048828125,
          y= -1562.449951171875,
          z= 28.739999771118164
        },
        pumps = {
          {
            x= 169.64999389648438,
            y= -1562.6800537109375,
            z= 29.319999694824219
          },
          {
            x= 176.41999816894531,
            y= -1556.280029296875,
            z= 29.319999694824219
          },
          {
            x= 181.38999938964844,
            y= -1561.56005859375,
            z= 29.319999694824219
          },
          {
            x= 174.63999938964844,
            y= -1567.68994140625,
            z= 29.319999694824219
          }
        }
      },
      {
        coordinates= {
          x= 1246.47998046875,
          y= -1485.449951171875,
          z= 34.900001525878906
        },
        pumps = {
          {
            x= 1246.1600341796875,
            y= -1488.1500244140625,
            z= 34.900001525878906
          },
          {
            x= 1246.47998046875,
            y= -1482.760009765625,
            z= 34.900001525878906
          }
        }
      },
      {
        coordinates= {
          x= -66.330001831054688,
          y= -2532.570068359375,
          z= 6.1399998664855957
        },
        pumps = {
          {
            x= -64.25,
            y= -2533.89990234375,
            z= 6.1399998664855957
          },
          {
            x= -68.720001220703125,
            y= -2530.7099609375,
            z= 6.1399998664855957
          }
        }
      }
}