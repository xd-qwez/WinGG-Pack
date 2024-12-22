local Vehicles = {}
local takeOutVehicles = {}

MySQL.ready(function()
    MySQL.query('SELECT * FROM owned_vehicles', {}, function(data)
        if data then
            for i = 1, #data do
                Vehicles[data[i].plate] = {
                    model = data[i].model,
                    owners = json.decode(data[i].owners),
                    tune = json.decode(data[i].tune),
                    health = json.decode(data[i].health),
                    color = json.decode(data[i].color),
                    inGarage = data[i].inGarage
                }
            end
        end
	end)
end)

local function UpdateVehiclesDB(plate)
    local vehicle = Vehicles[plate]
    MySQL.update.await("UPDATE owned_vehicles SET model = ?, owners = ?, tune = ?, health = ?, color = ?, inGarage = ? WHERE plate = ?", {vehicle.model, json.encode(vehicle.owners), json.encode(vehicle.tune), json.encode(vehicle.health), json.encode(vehicle.color), vehicle.inGarage, plate})
end

local function ApplyPropertiesToVehicle(plate, vehicle)

    SetVehicleColours(vehicle, type(Vehicles[plate].color.primary) == "number" and Vehicles[plate].color.primary or 0, type(Vehicles[plate].color.secondary) == "number" and Vehicles[plate].color.secondary or 0)
    if type(Vehicles[plate].color.primary) == "table" then
        SetVehicleCustomPrimaryColour(vehicle, Vehicles[plate].color.primary.r, Vehicles[plate].color.primary.g, Vehicles[plate].color.primary.b)
    end
    if type(Vehicles[plate].color.secondary) == "table" then
        SetVehicleCustomSecondaryColour(vehicle, Vehicles[plate].color.secondary.r, Vehicles[plate].color.secondary.g, Vehicles[plate].color.secondary.b)
    end

    SetVehicleNumberPlateText(vehicle, plate)
end

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

local function GetRandomNumber(length)
    Wait(0)
    if length > 0 then
        return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ''
    end
end

local function GetRandomLetter(length)
    Wait(0)
    if length > 0 then
        return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
    else
        return ''
    end
end

local function tuneChange(plate, value)
    Vehicles[plate].tune = value
    MySQL.update.await("UPDATE owned_vehicles SET tune = ? WHERE plate = ?", {json.encode(value), plate})
end

local function healthChange(plate, value)
    Vehicles[plate].health = value
    MySQL.update.await("UPDATE owned_vehicles SET health = ? WHERE plate = ?", {json.encode(value), plate})
end

local function colorChange(plate, value)
    Vehicles[plate].color = value
    MySQL.update.await("UPDATE owned_vehicles SET color = ? WHERE plate = ?", {json.encode(value), plate})
end

local vehiclePropertiesList = {
    ['tune'] = tuneChange,
    ['health'] = healthChange,
    ['color'] = colorChange,
}

for keyFilter, func in pairs(vehiclePropertiesList) do
    AddStateBagChangeHandler(keyFilter, nil, function(bagName, key, value)
        local bag = string.gsub(bagName, 'entity:', '')
        local vehicle = NetworkGetEntityFromNetworkId(tonumber(bag))
        if vehicle > 0 and DoesEntityExist(vehicle) then
            local plate = GetVehicleNumberPlateText(vehicle)
            local vehicleData = Vehicles[plate]
            if vehicleData then
                if type(value) == "table" then
                    for k, v in pairs(value) do
                        if v ~= vehicleData[keyFilter][k] then
                            func(plate, value)
                        end
                    end
                else
                    if vehicleData[keyFilter] ~= value then
                        func(plate, value)
                    end
                end
            end
        end
    end)
end

function CreateOneSyncVehicle(model, source, coords, giveKeys)
    local ped
    if source then
        ped = GetPlayerPed(source)
    end

    if not coords and ped then
        local preCoords = GetEntityCoords(ped)
        coords = vector4(preCoords.x, preCoords.y, preCoords.z, GetEntityHeading(ped))
    elseif not coords and not ped then
        print("Muncio ciuncio coś kurwa za mało dałeś")
        return
    end

    model = type(model) == 'string' and joaat(model) or model
    local vehicle = CreateVehicle(model, coords.xyz, coords.w, true, true)

    while not DoesEntityExist(vehicle) do
        Wait(50)
    end

    Wait(100)

    if ped then
        SetPedIntoVehicle(ped, vehicle, -1)
        if giveKeys then
            TriggerClientEvent("locksystem:giveTempKeys", source, GetVehicleNumberPlateText(vehicle))
        end
    end

    return vehicle
end

ESX.RegisterServerCallback('vehicles:createOneSyncVehicle', function(source, cb, model, coords, giveKeys)
    cb(NetworkGetNetworkIdFromEntity(CreateOneSyncVehicle(model, source, coords, giveKeys)))
end)

local function CreateOwnedVehicle(source, plate)
    local vehicle = CreateOneSyncVehicle(Vehicles[plate].model, source)
    ApplyPropertiesToVehicle(plate, vehicle)
    takeOutVehicles[plate] = vehicle
    for key, value in pairs(Vehicles[plate]) do
        Entity(vehicle).state:set(key, value, true)
    end
end

exports('CreateOneSyncVehicle', CreateOneSyncVehicle)

RegisterCommand('givecar', function(source, args, raw)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.group == 'admin' or xPlayer.group == 'superadmin' then
        if args[1] ~= nil and args[2] ~= nil then
            local xTarget = ESX.GetPlayerFromId(args[1])
            local plate = AddNewVehicleToGarage(xTarget.identifier, args[2], {inGarage = 1})
            TriggerClientEvent('esx:showNotification', src, 'Dodano pojazd o tablicach '..plate..' dla gracza '..xTarget.name..' ['..xTarget.source..']', 'success')
            TriggerClientEvent('esx:showNotification', xTarget.source, 'Administrator '..xPlayer.name..' dodał Ci pojazd o tablicach '..plate, 'success')
        end
    else
        TriggerClientEvent('esx:showNotification', src, 'Nie posiadasz permisji', 'error')
    end
end, false)

function AddNewVehicleToGarage(ownerIdentifier, model, data)
    local plate

    while true do
        plate = string.upper(GetRandomLetter(3)..' '..GetRandomNumber(4))
        if not Vehicles[plate] then
            break
        end
        Wait(0)
    end

    local vehicle = {
        model = model,
        owners = {[ownerIdentifier] = "owner"},
        tune = {},
        health = {
            body = 1000,
            engine = 1000,
            tank = 1000,
            dirt = 0,
            windowsBroken = {},
            doorsBroken = {},
            tyreBurst = {},
        },
        color = data.color or {},
        inGarage = data.inGarage and 1 or 0,
    }

    Vehicles[plate] = vehicle
    MySQL.insert.await('INSERT INTO owned_vehicles (plate, model, owners, tune, health, color, inGarage) VALUES (?, ?, ?, ?, ?, ?, ?) ', {plate, vehicle.model, json.encode(vehicle.owners), json.encode(vehicle.tune), json.encode(vehicle.health), json.encode(vehicle.color), vehicle.inGarage})

    return plate
end

ESX.RegisterServerCallback('garage:getVehicles', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    local vehicles = {}
    for plate, vehicle in pairs(Vehicles) do
        if vehicle.owners[xPlayer.identifier] then
            vehicles[#vehicles+1] = {model = vehicle.model, plate = plate, inGarage = vehicle.inGarage, ownerState = (vehicle.owners[xPlayer.identifier] == "owner"), health = vehicle.health}
        end
    end
    cb(vehicles)
end)

ESX.RegisterServerCallback('garage:getJobVehicles', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    local vehicles = {}
    for plate, vehicle in pairs(Vehicles) do
        if vehicle.owners[xPlayer.job.name] then
            vehicles[#vehicles+1] = {model = vehicle.model, plate = plate, inGarage = vehicle.inGarage, ownerState = false, health = vehicle.health}
        end
    end
    cb(vehicles)
end)

ESX.RegisterServerCallback('garage:getImpoundVehicles', function(source, cb)
    local impoundVehicles = {}
    for plate, vehicle in pairs(Vehicles) do
        if vehicle.inGarage == 2 then
            impoundVehicles[plate] = vehicle.model
        end
    end

    cb(impoundVehicles)
end)

ESX.RegisterServerCallback('garage:takeVehicle', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
    if Vehicles[plate] and not takeOutVehicles[plate] and (Vehicles[plate].inGarage == 1 and (Vehicles[plate].owners[xPlayer.identifier] or Vehicles[plate].owners[xPlayer.job.name])) or (Vehicles[plate].inGarage == 2 and xPlayer.job.name == 'police') then
        cb(true)
        Vehicles[plate].inGarage = 0
        UpdateVehiclesDB(plate)
        CreateOwnedVehicle(xPlayer.source, plate)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('garage:giveKeyForVehicle', function(source, cb, plate, tsource)
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(tsource)
	if Vehicles[plate] and Vehicles[plate].owners[xPlayer.identifier] == 'owner' then
        Vehicles[plate].owners[tPlayer.identifier] = 'co-owner'
        UpdateVehiclesDB(plate)
    else
        TriggerClientEvent('win:showNotification', source, {
            type = 'error',
            title = 'Garaże',
            text = "Nie możesz tego zrobić :/"
        })
    end
end)

ESX.RegisterServerCallback('garage:hideVehicle', function(source, cb, plate)
    if Vehicles[plate] and takeOutVehicles[plate] then

        DeleteEntity(takeOutVehicles[plate])

        Vehicles[plate].inGarage = 1
        UpdateVehiclesDB(plate)
        takeOutVehicles[plate] = nil

        cb()
    elseif Vehicles[plate] and not takeOutVehicles[plate] and Vehicles[plate].inGarage == 0 then

        DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(source), false))

        Vehicles[plate].inGarage = 1
        UpdateVehiclesDB(plate)
        takeOutVehicles[plate] = nil

        cb()
    else
        TriggerClientEvent('win:showNotification', source, {
            type = 'error',
            title = 'Garaż',
            text = "Nie możesz tego schować"
        })
    end
end)

ESX.RegisterServerCallback('garage:impoundVehicles', function(source, cb, plate)
    if takeOutVehicles[plate] and Vehicles[plate] and Vehicles[plate].inGarage == 0 then
        DeleteEntity(takeOutVehicles[plate])

        Vehicles[plate].inGarage = 2
        UpdateVehiclesDB(plate)
        takeOutVehicles[plate] = nil

        TriggerClientEvent('win:showNotification', source, {
            type = 'error',
            title = 'Garaż',
            text = "Odcholowałeś pojazd"
        })

        cb()
    else
        TriggerClientEvent('win:showNotification', source, {
            type = 'error',
            title = 'Garaż',
            text = "Odcholowałeś pojazd lokalny"
        })
        cb()
    end
end)


ESX.RegisterServerCallback('garage:towVehicle', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if Vehicles[plate] and Vehicles[plate].inGarage == 0 and (Vehicles[plate].owners[xPlayer.identifier] or Vehicles[plate].owners[xPlayer.job.name]) then
        local canTow = true

        if takeOutVehicles[plate] and DoesEntityExist(takeOutVehicles[plate]) then
            for seatIndex = -1, 16, 1 do
                local ped = GetPedInVehicleSeat(takeOutVehicles[plate], seatIndex)
                if ped and ped > 0 then
                    canTow = false
                end
            end
        end

        if canTow then
            if xPlayer.getAccount('money').money >= Config['garages'].towPrice then
                xPlayer.removeAccountMoney('money', Config['garages'].towPrice)

                if takeOutVehicles[plate] and DoesEntityExist(takeOutVehicles[plate]) then
                    DeleteEntity(takeOutVehicles[plate])
                end

                Vehicles[plate].inGarage = 1
                UpdateVehiclesDB(plate)
                takeOutVehicles[plate] = nil
                TriggerClientEvent('win:showNotification', source, {
                    type = 'success',
                    title = 'Garaż',
                    text = 'Pomyślnie odcholowano pojazd za  $'..Config['garages'].towPrice
                })
                cb(true)
            else
                TriggerClientEvent('win:showNotification', source, {
                    type = 'error',
                    title = 'Garaż',
                    text = 'Brakuje ci $'..Config['garages'].towPrice - xPlayer.getAccount('money').money..' do odholowania'
                })
                cb(false)
            end
        else
            TriggerClientEvent('win:showNotification', source, {
                type = 'error',
                title = 'Garaż',
                text = 'Nie możesz odholować pojazdu o tablicy: '..plate
            })
            cb(false)
        end
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('garage:towAllVehicle', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local overallPay = 0
    for plate, data in pairs(Vehicles) do
        if data.inGarage == 0 and data.owners[xPlayer.identifier] then
            local canTow = true

            if takeOutVehicles[plate] and DoesEntityExist(takeOutVehicles[plate]) then
                for seatIndex = -1, 16, 1 do
                    local ped = GetPedInVehicleSeat(takeOutVehicles[plate], seatIndex)
                    if ped and ped > 0 then
                        canTow = false
                    end
                end
            end

            if canTow then
                if xPlayer.getAccount('money').money >= Config['garages'].towPrice then
                    xPlayer.removeAccountMoney('money', Config['garages'].towPrice)

                    if takeOutVehicles[plate] and DoesEntityExist(takeOutVehicles[plate]) then
                        DeleteEntity(takeOutVehicles[plate])
                    end

                    Vehicles[plate].inGarage = 1
                    UpdateVehiclesDB(plate)
                    takeOutVehicles[plate] = nil
                    TriggerClientEvent('win:showNotification', source, {
                        type = 'success',
                        title = 'Garaż',
                        text = 'Pomyślnie odcholowano pojazd o tablicy: '..plate
                    })
                    overallPay = overallPay + Config['garages'].towPrice
                else
                    TriggerClientEvent('win:showNotification', source, {
                        type = 'error',
                        title = 'Garaż',
                        text = 'Brakuje ci $'..Config['garages'].towPrice - xPlayer.getAccount('money').money..' do odholowania'
                    })
                    break
                end
            else
                TriggerClientEvent('win:showNotification', source, {
                    type = 'error',
                    title = 'Garaż',
                    text = 'Nie możesz odholować pojazdu o tablicy: '..plate
                })
            end
        end
    end

    if overallPay > 0 then
        TriggerClientEvent('win:showNotification', source, {
            type = 'success',
            title = 'Garaż',
            text = 'Za wszystkie wyżej wymienione odcholowania zapłacono $'..overallPay
        })
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent("garage:syncAls", function(last)
    local src = source
    local veh = GetVehiclePedIsIn(GetPlayerPed(src), last or false)
    TriggerEvent('InteractSound_SV:PlayWithinDistance2', src, 35.0, 'vehiclePop'..math.random(12), 0.05)
    TriggerClientEvent("garage:syncAls", -1, NetworkGetNetworkIdFromEntity(veh))
end)

--============================================================================= VEHICLE SHOP ============================================================================--
ESX.RegisterServerCallback('vehicleShop:buyVehicle', function(source, cb, model, color)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price
    for category, vehicles in pairs(Config['vehicle-shop'].vehicles) do
        for index, values in ipairs(vehicles) do
            if values.model == model then
                price = values.price
            end
        end
    end

    if price and xPlayer.getAccount("money").money >= price then
        xPlayer.removeAccountMoney("money", price)
        local plate = AddNewVehicleToGarage(xPlayer.identifier, model, {color = color})
        CreateOwnedVehicle(xPlayer.source, plate)
    else
        print(GetPlayerName(xPlayer.source),'id: '..xPlayer.source, 'odjebał niezły numer w vehicle shopie')
    end
    cb()
end)

--============================================================================= LOCKSYSTEM ============================================================================--

local searchedCars = {}

ESX.RegisterServerCallback('locksystem:checkKeys', function(source, cb, plate)
	cb(Vehicles[plate] and Vehicles[plate].owners[ESX.GetPlayerFromId(source).identifier], not (Vehicles[plate] or searchedCars[plate]))
end)

ESX.RegisterServerCallback('locksystem:getAllPlayerKeys', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

    local vehicles = {}
    local coords = GetEntityCoords(GetPlayerPed(source))
    for _, vehicle in ipairs(GetAllVehicles()) do
        if DoesEntityExist(vehicle) then
            local plate = GetVehicleNumberPlateText(vehicle)
            if #(coords - GetEntityCoords(vehicle)) < 50 then
                vehicles[#vehicles+1] = {plate = plate, netVeh = NetworkGetNetworkIdFromEntity(vehicle), isOwned = Vehicles[plate] and Vehicles[plate].owners[xPlayer.identifier]}
            end
        end
    end

	cb(vehicles)
end)

RegisterNetEvent("locksystem:blockCarSearch", function(plate)
    searchedCars[plate] = true
end)

RegisterNetEvent("locksystem:giveTempKeys", function(tsrc, plate)
    local src = source

    if Vehicles[plate] then
        if Vehicles[plate].owners[ESX.GetPlayerFromId(src).identifier] == 'owner' then
            TriggerClientEvent('locksystem:giveTempKeys', tsrc, plate)
            TriggerClientEvent('win:showNotification', src, {
                type = 'info',
                title = 'System kluczyków',
                text = 'Przekazano kluczyki do ['..plate..'] id: '..tsrc
            })
        end
    else
        TriggerClientEvent('locksystem:giveTempKeys', tsrc, plate)
        TriggerClientEvent('win:showNotification', src, {
            type = 'info',
            title = 'System kluczyków',
            text = 'Przekazano kluczyki do ['..plate..'] id: '..tsrc
        })
    end
end)

--============================================================================= SELLCARS ============================================================================--
local sellSessions = {}

ESX.RegisterCommand('sprzedajpojazd', 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('sellvehicle:ask', args.playerId.source)
end, true, {help = 'Sprzedaj pojazd dla innego gracza', validate = true, arguments = {
    {name = 'playerId', help = 'ID gracza', type = 'player'}
}})

ESX.RegisterServerCallback('sellvehicle:send', function(source, cb, target, price, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

    if Vehicles[plate] and Vehicles[plate].owners[xPlayer.identifier] == "owner" then
        sellSessions[target] = {plate = plate, price = price, source = source}
        TriggerClientEvent('sellvehicle:ask_target', target, source, price, plate)
        xPlayer.showNotification('Wysłano ofertę sprzedaży za $'..price, 'success')
    else
        xPlayer.showNotification('To nie jest twój pojazd', 'error')
    end

	cb()
    CreateThread(function()
        Wait(60 * 1000)
        sellSessions[target] = nil
    end)
end)

ESX.RegisterServerCallback('sellvehicle:respond', function(source, cb, bool, sender, price, plate)
    if bool then
        local xPlayer = ESX.GetPlayerFromId(source)
        if sellSessions[source] then
            if sellSessions[source].plate == plate and sellSessions[source].price == price and sellSessions[source].source == sender then
                if xPlayer.getMoney() >= price then
                    xPlayer.removeMoney(price)
                    Vehicles[plate].owners = {[xPlayer.identifier] = 'owner'}
                    UpdateVehiclesDB(plate)
                    TriggerClientEvent('win:showNotification', source, {
                        type = 'success',
                        title = 'Garaże',
                        text = 'Pomyślnie zakupiono pojazd'
                    })
                    TriggerClientEvent('win:showNotification', sender, {
                        type = 'success',
                        title = 'Garaże',
                        text = 'Pomyślnie sprzedano pojazd'
                    })
                else
                    xPlayer.showNotification('Masz za mało pieniędzy', 'error')
                end
            else
                xPlayer.showNotification('Coś ty munciu ciunciu zmajstrował', 'error') -- mona tu export do bana wjebać tak profilaktycznie
            end
        else
            xPlayer.showNotification('Oferta sprzedaży wygasła', 'error')
        end
    elseif sellSessions[source] then
        sellSessions[source] = nil
    end
	cb()
end)


local addCarResponse = {}
ESX.RegisterCommand('addcar', {'admin'}, function(xPlayer, args, showError)
	args.playerId.triggerEvent('vehicles:onAddcarCommand', args.car, xPlayer.source)
	addCarResponse[args.playerId.source] = true
end, true, {help = 'Nadaj pojazd dla gracza', validate = true, arguments = {
    {name = 'playerId', help = 'ID gracza', type = 'player'},
	{name = 'car', help = 'Nazwa modelu', type = 'string'},
}})

RegisterNetEvent('vehicles:addCarResponse', function(model, sender)
	local xPlayer = ESX.GetPlayerFromId(source)
	if addCarResponse[xPlayer.source] then
        local xTarget = ESX.GetPlayerFromId(sender)
        LogCommands('addcar', xTarget, {
            playerId = xPlayer.source
        })
		local plate = AddNewVehicleToGarage(xPlayer.identifier, model, {})
        xTarget.showNotification('Nadano pojazd z rejestracja '..plate..' dla '..xPlayer.name..' ('..xPlayer.source..')', 'success')
        xPlayer.showNotification('Otrzymano pojazd z rejestracja '..plate, 'success')
		addCarResponse[xPlayer.source] = nil
	else
		exports['win-interiors']:banPlayer(xPlayer.source, 'winRP:addCarResponse', false, GetCurrentResourceName())
	end
end)

ESX.RegisterCommand('removecar', {'admin'}, function(xPlayer, args, showError)
	local plate = args.plate
    if Vehicles[plate] then
        xPlayer.showNotification('Usunięto pojazd o rejestracji '..plate..' i modelu '..Vehicles[plate].model, 'success')
        Vehicles[plate] = nil
        MySQL.update('DELETE FROM owned_vehicles WHERE plate = ?', {plate})
    else
        xPlayer.showNotification('Nie ma pojazdu o takiej rejestracji', 'error')
    end
end, true, {help = 'Usuń pojazd z bazy danych', validate = true, arguments = {
	{name = 'plate', help = 'Rejestracja (w znacznikach "")', type = 'string'},
}})