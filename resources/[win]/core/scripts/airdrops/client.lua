local airdropBlip = nil
local radius = nil
local Plane = nil
local Pilot = nil
local planeblip = nil
local effect = nil
local drop = nil
local enabled = false
local currenttarget = nil
local holding = false

RegisterNetEvent('win-airdrops:client:startAirdrop',function(coords)
	local zone = GetNameOfZone(coords.x, coords.y, coords.z)
	local zoneLabel = GetLabelText(zone)
	local time = (Config['airdrops'].TimeToDrop * 60 * 1000)
	currenttarget = coords

	TriggerEvent('win:showNotification', {
		title = 'Zrzuty',
		color = '110, 50, 170',
		icon = 'fa-solid fa-parachute-box',
		text = 'Za '..Config['airdrops'].TimeToDrop..' minut nadleci przesyłka<br>Lokalizacja: ~g~'..zoneLabel
	})

    PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', false)
    airdropBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite (airdropBlip, 550)
    SetBlipDisplay(airdropBlip, 4)
    SetBlipScale  (airdropBlip, 0.7)
    SetBlipAsShortRange(airdropBlip, true)
    SetBlipColour(airdropBlip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Miejsce zrzutu")
    EndTextCommandSetBlipName(airdropBlip)

    radius = AddBlipForRadius(coords, 120.0)
    SetBlipColour(radius, 1)
    SetBlipAlpha(radius, 80)

    RequestNamedPtfxAsset("scr_biolab_heist")
    SetPtfxAssetNextCall("scr_biolab_heist")
    effect = StartParticleFxLoopedAtCoord("scr_heist_biolab_flare", coords, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

	Wait(time)

	PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', false)
	TriggerEvent('win:showNotification', {
		title = 'Zrzuty',
		color = '110, 50, 170',
		icon = 'fa-solid fa-parachute-box',
		text = 'Nadlatuje przesyłka <br>Lokalizacja: ~g~'..zoneLabel
	})
    
    spawnAirPlane(coords)
end)

function spawnAirPlane(coords)
	local dropped = false

	ESX.Streaming.RequestModel(Config['airdrops'].AirCraft.PlaneModel)
	ESX.Streaming.RequestModel(Config['airdrops'].AirCraft.PilotModel)

  	Plane = CreateVehicle(GetHashKey(Config['airdrops'].AirCraft.PlaneModel), Config['airdrops'].aircraftSpawnPoint.x, Config['airdrops'].aircraftSpawnPoint.y, Config['airdrops'].aircraftSpawnPoint.z, heading, false, true)
	Pilot = CreatePed(4, GetHashKey(Config['airdrops'].AirCraft.PilotModel), Config['airdrops'].aircraftSpawnPoint.x, Config['airdrops'].aircraftSpawnPoint.y, Config['airdrops'].aircraftSpawnPoint.z, heading, false, true)

  	planeblip = AddBlipForEntity(Plane)
  	SetBlipSprite(planeblip,307)
	SetBlipRotation(planeblip,GetEntityHeading(Pilot))
  	SetPedIntoVehicle(Pilot, Plane, -1)

	ControlLandingGear(Plane, 3)
	SetVehicleEngineOn(Plane, true, true, false)
  	SetEntityVelocity(Plane, 0.9 * Config['airdrops'].AirCraft.Speed, 0.9 * Config['airdrops'].AirCraft.Speed, 0.0)

  	while DoesEntityExist(Plane) do
    	if not NetworkHasControlOfEntity(Plane) then
			NetworkRequestControlOfEntity(Plane)
			Wait(10)
		end

    	SetBlipRotation(planeblip, Ceil(GetEntityHeading(Plane)))

    	if not dropped then
      		TaskPlaneMission(Pilot, Plane, 0, 0, coords.x, coords.y, coords.z + 250, 6, 0, 0, GetEntityHeading(Pilot), 3000.0, 500.0)
    	end

		local activeCoords = GetEntityCoords(Plane)
    	local dist = #(activeCoords - coords)

    	if dist < 300 or dropped then
      		Wait(1000)
      		TaskPlaneMission(Pilot, Plane, 0, 0, -2194.32, 5120.9, Config['airdrops'].AirCraft.Height, 6, 0, 0, GetEntityHeading(Pilot), 3000.0, 500.0)
      		if not dropped then
        		spawnCrate(coords)
        		dropped = true
				enabled = true
      		end

     	 	if dist > 2000 then 
        		DeleteEntity(Plane)
        		DeleteEntity(Pilot)
        		Plane = nil
        		Pilot = nil
        		dropped = false
        		break
      		end
    	end

    	Wait(1000)
 	end
end

function spawnCrate(coords)
    ESX.Streaming.RequestModel(Config['airdrops'].DropProp)
    drop = ESX.Game.SpawnObject(Config['airdrops'].DropProp, vector3(coords.x, coords.y, coords.z-0.9))

	local zone = GetNameOfZone(coords.x, coords.y, coords.z)
	local zoneLabel = GetLabelText(zone)

	TriggerEvent('win:showNotification', {
		title = 'Zrzuty',
		color = '110, 50, 170',
		icon = 'fa-solid fa-parachute-box',
		text = 'Przesyłka wylądowała<br>Lokalizacja: ~g~'..zoneLabel
	})

    SetObjectPhysicsParams(drop,80000.0, 0.1, 0.0, 0.0, 0.0, 700.0, 0.0, 0.0, 0.0, 0.1, 0.0)
    SetEntityLodDist(drop, 1000)
    ActivatePhysics(drop)
    SetDamping(drop, 2, 0.1)
    SetEntityVelocity(drop, 0.0, 0.0, -7000.0)
end

CreateThread(function()
	while true do
		Wait(1)
		if enabled then
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(currenttarget.x, currenttarget.y, currenttarget.z), true) <= 12.5 then
				ESX.ShowFloatingHelpNotification(' [~g~E~w~] - aby przejmować zrzut', vector3(currenttarget.x, currenttarget.y, currenttarget.z + 1.0))
				DrawMarker(1, currenttarget.x, currenttarget.y, currenttarget.z-0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 25.0, 25.0, 1.0, 175, 0, 0, 100, false, true, 2, false, false, false, false)
				if not IsPedInAnyVehicle(PlayerPedId(), false) and not LocalPlayer.state.dead then
					if IsControlJustPressed(0, 38) then
						ESX.TriggerServerCallback('win-airdrops:server:getLootState', function(looted)
							if not looted and not holding then
								holding = true
								TriggerServerEvent("win-airdrops:server:sync:loot", true)
								exports['core']:showProgress({title = 'Przejmowanie zrzutu', time = (Config['airdrops'].ClaimingTime*60*1000)}, function(isDone)
									if isDone then
										holding = false
										enabled = false
										ESX.ShowNotification("Przejęto zrzut", 'success')
										TriggerServerEvent('win-airdrops:server:getLoot')
										Wait(100)
										ESX.HideUI()
									end
								end)
								ESX.ShowNotification("Opuszczenie strefy spowoduje anulowanie przejmowania")
							end
						end)
					end
				else
					if holding then
						exports['core']:cancelProgress()
						holding = false
						ESX.ShowNotification('Przestałeś przejmować zrzut', 'error')
						TriggerServerEvent("win-airdrops:server:sync:loot", false)
					end
				end
			else
				if holding then
					exports['core']:cancelProgress()
					holding = false
					ESX.ShowNotification('Przestałeś przejmować zrzut', 'error')
					TriggerServerEvent("win-airdrops:server:sync:loot", false)
				end
			end
		else
			Wait(2000)
		end
	end
end)

RegisterCommand('airdrop', function()
	if currenttarget then
		SetNewWaypoint(currenttarget.x, currenttarget.y)
		ESX.ShowNotification('Zaznaczono zrzut na GPS-ie', 'success')
	else
		ESX.ShowNotification('Brak aktywnych zrzutów na mapie', 'error')
	end
end)

RegisterNetEvent('win-airdrops:client:clearStuff',function()
	StopParticleFxLooped(effect, 0)
	ESX.Game.DeleteObject(drop)
	DeleteEntity(Pilot)
	DeleteEntity(Plane)
	RemoveBlip(airdropBlip)
	RemoveBlip(radius)
	enabled = false
	currenttarget = nil
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end
	StopParticleFxLooped(effect, 0)
	ESX.Game.DeleteObject(drop)
	DeleteEntity(Pilot)
	DeleteEntity(Plane)
	RemoveBlip(airdropBlip)
	RemoveBlip(radius)
	enabled = false
	currenttarget = nil
end)