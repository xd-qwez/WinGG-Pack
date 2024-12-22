local function getProtection(table)
    table['ip'] = GetCurrentServerEndpoint()
    table['key'] = 'ABP3G94A9P3B4EUHAHB43UP9ABHP394U9UH43PBUEOUVNO'
    return table
end

RegisterNetEvent("Cases:NewDrop", function(newDrop)
    SendNUIMessage({
        action = "last-drop",
        value = getProtection({newDrop = newDrop})
    })
end)

RegisterNUICallback('NUIFocusOff', function()
	SetNuiFocus(false, false)
end)

SetNuiFocus(false, false)

RegisterCommand("skrzynki", function()
    ESX.TriggerServerCallback("Cases:GetData", function(lastDrops, coins)
        SendNUIMessage({
            action = "open-container",
            value = getProtection({config = {premium = Config.premium, nonPremium = Config.nonPremium}, lastDrops = lastDrops, coins = coins})
        })
        SetNuiFocus(true, true)
    end)
end, false)

RegisterNUICallback('checkBalance', function(data, cb)
    ESX.TriggerServerCallback("Cases:CheckBalance", function(canBuy, coins) -- bang bang chief keef sosa
        cb({canBuy = canBuy, coins = coins})
    end, data.caseType, data.caseId)
end)

RegisterNUICallback('openCase', function(data, cb)
    ESX.TriggerServerCallback("Cases:OpenCase", function(canBuy, rareType, itemId, coins)
        cb({canBuy = canBuy, rareType = rareType, itemId = itemId, coins = coins})
    end, data.caseType, data.caseId)
end)

RegisterNUICallback('getReward', function(data, cb)
    ESX.TriggerServerCallback("Cases:GetReward", function(coins)
        cb({coins = coins})
    end, data.caseType, data.caseId, data.rareType, data.itemIteration, data.getItem)
end)

RegisterNetEvent('wingg-cases:giveCar', function(vehicle)
    if IsModelInCdimage(joaat(vehicle)) then
        local plate = exports['esx_vehicleshop']:GeneratePlate()
        TriggerServerEvent('wingg-cases:giveCarResponse', plate, joaat(vehicle))
    end
end)