local dressignslimit = 30
local jobDressignslimit = 60

local sharedDressings = {}

Ignore = {
	'face', 'hair_1', 'hair_2', 'hair_3', 'hair_color_1', 'hair_color_2', 'eyebrows_1', 'eyebrows_2', 'eyebrows_3', 'eyebrows_4', 'beard_1','beard_2',
	'beard_3', 'beard_4', 'chest_1', 'chest_2', 'chest_3', 'makeup_1', 'makeup_2', 'makeup_3', 'makeup_4', 'blush_1', 'blush_2', 'blush_3',
	'lipstick_1', 'lipstick_2', 'lipstick_3', 'lipstick_4'
}

ESX.RegisterServerCallback('win-dressings:getPlayerDressing', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

	local dressignsLabels = {}
	for index,dressing in ipairs(xPlayer.get("dressigns")) do
		table.insert(dressignsLabels, dressing.label)
	end

	cb(dressignsLabels)
end)

ESX.RegisterServerCallback('win-dressings:getPlayerOutfit', function(source, cb, index)
	local xPlayer = ESX.GetPlayerFromId(source)

	local dressigns = xPlayer.get("dressigns")
	if not dressigns then dressigns = {} end 

	cb(dressigns[index].skin)
end)

RegisterServerEvent("win-dressings:saveOutfit")
AddEventHandler("win-dressings:saveOutfit", function(name, skin)
	local xPlayer = ESX.GetPlayerFromId(source)
	local count = 0
	
	local dressigns = xPlayer.get("dressigns")
	if not dressigns then dressigns = {} end

	for i=1, #dressigns, 1 do
		count = count + 1
	end

	totalcount = count+1

	if totalcount > dressignslimit then
        xPlayer.showNotification('Nie posiadasz miejsca w garderobie, aby zapisać ten strój', 'error')
		return
	end

	for index,ignore in ipairs(Ignore) do skin[ignore] = nil end
	table.insert(dressigns, { label = name, skin = skin })

	xPlayer.set("dressigns", dressigns)
	DBSave(xPlayer.identifier, dressigns)
end)

RegisterServerEvent('win-dressings:removeOutfit')
AddEventHandler('win-dressings:removeOutfit', function(index)
	local xPlayer = ESX.GetPlayerFromId(source)

	local dressigns = xPlayer.get("dressigns")
	if not dressigns then dressigns = {} end

	table.remove(dressigns, index)

	xPlayer.set("dressigns", dressigns)
	DBSave(xPlayer.identifier, dressigns)
end)

AddEventHandler("esx:playerLoaded", function(source, xPlayer)
	MySQL.Async.fetchAll("SELECT `dressigns` FROM `user_dressigns` WHERE `identifier` = @identifier LIMIT 1", {
		["@identifier"] = xPlayer.identifier
	}, function(result)
		if result and result[1] then
			xPlayer.set("dressigns", json.decode(result[1].dressigns))
		else
			xPlayer.set("dressigns", {})
		end
	end)
end)

DBSave = function(identifier, dressigns)
	MySQL.Async.execute("INSERT INTO `user_dressigns` (`identifier`, `dressigns`) VALUES (@identifier, @dressigns) ON DUPLICATE KEY UPDATE `dressigns` = @dressigns;", {
		["@identifier"] = identifier,
		["@dressigns"] = json.encode(dressigns)
	})
end

-- SHARED

MySQL.ready(function()
    MySQL.query('SELECT name, clothes FROM jobs', {}, function(data)
        if data then
            for i = 1, #data do
                sharedDressings[data[i].name] = json.decode(data[i].clothes)
            end
        end
	end)
end)

ESX.RegisterServerCallback('win-dressings:getSharedDressing', function(source, cb, job)
	local dressignsLabels = {}
	
	if sharedDressings[job] then
		for index,dressing in ipairs(sharedDressings[job]) do
			table.insert(dressignsLabels, dressing.label)
		end
	end

	cb(dressignsLabels)
end)

ESX.RegisterServerCallback('win-dressings:getSharedOutfit', function(source, cb, index, job)
	local dressigns = sharedDressings[job]
	if not dressigns then dressigns = {} end 

	cb(dressigns[index].skin)
end)

RegisterServerEvent("win-dressings:saveSharedOutfit")
AddEventHandler("win-dressings:saveSharedOutfit", function(name, skin, job)
	local xPlayer = ESX.GetPlayerFromId(source)
	local count = 1
	
	if not sharedDressings[job] then sharedDressings[job] = {} end

	for i=1, #sharedDressings[job], 1 do
		count = count + 1
	end

	if count > jobDressignslimit then
        xPlayer.showNotification('Nie posiadasz miejsca w garderobie, aby zapisać ten strój', 'error')
		return
	end

	for index,ignore in ipairs(Ignore) do skin[ignore] = nil end
	table.insert(sharedDressings[job], { label = name, skin = skin })
	MySQL.update.await('UPDATE jobs SET clothes = ? WHERE name = ? ', {json.encode(sharedDressings[job]), job})
end)

RegisterServerEvent('win-dressings:removeSharedOutfit')
AddEventHandler('win-dressings:removeSharedOutfit', function(index, job)
	if not sharedDressings[job] then sharedDressings[job] = {} end

	table.remove(sharedDressings[job], index)

	MySQL.update.await('UPDATE jobs SET clothes = ? WHERE name = ? ', {json.encode(sharedDressings[job]), job})
end)