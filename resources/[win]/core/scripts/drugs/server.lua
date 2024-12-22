local playersCollecting = {}

local items = {
    ["weed_pooch"] = "weed",
    ["coke_pooch"] = "coke",
    ["meth_pooch"] = "meth",
    ["fentanyl_pooch"] = "fentanyl",
    ["heroin_pooch"] = "heroin",
}

CreateThread(function() -- collecting loop
    while true do
        for src, item in pairs(playersCollecting) do
            local xPlayer = ESX.GetPlayerFromId(src)
            if xPlayer then
                if item.delitem then
                    if xPlayer.getInventoryItem(item.delitem).count > 0 and item.count > 0 then
                        playersCollecting[src].count = item.count - 1
                        xPlayer.removeInventoryItem(item.delitem, 1)
                        xPlayer.addInventoryItem(item.name, 1)
                    else
                        playersCollecting[src] = nil
                        TriggerClientEvent("win_drugs:stop", src)
                        xPlayer.showNotification('Nie masz już półproduktu', 'error')
                    end
                else
                    if xPlayer.canCarryItem(item.name, 1) and item.count > 0 then
                        playersCollecting[src].count = item.count - 1
                        xPlayer.addInventoryItem(item.name, 1)
                    else
                        playersCollecting[src] = nil
                        TriggerClientEvent("win_drugs:stop", src)
                        xPlayer.showNotification('Masz pełny ekwipunek', 'error')
                    end
                end
            else
                playersCollecting[src] = nil
            end
        end
        Wait(1000)
    end
end)

ESX.RegisterServerCallback('win_drugs:collect', function(src, cb, itemName)
	local xPlayer = ESX.GetPlayerFromId(src)
    local count = 0

    for i = 1, 1000 do
        if not xPlayer.canCarryItem(itemName, i) then
            break
        end
        count = i
    end

    if count > 0 then
        cb(count)
        playersCollecting[src] = {count = count, name = itemName}
    else
        xPlayer.showNotification('Masz pełny ekwipunek', 'error')
    end
end)

ESX.RegisterServerCallback('win_drugs:process', function(src, cb, itemName)
	local xPlayer = ESX.GetPlayerFromId(src)
    local count = xPlayer.getInventoryItem(items[itemName]).count

    cb(count)

    playersCollecting[src] = {count = count, name = itemName, delitem = items[itemName]}
end)

ESX.RegisterServerCallback('win_drugs:stopCollecting', function(src, cb)
    playersCollecting[src] = nil
end)