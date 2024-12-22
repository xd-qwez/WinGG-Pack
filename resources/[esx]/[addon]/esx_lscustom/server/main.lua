local Vehicles
local Customs = {}

RegisterNetEvent('esx_lscustom:startModing', function(props, netId)
	local src = tostring(source)
	if Customs[src] then
		Customs[src][tostring(props.plate)] = {props = props, netId = netId}
	else
		Customs[src] = {}
		Customs[src][tostring(props.plate)] = {props = props, netId = netId}
	end
end)

RegisterNetEvent('esx_lscustom:stopModing', function(plate)
	local src = tostring(source)
	if Customs[src] then
		Customs[src][tostring(plate)] = nil
	end
end)

AddEventHandler('esx:playerDropped', function(src)
    src = tostring(src)
	local playersCount = #GetPlayers()
    if Customs[src] then
        for k, v in pairs(Customs[src]) do
            local entity = NetworkGetEntityFromNetworkId(v.netId)
            if DoesEntityExist(entity) then
                if playersCount > 0 then
                    TriggerClientEvent('esx_lscustom:restoreMods', -1, v.netId, v.props)
                else
                    DeleteEntity(entity)
                end
            end
        end
        Customs[src] = nil
    end
end)

RegisterServerEvent('esx_lscustom:buyMod')
AddEventHandler('esx_lscustom:buyMod', function(price)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	price = tonumber(price)

	if Config.IsMechanicJobOnly then
		local societyAccount

		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			societyAccount = account
		end)

		if price < societyAccount.money then
			TriggerClientEvent('esx_lscustom:installMod', source)
			TriggerClientEvent('esx:showNotification', source, _U('purchased'))
			societyAccount.removeMoney(price)
		else
			TriggerClientEvent('esx_lscustom:cancelInstallMod', source)
			TriggerClientEvent('esx:showNotification', source, _U('not_enough_money'))
		end
	else
		if price <= xPlayer.getMoney() then
			TriggerClientEvent('esx_lscustom:installMod', source)
			TriggerClientEvent('esx:showNotification', source, _U('purchased'))
			xPlayer.removeMoney(price, "LSC Purchase")
			exports['wingg']:SendLogToDiscord('https://discord.com/api/webhooks/1064942327677849730/p5LMqdWHkOz2rxcBw3-Q3COx4H3WqV8dEnNTo_A5fSblH-s13Z3BMOVulIiZai78p0KR', 'Wykonano tuning', 'ID: '..xPlayer.source..'\nNick: '..xPlayer.name..'\nLicencja: '..xPlayer.identifier..'\nPostać: '..xPlayer.get('firstName')..' '..xPlayer.get('lastName')..'\nKwota: '..price..'$ (gotówka)', 5763719)
		elseif price <= xPlayer.getAccount('bank').money then
			TriggerClientEvent('esx_lscustom:installMod', source)
			TriggerClientEvent('esx:showNotification', source, _U('purchased'))
			xPlayer.removeAccountMoney('bank', price, "LSC Purchase")
			exports['wingg']:SendLogToDiscord('https://discord.com/api/webhooks/1064942327677849730/p5LMqdWHkOz2rxcBw3-Q3COx4H3WqV8dEnNTo_A5fSblH-s13Z3BMOVulIiZai78p0KR', 'Wykonano tuning', 'ID: '..xPlayer.source..'\nNick: '..xPlayer.name..'\nLicencja: '..xPlayer.identifier..'\nPostać: '..xPlayer.get('firstName')..' '..xPlayer.get('lastName')..'\nKwota: '..price..'$ (bank)', 5763719)
		else
			TriggerClientEvent('esx_lscustom:cancelInstallMod', source)
			TriggerClientEvent('esx:showNotification', source, _U('not_enough_money'))
		end
	end
end)

RegisterServerEvent('esx_lscustom:refreshOwnedVehicle')
AddEventHandler('esx_lscustom:refreshOwnedVehicle', function(vehicleProps, netId)
	local src = tostring(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.single('SELECT vehicle FROM owned_vehicles WHERE plate = ?', {vehicleProps.plate},
	function(result)
		if result then
			local vehicle = json.decode(result.vehicle)
			if vehicleProps.model == vehicle.model then
				MySQL.update('UPDATE owned_vehicles SET vehicle = ? WHERE plate = ?', {json.encode(vehicleProps), vehicleProps.plate})
				if Customs[src] then
					if Customs[src][tostring(vehicleProps.plate)]  then
						Customs[src][tostring(vehicleProps.plate)].props = vehicleProps
					else
						Customs[src][tostring(vehicleProps.plate)] = {props = vehicleProps, netId = netId}
					end
				else
					Customs[src] = {}
					Customs[src][tostring(vehicleProps.plate)] = {props = vehicleProps, netId = netId}
				end
        local veh = NetworkGetEntityFromNetworkId(netId)
				local Veh_State = Entity(veh).state.VehicleProperties
				if Veh_State then
					Entity(veh).state:set("VehicleProperties", vehicleProps, true)
        		end
			else
				print(('[^3WARNING^7] Player ^5%s^7 Attempted To upgrade with mismatching vehicle model'):format(xPlayer.source))
			end
		end
	end)
end)

ESX.RegisterServerCallback('esx_lscustom:getVehiclesPrices', function(source, cb)
	if not Vehicles then
		Vehicles = MySQL.query.await('SELECT model, price FROM vehicles')
	end
	cb(Vehicles)
end)
