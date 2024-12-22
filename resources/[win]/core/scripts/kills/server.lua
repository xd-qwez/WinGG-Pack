local lastKilled = {}
GlobalPointsTable = {}
PlayerStats = {}
PlayerStatsBySource = {}

MySQL.ready(function()
    MySQL.query('SELECT identifier, name, points, deaths, kills FROM users', {}, function(data)
        if data then
            for i = 1, #data do
                PlayerStats[data[i].identifier] = {deaths = data[i].deaths, kills = data[i].kills}
                GlobalPointsTable[data[i].identifier] = {points = data[i].points, name = data[i].name}
            end
        end
	end)
end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    if not GlobalPointsTable[xPlayer.identifier] then
        GlobalPointsTable[xPlayer.identifier] = {points = 0, name = xPlayer.name}
    end

    if PlayerStats[xPlayer.identifier] then
        PlayerStatsBySource[tostring(source)] = {kills = PlayerStats[xPlayer.identifier].kills, deaths = PlayerStats[xPlayer.identifier].deaths}
    else
        PlayerStats[xPlayer.identifier] = {kills = 0, deaths = 0}
        PlayerStatsBySource[tostring(source)] = {kills = 0, deaths = 0}
    end

    TriggerClientEvent('win:updateStats', -1, PlayerStatsBySource)

    xPlayer.set('playerPoints', GlobalPointsTable[xPlayer.identifier].points)
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    MySQL.update.await('UPDATE users SET points = ?, kills = ?, deaths = ? WHERE identifier = ?', {
        GlobalPointsTable[xPlayer.identifier].points, 
        PlayerStats[xPlayer.identifier].kills, 
        PlayerStats[xPlayer.identifier].deaths, 
        xPlayer.identifier
    })
    Wait(150)
    PlayerStatsBySource[tostring(playerId)] = {}
end)

local function checkLastKill(killerSrc, killedSrc)
    if lastKilled[killerSrc] then
        if lastKilled[killerSrc][killedSrc] then
            if lastKilled[killerSrc][killedSrc] > os.time() then
                return false
            else
                return true
            end
        else
            return true
        end
    else
        return true
    end
end

RegisterNetEvent('esx:onPlayerDeath', function(data)
    if data.killedByPlayer then
        local killedSrc = source
        local killerSrc = data.killerServerId
        if killedSrc and killerSrc then 
            local xKilledPlayer, xKillerPlayer = ESX.GetPlayerFromId(killedSrc), ESX.GetPlayerFromId(killerSrc)

            PlayerStats[xKillerPlayer.identifier] = {
                kills = tonumber(PlayerStats[tostring(xKillerPlayer.identifier)].kills + 1),  -- Zaktualizowana wartość newKills
                deaths = PlayerStats[xKillerPlayer.identifier].deaths  -- Nie zmieniona wartość deaths
            }
            
            PlayerStats[xKilledPlayer.identifier] = {
                kills = PlayerStats[xKilledPlayer.identifier].kills,  -- Nie zmieniona wartość kills
                deaths = tonumber(PlayerStats[tostring(xKilledPlayer.identifier)].deaths + 1)  -- Zaktualizowana wartość newDeaths
            }

            PlayerStatsBySource[tostring(killerSrc)] = {
                kills = tonumber(PlayerStatsBySource[tostring(killerSrc)].kills + 1),  -- Zaktualizowana wartość newKillsSource
                deaths = PlayerStatsBySource[tostring(killerSrc)].deaths  -- Nie zmieniona wartość deaths
            }
            
            PlayerStatsBySource[tostring(killedSrc)] = {
                kills = PlayerStatsBySource[tostring(killedSrc)].kills,  -- Nie zmieniona wartość kills
                deaths = tonumber(PlayerStatsBySource[tostring(killedSrc)].deaths + 1)  -- Zaktualizowana wartość newDeathsSource
            }

            TriggerClientEvent('win:updateStats', -1, PlayerStatsBySource)

            if killedSrc and killerSrc and checkLastKill(killerSrc, killedSrc) then
                local killedPoints, killerPoints = 0, 0
                if GlobalPointsTable[xKilledPlayer.identifier] then
                    killedPoints = GlobalPointsTable[xKilledPlayer.identifier].points
                else
                    local result = MySQL.single.await('SELECT name, points FROM users WHERE identifier = ?', {xKilledPlayer.identifier})
                    if result then
                        GlobalPointsTable[xKilledPlayer.identifier] = {points = result.points, name = result.name}
                    else
                        print('zabity ziombel nie jest w bazce kurwen', xKilledPlayer.identifier)
                    end
                end
                if GlobalPointsTable[xKillerPlayer.identifier].points then
                    killerPoints = GlobalPointsTable[xKillerPlayer.identifier].points
                else
                    local result = MySQL.single.await('SELECT name, points FROM users WHERE identifier = ?', {xKillerPlayer.identifier})
                    if result then
                        GlobalPointsTable[xKillerPlayer.identifier] = {points = result.points, name = result.name}
                    else
                        print('zabijający ziombel nie jest w bazce kurwen', xKillerPlayer.identifier)
                    end
                end

                local newkilledPoints, newkillerPoints = nil, nil

                local baseRanking = 100
                local difference = math.abs(killerPoints - killedPoints)

                if killerPoints > killedPoints then
                    newkilledPoints = killedPoints - math.ceil((baseRanking / (difference ^ 0.05)) / 2)
                    newkillerPoints = killerPoints + math.ceil((baseRanking / (difference ^ 0.05)))
                elseif killerPoints < killedPoints then
                    newkilledPoints = killedPoints - math.ceil((baseRanking * (difference ^ 0.1)) / 2)
                    newkillerPoints = killerPoints + math.ceil((baseRanking * (difference ^ 0.1)))
                else
                    newkilledPoints = killedPoints - (baseRanking / 2)
                    newkillerPoints = killerPoints + baseRanking
                end

                newkillerPoints = ESX.Math.Round(newkillerPoints)
                newkilledPoints = ESX.Math.Round(newkilledPoints)

                if newkillerPoints then
                    xKillerPlayer.set('playerPoints', newkillerPoints)
                    GlobalPointsTable[xKillerPlayer.identifier].points = newkillerPoints

                    local pointsDiff = math.abs(newkillerPoints - killerPoints)
                    TriggerClientEvent('win:showNotification', killerSrc, {
                        duration = 5000,
                        title = 'Zabójstwo',
                        icon = 'fa-solid fa-skull',
                        text = 'Gracz: '..xKilledPlayer.name..' ['..killedSrc..']<br>Dystans: '..data.distance..'m<br>Ranking: +'..pointsDiff..' punktów'
                    })
                    xKillerPlayer.addInventoryItem('chocolatebunny', math.random(3))
                end

                if newkilledPoints then
                    xKilledPlayer.set('playerPoints', newkilledPoints)
                    GlobalPointsTable[xKilledPlayer.identifier].points = newkilledPoints

                    local pointsDiff = math.abs(killedPoints - newkilledPoints)
                    TriggerClientEvent('win:showNotification', killedSrc, {
                        duration = 5000,
                        title = 'Zabito Cię',
                        icon = 'fa-solid fa-skull',
                        text = 'Gracz: '..xKillerPlayer.name..' ['..killerSrc..']<br>Dystans: '..data.distance..'m<br>Ranking: -'..pointsDiff..' punktów'
                    })
                end

                if not lastKilled[killerSrc] then
                    lastKilled[killerSrc] = {}
                end

                lastKilled[killerSrc][killedSrc] = os.time() + (15 * 60 * 1000)
            else
                local xKilledPlayer, xKillerPlayer = ESX.GetPlayerFromId(killedSrc), ESX.GetPlayerFromId(killerSrc)
                TriggerClientEvent('win:showNotification', killedSrc, {
                    duration = 5000,
                    title = 'Zabito Cię',
                    icon = 'fa-solid fa-skull',
                    text = 'Gracz: '..xKillerPlayer.name..' ['..killerSrc..']<br>Dystans: '..data.distance..'m'
                })
                TriggerClientEvent('win:showNotification', killerSrc, {
                    duration = 5000,
                    title = 'Zabójstwo',
                    icon = 'fa-solid fa-skull',
                    text = 'Gracz: '..xKilledPlayer.name..' ['..killedSrc..']<br>Dystans: '..data.distance..'m'
                })
            end
        end
    end
end)

ESX.RegisterCommand('setranking', 'admin', function(xPlayer, args, showError)
    local xTarget = ESX.GetPlayerFromId(tonumber(args.playerId))
    if xTarget then
        xTarget.set('playerPoints', args.ranking)
        GlobalPointsTable[xTarget.identifier].points = args.ranking
        if xPlayer then
            xPlayer.showNotification('Ustawiono ranking gracza '..xTarget.source..' na '..args.ranking, 'info')
        else
            print('Ustawiono ranking gracza '..xTarget.source..' na '..args.ranking)
        end
        LogCommands('setranking', xPlayer, {
            playerId = xTarget.source,
            ranking = args.ranking
        })
    else
        if string.len(args.playerId) == 46 then
            GlobalPointsTable[args.playerId].points = args.ranking
            MySQL.update.await('UPDATE users SET points = ? WHERE identifier = ?', {GlobalPointsTable[args.playerId].points, args.playerId})
            if xPlayer then
                xPlayer.showNotification('Ustawiono ranking gracza '..args.playerId..' na '..args.ranking, 'info')
            else
                print('Ustawiono ranking gracza '..args.playerId..' na '..args.ranking)
            end
            LogCommands('setranking', xPlayer, {
                playerId = args.playerId,
                ranking = args.ranking
            })
        end
    end
end, true, {help = 'Ustaw ranking gracza', validate = true, arguments = {
    {name = 'playerId', help = 'ID gracza lub licencja (z char:)', type = 'string'},
    {name = 'ranking', help = 'Ilość rankingu', type = 'number'},
}})

ESX.RegisterCommand('ranking', 'user', function(xPlayer, args, showError)
    if args.playerId then
        xPlayer.showNotification('Ranking gracza ['..args.playerId.source..'] wynosi: '..GlobalPointsTable[args.playerId.identifier].points, 'info')
    else
        xPlayer.showNotification('Twój ranking wynosi: '..GlobalPointsTable[xPlayer.identifier].points, 'info')
    end
end, false, {help = 'Sprawdź swój ranking lub innego gracza', arguments = {
    {name = 'playerId', validate = false, help = 'ID gracza', type = 'player'},
}})

ESX.RegisterCommand('kd', 'user', function(xPlayer, args, showError)
    if args.playerId and PlayerStatsBySource[tostring(args.playerId)] then
        local number = tonumber(PlayerStatsBySource[tostring(args.playerId)].kills / PlayerStatsBySource[tostring(args.playerId)].deaths)
        TriggerClientEvent('win:showNotification', xPlayer.source, {
            title = 'Statystyki',
            icon = 'fa-solid fa-skull',
            color = '255, 170, 0',
            text = 'K/D tego gracza wynosi ('..ESX.Math.Round(number, 2)..')'
        })
    elseif args.playerId and not PlayerStatsBySource[tostring(args.playerId)] then
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Brak gracza z takim ID', 'error')
    else
        local number = tonumber(PlayerStatsBySource[tostring(xPlayer.source)].kills / PlayerStatsBySource[tostring(xPlayer.source)].deaths)
        TriggerClientEvent('win:showNotification', xPlayer.source, {
            title = 'Statystyki',
            icon = 'fa-solid fa-skull',
            color = '255, 170, 0',
            text = 'Twoje K/D wynosi ('..ESX.Math.Round(number, 2)..')'
        })
    end
end, false, {help = 'Sprawdź statystyki swoje lub gracza', arguments = {
    {name = 'playerId', validate = false, help = 'ID gracza', type = 'player'},
}})

ESX.RegisterCommand('kdreset', 'user', function(xPlayer, args, showError)
    if xPlayer.getAccount('bank').money >= 1000000 then
        xPlayer.removeAccountMoney('bank', 1000000)
        PlayerStats[xPlayer.identifier] = {kills = 0, deaths = 0}
        PlayerStatsBySource[tostring(xPlayer.source)] = {kills = 0, deaths = 0}
        TriggerClientEvent('win:updateStats', -1, PlayerStatsBySource)
        xPlayer.showNotification('Zresetowałeś swoje statystyki', 'success')
    else
        xPlayer.showNotification('Nie masz wystarczająco pieniędzy. Brakuje ci $'..tonumber(1000000-xPlayer.getAccount('bank').money), 'error')
    end
end, false, {help = 'Zresetuj swoje statystyki', arguments = {}})