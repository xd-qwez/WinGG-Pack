local isHudOpened = false

function OpenCarHud()
    SendNUIMessage({
        showhud = true
    })
end

function CloseCarHud()
    SendNUIMessage({
        showhud = false
    })
end

CreateThread(function()
    while true do
        if IsPedInAnyVehicle(PlayerPedId()) and not IsPauseMenuActive() and not exports['core']:ClearScreen() and not exports['core']:IsPauseActive() then
            SetUserRadioControlEnabled(false)
            if GetPlayerRadioStationName() ~= nil then
                SetVehRadioStation(GetVehiclePedIsIn(PlayerPedId()), "OFF")
            end
            DisplayRadar(true)
            local PedCar = GetVehiclePedIsUsing(PlayerPedId(), false)
            carSpeed = math.floor(GetEntitySpeed(PedCar) * 3.6)
            carMaxSpeed = math.ceil(GetVehicleEstimatedMaxSpeed(PedCar) * 3.6 + 0.5)
            carSpeedPercent = carSpeed / carMaxSpeed * 70

            if not isHudOpened then
                isHudOpened = true
            end

            SendNUIMessage({
                showhud = true,
                speed = carSpeed,
                rpmx = GetVehicleCurrentRpm(PedCar) * 100,
                percent = carSpeedPercent,
                gear = GetVehicleCurrentGear(PedCar),
                eHealth = GetVehicleEngineHealth(PedCar)
            })

            Wait(75)
        else
            DisplayRadar(false)
            if isHudOpened then
                SendNUIMessage({
                    showhud = false
                })

                isHudOpened = false
            end

            Wait(500)
        end 
    end
end)

local hash1, hash2
CreateThread(function() 
    while true do
        if isHudOpened then
            local ped, direction = PlayerPedId(), nil
            for k, v in pairs(Config['carhud'].Directions) do
                direction = GetEntityHeading(ped)
                if math.abs(direction - k) < 22.5 then
                    direction = v
                    break
                end
            end

            local coords = GetEntityCoords(ped, true)
            local zone = GetNameOfZone(coords.x, coords.y, coords.z)
            local zoneLabel = GetLabelText(zone)
            local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
            hash1 = GetStreetNameFromHashKey(var1)
            hash2 = GetStreetNameFromHashKey(var2)

            local street2
            if (hash2 == '') then
                street2 = zoneLabel
            else
                street2 = hash2..', '..zoneLabel
            end

            SendNUIMessage({
                street = street2,
                direction = (direction or 'N')
            })
        end

        Wait(500)
    end    
end)

exports('CloseCarHud', CloseCarHud)
exports('OpenCarHud', OpenCarHud)