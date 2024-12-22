local energyDrinkTimeLeft = 0
local methTimeLeft = 0
recoilDrugTimeLeft = 0

local function onEnergyThread()
	local playerid = PlayerId()
	while energyDrinkTimeLeft > 0 do
		ResetPlayerStamina(playerid)
		energyDrinkTimeLeft = energyDrinkTimeLeft - 1
		if energyDrinkTimeLeft == 1 then
			SetRunSprintMultiplierForPlayer(playerid, 1.0)
			ESX.ShowNotification('Czujesz, że energetyk przestaje działać...')
		end
		Wait(1000)
	end
end

local function onMethThread()
	local playerid = PlayerId()
	while methTimeLeft > 0 do
		ResetPlayerStamina(playerid)
		methTimeLeft = methTimeLeft - 1
		if methTimeLeft == 1 then
			SetRunSprintMultiplierForPlayer(playerid, 1.0)
			ESX.ShowNotification('Czujesz, że metamfetamina przestaje działać...')
		end
		Wait(1000)
	end
end

local function onRecoilDrug()
	while recoilDrugTimeLeft > 0 do
		recoilDrugTimeLeft = recoilDrugTimeLeft - 1
		Wait(1000)
	end
end

RegisterNetEvent('win:onEnergyDrink', function()
	local playerPed  = PlayerPedId()
	local coords     = GetEntityCoords(playerPed)
	local boneIndex  = GetPedBoneIndex(playerPed, 18905)
	
	ESX.Game.SpawnObject('prop_energy_drink', vector3(coords.x, coords.y, coords.z - 10), function(object)
		ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
			TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 8.0, -8.0, 2000, 48, 0, false, false, false)
			RemoveAnimDict('mp_player_intdrink')
		end)
		AttachEntityToEntity(object, playerPed, boneIndex,  0.09, -0.065, 0.045, -100.0, 0.0, -25.0, 1, 1, 0, 1, 1, 1)
		Wait(2100)
		DeleteObject(object)
	end)

	local needThread = false
	if energyDrinkTimeLeft == 0 then
		needThread = true
	end

	methTimeLeft = 0
	energyDrinkTimeLeft = 300

	if needThread then
		CreateThread(onEnergyThread)
	end

	SetRunSprintMultiplierForPlayer(PlayerId(), 1.30)
end)

RegisterNetEvent('win:onMethPooch', function()

	ESX.Streaming.RequestAnimDict('mp_suicide', function()
        TaskPlayAnim(PlayerPedId(), 'mp_suicide', 'pill', 8.0, -8.0, 2000, 48, 0.25, false, false, false)
        RemoveAnimDict('mp_suicide')
    end)

	local needThread = false
	if methTimeLeft == 0 then
		needThread = true
	end

	energyDrinkTimeLeft = 0
	methTimeLeft = 120

	if needThread then
		CreateThread(onMethThread)
	end

	SetRunSprintMultiplierForPlayer(PlayerId(), 1.35)
end)

RegisterNetEvent('win:onRecoilDrug', function()
	local needThread = false
	if recoilDrugTimeLeft == 0 then
		needThread = true
	end

	recoilDrugTimeLeft = 300
	ESX.ShowNotification('Efekt utrzyma się przez '..ESX.Math.Round(recoilDrugTimeLeft/60)..' minut')

	if needThread then
		CreateThread(onRecoilDrug)
	end
end)

RegisterNetEvent('win:onRepairKit', function(triggered)
	local playerPed = PlayerPedId()
	local vehicle = ESX.Game.GetVehicleInDirection()

	if IsPedSittingInAnyVehicle(playerPed) then
		ESX.ShowNotification('Nie możesz tego zrobić w pojeździe', 'error')
		return
	end

	if DoesEntityExist(vehicle) then
		if not triggered then
			TriggerServerEvent('win:repairKitAction', 'remove')
		end

		ESX.Streaming.RequestAnimDict('mini@repair', function()
			TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_ped', 8.0, -8.0, -1, 1, 0.0, false, false, false)
			RemoveAnimDict('mini@repair')
		end)

		local inRepair = true

		CreateThread(function()
			while inRepair do
				Wait(200)
				if not IsEntityPlayingAnim(playerPed, 'mini@repair', 'fixing_a_ped', 3) then
					cancelProgress()
					inRepair = false
				end
			end
		end)

		showProgress({title = 'Naprawianie pojazdu', time = 20000}, function(isDone)
			if isDone then
				local tries = 0
				while not NetworkRequestControlOfEntity(vehicle) and tries < 10 do
					tries = tries + 1
					NetworkRequestControlOfEntity(vehicle)
					Wait(100)
				end

				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)
				SetVehicleEngineOn(vehicle, true, true)

				local roll = GetEntityRoll(vehicle)
				if (roll > 30.0 or roll < -30.0) and GetEntitySpeed(vehicle) < 2 then
					SetVehicleOnGroundProperly(vehicle)
				end

				ESX.ShowNotification('Naprawiono pojazd', 'success')
			else
				if not triggered then
					TriggerServerEvent('win:repairKitAction', 'give')
				end
			end
			inRepair = false
			ClearPedTasks(playerPed)
		end)
	else
		ESX.ShowNotification('Brak pojazdu w pobliżu', 'error')
	end
end)

RegisterNetEvent('win:useVest', function(value)
	SetPedArmour(PlayerPedId(), value)
	ESX.ShowNotification('Założono kamizelkę ('..value..')', 'success')
end)