local adminList = {}

local adminRanks = {
    ['owner'] = true,
    ['manager'] = true,
    ['headadmin'] = true,
    ['developer'] = true,
    ['admin'] = true,
    ['mod'] = true,
    ['support'] = true,
    ['helper'] = true,
}

local prefixRanks = {
    ['owner'] = {
        name = 'Owner',
        color = 'rgb(204, 204, 0)'
    },
    ['manager'] = {
        name = 'Manager',
        color = 'rgb(203, 195, 227)'
    },
    ['headadmin'] = {
        name = 'Head Admin',
        color = 'rgb(170, 9, 41)'
    },
    ['developer'] = {
        name = 'Developer',
        color = 'rgb(99, 120, 153)'
    },
    ['admin'] = {
        name = 'Admin',
        color = 'rgb(255, 0, 0)'
    },
    ['mod'] = {
        name = 'Moderator',
        color = 'rgb(230, 76, 1)'
    },
    ['support'] = {
        name = 'Support',
        color = 'rgb(26, 144, 255)'
    },
    ['helper'] = {
        name = 'Helper',
        color = 'rgb(0, 255, 88)'
    },
    ['vip'] = {
        name = 'VIP',
        color = 'rgb(255, 215, 0)'
    }
}

local cooldowns = {
    ['local'] = {
        time = 3,
        players = {},
    },
    ['report'] = {
        time = 30,
        players = {},
    },
    ['global'] = {
        time = 30,
        players = {},
    },
    ['orgchat'] = {
        time = 10,
        players = {},
    },
}

local mutedPlayers = {}
local reportTable = {}

local chatWebhook = 'https://discord.com/api/webhooks/1053375905227092028/7uiqs9yhfMafGG2h1Lr3FvYui7vajf_JecWKzpiVpMY63xw7d8Jc9obSSE2mu5YDcqIU'
local maxCharacters = 100

MySQL.ready(function()
	MySQL.query('SELECT * FROM mutes', {}, function(data)
        for _, value in pairs(data) do
            local time = ESX.Math.Round(value.time/1000)
            if time > os.time() then
                mutedPlayers[value.identifier] = time
            else
                MySQL.update('DELETE FROM mutes WHERE identifier = ?', {value.identifier})
            end
        end
    end)
    MySQL.query('SELECT * FROM reportsystem', {}, function(data)
        for _, value in pairs(data) do
            reportTable[value.license] = value.count
        end
    end)
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    local playerGroup = xPlayer.getGroup()
    if adminRanks[playerGroup] then
        adminList[xPlayer.source] = true
        local splitIdentifier = SplitId(xPlayer.identifier)
        if not reportTable[splitIdentifier] then
            reportTable[splitIdentifier] = 0
            MySQL.insert.await('INSERT INTO reportsystem (license, count) VALUES (?, ?) ', {splitIdentifier, 0})
        end
    end
end)

AddEventHandler('esx:setGroup', function(source, group)
    if adminRanks[group] then
        adminList[source] = true
        local xPlayer = ESX.GetPlayerFromId(source)
        local splitIdentifier = SplitId(xPlayer.identifier)
        if not reportTable[splitIdentifier] then
            reportTable[splitIdentifier] = 0
            MySQL.insert.await('INSERT INTO reportsystem (license, count) VALUES (?, ?) ', {splitIdentifier, 0})
        end
    end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	if adminList[playerId] then
        adminList[playerId] = nil
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local splitIdentifier = SplitId(xPlayer.identifier)
        if reportTable[splitIdentifier] then
            MySQL.update.await('UPDATE reportsystem SET count = ? WHERE license = ?', {reportTable[splitIdentifier], splitIdentifier})
        end
    end
end)

AddEventHandler('chatMessage', function(playerId, playerName, message)
	if string.sub(message, 1, string.len('/')) ~= '/' then
		CancelEvent()

        local xPlayer = ESX.GetPlayerFromId(playerId)
        if string.len(message) <= maxCharacters then
            local splitIdentifier = SplitId(xPlayer.identifier)
            local canWrite = true

            if mutedPlayers[splitIdentifier] then
                if mutedPlayers[splitIdentifier] > os.time() then
                    canWrite = false
                end
            end

            if canWrite then
                local cooldown = getChatCooldown(xPlayer.source, 'local')
                if not cooldown then
                    local playerGroup = xPlayer.getGroup() == 'user' and xPlayer.get('premiumgroup') and xPlayer.get('premiumgroup') or xPlayer.getGroup()
                    local playerPrefix = prefixRanks[playerGroup] and prefixRanks[playerGroup].name or 'GRACZ'
                    local playerColor = prefixRanks[playerGroup] and prefixRanks[playerGroup].color or 'rgb(192, 192, 192)'

                    TriggerClientEvent('win_chat:sendProximityMessage', -1, xPlayer.source, 'Local', '<span style="color: '..playerColor..'">['..playerPrefix..'] ['..xPlayer.source..'] '..xPlayer.name..'</span>: '..exports['chat']:safeMessage(message), 'rgb(211, 211, 211)')
                    SendLogToDiscord(chatWebhook, 'LOKALNY CHAT', 'ID: '..xPlayer.source..'\nNick: '..xPlayer.name..'\nLicencja: '..xPlayer.identifier..'\nPostać: '..xPlayer.get('firstName')..' '..xPlayer.get('lastName')..'\nWiadomość: '..message, 5763719)
                    addChatCooldown(xPlayer.source, xPlayer.getGroup(), 'local')
                else
                    xPlayer.showNotification('Odczekaj '..cooldown..'s', 'error')
                end
            else
                local timeLeft = os.date('%Y-%m-%d %H:%M:%S', mutedPlayers[splitIdentifier])
                xPlayer.showNotification('Chat zablokowany do '..timeLeft, 'error')
            end
        else
            xPlayer.showNotification('Zbyt długa wiadomość (max ilość znaków: '..maxCharacters..')', 'error')
        end
	end
end)

RegisterCommand('global', function(source, args, rawCommand)
    if #args > 0 then
        args = table.concat(args, ' ')

        local xPlayer = ESX.GetPlayerFromId(source)
        if string.len(args) <= maxCharacters then
            local splitIdentifier = SplitId(xPlayer.identifier)
            local canWrite = true

            if mutedPlayers[splitIdentifier] then
                if mutedPlayers[splitIdentifier] > os.time() then
                    canWrite = false
                end
            end

            if canWrite then
                local cooldown = getChatCooldown(xPlayer.source, 'global')
                if not cooldown then
                    local playerGroup = xPlayer.getGroup() == 'user' and xPlayer.get('premiumgroup') and xPlayer.get('premiumgroup') or xPlayer.getGroup()
                    local playerPrefix = prefixRanks[playerGroup] and prefixRanks[playerGroup].name or 'GRACZ'
                    local playerColor = prefixRanks[playerGroup] and prefixRanks[playerGroup].color or 'rgb(192, 192, 192)'
                    TriggerClientEvent('win:chatMessage', -1, '#99ccff', 'fa-solid fa-globe', 'Global', '<span style="color: '..playerColor..'">['..playerPrefix..'] ['..xPlayer.source..'] '..xPlayer.name..'</span>: '..exports['chat']:safeMessage(args))
                    SendLogToDiscord(chatWebhook, 'GLOBALNY CHAT', 'ID: '..xPlayer.source..'\nNick: '..xPlayer.name..'\nLicencja: '..xPlayer.identifier..'\nPostać: '..xPlayer.get('firstName')..' '..xPlayer.get('lastName')..'\nWiadomość: '..args, 5763719)
                    addChatCooldown(xPlayer.source, xPlayer.getGroup(), 'global')
                else
                    xPlayer.showNotification('Odczekaj '..cooldown..'s', 'error')
                end
            else
                local timeLeft = os.date('%Y-%m-%d %H:%M:%S', mutedPlayers[splitIdentifier])
                xPlayer.showNotification('Chat zablokowany do '..timeLeft, 'error')
            end
        else
            xPlayer.showNotification('Zbyt długa wiadomość (max ilość znaków: '..maxCharacters..')', 'error')
        end
    end
end, false)

local requestReport = {}

local function generateReportNumber(source)
    local doBreak = false
    local reportNumber = nil
    while true do
        Wait(0)
        reportNumber = math.random(1111, 9999)
        if not requestReport[reportNumber] then
            doBreak = true
            requestReport[reportNumber] = source
        end

        if doBreak then
            break
        end
    end
    return reportNumber
end

ESX.RegisterCommand('report', 'user', function(xPlayer, args, showError)
    if #args > 0 then
        args = table.concat(args, ' ')
        local adminCount = adminCount()
        if adminCount > 0 then
            local cooldown = getChatCooldown(xPlayer.source, 'report')
            if not cooldown then
                local reportNumber = generateReportNumber(xPlayer.source)
                for adminSource, v in pairs(adminList) do
                    TriggerClientEvent('win:chatMessage', adminSource, 'rgb(255, 0, 0)', 'fa-solid fa-flag', 'Report #'..reportNumber, '['.. xPlayer.source ..'] ' .. xPlayer.name..': '..exports['chat']:safeMessage(args))
                end
                TriggerClientEvent('win:chatMessage', xPlayer.source, 'rgb(255, 0, 0)', 'fa-solid fa-flag', 'Report', 'Zgłoszenie #'..reportNumber..' zostało wysłane do '..adminCount..' administratorów online')
                SendLogToDiscord(chatWebhook, 'ZGŁOSZENIE', 'ID: '..xPlayer.source..'\nNick: '..xPlayer.name..'\nLicencja: '..xPlayer.identifier..'\nPostać: '..xPlayer.get('firstName')..' '..xPlayer.get('lastName')..'\nWiadomość: '..args..'\nNumer zgłoszenia: '..reportNumber, 5763719)
                addChatCooldown(xPlayer.source, xPlayer.getGroup(), 'report')
            else
                xPlayer.showNotification('Odczekaj '..cooldown..'s', 'error')
            end
        else
            xPlayer.showNotification('Brak dostępnej administracji na serwerze', 'error')
        end
    end
end, false)

ESX.RegisterCommand('acc', 'helper', function(xPlayer, args, showError)
    if requestReport[args.id] then
        local splitIdentifier = SplitId(xPlayer.identifier)
        reportTable[splitIdentifier] = reportTable[splitIdentifier] + 1
        for adminSource, v in pairs(adminList) do
            TriggerClientEvent('win:chatMessage', adminSource, 'rgb(0, 255, 0)', 'fa-solid fa-flag', 'Report #'..args.id, 'Akceptowane przez ['.. xPlayer.source ..'] '..xPlayer.name)
        end
        TriggerClientEvent('win:chatMessage', requestReport[args.id], 'rgb(0, 255, 0)', 'fa-solid fa-flag', 'Report #'..args.id, 'Administrator: ['.. xPlayer.source ..'] '..xPlayer.name..' zaakceptował twoje zgłoszenie')
        local discordMention = GetSpecificIdentifier(xPlayer.source, 'discord'):gsub('discord:', '')
        SendLogToDiscord('https://discord.com/api/webhooks/1066857216650530856/4yrl1TKUhUmp5NueFelE9IDtSZJKRjQODn_DnqzW-0g4ABnpYEbUAiylduZ-OP4kqEpq', 'ZAAKCEPTOWANE ZGŁOSZENIE', 'ID: '..xPlayer.source..'\nNick: '..xPlayer.name..'\nDiscord: <@'..discordMention..'>\nLicencja: '..xPlayer.identifier..'\nNumer zgłoszenia: '..args.id..'\nIlość zaakceptowanych zgłoszeń: '..reportTable[splitIdentifier], 5763719)
        requestReport[args.id] = nil
    else
        xPlayer.showNotification('Brak zgłoszenia o takim ID', 'error')
    end
end, false, {help = 'Zaakceptuj zgłoszenie', validate = true, arguments = {
    {name = 'id', help = 'ID zgłoszenia', type = 'number'},
}})

RegisterCommand('reportclear', function(source, args)
    if source == 0 then
        for identifier, count in pairs(reportTable) do
            reportTable[identifier] = 0
        end
        MySQL.update.await('UPDATE reportsystem SET count = 0')
        print('Pomyślnie zresetowano reporty')
    end
end, false)

ESX.RegisterCommand('msg', 'user', function(xPlayer, args, showError)
    if #args > 1 then
        local playerID = tonumber(args[1])
        local xTarget = ESX.GetPlayerFromId(playerID)
        table.remove(args, 1)
        if xTarget then
            TriggerClientEvent('win:chatMessage', xTarget.source, 'rgb(211, 211, 211)', 'fa-solid fa-messages', 'Wiadomość od gracza', '['.. xPlayer.source ..'] ' .. xPlayer.name..': '..exports['chat']:safeMessage(table.concat(args, ' ')))
            TriggerClientEvent('win:chatMessage', xPlayer.source, 'rgb(211, 211, 211)', 'fa-solid fa-messages', 'Wysłano wiadomość', exports['chat']:safeMessage(table.concat(args, ' ')))
            xPlayer.showNotification('Wysłano wiadomość do: '..xTarget.source, 'info')
        else
            xPlayer.showNotification('Podany gracz jest offline', 'error')
        end
    end
end, false)

ESX.RegisterCommand({'reply', 'r'}, 'user', function(xPlayer, args, showError)
    if #args > 1 then
        local playerGroup = xPlayer.getGroup()
        if adminRanks[playerGroup] then
            local playerID = tonumber(args[1])
            local xTarget = ESX.GetPlayerFromId(playerID)
            table.remove(args, 1)
            if xTarget then
                TriggerClientEvent('win:chatMessage', xTarget.source, 'rgb(255, 0, 0)', 'fa-solid fa-message', 'Wiadomość od administratora', '['.. xPlayer.source ..'] ' .. xPlayer.name..': '..exports['chat']:safeMessage(table.concat(args, ' ')))
                xPlayer.showNotification('Wysłano wiadomość do: '..xTarget.source, 'info')
            else
                xPlayer.showNotification('Podany gracz jest offline', 'error')
            end
        end
    end
end, false)

ESX.RegisterCommand('adminlist', 'admin', function(xPlayer, args, showError)
	local xPlayers = ESX.GetExtendedPlayers()
    local adminList = {}
	for i=1, #(xPlayers) do 
		local xPlayer = xPlayers[i]
		if adminRanks[xPlayer.getGroup()] then
            table.insert(adminList, {name = xPlayer.name, id = xPlayer.source, rank = xPlayer.getGroup()})
        end
	end
    xPlayer.triggerEvent('win:adminlist', adminList)
end, false)

ESX.RegisterCommand('chatmute', 'support', function(xPlayer, args, showError)
	if args.playerId then
        local xTarget = ESX.GetPlayerFromId(tonumber(args.playerId))
        if xTarget then
            local splitIdentifier = SplitId(xTarget.identifier)
            local expireTime = os.time() + ESX.Math.Round(args.time * 3600)
            if mutedPlayers[splitIdentifier] then
                MySQL.update.await('UPDATE mutes SET time = ? WHERE identifier = ? ', {os.date("%Y-%m-%d %H:%M:%S", expireTime), splitIdentifier})
            else
                MySQL.insert.await('INSERT INTO mutes (identifier, time) VALUES (?, ?) ', {splitIdentifier, os.date("%Y-%m-%d %H:%M:%S", expireTime)})
            end
            mutedPlayers[splitIdentifier] = expireTime
            for adminSource, v in pairs(adminList) do
                TriggerClientEvent('win:chatMessage', adminSource, 'rgb(255, 0, 0)', 'fa-solid fa-volume-xmark', 'WYCISZONY GRACZ', xPlayer.name..' wyciszył ['..xTarget.source..'] '..xTarget.name..' do '..os.date('%Y-%m-%d %H:%M:%S', expireTime))
            end
            TriggerClientEvent('win:chatMessage', xTarget.source, 'rgb(255, 0, 0)', 'fa-solid fa-volume-xmark', 'WYCISZENIE', xPlayer.name..' wyciszył cię do '..os.date('%Y-%m-%d %H:%M:%S', expireTime))
            LogCommands('chatmute', xPlayer, {
                playerId = args.playerId.source,
                time = args.time
            })
        else
            if string.len(args.playerId) == 40 then
                local expireTime = os.time() + ESX.Math.Round(args.time * 3600)
                if mutedPlayers[args.playerId] then
                    MySQL.update.await('UPDATE mutes SET time = ? WHERE identifier = ? ', {os.date("%Y-%m-%d %H:%M:%S", expireTime), args.playerId})
                else
                    MySQL.insert.await('INSERT INTO mutes (identifier, time) VALUES (?, ?) ', {args.playerId, os.date("%Y-%m-%d %H:%M:%S", expireTime)})
                end
                mutedPlayers[args.playerId] = expireTime
                for adminSource, v in pairs(adminList) do
                    TriggerClientEvent('win:chatMessage', adminSource, 'rgb(255, 0, 0)', 'fa-solid fa-volume-xmark', 'WYCISZONY GRACZ', xPlayer.name..' wyciszył '..args.playerId..' do '..os.date('%Y-%m-%d %H:%M:%S', expireTime))
                end
                TriggerClientEvent('win:chatMessage', args.playerId, 'rgb(255, 0, 0)', 'fa-solid fa-volume-xmark', 'WYCISZENIE', xPlayer.name..' wyciszył cię do '..os.date('%Y-%m-%d %H:%M:%S', expireTime))
                LogCommands('chatmute', xPlayer, {
                    playerId = args.playerId.source,
                    time = args.time
                })
            end
        end
	end
end, false, {help = 'Wycisz gracza na chacie', validate = false, arguments = {
    {name = 'playerId', validate = true, help = 'ID gracza lub Licencja', type = 'string'},
    {name = 'time', validate = true, help = 'Czas (godziny)', type = 'number'},
}})

ESX.RegisterCommand('chatunmute', 'support', function(xPlayer, args, showError)
	if args.playerId then
        local xTarget = ESX.GetPlayerFromId(tonumber(args.playerId))
        if xTarget then
            local splitIdentifier = SplitId(xTarget.identifier)
            if mutedPlayers[splitIdentifier] then
                MySQL.update('DELETE FROM mutes WHERE identifier = ?', {splitIdentifier})
                mutedPlayers[splitIdentifier] = nil
                local adminName = xPlayer and xPlayer.name or 'CONSOLE'
                for adminSource, v in pairs(adminList) do
                    TriggerClientEvent('win:chatMessage', adminSource, 'rgb(255, 0, 0)', 'fa-solid fa-volume-xmark', 'ODCISZONY GRACZ', adminName..' odciszył ['..xTarget.source..'] '..xTarget.name)
                end
                TriggerClientEvent('win:chatMessage', xTarget.source, 'rgb(255, 0, 0)', 'fa-solid fa-volume-xmark', 'ODCISZONO', adminName..' odciszył cię')
                LogCommands('chatunmute', xPlayer, {
                    playerId = args.playerId.source
                })
            end
        else
            if string.len(args.playerId) == 40 then
                if mutedPlayers[args.playerId] then
                    MySQL.update('DELETE FROM mutes WHERE identifier = ?', {args.playerId})
                    mutedPlayers[args.playerId] = nil
                    local adminName = xPlayer and xPlayer.name or 'CONSOLE'
                    for adminSource, v in pairs(adminList) do
                        TriggerClientEvent('win:chatMessage', adminSource, 'rgb(255, 0, 0)', 'fa-solid fa-volume-xmark', 'ODCISZONY GRACZ', adminName..' odciszył '..args.playerId)
                    end
                    TriggerClientEvent('win:chatMessage', args.playerId, 'rgb(255, 0, 0)', 'fa-solid fa-volume-xmark', 'ODCISZONO', adminName..' odciszył cię')
                    LogCommands('chatunmute', xPlayer, {
                        playerId = args.playerId.source
                    })
                end
            end
        end
	end
end, true, {help = 'Odcisz gracza na chacie', validate = false, arguments = {
    {name = 'playerId', validate = true, help = 'ID gracza lub Licencja', type = 'string'}
}})

ESX.RegisterCommand('adminchat', 'user', function(xPlayer, args, showError)
    if #args > 0 then
        if adminRanks[xPlayer.getGroup()] then
            args = table.concat(args, ' ')
            for adminSource, v in pairs(adminList) do
                TriggerClientEvent('win:chatMessage', adminSource, 'rgb(255, 0, 0)', 'fa-solid fa-shield', 'Admin chat', '['.. xPlayer.source ..'] ' .. xPlayer.name..': '..exports['chat']:safeMessage(args))
            end
            SendLogToDiscord(chatWebhook, 'ADMIN CHAT', 'ID: '..xPlayer.source..'\nNick: '..xPlayer.name..'\nLicencja: '..xPlayer.identifier..'\nPostać: '..xPlayer.get('firstName')..' '..xPlayer.get('lastName')..'\nWiadomość: '..args, 5763719)
        end
    end
end, false)

ESX.RegisterCommand('orgchat', 'user', function(xPlayer, args, showError)
    if string.find(xPlayer.job.name, 'org') then
        if #args > 0 then
            args = table.concat(args, ' ')
            if string.len(args) <= maxCharacters then
                local cooldown = getChatCooldown(xPlayer.source, 'orgchat')
                if not cooldown then
                    TriggerClientEvent('win_chat:sendOrgMessage', -1, 'Organizacja', '['..string.upper(xPlayer.job.label)..'] ' .. '['.. xPlayer.source ..'] ' .. xPlayer.name..': '..exports['chat']:safeMessage(args), 'rgb(192, 192, 192)')
                    SendLogToDiscord(chatWebhook, 'CHAT ORGANIZACJI', 'ID: '..xPlayer.source..'\nNick: '..xPlayer.name..'\nLicencja: '..xPlayer.identifier..'\nPostać: '..xPlayer.get('firstName')..' '..xPlayer.get('lastName')..'\nWiadomość: '..args, 5763719)
                    addChatCooldown(xPlayer.source, xPlayer.getGroup(), 'orgchat')
                else
                    xPlayer.showNotification('Odczekaj '..cooldown..'s', 'error')
                end
            else
                xPlayer.showNotification('Zbyt długa wiadomość (max ilość znaków: '..maxCharacters..')', 'error')
            end
        end
    else
        xPlayer.showNotification('Nie jesteś w organizacji', 'error')
    end
end, false)

function adminCount()
    local count = 0
    for k, v in pairs(adminList) do
        count += 1
    end
    return count
end

function addChatCooldown(source, rank, cdType)
    if not adminRanks[rank] then
        cooldowns[cdType].players[source] = os.time() + cooldowns[cdType].time
    end
end

function getChatCooldown(source, cdType)
    if cooldowns[cdType].players[source] and cooldowns[cdType].players[source] > os.time() then
        return cooldowns[cdType].players[source] - os.time()
    end
    return false
end