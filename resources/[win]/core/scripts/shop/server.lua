RegisterServerEvent('win_shop:buyItem')
AddEventHandler('win_shop:buyItem', function(item, count)
    local buyItem, priceItem, labelItem = nil, nil, nil
    local useBank, useMoney = false, false
    local xPlayer = ESX.GetPlayerFromId(source)
    local cash, bank = xPlayer.getAccount('money'), xPlayer.getAccount('bank')

    for k, v in pairs(Config['shops'].shopItems) do
        if v.item == item then
            buyItem = v.item
            priceItem = v.price*count
            labelItem = v.label
            break
        end
    end

    if buyItem and priceItem and labelItem then
        if xPlayer.canCarryItem(buyItem, count) then
            if bank.money >= priceItem then
                useBank = true
            elseif cash.money >= priceItem then
                useMoney = true
            end

            if not useBank and not useMoney then
                xPlayer.showNotification('Nie posiadasz wystarczająco dużo pieniędzy. Brakuje Ci '..math.floor(priceItem-cash.money)..'$ gotówki lub '..math.floor(priceItem-bank.money)..'$ na koncie')
                return
            end
            
            if useBank then
                xPlayer.removeAccountMoney('bank', priceItem)
            else
                xPlayer.removeAccountMoney('money', priceItem)
            end
            xPlayer.addInventoryItem(buyItem, count)
            xPlayer.showNotification('Zakupiono '..labelItem..' ('..count..') za '..priceItem..'$')
            SendLogToDiscord('https://discord.com/api/webhooks/1028397930815684618/o8ThygOfD-KpGZvfgOL6GW2dMuOdARXCNOHbf1rI6OFCDDjPtvB4pkqN6PnrfHoksl9y', 'Sklep Greenzone', 'ID: '..xPlayer.source..'\nNick: '..xPlayer.name..'\nLicencja: '..xPlayer.identifier..'\nPostać: '..xPlayer.get('firstName')..' '..xPlayer.get('lastName')..'\nZakupiony przedmiot: '..labelItem..' ('..count..')\nKwota: '..priceItem..'$', 56108)
        else
            xPlayer.showNotification('Brak miejsca w ekwipunku', 'error')
        end
    end
end)