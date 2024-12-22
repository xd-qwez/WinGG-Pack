local dragStatus = {}
local isDead, isHandcuffed = false, false
dragStatus.isDragged = false

RegisterNetEvent('win:onHandcuffs')
AddEventHandler('win:onHandcuffs', function()
	OpenHandcuffsMenu()
end)

function OpenHandcuffsMenu()
	local elements = {
		{label = 'Zakuj/Rozkuj', value = 'handcuff'},
		{label = 'Przeszukaj', value = 'search'},
		{label = 'Chwyć/Puść', value = 'drag'},
		{label = 'Wsadź do pojazdu', value = 'put_in_vehicle'},
		{label = 'Wyjmij z pojazdu', value = 'out_the_vehicle'},
		{label = 'Skopiuj strój', value = 'steal_clothes'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'handcuffs', {
		title    = 'Kajdanki',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if not IsPedInAnyVehicle(PlayerPedId(), false) then
			local closestPed, closestDistance = ESX.Game.GetClosestPed()
			local player = nil
			if closestPed ~= -1 and closestDistance <= 3.0 then
				local action = data.current.value

				if IsPedAPlayer(closestPed) then
					player = NetworkGetPlayerIndexFromPed(closestPed)
				end

				if action == 'search' then
					if not exports['core']:InLootZone() then
						OpenBodySearchMenu(player)
					else
						ESX.ShowNotification('Nie możesz tego tutaj zrobić', 'error')
					end
				elseif action == 'handcuff' then
					if not exports['core']:InLootZone() then
						if player then
							if IsPedCuffed(closestPed) or IsEntityPlayingAnim(closestPed, 'missminuteman_1ig_2', 'handsup_enter', 3) or Player(GetPlayerServerId(player)).state.dead or IsPedBeingStunned(closestPed) then
								TriggerServerEvent('win:handcuff', GetPlayerServerId(player))
							else
								ESX.ShowNotification('Gracz nie ma podniesionych rąk', 'error')
							end
						else
							TriggerServerEvent('win:handcuff', NetworkGetNetworkIdFromEntity(closestPed), true)
						end
					else
						ESX.ShowNotification('Nie możesz tego tutaj zrobić', 'error')
					end
				elseif action == 'drag' then
					if player then
						TriggerServerEvent('win:drag', GetPlayerServerId(player))
					else
						TriggerServerEvent('win:drag', NetworkGetNetworkIdFromEntity(closestPed), true)
					end
				elseif action == 'put_in_vehicle' then
					if player then
						TriggerServerEvent('win:putInVehicle', GetPlayerServerId(player))
					end
				elseif action == 'out_the_vehicle' then
					if player then
						TriggerServerEvent('win:OutVehicle', GetPlayerServerId(player))
					end
				elseif action == 'steal_clothes' then
					if player then
						if IsPedCuffed(closestPed) then
							if not Player(GetPlayerServerId(player)).state.dead then
								ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(otherSkin)
									ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(mySkin)
										if mySkin.sex == otherSkin.sex then
											TriggerEvent('skinchanger:loadClothes', mySkin, {
												['tshirt_1'] = otherSkin.tshirt_1, ['tshirt_2'] = otherSkin.tshirt_2,
												['torso_1'] = otherSkin.torso_1,   ['torso_2'] = otherSkin.torso_2,
												['pants_1'] = otherSkin.pants_1,   ['pants_2'] = otherSkin.pants_2,
												['shoes_1'] = otherSkin.shoes_1,  ['shoes_2'] = otherSkin.shoes_2,
												['bags_1'] = otherSkin.bags_1,  ['bags_2'] = otherSkin.bags_2,
												['decals_1'] = otherSkin.decals_1, ['decals_2'] = otherSkin.decals_2,
												['mask_1'] = otherSkin.mask_1, ['mask_2'] = otherSkin.mask_2,
												['bproof_1'] = otherSkin.bproof_1, ['bproof_2'] = otherSkin.bproof_2,
												['chain_1'] = otherSkin.chain_1, ['chain_2'] = otherSkin.chain_2,
												['helmet_1'] = otherSkin.helmet_1, ['helmet_2'] = otherSkin.helmet_2,
												['glasses_1'] = otherSkin.glasses_1, ['glasses_2'] = otherSkin.glasses_2,
												['arms'] = otherSkin.arms
											})
											TriggerEvent('skinchanger:getSkin', function(skin)
												TriggerServerEvent('esx_skin:save', skin)
											end)
										else
											ESX.ShowNotification('Nie możesz zabrać tych ciuchów', 'error')
										end
									end)
								end, GetPlayerServerId(player))
							else
								ESX.ShowNotification('Strój możesz skopiować tylko z żywych osób', 'error')
							end
						else
							ESX.ShowNotification('Gracz nie jest zakuty', 'error')
						end
					end
				end
			else
				if data.current.value == 'search' then
					OpenBodySearchMenuOffline()
				else
					ESX.ShowNotification('Brak graczy/pedów w pobliżu', 'error')
				end
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

exports('OpenHandcuffsMenu', OpenHandcuffsMenu)

local invisibleItems = {
	['combatpdw'] = true,
	['pumpshotgun'] = true,
	['shotgun_ammo'] = true,
	['stungun'] = true,
	['gps'] = true,
	['radio'] = true,
	['doubleaction'] = true,
	['ticket_vip'] = true,
}

function isItemInvisible(itemName)
	if invisibleItems[itemName] then
		return true
	end

	return false
end

exports('isItemInvisible', isItemInvisible)

function OpenBodySearchMenu(player, reOpened)
	local playerPed = GetPlayerPed(player)

	if not IsPedCuffed(playerPed) then
		return ESX.ShowNotification('Gracz nie jest zakuty', 'error')
	end

	ESX.TriggerServerCallback('win:getOtherPlayerData', function(data)
		local elements = {}

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 and not invisibleItems[data.inventory[i].name] then
				table.insert(elements, {
					label    = data.inventory[i].label..': '..data.inventory[i].count,
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end

		if #elements > 0 then

			if not reOpened then
				ESX.ShowNotification('Przytrzymaj SHIFT, aby zabrać całą ilość danego przedmiotu', 'info')
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
				title    = 'Przeszukiwanie',
				align    = 'center',
				elements = elements
			}, function(data, menu)
				if data.current.value then
					if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(playerPed)) <= 2.0 then
						if IsControlPressed(0, 21) then
							TriggerServerEvent('win:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
							OpenBodySearchMenu(player, true)
						else
							if data.current.amount > 1 then
								ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'bodysearch_count', {
									title = 'Ilość',
								}, function(data2, menu2)
									local quantity = tonumber(data2.value)
									if not quantity or quantity > data.current.amount then
										ESX.ShowNotification('Nieprawidłowa ilość', 'error')
									else
										menu2.close()
										TriggerServerEvent('win:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, quantity)
										OpenBodySearchMenu(player, true)
									end
								end, function(data2, menu2)
									menu2.close()
								end)
							else
								TriggerServerEvent('win:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
								OpenBodySearchMenu(player, true)
							end
						end
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		else
			ESX.ShowNotification('Gracz nie posiada przedmiotów', 'error')
			if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'body_search') then
				ESX.UI.Menu.CloseAll()
			end
		end
	end, GetPlayerServerId(player))
end

local offlineBodySearchTable = {}
RegisterNetEvent("win:droppedPlayer", function(license, coords)
	if #(GetEntityCoords(PlayerPedId()) - coords) < 100.0 then
		offlineBodySearchTable[license] = coords
		local Timeout = ESX.SetTimeout(120000, function()
			offlineBodySearchTable[license] = nil
		end)
	end
end)

function OpenBodySearchMenuOffline()
	for license, coords in pairs(offlineBodySearchTable) do
		if #(GetEntityCoords(PlayerPedId()) - coords) <= 2.0 then
			ESX.TriggerServerCallback('win:getOtherPlayerDataOffline', function(data)
				if not data then return end
				local elements = {}

				for i=1, #data.inventory, 1 do
					if data.inventory[i].count > 0 and not invisibleItems[data.inventory[i].name] then
						if data.inventory[i].label ~= nil then
							table.insert(elements, {
								label    = data.inventory[i].label..': '..data.inventory[i].count,
								value    = data.inventory[i].name,
								itemType = 'item_standard',
								amount   = data.inventory[i].count
							})
						end
					end
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search_offline', {
					title    = 'Przeszukiwanie',
					align    = 'center',
					elements = elements
				}, function(data, menu)
					if data.current.value then
						if #(GetEntityCoords(PlayerPedId()) - coords) <= 2.0 then
							TriggerServerEvent('win:confiscatePlayerItemOffline', license, data.current.itemType, data.current.value, data.current.amount)
							OpenBodySearchMenuOffline()
						end
					end
				end, function(data, menu)
					menu.close()
				end)
			end, license)
			break
		end
	end
end

RegisterNetEvent('win:handcuff')
AddEventHandler('win:handcuff', function()
	isHandcuffed = not isHandcuffed
	local playerPed = PlayerPedId()

	if isHandcuffed then

		ESX.UI.Menu.CloseAll()

		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.5, 'cuff', 0.3)

		RequestAnimDict('mp_arresting')
		while not HasAnimDictLoaded('mp_arresting') do
			Wait(100)
		end

		TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
		RemoveAnimDict('mp_arresting')

		SetEnableHandcuffs(playerPed, true)
		DisablePlayerFiring(playerPed, true)
		SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true) -- unarm player
		SetPedCanPlayGestureAnims(playerPed, false)
		DisplayRadar(false)
		exports['core']:disableHands()
	else
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.5, 'uncuff', 0.3)

		ClearPedTasks(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		DisplayRadar(true)
	end
end)

RegisterNetEvent('win:unrestrain')
AddEventHandler('win:unrestrain', function()
	if isHandcuffed then
		local playerPed = PlayerPedId()
		isHandcuffed = false
		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		DisplayRadar(true)
	end
end)

RegisterNetEvent('win:drag')
AddEventHandler('win:drag', function(copId)
	if isHandcuffed or LocalPlayer.state.dead then
		dragStatus.isDragged = not dragStatus.isDragged
		dragStatus.CopId = copId
	end
end)

CreateThread(function()
	local wasDragged
	while true do
		local Sleep = 500

		if dragStatus.isDragged then
			Sleep = 50
			local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

			if DoesEntityExist(targetPed) then
				if not wasDragged then
					AttachEntityToEntity(ESX.PlayerData.ped, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					wasDragged = true
				else
					Wait(1000)
				end
			else
				wasDragged = false
				dragStatus.isDragged = false
				DetachEntity(ESX.PlayerData.ped, true, false)
			end
		elseif wasDragged then
			wasDragged = false
			DetachEntity(ESX.PlayerData.ped, true, false)
		end
		Wait(Sleep)
	end
end)

RegisterNetEvent('win:putInVehicle')
AddEventHandler('win:putInVehicle', function()
	if isHandcuffed then
		local playerPed = PlayerPedId()
		local vehicle, distance = ESX.Game.GetClosestVehicle()

		if vehicle and distance < 5 then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				dragStatus.isDragged = false
			end
		end
	end
end)

RegisterNetEvent('win:OutVehicle')
AddEventHandler('win:OutVehicle', function()
	if isHandcuffed then
		local GetVehiclePedIsIn = GetVehiclePedIsIn
		local IsPedSittingInAnyVehicle = IsPedSittingInAnyVehicle
		local TaskLeaveVehicle = TaskLeaveVehicle
		if IsPedSittingInAnyVehicle(ESX.PlayerData.ped) then
			local vehicle = GetVehiclePedIsIn(ESX.PlayerData.ped, false)
			TaskLeaveVehicle(ESX.PlayerData.ped, vehicle, 64)
		end
	end
end)

-- Handcuff
CreateThread(function()
	local DisableControlAction = DisableControlAction
	local IsEntityPlayingAnim = IsEntityPlayingAnim
	while true do
		local Sleep = 1000

		if isHandcuffed then
			Sleep = 0
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			DisableControlAction(0, 21, true) -- Sprint

			if IsEntityPlayingAnim(ESX.PlayerData.ped, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(ESX.PlayerData.ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
					RemoveAnimDict('mp_arresting')
				end)
			end
		end
	Wait(Sleep)
	end
end)

AddEventHandler('esx:onPlayerSpawn', function(spawn)
	isDead = false
	TriggerEvent('win:unrestrain')
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
	TriggerServerEvent("win:death-offlineBodySearch")
end)

AddEventHandler('playerSpawned', function()
	TriggerServerEvent("win:revive-offlineBodySearch")
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('win:unrestrain')
	end
end)