ESX.RegisterUsableItem('energydrink', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('win:onEnergyDrink', xPlayer.source)
	xPlayer.removeInventoryItem('energydrink', 1)
end)

ESX.RegisterUsableItem('codeine_pooch', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('win:onRecoilDrug', xPlayer.source)
	xPlayer.removeInventoryItem('codeine_pooch', 1)
end)

ESX.RegisterUsableItem('meth_pooch', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('win:onMethPooch', xPlayer.source)
	xPlayer.removeInventoryItem('meth_pooch', 1)
end)

ESX.RegisterUsableItem('handcuffs', function(source)
    TriggerClientEvent('win:onHandcuffs', source)
end)

ESX.RegisterUsableItem('repairkit', function(source)
    TriggerClientEvent('win:onRepairKit', source)
end)

RegisterServerEvent('win:repairKitAction')
AddEventHandler('win:repairKitAction', function(action)
    local xPlayer = ESX.GetPlayerFromId(source)
    if action == 'give' then
        xPlayer.addInventoryItem('repairkit', 1)  
    elseif action == 'remove' then
        xPlayer.removeInventoryItem('repairkit', 1)
    end
end)

local vestTypes = {
    ['vest_light'] = 25,
    ['vest_medium'] = 50,
    ['vest_heavy'] = 100,
}

for itemName, value in pairs(vestTypes) do
    ESX.RegisterUsableItem(itemName, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        TriggerClientEvent('win:useVest', xPlayer.source, value)
        xPlayer.removeInventoryItem(itemName, 1)
    end)
end