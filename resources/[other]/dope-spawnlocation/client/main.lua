local spawns = {
    [1] = {coords = vector3(1008.9121, -2512.7402, 28.3019), label = "Doki"},
    [2] = {coords = vector3(2535.1987, 2613.3594, 37.9572), label = "Elektrownia"},
}

local Cam = false

RegisterNetEvent("dope-spawnmanager:open")
AddEventHandler("dope-spawnmanager:open", function(bool, pos)
    isFirst = bool
    local playerPed = PlayerPedId()
    SetEntityVisible(playerPed, false)
    SendNUIMessage({ data = spawns, lastpos = pos })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("close", function(data)
    SetNuiFocus(false, false)
    Cam = false
    SetEntityVisible(PlayerPedId(), true)
end)

RegisterNUICallback("spawn", function(data)
    SetNuiFocus(false, false)
    TriggerEvent("dope-spawnmanager:spawnPlayer", data.coords)
end)

RegisterNetEvent("dope-spawnmanager:spawnPlayer")
AddEventHandler("dope-spawnmanager:spawnPlayer", function(coords)
   if type(coords) == "string" then
    coords = json.decode(coords)
   end
    DoScreenFadeOut(200)
    Citizen.Wait(1550)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
    Cam = false
    SetEntityVisible(PlayerPedId(), true)
    Citizen.Wait(550)
    DoScreenFadeIn(2500)
end)