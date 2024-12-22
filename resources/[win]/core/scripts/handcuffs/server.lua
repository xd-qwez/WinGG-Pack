RegisterNetEvent('win:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local source = source
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if not targetXPlayer then
		return
	end

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		-- does the target player have enough in their inventory?
		if targetItem.count > 0 and targetItem.count <= amount then

			-- can the player carry the said amount of x item?
			if sourceXPlayer.canCarryItem(itemName, sourceItem.count) then
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				exports['core']:SendLogToDiscord('https://discord.com/api/webhooks/1042839749469143111/_aXvuG80SkZ8snRSNSVlVFpZw5u6umTfunUE8Sd2HkGcXdwXbtWUuSaOUN_9tO8-GyfA', 'Zabrano przedmiot', 'ID: '..sourceXPlayer.source..'\nNick: '..sourceXPlayer.name..'\nLicencja: '..sourceXPlayer.identifier..'\nZabiera przedmiot: '..sourceItem.label..' ('..amount..')\ngraczowi:\nID: '..targetXPlayer.source..'\nNick: '..targetXPlayer.name..'\nLicencja: '..targetXPlayer.identifier, 15548997)
			else
				sourceXPlayer.showNotification('Nieprawidłowa ilość')
			end
		else
			sourceXPlayer.showNotification('Brak miejsca w ekwipunku', 'error')
		end

	elseif itemType == 'item_account' then
		local targetAccount = targetXPlayer.getAccount(itemName)

		-- does the target player have enough money?
		if targetAccount.money >= amount then
			targetXPlayer.removeAccountMoney(itemName, amount, "Confiscated")
			sourceXPlayer.addAccountMoney   (itemName, amount, "Confiscated")
		else
			sourceXPlayer.showNotification('Nieprawidłowa ilość')
		end

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end

		-- does the target player have weapon?
		if targetXPlayer.hasWeapon(itemName) then
			targetXPlayer.removeWeapon(itemName)
			sourceXPlayer.addWeapon   (itemName, amount)
		else
			sourceXPlayer.showNotification('Nieprawidłowa ilość')
		end
	end
end)

function calcCoords(source, target)
    if target == -1 then
        return false
    end

    local sourceCoords = GetEntityCoords(GetPlayerPed(source))
    local targetCoords = GetEntityCoords(GetPlayerPed(target))

    if #(sourceCoords - targetCoords) > 10.0 then
       return false
    end

    return true
end

RegisterNetEvent('win:handcuff')
AddEventHandler('win:handcuff', function(target)
	local _source = source
	if calcCoords(_source, target) then
		TriggerClientEvent('win:handcuff', target)
	end
end)

RegisterNetEvent('win:drag')
AddEventHandler('win:drag', function(target)
	local _source = source
	if calcCoords(_source, target) then
		TriggerClientEvent('win:drag', target, _source)
	end
end)

RegisterNetEvent('win:putInVehicle')
AddEventHandler('win:putInVehicle', function(target)
	local _source = source
	if calcCoords(_source, target) then
		TriggerClientEvent('win:putInVehicle', target)
	end
end)

RegisterNetEvent('win:OutVehicle')
AddEventHandler('win:OutVehicle', function(target)
	local _source = source
	if calcCoords(_source, target) then
		TriggerClientEvent('win:OutVehicle', target)
	end
end)

local SavedInfo = {}

AddEventHandler('playerDropped', function()
	local playerId = source
	if playerId then
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if xPlayer then
			if SavedInfo[xPlayer.identifier] then
				TriggerClientEvent("win:droppedPlayer", -1, xPlayer.identifier, GetEntityCoords(GetPlayerPed(playerId)))
			end
		end
	end
end)

RegisterServerEvent("win:revive-offlineBodySearch", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer then
		SavedInfo[xPlayer.identifier] = nil
	end
end)

RegisterServerEvent("win:death-offlineBodySearch", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer then

		local data = {
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts
		}

		SavedInfo[xPlayer.identifier] = data
		local Timeout = ESX.SetTimeout(120000, function()
			SavedInfo[xPlayer.identifier] = nil
		end)
	end
end)

ESX.RegisterServerCallback('win:getOtherPlayerData', function(source, cb, target, notify)
	local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		local data = {
			name = xPlayer.getName(),
			characterName = xPlayer.get('firstName') .. ' ' .. xPlayer.get('lastName'),
			job = xPlayer.job.label,
			grade = xPlayer.job.grade_name,
			inventory = xPlayer.getInventory(),
			accounts = xPlayer.getAccounts(),
			weapons = xPlayer.getLoadout()
		}
	end
end)

ESX.RegisterServerCallback('win:getOtherPlayerDataOffline', function(source, cb, target)
	cb(SavedInfo[target])
end)

ESX.RegisterServerCallback('win:getHandcuffsCount', function(source, cb, target)
	cb(ESX.GetPlayerFromId(source).getInventoryItem('handcuffs').count)
end)

RegisterServerEvent('win:confiscatePlayerItemOffline', function(target, itemType, itemName, amount)
	local source = source
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromIdentifier(target)

	if not targetXPlayer then
		if itemType == 'item_standard' then
			local targetItem = getItem(target, itemName)
			local sourceItem = sourceXPlayer.getInventoryItem(itemName)

			if targetItem and targetItem > 0 and targetItem <= amount then
				if sourceXPlayer.canCarryItem(itemName, sourceItem.count) then
					removeItem(target, itemName, amount)
					sourceXPlayer.addInventoryItem   (itemName, amount)
					exports['core']:SendLogToDiscord('https://discord.com/api/webhooks/1042839749469143111/_aXvuG80SkZ8snRSNSVlVFpZw5u6umTfunUE8Sd2HkGcXdwXbtWUuSaOUN_9tO8-GyfA', 'Zabrano przedmiot (offline)', 'ID: '..sourceXPlayer.source..'\nNick: '..sourceXPlayer.name..'\nLicencja: '..sourceXPlayer.identifier..'\nZabiera przedmiot: '..sourceItem.label..' ('..amount..')\ngraczowi:\nLicencja: '..target, 15548997)
				else
					sourceXPlayer.showNotification('Nieprawidłowa ilość')
				end
			else
				sourceXPlayer.showNotification('Nieprawidłowa ilość')
			end

		elseif itemType == 'item_account' then
			local targetAccount = getAccMoney(target, itemName)

			if targetAccount and targetAccount >= amount then
				removeAccMoney(target, itemName, amount)
				sourceXPlayer.addAccountMoney(itemName, amount, "Confiscated")
			else
				sourceXPlayer.showNotification('Nieprawidłowa ilość')
			end
		end
	else
		sourceXPlayer.showNotification('Gracz wrócił już na serwer', 'error')
	end
end)