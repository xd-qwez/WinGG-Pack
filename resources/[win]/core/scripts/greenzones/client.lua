local entity = PlayerPedId()
local isInZone = false
local timeout = nil

CreateThread(function()
	for k, v in pairs(Config['greenzone'].Zones) do
		if v.addBlip then
			v.blip = AddBlipForCoord(v.coords)

			SetBlipSprite(v.blip, 487)
			SetBlipColour(v.blip, 2)
			SetBlipAsShortRange(v.blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName('Greenzone')
			EndTextCommandSetBlipName(v.blip)

			SetBlipInfoTitle(v.blip, "Green Zone", false)
			AddBlipInfoIcon(v.blip, "INFO:", "Jesteś w nim nietykalny", 4, 0, false)

			v.blipradius = AddBlipForRadius(v.coords, v.size)
			SetBlipColour(v.blipradius, 2)
			SetBlipAlpha(v.blipradius, 100)
		end
	end
end)

for k, v in pairs(Config['greenzone'].Zones) do
	CM.RegisterPlace(v.coords, {type = 28, size = vector3(v.size, v.size, v.size), dist = v.size * 10, color = {r = 0, g = 200, b = 0, a = 30}, greenzone = true}, nil, function() end,
	function()
		isInZone = false
		for _, veh in pairs(GetGamePool('CVehicle')) do
			SetEntityNoCollisionEntity(veh, entity, true)
		end
		for _, otherPed in pairs(GetGamePool('CPed')) do
			SetEntityNoCollisionEntity(otherPed, entity, true)
		end

		timeout = ESX.SetTimeout(10000, function()
			if not isInZone then
				NetworkSetFriendlyFireOption(true)
			end
		end)
		SetPlayerInvincible(PlayerId(), false)
	end,
	function()
		NetworkSetFriendlyFireOption(false)
		isInZone = true
		SetPlayerInvincible(PlayerId(), true)
		if timeout then
			ESX.ClearTimeout(timeout)
			timeout = nil
		end
	end)
end

CreateThread(function()
	while true do
		if isInZone then
			entity = PlayerPedId()

			for _, veh in pairs(GetGamePool('CVehicle')) do
				SetEntityNoCollisionEntity(veh, entity, false)
			end

			for _, otherPed in pairs(GetGamePool('CPed')) do
				SetEntityNoCollisionEntity(otherPed, entity, false)
			end
		else
			for _, veh in pairs(GetGamePool('CVehicle')) do
				SetEntityNoCollisionEntity(veh, PlayerPedId(), false)
			end
		end
		Wait(1500)
	end
end)

local playerGroups = {}
local displayTags = true

RegisterCommand('tags', function()
	displayTags = not displayTags
	TriggerEvent('win:showNotification', {
		type = 'info',
		icon = 'fa-solid fa-tag',
		duration = 5000,
		title = 'NAMETAGI',
		text = 'Wyświetlanie wszystkich rang zostało: '.. (displayTags and '<span style="color: #68f522">Włączone</span>' or '<span style="color: #f00">Wyłączone</span>')
	})
end,false)

CreateThread(function()
	while true do
		if isInZone then
			DisablePlayerFiring(PlayerId(), true)

			if displayTags then
				for k,v in pairs(playerGroups) do
					if v.display then
						local player = GetPlayerFromServerId(k)
						local ped = GetPlayerPed(player)
						local coords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 0x796E))

						local dist = #(coords - pedData.coords)
						if dist <= 20.0 and player ~= -1 then
							if IsEntityVisible(ped) == 1 then
								drawText3D(v.group, coords, v.color)
							end
						end
					end
				end
			end

			Wait(0)
		else
			Wait(2000)
		end
	end
end)

drawText3D = function(text, coords, color)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z + 0.45)
	local scale = (1 / #(GetFinalRenderedCamCoord() - coords)) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(1.0 * scale, 0.75 * scale)
        SetTextFont(0)
        SetTextColour(color[1], color[2], color[3], 255)
        SetTextDropshadow(0, 0, 5, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
		SetTextCentre(1)

        BeginTextCommandDisplayText('STRING')
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x,_y)
    end
end

AddStateBagChangeHandler('groups', 'global', function(name, key, value)
    playerGroups = value
end)

local function isInGreenzone()
	return isInZone
end

exports('isInGreenzone', isInGreenzone)

-- TELEPORTS

RegisterCommand('tpmenu', function()
	if not LocalPlayer.state.dead and not IsPedCuffed(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId(), false) then
		GreenZoneTeleport(true)
	else
		ESX.ShowNotification('Nie możesz tego teraz użyć', 'error')
	end
end)

function GreenZoneTeleport(command)
	local elements = {}

	for k, v in pairs(Config['greenzone'].Zones) do
		if v.label then
			elements[#elements+1] = {label = v.label, value = v.coords}
		end
	end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'win_teleports_greenzone', {
		title    = 'Wybierz greenzone',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()
		if data.current.value then
			if command then
				ESX.Streaming.RequestAnimDict('mp_suicide')
				TaskPlayAnim(PlayerPedId(), 'mp_suicide', 'pistol', 1.0, 1.0, -1, 2, 0, 0, 0, 0)
				FreezeEntityPosition(PlayerPedId(), true)
				showProgress({title = 'Trwa teleportacja', time = 5000}, function(isDone)
					if isDone then
						DoScreenFadeOut(400)
						Wait(750)
						ESX.Game.Teleport(PlayerPedId(), data.current.value)
						FreezeEntityPosition(PlayerPedId(), false)
						DoScreenFadeIn(400)
					end
				end)
			else
				DoScreenFadeOut(400)
				Wait(750)
				ESX.Game.Teleport(PlayerPedId(), data.current.value)
				FreezeEntityPosition(PlayerPedId(), false)
				DoScreenFadeIn(400)
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

for k, coords in pairs(Config['greenzone'].Teleports) do
    CM.RegisterPlace(coords, {}, "wybrać greenzone",
    function()
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
			GreenZoneTeleport(false)
        end
    end,
    function()
        ESX.UI.Menu.CloseAll()
    end,
    function()
        ESX.UI.Menu.CloseAll()
    end)
end