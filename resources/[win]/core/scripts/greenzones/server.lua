local playerGroups = {}

local groupSettings = {
    ['owner'] = {
        group = 'OWNER',
        color = {204, 204, 0},
        display = false
    },
    ['manager'] = {
        group = 'MANAGER',
        color = {203, 195, 227},
        display = false
    },
    ['headadmin'] = {
        group = 'HEAD ADMIN',
        color = {170, 9, 41},
        display = false
    },
    ['developer'] = {
        group = 'DEVELOPER',
        color = {99, 120, 153},
        display = false
    },
    ['admin'] = {
        group = 'ADMIN',
        color = {255, 0, 0},
        display = false
    },
    ['mod'] = {
        group = 'MODERATOR',
        color = {230, 76, 1},
        display = false
    },
    ['support'] = {
        group = 'SUPPORT',
        color = {26, 144, 255},
        display = false
    },
    ['helper'] = {
        group = 'HELPER',
        color = {0, 255, 88},
        display = false
    },
    ['vip'] = {
        group = 'VIP',
        color = {255, 215, 0},
        display = true
    }
}

local function table_copy(original)
    local copy = {}
    for key, value in pairs(original) do
        copy[key] = value
    end
    return copy
end

local function updateGroup(source, group)
    playerGroups[source] = groupSettings[group] and table_copy(groupSettings[group]) or nil
    GlobalState.groups = playerGroups
end

local function removeGroup(source)
    playerGroups[source] = nil
    GlobalState.groups = playerGroups
end

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    Wait(5000)
    if xPlayer.group == 'user' and xPlayer.get('premiumgroup') == 'vip' then
        xPlayer.group = 'vip'
    end
    updateGroup(source, xPlayer.group)
end)

AddEventHandler('esx:playerDropped', function(source)
    removeGroup(source)
end)

AddEventHandler('esx:setGroup', function(source, group)
    updateGroup(source, group)
end)

RegisterCommand('tag', function(source)
    if playerGroups[source] then
        playerGroups[source].display = not playerGroups[source].display
        GlobalState.groups = playerGroups
        TriggerClientEvent('win:showNotification', source, {
            type = 'info',
            icon = 'fa-solid fa-tag',
            duration = 5000,
            title = 'NAMETAG',
            text = 'Wyświetlanie rangi zostało: '.. (playerGroups[source].display and '<span style="color: #68f522">Włączone</span>' or '<span style="color: #f00">Wyłączone</span>')
        })
    end
end, false)