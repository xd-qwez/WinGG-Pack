local waitTime = Config['airdrops'].intervalBetweenAirdrops * 60000
local loc = nil
local looted = false

CreateThread(function()
	while true do
		Wait(waitTime)
		looted = false
		TriggerClientEvent("win-airdrops:client:clearStuff", -1)
		local randomloc = math.random(1, #Config['airdrops'].Locs)
		loc = Config['airdrops'].Locs[randomloc]  
		TriggerClientEvent("win-airdrops:client:startAirdrop", -1, loc)
	end
end)

RegisterNetEvent('win-airdrops:sendNotification', function(text)
	TriggerClientEvent('win:showNotification', -1, {
		title = 'Zrzuty',
		color = '110, 50, 170',
		icon = 'fa-solid fa-parachute-box',
		text = text
	})
end)

ESX.RegisterServerCallback('win-airdrops:server:getLootState', function(source, cb)
	cb(looted)
end)

RegisterNetEvent("win-airdrops:server:sync:loot", function(status)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if status == true then
		if string.find(xPlayer.job.name, 'org') then
			TriggerEvent('win-airdrops:sendNotification', 'Zrzut jest przejmowany przez ~y~'..xPlayer.name..' ['..xPlayer.job.label..']')
		else
			TriggerEvent('win-airdrops:sendNotification', 'Zrzut jest przejmowany przez ~y~'..xPlayer.name)
		end
	else
		TriggerEvent('win-airdrops:sendNotification', 'Zrzut przestał być przejmowany')
	end

	looted = status
end)

RegisterNetEvent("win-airdrops:server:getLoot", function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if not looted then return end
	
	if #(loc - GetEntityCoords(GetPlayerPed(src))) > 10 then 
		DropPlayer(src, "Ale z Ciebie Gagatek") 
		return 
	end

	for key, value in pairs(Config['airdrops'].Loot) do
		local number = math.random(1, 100)
		if number <= value.chance then
			xPlayer.addInventoryItem(key, value.count)
		end
	end

	if string.find(xPlayer.job.name, 'org') then
		TriggerEvent('win-airdrops:sendNotification', 'Zrzut został przejęty przez ~y~'..xPlayer.name..' ['..xPlayer.job.label..']')
	else
		TriggerEvent('win-airdrops:sendNotification', 'Zrzut został przejęty przez ~y~'..xPlayer.name)
	end

	Wait(5000)
	TriggerClientEvent("win-airdrops:client:clearStuff", -1)
end)

RegisterCommand("requestairdrop", function(source, args, rawCommand)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	looted = false
	if xPlayer.group == 'owner' or source == 0 then
		TriggerClientEvent("win-airdrops:client:clearStuff", -1)
		local randomloc = math.random(1, #Config['airdrops'].Locs)
		loc = Config['airdrops'].Locs[randomloc]    
		
		TriggerClientEvent("win-airdrops:client:startAirdrop", -1, loc)
	end
end)