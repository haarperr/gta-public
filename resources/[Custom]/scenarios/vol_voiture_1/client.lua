
AddEventHandler('onClientResourceStart', function (resourceName)
    TriggerServerEvent("getDoorsStatut")

    startMusic()
    -- spawnPeds()
end)

local boitierStatut = true


RegisterNetEvent('updateDoorStatut')
AddEventHandler('updateDoorStatut', function(door)
    Citizen.Wait(1000)
    local closeDoor = GetClosestObjectOfType(door.x, door.y, door.z, 1.0, door.hash, false, false, false)
	FreezeEntityPosition(closeDoor, door.locked)
end)

RegisterNetEvent('setBoitierPortailStatut')
AddEventHandler('setBoitierPortailStatut', function(statut)
    boitierStatut = statut
end)

RegisterNetEvent('startMusique')
AddEventHandler('startMusique', function()
    -- PANIC https://www.youtube.com/watch?v=7bsuT5qpEpA
    -- I KILL https://www.youtube.com/watch?v=qRR8xR9_RIM
    -- LONDON https://www.youtube.com/watch?v=Bw9n-Yu2UCY
    -- startMusic()
end)

function startMusic()
    -- Citizen.CreateThread(function()
    --     exports.xsound:PlayUrlPos("name", "https://www.youtube.com/watch?v=7bsuT5qpEpA", 0.1, vector3(-1538.1, -119.7, 55.7), false)
    --     exports.xsound:Distance("name", 80)
    --     exports.xsound:setSoundDynamic("name", true)
    --     Wait(((60000*3)+36000))
    --     exports.xsound:setSoundURL("name", "https://www.youtube.com/watch?v=qRR8xR9_RIM")
    --     Wait(((60000*3)+1000))
    --     exports.xsound:setSoundURL("name", "https://www.youtube.com/watch?v=Bw9n-Yu2UCY")
    --     Wait(((60000*6)+35000))
    --     startMusic()
    -- end)
end

Citizen.CreateThread(function()
    local coords = {x = -1593.7, y = -85.4, z = 53.3} 
    while boitierStatut do 
        local interval = 20
        local pos = GetEntityCoords(PlayerPedId())
        local dest = vector3(coords.x, coords.y, coords.z)
        local distance = GetDistanceBetweenCoords(pos, dest, true)

        if distance > 50 then
            interval = 500
        else
            interval = 1
            DrawMarker(1, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 0.4, 0, 75, 255, 175, 0, 0, 2, 0, nil, nil, 0)
            if distance < 2 then 
                AddTextEntry("EVENT01", "Appuyez sur la touche ~INPUT_CONTEXT~")
                DisplayHelpTextThisFrame("EVENT01", false)
                if IsControlJustPressed(1, 51) then
                    startPiratageBoitier()
                end
            end
        end
        Citizen.Wait(interval)
    end
end)

local isInAnimation
local cancelAnimation

function startPiratageBoitier()
    local ped = GetPlayerPed(-1)
    RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
    while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@') do
        Citizen.Wait(0)
    end
    isInAnimation = true
    useItemListener()
    TaskPlayAnim(ped, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@' , 'machinic_loop_mechandplayer' ,8.0, -8.0, -1, 1, 0, false, false, false )
    TriggerEvent("progressBar", 5)
    Wait(5000)
    ClearPedTasksImmediately(ped)
    if not cancelAnimation then
        TriggerServerEvent("unlockDoors")
        TriggerEvent("notifynui", "success", "Piratage", "Le portail a été déverrouillé.")
    end
end

function useItemListener()
    Citizen.CreateThread(function()
        local ped = GetPlayerPed(-1)
        while isInAnimation do
            Wait(0)
            if (not DoesEntityExist(ped) or IsEntityDead(ped) or (false and false) or IsPedRagdoll(ped)) then 
                isInAnimation = false
                cancelAnimation = true
                TriggerEvent("stopProgressBar")
                ClearPedTasksImmediately(ped)
            end
        end
    end)
end

local peds = {
    "a_f_m_beach_01",
    "a_f_y_beach_01",
    "a_f_y_topless_01",
    "ig_kerrymcintosh_02",
    "s_f_y_hooker_01",
    "s_f_y_bartender_01",
    "s_f_y_clubbar_01",
    "s_f_y_shop_mid",
    "ig_bride",
    "a_m_y_beach_03",
    "a_m_y_beach_01",
    "a_m_y_jetski_01",
    "a_m_y_musclbeac_01",
    "ig_djgeneric_01",
}
local posPeds = {
    {x = -1546.8, y = -105.1, z = 53.7, h = 215.8},
    {x = -1537.3, y = -103.8, z = 54.1, h = 169.5},
    {x = -1538.1, y = -116.3, z = 54.1, h = 182.1},
    {x = -1548.1, y = -123.1, z = 54.1, h = 284.1},
    {x = -1548.1, y = -112.1, z = 54.1, h = 226.1},
    {x = -1529.1, y = -113.1, z = 53.7, h = 126.1},
    {x = -1527.9, y = -104.9, z = 53.7, h = 139.9},
    {x = -1538.9, y = -109.9, z = 52.7, h = 181.9},
}

local dances = {
	{h = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", a = "hi_dance_facedj_09_v2_male^6"},
	{h = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", a = "hi_dance_crowd_13_v2_male^6"},
    {h = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", a = 'hi_dance_prop_13_v1_male^6'},
    {h = "anim@mp_player_intcelebrationfemale@raise_the_roof", a = 'raise_the_roof'}
}

Citizen.CreateThread(function()
    Wait(5000)
    for i,v in pairs(dances) do
        RequestAnimDict(v.h)
        while not HasAnimDictLoaded(v.h) do
            Wait(1)
        end
    end
    for i,v in pairs(peds) do 
        RequestModel(v)
        while not HasModelLoaded(v) do
            Wait(1)
        end
    end
    local modelHash = GetHashKey("cs_movpremf_01")
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
    local ped = CreatePed(5, modelHash , -1538.2, -121.5, 54.74, 350.6, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    RequestAnimDict('anim@amb@nightclub@dancers@club_ambientpeds@med-hi_intensity')
    while not HasAnimDictLoaded('anim@amb@nightclub@dancers@club_ambientpeds@med-hi_intensity') do
        Citizen.Wait(1)
    end
    Wait(50)
    TaskPlayAnim(ped, "anim@amb@nightclub@dancers@club_ambientpeds@med-hi_intensity" , 'mi-hi_amb_club_10_v1_male^6' ,8.0, -8.0, -1, 1, 0, false, false, false)
    Wait(50)
    for _,p in pairs(posPeds) do 
        local nb = math.random(4,6)
        while nb ~= 0 do 
            local rnb = math.random(1,#peds)
            local c = {}
            c.x = (p.x + math.random(-3, 3))
            c.y = (p.y + math.random(-3, 3))
            c.h = (p.h + math.random(-3, 3))
            b, c.z = GetGroundZFor_3dCoord(c.x,c.y,p.z,false)
            local ped = CreatePed(5, peds[rnb] , c.x, c.y, c.z, c.h, false, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            local r = math.random(1, #dances)
            TaskPlayAnim(ped, dances[r].h, dances[r].a ,8.0, -8.0, -1, 1, 0, false, false, false )
            Wait(100)
            nb = nb - 1
        end
        Wait(1000)
    end
    for i,v in pairs(peds) do 
        SetModelAsNoLongerNeeded(v)
    end
end)