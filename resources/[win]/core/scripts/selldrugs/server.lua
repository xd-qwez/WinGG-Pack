RegisterNetEvent('win-selldrugs:notifycops', function()
    local src = source
    TriggerClientEvent('win-selldrugs:notifyPolice', -1, GetEntityCoords(GetPlayerPed(src)))
end)

ESX.RegisterServerCallback('win-selldrugs:dealer', function(src, cb, multiplier)
    local xPlayer = ESX.GetPlayerFromId(src)

    local drug
    for itemName, sellPrice in pairs(Config['selldrugs'].drugs) do
        local item = xPlayer.getInventoryItem(itemName)
        if item ~= nil and item.count > 0 then
            drug = item
            drug.price = sellPrice
            break
        end
    end

    if drug then
        local drugToSellCount = math.random(1, drug.count >= 50 and 50 or drug.count)
        drug.price = drug.price * drugToSellCount + math.random(1, drugToSellCount * 300)

        Wait(4000)

        cb(true)

        Wait(1000)

        TriggerEvent('win:showNotification', src, {
            title = Config['selldrugs'].notify.title,
            text = (Config['selldrugs'].notify.sold):format(drugToSellCount, drug.label, drug.price)
        })

        xPlayer.removeInventoryItem(drug.name, drugToSellCount)
        xPlayer.addMoney(drug.price)

        SendLogToDiscord('https://discord.com/api/webhooks/1029482321843335289/qZ4aR4BIZfeUsid3z_wxCmnUalH4onEBbD7bLY-fYXPQ51ylL8ydl0UXszxc9yUq4Lx6', 'Sprzedaż narkotyków', 'ID: '..xPlayer.source..'\nNick: '..xPlayer.name..'\nLicencja: '..xPlayer.identifier..'\nPostać: '..xPlayer.get('firstName')..' '..xPlayer.get('lastName')..'\nSprzedane: '..drug.label..' ('..drugToSellCount..') za '..drug.price..'$', 56108)
    else
        TriggerEvent('win:showNotification', src, {
            type = 'error',
            title = Config['selldrugs'].notify.title,
            text = Config['selldrugs'].notify.nodrugs
        })
        cb(false)
    end
end)