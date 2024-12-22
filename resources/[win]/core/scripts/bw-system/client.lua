local cam = nil
local angleY = 0.0
local angleZ = 0.0
local lastDistressSend = 0
local distressCooldown = 5 * 60000
coords = nil

local function StartDeathCam()
    ClearFocus()
    local playerPed = PlayerPedId()
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(playerPed), 0, 0, 0, GetGameplayCamFov())
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, false)
end

local function EndDeathCam()
    ClearFocus()
    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(cam, false)
    cam = nil
end

local function ProcessNewPosition()
    local mouseX = 0.0
    local mouseY = 0.0
    if (IsInputDisabled(0)) then
        mouseX = GetDisabledControlNormal(1, 1) * 8.0
        mouseY = GetDisabledControlNormal(1, 2) * 8.0
    else
        mouseX = GetDisabledControlNormal(1, 1) * 1.5
        mouseY = GetDisabledControlNormal(1, 2) * 1.5
    end
    
    angleZ = angleZ - mouseX
    angleY = angleY + mouseY
    
    if (angleY > 89.0) then
        angleY = 89.0
    elseif (angleY < -89.0) then
        angleY = -89.0
    end
    
    local pCoords = GetEntityCoords(PlayerPedId())
    local behindCam = {
        x = pCoords.x + ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * (5.5 + 0.5),
        y = pCoords.y + ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * (5.5 + 0.5),
        z = pCoords.z + ((Sin(angleY))) * (5.5 + 0.5)
    }
    
    local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, PlayerPedId(), 0)
    
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    
    local maxRadius = 1.9
    
    if (hitBool and Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords) < 5.5 + 0.5) then
        maxRadius = Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords)
    end
    
    local offset = {
        x = ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * maxRadius,
        y = ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * maxRadius,
        z = ((Sin(angleY))) * maxRadius
    }
    
    local pos = {
        x = pCoords.x + offset.x,
        y = pCoords.y + offset.y,
        z = pCoords.z + offset.z
    }
    
    return pos    
end

local function ProcessCamControls()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    DisableFirstPersonCamThisFrame()
    local newPos = ProcessNewPosition()
    SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)
    SetCamCoord(cam, newPos.x, newPos.y, newPos.z)
    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 0.5)
end

local function RespawnPed(ped, coords, heading)
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
    SetPlayerInvincible(ped, false)
    ClearPedBloodDamage(ped)
    LocalPlayer.state:set('dead', false, true)

    SendNUIMessage({
        action = 'brutallywounded',
        data = {
            respawn = true
        }
    })

    TriggerServerEvent('esx:onPlayerSpawn')
    TriggerEvent('esx:onPlayerSpawn')
    TriggerEvent('playerSpawned')

    ESX.UI.Menu.CloseAll()
end

local function OnPlayerDeath()
    local playerPed = PlayerPedId()
    LocalPlayer.state:set('dead', true, true)
	ESX.UI.Menu.CloseAll()
	StartDeathCam()
	ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 2.0)

    SendNUIMessage({
        action = 'brutallywounded',
        data = {
            time = Config['bw-system'].Timer
        }
    })

	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if GetPedInVehicleSeat(vehicle, -1) == playerPed then
			SetVehicleEngineOn(vehicle, false, true, true)
		end
	end

  	CreateThread(function()
        ESX.Streaming.RequestAnimDict('dead')

		if IsPedInAnyVehicle(playerPed, false) then
			while IsPedInAnyVehicle(playerPed, true) do
				Wait(0)
			end
		else
			if GetEntitySpeed(playerPed) > 0.2 then
				while GetEntitySpeed(playerPed) > 0.2 do
					Wait(0)
				end
			end
		end

		NetworkResurrectLocalPlayer(GetEntityCoords(playerPed), 0.0, false, false)
		SetPlayerInvincible(PlayerId(), true)
		SetPlayerCanUseCover(PlayerId(), false)

		while LocalPlayer.state.dead do
			playerPed = PlayerPedId()

            DisableAllControlActions(0)
            EnableControlAction(0, 47, true) -- G 
            EnableControlAction(0, 245, true) -- T
            EnableControlAction(0, 38, true) -- E

            ProcessCamControls()

			if not IsPedInAnyVehicle(playerPed, false) then
				if not IsEntityPlayingAnim(playerPed, 'dead', 'dead_a', 3) then
                    TaskPlayAnim(playerPed, 'dead', 'dead_a', 1.0, 1.0, -1, 2, 0, 0, 0, 0)
				end
			end

			Wait(0)
		end

		SetPlayerInvincible(PlayerId(), false)
		SetPlayerCanUseCover(PlayerId(), true)
		StopAnimTask(PlayerPedId(), 'dead', 'dead_a', 4.0)
		RemoveAnimDict('dead')
	end)
end

RegisterNetEvent('win:revive', function()
  local playerPed = PlayerPedId()
  local coords = GetEntityCoords(playerPed)

  DoScreenFadeOut(800)

  while not IsScreenFadedOut() do
    Wait(50)
  end

  local formattedCoords = {x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1)}

  RespawnPed(playerPed, formattedCoords, 0.0)
  EndDeathCam()
  DoScreenFadeIn(800)
end)

AddEventHandler('esx:onPlayerSpawn', function()
    EndDeathCam()
end)

AddEventHandler('esx:onPlayerDeath', OnPlayerDeath)

RegisterNUICallback('win:bw-finished', function()
    lastDistressSend = 0
    CreateThread(function()
        local timeHeld = 0
        while LocalPlayer.state.dead do
            if IsControlPressed(0, 38) and timeHeld > 60 then
                CreateThread(function()
                    local coords = GetEntityCoords(PlayerPedId())
                    local formattedCoords = {x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1)}
                    RespawnPed(PlayerPedId(), formattedCoords, 0.0)
                end)
                TriggerEvent("dope-spawnmanager:open", false, GetEntityCoords(PlayerPedId()))
            end

            if IsControlPressed(0, 38) then
				timeHeld = timeHeld + 1
			else
				timeHeld = 0
			end

            Wait(0)
        end
    end)
end)