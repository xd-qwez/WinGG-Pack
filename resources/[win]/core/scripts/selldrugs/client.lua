local selledPeds = {}
local haveDrugs = false
local selling = false
local drugList = {}

for item, price in pairs(Config['selldrugs'].drugs) do
	drugList[#drugList+1] = item
end

RegisterNetEvent("esx:playerLoaded", function(xPlayer)
	Wait(1000)
	for item, price in pairs(Config['selldrugs'].drugs) do
		if ESX.SearchInventory(item, true) > 0 then
			haveDrugs = true
		end
	end
end)

RegisterNetEvent('esx:removeInventoryItem', function(item, count)
	Wait(1000)
	haveDrugs = false
	for item, price in pairs(Config['selldrugs'].drugs) do
		if ESX.SearchInventory(item, true) > 0 then
			haveDrugs = true
		end
	end
end)

RegisterNetEvent('esx:addInventoryItem', function(item, count)
	Wait(1000)
	haveDrugs = false
	for item, price in pairs(Config['selldrugs'].drugs) do
		if ESX.SearchInventory(item, true) > 0 then
			haveDrugs = true
		end
	end
end)

local function makeEntityFaceEntity(entity1, entity2)
	local p1 = GetEntityCoords(entity1, true)
	local p2 = GetEntityCoords(entity2, true)

	local dx = p2.x - p1.x
	local dy = p2.y - p1.y

	local heading = GetHeadingFromVector_2d(dx, dy)
	SetEntityHeading( entity1, heading )
end

local function PlayAnimOnPed(ped, dict, anim, speed, time, flag)
	ESX.Streaming.RequestAnimDict(dict, function()
		TaskPlayAnim(ped, dict, anim, speed, speed, time, flag, 1, false, false, false)
	end)
end

local function StartSelling(closestPed)
	selling = true
	local cops = exports['win-scoreboard']:counter('police')

	if cops < Config['selldrugs'].requiredCops then
		TriggerEvent('win:showNotification', {
			type = 'error',
			title = Config['selldrugs'].notify.title,
			text = Config['selldrugs'].notify.cops
		})
		selling = false
	else
		local multiplier = 1
		if cops == 3 then
			multiplier = 1.10
		elseif cops == 4 then
			multiplier = 1.15
		elseif cops == 5 then
			multiplier = 1.20
		elseif cops == 6 then
			multiplier = 1.25
		elseif cops >= 7 then
			multiplier = 1.30
		end

		if math.random(1, 100) < 30 then
			TriggerEvent('win:showNotification', {
				type = 'error',
				title = Config['selldrugs'].notify.title,
				text = Config['selldrugs'].notify.reject
			})
			PlayPedAmbientSpeechNative(closestPed, 'GENERIC_HI', 'SPEECH_PARAMS_STANDARD')
			TriggerServerEvent('win-selldrugs:notifycops')

			selling = false
		else
			makeEntityFaceEntity(PlayerPedId(), closestPed)
			makeEntityFaceEntity(closestPed, PlayerPedId())

			FreezeEntityPosition(PlayerPedId(), true)
			FreezeEntityPosition(closestPed, true)

			SetPedTalk(closestPed)

			PlayPedAmbientSpeechNative(closestPed, 'GENERIC_HI', 'SPEECH_PARAMS_STANDARD')

			PlayAnimOnPed(closestPed, 'mp_cp_stolen_tut', 'b_think', 2.0, -1, 0)
			Wait(2000)
			TaskStandStill(closestPed, 4000)

			ESX.TriggerServerCallback("win-selldrugs:dealer", function(bool)
				if bool then
					local obj = CreateObject(`prop_weed_bottle`, 0, 0, 0, false, true, false)
					local obj2 = CreateObject(`hei_prop_heist_cash_pile`, 0, 0, 0, false, true, false)

					AttachEntityToEntity(obj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, true, true, false, true, 0, true)
					AttachEntityToEntity(obj2, closestPed, GetPedBoneIndex(closestPed,  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, true, true, false, true, 0, true)

					PlayAnimOnPed(PlayerPedId(), 'mp_common', 'givetake1_a', 8.0, -1, 0)
					PlayAnimOnPed(closestPed, 'mp_common', 'givetake1_a', 8.0, -1, 0)

					Wait(1000)

					AttachEntityToEntity(obj2, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, true, true, false, true, 0, true)
					AttachEntityToEntity(obj, closestPed, GetPedBoneIndex(closestPed,  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, true, true, false, true, 0, true)

					Wait(1000)

					DeleteEntity(obj)
					DeleteEntity(obj2)
					PlayPedAmbientSpeechNative(closestPed, 'GENERIC_THANKS', 'SPEECH_PARAMS_STANDARD')
				end

				FreezeEntityPosition(PlayerPedId(), false)
				FreezeEntityPosition(closestPed, false)

				selling = false
			end, multiplier)
		end
	end
end

CreateThread(function()
	while ESX.PlayerData == nil or ESX.PlayerData.job == nil or ESX.PlayerData.job.name == nil or ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.name == "offpolice" do
        Wait(500)
    end
	CM.RegisterButton("E", function()
		if haveDrugs and not selling and not IsPedInAnyVehicle(PlayerPedId(), true) then
			local closestPed, closestDistance = ESX.Game.GetClosestPed()
			if closestPed and not IsPedAPlayer(closestPed) and closestDistance < 1.0 and not IsEntityPositionFrozen(closestPed) and not IsEntityDead(closestPed) and not selledPeds[closestPed] then
				if #(GetEntityCoords(PlayerPedId()) - Config['selldrugs'].cityPoint) < 2500.0 then
					selledPeds[closestPed] = true
					StartSelling(closestPed)
				else
					TriggerEvent('win:showNotification', {
						type = 'error',
						title = Config['selldrugs'].notify.title,
						text = Config['selldrugs'].notify.too_far_from_city
					})
				end
			end
		end
	end)
end)

RegisterNetEvent('win-selldrugs:notifyPolice', function(coords)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
		local street = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
		local street2 = GetStreetNameFromHashKey(street)

		TriggerEvent('win:showNotification', {
			title = Config['selldrugs'].notify.police_notify_title,
			text = Config['selldrugs'].notify.police_notify_subtitle.." na ulicy: "..street2
		})

		PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", false)

		local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
		SetBlipSprite(blip,  403)
		SetBlipColour(blip,  1)
		SetBlipAlpha(blip, 250)
		SetBlipScale(blip, 1.2)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName('Sprzedaż narkotykow')
		EndTextCommandSetBlipName(blip)
		Wait(50000)
		RemoveBlip(blip)
	end
end)