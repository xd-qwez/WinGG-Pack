local antiZjeby = {}
local Coins = {}
local DiscordBotToken = "MTAyNTc4ODc4NzEzOTI5NzI5MA.GAlyMw.p_zuyQNChgP-MS6TWiImwDUvYgfTf3MTMMdG1U"
local webHookLink = "https://discord.com/api/webhooks/1064211863472185365/IXqCx1RWpjHa-jn3ZMc7f1c7WsDNzwY3NtAcOsAx0ZmS4AAeD2GLsCZJd9GKaAppEtjy"
_G["🤓"] = false

local lastDrops = {}
local carDropsResponse = {}

MySQL.ready(function()
    MySQL.query('SELECT * FROM cases_coins', {}, function(data)
        if data then
            for i = 1, #data do
                Coins[data[i].license] = {gold = data[i].GoldCoins, silver = data[i].SilverCoins}
            end
        end
	end)
end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    if not Coins[xPlayer.identifier] then
        Coins[xPlayer.identifier] = {gold = 0, silver = 100}
        MySQL.insert.await('INSERT INTO cases_coins (license, GoldCoins, SilverCoins) VALUES (?, ?, ?) ', {xPlayer.identifier, 0, 100})
    end

    Wait(10 * 1000)

    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local hasNick = GetPlayerName(source) and string.find(GetPlayerName(source), 'wingg') or false
    local waitTime = hasNick and 180000 or 360000
    local notifyText = hasNick and 'Otrzymano silver coins za '..ESX.Math.Round(waitTime/60000)..' minuty gry (posiadasz wingg w nicku)' or 'Otrzymano silver coins za '..ESX.Math.Round(waitTime/60000)..' minut gry (dodaj wingg do nicku steam, aby otrzymywać coinsy szybciej)'

    CreateThread(function()
        while GetPlayerPing(source) and GetPlayerPing(source) > 0 do
            Wait(waitTime)
            ped = GetPlayerPed(source)
            if #(coords - GetEntityCoords(ped)) > 10.0 and heading ~= GetEntityHeading(ped) then
                coords = GetEntityCoords(ped)
                heading = GetEntityHeading(ped)
                Coins[xPlayer.identifier].silver = Coins[xPlayer.identifier].silver + 1
                MySQL.update.await("UPDATE cases_coins SET SilverCoins = ? WHERE license = ?", {Coins[xPlayer.identifier].silver, xPlayer.identifier})
                TriggerClientEvent('wingg:showNotification', source, {
                    type = 'info',
                    title = 'Skrzynki',
                    text = notifyText
                })
            end
        end
    end)
end)

local function splitId(string)
    local output
    for str in string.gmatch(string, "([^:]+)") do
        output = str
    end
    return output
end

local function extractDiscordIdentifier(src)
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "discord") then
            return splitId(id)
        end
    end
end

local function getUserData(src)
    local discordIdentifier = extractDiscordIdentifier(src)

    local name
    local image

    PerformHttpRequest("https://discord.com/api/v9/guilds/"..Config.DiscordServerID.."/members/"..discordIdentifier, function(err, text, headers)
        local DiscordData = json.decode(text)
        if DiscordData then
            if DiscordData.nick then
                name = DiscordData.nick
            else
                name = DiscordData.user.username
            end

            if DiscordData.user.avatar then
                image = "https://cdn.discordapp.com/avatars/"..discordIdentifier.."/"..DiscordData.user.avatar..".webp?size=128"
            else
                image = "https://i.imgur.com/FYNogHY.png"
            end
        else
            name = GetPlayerName(src)
            image = "https://i.imgur.com/FYNogHY.png"
        end
    end, 'GET', nil, {['Content-Type'] = 'application/json', ["Authorization"] = "Bot "..DiscordBotToken})

    while not name or not image do
        Wait(100)
    end

    return {name = name, image = image}
end

ESX.RegisterServerCallback('Cases:GetData', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)

    while not xPlayer do
        xPlayer = ESX.GetPlayerFromId(src)
        Wait(100)
    end

    cb(lastDrops, Coins[xPlayer.identifier])
end)

ESX.RegisterServerCallback('Cases:OpenCase', function(src, cb, caseType, caseId)
    if antiZjeby[src] then
        return
    end

    caseId += 1

    local xPlayer = ESX.GetPlayerFromId(src)
    local case = Config[caseType][caseId]

    if not case then
        print(caseType, caseId)
    end

    local chanceTable = {}
    for rareType, items in pairs(case.drop) do
        for _ = 1, Config.Categories.chances[rareType] do
            chanceTable[#chanceTable+1] = rareType
        end
    end

    local rareType = chanceTable[math.random(#chanceTable)]
    local itemIteration = math.random(#case.drop[rareType])
    local canBuy = false

    if _G["🤓"] then
        print('Cases:OpenCase:','caseType '..caseType, "caseId "..caseId, "rareType "..rareType, "itemIteration "..itemIteration)
    end

    if caseType == "premium" then
        if Coins[xPlayer.identifier].gold >= case.price then
            exports['wingg']:SendLogToDiscord(webHookLink, 'Otworzono skrzynkę premium', '**ID: **'..xPlayer.source..'\n**Nick: **'..xPlayer.name..'\n**Licencja: **'..xPlayer.identifier..'\n\n**Skrzynka: **'..case.label..'\n**preNagroda: **'..case.drop[rareType][itemIteration].label..' lub + Gold $'..case.drop[rareType][itemIteration].sellCredit..'\n**Gold: **'..Coins[xPlayer.identifier].gold..' - '..case.price..'\n**Silver: **'..Coins[xPlayer.identifier].silver, 5763719)
            Coins[xPlayer.identifier].gold = Coins[xPlayer.identifier].gold - case.price
            canBuy = true
        else
            exports['wingg']:SendLogToDiscord(webHookLink,'[Za mało kasy] skrzynka premium', '**ID: **'..xPlayer.source..'\n**Nick: **'..xPlayer.name..'\n**Licencja: **'..xPlayer.identifier..'\n\n**Skrzynka: **'..case.label..'\n**preNagroda: **'..case.drop[rareType][itemIteration].label..' lub + Gold $'..case.drop[rareType][itemIteration].sellCredit..'\n**Gold: **'..Coins[xPlayer.identifier].gold..' - '..case.price..'\n**Silver: **'..Coins[xPlayer.identifier].silver, 15548997)
        end
    elseif caseType == "nonPremium" then
        if Coins[xPlayer.identifier].silver >= case.price then
            exports['wingg']:SendLogToDiscord(webHookLink, 'Otworzono skrzynkę non-premium', '**ID: **'..xPlayer.source..'\n**Nick: **'..xPlayer.name..'\n**Licencja: **'..xPlayer.identifier..'\n\n**Skrzynka: **'..case.label..'\n**preNagroda: **'..case.drop[rareType][itemIteration].label..' lub + Silver $'..case.drop[rareType][itemIteration].sellCredit..'\n**Gold: **'..Coins[xPlayer.identifier].gold..'\n**Silver: **'..Coins[xPlayer.identifier].silver..' - '..case.price, 5763719)
            Coins[xPlayer.identifier].silver = Coins[xPlayer.identifier].silver - case.price
            canBuy = true
        else
            exports['wingg']:SendLogToDiscord(webHookLink, '[Za mało kasy] skrzynka non-premium', '**ID: **'..xPlayer.source..'\n**Nick: **'..xPlayer.name..'\n**Licencja: **'..xPlayer.identifier..'\n\n**Skrzynka: **'..case.label..'\n**preNagroda: **'..case.drop[rareType][itemIteration].label..' lub + Silver $'..case.drop[rareType][itemIteration].sellCredit..'\n**Gold: **'..Coins[xPlayer.identifier].gold..'\n**Silver: **'..Coins[xPlayer.identifier].silver..' - '..case.price, 15548997)
        end
    end

    itemIteration -= 1

    cb(canBuy, rareType, itemIteration, Coins[xPlayer.identifier])

    if canBuy then
        antiZjeby[src] = {caseType = caseType, caseId = caseId, rareType = rareType, itemIteration = itemIteration + 1}
        MySQL.update.await("UPDATE cases_coins SET GoldCoins = ?, SilverCoins = ? WHERE license = ?", {Coins[xPlayer.identifier].gold, Coins[xPlayer.identifier].silver, xPlayer.identifier})

        local user = getUserData(src)

        Wait(8 * 1000) -- delay od rozpoczęcia losowania skrzynki do wysłania dropu to innych graczy
        local drop = {caseType = caseType, caseId = caseId - 1, rareType = rareType, itemIteration = itemIteration, user = user}

        table.insert(lastDrops, 1, drop)
        lastDrops[11] = nil

        TriggerClientEvent("Cases:NewDrop", -1, drop)
    end

end)

ESX.RegisterServerCallback('Cases:CheckBalance', function(src, cb, caseType, caseId)
    caseId += 1

    local xPlayer = ESX.GetPlayerFromId(src)
    local case = Config[caseType][caseId]

    if _G["🤓"] then
        print('Cases:CheckBalance: '..caseType..' '..caseId)
    end

    if not case then
        print(caseType, caseId)
    end

    local canBuy = false
    if caseType == "premium" then
        if Coins[xPlayer.identifier].gold >= case.price then
            canBuy = true
        end
    elseif caseType == "nonPremium" then
        if Coins[xPlayer.identifier].silver >= case.price then
            canBuy = true
        end
    end

    cb(canBuy, Coins[xPlayer.identifier])
end)

ESX.RegisterServerCallback('Cases:GetReward', function(src, cb, caseType, caseId, rareType, itemIteration, getItem)
    caseId += 1
    itemIteration += 1

    local xPlayer = ESX.GetPlayerFromId(src)

    local item = Config[caseType][caseId].drop[rareType][itemIteration]

    if _G["🤓"] then
        print('recv: '..json.encode({["itemIteration"] = itemIteration, ["rareType"] = rareType, ["caseId"] = caseId, ["caseType"] = caseType}))
        print('need: '..json.encode(antiZjeby[src]))
    end

    if antiZjeby[src] and antiZjeby[src].caseType == caseType and antiZjeby[src].caseId == caseId and antiZjeby[src].rareType == rareType and antiZjeby[src].itemIteration == itemIteration then
        if getItem then
            if item.giveItemType == "item" then
                xPlayer.addInventoryItem(item.itemName, item.itemCount)
                if _G["🤓"] then
                    print("addInventoryItem", item.itemName, item.itemCount)
                end
                cb(Coins[xPlayer.identifier])
            elseif item.giveItemType == "money" then
                xPlayer.addMoney(item.itemCount)
                if _G["🤓"] then
                    print("addMoney", item.itemCount)
                end
                cb(Coins[xPlayer.identifier])
            elseif item.giveItemType == "vehicle" then
                if _G["🤓"] then
                    print("give auten", item.itemName)
                end
                carDropsResponse[xPlayer.source] = true
                xPlayer.triggerEvent('wingg-cases:giveCar', item.itemName)
                cb(Coins[xPlayer.identifier])
            end
        else
            if caseType == "premium" then
                Coins[xPlayer.identifier].gold = Coins[xPlayer.identifier].gold + item.sellCredit
            elseif caseType == "nonPremium" then
                Coins[xPlayer.identifier].silver = Coins[xPlayer.identifier].silver + item.sellCredit
            end
            MySQL.update.await("UPDATE cases_coins SET GoldCoins = ?, SilverCoins = ? WHERE license = ?", {Coins[xPlayer.identifier].gold, Coins[xPlayer.identifier].silver, xPlayer.identifier})
            cb(Coins[xPlayer.identifier])
        end

        antiZjeby[src] = nil
    end
end)

RegisterServerEvent('wingg-cases:giveCarResponse')
AddEventHandler('wingg-cases:giveCarResponse', function(plate, model)
	local xPlayer = ESX.GetPlayerFromId(source)
	if carDropsResponse[xPlayer.source] then
        MySQL.insert('INSERT INTO owned_vehicles (owner, plate, vehicle, state) VALUES (?, ?, ?, ?)', {xPlayer.identifier, plate, json.encode({model = joaat(model), plate = plate}), 1
		}, function(rowsChanged)
			xPlayer.showNotification('Otrzymano pojazd z rejestracja '..plate, 'success')
		end)
		carDropsResponse[xPlayer.source] = nil
	else
		exports['wingg-interiors']:banPlayer(xPlayer.source, 'wingg-cases:giveCarResponse', false, GetCurrentResourceName())
	end
end)

exports('AddCoins', function(src, value)
    local xPlayer = ESX.GetPlayerFromId(src)
    Coins[xPlayer.identifier].gold = Coins[xPlayer.identifier].gold + value
    MySQL.update.await("UPDATE cases_coins SET GoldCoins = ?, SilverCoins = ? WHERE license = ?", {Coins[xPlayer.identifier].gold, Coins[xPlayer.identifier].silver, xPlayer.identifier})
end)

RegisterCommand('addCoins', function(source, args)
    if source == 0 then
        local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
        local goldCoins = (tonumber(args[2]) and tonumber(args[2]) or 0)
        local SilverCoins = (tonumber(args[3]) and tonumber(args[3]) or 0)
        if not xPlayer then return end

        Coins[xPlayer.identifier].gold = Coins[xPlayer.identifier].gold + goldCoins
        Coins[xPlayer.identifier].silver = Coins[xPlayer.identifier].silver + SilverCoins
        MySQL.update.await("UPDATE cases_coins SET GoldCoins = ?, SilverCoins = ? WHERE license = ?", {Coins[xPlayer.identifier].gold, Coins[xPlayer.identifier].silver, xPlayer.identifier})
        xPlayer.showNotification('Zaktualizowano twoje coinsy - GC: '..Coins[xPlayer.identifier].gold..', SC: '..Coins[xPlayer.identifier].silver, 'info')
    end
end, false)

ESX.RegisterCommand('car-greenscreen', 'admin', function(xPlayer, args, showError)
	local GameBuild = tonumber(GetConvar("sv_enforceGameBuild", 1604))
	if not args.car then args.car = GameBuild >= 2699 and "draugur" or "prototipo" end
	local upgrades = Config.MaxAdminVehicles and {
		plate = "ADMINCAR",
		modEngine = 3,
		modBrakes = 2,
		modTransmission = 2,
		modSuspension = 3,
		modArmor = true,
		windowTint = 1,
	} or {}

	ESX.OneSync.SpawnVehicle(args.car, vector3(-1277.4091, -3158.4219, 32.9582), 200.0, upgrades, function(networkId)
        local PlayerPed = GetPlayerPed(xPlayer.source)
        SetEntityCoords(PlayerPed, -1273.8574, -3161.2109, 32.9582)
        SetEntityHeading(PlayerPed, 60.0)
	end)
end, false, {help = "chuj", validate = false, arguments = {
	{name = 'car', validate = false, help = "wielki", type = 'string'}
}})
