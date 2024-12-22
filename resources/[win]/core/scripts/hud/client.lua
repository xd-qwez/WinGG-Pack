function OpenHud()
	SendNUIMessage({
		action = 'hud',
		data = {
			toggle = {
				player = true
			}
		}
	})
end

function CloseHud()
	SendNUIMessage({
		action = 'hud',
		data = {
			toggle = {
				player = false
			}
		}
	})
end

local function slowLoop()
	while true do
		Wait(2500)

		SendNUIMessage({
			action = 'hud',
			data = {
				update = {
					player = {
						aspectRatio = GetAspectRatio()
					}
				}
			}
		})
	end
end

CreateThread(function()
	while true do
		if exports['core']:IsPauseActive() or IsPauseMenuActive() then
			CloseHud()
		else
			OpenHud()
		end
		Wait(1500)
	end
end)

local function fastLoop()
	while true do
		local PlayerId = PlayerId()
		local isTalking = MumbleIsConnected() and NetworkIsPlayerTalking(PlayerId)
		local healthPercentage = math.ceil((((GetEntityHealth(PlayerPed) - 100) / (GetEntityMaxHealth(PlayerPed) - 100)) * 100)) -- persjęt
		local armorPercentage = math.ceil(((GetPedArmour(PlayerPed) / GetPlayerMaxArmour(PlayerId)) * 100))

		local timer = GetPlayerUnderwaterTimeRemaining(PlayerId)
		if timer < 0 then
			timer = 0
		end
		SendNUIMessage({
			action = 'hud',
			data = {
				update = {
					player = {
						health = (GetEntityHealth(PlayerPedId())-100),
						armor = (GetPedArmour(PlayerPedId())),
						isTalking = (isTalking == 1)					
					}
				}
			}
		})

		Wait(100)
	end
end

AddEventHandler('pma-voice:setTalkingMode', function(mode)
	local talking = {
		30,
		50,
		100
	}

	SendNUIMessage({
		action = 'hud',
		data = {
			update = {
				player = {
					voice = talking[mode]
				}
			}
		}
	})
end)

CreateThread(function ()
	while not ESX.PlayerLoaded do
		Wait(500)
	end

	CreateThread(fastLoop)
	CreateThread(slowLoop)
end)

exports('CloseHud', CloseHud)
exports('OpenHud', OpenHud)

AddEventHandler('esx:playerLoaded', function()
	OpenHud()
end)

CreateThread(function()
	Wait(500)
	OpenHud()
end)

RegisterCommand('hudswitch', function()
	SendNUIMessage({
		action = 'hud',
		data = {
			switch = true
		}
	})
	ESX.ShowNotification('Pomyślnie zmieniono typ hudu', 'success')
end)