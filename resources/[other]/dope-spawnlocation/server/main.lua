TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("getstatdata", function(source)
    local player = ESX.GetPlayerFromId(source)
    print(json.encode(player.PlayerData.staticsdata))
end)
