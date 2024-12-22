lib = {
    func = {},
    using = {},
    cache = {
        counter = {['players'] = 0, ['police'] = 0}
    }
}

TogglePlayers = {}

lib.func.updateCounter = function(data)
    if not data then
        return
    end

    if data.source == '*' then
        for k,v in pairs(ESX.GetExtendedPlayers()) do
            lib.func.updateCounter({add = {'players', v.job.name}})
        end
        return
    end

    local xPlayer = data.xPlayer or ESX.GetPlayerFromId(data.source)

    if data.disconnect then
        lib.func.updateCounter({source = data.source, remove = {'players', xPlayer.job.name}})
        return
    end

    local add = data.add or {}
    local remove = data.remove or {}

    for i=1, #add do
        if lib.cache.counter[add[i]] then
            lib.cache.counter[add[i]] = lib.cache.counter[add[i]] + 1
        end
    end

    for i=1, #remove do
        if lib.cache.counter[remove[i]] then
            lib.cache.counter[remove[i]] = lib.cache.counter[remove[i]] - 1
        end
    end

    GlobalState.counter = lib.cache.counter
end

AddEventHandler('esx:setJob', function(source, job, lastjob)
    lib.func.updateCounter({source = source, add = {job.name}, remove = {lastjob.name}})
end)

AddEventHandler('esx:setGroup', function(source, group)
    Player(source).state.admin = (group ~= 'user')
end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    lib.func.updateCounter({source = source, add = {'players', xPlayer.job.name}})
    Player(xPlayer.source).state.admin = (xPlayer.group ~= 'user')
    TogglePlayers[tostring(source)] = true

    TriggerClientEvent('win:toggle', -1, TogglePlayers)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        Wait(500)

        lib.func.updateCounter({source = '*'})
    end

    TriggerClientEvent('win:toggle', -1, TogglePlayers)
end)

AddEventHandler('esx:playerDropped', function(source)
    lib.func.updateCounter({source = source, disconnect = true})
end)

RegisterNetEvent('win-scoreboard:toggle')
AddEventHandler('win-scoreboard:toggle', function(toggle)
    lib.using[source] = toggle
    GlobalState.using = lib.using
end)

RegisterCommand('kdoff', function(source)
    if TogglePlayers[tostring(source)] then
        TogglePlayers[tostring(source)] = false
        TriggerClientEvent('esx:showNotification', source, 'Wyłączono widoczność statystyk', 'info')
    else
        TogglePlayers[tostring(source)] = true
        TriggerClientEvent('esx:showNotification', source, 'Włączono widoczność statystyk', 'info')
    end

    TriggerClientEvent('win:toggle', -1, TogglePlayers)
end)

exports('serverCounter', function(name)
    return lib.cache.counter[name]
end)