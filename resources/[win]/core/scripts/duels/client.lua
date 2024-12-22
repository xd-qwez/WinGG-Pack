for k, v in pairs(Config['duels'].SearchLocs) do
	CM.RegisterPlace(v, {}, false,
	function()
		TriggerServerEvent('win-duels:addToQueue')
	end,
	function()
		ESX.HideUI()
	end, function()
		ESX.TextUI('[E] - wyszukiwanie duela')
	end)
end

lastPos = nil

RegisterNetEvent('win-duels:prepare', function(player)
    lastPos = GetEntityCoords(PlayerPedId())
    if player == 1 then
        print('1')
    elseif player == 2 then
        print('2')
    end
end)

RegisterNetEvent('win-duels:end', function()
    ---ESX.Game.Teleport(lastPos)
end)