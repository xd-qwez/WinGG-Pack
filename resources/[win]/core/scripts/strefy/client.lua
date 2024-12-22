local currentHour
local activeStrefa = {}
local activeBlip = {}
local activeRadiusBlip = {}
local isCapturing
local UsedStrefa = {}

RegisterNetEvent("strefy:currentHour", function(hour, usedStrefa)

    while ESX.PlayerData == nil or ESX.PlayerData.job == nil or ESX.PlayerData.job.name == nil do
        Wait(100)
    end

    UsedStrefa = usedStrefa

    for strefaID, _ in pairs(UsedStrefa) do
        if DoesBlipExist(activeBlip[strefaID]) then
            RemoveBlip(activeBlip[strefaID])
        end

        if DoesBlipExist(activeRadiusBlip[strefaID]) then
            RemoveBlip(activeRadiusBlip[strefaID])
        end
    end

    if string.find(ESX.PlayerData.job.name, "org") and currentHour ~= hour then

        for strefaID, blip in pairs(activeBlip) do
            if DoesBlipExist(blip) then
                RemoveBlip(blip)
            end
        end

        for strefaID, blip in pairs(activeRadiusBlip) do
            if DoesBlipExist(blip) then
                RemoveBlip(blip)
            end
        end

        activeBlip = {}
        activeRadiusBlip = {}

        for i = 1, #Config["strefy"].Zones do
            for j = 1, #Config["strefy"].Zones[i].hours do
                if Config["strefy"].Zones[i].hours[j] == hour then
                    activeStrefa[i] = Config["strefy"].Zones[i].coords
                    activeBlip[i] = AddBlipForCoord(Config["strefy"].Zones[i].coords)

                    SetBlipSprite(activeBlip[i], 437)
                    SetBlipColour(activeBlip[i], 70)
                    SetBlipAsShortRange(activeBlip[i], true)

                    BeginTextCommandSetBlipName('STRING')
                    AddTextComponentSubstringPlayerName('Aktywna Strefa')
                    EndTextCommandSetBlipName(activeBlip[i])

                    SetBlipInfoTitle(activeBlip[i], "Strefa", false)
                    AddBlipInfoIcon(activeBlip[i], "INFO:", "strefy", 4, 0, true)

                    local tempHour = hour + 1
                    if hour == 0 then
                        tempHour = 24
                    end

                    AddBlipInfoHeader(activeBlip[i], "DOSTĘPNA DO:", tempHour..":00")
                    --AddBlipInfoName(activeBlip[i], "TOP:", "[1] zjeby, [2] Czesionny, [3] omegaZjeby")

                    activeRadiusBlip[i] = AddBlipForRadius(Config["strefy"].Zones[i].coords, 60.0)
                    SetBlipColour(activeRadiusBlip[i], 70)
                    SetBlipAlpha(activeRadiusBlip[i], 100)
                end
            end
        end

        if type(currentHour) == "number" then
            local dist
            local nearestCoords
            for strefaID, coords in pairs(activeStrefa) do
                if not nearestCoords or #(GetEntityCoords(PlayerPedId()) - coords) < dist then
                    nearestCoords = coords
                    dist = #(GetEntityCoords(PlayerPedId()) - coords)
                end
            end

            TriggerEvent('win:showNotification', {
                type = 'info',
                title = 'Strefy',
                text = 'Dostępne strefy, zmieniły się'
            })
        end

        currentHour = hour
    end
end)

RegisterNetEvent("strefy:UsedStrefa", function(usedStrefa)
    UsedStrefa = usedStrefa
    for strefaID, _ in pairs(UsedStrefa) do
        if DoesBlipExist(activeBlip[strefaID]) then
            RemoveBlip(activeBlip[strefaID])
        end

        if DoesBlipExist(activeRadiusBlip[strefaID]) then
            RemoveBlip(activeRadiusBlip[strefaID])
        end
    end
end)

local function startCapture(strefaID)
    if not isCapturing then
        ESX.TriggerServerCallback("strefy:captureStrefa", function()
            isCapturing = strefaID
            showProgress({title = 'Przejmowanie strefy', time = 5*60*1000}, function(isDone)
                if isDone then
                    ESX.TriggerServerCallback("strefy:finishCaptureStrefa", function()
                        isCapturing = nil
                    end, strefaID)
                else
                    ESX.TriggerServerCallback("strefy:emptyCaptureStrefa", function()
                        isCapturing = nil
                    end, strefaID)
                end
            end)
        end, strefaID)
    end
end

for k, v in pairs(Config["strefy"].Zones) do
	CM.RegisterPlace(v.coords, {size = vector3(v.size, v.size, 0.3)}, "przejąć strefe", function()
		if ESX.PlayerData.job then
			if string.find(ESX.PlayerData.job.name, "org") then
                if not LocalPlayer.state.dead then
                    if UsedStrefa[k] then
                        TriggerEvent('win:showNotification', {
                            type = 'error',
                            title = 'Strefy',
                            text = 'Ta strefa została już przejęta'
                        })
                    elseif activeStrefa[k] then
                        ESX.TriggerServerCallback("orgs:IsSuspended", function(time)
                            if not time then
                                startCapture(k)
                            else
                                TriggerEvent('win:showNotification', {
                                    type = 'error',
                                    title = 'Strefy',
                                    text = "Twoja org została zawieszona, do: "..time
                                })
                            end
                        end)
                    else
                        local dist
                        local nearestCoords
                        for strefaID, coords in pairs(activeStrefa) do
                            if not nearestCoords or #(GetEntityCoords(PlayerPedId()) - coords) < dist then
                                nearestCoords = coords
                                dist = #(GetEntityCoords(PlayerPedId()) - coords)
                            end
                        end

                        if nearestCoords then
                            CreateThread(function ()
                                TriggerEvent('win:showNotification', {
                                    type = 'error',
                                    title = 'Strefy',
                                    text = 'Ta strefa nie jest aktualnie dostępna',
                                    duration = 5000
                                })
                                Wait(6000)
                                SetNewWaypoint(nearestCoords.x, nearestCoords.y)
                                TriggerEvent('win:showNotification', {
                                    type = 'info',
                                    title = 'Strefy',
                                    text = 'Na mapie została zaznaczona najbliższa strefa',
                                })
                            end)
                        end
                    end
                end
			elseif string.find(ESX.PlayerData.job.name, "police") then
                TriggerEvent('win:showNotification', {
                    type = 'error',
                    title = 'Strefy',
                    text = 'Wypierdalaj psiaku, nie dla ciebie to',
                })
			else
                TriggerEvent('win:showNotification', {
                    type = 'error',
                    title = 'Strefy',
                    text = 'Musisz być w organizacji',
                })
			end
		end
	end,
	function()
		if isCapturing then
            cancelProgress()
            isCapturing = nil
        end
	end,
	function()

	end)
end

AddEventHandler('esx:onPlayerDeath', function()
    if isCapturing then
        ESX.TriggerServerCallback("strefy:emptyCaptureStrefa", function()
            cancelProgress()
            isCapturing = nil
        end, isCapturing)
    end
end)