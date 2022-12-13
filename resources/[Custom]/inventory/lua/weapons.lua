

-- *****************************  WEAPONS  ***************************************************************
local weapons = {}

SetWeaponsNoAutoswap(true)

RegisterNUICallback('sendWeapon', function(data, cb)
    while not DoesEntityExist(GetPlayerPed(-1)) and IsEntityDead(GetPlayerPed(-1)) do
        Wait(50)
    end
    Wait(5000)
    -- RemoveAllPedWeapons(GetPlayerPed(-1), false)
    for i,v in pairs(data) do 
        local check = 0
        if weapons ~= {} then
            for j,w in pairs(weapons) do 
                if v.id == w.id then 
                    check = 1
                    if not HasPedGotWeapon(GetPlayerPed(-1),tonumber(v.Item.action),false) then 
                        GiveWeaponToPed(GetPlayerPed(-1), tonumber(v.Item.action), 0, false, false)
                    end
                end
            end
        end
        if check == 0 then 
            table.insert(weapons, v)
            GiveWeaponToPed(GetPlayerPed(-1), tonumber(v.Item.action), 0, false, false)
        end
    end
    if weapons ~= {} then
        for i,v in pairs(weapons) do 
            local check = 0
            for j,w in pairs(data) do 
                if v.id == w.id then 
                    check = 1
                end
            end
            if check == 0 then 
                table.remove(weapons, i)
                RemoveWeaponFromPed(GetPlayerPed(-1), tonumber(v.Item.action), 0, false, false)
            end
        end
    end
    cb("")
end)







-- *********** ARME DANS LE DOS **************************************************

local SETTINGS = {
    back_bone = 24816,
    x = 0.075,
    y = -0.15,
    z = -0.02,
    x_rotation = 0.0,
    y_rotation = 165.0,
    z_rotation = 0.0,
    compatable_weapon_hashes = {
      -- melee:
      --["prop_golf_iron_01"] = 1141786504, -- positioning still needs work
      ["w_me_bat"] = -1786099057,
      ["prop_ld_jerrycan_01"] = 883325847,
      -- assault rifles:
      ["w_ar_carbinerifle"] = -2084633992,
      ["w_ar_carbineriflemk2"] = GetHashKey("WEAPON_CARBINERIFLE_MK2"),
      ["w_ar_assaultrifle"] = -1074790547,
      ["w_ar_specialcarbine"] = -1063057011,
      ["w_ar_bullpuprifle"] = 2132975508,
      ["w_ar_advancedrifle"] = -1357824103,
      -- sub machine guns:
    --   ["w_sb_microsmg"] = 324215364,
      ["w_sb_assaultsmg"] = -270015777,
      ["w_sb_smg"] = 736523883,
      ["w_sb_smgmk2"] = GetHashKey("WEAPON_SMG_MK2"),
      ["w_sb_gusenberg"] = 1627465347,
      -- sniper rifles:
      ["w_sr_sniperrifle"] = 100416529,
      -- shotguns:
      ["w_sg_assaultshotgun"] = -494615257,
      ["w_sg_bullpupshotgun"] = -1654528753,
      ["w_sg_pumpshotgun"] = 487013001,
      ["w_ar_musket"] = -1466123874,
      ["w_sg_heavyshotgun"] = GetHashKey("WEAPON_HEAVYSHOTGUN"),
      -- ["w_sg_sawnoff"] = 2017895192 don't show, maybe too small?
      -- launchers:
      ["w_lr_firework"] = 2138347493,
      ["w_lr_rpg"] = -1312131151
    }
}

local attached_weapons = {}

Citizen.CreateThread(function()
  while true do
      local me = GetPlayerPed(-1)
      ---------------------------------------
      -- attach if player has large weapon --
      ---------------------------------------
      for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
          if HasPedGotWeapon(me, wep_hash, false) then
              if not attached_weapons[wep_name] and GetSelectedPedWeapon(me) ~= wep_hash then
                  AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(wep_name))
              end
          end
      end
      --------------------------------------------
      -- remove from back if equipped / dropped --
      --------------------------------------------
      for name, attached_object in pairs(attached_weapons) do
          -- equipped? delete it from back:
          if GetSelectedPedWeapon(me) ==  attached_object.hash or not HasPedGotWeapon(me, attached_object.hash, false) then -- equipped or not in weapon wheel
            DeleteObject(attached_object.handle)
            attached_weapons[name] = nil
          end
      end
  Wait(0)
  end
end)

function AttachWeapon(attachModel,modelHash,boneNumber,x,y,z,xR,yR,zR, isMelee)
	local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Wait(100)
	end

  attached_weapons[attachModel] = {
    hash = modelHash,
    handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
  }

  if isMelee then x = 0.11 y = -0.14 z = 0.0 xR = -75.0 yR = 185.0 zR = 92.0 end -- reposition for melee items
  if modelHash == -1312131151 then 
    x = -0.1
    y = -0.15
    z = 0.07
    xR = 0.0
    yR = 195.0
    zR = 0.0
  end -- reposition for melee items
  if attachModel == "prop_ld_jerrycan_01" then x = x + 0.3 end
	AttachEntityToEntity(attached_weapons[attachModel].handle, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

function isMeleeWeapon(wep_name)
    if wep_name == "prop_golf_iron_01" then
        return true
    elseif wep_name == "w_me_bat" then
        return true
    elseif wep_name == "prop_ld_jerrycan_01" then
      return true
    else
        return false
    end
end




-- *************** GESTION DES MUNISTIONS *******************************

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        if IsPedReloading(ped) then reloading() end
        if IsPedShooting(ped) then afterShooting() end
        Wait(0)
    end
end)

local reloadingBuffer
local shootingBuffer
local munitions = {}

function reloading()
    if not reloadingBuffer then 
        reloadingBuffer = true 
        Citizen.CreateThread(function()
            Citizen.Wait(5000)
            reloadingBuffer = false 
        end)
    end
end


function afterShooting()
    if not shootingBuffer then 
        shootingBuffer = true 
        Citizen.CreateThread(function()
            Citizen.Wait(5000)
            local ped = GetPlayerPed(-1)
            for i,v in pairs(weapons) do
                local typeAmmo = GetPedAmmoTypeFromWeapon(ped, tonumber(v.Item.action))
                local ammo = GetPedAmmoByType(ped, typeAmmo)
                for j,m in pairs(munitions) do
                    if m.hash == typeAmmo then
                        if m.quantity ~= ammo then
                            munitions[j].quantity = ammo 
                            TriggerServerEvent("updateAmmo", ammo, typeAmmo)
                        end
                    end
                end
            end
            shootingBuffer = false 
        end)
    end
end


RegisterNUICallback('sendAmmo', function(data, cb)
    if not shootingBuffer then
        local ped = GetPlayerPed(-1)
        for i,v in pairs(data) do
            local hash = tonumber(v.Item.action)
            local newAmmo = tonumber(v.quantity)
            local ammo = GetPedAmmoByType(ped, hash)
            if ammo ~= newAmmo then 
                if ammo < newAmmo then 
                    AddAmmoToPedByType(ped, hash, newAmmo - ammo)
                else 
                    SetPedAmmoByType(ped, hash, newAmmo)
                end
            end
            local check = false
            for j,m in pairs(munitions) do 
                if m.hash == hash then 
                    check = true
                    munitions[i].quantity = newAmmo
                end
            end
            if not check then 
                local n = {
                    hash = hash,
                    quantity = newAmmo
                }
                table.insert(munitions, n)
            end
        end
    end
    cb("")
end)
