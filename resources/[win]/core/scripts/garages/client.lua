RegisterNetEvent("garage:syncAls", function(netVehicle)
    if NetworkDoesNetworkIdExist(netVehicle) and NetToVeh(netVehicle) ~= GetVehiclePedIsIn(PlayerPedId(), false) then
        CreateVehicleExhaustBackfire(NetToVeh(netVehicle), 1.30)
    end
end)


--============================================================================= GARAGE FUNCTIONS ============================================================================--

RegisterNetEvent('vehicles:onAddcarCommand', function(model, player)
    if IsModelInCdimage(joaat(model)) then
        TriggerServerEvent('vehicles:addCarResponse', model, player)
    end
end)

local function tuneApply(vehicle, tune)
    SetVehicleModKit(vehicle, 0)

    SetVehicleWheelType(vehicle, tune.wheels or 0)

    SetVehicleWindowTint(vehicle, tune.windowTint or 0)
    SetVehicleNumberPlateTextIndex(vehicle, tune.plateIndex or 0)

    if tune.extras then
        for extraIndex, bool in pairs(tune.extras) do
            SetVehicleExtra(vehicle, extraIndex, not bool)
        end
    end

    if tune.modAddonTurbo then
        ToggleVehicleMod(vehicle, 18, true)
    end


    SetVehicleMod(vehicle, 0, tune.modSpoilers or -1, false)
    SetVehicleMod(vehicle, 1, tune.modFrontBumper or -1, false)
    SetVehicleMod(vehicle, 2, tune.modRearBumper or -1, false)
    SetVehicleMod(vehicle, 3, tune.modSideSkirt or -1, false)
    SetVehicleMod(vehicle, 4, tune.modExhaust or -1, false)
    SetVehicleMod(vehicle, 5, tune.modFrame or -1, false)
    SetVehicleMod(vehicle, 6, tune.modGrille or -1, false)
    SetVehicleMod(vehicle, 7, tune.modHood or -1, false)
    SetVehicleMod(vehicle, 8, tune.modFender or -1, false)
    SetVehicleMod(vehicle, 9, tune.modRightFender or -1, false)
    SetVehicleMod(vehicle, 10, tune.modRoof or -1, false)

    if tune.modAddonEngine then
        local modIndex = #tune.modAddonEngine - 1
        if modIndex > (GetNumVehicleMods(vehicle, 11) - 2) then
            modIndex = GetNumVehicleMods(vehicle, 11) - 2
        end
        SetVehicleMod(vehicle, 11, modIndex, false)
    end
    if tune.modAddonBrakes then
        local modIndex = #tune.modAddonBrakes - 1
        if modIndex > (GetNumVehicleMods(vehicle, 12) - 2) then
            modIndex = GetNumVehicleMods(vehicle, 12) - 2
        end
        SetVehicleMod(vehicle, 12, modIndex, false)
    end
    if tune.modAddonTransmission then
        local modIndex = #tune.modAddonTransmission - 1
        if modIndex > (GetNumVehicleMods(vehicle, 13) - 2) then
            modIndex = GetNumVehicleMods(vehicle, 13) - 2
        end
        SetVehicleMod(vehicle, 13, tune.modBrakes, false)
    end

    SetVehicleMod(vehicle, 14, tune.modHorns or -1, false)
    SetVehicleMod(vehicle, 15, tune.modSuspension or -1, false)
    SetVehicleMod(vehicle, 16, tune.modArmor or -1, false)
    SetVehicleMod(vehicle, 23, tune.modFrontWheels or -1, false)
    SetVehicleMod(vehicle, 24, tune.modBackWheels or -1, false)
    SetVehicleMod(vehicle, 25, tune.modPlateHolder or -1, false)
    SetVehicleMod(vehicle, 26, tune.modVanityPlate or -1, false)
    SetVehicleMod(vehicle, 27, tune.modTrimA or -1, false)
    SetVehicleMod(vehicle, 28, tune.modOrnaments or -1, false)
    SetVehicleMod(vehicle, 29, tune.modDashboard or -1, false)
    SetVehicleMod(vehicle, 30, tune.modDial or -1, false)
    SetVehicleMod(vehicle, 31, tune.modDoorSpeaker or -1, false)
    SetVehicleMod(vehicle, 32, tune.modSeats or -1, false)
    SetVehicleMod(vehicle, 33, tune.modSteeringWheel or -1, false) 
    SetVehicleMod(vehicle, 34, tune.modShifterLeavers or -1, false)
    SetVehicleMod(vehicle, 35, tune.modAPlate or -1, false) 
    SetVehicleMod(vehicle, 36, tune.modSpeakers or -1, false)  
    SetVehicleMod(vehicle, 37, tune.modTrunk or -1, false)
    SetVehicleMod(vehicle, 38, tune.modHydrolic or -1, false)
    SetVehicleMod(vehicle, 39, tune.modEngineBlock or -1, false)
    SetVehicleMod(vehicle, 40, tune.modAirFilter or -1, false)
    SetVehicleMod(vehicle, 41, tune.modStruts or -1, false)
    SetVehicleMod(vehicle, 42, tune.modArchCover or -1, false)
    SetVehicleMod(vehicle, 43, tune.modAerials or -1, false)
    SetVehicleMod(vehicle, 44, tune.modTrimB or -1, false)
    SetVehicleMod(vehicle, 45, tune.modTank or -1, false)
    SetVehicleMod(vehicle, 46, tune.modWindows or -1, false)
    SetVehicleMod(vehicle, 49, tune.modLightbar or -1, false)

    local frontWheels = {
        ["wheel_lf"] = 0,
        ["wheel_rf"] = 1,
    }

    local rearWheels = {
        ["wheel_lr"] = 2,
        ["wheel_rr"] = 3,
        ["wheel_lm1"] = 4,
        ["wheel_rm1"] = 5,
        ["wheel_lm2"] = 6,
        ["wheel_rm2"] = 7,
        ["wheel_lm3"] = 8,
        ["wheel_rm3"] = 9,
    }
end

local function healthApply(vehicle, health)
    SetVehicleBodyHealth(vehicle, health.body + 0.0)
    SetVehicleEngineHealth(vehicle, health.engine + 0.0)
    SetVehiclePetrolTankHealth(vehicle, health.tank + 0.0)
    SetVehicleDirtLevel(vehicle, health.dirt + 0.0)

    for windowIndex, bool in pairs(health.windowsBroken) do
        if bool then
            SmashVehicleWindow(vehicle, windowIndex)
        end
    end

    for doorIndex, bool in pairs(health.doorsBroken) do
        if bool then
            SetVehicleDoorBroken(vehicle, doorIndex, true)
        end
    end

    for tyreIndex, type in pairs(health.tyreBurst) do
        if type then
            SetVehicleTyreBurst(vehicle, tyreIndex, type == 2, type == 1 and 1000.0 or 0.0)
        end
    end

    --ApplyDamageToVehicle(vehicle)
end

local function colorApply(vehicle, color)
    SetVehicleModKit(vehicle, 0)

    local pearlescent, wheel = GetVehicleExtraColours(vehicle)
    SetVehicleExtraColours(vehicle, color.pearlescent and color.pearlescent or pearlescent, color.wheel and color.wheel or wheel)

    if color.neon and (color.neon.r > 0 or color.neon.g > 0 or color.neon.b > 0) then
        SetVehicleNeonLightEnabled(vehicle, 0, true)
        SetVehicleNeonLightEnabled(vehicle, 1, true)
        SetVehicleNeonLightEnabled(vehicle, 2, true)
        SetVehicleNeonLightEnabled(vehicle, 3, true)
        SetVehicleNeonLightsColour(vehicle, color.neon.r, color.neon.g, color.neon.b)
    end

    if color.livery then
        SetVehicleMod(vehicle, 48, color.livery, false)
        SetVehicleLivery(vehicle, color.livery + 1)
    else
        SetVehicleMod(vehicle, 48, -1, false)
    end

    if type(color.xenon) == "number" then
        ToggleVehicleMod(vehicle, 22, true)
        SetVehicleXenonLightsColor(vehicle, color.xenon)
    elseif type(color.xenon) == "table" then
        ToggleVehicleMod(vehicle, 22, true)
        SetVehicleXenonLightsCustomColor(vehicle, color.xenon.r, color.xenon.g, color.xenon.b)
    end

    if color.tyreSmoke then
        ToggleVehicleMod(vehicle, 20, true)
        SetVehicleTyreSmokeColor(vehicle, color.tyreSmoke.r, color.tyreSmoke.g, color.tyreSmoke.b)
    end
end

local function cruiseApply(vehicle, value)
    if value then
        SetEntityMaxSpeed(vehicle, value)
    else
        local ent = Entity(vehicle)
        SetEntityMaxSpeed(vehicle, ent.state.handling.fInitialDriveMaxFlatVel)
    end
end

local function engineApply(vehicle, value)
    SetVehicleEngineOn(vehicle, value, true, true)
end

local vehiclePropertiesList = {
    ['tune'] = tuneApply,
    ['health'] = healthApply,
    ['color'] = colorApply,
    ['cruise'] = cruiseApply,
    ['engine'] = engineApply,
}

for keyFilter, func in pairs(vehiclePropertiesList) do
    AddStateBagChangeHandler(keyFilter, nil, function(bagName, key, value)
        Wait(0)

        local vehicle = GetEntityFromStateBagName(bagName)

        if vehicle > 0 then
            for i = 1, 300 do
                if DoesEntityExist(vehicle) then
                    break
                end
                Wait(100)
            end

            if NetworkGetEntityOwner(vehicle) == PlayerId() then
                func(vehicle, value)
            end
        end
    end)
end

local function getVehicleColor(vehicle)
    local color = {}

    local primary, secondary = GetVehicleColours(vehicle)

    if GetIsVehiclePrimaryColourCustom(vehicle) then
        local r, g, b = GetVehicleCustomPrimaryColour(vehicle)
        color.primary = {
            r = r,
            g = g,
            b = b,
        }
    else
        color.primary = primary
    end

    color.livery = GetVehicleLivery(vehicle) -1
    if not color.livery or color.livery == -2 then
        color.livery = GetVehicleMod(vehicle, 48)
    end

    if GetIsVehicleSecondaryColourCustom(vehicle) then
        local r, g, b = GetVehicleCustomSecondaryColour(vehicle)
        color.secondary = {
            r = r,
            g = g,
            b = b,
        }
    else
        color.secondary = secondary
    end


    local pearlescent, wheel = GetVehicleExtraColours(vehicle)
    color.pearlescent = pearlescent
    color.wheel = wheel

    local bool, r, g, b = GetVehicleXenonLightsCustomColor(vehicle)

    if bool then
        color.xenon = {
            r = r,
            g = g,
            b = b,
        }
    else
        color.xenon = GetVehicleXenonLightsColor(vehicle)
    end

    r , g , b = GetVehicleNeonLightsColour(vehicle)
    color.neon = {
        r = r,
        g = g,
        b = b,
    }

    r , g , b = GetVehicleTyreSmokeColor(vehicle)
    color.tyreSmoke = {
        r = r,
        g = g,
        b = b,
    }

    return color
end

local function getVehicleHealth(vehicle)
    local health = {
        tyreBurst = {},
        windowsBroken = {},
        doorsBroken = {},
    }

    health.body = ESX.Math.Round(GetVehicleBodyHealth(vehicle), 1)
    health.engine = ESX.Math.Round(GetVehicleEngineHealth(vehicle), 1)
    health.tank = ESX.Math.Round(GetVehiclePetrolTankHealth(vehicle), 1)
    health.dirt = ESX.Math.Round(GetVehicleDirtLevel(vehicle), 1)    

    for i = 0, 5 do
        if IsVehicleTyreBurst(vehicle, i, false) then
            health.tyreBurst[i] = IsVehicleTyreBurst(vehicle, i, true) and 2 or 1
        end
    end

    for windowIndex = 0, 7 do
        health.windowsBroken[windowIndex] = not IsVehicleWindowIntact(vehicle, windowIndex)
    end

    for doorIndex = 0, GetNumberOfVehicleDoors(vehicle) do
        health.doorsBroken[doorIndex] = IsVehicleDoorDamaged(vehicle, doorIndex)
    end

    return health
end

local function getVehicleTune(vehicle)
    local tune = {}

    tune.plateIndex = GetVehicleNumberPlateTextIndex(vehicle)
    tune.wheels = GetVehicleWheelType(vehicle)
    tune.windowTint = GetVehicleWindowTint(vehicle)



    tune.extras = {}
    for extraIndex = 0, 12 do
        if DoesExtraExist(vehicle, extraIndex) then
            tune.extras[extraIndex] = IsVehicleExtraTurnedOn(vehicle, extraIndex)
        end
    end

    --tune.modTurbo = IsToggleModOn(vehicle, 18)
    tune.modSmokeEnabled = IsToggleModOn(vehicle, 20)
    tune.modXenon = IsToggleModOn(vehicle, 22)

    tune.modSpoilers = GetVehicleMod(vehicle, 0)
    tune.modFrontBumper = GetVehicleMod(vehicle, 1)
    tune.modRearBumper = GetVehicleMod(vehicle, 2)
    tune.modSideSkirt = GetVehicleMod(vehicle, 3)
    tune.modExhaust = GetVehicleMod(vehicle, 4)
    tune.modFrame = GetVehicleMod(vehicle, 5)
    tune.modGrille = GetVehicleMod(vehicle, 6)
    tune.modHood = GetVehicleMod(vehicle, 7)
    tune.modFender = GetVehicleMod(vehicle, 8)
    tune.modRightFender = GetVehicleMod(vehicle, 9)
    tune.modRoof = GetVehicleMod(vehicle, 10)
    tune.modEngine = GetVehicleMod(vehicle, 11)
    tune.modBrakes = GetVehicleMod(vehicle, 12)
    tune.modTransmission = GetVehicleMod(vehicle, 13)
    tune.modHorns = GetVehicleMod(vehicle, 14)
    tune.modSuspension = GetVehicleMod(vehicle, 15)
    tune.modArmor = GetVehicleMod(vehicle, 16)
    tune.modFrontWheels = GetVehicleMod(vehicle, 23)
    tune.modBackWheels = GetVehicleMod(vehicle, 24)
    tune.modPlateHolder = GetVehicleMod(vehicle, 25)
    tune.modVanityPlate = GetVehicleMod(vehicle, 26)
    tune.modTrimA = GetVehicleMod(vehicle, 27)
    tune.modOrnaments = GetVehicleMod(vehicle, 28)
    tune.modDashboard = GetVehicleMod(vehicle, 29)
    tune.modDial = GetVehicleMod(vehicle, 30)
    tune.modDoorSpeaker = GetVehicleMod(vehicle, 31)
    tune.modSeats = GetVehicleMod(vehicle, 32)
    tune.modSteeringWheel = GetVehicleMod(vehicle, 33)
    tune.modShifterLeavers = GetVehicleMod(vehicle, 34)
    tune.modAPlate = GetVehicleMod(vehicle, 35)
    tune.modSpeakers = GetVehicleMod(vehicle, 36)
    tune.modTrunk = GetVehicleMod(vehicle, 37)
    tune.modHydrolic = GetVehicleMod(vehicle, 38)
    tune.modEngineBlock = GetVehicleMod(vehicle, 39)
    tune.modAirFilter = GetVehicleMod(vehicle, 40)
    tune.modStruts = GetVehicleMod(vehicle, 41)
    tune.modArchCover = GetVehicleMod(vehicle, 42)
    tune.modAerials = GetVehicleMod(vehicle, 43)
    tune.modTrimB = GetVehicleMod(vehicle, 44)
    tune.modTank = GetVehicleMod(vehicle, 45)
    tune.modWindows = GetVehicleMod(vehicle, 46)
    tune.modLightbar = GetVehicleMod(vehicle, 49)


    return tune
end



--============================================================================= GARAGE ============================================================================--

local function takeVehicleFromGarage(plate, cb)
    ESX.TriggerServerCallback('garage:takeVehicle', function(bool)
        cb(bool)
    end, plate)
end

local function towVehicle(plate, cb)
    ESX.TriggerServerCallback('garage:towVehicle', function(bool)
        cb(bool)
    end, plate)
end

local function towAllVehicle(cb)
    ESX.TriggerServerCallback('garage:towAllVehicle', function(bool)
        cb(bool)
    end)
end

local function giveKeys(plate, cb)
    cb(true) --change this shit zdziaramy plsge
    local player = ESX.UI.ChoosePlayerMenu()

    if player then
        ESX.TriggerServerCallback('garage:giveKeyForVehicle', function()
        end, plate, player)
    end
end

RegisterCommand('nuifix', function()
    SetNuiFocus(false, false)
end)

RegisterCommand('garage', function()
    if not LocalPlayer.state.dead and not IsPedCuffed(PlayerPedId()) then
        ESX.TriggerServerCallback('garage:getVehicles', function(vehicles)
            for i = 1, #vehicles do
                vehicles[i].model = Config['vehicle-list'][vehicles[i].model] and Config['vehicle-list'][vehicles[i].model].label or GetDisplayNameFromVehicleModel(joaat(vehicles[i].model))
            end
            SendNUIMessage({
                action = 'garage',
                data = {
                    cars = vehicles
                }
            })
            SetNuiFocus(true, true)
        end)
    end
end)

RegisterNUICallback('SpaceRP:garage', function(data, cb)
    if data.action == "out" then
        takeVehicleFromGarage(data.plate, cb)
    elseif data.action == "tow" then
        towVehicle(data.plate, cb)
    elseif data.action == "give" then
        giveKeys(data.plate, cb)
    elseif data.action == "tow-all" then
        towAllVehicle(cb)
    end
end)

for _, values in ipairs(Config['garages'].normal) do
    CM.RegisterPlace(values.coords, {size = vector3(6.0, 6.0, 4.0), dist = 35.0}, false,
    function()
        if IsPedInAnyVehicle(PlayerPedId()) then
            local ent = Entity(GetVehiclePedIsIn(PlayerPedId(), false))
            ent.state:set('health', getVehicleHealth(GetVehiclePedIsIn(PlayerPedId(), false)), true)
            ESX.TriggerServerCallback('garage:hideVehicle', function()
                DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
            end, GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)))
        else
            if IsPedInAnyVehicle(PlayerPed, false) then
                TriggerEvent('win:showNotification', {
                    type = 'error',
                    title = 'Garaż',
                    text = "Nie jesteś kierowcą"
                })
            else
                ESX.TriggerServerCallback('garage:getVehicles', function(vehicles)
                    for i = 1, #vehicles do
                        vehicles[i].model = Config['vehicle-list'][vehicles[i].model] and Config['vehicle-list'][vehicles[i].model].label or GetDisplayNameFromVehicleModel(joaat(vehicles[i].model))
                    end
                    SendNUIMessage({
                        action = 'garage',
                        data = {
                            cars = vehicles
                        }
                    })
                    SetNuiFocus(true, true)
                end)
            end
        end
    end, function()
        ESX.UI.Menu.CloseAll()
        ESX.HideUI()
    end, function()
        ESX.TextUI('[E] - aby otworzyć garaż')
    end)
    if values.blip then
        local blip = AddBlipForCoord(values.coords)
        SetBlipSprite(blip, 50)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.5)
        SetBlipColour(blip, 38)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Garaż")
        EndTextCommandSetBlipName(blip)
    end
end

--============================================================================= CAR DMG ============================================================================--

local healthEngineLast = 1000.0
local healthBodyLast = 1000.0
local healthPetrolTankLast = 1000.0


local function setDamageVehicleHandling(vehicle, ent)
    if Config['cardamage'].deformationMultiplier ~= -1 then
        SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDeformationDamageMult', (ent.state.handling.fDeformationDamageMult ^ Config['cardamage'].deformationExponent) * Config['cardamage'].deformationMultiplier)
    end
    if Config['cardamage'].weaponsDamageMultiplier ~= -1 then
        SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fWeaponDamageMult', Config['cardamage'].weaponsDamageMultiplier/Config['cardamage'].damageFactorBody)
    end

    SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fCollisionDamageMult', ent.state.handling.fCollisionDamageMult ^ Config['cardamage'].collisionDamageExponent)
    SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fEngineDamageMult', ent.state.handling.fEngineDamageMult ^ Config['cardamage'].engineDamageExponent)
end

local function getVehicleHandling(vehicle, ent)
    if not ent.state.handling then
        local handling = {
            -- damage
            ["fDeformationDamageMult"] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fDeformationDamageMult"),
            ["fCollisionDamageMult"] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fCollisionDamageMult"),
            ["fEngineDamageMult"] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fEngineDamageMult"),

            -- tempomat
            ["fInitialDriveMaxFlatVel"] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel"),


            -- tymczasowo zbędny syf zostawiony na przyszłe pokolenie
            ["fInitialDragCoeff"] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDragCoeff"),
            ["fInitialDriveForce"] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce"),
            ["fDriveInertia"] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fDriveInertia"),

            ["fClutchChangeRateScaleDownShift"] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fClutchChangeRateScaleDownShift"),
            ["fClutchChangeRateScaleUpShift"] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fClutchChangeRateScaleUpShift"),
            ["fLowSpeedTractionLossMult"] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fLowSpeedTractionLossMult"),
            ["fTractionCurveLateral"] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveLateral"),
            ["fBrakeForce"] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeForce"),
            ["fSuspensionRaise"] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fSuspensionRaise"),
            ["fTractionCurveMax"] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMax"),
            ["fTractionCurveMin"] = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMin")
        }
        ent.state:set('handling', handling, true)
    end
end


local function applyDamageToVehicle(vehicle)
    local class = GetVehicleClass(vehicle)

    local healthEngineCurrent = GetVehicleEngineHealth(vehicle)

    if healthEngineCurrent == 1000 then
        healthEngineLast = 1000.0
    end

    local healthEngineNew = healthEngineCurrent
    local healthEngineDelta = healthEngineLast - healthEngineCurrent
    local healthEngineDeltaScaled = healthEngineDelta * Config['cardamage'].damageFactorEngine * Config['cardamage'].classDamageMultiplier[class]

    local healthBodyCurrent = GetVehicleBodyHealth(vehicle)

    if healthBodyCurrent == 1000 then
        healthBodyLast = 1000.0
    end

    local healthBodyNew = healthBodyCurrent

    if healthBodyCurrent < Config['cardamage'].cascadingFailureThreshold then
        healthBodyNew = Config['cardamage'].cascadingFailureThreshold
    end

    local healthBodyDelta = healthBodyLast - healthBodyCurrent
    local healthBodyDeltaScaled = healthBodyDelta * Config['cardamage'].damageFactorBody * Config['cardamage'].classDamageMultiplier[class]

    local healthPetrolTankCurrent = GetVehiclePetrolTankHealth(vehicle)
    if Config['cardamage'].compatibilityMode and healthPetrolTankCurrent < 1 then
        healthPetrolTankLast = healthPetrolTankCurrent
    end

    if healthPetrolTankCurrent == 1000 then
        healthPetrolTankLast = 1000.0
    end

    local healthPetrolTankNew = healthPetrolTankCurrent
    local healthPetrolTankDelta = healthPetrolTankLast-healthPetrolTankCurrent
    local healthPetrolTankDeltaScaled = healthPetrolTankDelta * Config['cardamage'].damageFactorPetrolTank * Config['cardamage'].classDamageMultiplier[class]

    if healthEngineCurrent > Config['cardamage'].engineSafeGuard+1 then
        SetVehicleUndriveable(vehicle, false)
        local ent = Entity(vehicle)
        ent.state:set('undriveable', false, true)
    end

    if healthEngineCurrent <= Config['cardamage'].engineSafeGuard+1 then
        local ent = Entity(vehicle)
        if GetIsVehicleEngineRunning(vehicle) then
            ESX.ShowNotification('Zbyt duże uszkodzenia pojazdu, dalsza jazda niemożliwa', 'error')
            ent.state:set('engine', false, true)
        end

        ent.state:set('undriveable', true, true)
        SetVehicleUndriveable(vehicle, true)
    end

    if healthEngineCurrent ~= 1000.0 or healthBodyCurrent ~= 1000.0 or healthPetrolTankCurrent ~= 1000.0 then

        local healthEngineCombinedDelta = math.max(healthEngineDeltaScaled, healthBodyDeltaScaled, healthPetrolTankDeltaScaled)

        if healthEngineCombinedDelta > (healthEngineCurrent - Config['cardamage'].engineSafeGuard) then
            healthEngineCombinedDelta = healthEngineCombinedDelta * 0.7
        end

        if healthEngineCombinedDelta > healthEngineCurrent then
            healthEngineCombinedDelta = healthEngineCurrent - (Config['cardamage'].cascadingFailureThreshold / 5)
        end

        healthEngineNew = healthEngineLast - healthEngineCombinedDelta


        if healthEngineNew > (Config['cardamage'].cascadingFailureThreshold + 5) and healthEngineNew < Config['cardamage'].degradingFailureThreshold then
            healthEngineNew = healthEngineNew-(0.038 * Config['cardamage'].degradingHealthSpeedFactor)
        end

        if healthEngineNew < Config['cardamage'].cascadingFailureThreshold then
            healthEngineNew = healthEngineNew-(0.1 * Config['cardamage'].cascadingFailureSpeedFactor)
        end

        if healthEngineNew < Config['cardamage'].engineSafeGuard then
            healthEngineNew = Config['cardamage'].engineSafeGuard
        end

        if Config['cardamage'].compatibilityMode == false and healthPetrolTankCurrent < 750 then
            healthPetrolTankNew = 750.0
        end

        if healthBodyNew < 0  then
            healthBodyNew = 0.0
        end
    end

    if healthEngineNew ~= healthEngineCurrent then
        SetVehicleEngineHealth(vehicle, healthEngineNew)
    end

    if healthBodyNew ~= healthBodyCurrent then
        SetVehicleBodyHealth(vehicle, healthBodyNew)
    end

    if healthPetrolTankNew ~= healthPetrolTankCurrent then
        SetVehiclePetrolTankHealth(vehicle, healthPetrolTankNew)
    end

    healthEngineLast = healthEngineNew
    healthBodyLast = healthBodyNew
    healthPetrolTankLast = healthPetrolTankNew
end

function ApplyDamageToVehicle(vehicle)
    applyDamageToVehicle(vehicle)
end

RegisterNetEvent("mechanic:syncWheels", function(netVeh, wheelsTable)
    local veh = NetToVeh(netVeh)
    if NetworkDoesNetworkIdExist(netVeh) and veh ~= vehicleInMechanicMode then
        for bone, values in pairs(wheelsTable) do
            if values.attached then
                SetVehicleWheelXOffset(veh, values.wheelIndex, values.wheelXOffset)
            else
                SetVehicleWheelXOffset(veh, values.wheelIndex, -9999.9)
            end
        end
    end
end)

--============================================================================= VEHICLE SHOP ============================================================================--
local function waitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or joaat(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyspinnerOn('STRING')
		AddTextComponentSubstringPlayerName('wczytywanie pojazdu')
		EndTextCommandBusyspinnerOn(4)

		while not HasModelLoaded(modelHash) do
			Wait(0)
			DisableAllControlActions(0)
		end

		BusyspinnerOff()
	end
end

local isInVehShop = false

local function openVehicleShopMenu(coords)
    isInVehShop = true
    FreezeEntityPosition(PlayerPed, true)
	SetEntityVisible(PlayerPed, false)

    local categories = {}
    for category, vehicles in pairs(Config['vehicle-shop'].vehicles) do
        categories[#categories+1] = {label = category}
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_categories_shop', {
        title = "Dealer samochodowy",
        align = 'right',
        elements = categories
    }, function(data, menu)

        local vehicles = {}
        for index, value in ipairs(Config['vehicle-shop'].vehicles[data.current.label]) do
            vehicles[index] = value
            vehicles[index].label = value.name..' - <span style="color:green;">$'..ESX.Math.GroupDigits(value.price)..'</span>'
        end

        if IsPedInAnyVehicle(PlayerPed, false) then
            ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPed, false))
        end

        waitForVehicleToLoad(vehicles[1].model)

        ESX.Game.SpawnLocalVehicle(vehicles[1].model, coords, 60.0, function(vehicle)
            TaskWarpPedIntoVehicle(PlayerPed, vehicle, -1)
            FreezeEntityPosition(vehicle, true)
            SetVehicleDoorsLocked(vehicle, 4)
            SetModelAsNoLongerNeeded(vehicles[1].model)
        end)

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
            title = data.current.label,
            align = 'right',
            elements = vehicles
        }, function(data2, menu2)

            local bool = ESX.UI.ShowAskMenu('Czy na pewno chcesz kupić '..data2.current.name..'?')
            if bool then
                for i=1, #(ESX.PlayerData.accounts) do
                    if ESX.PlayerData.accounts[i].name == 'money' and ESX.PlayerData.accounts[i].money < data2.current.price then
                        ESX.ShowNotification('Nie masz wystarczająco pieniędzy', 'error')
                        return
                    end
                end

                ESX.UI.Menu.CloseAll()
                DoScreenFadeOut(500)
                Wait(500)
                if IsPedInAnyVehicle(PlayerPed, false) then
                    ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPed, false))
                end
                BusyspinnerOff()
                ESX.Game.Teleport(PlayerPed, Config['vehicle-shop'].exitVeh)
                FreezeEntityPosition(PlayerPed, false)
                SetEntityVisible(PlayerPed, true)
                isInVehShop = false

                ESX.TriggerServerCallback('vehicleShop:buyVehicle', function()
                    DoScreenFadeIn(500)
                end, data2.current.model, getVehicleColor(GetVehiclePedIsIn(PlayerPed, false)))
            end
        end, function(data2, menu2)
            menu2.close()
            if IsPedInAnyVehicle(PlayerPed, false) then
                ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPed, false))
            end
        end, function(data2, menu2)
            if IsPedInAnyVehicle(PlayerPed, false) then
                ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPed, false))
            end

            waitForVehicleToLoad(data2.current.model)

            ESX.Game.SpawnLocalVehicle(data2.current.model, coords, 60.0, function(vehicle)
                TaskWarpPedIntoVehicle(PlayerPed, vehicle, -1)
                FreezeEntityPosition(vehicle, true)
                SetVehicleDoorsLocked(vehicle, 4)
                SetModelAsNoLongerNeeded(data2.current.model)
            end)
        end)

    end, function(data, menu)
        menu.close()
        if IsPedInAnyVehicle(PlayerPed, false) then
            ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPed, false))
        end
        FreezeEntityPosition(PlayerPed, false)
        SetEntityVisible(PlayerPed, true)
        isInVehShop = false
        Wait(500)
        DoScreenFadeIn(500)
    end)
end

CreateThread(function()
    local blip = AddBlipForCoord(Config['vehicle-shop'].places[1])
    SetBlipSprite(blip, 326)
	SetBlipDisplay(blip, 4)
	SetBlipScale (blip, 0.8)
	SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Salon samochodowy')
    EndTextCommandSetBlipName(blip)
end)

for index, coords in ipairs(Config['vehicle-shop'].places) do
    CM.RegisterPlace(coords, {size = vector3(6.0, 6.0, 4.0)}, false,
    function()
        if IsPedInAnyVehicle(PlayerPed, false) then
            ESX.ShowNotification('Jesteś w pojeździe', 'error')
        elseif not isInVehShop then
            openVehicleShopMenu(coords)
        end
    end, function()
        ESX.HideUI()
    end, function()
        ESX.TextUI('[E] - przeglądanie pojazdów')
    end)
end

CreateThread(function()
	RequestIpl('shr_int') -- Load walls and floor

	local interiorID = 7170
	PinInteriorInMemory(interiorID)
	ActivateInteriorEntitySet(interiorID, 'csr_beforeMission') -- Load large window
	RefreshInterior(interiorID)
end)

--============================================================================= LOCKSYSTEM ============================================================================--

local Timer = 2000
local lastLockTimer = 0

local vehicleKeys = {}

local doors = {
	["door_dside_f"] = -1,
	["door_pside_f"] = 0,
	["door_dside_r"] = 1,
	["door_pside_r"] = 2
}

RegisterNetEvent('locksystem:giveTempKeys', function(plate)
    GiveTempKeys(plate)
end)

local function lockCar(vehicle)
    local lockStatus = GetVehicleDoorLockStatus(vehicle)
    if lockStatus < 2 then
        SetVehicleDoorsLocked(vehicle, 2)
        SetVehicleDoorsShut(vehicle, false)
        SetVehicleAlarm(vehicle, true)
        TriggerEvent('win:showNotification', {
            type = 'error',
            title = 'System kluczyków',
            duration = 4000,
            text = 'Pojazd zamknięty'
        })
    elseif lockStatus > 1 then
        SetVehicleDoorsLocked(vehicle, 1)
        SetVehicleAlarm(vehicle, false)
        TriggerEvent('win:showNotification', {
            type = 'success',
            title = 'System kluczyków',
            duration = 4000,
            text = 'Pojazd otwarty'
        })
    end

    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 20.0, 'lock', 0.3)

    ESX.Streaming.RequestAnimDict('gestures@m@standing@casual', function()
        TaskPlayAnim(PlayerPedId(), 'gestures@m@standing@casual', 'gesture_you_soft', 8.0, -8.0, -1, 48, 1, false, false, false)
        RemoveAnimDict('gestures@m@standing@casual')
    end)

    local isControled = false
    for tries = 1, 10 do
        if NetworkRequestControlOfEntity(vehicle) then
            isControled = true
            break
        end
        Wait(25)
    end

    if not IsPedInAnyVehicle(PlayerPedId()) and isControled then
        local ent = Entity(vehicle)
        SetVehicleInteriorlight(vehicle, false)

        StartVehicleHorn(vehicle, 200, `HELDDOWN`, false)
        SetVehicleLights(vehicle, 2)
        SetVehicleBrakeLights(vehicle, true)
        Wait(200)

        SetVehicleLights(vehicle, 0)
        SetVehicleBrakeLights(vehicle, false)
        Wait(200)

        StartVehicleHorn(vehicle, 200, `HELDDOWN`, false)
        SetVehicleLights(vehicle, 2)
        SetVehicleBrakeLights(vehicle, true)
        Wait(200)

        SetVehicleLights(vehicle, 0)
        SetVehicleBrakeLights(vehicle, false)
        Wait(200)

        StartVehicleHorn(vehicle, 200, `HELDDOWN`, false)
        SetVehicleLights(vehicle, 2)
        SetVehicleBrakeLights(vehicle, true)
        Wait(200)

        SetVehicleLights(vehicle, 0)
        SetVehicleBrakeLights(vehicle, false)
    end
end

function giveTempKeys(plate)
    local player = ESX.UI.ChoosePlayerMenu()
    if player then
        TriggerServerEvent('locksystem:giveTempKeys', player, plate)
    end
end

local function longRangeKeys()
    ESX.TriggerServerCallback('locksystem:getAllPlayerKeys', function(vehicles)
        local elements = {}

        for index, vehicle in ipairs(vehicles) do
            if NetworkDoesNetworkIdExist(vehicle.netVeh) and (vehicle.isOwned or vehicleKeys[vehicle.plate]) then
                elements[#elements+1] = vehicle
                elements[#elements].label = '['..vehicle.plate..'] '..GetDisplayNameFromVehicleModel(GetEntityModel(NetToVeh(vehicle.netVeh)))
            end
        end

		if #elements > 0 then
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'locksystem_keys', {
                title    = 'Twoje kluczyki',
                align    = 'center',
                elements = elements
            }, function(data, menu)
                local options = {
                    {label = 'Zamknij/otwórz pojazd', value = 'closeCar'},
                    {label = 'Daj kluczyki', value = 'giveKeys'},
                }
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'locksystem_options', {
                    title    = 'Opcje',
                    align    = 'center',
                    elements = options
                }, function(data2, menu2)
                    if data2.current.value == 'closeCar' then
                        if GetGameTimer() > lastLockTimer then
                            lastLockTimer = GetGameTimer() + Timer

                            if NetworkDoesNetworkIdExist(data.current.netVeh) then
                                lockCar(NetToVeh(data.current.netVeh))
                            else
                                ESX.ShowNotification('Pojazd nie jest już w zasięgu kluczyków (50 metrów)', 'error')
                            end
                        end
                    elseif data2.current.value == 'giveKeys' then
                        menu.close()
                        menu2.close()
                        giveTempKeys(data.current.plate)
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            end, function(data, menu)
                menu.close()
            end)
        else
            ESX.ShowNotification('Nie znaleziono twoich pojazdów w okolicy (50 metrów)', 'error')
		end
    end)
end


function GiveTempKeys(plate)
    vehicleKeys[plate] = true
    TriggerEvent('win:showNotification', {
        type = 'info',
        title = 'System kluczyków',
        text = 'Otrzymano kluczyki do pojazdu - '..plate
    })
end

exports('GiveTempKeys', GiveTempKeys)


ESX.RegisterInput('keys', 'Kluczyki', 'keyboard', 'U', function()

    if LocalPlayer.state.dead then
		return
	end

    if GetGameTimer() < lastLockTimer then
		return
	end

    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    if not vehicle then
		vehicle = ESX.Game.GetVehicleInDirection()
	end

    if vehicle and DoesEntityExist(vehicle) then
        lastLockTimer = GetGameTimer() + Timer
        local plate = GetVehicleNumberPlateText(vehicle)
        ESX.TriggerServerCallback('locksystem:checkKeys', function(hasKey, canSearch)
            if hasKey or vehicleKeys[plate] then
                lockCar(vehicle)
            elseif canSearch then
                if GetVehiclePedIsIn(PlayerPedId(), false) then
                    TriggerServerEvent('locksystem:blockCarSearch', plate)
                    if math.random(100) <= 70 and NetworkGetEntityIsNetworked(GetVehiclePedIsIn(PlayerPedId(), false)) then
                        vehicleKeys[plate] = true
                        ESX.ShowNotification('Znaleziono klucze do tego pojazdu', 'info')
                    else
                        ESX.ShowNotification('Nie znaleziono kluczy do tego pojazdu', 'info')
                    end
                end
            end
        end, plate)
    else
        longRangeKeys()
    end
end)

--============================================================================= SELLCARS ============================================================================--

RegisterNetEvent('sellvehicle:ask', function(target)
	if GetVehiclePedIsIn(PlayerPedId(), false) then
		local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
		if targetPed ~= -1 and targetPed == GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), 0) then
            local price
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sell_vehicle_input', {
                title = 'Podaj kwotę za pojazd'
            }, function(data, menu)
                price = tonumber(data.value)
                if not price then
                    ESX.ShowNotification('Nieprawidłowa wartość', 'error')
                else
                    menu.close()
                end
            end, function(data, menu)
                menu.close()
                price = false
            end)

            while price == nil do
                Wait(0)
            end

            if price then
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'confirm_sell_vehicle_input', {
                    title = 'Wpisz numer rejestracyjny aby potwierdzić sprzedaż za $'..price
                }, function(data, menu)
                    if GetVehiclePedIsIn(PlayerPedId(), false) then
                        if GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)) == data.value then
                            ESX.TriggerServerCallback('sellvehicle:send', function()
                                menu.close()
                            end, target, price, GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)))
                        else
                            ESX.ShowNotification('Błąd', 'error')
                        end
                    else
                        ESX.ShowNotification('Nie jesteś w pojeździe lub nie jesteś kierowcą', 'error')
                    end
                end, function(data, menu)
                    menu.close()
                    price = false
                end)
            end

		else
			ESX.ShowNotification('Wskazany gracz z id: '..target..' nie siedzi na miejscu pasażera', 'error')
		end
	else
		ESX.ShowNotification('Nie jesteś w pojeździe lub nie jesteś kierowcą', 'error')
	end
end)

RegisterNetEvent('sellvehicle:ask_target', function(sender, price, plate)
    local bool = ESX.UI.ShowAskMenu('Czy chcesz kupić pojazd "'..plate..'" za $'..price..'od ['..sender..']')
    ESX.TriggerServerCallback('sellvehicle:respond', function()
    end, bool, sender, price, plate)
end)

RegisterNUICallback('SpaceRP:setNuiFocus', function (data, cb)
    SetNuiFocus(false, false)
    cb()
end)