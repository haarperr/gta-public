


-- TriggerEvent("tornado:delete")
-- TriggerEvent("tornado:summon")





local plansWeed
-- local plansWeed = {
-- 	{x=2502.0053710938,y=4818.5834960938,z=35.098754882813,state=0,health=0},
-- 	{x=2504.7739257813,y=4815.8920898438,z=34.863132476807,state=0,health=0},
-- 	{x=2507.1203613281,y=4813.5288085938,z=34.664619445801,state=0,health=0},
-- 	{x=2511.4819335938,y=4809.3837890625,z=34.458618164063,state=0,health=0},
-- 	{x=2515.2060546875,y=4806.0102539063,z=34.33988571167,state=0,health=0},
-- }


-- Citizen.CreateThread(function()
-- 	MySQL.ready(function ()
--         MySQL.Async.fetchAll("SELECT * FROM champs", {
--         }, function(res)
--             if res[1] then
--                 plansWeed = res
-- 				for k,v in pairs(plansWeed) do
-- 					if DoesEntityExist(plansWeed[k].object) then 
-- 						DeleteEntity(plansWeed[k].object)
-- 					end
-- 					if v.state == 1 then 
-- 						plansWeed[k].object = CreateObjectNoOffset("bkr_prop_weed_bud_01a", plansWeed[k].x, plansWeed[k].y, (plansWeed[k].z-0.99), true, false, false)
-- 						FreezeEntityPosition(plansWeed[k].object, true)
-- 					elseif v.state == 2 then 
-- 						plansWeed[k].object = CreateObjectNoOffset("prop_weed_02", plansWeed[k].x, plansWeed[k].y, (plansWeed[k].z-0.99), true, false, false)
-- 						FreezeEntityPosition(plansWeed[k].object, true)
-- 					elseif v.state == 3 then 
-- 						plansWeed[k].object = CreateObjectNoOffset("prop_weed_01", plansWeed[k].x, plansWeed[k].y, (plansWeed[k].z-0.99), true, false, false)
-- 						FreezeEntityPosition(plansWeed[k].object, true)
-- 					elseif v.state == 4 then 
-- 						plansWeed[k].object = CreateObjectNoOffset("bkr_prop_weed_lrg_01a", plansWeed[k].x, plansWeed[k].y, (plansWeed[k].z-1.55), true, false, false)
-- 						FreezeEntityPosition(plansWeed[k].object, true)
-- 					end
-- 				end
--             end
--         end)
-- 	end)
-- end)




-- Citizen.CreateThread(function()
-- 	while true do 
-- 		Wait(10000)
-- 		if plansWeed then
-- 			for k,v in pairs(plansWeed) do 
-- 				if v.state > 0 then
-- 					if v.water and v.water < os.time() then
-- 						plansWeed[k].water = nil
-- 						plansWeed[k].fertilizer = nil
-- 						plansWeed[k].health = 2
-- 						MySQL.Sync.execute("UPDATE champs SET health = 2, fertilizer = NULL, water = NULL WHERE id = @id", { 
-- 							["id"] = plansWeed[k].id, 
-- 						}, function(alteredRow)
-- 							if not alteredRow then
-- 								TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
-- 							end
-- 						end)
-- 						TriggerClientEvent("event:updatePlanWeedCallback", -1, k, plansWeed[k])
-- 					elseif v.fertilizer and v.fertilizer < os.time() then
-- 						plansWeed[k].water = nil
-- 						plansWeed[k].fertilizer = nil
-- 						plansWeed[k].health = 3
-- 						MySQL.Sync.execute("UPDATE champs SET health = 3, fertilizer = NULL, water = NULL WHERE id = @id", { 
-- 							["id"] = plansWeed[k].id, 
-- 						}, function(alteredRow)
-- 							if not alteredRow then
-- 								TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
-- 							end
-- 						end)
-- 						TriggerClientEvent("event:updatePlanWeedCallback", -1, k, plansWeed[k])
-- 					elseif v.grow and v.grow < os.time() and v.health == 1 and plansWeed[k].water == nil and plansWeed[k].fertilizer == nil then
-- 						plansWeed[k].grow = nil
-- 						plansWeed[k].health = 1
-- 						math.randomseed(GetGameTimer())
-- 						if math.random(1,2) == 1 then 
-- 							plansWeed[k].water = os.time()+10
-- 						else
-- 							plansWeed[k].fertilizer = os.time()+10
-- 						end
-- 						if v.state == 1 then
-- 							plansWeed[k].state = 2
-- 							if DoesEntityExist(plansWeed[k].object) then 
-- 								DeleteEntity(plansWeed[k].object)
-- 							end
-- 							plansWeed[k].object = CreateObjectNoOffset("prop_weed_02", plansWeed[k].x, plansWeed[k].y, (plansWeed[k].z-0.99), true, false, false)
-- 							FreezeEntityPosition(plansWeed[k].object, true)
-- 						elseif v.state == 2 then
-- 							plansWeed[k].state = 3
-- 							if DoesEntityExist(plansWeed[k].object) then 
-- 								DeleteEntity(plansWeed[k].object)
-- 							end
-- 							plansWeed[k].object = CreateObjectNoOffset("prop_weed_01", plansWeed[k].x, plansWeed[k].y, (plansWeed[k].z-0.99), true, false, false)
-- 							FreezeEntityPosition(plansWeed[k].object, true)
-- 						elseif v.state == 3 then
-- 							plansWeed[k].state = 4
-- 							if DoesEntityExist(plansWeed[k].object) then 
-- 								DeleteEntity(plansWeed[k].object)
-- 							end
-- 							plansWeed[k].object = CreateObjectNoOffset("bkr_prop_weed_lrg_01a", plansWeed[k].x, plansWeed[k].y, (plansWeed[k].z-1.55), true, false, false)
-- 							FreezeEntityPosition(plansWeed[k].object, true)
-- 						end
-- 						MySQL.Sync.execute("UPDATE champs SET state = @state, health = 1, grow = NULL, fertilizer = NULL, water = NULL WHERE id = @id", { 
-- 							["id"] = plansWeed[k].id, 
-- 							["state"] = plansWeed[k].state, 
-- 						}, function(alteredRow)
-- 							if not alteredRow then
-- 								TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
-- 							end
-- 						end)
-- 						TriggerClientEvent("event:updatePlanWeedCallback", -1, k, plansWeed[k])
-- 					elseif v.health == 1 and v.water == nil and v.fertilizer == nil and v.grow == nil then 
-- 						plansWeed[k].grow = os.time()+10
-- 						plansWeed[k].health = 1
-- 						MySQL.Sync.execute("UPDATE champs SET grow = @grow WHERE id = @id", { 
-- 							["id"] = plansWeed[k].id, 
-- 							["grow"] = plansWeed[k].grow, 
-- 						}, function(alteredRow)
-- 							if not alteredRow then
-- 								TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
-- 							end
-- 						end)
-- 						TriggerClientEvent("event:updatePlanWeedCallback", -1, k, plansWeed[k])
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- end)

-- RegisterNetEvent("event:getPlanWeed")
-- AddEventHandler("event:getPlanWeed", function()
--     local _src = source
-- 	TriggerClientEvent("event:getPlanWeedCallBack", _src, plansWeed)
-- end)

-- RegisterNetEvent("event:updatePlanWeed")
-- AddEventHandler("event:updatePlanWeed", function(k)
--     local _src = source
-- 	local state = plansWeed[k].state 
-- 	local h = plansWeed[k].health 
-- 	if state == 0 then
-- 		plansWeed[k].state = 1
-- 		plansWeed[k].health = 1
-- 		math.randomseed(GetGameTimer())
-- 		if math.random(1,2) == 1 then 
-- 			plansWeed[k].fertilizer = nil
-- 			plansWeed[k].water = os.time()+10
-- 		else
-- 			plansWeed[k].fertilizer = os.time()+10
-- 			plansWeed[k].water = nil
-- 		end
-- 		MySQL.Async.execute("UPDATE champs SET state = 1, health = 1, water = @water, fertilizer = @fertilizer WHERE id = @id", { 
-- 			["id"] = plansWeed[k].id, 
-- 			["water"] = plansWeed[k].water, 
-- 			["fertilizer"] = plansWeed[k].fertilizer, 
-- 		}, function(alteredRow)
-- 			if alteredRow then
-- 				plansWeed[k].object = CreateObjectNoOffset("bkr_prop_weed_bud_01a", plansWeed[k].x, plansWeed[k].y, (plansWeed[k].z-0.99), true, false, false)
-- 				TriggerClientEvent("event:updatePlanWeedCallback", -1, k, plansWeed[k])
-- 			else
-- 				TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
-- 			end
-- 		end)
-- 	else
-- 		if h == 2 or h == 3 then 
-- 			plansWeed[k].grow = os.time()+10
-- 			plansWeed[k].health = 1
-- 			MySQL.Async.execute("UPDATE champs SET health = 1, grow = @grow WHERE id = @id", { 
-- 				["id"] = plansWeed[k].id, 
-- 				["grow"] = plansWeed[k].grow, 
-- 			}, function(alteredRow)
-- 				if alteredRow then
-- 					TriggerClientEvent("event:updatePlanWeedCallback", -1, k, plansWeed[k])
-- 				else
-- 					TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
-- 				end
-- 			end)
-- 		end
-- 		if state == 4 then 
-- 			plansWeed[k].state = 0
-- 			plansWeed[k].health = 0
-- 			MySQL.Async.execute("UPDATE champs SET state = 0, health = 0, grow = NULL, water = NULL, fertilizer = NULL WHERE id = @id", { 
-- 				["id"] = plansWeed[k].id, 
-- 				["state"] = 0, 
-- 				["health"] = 0, 
-- 			}, function(alteredRow)
-- 				if alteredRow then
-- 					if DoesEntityExist(plansWeed[k].object) then 
-- 						DeleteEntity(plansWeed[k].object)
-- 					end
-- 					TriggerClientEvent("event:updatePlanWeedCallback", -1, k, plansWeed[k])
-- 				else
-- 					TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
-- 				end
-- 			end)
-- 		end
-- 	end
-- end)


-- AddEventHandler('onResourceStop', function(resourceName)
-- 	if (GetCurrentResourceName() ~= resourceName) then
-- 		return
-- 	end
-- 	if plansWeed then 
-- 		for i,v in pairs(plansWeed) do 
-- 			if DoesEntityExist(plansWeed[i].object) then 
-- 				DeleteEntity(plansWeed[i].object)
-- 			end
-- 		end
-- 	end
--   	print('The resource ' .. resourceName .. ' was stopped.')
-- end)

-- RegisterServerEvent("addPiedChamp")
-- AddEventHandler("addPiedChamp", function(id, coords)
--     local _src = source
--     MySQL.Async.execute("INSERT INTO champs (x, y, z) VALUES (@x, @y, @z)", {
--         ["x"] = coords.x+0.0001,
--         ["y"] = coords.y+0.0001,
--         ["z"] = coords.z+0.0001,
--     }, function(alteredRow)
--         if alteredRow then
--             MySQL.Async.fetchAll("SELECT * FROM champs ORDER BY ID DESC", {}, function(sup)
--                 TriggerClientEvent("notify", _src, "Champ créé avec succès. ID: "..sup[1].id)
--             end)
--         else
--             TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
--         end
--     end)
-- end)


-- RegisterServerEvent("addPiedChamp")
-- AddEventHandler("addPiedChamp", function(id, coords)
--     local _src = source
--     MySQL.Async.execute("INSERT INTO champs (x, y, z) VALUES (@x, @y, @z)", {
--         ["x"] = coords.x+0.0001,
--         ["y"] = coords.y+0.0001,
--         ["z"] = coords.z+0.0001,
--     }, function(alteredRow)
--         if alteredRow then
--             MySQL.Async.fetchAll("SELECT * FROM champs ORDER BY ID DESC", {}, function(sup)
--                 TriggerClientEvent("notify", _src, "Champ créé avec succès. ID: "..sup[1].id)
--             end)
--         else
--             TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
--         end
--     end)
-- end)






RegisterServerEvent("addPointLivraisonCrimi")
AddEventHandler("addPointLivraisonCrimi", function(coords)
    local _src = source
    MySQL.Async.execute("INSERT INTO livraisonCrimi (x, y, z) VALUES (@x, @y, @z)", {
        ["x"] = coords.x,
        ["y"] = coords.y,
        ["z"] = coords.z,
    }, function(alteredRow)
        if alteredRow then
            TriggerClientEvent("notify", _src, "Point de livraison ajouté.")
        else
            TriggerClientEvent("notify", _src, "Une erreur s'est produite.")
        end
    end)
end)