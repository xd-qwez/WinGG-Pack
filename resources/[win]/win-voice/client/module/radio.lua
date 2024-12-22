local radioChannel = 0
local radioNames = {}

function syncRadioData(radioTable, localPlyRadioName)
	radioData = radioTable
	for tgt, enabled in pairs(radioTable) do
		if tgt ~= playerServerId then
			toggleVoice(tgt, enabled, 'radio')
		end
	end
	if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
		radioNames[playerServerId] = localPlyRadioName
	end
end
RegisterNetEvent('pma-voice:syncRadioData', syncRadioData)

Display = {}
DisplayStr = nil

function setTalkingOnRadio(plySource, enabled)
	if enabled then
		table.insert(Display, plySource)
	else
		for k,v in pairs(Display) do
			if v == plySource then
				table.remove(Display, k)
				break
			end
		end
	end
	toggleVoice(plySource, enabled, 'radio')
	radioData[plySource] = enabled
end

CreateThread(function()
	while true do
		Wait(0)
		if DisplayStr then
			DrawTick()
		else 
			Wait(50) 
		end
	end
end)

DrawTick = function()
	SetTextScale(0.45, 0.45)
	SetTextFont(4)
	SetTextColour(0, 255, 200, 200)
	SetTextDropshadow(0, 0, 0, 0, 200)
	SetTextDropShadow()
	SetTextOutline()

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(DisplayStr)
	if LocalPlayer.state.oldhud then
		if IsRadarHidden() then
			EndTextCommandDisplayText(0.165, (1.015-(0.0295*(#Display+1))))
		else
			EndTextCommandDisplayText(0.165, (1.015-(0.0295*(#Display+1))))
		end
	else
		if IsRadarHidden() then
			EndTextCommandDisplayText(0.165, (1.015-(0.0295*(#Display+1))))
		else
			EndTextCommandDisplayText(0.01, (0.995-(0.0295*(#Display+1))))
		end
	end
end

UpdateDisplay = function()

	table.sort(Display, function(a,b) return a < b end)

	if #Display > 0 then
		DisplayStr = table.concat(Display, "\n")
	else DisplayStr = nil end

	SetTimeout(100, UpdateDisplay)
end

SetTimeout(0, UpdateDisplay)

RegisterNetEvent('pma-voice:setTalkingOnRadio', setTalkingOnRadio)

function addPlayerToRadio(plySource, plyRadioName)
	radioData[plySource] = false
	if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
		radioNames[plySource] = plyRadioName
	end
	if radioPressed then
		logger.info('[radio] %s joined radio %s while we were talking, adding them to targets', plySource, radioChannel)
		playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
	else
		logger.info('[radio] %s joined radio %s', plySource, radioChannel)
	end
end

RegisterNetEvent('pma-voice:addPlayerToRadio', addPlayerToRadio)

function removePlayerFromRadio(plySource)
	if plySource == playerServerId then
		logger.info('[radio] Left radio %s, cleaning up.', radioChannel)
		for tgt, _ in pairs(radioData) do
			if tgt ~= playerServerId then
				toggleVoice(tgt, false, 'radio')
			end
		end
		radioNames = {}
		radioData = {}
		Display = {}
		playerTargets(MumbleIsPlayerTalking(PlayerId()) and callData or {})
	else
		toggleVoice(plySource, false)
		if radioPressed then
			logger.info('[radio] %s left radio %s while we were talking, updating targets.', plySource, radioChannel)
			playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
		else
			logger.info('[radio] %s has left radio %s', plySource, radioChannel)
		end
		radioData[plySource] = nil
		if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
			radioNames[plySource] = nil
		end
	end
end

RegisterNetEvent('pma-voice:removePlayerFromRadio', removePlayerFromRadio)

function setRadioChannel(channel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	type_check({channel, "number"})
	TriggerServerEvent('pma-voice:setPlayerRadio', channel)
	radioChannel = channel
	sendUIMessage({
		radioChannel = channel,
		radioEnabled = radioEnabled
	})
	TriggerEvent('win:updateHud', {
		radioChannel = channel
	})
end

exports('setRadioChannel', setRadioChannel)
exports('SetRadioChannel', setRadioChannel)

exports('removePlayerFromRadio', function()
	setRadioChannel(0)
end)

exports('addPlayerToRadio', function(_radio)
	local radio = tonumber(_radio)
	if radio then
		setRadioChannel(radio)
	end
end)

exports('getRadioData', function()
	return radioData
end)

function isDead()
	return LocalPlayer.state.dead
end

RegisterCommand('+radiotalk', function()
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	if isDead() then return end
	if IsPedCuffed(PlayerPedId()) then return end

	if not radioPressed and radioEnabled then
		if radioChannel > 0 then
			logger.info('[radio] Start broadcasting, update targets and notify server.')
			playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
			TriggerServerEvent('pma-voice:setTalkingOnRadio', true)
			radioPressed = true
			playMicClicks(true)
			if GetConvarInt('voice_enableRadioAnim', 0) == 1 and not (GetConvarInt('voice_disableVehicleRadioAnim', 0) == 1 and IsPedInAnyVehicle(PlayerPedId(), false)) then
				RequestAnimDict('random@arrests')
				while not HasAnimDictLoaded('random@arrests') do
					Wait(10)
				end
				TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 1.0, 0, 0, 0)
			end
			CreateThread(function()
				TriggerEvent("pma-voice:radioActive", true)
				while radioPressed do
					Wait(0)
					SetControlNormal(0, 249, 1.0)
					SetControlNormal(1, 249, 1.0)
					SetControlNormal(2, 249, 1.0)
					if LocalPlayer.state.dead then
						ExecuteCommand('-radiotalk')
					end
				end
			end)
		end
	end
end, false)

RegisterCommand('-radiotalk', function()
	if radioChannel > 0 and radioEnabled and radioPressed then
		radioPressed = false
		MumbleClearVoiceTargetPlayers(voiceTarget)
		playerTargets(MumbleIsPlayerTalking(PlayerId()) and callData or {})
		TriggerEvent("pma-voice:radioActive", false)
		playMicClicks(false)
		if GetConvarInt('voice_enableRadioAnim', 0) == 1 then
			if radioChannel > 13 then
				StopAnimTask(PlayerPedId(), "random@arrests", "generic_radio_enter", -4.0)
			else
				StopAnimTask(PlayerPedId(), "amb@code_human_police_investigate@idle_a", "idle_b", -4.0)
			end
		end
		TriggerServerEvent('pma-voice:setTalkingOnRadio', false)
	end
end, false)

if gameVersion == 'fivem' then
	RegisterKeyMapping('+radiotalk', 'Rozmowa przez radio', 'keyboard', GetConvar('voice_defaultRadio', 'LMENU'))
end

function syncRadio(_radioChannel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	radioChannel = _radioChannel
end

RegisterNetEvent('pma-voice:clSetPlayerRadio', syncRadio)