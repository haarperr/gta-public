local character
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

AddEventHandler('onClientResourceStart', function()
end)


RegisterNetEvent('getCharacterCallback')
AddEventHandler('getCharacterCallback', function(c)
    character = c
end)



-- TEST




-- RegisterCommand("alarm", function(source, args, rawcommand)
-- 	local alarm = "AGENCY_HEIST_FIB_TOWER_ALARMS"
--     StartAlarm(alarm, 0)
--     Wait(10000)
-- 	StopAlarm(alarm, 1)
-- end, false)


-- RegisterCommand("music", function(source, args, rawcommand)
-- 	-- RequestScriptAudioBank("DLC_BATTLE/BTL_CLUB_OPEN_TRANSITION_CROWD", false, -1)
-- 	-- StartAudioScene("DLC_Ba_NightClub_Scene")
-- 	-- PlaySoundFrontend(-1, "club_crowd_transition", "dlc_btl_club_open_transition_crowd_sounds", true)
-- 	local h = "anim@mp_player_intcelebrationfemale@raise_the_roof"
-- 	local ped = GetPlayerPed(-1)
-- 	RequestAnimDict(h)
-- 	while not HasAnimDictLoaded(h) do
-- 		Citizen.Wait(0)
-- 	end
-- 	TaskPlayAnim(ped, h , 'raise_the_roof' ,8.0, -8.0, -1, 1, 0, false, false, false )
-- 	TriggerEvent("progressBar", 10)
-- 	Wait(10000)
-- 	ClearPedTasksImmediately(ped)
-- end, false)


Citizen.CreateThread(function()
	-- AddDoorToSystem(431362, -1918480350, -1529.0, -41.5, 56.86, 0, 0, 0)
	-- DoorSystemSetDoorState(431362, 1, 1, 1)
	-- local closeDoor = GetClosestObjectOfType(-1529.0, -41.5, 56.86, 1.0, -1918480350, false, false, false)
	-- FreezeEntityPosition(closeDoor, true)
	-- -- AddDoorToSystem(430082, -349730013, -1533.9, -42.7, 56.9, 0, 0, 0)
	-- -- DoorSystemSetDoorState(430082, 2, 1, 1)
	-- local closeDoor2 = GetClosestObjectOfType(-1533.9, -42.7, 56.9, 1.0, -349730013, false, false, false)
	-- FreezeEntityPosition(closeDoor2, true)





	local components = {
		"Tête",
		"Barbe",
		"Cheveux",
		"Poils de torse",
		"Jambes",
		"Mains",
		"Pieds",
		"--",
		"Accessoire 1",
		"Accessoire 2",
		"Décalcomanies",
		"Torse auxiliaire",
	}






	local ped = GetPlayerPed(-1)
	-- print(GetEntityModel(ped))
	-- print("-------------------------")

	-- local drawables = {}
	-- local drawableTextures = {}
	-- local props = {}
	-- local propTextures = {}



	-- local hairStyle = GetPedDrawableVariation(ped, 2)
	-- local hairColor = GetPedDrawableVariation(ped, 2)



	-- for i=0,11 do 
	-- 	-- print('DrawId    : '..GetPedDrawableVariation(ped, i))
	-- 	local retval, overlayValue, colourType, firstColour, secondColour, overlayOpacity = GetPedHeadOverlayData(ped, i)
	-- 	table.insert(drawables,{value=overlayValue,opacity=overlayOpacity,color=colourType})
	-- 	-- print('TextureId : '..GetPedTextureVariation(ped, i))
	-- 	table.insert(drawableTextures,{i=i,d=GetPedTextureVariation(ped, i)})
	-- end
	-- -- for i=0,11 do 
	-- -- 	-- print('Prop         : '..GetPedPropIndex(ped, i))
	-- -- 	table.insert(props,{i=i,d=GetPedPropIndex(ped, i)})
	-- -- 	-- print('Prop Texture : '..GetPedPropTextureIndex(ped, i))
	-- -- 	table.insert(propTextures,{i=i,d=GetPedPropTextureIndex(ped, i)})
	-- -- end
	-- print("-------------------------")






	-- local kvpHandle = StartFindExternalKvp('vMenu','mp_ped')



	-- if kvpHandle ~= -1 then 
	
	-- 	local key
	
		
	
	-- 	repeat
	-- 		Wait(0)
	
	-- 		key = FindKvp(kvpHandle)
	
	
	
	-- 		if key then
	
	-- 			print(('%s: %s'):format(key, GetResourceKvpString(key)))
	
	-- 		end
	
	-- 	until key
	
	
	
	-- 	EndFindKvp(kvpHandle)
	
	-- end

	
	-- RequestModel(GetHashKey("mp_f_freemode_01"));
	-- while not HasModelLoaded(GetHashKey("mp_f_freemode_01")) do
	-- 	Wait(0)
	-- end
	-- Wait(2000)

	-- SetPlayerModel(ped, GetHashKey("mp_f_freemode_01"))

	-- ClearPedDecorations(ped);
	-- ClearPedFacialDecorations(ped);
	-- SetPedDefaultComponentVariation(ped);
	-- SetPedHairColor(ped, 0, 0);
	-- SetPedEyeColor(ped, 0);
	-- ClearAllPedProps(ped);

	-- Wait(2000)

	-- for i=0,21 do 
	-- 	SetPedComponentVariation(ped, drawables[i].i, drawables[i].d, drawableTextures[i].d, 1)
	-- end
	-- for i=0,21 do 
	-- 	if (props[i].d == -1 or propTextures[i].d == -1) then 
	-- 		ClearPedProp(ped, i)
	-- 	else
	-- 		SetPedPropIndex(ped, drawables[i].i, props[i].d, propTextures[i].d, true)
	-- 	end
	-- end

-- 1885233650	
	-- SetPedComponentVariation(ped, drawable, pedCustomizationOptions.drawableVariations[drawable],
	-- pedCustomizationOptions.drawableVariationTextures[drawable], 1);

	-- for (var drawable = 0; drawable < 21; drawable++)
	-- {
	-- 	SetPedComponentVariation(ped, drawable, pedCustomizationOptions.drawableVariations[drawable],
	-- 		pedCustomizationOptions.drawableVariationTextures[drawable], 1);
	-- }

	-- for (var i = 0; i < 21; i++)
	-- {
	-- 	int prop = pedCustomizationOptions.props[i];
	-- 	int propTexture = pedCustomizationOptions.propTextures[i];
	-- 	if (prop == -1 || propTexture == -1)
	-- 	{
	-- 		ClearPedProp(ped, i);
	-- 	}
	-- 	else
	-- 	{
	-- 		SetPedPropIndex(ped, i, prop, propTexture, true);
	-- 	}
	-- }






















	-- ClearPedDecorations(Game.PlayerPed.Handle);
	-- ClearPedFacialDecorations(Game.PlayerPed.Handle);
	-- SetPedDefaultComponentVariation(Game.PlayerPed.Handle);
	-- SetPedHairColor(Game.PlayerPed.Handle, 0, 0);
	-- SetPedEyeColor(Game.PlayerPed.Handle, 0);
	-- ClearAllPedProps(Game.PlayerPed.Handle);

	-- #region headblend
	-- var data = currentCharacter.PedHeadBlendData;
	-- SetPedHeadBlendData(Game.PlayerPed.Handle, data.FirstFaceShape, data.SecondFaceShape, data.ThirdFaceShape, data.FirstSkinTone, data.SecondSkinTone, data.ThirdSkinTone, data.ParentFaceShapePercent, data.ParentSkinTonePercent, 0f, data.IsParentInheritance);

	-- while (!HasPedHeadBlendFinished(Game.PlayerPed.Handle))
	-- {
	-- 	await BaseScript.Delay(0);
	-- }
	-- #endregion

	-- #region appearance
	-- var appData = currentCharacter.PedAppearance;
	-- // hair
	-- SetPedComponentVariation(Game.PlayerPed.Handle, 2, appData.hairStyle, 0, 0);
	-- SetPedHairColor(Game.PlayerPed.Handle, appData.hairColor, appData.hairHighlightColor);
	-- if (!string.IsNullOrEmpty(appData.HairOverlay.Key) && !string.IsNullOrEmpty(appData.HairOverlay.Value))
	-- {
	-- 	SetPedFacialDecoration(Game.PlayerPed.Handle, (uint)GetHashKey(appData.HairOverlay.Key), (uint)GetHashKey(appData.HairOverlay.Value));
	-- }
	-- // blemishes
	-- SetPedHeadOverlay(Game.PlayerPed.Handle, 0, appData.blemishesStyle, appData.blemishesOpacity);
	-- // bread
	-- SetPedHeadOverlay(Game.PlayerPed.Handle, 1, appData.beardStyle, appData.beardOpacity);
	-- SetPedHeadOverlayColor(Game.PlayerPed.Handle, 1, 1, appData.beardColor, appData.beardColor);
	-- // eyebrows
	-- SetPedHeadOverlay(Game.PlayerPed.Handle, 2, appData.eyebrowsStyle, appData.eyebrowsOpacity);
	-- SetPedHeadOverlayColor(Game.PlayerPed.Handle, 2, 1, appData.eyebrowsColor, appData.eyebrowsColor);
	-- // ageing
	-- SetPedHeadOverlay(Game.PlayerPed.Handle, 3, appData.ageingStyle, appData.ageingOpacity);
	-- // makeup
	-- SetPedHeadOverlay(Game.PlayerPed.Handle, 4, appData.makeupStyle, appData.makeupOpacity);
	-- SetPedHeadOverlayColor(Game.PlayerPed.Handle, 4, 2, appData.makeupColor, appData.makeupColor);
	-- // blush
	-- SetPedHeadOverlay(Game.PlayerPed.Handle, 5, appData.blushStyle, appData.blushOpacity);
	-- SetPedHeadOverlayColor(Game.PlayerPed.Handle, 5, 2, appData.blushColor, appData.blushColor);
	-- // complexion
	-- SetPedHeadOverlay(Game.PlayerPed.Handle, 6, appData.complexionStyle, appData.complexionOpacity);
	-- // sundamage
	-- SetPedHeadOverlay(Game.PlayerPed.Handle, 7, appData.sunDamageStyle, appData.sunDamageOpacity);
	-- // lipstick
	-- SetPedHeadOverlay(Game.PlayerPed.Handle, 8, appData.lipstickStyle, appData.lipstickOpacity);
	-- SetPedHeadOverlayColor(Game.PlayerPed.Handle, 8, 2, appData.lipstickColor, appData.lipstickColor);
	-- // moles and freckles
	-- SetPedHeadOverlay(Game.PlayerPed.Handle, 9, appData.molesFrecklesStyle, appData.molesFrecklesOpacity);
	-- // chest hair 
	-- SetPedHeadOverlay(Game.PlayerPed.Handle, 10, appData.chestHairStyle, appData.chestHairOpacity);
	-- SetPedHeadOverlayColor(Game.PlayerPed.Handle, 10, 1, appData.chestHairColor, appData.chestHairColor);
	-- // body blemishes 
	-- SetPedHeadOverlay(Game.PlayerPed.Handle, 11, appData.bodyBlemishesStyle, appData.bodyBlemishesOpacity);
	-- // eyecolor
	-- SetPedEyeColor(Game.PlayerPed.Handle, appData.eyeColor);
	-- #endregion

	-- #region Face Shape Data
	-- for (var i = 0; i < 19; i++)
	-- {
	-- 	SetPedFaceFeature(Game.PlayerPed.Handle, i, 0f);
	-- }

	-- if (currentCharacter.FaceShapeFeatures.features != null)
	-- {
	-- 	foreach (var t in currentCharacter.FaceShapeFeatures.features)
	-- 	{
	-- 		SetPedFaceFeature(Game.PlayerPed.Handle, t.Key, t.Value);
	-- 	}
	-- }
	-- else
	-- {
	-- 	currentCharacter.FaceShapeFeatures.features = new Dictionary<int, float>();
	-- }

	-- #endregion

	-- #region Clothing Data
	-- if (currentCharacter.DrawableVariations.clothes != null && currentCharacter.DrawableVariations.clothes.Count > 0)
	-- {
	-- 	foreach (var cd in currentCharacter.DrawableVariations.clothes)
	-- 	{
	-- 		SetPedComponentVariation(Game.PlayerPed.Handle, cd.Key, cd.Value.Key, cd.Value.Value, 0);
	-- 	}
	-- }
	-- #endregion

	-- #region Props Data
	-- if (currentCharacter.PropVariations.props != null && currentCharacter.PropVariations.props.Count > 0)
	-- {
	-- 	foreach (var cd in currentCharacter.PropVariations.props)
	-- 	{
	-- 		if (cd.Value.Key > -1)
	-- 		{
	-- 			SetPedPropIndex(Game.PlayerPed.Handle, cd.Key, cd.Value.Key, cd.Value.Value > -1 ? cd.Value.Value : 0, true);
	-- 		}
	-- 	}
	-- }
	-- #endregion

















end)

















-- SetPedComponentVariation(ped, 0, 0, 0, 0)
-- SetPedComponentVariation(ped, 1, 36, 0, 0)
-- SetPedComponentVariation(ped, 2, 50, 0, 0)
-- SetPedComponentVariation(ped, 3, 15, 0, 0)
-- SetPedComponentVariation(ped, 4, 102, 0, 0)
-- SetPedComponentVariation(ped, 5, 0, 0, 0)
-- SetPedComponentVariation(ped, 6, 6, 0, 0)
-- SetPedComponentVariation(ped, 8, 15, 0, 0)
-- SetPedComponentVariation(ped, 9, 0, 0, 0)
-- SetPedComponentVariation(ped, 10, 0, 0, 0)
-- SetPedComponentVariation(ped, 11, 15, 0, 0)
-- SetPedPropIndex(ped, 0, 83, 0, 1)
-- SetPedHeadBlendData(ped, "Noah", "Gisele", nil, "Noah", "Gisele", nil, 1.0, 1.0, nil, true);

-- print(GetEntityModel(PlayerPedId()))








function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end




RegisterCommand("hump",function(source, args)

    local ad = "creatures@rottweiler@amb@"
	local anim = "hump_loop_chop" 
	local player = PlayerPedId()
	

	if ( DoesEntityExist( player ) and not IsEntityDead(player) and IsEntityPlayingAnim(player, "mp_arresting", "idle", 3)) then
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, anim, 3 ) ) then 
			TaskPlayAnim( player, ad, "exit", 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
			Wait(900)
			ClearPedTask(player)
		else
			TaskPlayAnim( player, ad, anim, 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
		end       
	end

end, false)


RegisterCommand("sit",function(source, args)

    local ad = "creatures@retriever@amb@world_dog_sitting@idle_a"
	local anim = "idle_b" 
	local player = PlayerPedId()
	

	if ( DoesEntityExist( player ) and not IsEntityDead(player) and IsEntityPlayingAnim(player, "mp_arresting", "idle", 3)) then
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, anim, 3 ) ) then 
			TaskPlayAnim( player, ad, "exit", 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
			
			ClearPedTask(player)
		else
			TaskPlayAnim( player, ad, anim, 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
		end       
	end

end, false)



RegisterCommand("bark",function(source, args)

    local ad = "creatures@retriever@amb@world_dog_barking@idle_a"
	local anim = "idle_a" 
	local player = PlayerPedId()
	

	if ( DoesEntityExist( player ) and not IsEntityDead(player) and IsEntityPlayingAnim(player, "mp_arresting", "idle", 3)) then
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, anim, 3 ) ) then 
			TaskPlayAnim( player, ad, "exit", 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
			
			ClearPedTask(player)
		else
			TaskPlayAnim( player, ad, anim, 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
		end       
	end

end, false)

RegisterCommand("shit",function(source, args)

    local ad = "creatures@rottweiler@move"
	local anim = "dump_loop" 
	local player = PlayerPedId()
	

	if ( DoesEntityExist( player ) and not IsEntityDead(player) and IsEntityPlayingAnim(player, "mp_arresting", "idle", 3)) then
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, anim, 3 ) ) then 
			TaskPlayAnim( player, ad, "exit", 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
			
			ClearPedTask(player)
		else
			TaskPlayAnim( player, ad, anim, 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
		end       
	end

end, false)


RegisterCommand("sleep",function(source, args)

    local ad = "creatures@rottweiler@amb@sleep_in_kennel@"
	local anim = "sleep_in_kennel" 
	local player = PlayerPedId()
	

	if ( DoesEntityExist( player ) and not IsEntityDead(player) and IsEntityPlayingAnim(player, "mp_arresting", "idle", 3)) then
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, anim, 3 ) ) then 
			TaskPlayAnim( player, ad, "exit", 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
			
			ClearPedTask(player)
		else
			TaskPlayAnim( player, ad, anim, 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
		end       
	end

end, false)

RegisterCommand("pissright",function(source, args)

    local ad = "creatures@rottweiler@move"
	local anim = "pee_right_idle" 
	local player = PlayerPedId()
	

	if ( DoesEntityExist( player ) and not IsEntityDead(player) and IsEntityPlayingAnim(player, "mp_arresting", "idle", 3)) then
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, anim, 3 ) ) then 
			TaskPlayAnim( player, ad, "exit", 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
			
			ClearPedTask(player)
		else
			TaskPlayAnim( player, ad, anim, 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
		end       
	end

end, false)

RegisterCommand("pissleft",function(source, args)

    local ad = "creatures@rottweiler@move"
	local anim = "pee_left_idle" 
	local player = PlayerPedId()
	

	if ( DoesEntityExist( player ) and not IsEntityDead(player) and IsEntityPlayingAnim(player, "mp_arresting", "idle", 3)) then
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, anim, 3 ) ) then 
			TaskPlayAnim( player, ad, "exit", 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
			
			ClearPedTask(player)
		else
			TaskPlayAnim( player, ad, anim, 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
		end       
	end

end, false)

RegisterCommand("carsit",function(source, args)

    local ad = "creatures@rottweiler@incar@"
	local anim = "sit" 
	local player = PlayerPedId()
	

	if ( DoesEntityExist( player ) and not IsEntityDead(player) and IsEntityPlayingAnim(player, "mp_arresting", "idle", 3)) then
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, anim, 3 ) ) then 
			TaskPlayAnim( player, ad, "exit", 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
			
			ClearPedTask(player)
		else
			TaskPlayAnim( player, ad, anim, 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
		end       
	end

end, false)

RegisterCommand("playdead",function(source, args)

    local ad = "creatures@rottweiler@move"
	local anim = "dead_right" 
	local player = PlayerPedId()
	

	if ( DoesEntityExist( player ) and not IsEntityDead(player) and IsEntityPlayingAnim(player, "mp_arresting", "idle", 3)) then
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, anim, 3 ) ) then 
			TaskPlayAnim( player, ad, "exit", 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
			
			ClearPedTask(player)
		else
			TaskPlayAnim( player, ad, anim, 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
		end       
	end

end, false)



--[[ --amb@code_human_wander_eating_donut_fat@male@idle_a
RegisterCommand("test",function(source, args)
    local ad = "amb@code_human_wander_eating_donut_fat@male@idle_a"
	local anim = "idle_a" 
	local player = PlayerPedId()
	
	if ( DoesEntityExist( player ) and not IsEntityDead(player) and IsEntityPlayingAnim(player, "mp_arresting", "idle", 3)) then
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, anim, 3 ) ) then 
			TaskPlayAnim( player, ad, "exit", 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
			
			ClearPedTask(player)
		else
			TaskPlayAnim( player, ad, anim, 3.0, 1.0, -1, 01, 0, 0, 0, 0 )
		end       
	end
end, false) ]]

-- Citizen.CreateThread(function()
-- 	local player = PlayerPedId()


--     while true do

--         if emotePlaying then
--             if (IsControlJustPressed(1, 22) or IsControlJustPressed(1, 177)) then
-- 				ClearPedTasksImmediately(ped)
-- 				print('cleared')
--             end
--         end

--         Citizen.Wait(0)
--     end
-- end)

-- Citizen.CreateThread(function()
-- 	local ped = GetPlayerPed(-1)
-- 	while true do
-- 		Wait(0)
-- 		if (IsControlJustPressed(1, 22) or IsControlJustPressed(1, 177)) then 
-- 			ClearPedTasks(ped)
-- 		end
-- 	end
-- end)

-- This messes with the player alot and isnt needed.
--Citizen.CreateThread(function()
--	while true do
--	 Citizen.Wait(0)
--	  if IsControlJustReleased(1, 32) then
--	  ClearPedTasksImmediately(GetPlayerPed(-1))            
--	 end
--	end
--   end)




--pee_left_enter
--pee_left_exit
--pee_left_idle
--pee_right_enter
--pee_right_exit
--pee_right_idle
--dump_enter
--dump_enter_facial
--dump_exit
--dump_exit_facial
--dump_loop
--dump_loop_facial



-- local dragging_data = {
-- 	InProgress = false,
-- 	target = -1,
-- 	Anim = {
-- 		dict = "combat@drag_ped@",
-- 		start = "injured_pickup_back_",
-- 		loop = "injured_drag_",
-- 		ending = "injured_putdown_"
-- 	}
-- }



-- Config = {}
-- Config.ReloadDeath = false


-- AddEventHandler('eventname', function(data)
-- 	print(data.label, data.num, data.entity)

-- 	PlayAnim("loop", "plyr")
-- 	WaitControlsInteractions()

-- 	local target_ped = PlayerPedId()
	
-- 	local player 	 = data.entity

-- 	dragging_data.InProgress = true

-- 	SetEntityCoords(player, GetOffsetFromEntityInWorldCoords(target_ped, 0.0, 1.2, -1.0)) --// Set the player in front of the other
-- 	SetEntityHeading(player, GetEntityHeading(target_ped)) --// Set same heading
-- 	-- PlayAnim("start", "ped")
-- 	ClearPedTasks(player) --// Added this to prevent multiple ending animation

-- 	--                                       Bone		   X    Y    Z    rX   rY   rZ
-- 	AttachEntityToEntity(player, target_ped, 1816, 4103, 0.48, 0.0, 0.0, 0.0, 0.0, 0.0)
-- 	-- PlayAnim("loop", "ped")
	
-- 	TaskPlayAnim(player, "combat@drag_ped@", "injured_drag_ped", 8.0, -8.0, -1, 33, 0, 0, 0, 0)


-- 	Citizen.CreateThread(function()
-- 		while true do
-- 			if IsControlJustPressed(1, 323) then -- X
-- 				DetachEntity(player, true, false)
-- 				ClearPedTasks(target_ped) 
-- 				ClearPedTasks(player) 
-- 				SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
				
-- 				-- DetachEntity(player, true, false)
-- 				-- SetEntityCoords(player, GetOffsetFromEntityInWorldCoords(target_ped, 0.0, 0.4, -1.0))
-- 				return
-- 			end
-- 			Wait(5)
-- 		end
-- 	end)
-- end)

-- exports.qtarget:Ped({
-- 	options = {
-- 		{
-- 			event = "eventname",
-- 			icon = "fas fa-box-circle-check",
-- 			label = "Déplacer le corp",
-- 		}
-- 	},
-- 	distance = 2
-- })




-- StartParticleFxLoopedAtCoord("scr_fbi_falling_debris", -185.2, -1590.1, 34.5, 0.0, 0.0, 0.0, 10.0, 0, 0, 0, 0)
-- START_PARTICLE_FX_LOOPED_AT_COORD("scr_fbi_falling_debris", 93.7743, -749.4572, 70.86904, 0, 0, 0, 0x3F800000, 0, 0, 0, 0) 
--proj_heist_flare_smoke
--wpn_flare
--scr_crate_drop_flare
Citizen.CreateThread(function()
	Wait(500)
	-- dict = "wpn_flare"
	-- particuleName = "proj_heist_flare_smoke"
	-- time = 10000
	-- RequestNamedPtfxAsset(dict)
	-- -- Wait for the particle dictionary to load.
	-- while not HasNamedPtfxAssetLoaded(dict) do
	-- 	Citizen.Wait(0)
	-- end
	-- -- Tell the game that we want to use a specific dictionary for the next particle native.
	-- UseParticleFxAssetNextCall(dict)
	-- -- Create a new non-looped particle effect, we don't need to store the particle handle because it will
	-- -- automatically get destroyed once the particle has finished it's animation (it's non-looped).
	-- local particleHandle = StartParticleFxNonLoopedAtCoord(particleName, -185.2, -1590.1, 34.5, 0.0, 0.0, 0.0, 1.0, false, false, false)
	-- -- SetParticleFxLoopedColour(particleHandle, 0, 255, 0 ,0)
	-- -- Citizen.Wait(time)
	-- -- StopParticleFxLooped(particleHandle, false)

	-- RequestNamedPtfxAsset("scr_exile3");
	-- UseParticleFxAssetNextCall("scr_exile3");
	-- StartParticleFxNonLoopedOnEntity("scr_ex3_water_dinghy_wash", GetPlayerPed(-1), 0.0, 0.0, -0.5, 0.0, 0.0, 0.0, 1.0, false, false, false);




	x=-185.2
	y=-1590.1
	z=34.5
	h=100.1

	-- local blipCoords = {x=x+math.random(-180,180), y=y+math.random(-180,180), z=z}

    -- crateBlipZone = AddBlipForRadius(blipCoords.x, blipCoords.y, blipCoords.z, 250.0)
    -- SetBlipRotation(crateBlipZone, 0)
    -- SetBlipColour(crateBlipZone, 1)
    -- SetBlipAlpha(crateBlipZone, 150)
    
    -- crateBlip = AddBlipForCoord(blipCoords.x, blipCoords.y, blipCoords.z, 250.0)
    -- EndTextCommandSetBlipName(crateBlip)
    -- SetBlipSprite(crateBlip, 550)
    -- SetBlipColour(crateBlip, 1)

	-- RequestModel("prop_box_wood07a")
	-- while not HasModelLoaded("prop_box_wood07a") do
	-- 	Wait(1)
	-- end



end)


RegisterCommand("dev",function(source, args)
	

end, false)




-- DRAG BODY***********************




-- local ESX = nil

-- if Config.ReloadDeath then
-- 	Citizen.CreateThread(function()
-- 		while ESX == nil do
-- 			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
-- 			Citizen.Wait(0)
-- 		end
-- 	end)
-- end

-- -- dragging start anim: combat@drag_ped@ / injured_pickup_back_plyr
-- -- dragging during anim: combat@drag_ped@ / injured_drag_plyr
-- -- dragging ending anim: combat@drag_ped@ / injured_putdown_plyr

-- -- dragged start anim: combat@drag_ped@ / injured_pickup_back_ped
-- -- dragged during anim: combat@drag_ped@ / injured_drag_ped
-- -- dragged ending anim: combat@drag_ped@ / injured_putdown_ped

-- --// Function 
-- local function HelpNotification(text)
--     SetTextComponentFormat("STRING")
--     AddTextComponentString(text)
--     DisplayHelpTextFromStringLabel(0, 0, 1, -1)
-- end

-- local function Notification(text)
-- 	AddTextEntry('notify', text)
--     SetNotificationTextEntry('notify')
--     DrawNotification(false, true)
-- end

-- local function GetClosestPlayer(radius)
--     local players = GetActivePlayers()
--     local closestDistance = -1
--     local closestPlayer = -1
--     local playerPed = PlayerPedId()
--     local playerCoords = GetEntityCoords(playerPed)

--     for _,playerId in ipairs(players) do
--         local targetPed = GetPlayerPed(playerId)
--         if targetPed ~= playerPed then
--             local targetCoords = GetEntityCoords(targetPed)
--             local distance = #(targetCoords-playerCoords)
--             if closestDistance == -1 or closestDistance > distance then
--                 closestPlayer = playerId
--                 closestDistance = distance
--             end
--         end
--     end
-- 	if closestDistance ~= -1 and closestDistance <= radius then
-- 		return closestPlayer
-- 	else
-- 		return nil
-- 	end
-- end

-- local function LoadAnimDict(animDict)
--     if not HasAnimDictLoaded(animDict) then
--         RequestAnimDict(animDict)
--         while not HasAnimDictLoaded(animDict) do
--             Wait(0)
--         end        
--     end
--     return animDict
-- end

-- --// Override TaskPlayAnim to unload the animation after whe have use it
-- local old_TaskPlayAnim = TaskPlayAnim
-- function TaskPlayAnim(ped, animDictionary, animationName, blendInSpeed, blendOutSpeed, duration , flag, playbackRate, lockX, lockY, lockZ)
-- 	old_TaskPlayAnim(ped, animDictionary, animationName, blendInSpeed, blendOutSpeed, duration , flag, playbackRate, lockX, lockY, lockZ)
-- 	RemoveAnimDict(animDictionary)
-- 	return
-- end

-- function PlayAnim(type, desinence)
-- 	--// Desinence //--

-- 	-- plyr = player that dragging 
-- 	-- ped  = player that been dragged

-- 	local duration = nil
-- 	if type == "loop" then duration = -1 elseif type == "start" then duration = 6000 elseif type == "ending" then duration = 5000 end

-- 	LoadAnimDict(dragging_data.Anim.dict)
-- 	TaskPlayAnim(PlayerPedId(), dragging_data.Anim.dict, dragging_data.Anim[type]..desinence, 8.0, -8.0, duration, 33, 0, 0, 0, 0)

-- 	if duration ~= -1 then
-- 		Wait(duration)
-- 		ClearPedTasks(PlayerPedId())
-- 	end
-- end

-- function WaitControlsInteractions()
-- 	Citizen.CreateThread(function()
-- 		while true do
-- 			HelpNotification("~INPUT_VEH_DUCK~ to drop the body")
-- 			if IsControlJustPressed(1, 323) then -- X
-- 				DragClosest()
-- 				return
-- 			end
-- 			Wait(5)
-- 		end
-- 	end)
-- end	

-- RegisterCommand("drag", function()
-- 	DragClosest()
-- end)

-- function DragClosest()
-- 	local player = PlayerPedId()

	
-- 	if not dragging_data.InProgress then --// Dont have any drag animation started
-- 		local closestPlayer = GetClosestPlayer(1)
-- 		local Ped_ClosestPlayer = GetPlayerPed(GetPlayerFromServerId(closestPlayer))

-- 		if Config.ReloadDeath then
-- 			ESX.TriggerServerCallback("reload_death:isPlayerDead", function(dead) 
-- 				if dead then
-- 					local target = GetPlayerServerId(closestPlayer)
-- 					if target ~= -1 then
-- 						dragging_data.InProgress = true
-- 						dragging_data.target = target

-- 						--// Play anim [start]
-- 						TriggerServerEvent("xenos_DragPeople:sync",target) --// Request to the other client (the closest player) to sync the animation with that client
-- 						PlayAnim("start", "plyr")
-- 						PlayAnim("loop", "plyr")
-- 						WaitControlsInteractions()
-- 					else
-- 						Notification("~r~No one nearby to drag!")
-- 					end
-- 				else
-- 					Notification("~r~No one nearby to drag!")
-- 				end
-- 			end, GetPlayerServerId(closestPlayer))
-- 		else
-- 			if closestPlayer and IsPedDeadOrDying(closestPlayer) then
-- 				local target = GetPlayerServerId(closestPlayer)
-- 				if target ~= -1 then
-- 					dragging_data.InProgress = true
-- 					dragging_data.target = target

-- 					--// Play anim [start]
-- 					TriggerServerEvent("xenos_DragPeople:sync",target) --// Request to the other client (the closest player) to sync the animation with that client
-- 					PlayAnim("start", "plyr")
-- 					PlayAnim("loop", "plyr")
-- 					WaitControlsInteractions()
-- 				else
-- 					Notification("~r~No one nearby to drag!")
-- 				end
-- 			else
-- 				Notification("~r~No one nearby to drag!")
-- 			end
-- 		end
-- 	else --// Have a drag animation started
-- 		local target_ped = GetPlayerPed(GetPlayerFromServerId(dragging_data.target))

-- 		TriggerServerEvent("xenos_DragPeople:stop",dragging_data.target) --// Request to the other client (the closest player) to stop the animation with that client
		
-- 		DetachEntity(PlayerPedId(), true, false)
-- 		PlayAnim("ending", "plyr")
-- 		ClearPedTasks(target_ped) --// Added this to prevent multiple ending animation

-- 		-- Reset all data
-- 		dragging_data.InProgress = false
-- 		dragging_data.target = 0
-- 	end
-- end

-- --// This is the trigger that get the call from the other client to sync the animation
-- RegisterNetEvent("xenos_DragPeople:syncTarget")
-- AddEventHandler("xenos_DragPeople:syncTarget", function(target)
-- 	local target_ped = GetPlayerPed(GetPlayerFromServerId(target))
-- 	local player 	 = PlayerPedId()

-- 	dragging_data.InProgress = true

-- 	SetEntityCoords(player, GetOffsetFromEntityInWorldCoords(target_ped, 0.0, 1.2, -1.0)) --// Set the player in front of the other
-- 	SetEntityHeading(player, GetEntityHeading(target_ped)) --// Set same heading
-- 	PlayAnim("start", "ped")
-- 	ClearPedTasks(player) --// Added this to prevent multiple ending animation

-- 	--                                       Bone		   X    Y    Z    rX   rY   rZ
-- 	AttachEntityToEntity(player, target_ped, 1816, 4103, 0.48, 0.0, 0.0, 0.0, 0.0, 0.0)
-- 	PlayAnim("loop", "ped")
-- end)

-- --// Trigger that get call from the other client to stop the animation
-- RegisterNetEvent("xenos_DragPeople:cl_stop")
-- AddEventHandler("xenos_DragPeople:cl_stop", function(_target)
-- 	_target = GetPlayerPed(GetPlayerFromServerId(_target))
-- 	dragging_data.InProgress = false

-- 	DetachEntity(PlayerPedId(), true, false)
-- 	SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(_target, 0.0, 0.4, -1.0))
-- 	PlayAnim("ending", "ped")
-- end)

-- FIN DRAG BODY






-- local function textFain(text, secconds)
-- 	ClearPrints()
-- 	SetTextEntry_2("STRING")
-- 	AddTextComponentString(text)
-- 	DrawSubtitleTimed(secconds * 1000, 1)
-- end
-- local function drawText3D(x, y, z, text)
--     local onScreen,_x,_y=World3dToScreen2d(x,y,z)
--     local px,py,pz=table.unpack(GetGameplayCamCoords())
--     local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

--     local scale = (1/dist)*2
--     local fov = (1/GetGameplayCamFov())*130
--     local scale = scale*fov

--     if onScreen then
--         SetTextScale(0.2*scale, 0.5*scale)
--         SetTextFont(6)
--         SetTextProportional(1)
-- 		SetTextColour( 1,1, 1, 255 )
--         SetTextDropshadow(0, 0, 0, 0, 255)
--         SetTextEdge(2, 0, 0, 0, 150)
--         SetTextDropShadow()
--         SetTextOutline()
--         SetTextEntry("STRING")
--         SetTextCentre(1)
--         AddTextComponentString(text)
-- 	    World3dToScreen2d(x,y,z, 0) --Added Here
--         DrawText(_x,_y)
--     end
-- end
-- local function drawInfo(str)
-- 	SetTextComponentFormat("STRING")
-- 	AddTextComponentString(str)
-- 	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
-- end


-- local plansWeed


-- RegisterNetEvent("event:getPlanWeedCallBack")
-- AddEventHandler("event:getPlanWeedCallBack", function(v)
-- 	plansWeed = v
-- end)


-- RegisterNetEvent("event:updatePlanWeedCallback")
-- AddEventHandler("event:updatePlanWeedCallback", function(k, v)
-- 	plansWeed[k] = v
-- end)



-- animation = false
-- breakAnimation = false
-- function startAnimationListener()
--     Citizen.CreateThread(function()
--         while animation do
--             local ped = GetPlayerPed(-1)
--             if IsPedRagdoll(ped) or not DoesEntityExist(ped) or IsEntityDead(ped) or IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) then 
--                 animation = false
--                 breakAnimation = true
--                 ClearPedTasksImmediately(ped)
--                 TriggerEvent("stopProgressBar")
--             end
--             Citizen.Wait(0)
--         end
--     end)
-- end


-- local waterPoints = {
-- 	{x=1867.2,y=4766.9,z=38.9},
-- }
-- Citizen.CreateThread(function()
-- 	Citizen.Wait(1000)
-- 	TriggerServerEvent("event:getPlanWeed")
-- 	Citizen.Wait(1000)
-- 	local ped = GetPlayerPed(-1)
-- 	for k,v in pairs(waterPoints) do
-- 		local blip = AddBlipForCoord(v.x, v.y, v.z)
-- 		SetBlipAsShortRange(blip, true)
-- 		SetBlipSprite(blip, 399)
-- 		SetBlipDisplay(blip, 8) 
-- 		SetBlipScale(blip, 0.6)
-- 		SetBlipFade(blip, 120, 0)
-- 		SetBlipColour(blip, 3)
-- 	end
-- 	while true do
-- 		local interval = 10000
-- 		local pos = GetEntityCoords(ped, true)
-- 		if waterPoints then 
-- 			for k,v in pairs(waterPoints) do
-- 				local dist = Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z)
-- 				if dist < 200 then 
-- 					interval = 500
-- 					if interval > 500 then 
-- 						interval = 500
-- 					end
-- 					if dist < 60 then 
-- 						interval = 5
--                         DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.5, 3.5, 1.2, 0, 140, 255, 180, 0, 0, 2, 0, nil, nil, 0)
-- 						if dist < 3 then 
-- 							drawInfo("Appuyez sur ~INPUT_CONTEXT~ pour récupérer un seau d'eau.")
-- 							if IsControlJustPressed(1, 51)  then
-- 								TaskStartScenarioInPlace(ped, "PROP_HUMAN_PARKING_METER", 0, false);
-- 								TriggerEvent("progressBar", 2)
-- 								Wait(2000)
-- 								ClearPedTasksImmediately(ped)
-- 								TriggerServerEvent("updateInventory", 36, 1)
-- 							end
-- 						end
-- 					end
-- 				end
-- 			end
-- 		end
-- 		Citizen.Wait(interval)
-- 	end
-- end)


-- Citizen.CreateThread(function()
-- 	Citizen.Wait(1000)
-- 	TriggerServerEvent("event:getPlanWeed")
-- 	Citizen.Wait(1000)
-- 	local ped = GetPlayerPed(-1)
-- 	while true do
-- 		local interval = 10000
-- 		local pos = GetEntityCoords(ped, true)
-- 		if plansWeed then 
-- 			for k,v in pairs(plansWeed) do
-- 				local dist = Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z)
-- 				if dist < 100.0 then
-- 					if interval > 500 then
-- 						interval = 500
-- 					end
-- 					if dist < 20.0 then
-- 						interval = 0

-- 						local text = ""
-- 						if v.health == 0 then 
-- 							text = "~b~VIDE"
-- 						elseif v.health == 1 then 
-- 							text = "~g~SAINE"
-- 						elseif v.health == 2 then 
-- 							text = "~y~BESOIN D'EAU"
-- 						elseif v.health == 3 then 
-- 							text = "~y~BESOIN D'ENGRAIS"
-- 						end
-- 						if v.state == 0 then
-- 							drawText3D(v.x, v.y, v.z + 0.8, "~w~Plan de Cannabis "..text)
-- 						elseif v.state == 1 then
-- 							drawText3D(v.x, v.y, v.z + 0.8, "~w~Petite pousse : "..text)
-- 						elseif v.state == 2 then
-- 							drawText3D(v.x, v.y, v.z + 0.8, "~w~Jeune pousse : "..text)
-- 						elseif v.state == 3 then
-- 							drawText3D(v.x, v.y, v.z + 0.8, "~w~Grande pousse : "..text)
-- 						elseif v.state == 4 then
-- 							drawText3D(v.x, v.y, v.z + 0.8, "~w~Plan de Cannabis : ~g~PRÊT À RÉCOLTER")
-- 						end


-- 						if dist < 1.0 then 
-- 							if not animation and not breakAnimation then
-- 								if v.state == 0 then
-- 									drawInfo("Appuyez sur ~INPUT_CONTEXT~ pour planter les graines.")
-- 								elseif v.state == 1 or v.state == 2 or v.state == 3 then 
-- 									if v.health == 2 then
-- 										drawInfo("Appuyez sur ~INPUT_CONTEXT~ pour arroser la pousse.")
-- 									elseif v.health == 3 then
-- 										drawInfo("Appuyez sur ~INPUT_CONTEXT~ pour ajouter de l'engrais.")
-- 									end
-- 								elseif v.state == 4 then
-- 									drawInfo("Appuyez sur ~INPUT_CONTEXT~ pour récolter.")
-- 								end

-- 								if IsControlJustPressed(1, 51)  then
-- 									Citizen.CreateThread(function()
-- 										local dx = v.x - pos.x
-- 										local dy = v.y - pos.y
-- 										local heading = GetHeadingFromVector_2d(dx, dy)
-- 										SetEntityHeading(ped, heading)
-- 										animation = true
-- 										if v.state == 0 or v.state == 1 then 
-- 											TaskStartScenarioInPlace(ped, "WORLD_HUMAN_GARDENER_PLANT", 0, false);
-- 										elseif v.state == 2 or v.state == 3 or v.state == 4 then 
-- 											TaskStartScenarioInPlace(ped, "PROP_HUMAN_PARKING_METER", 0, false);
-- 										end
-- 										TriggerEvent("progressBar", 5)
-- 										startAnimationListener()
-- 										Wait(5000)
-- 										if animation and not breakAnimation then 
-- 											ClearPedTasksImmediately(ped)
-- 											if v.state == 0 then 
-- 												TriggerServerEvent("updateInventoryWithCallback", "event:inventoryCallbackCulture", {data = v, k = k}, 34, -1)
-- 											elseif v.state == 1 or v.state == 2 or v.state == 3 then 
-- 												if v.health == 2 then 
-- 													TriggerServerEvent("updateInventoryWithCallback", "event:inventoryCallbackCulture", {data = v, k = k}, 36, -1)
-- 												elseif v.health == 3 then 
-- 													TriggerServerEvent("updateInventoryWithCallback", "event:inventoryCallbackCulture", {data = v, k = k}, 35, -1)
-- 												end
-- 											elseif v.state == 4 then
-- 												TriggerServerEvent("updateInventoryWithCallback", "event:inventoryCallbackCulture", {data = v, k = k}, 20, 20)
-- 											end
-- 											Wait(2000)
-- 											animation = false
-- 											breakAnimation = false
-- 										end
-- 										breakAnimation = false
-- 									end)
-- 								end
-- 							else
-- 								drawInfo("Patientez quelques instants...")
-- 							end
-- 						end
-- 						if v.state <= 1 then
-- 							DrawMarker(20, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.6001,0.6001,0.6001, 5, 144, 51, 100, 0, 0, 0, 1, 0, 0, 0)
-- 						end
-- 					end
-- 				end
-- 			end
-- 		end
-- 		Citizen.Wait(interval)
-- 	end
-- end)

-- RegisterNetEvent("event:inventoryCallbackCulture")
-- AddEventHandler("event:inventoryCallbackCulture", function(p)
-- 	local v = p.data
-- 	local k = p.k
-- 	if v.state == 0 then 
-- 		TriggerEvent("notifynui", "info", "Culture", "Vous avez planté un pied.")
-- 	elseif v.state == 1 or v.state == 2 or v.state == 3 then
-- 		if v.health == 2 then 
-- 			TriggerEvent("notifynui", "info", "Culture", "Vous avez arrosé le pied.")
-- 		elseif v.health == 3 then 
-- 			TriggerEvent("notifynui", "info", "Culture", "Vous avez ajouté de l'engrais.")
-- 		end 
-- 	elseif v.state == 4 then 
-- 		TriggerEvent("notifynui", "info", "Culture", "Vous avez récolté le pied.")
-- 	end
-- 	TriggerServerEvent("event:updatePlanWeed", k)
-- end)


-- RegisterCommand("addPiedChamp", function(source, args, rawcommand)
--     local coords = {}
--     local pos = GetEntityCoords(PlayerPedId())
--     coords.x = pos.x
--     coords.y = pos.y
--     coords.z = pos.z
--     TriggerServerEvent("addPiedChamp", args[1], coords)
-- end)






-----------------------------------------------------------
-- PushOver- A Simple FiveM Script, Made By Jordan.#2139 --
-----------------------------------------------------------
----------------------------------------------------------------------------------------------
                  -- !WARNING! !WARNING! !WARNING! !WARNING! !WARNING! --
        -- DO NOT TOUCH THIS FILE OR YOU /WILL/ FUCK SHIT UP! EDIT THE CONFIG.LUA --
-- DO NOT BE STUPID AND WHINE TO ME ABOUT THIS BEING BROKEN IF YOU TOUCHED THE LINES BELOW. --
----------------------------------------------------------------------------------------------
-- Config = {
-- 	Keys = {
-- 	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
-- 	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
-- 	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
-- 	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
-- 	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
-- 	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
-- 	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
-- 	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
-- 	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118,
-- 	}
-- 	}
-- local First = vector3(0.0, 0.0, 0.0)
-- local Second = vector3(5.0, 5.0, 5.0)
-- local Vehicle = {Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil}
-- Citizen.CreateThread(function()
--     Citizen.Wait(200)
--     while true do
--         local ped = PlayerPedId()
--         local posped = GetEntityCoords(GetPlayerPed(-1))
--         local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 20.0, 0.0)
--         local rayHandle = CastRayPointToPoint(posped.x, posped.y, posped.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, ped, 0)
--         local a, b, c, d, closestVehicle = GetRaycastResult(rayHandle)
--         local Distance = GetDistanceBetweenCoords(c.x, c.y, c.z, posped.x, posped.y, posped.z, false);
--         local vehicleCoords = GetEntityCoords(closestVehicle)
--         local dimension = GetModelDimensions(GetEntityModel(closestVehicle), First, Second)
--         if Distance < 6.0  and not IsPedInAnyVehicle(ped, false) then
--             Vehicle.Coords = vehicleCoords
--             Vehicle.Dimensions = dimension
--             Vehicle.Vehicle = closestVehicle
--             Vehicle.Distance = Distance
--             if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(ped), true) then
--                 Vehicle.IsInFront = false
--             else
--                 Vehicle.IsInFront = true
--             end
--         else
--             Vehicle = {Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil}
--         end
--         Citizen.Wait(500)
--     end
-- end)

-- Citizen.CreateThread(function()
--     local lerpCurrentAngle = 0.0
--     while true do 
--         Citizen.Wait(5)
--         local ped = PlayerPedId()
--         if Vehicle.Vehicle ~= nil then
--                 DisplayHelpText(('Press [~g~SHIFT~w~] and [~g~E~w~] to push the vehicle'))
--                 if IsControlPressed(0, Config.Keys["LEFTSHIFT"]) and IsVehicleSeatFree(Vehicle.Vehicle, -1) and not IsEntityAttachedToEntity(ped, Vehicle.Vehicle) and IsControlJustPressed(0, Config.Keys["E"]) then
--                     NetworkRequestControlOfEntity(Vehicle.Vehicle)
--                     local coords = GetEntityCoords(ped)
--                     if Vehicle.IsInFront then    
--                         AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y * -1 + 0.1 , Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)
--                     else
--                         AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z  + 1.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true)
--                     end
    
--                     RequestAnimDict('missfinale_c2ig_11')
--                     TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
--                     Citizen.Wait(200)
--                      while true do
--                         Citizen.Wait(5)
    
--                         local speed = GetFrameTime() * 50
--                         if IsDisabledControlPressed(0, Config.Keys["A"]) then
--                             SetVehicleSteeringAngle(Vehicle.Vehicle, lerpCurrentAngle)
--                             lerpCurrentAngle = lerpCurrentAngle + speed
--                         elseif IsDisabledControlPressed(0, Config.Keys["D"]) then
--                             SetVehicleSteeringAngle(Vehicle.Vehicle, lerpCurrentAngle)
--                             lerpCurrentAngle = lerpCurrentAngle - speed
--                         else
--                             SetVehicleSteeringAngle(Vehicle.Vehicle, lerpCurrentAngle)
     
--                             --Don't immediatly snap tires to base position
--                             if lerpCurrentAngle < -0.02 then    
--                                 lerpCurrentAngle = lerpCurrentAngle + speed
--                             elseif lerpCurrentAngle > 0.02 then
--                                 lerpCurrentAngle = lerpCurrentAngle - speed
--                             else
--                                 lerpCurrentAngle = 0.0
--                             end
--                         end
    
--                         -- Force the vehicle angles to stay at 15 to -15 degrees
--                         if lerpCurrentAngle > 15.0 then
--                             lerpCurrentAngle = 15.0
--                         elseif lerpCurrentAngle < -15.0 then
--                             lerpCurrentAngle = -15.0
--                         end
    
--                         if Vehicle.IsInFront then
--                             SetVehicleForwardSpeed(Vehicle.Vehicle, -1.0)
--                         else
--                             SetVehicleForwardSpeed(Vehicle.Vehicle, 1.0)
--                         end
    
--                         if HasEntityCollidedWithAnything(Vehicle.Vehicle) then
--                             SetVehicleOnGroundProperly(Vehicle.Vehicle)
--                         end
--                               if not IsDisabledControlPressed(0, Config.Keys["E"]) then
--                             DetachEntity(ped, false, false)
--                             StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
--                             FreezeEntityPosition(ped, false)
--                             break
--                         end
--                     end
--                 end
--             end
--         end  
-- end)

-- function DisplayHelpText(str)
-- 	SetTextComponentFormat("STRING")
-- 	AddTextComponentString(str)
-- 	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
-- end

Citizen.CreateThread(function()
	Wait(1000)

	
	-- RequestAnimDict("amb@world_human_smoking_pot@male@base") 
    -- while not HasAnimDictLoaded("amb@world_human_smoking_pot@male@base") do
    --   Citizen.Wait(0)
    -- end    
	-- TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_smoking_pot@male@base", "base", 2.0, 8.0,-1, 49, 0, 0, 0, 0)
	-- local playerPed = GetPlayerPed(-1)
	-- SetTimecycleModifier("drug_flying_01")
	-- SetPedMotionBlur(playerPed, true)
	
	-- -- RequestAnimSet("move_m@hipster@a") 
	-- -- while not HasAnimSetLoaded("move_m@hipster@a") do
	-- --   Citizen.Wait(0)
	-- -- end    
	-- -- SetPedMovementClipset(playerPed, "move_m@hipster@a", true)

	
	-- Wait(120000)
	-- ClearTimecycleModifier()
	-- ResetScenarioTypesEnabled()
	-- SetPedMotionBlur(playerPed, false)

end)


-- Citizen.CreateThread(function()
--     Wait(2000)
--     -- local menu = CreateMenu("test", {title = "Mon menu", subtitle = "Mon sous-titre", footer = "En bas oé"})
--     -- menu.AddButton(menu, {label = "Actionne moi", select = function() 
--     --     print("testé et approuvé")
--     -- end})
--     -- menu.AddCheckbox(menu, {label = "Oééé checked", checked = true, select = function(checked) 
--     --     print("checked")
--     -- end})
--     -- openMenu(menu)
    

--     local menu = exports.menu:CreateMenu({name = "garage", title = 'Car shop', subtitle = 'Les types de céhicules', footer = 'Appuyer sur Entrée'})
--     menu.ClearItems(menu)
--     menu.AddButton(menu, {label = "Entrer dans l'appartement", badge = "500'000$", select = function()
--         exports.menu:closeMenu()
--     end})
--     menu.AddCheckbox(menu, {label = "Allumer le moteur", checked = true, select = function()
--         exports.menu:closeMenu()
--     end})
--     local submenu = exports.menu:CreateSubmenu(menu, {title = '4x4', subtitle = 'Liste des véhicules disponibles', footer = 'Appuyer sur Entrée pour acheter'})
--     submenu.AddButton(submenu, {label = "Actionne moi", select = function() 
--         print("submenu 1 on y é")
--     end})
--     local submenu2 = exports.menu:CreateSubmenu(submenu, {title = 'Confirmer', subtitle = 'Sûr?', footer = 'Appuyer sur Entrée pour acheter'})
--     submenu2.AddButton(submenu2, {label = "Actionne moi", select = function() 
--         print("submenu 2 victoire")
--     end})
--     submenu.AddSubmenu(submenu, submenu2)
--     menu.AddSubmenu(menu, submenu)

--     exports.menu:openMenu(menu)
-- end)

-- postals = nil
-- Citizen.CreateThread(function()
--     postals = LoadResourceFile(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'postal_file'))
--     postals = json.decode(postals)
--     for i, postal in ipairs(postals) do postals[i] = { vec(postal.x, postal.y), code = postal.code } end
-- end)








RegisterCommand("addpoint", function(source, args, rawcommand)
    local coords = {}
    local pos = GetEntityCoords(PlayerPedId())
    coords.x = pos.x
    coords.y = pos.y
    coords.z = pos.z-0.98
    TriggerServerEvent("addPointLivraisonCrimi", coords)
end)







-- local zipcode