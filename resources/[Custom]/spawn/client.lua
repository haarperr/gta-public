
local res
local spawn

Citizen.CreateThread(function()
    -- TriggerServerEvent('getIds')
end)

RegisterNetEvent('spawnPlayerEvent')
AddEventHandler('spawnPlayerEvent', function(coords, model, hp, mp_ped)
    local spawn = {}
    spawn.x = coords.x+0.01
    spawn.y = coords.y+0.01
    spawn.z = coords.z+0.01
    spawn.h = coords.h+0.01
    spawn.model = model   
    spawn.mp_ped = mp_ped   
    spawnPlayer(spawn, hp)
end)


local function freezePlayer(id, freeze)
    local player = id
    SetPlayerControl(player, not freeze, false)

    local ped = GetPlayerPed(player)

    if not freeze then
        if not IsEntityVisible(ped) then
            SetEntityVisible(ped, true)
        end

        if not IsPedInAnyVehicle(ped) then
            SetEntityCollision(ped, true)
        end

        FreezeEntityPosition(ped, false)
        --SetCharNeverTargetted(ped, false)
        SetPlayerInvincible(player, false)
    else
        if IsEntityVisible(ped) then
            SetEntityVisible(ped, false)
        end

        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        --SetCharNeverTargetted(ped, true)
        SetPlayerInvincible(player, true)
        --RemovePtfxFromPed(ped)

        if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end
    end
end


function spawnPlayer(spawn, hp)

    Citizen.CreateThread(function()


        if not spawn.skipFade then
            DoScreenFadeOut(500)

            while not IsScreenFadedOut() do
                Citizen.Wait(0)
            end
        end

        -- validate the index
        if not spawn then
            Citizen.Trace("tried to spawn at an invalid spawn index\n")

            spawnLock = false

            return
        end

        -- freeze the local player
        freezePlayer(PlayerId(), true)

        if spawn.model then
            RequestModel(spawn.model)

            -- load the model for this spawn
            while not HasModelLoaded(spawn.model) do
                RequestModel(spawn.model)

                Wait(0)
            end

            -- change the player model
            SetPlayerModel(PlayerId(), spawn.model)
            -- SetPedComponentVariation(GetPlayerPed(-1), 2, 30, 0, 0)

            if spawn.mp_ped then 
                local ped = GetPlayerPed(-1)
                local data = json.decode(spawn.mp_ped)


                -- Wait(100)
                -- -- for i,v in pairs(decode) do 
                -- -- 	print(i)
                -- -- 	print(v)
                -- -- end
                -- RequestModel(data.ModelHash)
            
                -- -- load the model for this spawn
                -- while not HasModelLoaded(data.ModelHash) do
                -- 	RequestModel(data.ModelHash)
            
                -- 	Wait(0)
                -- end
            
                -- -- change the player model
                -- SetPlayerModel(PlayerId(), data.ModelHash)
            
                
                -- local model = data.ModelHash
                -- RequestModel(model)
                -- while not HasModelLoaded(model) do
                -- 	Citizen.Wait(0)
                -- end
                -- SetPlayerModel(PlayerId(), model)
                -- SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 2)
            
                -- Wait(1000)
                
                ClearPedDecorations(ped);
                ClearPedFacialDecorations(ped);
                SetPedDefaultComponentVariation(ped);
                SetPedHairColor(ped, 0, 0);
                SetPedEyeColor(ped, 0);
                ClearAllPedProps(ped);
            
                local dH = data.PedHeadBlendData
            
                SetPedHeadBlendData(ped, dH.FirstFaceShape, dH.SecondFaceShape, dH.ThirdFaceShape, dH.FirstSkinTone, dH.SecondSkinTone, dH.ThirdSkinTone, dH.ParentFaceShapePercent, dH.ParentSkinTonePercent, 0, dH.IsParentInheritance);
            
                while HasPedHeadBlendFinished(ped) do
                    Wait(0)
                end
            
                local appData = data.PedAppearance;
                -- hair
                SetPedComponentVariation(ped, 2, appData.hairStyle, 0, 0);
                SetPedHairColor(ped, appData.hairColor, appData.hairHighlightColor);
                if (not appData.HairOverlay.Key and not appData.HairOverlay.Value) then
                    SetPedFacialDecoration(ped, GetHashKey(appData.HairOverlay.Key), GetHashKey(appData.HairOverlay.Value));
                end
                -- blemishes
                SetPedHeadOverlay(ped, 0, appData.blemishesStyle, appData.blemishesOpacity);
                -- bread
                SetPedHeadOverlay(ped, 1, appData.beardStyle, appData.beardOpacity);
                SetPedHeadOverlayColor(ped, 1, 1, appData.beardColor, appData.beardColor);
                -- eyebrows
                SetPedHeadOverlay(ped, 2, appData.eyebrowsStyle, appData.eyebrowsOpacity);
                SetPedHeadOverlayColor(ped, 2, 1, appData.eyebrowsColor, appData.eyebrowsColor);
                -- ageing
                SetPedHeadOverlay(ped, 3, appData.ageingStyle, appData.ageingOpacity);
                -- makeup
                SetPedHeadOverlay(ped, 4, appData.makeupStyle, appData.makeupOpacity);
                SetPedHeadOverlayColor(ped, 4, 2, appData.makeupColor, appData.makeupColor);
                -- blush
                SetPedHeadOverlay(ped, 5, appData.blushStyle, appData.blushOpacity);
                SetPedHeadOverlayColor(ped, 5, 2, appData.blushColor, appData.blushColor);
                -- complexion
                SetPedHeadOverlay(ped, 6, appData.complexionStyle, appData.complexionOpacity);
                -- sundamage
                SetPedHeadOverlay(ped, 7, appData.sunDamageStyle, appData.sunDamageOpacity);
                -- lipstick
                SetPedHeadOverlay(ped, 8, appData.lipstickStyle, appData.lipstickOpacity);
                SetPedHeadOverlayColor(ped, 8, 2, appData.lipstickColor, appData.lipstickColor);
                -- moles and freckles
                SetPedHeadOverlay(ped, 9, appData.molesFrecklesStyle, appData.molesFrecklesOpacity);
                -- chest hair 
                SetPedHeadOverlay(ped, 10, appData.chestHairStyle, appData.chestHairOpacity);
                SetPedHeadOverlayColor(ped, 10, 1, appData.chestHairColor, appData.chestHairColor);
                -- body blemishes 
                SetPedHeadOverlay(ped, 11, appData.bodyBlemishesStyle, appData.bodyBlemishesOpacity);
                -- eyecolor
                SetPedEyeColor(ped, appData.eyeColor);
            
                for i = 0,19 do
                    SetPedFaceFeature(ped, i, 0.0);
                end
            
                if (data.FaceShapeFeatures.features ~= nil) then
                    for i,t in pairs(data.FaceShapeFeatures.features) do 
                        SetPedFaceFeature(ped, i, t);
                    end
                end
            
            
                if (data.DrawableVariations.clothes ~= nil) then
                    for i,cd in pairs(data.DrawableVariations.clothes) do
                        SetPedComponentVariation(ped, tonumber(i), cd.Key, cd.Value, 0);
                    end
                end
                if (data.PropVariations.props ~= nil) then
                    for i,cd in pairs(data.PropVariations.props) do
                        if (tonumber(i) > -1) then
                            if cd.Value > -1 then 
                                SetPedPropIndex(ped, tonumber(i), cd.Key, cd.Value, true);
                            else
                                SetPedPropIndex(ped, tonumber(i), cd.Key, 0, true);
                            end
                        end
                    end
                end
            
                if data.FacialExpression then 
                    SetFacialIdleAnimOverride(ped, data.FacialExpression, null);
                end

            end

            -- release the player model
            SetModelAsNoLongerNeeded(spawn.model)
            
            -- RDR3 player model bits
            if N_0x283978a15512b2fe then
				N_0x283978a15512b2fe(PlayerPedId(), true)
            end
        end


        -- preload collisions for the spawnpoint
        RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)

        -- spawn the player
        local ped = PlayerPedId()

        -- V requires setting coords as well
        SetEntityCoordsNoOffset(ped, spawn.x, spawn.y, spawn.z, false, false, false, true)

        NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.h, true, true, false)
        SetEntityHealth(GetPlayerPed(-1), hp)

        -- gamelogic-style cleanup stuff
        ClearPedTasksImmediately(ped)
        --SetEntityHealth(ped, 300) -- TODO: allow configuration of this?
        RemoveAllPedWeapons(ped) -- TODO: make configurable (V behavior?)
        ClearPlayerWantedLevel(PlayerId())

        -- why is this even a flag?
        --SetCharWillFlyThroughWindscreen(ped, false)

        -- set primary camera heading
        --SetGameCamHeading(spawn.heading)
        --CamRestoreJumpcut(GetGameCam())

        -- load the scene; streaming expects us to do it
        --ForceLoadingScreen(true)
        --loadScene(spawn.x, spawn.y, spawn.z)
        --ForceLoadingScreen(false)

        local time = GetGameTimer()

        while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do
            Citizen.Wait(0)
        end

        ShutdownLoadingScreen()

        if IsScreenFadedOut() then
            DoScreenFadeIn(500)

            while not IsScreenFadedIn() do
                Citizen.Wait(0)
            end
        end

        -- and unfreeze the player
        freezePlayer(PlayerId(), false)

        -- TriggerEvent('playerSpawned', spawn)

        spawnLock = false

    end)
end
