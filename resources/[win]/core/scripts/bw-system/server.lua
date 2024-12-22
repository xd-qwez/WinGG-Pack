local deadPlayers = {}

RegisterNetEvent('win:revive', function(playerId)
	playerId = tonumber(playerId)
	local xPlayer = source and ESX.GetPlayerFromId(source)

	if xPlayer and xPlayer.job.name == 'ambulance' then
		local xTarget = ESX.GetPlayerFromId(playerId)
		if xTarget then
			if deadPlayers[playerId] then
                xTarget.triggerEvent('win:revive')
				deadPlayers[playerId] = nil
			end
		end
	end
end)

AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
	if GetInvokingResource() ~= 'monitor' or type(eventData) ~= 'table' or type(eventData.id) ~= 'number' then
		return
	end
	if deadPlayers[eventData.id] then
		TriggerClientEvent('win:revive', eventData.id)
		deadPlayers[eventData.id] = nil
	end
end)

RegisterNetEvent('esx:onPlayerDeath', function(data)
	local source = source
	deadPlayers[source] = 'dead'
end)

RegisterNetEvent('esx:onPlayerSpawn', function()
	local source = source
	if deadPlayers[source] then
		deadPlayers[source] = nil
	end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	if deadPlayers[playerId] then
		deadPlayers[playerId] = nil
	end
end)

ESX.RegisterCommand('revive', 'support', function(xPlayer, args, showError)
	if args.playerId then
		args.playerId.triggerEvent('win:revive')
		LogCommands('revive', xPlayer, {
            playerId = args.playerId.source
        })
	else
		xPlayer.triggerEvent('win:revive')
		LogCommands('revive', xPlayer)
	end
end, true, {help = 'Ożyw gracza', arguments = {
	{name = 'playerId', validate = false, help = 'ID Gracza', type = 'player'}
}})

ESX.RegisterCommand('revivedist', {'admin', 'mod'}, function(xPlayer, args, showError)
	local maxDist = 500
    if args.distance then
        if args.distance <= maxDist then
            local adminCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
            for k, v in pairs(GetPlayers()) do
                local playerCoords = GetEntityCoords(GetPlayerPed(v))
                local distance = #(adminCoords - playerCoords)
                if distance < args.distance then
                    TriggerClientEvent('win:revive', v)
                end
            end
			LogCommands('revivedist', xPlayer, {
				distance = args.distance,
			})
        else
			xPlayer.showNotification('Maksymalna odległość wynosi: '..maxDist, 'error')
        end
    end
end, false, {help = 'Ożyw graczy w danym dystansie', validate = true, arguments = {
    {name = 'distance', help = 'Odległość', type = 'number'},
}})