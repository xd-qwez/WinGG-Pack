QueuePlayers = {}
Duels = {}

RegisterNetEvent('win-duels:addToQueue', function()
    local source = source
    if not QueuePlayers[tostring(source)] then
        QueuePlayers[tostring(source)] = true

        TriggerClientEvent('win:showNotification', source, {
            title = 'Duels',
            icon = 'fa-solid fa-gun',
            color = '70, 185, 255',
            text = 'Dołączono do kolejki'
        })
    else
        QueuePlayers[tostring(source)] = nil

        TriggerClientEvent('win:showNotification', source, {
            title = 'Duels',
            icon = 'fa-solid fa-gun',
            color = '70, 185, 255',
            text = 'Opuszczono kolejkę'
        })
    end
end)

CreateThread(function()
    while true do
        Wait(5000)
        local count = 0
        for _ in pairs(QueuePlayers) do
            count = count + 1
        end
        if count >= 2 then
            print('Cos znalazl')
            local Player = math.random(#QueuePlayers)
            local Player2 = math.random(#QueuePlayers)

            if Player and Player2 and (Player ~= Player2) then
                
                Duels[Player] = {[1] = Player, [2] = Player2}
                local playersToInstance = {}

                for k,v in pairs(Duels[Player]) do
                    QueuePlayers[v] = nil
                    playersToInstance[#playersToInstance+1] = v
                    TriggerClientEvent('win-duels:prepare', k)
                end

                local InstanceId = AddPlayersToInstance(playersToInstance)

                local PlayerWinner = false
                local Player2Winner = false

                while true do
                    if GetEntityHealth(GetPlayerPed(Player)) == 0 then
                        PlayerWinner = true
                    elseif GetEntityHealth(GetPlayerPed(Player2)) == 0 then
                        Player2Winner = true
                    end

                    if PlayerWinner or PlayerWinner then
                        break
                    end

                    Wait(0)
                end

                if PlayerWinner then
                    TriggerClientEvent('win:showNotification', Player, {
                        title = 'Duels',
                        icon = 'fa-solid fa-gun',
                        color = '70, 185, 255',
                        text = 'Wygrałes duela'
                    })
                    TriggerClientEvent('win:showNotification', Player2, {
                        title = 'Duels',
                        icon = 'fa-solid fa-gun',
                        color = '70, 185, 255',
                        text = 'Przegrałes duela'
                    })
                elseif Player2Winner then
                    TriggerClientEvent('win:showNotification', Player2, {
                        title = 'Duels',
                        icon = 'fa-solid fa-gun',
                        color = '70, 185, 255',
                        text = 'Wygrałes duela'
                    })
                    TriggerClientEvent('win:showNotification', Player, {
                        title = 'Duels',
                        icon = 'fa-solid fa-gun',
                        color = '70, 185, 255',
                        text = 'Przegrales duela'
                    })
                end

                for src, _ in pairs(playersToInstance) do
                    TriggerClientEvent("win:revive", src)
                    TriggerClientEvent("win-duels:end", src)
                    Wait(500)
                end

                ReturnPlayersToMainInstance(InstanceId)
            end
        end
    end
end)