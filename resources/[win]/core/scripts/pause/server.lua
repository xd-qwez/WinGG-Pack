AddEventHandler('esx:playerLoaded', function(_, xPlayer)
    TriggerClientEvent('win-pause:maxPlayers', xPlayer.source, GetConvarInt('sv_maxclients', 128))
end)