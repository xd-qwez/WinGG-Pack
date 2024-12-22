local commandsWebhook = 'https://discord.com/api/webhooks/1042839422808358983/6laXvmSevH_RPOdjDnnU4lyhiGhnOhb8CRb2hkafD0HYom2eNIoXVpjxFQeCuKTYoiKe'

function LogCommands(command, xPlayer, args)
	local stringArgs = 'Brak'
	local argsCount = 0
	if args then
		for k, v in pairs(args) do
			argsCount = argsCount + 1
		end
	end
	if argsCount > 0 then
		stringArgs = json.encode(args)
	end
	if not xPlayer then
		xPlayer = {}
		xPlayer.name = 'CONSOLE'
		xPlayer.source = 'CONSOLE'
		xPlayer.identifier = 'CONSOLE'
	end
	SendLogToDiscord(commandsWebhook, '/'..command, '**'..xPlayer.name..'** użył komendy /'..command..'\nID: '..xPlayer.source..' | Licencja: '..xPlayer.identifier..'\nArgumenty: '..stringArgs, 15548997)
end

exports('LogCommands', LogCommands)

ESX.RegisterCommand("clearmap", 'mod', function(xPlayer, args, showError)
    local countCars, countObjects, countPeds = 0, 0, 0
    for index,vehicle in ipairs(GetAllVehicles()) do
        if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == 0 and GetPedInVehicleSeat(vehicle, 0) == 0 and GetPedInVehicleSeat(vehicle, 1) == 0 and GetPedInVehicleSeat(vehicle, 2) == 0 then
            DeleteEntity(vehicle)
            countCars += 1
        end
    end
    for index,object in ipairs(GetAllObjects()) do
        if DoesEntityExist(object) then
            DeleteEntity(object)
            countObjects += 1
        end
    end
    for index,ped in ipairs(GetAllPeds()) do
        if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
            DeleteEntity(ped)
            countPeds += 1
        end
    end
    if xPlayer then
        xPlayer.showNotification('Wyczyszczono mapę z ('..countCars..' pojazdów, '..countObjects..' obiektów, '..countPeds..' pedów)')
		LogCommands('clearmap', xPlayer)
    else
        print('[wingg.eu] Wyczyszczono mapę z ('..countCars..' pojazdów, '..countObjects..' obiektów, '..countPeds..' pedów)')
    end
end, true)

ESX.RegisterCommand("clearcars", 'mod', function(xPlayer, args, showError)
    local countCars = 0
    for index,vehicle in ipairs(GetAllVehicles()) do
        if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == 0 and GetPedInVehicleSeat(vehicle, 0) == 0 and GetPedInVehicleSeat(vehicle, 1) == 0 and GetPedInVehicleSeat(vehicle, 2) == 0 then
            DeleteEntity(vehicle)
            countCars += 1
        end
    end
    if xPlayer then
        xPlayer.showNotification('Wyczyszczono mapę z ('..countCars..' pojazdów)')
		LogCommands('clearcars', xPlayer)
    else
        print('[wingg.eu] Wyczyszczono mapę z ('..countCars..' pojazdów)')
    end
end, true)

ESX.RegisterCommand('fix', 'mod', function(xPlayer, args, showError)
	xPlayer.triggerEvent('win:onFixCommand')
	LogCommands('fix', xPlayer)
end, false)

local allowedGiveItems = {
	['handcuffs'] = true,
}

ESX.RegisterCommand("giveallitem", 'admin', function(xPlayer, args, showError)
	if allowedGiveItems[args.item] then
		local xPlayers = ESX.GetExtendedPlayers()
		for i=1, #(xPlayers) do 
			local xPlayer = xPlayers[i]
			xPlayer.addInventoryItem(args.item, args.count)
		end
		LogCommands('giveallitem', xPlayer, {
			item = args.item,
			count = args.count
		})
	else
		xPlayer.showNotification('Ten przedmiot nie jest na liście dozwolonych przedmiotów')
	end
end, false, {help = 'Daj przedmiot dla wszystkich graczy', validate = true, arguments = {
	{name = 'item', help = 'Przedmiot', type = 'string'},
	{name = 'count', help = 'Ilość', type = 'number'}
}})

ESX.RegisterCommand('revivedist', 'mod', function(xPlayer, args, showError)
	local maxDist = 500
    if args.distance then
        if args.distance <= maxDist then
            local adminCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
            for k, v in pairs(GetPlayers()) do
                local playerCoords = GetEntityCoords(GetPlayerPed(v))
                local distance = #(adminCoords - playerCoords)
                if distance < args.distance then
                    TriggerClientEvent('esx_ambulancejob:revive', v)
                end
            end
			LogCommands('revivedist', xPlayer, {
				distance = args.distance,
			})
        else
			xPlayer.showNotification('Maksymalna odległość wynosi: '..maxDist, 'error')
        end
    end
end, false, {help = 'Ożyw graczy w danym dystansie', validate = true, arguments = {
    {name = 'distance', help = 'Odległość', type = 'number'},
}})

ESX.RegisterCommand('heal', 'support', function(xPlayer, args, showError)
	if args.playerId then
		args.playerId.triggerEvent('win:onHealCommand')
		LogCommands('heal', xPlayer, {
			playerId = args.playerId.source
		})
	else
		xPlayer.triggerEvent('win:onHealCommand')
		LogCommands('heal', xPlayer)
	end
end, false, {help = 'Ulecz gracza lub siebie', validate = false, arguments = {
    {name = 'playerId', validate = false, help = 'ID gracza', type = 'player'},
}})

ESX.RegisterCommand('vanish', 'support', function(xPlayer, args, showError)
	xPlayer.triggerEvent('win:onVanishCommand')
	LogCommands('vanish', xPlayer)
end, false)

ESX.RegisterCommand('wezwij', 'helper', function(xPlayer, args, showError)
	args.playerId.triggerEvent('win:onRequestCommand', xPlayer and xPlayer.name or 'CONSOLE')
	local discordMention = GetSpecificIdentifier(args.playerId.source, 'discord'):gsub('discord:', '')
	local adminDiscordMention = xPlayer and GetSpecificIdentifier(xPlayer.source, 'discord'):gsub('discord:', '') or 'CONSOLE'
	PerformHttpRequest('https://discord.com/api/webhooks/1040985169512902678/_1ZDWdgVzsE5QwvxxkpWGzZO3jGdskv-dIMm0VrMIFKweDOZ28rJ-zQU74Uzaau-s4La', function(err, text, headers) end, 'POST', json.encode({content = '<@'..discordMention..'> - Administrator: <@'..adminDiscordMention..'> zaprasza Cię na poczekalnie ( ͡° ͜ʖ ͡°)'}), { ['Content-Type'] = 'application/json' })
	LogCommands('wezwij', xPlayer, {
		playerId = args.playerId.source
	})
end, true, {help = 'Wezwij gracza', validate = true, arguments = {
	{name = 'playerId', help = 'ID gracza', type = 'player'},
}})

ESX.RegisterCommand('sprawdzanie', 'helper', function(xPlayer, args, showError)
	args.playerId.triggerEvent('win:onRequestCommand', xPlayer and xPlayer.name or 'CONSOLE', true)
	local discordMention = GetSpecificIdentifier(args.playerId.source, 'discord'):gsub('discord:', '')
	local adminDiscordMention = xPlayer and GetSpecificIdentifier(xPlayer.source, 'discord'):gsub('discord:', '') or 'CONSOLE'
	PerformHttpRequest('https://discord.com/api/webhooks/1040985169512902678/_1ZDWdgVzsE5QwvxxkpWGzZO3jGdskv-dIMm0VrMIFKweDOZ28rJ-zQU74Uzaau-s4La', function(err, text, headers) end, 'POST', json.encode({content = '<@'..discordMention..'> - Administrator: <@'..adminDiscordMention..'> zaprasza Cię na sprawdzanie! Masz minutę! (QUIT = PERM)'}), { ['Content-Type'] = 'application/json' })
	LogCommands('sprawdzanie', xPlayer, {
		playerId = args.playerId.source
	})
end, true, {help = 'Wezwij gracza na sprawdzanie', validate = true, arguments = {
    {name = 'playerId', help = 'ID gracza', type = 'player'},
}})

ESX.RegisterCommand('kick', 'helper', function(xPlayer, args, showError)
	DropPlayer(args.playerId.source, xPlayer.name..' wyrzucił Cię z serwera! Powód: '..args.reason)
	LogCommands('kick', xPlayer, {
		playerId = args.playerId.source,
		reason = args.reason
	})
end, false, {help = 'Wyrzuć gracza', validate = true, arguments = {
    {name = 'playerId', help = 'ID gracza', type = 'player'},
	{name = 'reason', help = 'Powód -> użyj cudzysłowia', type = 'string'},
}})

local addCarResponse = {}

ESX.RegisterCommand('addcar', {'admin'}, function(xPlayer, args, showError)
	args.playerId.triggerEvent('win:onAddcarCommand', args.car, xPlayer.source)
	addCarResponse[args.playerId.source] = true
	LogCommands('addcar', xPlayer, {
		playerId = args.playerId.source,
		car = args.car
	})
end, true, {help = 'Nadaj pojazd dla gracza', validate = true, arguments = {
    {name = 'playerId', help = 'ID gracza', type = 'player'},
	{name = 'car', help = 'Nazwa modelu', type = 'string'},
}})

RegisterServerEvent('win:addCarResponse')
AddEventHandler('win:addCarResponse', function(plate, model, sender)
	local xPlayer = ESX.GetPlayerFromId(source)
	if addCarResponse[xPlayer.source] then
		local xTarget = ESX.GetPlayerFromId(sender)
		MySQL.insert('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (?, ?, ?)', {xPlayer.identifier, plate, json.encode({model = model, plate = plate})
		}, function(rowsChanged)
			xTarget.showNotification('Nadano pojazd z rejestracja '..plate..' dla '..xPlayer.name..' ('..xPlayer.source..')', 'success')
			xPlayer.showNotification('Otrzymano pojazd z rejestracja '..plate, 'success')
		end)
		addCarResponse[xPlayer.source] = nil
	else
		exports['win-interiors']:banPlayer(xPlayer.source, 'win:addCarResponse', false, GetCurrentResourceName())
	end
end)

ESX.RegisterCommand('removecar', {'admin'}, function(xPlayer, args, showError)
	local plate = args.plate:gsub("%-", " ")
	local deletedResults = 0
	MySQL.query('SELECT plate FROM owned_vehicles WHERE plate = ?', {plate}, function(data)
        if data then
			for k, v in pairs(data) do
				deletedResults = deletedResults + 1
				MySQL.update('DELETE FROM owned_vehicles WHERE plate = ?', {v.plate})
			end
			if xPlayer then
				xPlayer.showNotification('Usunięto: '..deletedResults..' rekordów ('..plate..')', 'success')
			else
				print('Usunięto: '..deletedResults..' rekordów ('..plate..')')
			end
        end
	end)
end, true, {help = 'Usuń pojazd z bazy danych', validate = true, arguments = {
	{name = 'plate', help = 'Rejestracja (spacje zastąp "-")', type = 'string'},
}})

ESX.RegisterCommand('setped', {'admin'}, function(xPlayer, args, showError)
	args.playerId.triggerEvent('win:onSetpedCommand', args.ped)
	LogCommands('setped', xPlayer, {
		playerId = args.playerId.source,
		ped = args.ped
	})
end, true, {help = 'Nadaj peda dla gracza', validate = true, arguments = {
    {name = 'playerId', help = 'ID gracza', type = 'player'},
	{name = 'ped', help = 'Nazwa modelu', type = 'string'},
}})

ESX.RegisterCommand('changegroup', 'admin', function(xPlayer, args, showError)
	if string.len(args.license) == 40 then
		MySQL.query('SELECT identifier FROM users WHERE identifier LIKE \'%' .. args.license .. '\'', {}, function(data)
			if data and data[1] then
				for k, v in pairs(data) do
					MySQL.update('UPDATE users SET `group` = ? WHERE identifier = ?', {args.group, v.identifier})
				end
				if xPlayer then
					xPlayer.showNotification('Pomyślnie zmieniono rangę', 'success')
				else
					print('Pomyślnie zmieniono rangę')
				end
				LogCommands('changegroup', xPlayer, {
					license = args.license,
					group = args.group
				})
			else
				if xPlayer then
					xPlayer.showNotification('Nie znaleziono licencji w bazie danych', 'error')
				else
					print('Nie znaleziono licencji w bazie danych')
				end
			end
		end)
	else
		if xPlayer then
			xPlayer.showNotification('Nieprawidłowa licencja', 'error')
		else
			print('Nieprawidłowa licencja')
		end
	end
end, true, {help = 'Zmień grupę gracza (po licencji)', validate = true, arguments = {
	{name = 'license', help = 'Licencja', type = 'string'},
	{name = 'group', help = 'Nazwa grupy', type = 'string'},
}})

ESX.RegisterCommand('jobinfo', 'helper', function(xPlayer, args, showError)
    MySQL.query('SELECT job, job_grade FROM users WHERE identifier = @identifier', {
		['@identifier'] = args.license
	}, function(data)
		if data and data[1] then
            if xPlayer then
                xPlayer.showNotification(args.license..' | job: '..data[1].job..' | grade: '..data[1].job_grade, 'info')
            else
                print(args.license..' | job: '..data[1].job..' | grade: '..data[1].job_grade)
            end
        else
            if xPlayer then
                xPlayer.showNotification('Nie znaleziono gracza z taką licencją', 'error')
            else
                print('Nie znaleziono gracza z taką licencją')
            end
		end
	end)
end, true, {help = 'Sprawdź nazwę joba po licencji', validate = true, arguments = {
	{name = 'license', help = 'Licencja (z char:)', type = 'string'}
}})

ESX.RegisterServerCallback('win:requestPlayerStatus', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.query('SELECT status FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(data)
		if data and data[1] then
			cb(json.decode(data[1].status))
		end
	end)
end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
	local steam = GetSpecificIdentifier(xPlayer.source, 'steam')
	local discord = GetSpecificIdentifier(xPlayer.source, 'discord')
	local xbl = GetSpecificIdentifier(xPlayer.source, 'xbl')
	local live = GetSpecificIdentifier(xPlayer.source, 'live')
	local discordmention = discord:gsub('discord:', '')
	local character = xPlayer.get('firstName') .. ' ' .. xPlayer.get('lastName')
	SendLogToDiscord('https://discord.com/api/webhooks/1027405350653136938/lwB4DdE4AYbp1Q-boE8y2xVWlwGrd7Ze6itg_fua-thXtCCL1xV-yt9C21iUdOVmdG5s', 'Connect', xPlayer.name..' wchodzi na serwer\nID: '..xPlayer.source..'\nLicencja: '..xPlayer.identifier..'\nHex: '..steam..'\nDiscord: <@'..discordmention..'> - '..discord..'\nXbl: '..xbl..'\nLive: '..live..'\nPostać: '..character, 5763719)
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	local steam = GetSpecificIdentifier(xPlayer.source, 'steam')
	local discord = GetSpecificIdentifier(xPlayer.source, 'discord')
	local xbl = GetSpecificIdentifier(xPlayer.source, 'xbl')
	local live = GetSpecificIdentifier(xPlayer.source, 'live')
	local discordmention = discord:gsub('discord:', '')
	local character = xPlayer.get('firstName') .. ' ' .. xPlayer.get('lastName')
	SendLogToDiscord('https://discord.com/api/webhooks/1027405350653136938/lwB4DdE4AYbp1Q-boE8y2xVWlwGrd7Ze6itg_fua-thXtCCL1xV-yt9C21iUdOVmdG5s', 'Disconnect', xPlayer.name..' wychodzi z serwera\nID: '..xPlayer.source..'\nLicencja: '..xPlayer.identifier..'\nHex: '..steam..'\nDiscord: <@'..discordmention..'> - '..discord..'\nXbl: '..xbl..'\nLive: '..live..'\nPostać: '..character..'\nPowód: '..reason, 15548997)

	local data = {
		health = Player(xPlayer.source).state.health,
		armor = Player(xPlayer.source).state.armor
	}

	MySQL.update.await('UPDATE users SET status = ? WHERE identifier = ?', {json.encode(data), xPlayer.identifier})
end)

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)

    local WeaponNames = {
		[`WEAPON_UNARMED`] = 'bez broni',
		[`WEAPON_KNIFE`] = 'noz',
		[`WEAPON_NIGHTSTICK`] = 'palka policyjna',
		[`WEAPON_HAMMER`] = 'mlotek',
		[`WEAPON_BAT`] = 'kij do baseballa',
		[`WEAPON_GOLFCLUB`] = 'kij golfowy',
		[`WEAPON_CROWBAR`] = 'lom',
		[`WEAPON_PISTOL`] = 'pistolet',
		[`WEAPON_PISTOL_MK2`] = 'pistolet mk2',
		[`WEAPON_COMBATPISTOL`] = 'pistolet bojowy',
		[`WEAPON_APPISTOL`] = 'Pistolet przeciwpancerny',
		[`WEAPON_PISTOL50`] = 'Pistolet .50',
		[`WEAPON_MICROSMG`] = 'Micro SMG',
		[`WEAPON_SMG`] = 'SMG',
		[`WEAPON_ASSAULTSMG`] = 'Szturmowe SMG',
		[`WEAPON_ASSAULTRIFLE`] = 'AK-47',
		[`WEAPON_CARBINERIFLE`] = 'm4',
		[`WEAPON_ADVANCEDRIFLE`] = 'Zaawansowany karabin',
		[`WEAPON_MG`] = 'Karabin maszynowy',
		[`WEAPON_COMBATMG`] = 'Bojowy karabin maszynowy',
		[`WEAPON_PUMPSHOTGUN`] = 'strzelba pompowa',
		[`WEAPON_SAWNOFFSHOTGUN`] = 'obrzym',
		[`WEAPON_ASSAULTSHOTGUN`] = 'strzelba szturmowa',
		[`WEAPON_BULLPUPSHOTGUN`] = 'Strzelba bezkolbowa',
		[`WEAPON_STUNGUN`] = 'Paralizator',
		[`WEAPON_SNIPERRIFLE`] = 'Karabin Snajperski',
		[`WEAPON_HEAVYSNIPER`] = 'Ciężki karabin snajperski',
		[`WEAPON_REMOTESNIPER`] = 'Remote Sniper',
		[`WEAPON_GRENADELAUNCHER`] = 'Granatnik',
		[`WEAPON_GRENADELAUNCHER_SMOKE`] = 'Granatnik',
		[`WEAPON_RPG`] = 'RPG',
		[`WEAPON_PASSENGER_ROCKET`] = 'Passenger Rocket',
		[`WEAPON_AIRSTRIKE_ROCKET`] = 'Nalot rakietowy',
		[`WEAPON_STINGER`] = 'Stinger [Vehicle]',
		[`WEAPON_MINIGUN`] = 'Minigun',
		[`WEAPON_GRENADE`] = 'Granat',
		[`WEAPON_STICKYBOMB`] = 'Bomba przylepna',
		[`WEAPON_SMOKEGRENADE`] = 'Gaz lzawiacy',
		[`WEAPON_BZGAS`] = 'Gaz bojowy',
		[`WEAPON_MOLOTOV`] = 'Molotov',
		[`WEAPON_FIREEXTINGUISHER`] = 'Gasnica',
		[`WEAPON_PETROLCAN`] = 'Jerry Can',
		[`OBJECT`] = 'Obiekt',
		[`WEAPON_BALL`] = 'Pilka',
		[`WEAPON_FLARE`] = 'Flara',
		[`VEHICLE_WEAPON_TANK`] = 'Czolg',
		[`VEHICLE_WEAPON_SPACE_ROCKET`] = 'Rakieta Kosmiczna',
		[`VEHICLE_WEAPON_PLAYER_LASER`] = 'Laser',
		[`AMMO_RPG`] = 'Rakieta',
		[`AMMO_TANK`] = 'Czolg',
		[`AMMO_SPACE_ROCKET`] = 'Rakieta Kosmiczna',
		[`AMMO_PLAYER_LASER`] = 'Laser',
		[`AMMO_ENEMY_LASER`] = 'Laser',
		[`WEAPON_RAMMED_BY_CAR`] = 'Staranowany przez samochód',
		[`WEAPON_BOTTLE`] = 'Butelka',
		[`WEAPON_GUSENBERG`] = 'Gusenberg',
		[`WEAPON_SNSPISTOL`] = 'Pukawka',
		[`WEAPON_SNSPISTOL_MK2`] = 'Pukawka MK2',
		[`WEAPON_CERAMICPISTOL`] = 'Pistolet Ceramiczny',
		[`WEAPON_VINTAGEPISTOL`] = 'Pistolet Vintage',
		[`WEAPON_DAGGER`] = 'Zabytkowy sztylet',
		[`WEAPON_FLAREGUN`] = 'Pistolet sygnałowy',
		[`WEAPON_HEAVYPISTOL`] = 'Ciezki pistolet',
		[`WEAPON_SPECIALCARBINE`] = 'Karabinek specjalnyk',
		[`WEAPON_MUSKET`] = 'Muszkiet',
		[`WEAPON_FIREWORK`] = 'Wyrzutnia fajerwerkow',
		[`WEAPON_MARKSMANRIFLE`] = 'Karabin wyborowy',
		[`WEAPON_HEAVYSHOTGUN`] = 'Ciezka strzelba',
		[`WEAPON_PROXMINE`] = 'Mina zbliżeniowa',
		[`WEAPON_HOMINGLAUNCHER`] = 'Wyrzutnia namierzająca',
		[`WEAPON_HATCHET`] = 'Topor',
		[`WEAPON_COMBATPDW`] = 'PDW',
		[`WEAPON_KNUCKLE`] = 'Kastety',
		[`WEAPON_MARKSMANPISTOL`] = 'Pistolet wyborowy',
		[`WEAPON_MACHETE`] = 'Maczeta',
		[`WEAPON_MACHINEPISTOL`] = 'Pistolet maszynowy',
		[`WEAPON_FLASHLIGHT`] = 'Latarka',
		[`WEAPON_DBSHOTGUN`] = 'Dwururka',
		[`WEAPON_COMPACTRIFLE`] = 'Karabin kompaktowy',
		[`WEAPON_SWITCHBLADE`] = 'Noz sprezynowy',
		[`WEAPON_REVOLVER`] = 'Ciężki rewolwer',
		[`WEAPON_FIRE`] = 'Ogien',
		[`WEAPON_HELI_CRASH`] = 'Helikopter',
		[`WEAPON_RUN_OVER_BY_CAR`] = 'Przejechany przez samochod',
		[`WEAPON_HIT_BY_WATER_CANNON`] = 'Trafiony armatka wodna',
		[`WEAPON_EXHAUSTION`] = 'wyczerpanie',
		[`WEAPON_EXPLOSION`] = 'wybuch',
		[`WEAPON_ELECTRIC_FENCE`] = 'Elektryczne ogrodzenie',
		[`WEAPON_BLEEDING`] = 'wykrwawienie',
		[`WEAPON_DROWNING_IN_VEHICLE`] = 'Utoniecie w pojezdzie',
		[`WEAPON_DROWNING`] = 'Utoniecie',
		[`WEAPON_BARBED_WIRE`] = 'Drut kolczasty',
		[`WEAPON_VEHICLE_ROCKET`] = 'Rakieta z samochodu',
		[`WEAPON_BULLPUPRIFLE`] = 'Karabin bezkolbowy',
		[`WEAPON_ASSAULTSNIPER`] = 'Assault Sniper',
		[`VEHICLE_WEAPON_ROTORS`] = 'Rotors',
		[`WEAPON_RAILGUN`] = 'Railgun',
		[`WEAPON_AIR_DEFENCE_GUN`] = 'Air Defence Gun',
		[`WEAPON_AUTOSHOTGUN`] = 'Strzelba automatyczna',
		[`WEAPON_BATTLEAXE`] = 'topor',
		[`WEAPON_COMPACTLAUNCHER`] = 'Granatnik kompaktowy',
		[`WEAPON_MINISMG`] = 'Mini SMG',
		[`WEAPON_PIPEBOMB`] = 'Rurobomba',
		[`WEAPON_POOLCUE`] = 'Kij bilardowy',
		[`WEAPON_WRENCH`] = 'Klucz francuski',
		[`WEAPON_SNOWBALL`] = 'Sniezka',
		[`WEAPON_ANIMAL`] = 'Zwierze',
		[`WEAPON_COUGAR`] = 'Puma'
	}

    local Weapon = (WeaponNames[data.deathCause] or 'Nieznany powód')

    if data.killedByPlayer then
		local xTarget = ESX.GetPlayerFromId(data.killerServerId)
        SendLogToDiscord('https://discord.com/api/webhooks/1027210233304592536/Qw3sxaI53gVrP0KYMx6nAqYpXVuptrWv6SsicVzzDBzpGE4ilU82EM8PG74VoBC7pYn5', 'Nowa śmierć', xTarget.name .. '\n(ID: '..xTarget.source..', Licencja: '..xTarget.identifier..')\n**ZABIŁ**\n' .. xPlayer.name .. '\n(ID: '..xPlayer.source..', Licencja: '..xPlayer.identifier..')\nDystans: ' .. data.distance .. 'm\nBroń: ' .. Weapon, 15548997)
		SendLogToDiscord('https://discord.com/api/webhooks/1066193518428700733/eiemuux4xktO52a2a0QpXtkEytJjjFkyQlI6DEM-ZjO9Z15ZQ9CxxWmd6QGQ2PTaGENH', 'Nowa śmierć', xTarget.name .. '\n(ID: '..xTarget.source..', Licencja: '..xTarget.identifier..')\n**ZABIŁ**\n' .. xPlayer.name .. '\n(ID: '..xPlayer.source..', Licencja: '..xPlayer.identifier..')\nDystans: ' .. data.distance .. 'm\nBroń: ' .. Weapon, 15548997)
		if data.distance > 107 then
			SendLogToDiscord('https://discord.com/api/webhooks/1052615056069755031/tEQGBwIEFWtP1roDnnnQUpnXtCFxyRP3AVZvY2k2yXbA8jgP2S5HX24GyfOoCO6ax8bA', 'Nowa śmierć', xTarget.name .. '\n(ID: '..xTarget.source..', Licencja: '..xTarget.identifier..')\n**ZABIŁ**\n' .. xPlayer.name .. '\n(ID: '..xPlayer.source..', Licencja: '..xPlayer.identifier..')\nDystans: ' .. data.distance .. 'm\nBroń: ' .. Weapon, 15548997)
		end
    else
        SendLogToDiscord('https://discord.com/api/webhooks/1027210233304592536/Qw3sxaI53gVrP0KYMx6nAqYpXVuptrWv6SsicVzzDBzpGE4ilU82EM8PG74VoBC7pYn5', 'Nowa śmierć', 'ID: '..xPlayer.source..'\nNICK: '..xPlayer.name .. '\nLicencja: '..xPlayer.identifier..'\nPowód śmierci - ['..Weapon..']', 15548997)
    end
end)

GetSpecificIdentifier = function(playerId, identifier)
	local identifiers = GetPlayerIdentifiers(playerId)
	for i=1, #identifiers do
		if identifiers[i]:match(identifier) then
			return identifiers[i]
		end
	end
	return "Nie wykryto identyfikatora: "..identifier
end

WhiteListedEntities = {}
local wlModel = {
	[`metrotrain`] = true,
	[`tankercar`] = true,
	[`freightgrain`] = true,
	[`freightcont2`] = true,
	[`freightcont1`] = true,
	[`freightcar`] = true,
	[`freight`] = true,
	[`titan`] = true
}

local function clearCars()
	CreateThread(function()
		TriggerClientEvent('win:showNotification', -1, {
			type = 'info',
			duration = 5000,
			title = 'CZYSZCZENIE POJAZDÓW',
			text = 'Puste pojazdy zostaną usunięte za minutę'
		})
		Wait(50000)
		TriggerClientEvent('win:showNotification', -1, {
			type = 'info',
			duration = 10000,
			title = 'CZYSZCZENIE POJAZDÓW',
			text = 'Puste pojazdy zostaną usunięte za 10 sekund'
		})
		Wait(10000)
		for index, vehicle in ipairs(GetAllVehicles()) do
			if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == 0 and GetPedInVehicleSeat(vehicle, 0) == 0 and GetPedInVehicleSeat(vehicle, 1) == 0 and GetPedInVehicleSeat(vehicle, 2) == 0 and not WhiteListedEntities[vehicle] and not wlModel[GetEntityModel(vehicle)] then
				DeleteEntity(vehicle)
			end
		end
		for index, object in ipairs(GetAllObjects()) do
			if DoesEntityExist(object) and not WhiteListedEntities[object] then
				DeleteEntity(object)
			end
		end
		TriggerClientEvent('win:showNotification', -1, {
			type = 'success',
			duration = 5000,
			title = 'CZYSZCZENIE POJAZDÓW',
			text = 'Pomyślnie wyczyszczono puste pojazdy'
		})
	end)
end

CreateThread(function()
	while true do
		local m = os.date('%M')
		if (m % 30 == 0) then
			clearCars()
		end
		Wait(60000)
	end
end)

--[[[local trains = {}

AddEventHandler("entityCreated", function(entity)
	if DoesEntityExist(entity) and GetEntityModel(entity) == `freight` then
		trains[entity] = true
	end
end)

AddEventHandler("entityRemoved", function(entity)
	if trains[entity] then
		trains[entity] = nil
	end
end)

CreateThread(function ()
	while true do
		local netEntity = {}
		for entity, _ in pairs(trains) do
			if DoesEntityExist(entity) then
				netEntity[#netEntity+1] = {netId = NetworkGetNetworkIdFromEntity(entity), coords = GetEntityCoords(entity)}
			else
				trains[entity] = nil
			end
		end
		TriggerClientEvent("win:trainBlip", -1, netEntity)
		Wait(500)
	end
end)]]

ESX.RegisterServerCallback('win:requestCarSpawn', function(source, cb, model, coords, heading)
	local vehicle = CreateVehicle(model, coords, heading, true, true)

    while not DoesEntityExist(vehicle) do
        Wait(50)
    end

	while GetVehiclePedIsIn(GetPlayerPed(source), false) ~= vehicle do
        SetPedIntoVehicle(GetPlayerPed(source), vehicle, -1)
		Wait(100)
    end

	cb(NetworkGetNetworkIdFromEntity(vehicle))
end)

local maxMonitorTime = 300

ESX.RegisterCommand('monitor', 'support', function(xPlayer, args, showError)
	if args.time > maxMonitorTime then
		if xPlayer then
			xPlayer.showNotification('Maksymalny czas nagrania wynosi '..ESX.Math.Round(maxMonitorTime/60)..' minut', 'error')
		else
			print('Maksymalny czas nagrania wynosi '..ESX.Math.Round(maxMonitorTime/60)..' minut')
		end
	else
		TriggerEvent('win:inspekcjaGagatka', args.playerId.source, args.type, args.time * 1000, 4)
	end
end, true, {help = 'Monitoruj gracza (nagranie/ss)', validate = true, arguments = {
	{name = 'playerId', help = 'ID gracza', type = 'player'},
	{name = 'type', help = 'video/image', type = 'string'},
	{name = 'time', help = 'Czas w sekundach', type = 'number'},
}})

AddEventHandler('weaponDamageEvent', function(source, data)
	if data.weaponType == 911657153 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer and xPlayer.job.name ~= 'police' then
			local item = xPlayer.getInventoryItem('stungun')
			if item and item.count > 0 then
				xPlayer.removeInventoryItem('stungun', item.count)
				CancelEvent()
			end
		end
	end
end)

RegisterCommand('lepszegranie', function(source)
	TriggerClientEvent('InteractSound_CL:PlayOnOne', source, 'wtsk', 1.0)
end)