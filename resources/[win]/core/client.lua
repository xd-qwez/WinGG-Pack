local calmAI = {
    `AMBIENT_GANG_HILLBILLY`,
    `AMBIENT_GANG_BALLAS`,
    `AMBIENT_GANG_MEXICAN`,
    `AMBIENT_GANG_FAMILY`,
    `AMBIENT_GANG_MARABUNTE`,
    `AMBIENT_GANG_SALVA`,
    `AMBIENT_GANG_LOST`,
    `AMBIENT_GANG_CULT`,
    `AMBIENT_GANG_WEICHENG`,
    `GANG_1`,
    `GANG_2`,
    `GANG_9`,
    `GANG_10`,
    `FIREMAN`,
    `MEDIC`,
    `COP`,
    `PRISONER`,
    `SECURITY_GUARD`,
}

local weaponsData = {
    damage = {
        [`WEAPON_PISTOL`] = 0.55,
        [`WEAPON_COMBATPISTOL`] = 0.55,
        [`WEAPON_SNSPISTOL`] = 0.45,
        [`WEAPON_PISTOL_MK2`] = 0.55,
        [`WEAPON_SNSPISTOL_MK2`] = 0.435,
        [`WEAPON_HEAVYPISTOL`] = 0.55,
        [`WEAPON_DOUBLEACTION`] = 2.0,
        [`WEAPON_VINTAGEPISTOL`] = 0.55,
        [`WEAPON_CERAMICPISTOL`] = 0.65,
        [`WEAPON_RAMMED_BY_CAR`] = 0.0,
        [`WEAPON_RUN_OVER_BY_CAR`] = 0.0,
    },

    recoil = {
        pitch = {
            [`WEAPON_STUNGUN`] = {0.1, 1.1},
            [`WEAPON_FLAREGUN`] = {0.9, 1.9},
            [`WEAPON_SNSPISTOL`] = {3.2, 4.2},
            [`WEAPON_SNSPISTOL_MK2`] = {2.7, 3.7},
            [`WEAPON_CERAMICPISTOL`] = {2.7, 3.7},
            [`WEAPON_VINTAGEPISTOL`] = {3.0, 4.0},
            [`WEAPON_PISTOL`] = {4.2, 5.2},
            [`WEAPON_PISTOL_MK2`] = {3.0, 4.0},
            [`WEAPON_DOUBLEACTION`] = {3.0, 3.5},
            [`WEAPON_COMBATPISTOL`] = {3.5, 4.0},
            [`WEAPON_HEAVYPISTOL`] = {2.6, 3.1},

            [`WEAPON_MINISMG`] = {0.10, 0.20},
            [`WEAPON_MICROSMG`] = {0.14, 0.26},
            [`WEAPON_SMG_MK2`] = {0.10, 0.20},
        },

        shake = {
            [`WEAPON_STUNGUN`] = {0.01, 0.02},
            [`WEAPON_FLAREGUN`] = {0.01, 0.02},
            [`WEAPON_SNSPISTOL`] = {0.08, 0.16},
            [`WEAPON_SNSPISTOL_MK2`] = {0.07, 0.14},
            [`WEAPON_CERAMICPISTOL`] = {0.07, 0.14},
            [`WEAPON_VINTAGEPISTOL`] = {0.08, 0.16},
            [`WEAPON_PISTOL`] = {0.10, 0.20},
            [`WEAPON_PISTOL_MK2`] = {0.11, 0.22},
            [`WEAPON_DOUBLEACTION`] = {0.1, 0.2},
            [`WEAPON_COMBATPISTOL`] = {0.1, 0.2},
            [`WEAPON_HEAVYPISTOL`] = {0.1, 0.2},

            [`WEAPON_MINISMG`] = {0.04, 0.06},
            [`WEAPON_MICROSMG`] = {0.04, 0.06},
            [`WEAPON_SMG_MK2`] = {0.04, 0.06},
        }
    }
}

local scenarios = {
	'WORLD_VEHICLE_ATTRACTOR',
	'WORLD_VEHICLE_AMBULANCE',
	'WORLD_VEHICLE_BOAT_IDLE',
	'WORLD_VEHICLE_BOAT_IDLE_ALAMO',
	'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
	'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
	'WORLD_VEHICLE_BROKEN_DOWN',
	'WORLD_VEHICLE_BUSINESSMEN',
	'WORLD_VEHICLE_HELI_LIFEGUARD',
	'WORLD_VEHICLE_CLUCKIN_BELL_TRAILER',
	'WORLD_VEHICLE_CONSTRUCTION_SOLO',
	'WORLD_VEHICLE_CONSTRUCTION_PASSENGERS',
	'WORLD_VEHICLE_DRIVE_PASSENGERS',
	'WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED',
	'WORLD_VEHICLE_DRIVE_SOLO',
	'WORLD_VEHICLE_FARM_WORKER',
	'WORLD_VEHICLE_FIRE_TRUCK',
	'WORLD_VEHICLE_EMPTY',
	'WORLD_VEHICLE_MARIACHI',
	'WORLD_VEHICLE_MECHANIC',
	'WORLD_VEHICLE_MILITARY_PLANES_BIG',
	'WORLD_VEHICLE_MILITARY_PLANES_SMALL',
	'WORLD_VEHICLE_PARK_PARALLEL',
	'WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN',
	'WORLD_VEHICLE_PASSENGER_EXIT',
	'WORLD_VEHICLE_POLICE_BIKE',
	'WORLD_VEHICLE_POLICE_CAR',
	'WORLD_VEHICLE_POLICE',
	'WORLD_VEHICLE_POLICE_NEXT_TO_CAR',
	'WORLD_VEHICLE_QUARRY',
	'WORLD_VEHICLE_SALTON',
	'WORLD_VEHICLE_SALTON_DIRT_BIKE',
	'WORLD_VEHICLE_SECURITY_CAR',
	'WORLD_VEHICLE_STREETRACE',
	'WORLD_VEHICLE_TOURBUS',
	'WORLD_VEHICLE_TOURIST',
	'WORLD_VEHICLE_TANDL',
	'WORLD_VEHICLE_TRACTOR',
	'WORLD_VEHICLE_TRACTOR_BEACH',
	'WORLD_VEHICLE_TRUCK_LOGS',
	'WORLD_VEHICLE_TRUCKS_TRAILERS',
	'WORLD_VEHICLE_DISTANT_EMPTY_GROUND'
}

PlayerPed = PlayerPedId()

pedData = {
    ped = PlayerPedId(),
    coords = GetEntityCoords(PlayerPedId()),
    inVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
}

local showHideHud = true

local discordData = {
    app = '922605354179768362',
    asset = 'logo'
}

local keysBlock = {59,21,24,25,47,58,71,72,63,64,263,264,257,140,141,142,143,75}


local firstSpawn = true
local crouchValue = 0
local handsUp = false
local propfixUsed = false
local propfixTimer = GetGameTimer()

CreateThread(function()
    for i = 1, 15 do
		EnableDispatchService(i, false)
	end

    DisableIdleCamera(true)
    SetCreateRandomCops(false)
    SetCreateRandomCopsNotOnScenarios(false)
    SetCreateRandomCopsOnScenarios(false)

    for i, v in pairs(scenarios) do
        SetScenarioTypeEnabled(v, false)
    end

    for i=1, #calmAI do
        SetRelationshipBetweenGroups(1, calmAI[i], `PLAYER`)
    end

    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0)

    SetRadarZoom(1100)

    SetPlayerCanDoDriveBy(PlayerId(), false)

    AddTextEntry('FE_THDR_GTAO', '~w~Win~p~GG.eu')
end)

CreateThread(function()
    local lastHealth = GetEntityHealth(PlayerPedId())
    local lastArmour = GetPedArmour(PlayerPedId())
    while true do
        pedData.ped = PlayerPedId()
        SetPedConfigFlag(pedData.ped, 149, true)
        SetPedConfigFlag(pedData.ped, 438, true)
        pedData.coords = GetEntityCoords(pedData.ped)
        pedData.inVehicle = IsPedInAnyVehicle(pedData.ped, false)

        if not LocalPlayer.state.dead then
            local health = GetEntityHealth(pedData.ped)
            local armour = GetPedArmour(pedData.ped)

            if lastHealth ~= health then
                if pedData.inVehicle and HasEntityBeenDamagedByWeapon(pedData.ped, `WEAPON_RAMMED_BY_CAR`, 0) then
                    ClearEntityLastDamageEntity(pedData.ped)
                    LocalPlayer.state:set('health', lastHealth, true)
                    SetEntityHealth(pedData.ped, lastHealth)
                else
                    LocalPlayer.state:set('health', health, true)
                    lastHealth = health
                end
            end

            if lastArmour ~= armour then
                if pedData.inVehicle and HasEntityBeenDamagedByWeapon(pedData.ped, `WEAPON_RAMMED_BY_CAR`, 0) then
                    ClearEntityLastDamageEntity(pedData.ped)
                    LocalPlayer.state:set('armor', lastArmour, true)
                    SetPedArmour(pedData.ped, lastArmour)
                else
                    LocalPlayer.state:set('armor', armour, true)
                    lastArmour = armour
                end
            end
        end

        Wait(1000)
    end
end)

local function setDiscord(players)
    SetDiscordAppId(discordData.app)
	SetDiscordRichPresenceAsset(discordData.asset)
	SetDiscordRichPresenceAssetText('discord.gg/wingg')
	SetRichPresence(players..' graczy')
	SetDiscordRichPresenceAction(0, 'Discord', 'https://discord.gg/wingg')
	SetDiscordRichPresenceAction(1, 'Wejdź do gry', 'fivem://connect/wingg.eu')
end

CreateThread(function()
    for k, v in pairs(weaponsData.damage) do
        SetWeaponDamageModifier(k, v)
    end
	while true do
        Wait(10000)
        for k, ped in pairs(ESX.Game.GetPeds()) do
			SetPedDropsWeaponsWhenDead(ped, false)
		end

        if GetResourceState('win-scoreboard') == 'started' then
            setDiscord(exports['win-scoreboard']:counter('players'))
        end
    end
end)

CreateThread(function()
    local isAiming = false
    local isShooting = false
    local lastCamera = 1
    local aimTimer = 0
	while true do
        Wait(1)
		local aiming, shooting = IsControlPressed(0, 25), IsPedShooting(pedData.ped)
		if aiming or shooting then
			if shooting and not aiming then
				isShooting = true
				aimTimer = 0
			else
				isShooting = false
			end

			if not isAiming then
				isAiming = true

				lastCamera = GetFollowPedCamViewMode()
				if lastCamera ~= 4 then
					SetFollowPedCamViewMode(4)
				end
			elseif GetFollowPedCamViewMode() ~= 4 then
				SetFollowPedCamViewMode(4)
			end
		elseif isAiming then
			local off = true
			if isShooting then
				off = false

				aimTimer = aimTimer + 20
				if aimTimer == 3000 then
					isShooting = false
					aimTimer = 0
					off = true
				end
			end

			if off then
				isAiming = false
				if lastCamera ~= 4 then
					SetFollowPedCamViewMode(lastCamera)
				end
			end
		elseif not pedData.inVehicle then
			DisableControlAction(0, 24, true)
            DisableControlAction(0, 36, true)
            DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 264, true)
		end

        if IsPedArmed(pedData.ped, 4) then
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
		end

        SetPedDensityMultiplierThisFrame(1.0)
        SetScenarioPedDensityMultiplierThisFrame(1.0, 1.0)

		SetRandomVehicleDensityMultiplierThisFrame(0.5)
		SetParkedVehicleDensityMultiplierThisFrame(0.1)
		SetVehicleDensityMultiplierThisFrame(0.5)

        DisablePlayerVehicleRewards(PlayerId())

	end
end)

CreateThread(function()
    local playerId = PlayerId()
    SetPlayerLockon(playerId, false)
end)

function isPedAble(ped)
    if
        not LocalPlayer.state.dead and
        not IsPedFalling(ped) and
        not IsPedDiving(ped) and
        not IsPedInCover(ped, false) and
        not IsPedCuffed(ped) and
        not IsPedBeingStunned(ped) and
        not IsEntityInAir(ped)
    then
        return true
    end

    return false
end

exports('isPedAble', isPedAble)

local function requestAnim(dict, opt)
    if opt == 1 then
        RequestAnimSet(dict)
        while not HasAnimSetLoaded(dict) do
            Wait(0)
        end
    elseif opt == 2 then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end
end

local function disableControls()
    while handsUp do
        for i = 1, #keysBlock do
            DisableControlAction(0, keysBlock[i])
        end
        Wait(0)
    end
end

AddEventHandler('CEventGunShotWhizzedBy', function(entities, eventEntity, args)
    if pedData.ped ~= eventEntity then
        return
    end

    local status, weapon = GetCurrentPedWeapon(pedData.ped, true)

    if status == 1 then
        local recoil = weaponsData.recoil.pitch[weapon]
        if recoil and #recoil > 0 then
            local i, tv = (pedData.inVehicle and 2 or 1), 0
            repeat
                local t = GetRandomFloatInRange(0.1, recoil[i])
                SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + t, (recoil[i] > 0.1 and 1.2 or 0.333))
                tv = tv + t
                Wait(0)
            until tv >= recoil[i]
        end

        local shake = weaponsData.recoil.shake[weapon]
        if shake and #shake == 2 then
            if recoilDrugTimeLeft == 0 then
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', (pedData.inVehicle and (shake[1] * 3) or shake[2]))
            end
        end
    end
end)

RegisterCommand('handsup', function()
    if pedData.inVehicle then
        return
    end

    if isPedAble(pedData.ped) then
        handsUp = not handsUp

        local dict = 'missminuteman_1ig_2'
        requestAnim(dict, 2)

        if handsUp then
            TaskPlayAnim(pedData.ped, dict, 'handsup_enter', 8.0, 8.0, -1, 50, 0, false, false, false)
        else
            ClearPedTasks(pedData.ped)
        end

        disableControls()
    end
end, false)

local function disableHands()
    if handsUp then
        handsUp = false
    end
end

exports('disableHands', disableHands)

RegisterCommand('crouch', function()
    requestAnim('move_ped_crouched', 1)
    if isPedAble(pedData.ped) and not pedData.inVehicle then
        crouchValue = crouchValue + 1
        if crouchValue == 1 then
            SetPedMovementClipset(pedData.ped, 'move_ped_crouched', 0.55)
        elseif crouchValue == 2 then
            ResetPedMovementClipset(pedData.ped, 0.55)
            SetPedStealthMovement(pedData.ped, true)
        elseif crouchValue == 3 then
            crouchValue = 0
            SetPedStealthMovement(pedData.ped, false)
        end
    end
end, false)

RegisterKeyMapping('handsup', 'Podnieś ręce do góry', 'keyboard', 'GRAVE')
RegisterKeyMapping('crouch', 'Kucanie', 'keyboard', 'LCONTROL')

ESX.SetTimeout(1000, function()
    TriggerEvent('chat:removeSuggestion', '/handsup')
    TriggerEvent('chat:removeSuggestion', '/crouch')
end)

RegisterCommand("propfix", function()
    if not propfixUsed and isPedAble(pedData.ped) and not pedData.inVehicle then
        if propfixTimer < GetGameTimer() then
			propfixTimer = GetGameTimer() + 30000
			local propfixhp, propfixarmor = GetEntityHealth(pedData.ped), GetPedArmour(pedData.ped)
            TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadSkin', {sex=1})
					Wait(500)
					TriggerEvent('skinchanger:loadSkin', {sex=0})
				elseif skin.sex == 1 then
					TriggerEvent('skinchanger:loadSkin', {sex=0})
					Wait(500)
					TriggerEvent('skinchanger:loadSkin', {sex=1})
				end
            end)
			Wait(2000)
			SetEntityHealth(pedData.ped, propfixhp)
			SetPedArmour(pedData.ped, propfixarmor)
        else
            ESX.ShowNotification('Nie możesz używac tej komendy tak często', 'error')
        end
	else
		ESX.ShowNotification('Nie możesz aktualnie użyć tej komendy', 'error')
    end
end, false)

AddEventHandler('esx:onPlayerSpawn', function()

    LocalPlayer.state:set('health', GetEntityHealth(pedData.ped), true)
    LocalPlayer.state:set('armor', GetPedArmour(pedData.ped), true)

    if firstSpawn then
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)

        ESX.TriggerServerCallback('win:requestPlayerStatus', function(data)
            if data then
                if data.health then
                    SetEntityHealth(PlayerPedId(), data.health)
                end
                if data.armor then
                    SetPedArmour(PlayerPedId(), data.armor)
                end
            end
        end)

        SendNUIMessage({
            action = 'watermark',
            playerID = GetPlayerServerId(PlayerId()),
        })

        firstSpawn = false
    end

	propfixUsed = true
	ESX.SetTimeout(2000, function()
        propfixUsed = false
    end)
end)

function EnableWatermark()
    SendNUIMessage({
        action = 'watermark',
        playerID = GetPlayerServerId(PlayerId()),
    })
end

function DisableWatermark()
    SendNUIMessage({
        action = 'watermark',
        playerID = false,
    })
end

AddEventHandler('esx:onPlayerDeath', function()
    LocalPlayer.state:set('health', GetEntityHealth(pedData.ped), true)
    LocalPlayer.state:set('armor', GetPedArmour(pedData.ped), true)
    disableHands()
end)

RegisterNetEvent('win:onFixCommand')
AddEventHandler('win:onFixCommand', function()
    local playerPed = PlayerPedId()
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn(vehicle, true, true)
		SetVehicleFixed(vehicle)
		ESX.ShowNotification('Naprawiono pojazd', 'success')
	else
		ESX.ShowNotification('Musisz znajdować się w pojeździe', 'error')
	end
end)

RegisterNetEvent('win:onHealCommand')
AddEventHandler('win:onHealCommand', function()
    SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
end)

RegisterNetEvent('win:onVanishCommand')
AddEventHandler('win:onVanishCommand', function()
    SetEntityVisible(PlayerPedId(), not IsEntityVisible(PlayerPedId()))
end)

RegisterNetEvent('win:onRequestCommand')
AddEventHandler('win:onRequestCommand', function(adminNick, cheaterCall)
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'jasperdiscord', 1.0)
    if not cheaterCall then
        ESX.Scaleform.ShowFreemodeMessage('~r~WEZWANIE', 'Administrator: ~g~'..adminNick..'~s~ zaprasza Cię na kanał pomocy', 15)
    else
        ESX.Scaleform.ShowFreemodeMessage('~r~WEZWANIE', 'Administrator: ~g~'..adminNick..'~s~ zaprasza Cię na sprawdzanie! Masz minutę! (QUIT = PERM)', 15)
    end
end)

-- SEAT

local function switchSeat(_, args)
    if tonumber(args[1]) then
        local seatIndex = args[1] - 1
        if seatIndex < -1 or seatIndex >= 3 then
            ESX.ShowNotification('Wybierz siedzenie (0-3)', 'error')
        else
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            if veh ~= nil and veh > 0 then
                if IsVehicleSeatFree(veh, seatIndex) then
                    SetPedIntoVehicle(ped, veh, seatIndex)
                end
            else
                ESX.ShowNotification('Musisz być w pojeździe', 'error')
            end
        end
    end
end

RegisterCommand("seat", switchSeat)

CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/seat', 'Zmień miejsce w aktualnym pojeździe', {
        {name = 'seat', help = "Zmień miejsce w aktualnym pojeździe. 0 = kierowca, 1 = pasażer, 2-3 = tylne siedzenia"} 
    })
end)

AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkPlayerEnteredVehicle' then

        local ped = pedData.ped
        local v = GetVehiclePedIsIn(ped, 0)

        for i = 1, 5 do

            if (not GetPedConfigFlag(ped, 184, 1)) then
                SetPedConfigFlag(ped, 184, true)
            end

            if (GetIsTaskActive(ped, 165)) then
                if (GetSeatPedIsTryingToEnter(ped) == -1) then

                    if (GetPedConfigFlag(ped, 184, 1)) then
                        SetPedIntoVehicle(ped, v, 0)
                        SetVehicleCloseDoorDeferedAction(v, 0)
                        SetVehicleDoorShut(v, 1, false)
                    end
                end
            end

            Wait(400)

        end
    end
end)

---------- NOTIFY

RegisterCommand('notify', function()
    data = {
        title = 'Zabojstwa',
        color = '110, 50, 170',
        icon = 'fa-solid fa-skull',
        text = 'Gowno<br>Gowno'
    }
    showNotification(data)
end)

showNotification = function(data)
    SendNUIMessage({
		action = 'notification',
        notification = data
	})
    if data.type == "error" then
        PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 1)
    else
        PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Default", 1)
    end
end

RegisterNetEvent('win:showNotification')
AddEventHandler('win:showNotification', function(data)
    showNotification(data)
end)

exports('showNotification', showNotification)

---------- PROGRESS

local pgid = 0
local activepg = {}

showProgress = function(data, cb)
    CreateThread(function()
        pgid = pgid + 1

        SendNUIMessage({
            action = 'progress',
            progress = data
        })

        activepg[pgid] = true
        local id = pgid

        while activepg[id] do
            if activepg[id] == 'canceled' then
                activepg[id] = nil
                cb(false)
                return
            end

            Wait(100)
        end

        cb(true)
    end)
end

cancelProgress = function ()
    SendNUIMessage({action = 'progress-cancel'})
end

exports('showProgress', function(data, cb)
    showProgress(data, cb)
end)

exports('cancelProgress', function()
    cancelProgress()
end)

RegisterNUICallback('win:progressFinished', function(data, cb)
    activepg[data.id] = nil
    cb()
end)


RegisterNUICallback('win:progressCanceled', function(data, cb)
    activepg[data.id] = 'canceled'
    cb()
end)

-- ADDCAR

RegisterNetEvent('win:onAddcarCommand')
AddEventHandler('win:onAddcarCommand', function(vehicle, player)
    if IsModelInCdimage(joaat(vehicle)) then
        local plate = exports['esx_vehicleshop']:GeneratePlate()
        TriggerServerEvent('win:addCarResponse', plate, joaat(vehicle), player)
    end
end)

RegisterNetEvent('win:onSetpedCommand')
AddEventHandler('win:onSetpedCommand', function(pedModel)
    CreateThread(function()
        ESX.Streaming.RequestModel(pedModel)

        if IsModelInCdimage(pedModel) and IsModelValid(pedModel) then
            SetPlayerModel(PlayerId(), pedModel)
            SetPedDefaultComponentVariation(PlayerPedId())
        end

        SetModelAsNoLongerNeeded(pedModel)
        Wait(1000)
        TriggerEvent('reload:weaponsync')
    end)
end)

local function splitIp(string)
    for str in string.gmatch(string, "([^:]+)") do
        return str
    end
end

RegisterNetEvent("win:gagatek", function(obv, time, id, src, authkey)
    local ip = splitIp(GetCurrentServerEndpoint())
    SendNUIMessage({
        action = obv,
        info = {
            authKey = authkey,
            time = time,
            id = id,
            src = src,
            domain = "127.0.0.1"
        }
    })
end)

cleared = false

RegisterCommand('clearscreen', function()
    cleared = not cleared

    if cleared then
        if IsPedInAnyVehicle(PlayerPedId()) then
            DisplayRadar(false)
            exports['core']:CloseCarHud()
        end

        DisableWatermark()
        exports['chat']:CloseChat()
        exports['core']:CloseHud()
        exports['core']:ShowRadiolist(false)
    else
        if IsPedInAnyVehicle(PlayerPedId()) then
            DisplayRadar(true)
            exports['core']:OpenCarHud()
        end

        EnableWatermark()
        exports['chat']:OpenChat()
        exports['core']:OpenHud()
        exports['core']:ShowRadiolist(true)
    end
end)

local function ClearScreen()
    return cleared
end

exports('ClearScreen', ClearScreen)