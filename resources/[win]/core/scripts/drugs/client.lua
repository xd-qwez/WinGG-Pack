local isCollecting = false

RegisterNetEvent("win_drugs:stop", function()
    isCollecting = false
    cancelProgress()
end)

local function drugsAction(zoneType, value)
    if not isCollecting then
        if zoneType == 'field' then
            ESX.TriggerServerCallback('win_drugs:collect', function(count)
                if not isCollecting then
                    isCollecting = true
                    showProgress({title = "Zbieranie", time = count * 1000}, function(isDone)
                        isCollecting = false
                        if isDone then
                            ESX.ShowNotification('Zakończono zbieranie', 'success')
                        else
                            ESX.ShowNotification('Przerwano zbieranie', 'error')
                        end
                        ESX.TriggerServerCallback('win_drugs:stopCollecting', function() end)
                    end)
                end
            end, value.item)
        elseif zoneType == 'process' then
            ESX.TriggerServerCallback('win_drugs:process', function(count)
                if not isCollecting then
                    isCollecting = true
                    showProgress({title = "Przerabianie", time = count * 1000}, function(isDone)
                        isCollecting = false
                        if isDone then
                            ESX.ShowNotification('Zakończono przerabianie', 'success')
                        else
                            ESX.ShowNotification('Przerwano przerabianie', 'error')
                        end
                        ESX.TriggerServerCallback('win_drugs:stopCollecting', function() end)
                    end)
                end
            end, value.item)
        end
    end
end

for narkoType, narkoTable in pairs(Config['drugs']) do
    for zoneType, value in pairs(narkoTable) do

        if value.blip then
            local blip = AddBlipForCoord(value.coords)
            SetBlipSprite(blip, value.blip.sprite)
            SetBlipScale(blip, value.blip.scale)
            SetBlipColour(blip, value.blip.colour)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(value.title)
            EndTextCommandSetBlipName(blip)
        end

        CM.RegisterPlace(value.coords, {type = 1, size = vector3(5.0, 5.0, 1.0)}, value.text,
        function()
            if not LocalPlayer.state.dead then
                drugsAction(zoneType, value)
            end
        end,
        function()
            if isCollecting then
                ESX.UI.Menu.CloseAll()
                cancelProgress()
            end
        end)
    end
end

AddEventHandler('esx:onPlayerDeath', function()
    if isCollecting then
        ESX.UI.Menu.CloseAll()
        cancelProgress()
    end
end)