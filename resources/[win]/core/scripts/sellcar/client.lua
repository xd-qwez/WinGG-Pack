RegisterNetEvent("win_sellvehicle:menuinput")
AddEventHandler("win_sellvehicle:menuinput", function(money)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sell_vehicle_input', {
		title = 'Podaj kwotę za pojazd'
	}, function(data2, menu)

		local price = tonumber(data2.value)
		if price == nil then
			ESX.ShowNotification('~r~Nieprawidłowa wartość')
		else
			menu.close()
			TriggerServerEvent("win_sellvehicle:menuinput", price)
		end

	end, function(data2,menu)
		menu.close()
	end)
end)

RegisterNetEvent("win_sellvehicle:begin")
AddEventHandler("win_sellvehicle:begin", function(money)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsPedInAnyVehicle(playerPed,  false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)			
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 70)
    end

	local plate = GetVehicleNumberPlateText(vehicle)
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

	ESX.TriggerServerCallback('win_sellvehicle:requestPlayerCars', function(isOwnedVehicle)
		if isOwnedVehicle then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer == -1 or closestDistance > 3.0 then
				ESX.ShowNotification('~r~Brak graczy w pobliżu!')
			else
  				TriggerServerEvent('win_sellvehicle:requestserver', GetPlayerServerId(closestPlayer), vehicleProps, money)
			end
		else
			ESX.ShowNotification('~r~Pojazd nie należy do ciebie!')
		end
	end, GetVehicleNumberPlateText(vehicle))
end)

RegisterNetEvent('win_sellvehicle:requestclient')
AddEventHandler('win_sellvehicle:requestclient', function(plate, money, seller)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'resell', {
		title    = 'Czy chcesz odkupić ten pojazd za $' .. money .. '?',
		align    = 'center',
		elements = {
			{ label = 'Tak', value = true },
			{ label = 'Nie', value = false }
		},
	}, function(data, menu)
		menu.close()
		if data.current.value == true then
			TriggerServerEvent('win_sellvehicle:acceptsell', seller, plate, money)
		else
			TriggerServerEvent('win_sellvehicle:denysell', seller)
		end
	end, nil, function()
		TriggerServerEvent('win_sellvehicle:denysell', seller)
	end)
end)

RegisterNetEvent('win_sellvehicle:finish')
AddEventHandler('win_sellvehicle:finish', function()
	local ped = PlayerPedId()
	TaskLeaveVehicle(ped, GetVehiclePedIsIn(ped, false), 4160)
end)