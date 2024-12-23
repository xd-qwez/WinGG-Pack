local wasProximityDisabledFromOverride = false
local isDead = false
disableProximityCycle = false
RegisterCommand('setvoiceintent', function(source, args)
	if GetConvarInt('voice_allowSetIntent', 1) == 1 then
		local intent = args[1]
		if intent == 'speech' then
			MumbleSetAudioInputIntent(`speech`)
		elseif intent == 'music' then
			MumbleSetAudioInputIntent(`music`)
		end
		LocalPlayer.state:set('voiceIntent', intent, true)
	end
end)

RegisterCommand('vol', function(_, args)
	if not args[1] then
		return
	end
	setVolume(tonumber(args[1]) or 100)
end)

exports('setAllowProximityCycleState', function(state)
	type_check({state, "boolean"})
	disableProximityCycle = state
end)

function setProximityState(proximityRange, isCustom)
	local voiceModeData = Cfg.voiceModes[mode]
	MumbleSetTalkerProximity(proximityRange + 0.0)
	LocalPlayer.state:set('proximity', {
		index = mode,
		distance = proximityRange,
		mode = isCustom and "Custom" or voiceModeData[2],
	}, true)
	sendUIMessage({
		voiceMode = isCustom and #Cfg.voiceModes or mode - 1
	})
	TriggerEvent('wingg:updateHud', {
		voiceName = isCustom and #Cfg.voiceModes or mode - 1
	})
end

exports("overrideProximityRange", function(range, disableCycle)
	type_check({range, "number"})
	setProximityState(range, true)
	if disableCycle then
		disableProximityCycle = true
		wasProximityDisabledFromOverride = true
	end
end)

exports("clearProximityOverride", function()
	local voiceModeData = Cfg.voiceModes[mode]
	setProximityState(voiceModeData[1], false)
	if wasProximityDisabledFromOverride then
		disableProximityCycle = false
	end
end)

RegisterCommand('cycleproximity', function()
	if GetConvarInt('voice_enableProximityCycle', 1) ~= 1 or disableProximityCycle then return end
	if isDead then return end
	local newMode = mode + 1

	if newMode <= #Cfg.voiceModes then
		mode = newMode
	else
		mode = 1
	end

	setProximityState(Cfg.voiceModes[mode][1], false)
	TriggerEvent('pma-voice:setTalkingMode', mode)
end, false)

if gameVersion == 'fivem' then
	RegisterKeyMapping('cycleproximity', 'Zmiana zasięgu mówienia', 'keyboard', GetConvar('voice_defaultCycle', 'F11'))
end

AddEventHandler('playerSpawned', function()
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
	mode = 2
	setProximityState(Cfg.voiceModes[mode][1], false)
	TriggerEvent('pma-voice:setTalkingMode', mode)
end)