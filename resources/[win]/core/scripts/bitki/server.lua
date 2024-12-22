local BusyOrgs = {}
local PairedTeams = {}

function GetOrgExtendedPlayers()
    local xPlayers =  ESX.GetExtendedPlayers()
    local orgPlayers = {}
    for i = 1, #xPlayers do
        if string.find(xPlayers[i].job.name, "org") then
            orgPlayers[#orgPlayers+1] = xPlayers[i]
        end
    end

    return orgPlayers
end

ESX.RegisterServerCallback('bitki:getAvailableOrgs', function(src, cb, bitkaPlace)
    local xPlayers = GetOrgExtendedPlayers()
    local availableOrgs = {}
    for i = 1, #xPlayers do
        if xPlayers[i].job.grade == 1 or xPlayers[i].job.grade_permissions["bitki_menager"] then
            if bitkaPlace then
                if #(GetEntityCoords(GetPlayerPed(xPlayers[i].source)) - Config['bitki'].Zones[bitkaPlace].coords) < Config['bitki'].Zones[bitkaPlace].size then
                    availableOrgs[xPlayers[i].job.name] = {label = string.upper(xPlayers[i].job.label), isBusy = BusyOrgs[xPlayers[i].job.name]}
                end
            else
                availableOrgs[xPlayers[i].job.name] = {label = string.upper(xPlayers[i].job.label), isBusy = BusyOrgs[xPlayers[i].job.name]}
            end
        end
    end

	cb(availableOrgs)
end)

ESX.RegisterServerCallback('bitki:getAvailableNearOrgsPlayers', function(src, cb, place, org)
    local xPlayer = ESX.GetPlayerFromId(src)

    local orgPlayers = ESX.GetExtendedPlayers("job", org)
    local nearOrgPlayers = {}
    for i = 1, #orgPlayers do
        if #(GetEntityCoords(GetPlayerPed(orgPlayers[i].source)) - Config['bitki'].Zones[place].coords) < Config['bitki'].Zones[place].size then
            nearOrgPlayers[orgPlayers[i].source] = orgPlayers[i].name
        end
    end

    local myOrgPlayers = ESX.GetExtendedPlayers("job", xPlayer.job.name)
    local nearMyOrgPlayers = {}
    for i = 1, #myOrgPlayers do
        if #(GetEntityCoords(GetPlayerPed(myOrgPlayers[i].source)) - Config['bitki'].Zones[place].coords) < Config['bitki'].Zones[place].size then
            nearMyOrgPlayers[myOrgPlayers[i].source] = myOrgPlayers[i].name
        end
    end

	cb(nearOrgPlayers, nearMyOrgPlayers)
end)

local waitingInvitations = {}

CreateThread(function ()
    while true do
        Wait(1000)
        for org, time in pairs(waitingInvitations) do
            if time <= 0 then
                waitingInvitations[org] = nil
            end
            time = time - 1
        end
    end
end)

ESX.RegisterServerCallback('bitki:sendInvite', function(src, cb, availableOrgsPlayers, availableMyOrgsPlayers, targetOrg, targetOrglabel, bitkaPlace, settings)
    local xPlayer = ESX.GetPlayerFromId(src)

    for src2, name in pairs(availableMyOrgsPlayers) do
        local xPlayer2 = ESX.GetPlayerFromId(src)
        if xPlayer.license ~= xPlayer2.license then
            xPlayer2.showNotification(xPlayer.name.. ' wysłał zaproszenie do bitki org: "'..targetOrglabel..'"')
        end
    end

    for src2, name in pairs(availableOrgsPlayers) do
        if #(GetEntityCoords(GetPlayerPed(src2)) - Config['bitki'].Zones[bitkaPlace].coords) < Config['bitki'].Zones[bitkaPlace].size and (ESX.GetPlayerFromId(src2).job.grade_permissions["bitki_menager"] or ESX.GetPlayerFromId(src2).job.grade == 1) then
            TriggerClientEvent("bitki:receiveInvite", src2, availableOrgsPlayers, availableMyOrgsPlayers, xPlayer.job.name, xPlayer.job.label, bitkaPlace, settings)
        end
    end

    waitingInvitations[targetOrg] = 60

	cb()
end)

ESX.RegisterServerCallback('bitki:ResponseToInvite', function(src, cb, availableOrgsPlayers, availableMyOrgsPlayers, isAccept, MyOrg, MyOrgLabel, bitkaPlace, settings)
    local xPlayer = ESX.GetPlayerFromId(src)
    if waitingInvitations[xPlayer.job.name] then
        if not BusyOrgs[MyOrg] then

            waitingInvitations[xPlayer.job.name] = nil

            if isAccept then
                for src2, name in pairs(availableMyOrgsPlayers) do
                    local tPlayer = ESX.GetPlayerFromId(src2)
                    tPlayer.showNotification(xPlayer.name.. ' ['..xPlayer.job.label..'] zaakceptował zaproszenie do bitki')
                end

                for src2, name in pairs(availableOrgsPlayers) do
                    local tPlayer = ESX.GetPlayerFromId(src2)
                    tPlayer.showNotification(xPlayer.name.. ' zaakceptował zaproszenie do bitki od org: "'..MyOrgLabel..'"')
                end

                BusyOrgs[MyOrg] = true
                BusyOrgs[xPlayer.job.name] = true

                StartBitkaThread(availableOrgsPlayers, availableMyOrgsPlayers, xPlayer.job.name, MyOrg, xPlayer.job.label, MyOrgLabel, bitkaPlace, settings)

                BusyOrgs[MyOrg] = false
                BusyOrgs[xPlayer.job.name] = false
            else
                for src2, name in pairs(availableMyOrgsPlayers) do
                    local tPlayer = ESX.GetPlayerFromId(src2)
                    if tPlayer then
                        tPlayer.showNotification(xPlayer.name.. ' ['..xPlayer.job.label..'] odrzucił zaproszenie do bitki')
                    end
                end

                for src2, name in pairs(availableOrgsPlayers) do
                    local tPlayer = ESX.GetPlayerFromId(src2)
                    if tPlayer then
                        tPlayer.showNotification(xPlayer.name.. ' odrzucił zaproszenie do bitki od org: "'..MyOrgLabel..'"')
                    end
                end
            end
        else
            xPlayer.showNotification('"'..MyOrgLabel..'" jest już podczas bitki', 'error')
        end
    end
end)

function StartBitkaThread(org1Players, org2Players, org1, org2, org1Label, org2Label, bitkaPlace, settings)

    local isRanked = false
    local addonTime = false
    local prespawn = false
    for i = 1, #settings do
        if settings[i].name == "ranked" then
            isRanked = settings[i].value
        elseif settings[i].name == "looting" then
            addonTime = settings[i].value
        elseif settings[i].name == "prespawn" then
            prespawn = settings[i].value
        end
    end

    local playersToInstance = {}
    local playersHealth = {}

    local playersKills = {}
    local playersOrg1Alive = {}
    local playersOrg2Alive = {}

    for src, name in pairs(org1Players) do
        playersToInstance[#playersToInstance+1] = src
        playersOrg1Alive[src] = true
        playersHealth[src] = GetEntityHealth(GetPlayerPed(src))
        playersKills[src] = 0
        TriggerClientEvent("bitki:setHealth", src, 200)
        if prespawn then
            TriggerClientEvent("bitki:preSpawn", src, Config["bitki"].Zones[bitkaPlace].spawn[1])
        else
            TriggerClientEvent("bitki:notify", src, "~r~Bitka Rozpoczęta!", 3, 0)
        end
    end

    for src, name in pairs(org2Players) do
        playersToInstance[#playersToInstance+1] = src
        playersOrg2Alive[src] = true
        playersHealth[src] = GetEntityHealth(GetPlayerPed(src))
        playersKills[src] = 0
        TriggerClientEvent("bitki:setHealth", src, 200)
        if prespawn then
            TriggerClientEvent("bitki:preSpawn", src, Config["bitki"].Zones[bitkaPlace].spawn[2])
        else
            TriggerClientEvent("bitki:notify", src, "~r~Bitka Rozpoczęta!", 3, 0)
        end
    end


    local InstanceId = AddPlayersToInstance(playersToInstance)

    for i = 1, #playersToInstance do
        TriggerClientEvent("bitki:switchSphere", playersToInstance[i], true, bitkaPlace)
    end

    local isOrg1Alive = true
    local isOrg2Alive = true
    --mainloop
    while true do
        isOrg1Alive = false
        isOrg2Alive = false

        for src, _ in pairs(playersOrg1Alive) do
            if GetEntityHealth(GetPlayerPed(src)) == 0 then
                playersOrg1Alive[src] = nil
                for src2, _ in pairs(playersOrg2Alive) do
                    if GetPlayerPed(src2) == GetPedSourceOfDeath(GetPlayerPed(src)) then
                        playersKills[src2] = playersKills[src2] + 1
                    end
                end
            end
            isOrg1Alive = true
        end

        for src, _ in pairs(playersOrg2Alive) do
            if GetEntityHealth(GetPlayerPed(src)) == 0 then
                playersOrg2Alive[src] = nil
                for src2, _ in pairs(playersOrg1Alive) do
                    if GetPlayerPed(src2) == GetPedSourceOfDeath(GetPlayerPed(src)) then
                        playersKills[src2] = playersKills[src2] + 1
                    end
                end
            end
            isOrg2Alive = true
        end

        if not isOrg1Alive or not isOrg2Alive then
            break
        end

        Wait(0)
    end

    if addonTime then
        if isOrg1Alive then
            for i = 1, #playersToInstance do
                TriggerClientEvent("bitki:notify", playersToInstance[i], "~r~Wygrała org: "..org1Label, "Drużyna wygrana ma teraz 4 min na zlootowanie drużyny przegranej", 8, 4*60*1000)
            end
        elseif isOrg2Alive then
            for i = 1, #playersToInstance do
                TriggerClientEvent("bitki:notify", playersToInstance[i], "~r~Wygrała org: "..org2Label, "Drużyna wygrana ma teraz 4 min na zlootowanie drużyny przegranej", 8, 4*60*1000)
            end
        end
        Wait(4 * 60 * 1000)
    else
        if isOrg1Alive then
            for i = 1, #playersToInstance do
                TriggerClientEvent("bitki:notify", playersToInstance[i], "~r~Wygrała org: "..org1Label, "", 8, 0)
            end
        elseif isOrg2Alive then
            for i = 1, #playersToInstance do
                TriggerClientEvent("bitki:notify", playersToInstance[i], "~r~Wygrała org: "..org2Label, "", 8, 0)
            end
        end
    end


    local statsString = ""
    local statsToDsc = {
        [org1] = "",
        [org2] = ""
    }

    local cnt = 0

    for src, kills in pairs(playersKills) do
        if ESX.GetPlayerFromId(src) then
            cnt = cnt+1
        else
            playersKills[src] = nil
        end
    end

    for i = 1, cnt do
        local highestScore = {src = 0, kills = 0}
        for src, kills in pairs(playersKills) do
            if kills >= highestScore.kills then
                highestScore = {src = src, kills = kills}
            end
        end
        playersKills[highestScore.src] = nil

        local xPlayer = ESX.GetPlayerFromId(highestScore.src)
        statsString = statsString..xPlayer.name.." ["..string.upper(xPlayer.job.label).."]: "..highestScore.kills.."</br>"

        statsToDsc[xPlayer.job.name] = statsToDsc[xPlayer.job.name]..xPlayer.name..": "..highestScore.kills.."\n"
    end

    ReturnPlayersToMainInstance(InstanceId)

    Wait(3000)

    for i = 1, #playersToInstance do
        TriggerClientEvent("bitki:switchSphere", playersToInstance[i], false, bitkaPlace)
        TriggerClientEvent('win:chatMessage', playersToInstance[i], 'rgb(255, 16, 16)', 'fa-solid fa-messages', 'Statystyki Bitki:', statsString)
    end

    for src, health in pairs(playersHealth) do
        CreateThread(function()
            TriggerClientEvent("esx_ambulancejob:revive", src)
            Wait(500)
            TriggerClientEvent("bitki:setHealth", src, health)
        end)
    end

    if isRanked then
        local org1Points =  GetBitkiPoints(org1)
        local org2Points =  GetBitkiPoints(org2)
        local baseRanking = 500

        local PairedIteration = FoundPairedTeam()
        local divider = 1
        if PairedIteration then
            PairedTeams[PairedIteration][3] = PairedTeams[PairedIteration][3] + 1
            divider = PairedTeams[PairedIteration][3]
        else
            PairedTeams[#PairedTeams+1] = {org1, org2, 1}
        end

        if org1Points >= org2Points then
            local addonPoints = math.sqrt(org1Points - org2Points) * 20
            if isOrg1Alive then
                local winnersPoint = math.ceil((addonPoints + baseRanking) / divider)
                local losersPoint = math.ceil((addonPoints * 0.5) / divider)
                AddBitkiPoints(org1, winnersPoint)
                RemoveBitkiPoints(org2, losersPoint)
                SendRankedBitkiLogs(org1, org1Label, winnersPoint, org2, org2Label, losersPoint, statsToDsc)
            elseif isOrg2Alive then
                local winnersPoint = math.ceil((addonPoints*2 + baseRanking) / divider)
                local losersPoint = math.ceil((addonPoints) / divider)
                AddBitkiPoints(org2, winnersPoint)
                RemoveBitkiPoints(org1, losersPoint)
                SendRankedBitkiLogs(org2, org2Label, winnersPoint, org1, org1Label, losersPoint, statsToDsc)
            end
        else
            local addonPoints = math.sqrt(org2Points - org1Points) * 20
            if isOrg1Alive then
                local winnersPoint = math.ceil((addonPoints*2 + baseRanking) / divider)
                local losersPoint = math.ceil((addonPoints) / divider)
                AddBitkiPoints(org1, winnersPoint)
                RemoveBitkiPoints(org2, losersPoint)
                SendRankedBitkiLogs(org1, org1Label, winnersPoint, org2, org2Label, losersPoint, statsToDsc)
            elseif isOrg2Alive then
                local winnersPoint = math.ceil((addonPoints + baseRanking) / divider)
                local losersPoint = math.ceil((addonPoints * 0.5) / divider)
                AddBitkiPoints(org2, winnersPoint)
                RemoveBitkiPoints(org1, losersPoint)
                SendRankedBitkiLogs(org2, org2Label, winnersPoint, org1, org1Label, losersPoint, statsToDsc)
            end
        end
    else
        if isOrg1Alive then
            SendNoRankedBitkiLogs(org1, org1Label, org2, org2Label, statsToDsc)
        elseif isOrg2Alive then
            SendNoRankedBitkiLogs(org2, org2Label, org1, org1Label, statsToDsc)
        end
    end
end

function SendRankedBitkiLogs(winners, winnersLabel, winnersPoints, losers, losersLabel, losersPoints, statsToDsc)
    SendLogToDiscord("", "Rankingowa",
        "**Wygrała:** "..winnersLabel.." ("..winners..") [+"..winnersPoints.." punktów]\n"
        ..statsToDsc[winners].."\n"..
        "**Przegrała:** "..losersLabel.." ("..losers..") [-"..losersPoints.." punktów]\n"
        ..statsToDsc[losers], 15844367)
end

function SendNoRankedBitkiLogs(winners, winnersLabel, losers, losersLabel, statsToDsc)
    SendLogToDiscord("", "Nierankingowa",
        "**Wygrała:** "..winnersLabel.." ("..winners..")\n"
        ..statsToDsc[winners].."\n"..
        "**Przegrała:** "..losersLabel.." ("..losers..")\n"
        ..statsToDsc[losers], 9936031)
end

function FoundPairedTeam(org1, org2)
    for i = 1, #PairedTeams do
        if (PairedTeams[i][1] == org1 and PairedTeams[i][2] == org2) or (PairedTeams[i][2] == org1 and PairedTeams[i][1] == org2) then
            return i
        end
    end
    return false
end