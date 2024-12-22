local radioItems = {
    'radio',
    'radiocrime'
}

for k, v in pairs(radioItems) do
    ESX.RegisterUsableItem(v, function(source)	
        TriggerClientEvent('win-radio:item', source)
    end)
end

ESX.RegisterServerCallback('win-radio:crimeRadioList', function(source, cb, data)
    local newtable = {}
    if data then
        for id, value in pairs(data) do
            local xPlayer = ESX.GetPlayerFromId(id)
            table.insert(newtable, {playerid = id, names = xPlayer.name})
        end
    end
    cb(newtable)
end)

ESX.RegisterServerCallback('win-radio:GetUsers', function(source, cb)
    local players = exports['win-voice']:getPlayersInRadioChannel(Player(source).state['radioChannel'])
    local list = {}
    for player, isTalking in pairs(players) do
        local xPlayer = ESX.GetPlayerFromId(player)
        local list2 = {player = xPlayer.name, isTalking = isTalking, badge = xPlayer.source, isDead = Player(player).state.dead}
        table.insert(list, list2)
    end

    Wait(100)
    cb(list)
end)