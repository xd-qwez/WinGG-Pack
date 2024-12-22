local Kits = {
    ['start'] = {
        groups = {
            ['user'] = true,
            ['helper'] = true,
            ['support'] = true,
            ['mod'] = true,
            ['admin'] = true,
            ['headadmin'] = true,
            ['developer'] = true,
            ['manager'] = true,
            ['owner'] = true,
        },
        delay = 60*60*6,
        items = {
            ['handcuffs'] = 1,
            ['radiocrime'] = 1,
            ['energydrink'] = 3,
            ['pistol'] = 1,
            ['pistol_ammo'] = 100,
        }
    },
    ['vip'] = {
        groups = {
            ['vip'] = true,
            ['mod'] = true,
            ['admin'] = true,
            ['headadmin'] = true,
            ['manager'] = true,
            ['owner'] = true,
        },
        delay = 60*60*6,
        items = {
            ['handcuffs'] = 2,
            ['radiocrime'] = 2,
            ['energydrink'] = 6,
            ['vintagepistol'] = 1,
            ['snspistol_mk2'] = 1,
            ['pistol_ammo'] = 200,
            ['codeine_pooch'] = 4,
            ['vest_medium'] = 2,
        }
    },
    ['sieka'] = {
        groups = {
            ['developer'] = true,
            ['manager'] = true,
            ['owner'] = true,
        },
        delay = 30,
        items = {
            ['handcuffs'] = 1,
            ['meth_pooch'] = 2,
            ['vintagepistol'] = 1,
            ['snspistol_mk2'] = 1,
            ['pistol_ammo'] = 90
        }
    },
}

local KitsTable = {}
local collectingKit = {}

MySQL.ready(function()
	MySQL.query('SELECT * FROM kits', {}, function(data)
        for _, value in ipairs(data) do
            KitsTable[value.identifier] = json.decode(value.data)
        end
    end)
end)

local function GetKitsByIdentifier(id)
    if KitsTable[id] then
        for kitname, values in pairs(Kits) do
            if not KitsTable[id][kitname] then
                KitsTable[id][kitname] = 0
            end
        end
    else
        KitsTable[id] = {}
        for kitname, values in pairs(Kits) do
            KitsTable[id][kitname] = 0
        end

        MySQL.insert.await('INSERT INTO kits (identifier, data) VALUES (?, ?) ', {id, json.encode(KitsTable[id])})
    end
    return KitsTable[id]
end

local function UseKit(id, kit)
    if KitsTable[id][kit] <= os.time() then
        local xPlayer = ESX.GetPlayerFromIdentifier(id, true)
        for item, count in pairs(Kits[kit].items) do
            xPlayer.addInventoryItem(item, count)
        end

        KitsTable[id][kit] = os.time() + Kits[kit].delay

        MySQL.update.await('UPDATE kits SET data = ? WHERE identifier = ? ', {json.encode(KitsTable[id]), id})

        return true
    else
        return {false, KitsTable[id][kit]}
    end
end

function SplitId(string)
    local output
    for str in string.gmatch(string, '([^:]+)') do
        output = str
    end
    return output
end

ESX.RegisterCommand('kit', 'user', function(xPlayer, args, showError)
    if not collectingKit[xPlayer.source] then
        collectingKit[xPlayer.source] = true
        local identifier = SplitId(xPlayer.identifier)
        local ableKits = GetKitsByIdentifier(identifier)
        local playerGroup = xPlayer.getGroup()
        local premiumGroup = xPlayer.get('premiumgroup')
        for kitName, time in pairs(ableKits) do
            if Kits[kitName] and (Kits[kitName].groups[playerGroup] or Kits[kitName].groups[premiumGroup]) then
                local kitToLower = string.lower(args.kitname)
                if kitName == string.lower(kitToLower) then
                    local usedKit = UseKit(identifier, kitName)
                    if type(usedKit) == 'table' then
                        local timeLeft = os.date('%Y-%m-%d %H:%M:%S', usedKit[2])
                        xPlayer.showNotification('Zestaw niedostępny do '..timeLeft, 'error')
                    else
                        xPlayer.showNotification('Odebrano zestaw: '..kitName, 'success')
                        SendLogToDiscord('https://discord.com/api/webhooks/1053366556148637856/rVVkzi9wfrSuDpzXpudY6KEq-iFAfNaq6GIH4U_omwk-ENBKk6zbB2R3UVaM3emn1ZS8', 'Odebrano zestaw', 'ID: '..xPlayer.source..'\nNick: '..xPlayer.name..'\nLicencja: '..xPlayer.identifier..'\nPostać: '..xPlayer.get('firstName')..' '..xPlayer.get('lastName')..'\nZestaw: '..kitName, 5763719)
                    end
                    collectingKit[xPlayer.source] = nil
                    break
                else
                    collectingKit[xPlayer.source] = nil
                end
            else
                collectingKit[xPlayer.source] = nil
            end
        end
    end
end, false, {help = 'Odbierz zestaw', validate = true, arguments = {
	{name = 'kitname', help = 'Nazwa zestawu', type = 'string'}
}})