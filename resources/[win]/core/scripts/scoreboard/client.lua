lib = {
	store = {
		player = {},
		dict = 'amb@world_human_clipboard@male@idle_a',
		anim = 'idle_a'
	},
	cache = {
		players = {},
        using = {},
		toggled = false
	},
    func = {}
}

PlayersStats = {}
TogglePlayers = {}

RegisterNetEvent('win:updateStats')
AddEventHandler('win:updateStats', function(stats)
    PlayersStats = stats
end)

RegisterNetEvent('win:toggle')
AddEventHandler('win:toggle', function(toggle)
    TogglePlayers = toggle
end)

lib.func.canSee = function(ped)
    return lib.store.player.admin or IsEntityVisible(ped) == 1
end

lib.func.updateNUI = function(action, value)
    if action == 'job' then
        SendNUIMessage({action = 'update', data = {['job'] = value.label..' - '..(value.name == 'unemployed' and 'Bezrobotny' or value.grade_name)}})
    elseif action == 'counter' then
        SendNUIMessage({action = 'update', data = value})
    elseif action == 'toggle' then
        SendNUIMessage({action = 'toggle', state = lib.cache.toggled})
    end
end

lib.func.globalThread = function(switch)
    lib.store.player.admin = LocalPlayer.state.admin or false
    lib.cache.toggled = switch
    lib.func.spawnProp()

    if lib.cache.toggled then
        lib.func.scrapingThread()
        lib.func.displayThread()
    end
end

lib.func.spawnProp = function()
    lib.func.updateNUI('toggle', lib.cache.toggled)

    if lib.store.player.admin then
        return
    end
    TriggerServerEvent('win-scoreboard:toggle', lib.cache.toggled)


    if lib.cache.toggled then
        if lib.func.canUseAnim(lib.store.player.ped) then
            lib.cache.prop = CreateObject(`p_cs_clipboard`, lib.store.player.coords, false)

            ESX.Streaming.RequestAnimDict(lib.store.dict, function()
                TaskPlayAnim(lib.store.player.ped, lib.store.dict, lib.store.anim, 8.0, -8.0, -1, 1, 0.0, false, false, false)
                AttachEntityToEntity(lib.cache.prop, lib.store.player.ped, GetPedBoneIndex(lib.store.player.ped, 36029), 0.1, 0.015, 0.12, 45.0, -130.0, 180.0, true, false, false, false, 0, true)
                RemoveAnimDict(lib.store.dict)
            end)
        end
    else
        ClearPedTasks(lib.store.player.ped)
        StopAnimTask(lib.store.player.ped, lib.store.dict, lib.store.anim, 1.0)
        DeleteEntity(lib.cache.prop)
    end
end

lib.func.canUseAnim = function(ped)
    if not LocalPlayer.state.dead and
    not IsPedInAnyVehicle(ped, false) and
    not IsPedFalling(ped) and
    not IsPedCuffed(ped) and
    not IsPedDiving(ped) and
    not IsPedInCover(ped, false) and
    not IsPedInParachuteFreeFall(ped) and
    GetPedParachuteState(ped) < 1 then
        return true
    else
        return false
    end
end

lib.func.scrapingThread = function()
    CreateThread(function()
        while lib.cache.toggled do
            for k,v in pairs(GetActivePlayers()) do
                if #(lib.store.player.coords - GetEntityCoords(GetPlayerPed(v))) < (lib.store.player.admin and 60 or 40) then
                    if PlayersStats[tostring(GetPlayerServerId(v))] then
                        lib.cache.players[v] = {id = GetPlayerServerId(v), ped = GetPlayerPed(v), kills = PlayersStats[tostring(GetPlayerServerId(v))].kills, deaths = PlayersStats[tostring(GetPlayerServerId(v))].deaths}
                    else
                        lib.cache.players[v] = {id = GetPlayerServerId(v), ped = GetPlayerPed(v)}
                    end
                else
                    if lib.cache.players[v] then
                        lib.cache.players[v] = nil
                    end
                end
            end

            Wait(500)

            if not lib.store.player.admin and (not IsEntityPlayingAnim(lib.store.player.ped, lib.store.dict, lib.store.anim, 1) and lib.func.canUseAnim(lib.store.player.ped)) then
                lib.func.globalThread(false)
                break
            end
        end
    end)
end

lib.func.displayThread = function()
    CreateThread(function()
        while lib.cache.toggled do
            for k,v in pairs(lib.cache.players) do
                if lib.func.canSee(v.ped) then
                    if PlayersStats[tostring(v.id)] and TogglePlayers[tostring(v.id)] == true then
                        lib.func.drawText3D(v.id..'<br>~g~'..v.kills..'</span>~w~|~r~'..v.deaths..'~w~', GetWorldPositionOfEntityBone(v.ped, GetPedBoneIndex(v.ped, 0x796E)), NetworkIsPlayerTalking(k), 0.95)
                    else
                        lib.func.drawText3D(v.id, GetWorldPositionOfEntityBone(v.ped, GetPedBoneIndex(v.ped, 0x796E)), NetworkIsPlayerTalking(k), 0.75)
                    end
                end
            end

            Wait(1)
        end
    end)
end 

lib.func.drawText3D = function(text, coords, talking, add)
    local color = (talking and {255, 0, 0} or {255, 255, 255})
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z + add)
	local scale = (1 / #(GetFinalRenderedCamCoord() - coords)) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(1.0 * scale, 1.55 * scale)
        SetTextFont(0)
        SetTextColour(color[1], color[2], color[3], 255)
		SetTextCentre(1)

        BeginTextCommandDisplayText('STRING')
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x,_y)
    end
end

lib.func.refreshStates = function()
    lib.store.player.ped = PlayerPedId()
    lib.store.player.coords = GetEntityCoords(lib.store.player.ped)
    lib.store.player.admin = LocalPlayer.state.admin or false
end

CreateThread(function()
    while true do
        lib.func.refreshStates()
        Wait(500)
    end
end)

CreateThread(function()
    Wait(1000)
    lib.func.refreshStates()

    while true do
        Wait(0)
        local sleep = true
        for k,v in pairs(lib.cache.using) do
            if v then
                local player = GetPlayerFromServerId(k)
                local ped = GetPlayerPed(player)

                if ped ~= PlayerPedId() then
                    local coords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 0x796E))

                    if lib.func.canSee(ped) then
                        local dist = #(coords - lib.store.player.coords)
                        if dist <= 50.0 and dist ~= 0.0 then
                            sleep = false
                            lib.func.drawText3D('👑', coords, false, 0.25)
                        end
                    end
                end
            end
        end

        if sleep then
            Wait(500)
        end
    end
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    lib.func.updateNUI('job', job)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    lib.func.updateNUI('job', xPlayer.job)
end)

AddStateBagChangeHandler('counter', 'global', function(name, key, value)
    lib.func.updateNUI('counter', value)
end)

AddStateBagChangeHandler('using', 'global', function(name, key, value)
    lib.cache.using = value
end)

RegisterCommand('+scoreboard', function()
    lib.func.globalThread(true)
end, false)

RegisterCommand('-scoreboard', function()
    lib.func.globalThread(false)
end, false)

RegisterKeyMapping('+scoreboard', 'Lista graczy', 'keyboard', 'Z')

exports('counter', function(key) return GlobalState.counter and GlobalState.counter[key] or 0 end)