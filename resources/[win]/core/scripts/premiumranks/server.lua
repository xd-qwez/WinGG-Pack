local ranksTable = {}
local rankTime = 2592000

local allowedRanks = {
    ['vip'] = true
}

local ranksItems = {
    ['vip'] = 'ticket_vip'
}

MySQL.ready(function()
    MySQL.query('SELECT premiumgroup, identifier FROM users', {}, function(data)
        if data then
            for i = 1, #data do
                if data[i].premiumgroup then
                    ranksTable[data[i].identifier] = json.decode(data[i].premiumgroup)
                end
            end
        end
	end)
end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    if ranksTable[xPlayer.identifier] then
        for rankName, time in pairs(ranksTable[xPlayer.identifier]) do
            if time >= os.time() then
                xPlayer.set('premiumgroup', rankName)
            else
                xPlayer.set('premiumgroup', false)
            end
        end
    else
        xPlayer.set('premiumgroup', false)
    end
end)

RegisterCommand('addPremiumGroup', function(source, args)
    if source == 0 then
        local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
        if not xPlayer then return end

        local rank = args[2]
        if allowedRanks[rank] then
            xPlayer.set('premiumgroup', rank)
            ranksTable[xPlayer.identifier] = {
                [rank] = os.time() + rankTime
            }
            MySQL.update.await('UPDATE users SET premiumgroup = ? WHERE identifier = ?', {json.encode(ranksTable[xPlayer.identifier]), xPlayer.identifier})
        end
    end
end, false)

RegisterCommand('removePremiumGroup', function(source, args)
    if source == 0 then
        local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
        if not xPlayer then return end

        xPlayer.set('premiumgroup', false)
        ranksTable[xPlayer.identifier] = nil
        MySQL.update.await('UPDATE users SET premiumgroup = ? WHERE identifier = ?', {nil, xPlayer.identifier})
    end
end, false)

for rank, itemName in pairs(ranksItems) do
    ESX.RegisterUsableItem(itemName, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(itemName, 1)
        xPlayer.set('premiumgroup', rank)
        ranksTable[xPlayer.identifier] = {
            [rank] = os.time() + rankTime
        }
        MySQL.update.await('UPDATE users SET premiumgroup = ? WHERE identifier = ?', {json.encode(ranksTable[xPlayer.identifier]), xPlayer.identifier})
        xPlayer.showNotification('Odebrano rangę: '..rank, 'success')
    end)
end