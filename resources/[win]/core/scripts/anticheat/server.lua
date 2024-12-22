local webhookLink = 'https://discord.com/api/webhooks/1030567585344925696/rc1C7zA8QDJcyBlKAQl4tTbaufQaDvWjcSUTjeiujwdG96-eUVsinJ5O2peFUyro4zAu'
local banroomLink = 'https://discord.com/api/webhooks/1040991559325335572/EApckOrH_3LurMJvHbGFX-W98nEMUwdh4BQAPqpcmoUTPb-7ffAqzEQoqYSxZJcuH58F'

local detectionTypes = {
    ['hitbox'] = {
        time = 21600,
        reason = 'Modyfikacja plików gry',
        color = 16711680,
    },
    ['metadmg'] = {
        time = 21600,
        reason = 'Modyfikacja plików gry',
        color = 16711680,
    },
    ['weaponSpawn'] = {
        reason = 'Cheating',
        color = 16711680,
    },
    ['clientStart'] = {
        color = 1752220,
    },
    ['clientStop'] = {
        color = 1752220,
    },
}

AddEventHandler('ptFxEvent', function(src, data)
    banPlayer(src, 'ptFxEvent - '..json.encode(data), false, true)
    CancelEvent()
end)

AddEventHandler('giveWeaponEvent', function(src, data)
    banPlayer(src, 'giveWeaponEvent - '..json.encode(data), false, true)
    CancelEvent()
end)

AddEventHandler('removeWeaponEvent', function(src, data)
    banPlayer(src, 'removeWeaponEvent - '..json.encode(data), false, true)
    CancelEvent()
end)

AddEventHandler('removeAllWeaponsEvent', function(src, data)
    banPlayer(src, 'removeAllWeaponsEvent - '..json.encode(data), false, true)
    CancelEvent()
end)

AddEventHandler('clearPedTasksEvent', function(src, data)
    local pedHandle = NetworkGetEntityFromNetworkId(data.pedId)

    if IsPedAPlayer(pedHandle) then
        banPlayer(src, 'clearPedTasksEvent - '..json.encode(data), false, true)
        CancelEvent()
    end
end)

AddEventHandler('explosionEvent', function(src, data)
    CancelEvent()
end)

local projectileList = {
    -- weaponHash
    [-123497569] = 'Hydra',
    [-1572351938] = 'Chernobog',
    [-821520672] = 'Lazer',
    [328167896] = 'APC',

    --projectileHash
    [-1278325590] = 'Rakieta Chernobog',
    [527765612] = 'Rakieta Hydry',
    [-1198741878] = 'Rakieta Lazer',
    [-767591211] = 'Pocisk APC',
}

AddEventHandler('startProjectileEvent', function(src, data)
    local weapon = projectileList[data.weaponHash] or 'BRAK'
    local projectile = projectileList[data.projectileHash] or 'BRAK'
    sendLog(src, 'Wystrzelił rakiete - Pojazd/Broń: '..weapon..' (hash: '..data.weaponHash..'), Pocisk: '..projectile..' (hash: '..data.projectileHash..')')
end)

RegisterNetEvent('win:1Q3t2j5doL9jLon', function(detectionType, value)
    local source = source
    if detectionTypes[detectionType] then
        local toLog = detectionType
        if value then
            toLog = detectionType..' | Value: '..value
        end
        sendLog(source, toLog, detectionTypes[detectionType].color and detectionTypes[detectionType].color or 16711680)
        local reason = detectionTypes[detectionType].reason and detectionTypes[detectionType].reason or false
        if reason then
            local time = detectionTypes[detectionType].time and detectionTypes[detectionType].time or false
            banPlayer(source, reason, time)
        end
    end
end)

function sendLog(source, content, color)
    local finalContent = '**ID:** '..source..'\n**Nick:** '..GetPlayerName(source)..'\n**Steam:** '..GetIdentifiers(GetPlayerIdentifiers(source), 'steam')..'\n**License: **'..GetIdentifiers(GetPlayerIdentifiers(source), 'license')..'\n**Discord:** '..GetIdentifiers(GetPlayerIdentifiers(source), 'discord')..'\nWykryto: '..content
    SendLogToDiscord(webhookLink, 'Detection', finalContent, color)
end

function banPlayer(source, reason, expireTime, resource)
    if not expireTime then
        expireTime = 2000000000
    end

    local time = 'Nigdy'
    if expireTime ~= 2000000000 then
        expireTime = os.time() + expireTime
        time = '<t:'..expireTime..':R>'
    end

    if not reason then
        reason = 'N/A'
    end

    if resource then
        sendLog(source, reason)
        reason = 'Cheating'
    end

    local discord = GetIdentifiers(GetPlayerIdentifiers(source), 'discord')
    local discordPing = '<@'..discord:gsub('discord:', '')..'>'
    local embedContent = '**Nick steam:** '..GetPlayerName(source)..'\n**Powód bana:** '..reason..'\n**Ban wygasa:** '..time
    local embeds = {
        {
            ['title'] = '**ANTICHEAT**',
            ['type'] = 'rich',
            ['color'] = 15418782,
            ['description'] = embedContent,
            ['footer'] = {
                ['text'] = 'WinGG | '..os.date('%Y/%m/%d %H:%M'),
            },
        }
    }
    PerformHttpRequest(banroomLink, function(err, text, headers) end, 'POST', json.encode({username = 'Anticheat', content = discordPing, embeds = embeds}), { ['Content-Type'] = 'application/json' })
    TriggerEvent('win:ban', source, reason, expireTime)
end

function GetIdentifiers(identifiers, id)
    for i=1, #identifiers do
        if identifiers[i]:match(id) then
            return identifiers[i]
        end
    end
    return 'Nie wykryto: '..id
end

exports('banPlayer', banPlayer)