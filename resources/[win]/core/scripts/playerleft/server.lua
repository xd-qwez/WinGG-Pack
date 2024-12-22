AddEventHandler('esx:playerDropped', function(playerId, reason)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    TriggerClientEvent('win:playerLeft', -1, {
        source = xPlayer.source,
        name = xPlayer.name,
        coords = GetEntityCoords(GetPlayerPed(xPlayer.source)),
        date = os.date("%Y/%m/%d %H:%M")
    })
end)