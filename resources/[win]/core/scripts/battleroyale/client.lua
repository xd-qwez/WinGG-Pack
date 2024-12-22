local battleroyale
local battleroyaleData = {}
local blip

RegisterNetEvent("battleroyale:start", function(bool, size, time)
    battleroyale = bool
    if bool then
        NetworkSetFriendlyFireOption(false)
        battleroyaleData = {size = size, time = time}
        for i = 10, 1, -1 do
            ESX.Scaleform.ShowFreemodeMessage('~r~'..i, '', 1)
        end
        ESX.Scaleform.ShowFreemodeMessage('~r~Start!', '', 3)
        NetworkSetFriendlyFireOption(true)
    else
        ESX.Scaleform.ShowFreemodeMessage('~r~Battle Royale rozpoczął się', 'Nie zbliżaj się do cayo', 7)
    end

    if battleroyale then
        CreateThread(function ()
            while battleroyale do
                DrawMarker(28, Config['battleroyale'].coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, battleroyaleData.size, battleroyaleData.size, battleroyaleData.size, 0, 110, 255, 100, false, true, 2, false, false, false, false)
                Wait(0)
            end
        end)

        while battleroyale do
            local ped = PlayerPedId()
            if #(GetEntityCoords(ped) - Config['battleroyale'].coords) > battleroyaleData.size then
                SetEntityHealth(ped, GetEntityHealth(ped) - 1)
            end

            battleroyaleData.size = battleroyaleData.size - ((battleroyaleData.size > 100 and Config['battleroyale'].cutZoneSize or (Config['battleroyale'].cutZoneSize / 2)) / (battleroyaleData.time * 10))
            blip = AddBlipForRadius(Config['battleroyale'].coords, battleroyaleData.size)
            SetBlipColour(blip, 3)
		    SetBlipAlpha(blip, 100)

            Wait(100)
            RemoveBlip(blip)
        end
    else
        while battleroyale == false do
            local ped = PlayerPedId()
            local dist = #(GetEntityCoords(ped) - Config['battleroyale'].coords)
            if dist < Config['battleroyale'].cutZoneSize then
                SetEntityHealth(ped, GetEntityHealth(ped) - 1)
            end
            Wait(100)
        end
    end
end)

RegisterNetEvent("battleroyale:end", function(player)
    battleroyale = nil
    RemoveBlip(blip)
    ESX.Scaleform.ShowFreemodeMessage('~r~Event wygrał: '..player, '', 7)
end)

RegisterNetEvent("battleroyale:tp", function()
    battleroyale = nil
    RemoveBlip(blip)
    ESX.ShowNotification('Teleport nastąpi za 10 sekund', 'info')
    ESX.Scaleform.ShowFreemodeMessage('~r~Ale z ciebie bambik', 'Teleport nastąpi za 10 sekund', 5)
    Wait(5*1000)
    ESX.Game.Teleport(PlayerPedId(), vector3(1008.0433, -2521.7927, 28.3076))
    Wait(1000)
    TriggerEvent('esx_ambulancejob:revive')
end)