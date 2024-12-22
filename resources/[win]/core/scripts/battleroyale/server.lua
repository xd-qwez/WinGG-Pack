local battleroyale = false

ESX.RegisterCommand("battleroyale", 'mod', function(xPlayer, args, showError)
    if not battleroyale then
        battleroyale = true
        local players = {}
        for _, player in ipairs(GetPlayers()) do
            if #(Config['battleroyale'].coords - GetEntityCoords(GetPlayerPed(player))) < Config['battleroyale'].cutZoneSize then
                TriggerClientEvent("battleroyale:start", player, true, Config['battleroyale'].cutZoneSize, 10*60)
                players[#players+1] = player
            else
                TriggerClientEvent("battleroyale:start", player, false)
            end
        end
        local loop = true
        while loop do
            for i = 1, #players do
                if GetEntityHealth(GetPlayerPed(players[i])) == 0 or not GetPlayerPing(players[i]) then
                    TriggerClientEvent("battleroyale:tp", players[i])
                    SendLogToDiscord('https://discord.com/api/webhooks/1086336838735765628/Fxilj65KaTAFMu6cuJQ1GLC04O-p-VPu0D4AHkPVOdMtWl9RKgc1uc_kz1iPxi0n3Yxv', 'Battle Royale', 'ID: '..players[i]..' Nick: '..GetPlayerName(players[i])..'\nodpadł\nPozostała liczba graczy: '..#players-1)
                    table.remove(players, i)
                    break
                end
            end

            if #players == 1 then
                TriggerClientEvent("battleroyale:end", -1, GetPlayerName(players[1]).." ["..players[1].."]")
                SendLogToDiscord('https://discord.com/api/webhooks/1086336838735765628/Fxilj65KaTAFMu6cuJQ1GLC04O-p-VPu0D4AHkPVOdMtWl9RKgc1uc_kz1iPxi0n3Yxv', 'Battle Royale (win)', 'ID: '..players[1]..' Nick: '..GetPlayerName(players[1])..'\nwygrał event', 15844367)
                loop = false
            end

            Wait(0)
        end
        battleroyale = false
    end
end, true)