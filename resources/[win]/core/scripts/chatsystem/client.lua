RegisterNetEvent('win_chat:sendProximityMessage')
AddEventHandler('win_chat:sendProximityMessage', function(playerId, title, message, color)
	local player = PlayerId()
	local target = GetPlayerFromServerId(playerId)

	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(target)
	local playerCoords = GetEntityCoords(playerPed)
	local targetCoords = GetEntityCoords(targetPed)

	if target ~= -1 then
		if target == player or #(playerCoords - targetCoords) < 20 then
			TriggerEvent('win:chatMessage', color, 'fa-solid fa-message', title, message)
		end
	end
end)

RegisterNetEvent('win_chat:sendOrgMessage')
AddEventHandler('win_chat:sendOrgMessage', function(title, message, color)
	if ESX.PlayerData.job and string.find(ESX.PlayerData.job.name, 'org') then
		TriggerEvent('win:chatMessage', color, 'fa-solid fa-user-secret', title, message)
	end
end)

CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/global', 'Wiadomość globalna', {
		{name = "message", help = "Treść wiadomości"}
	})
	TriggerEvent('chat:addSuggestion', '/report', 'Wyślij zgłoszenie', {
		{name = 'message', help = 'Treść zgłoszenia'}
	})
end)

RegisterNetEvent('win:adminlist')
AddEventHandler('win:adminlist', function(admins)
	local elements = {}
	local adminsCount = 0
	for k, v in pairs(admins) do
		adminsCount = adminsCount + 1
		table.insert(elements, {label = v.name..' [ID: '..v.id..'] ['..string.upper(v.rank)..']', value = nil})
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'admin_list',
	{
		title    = 'Administratorzy online ('..adminsCount..')',
		align    = 'center',
		elements = elements

	}, function(data, menu)
	end, function(data, menu)
		menu.close()
	end)
end)