RegisterNetEvent('InteractSound_SV:PlayOnOne')
AddEventHandler('InteractSound_SV:PlayOnOne', function(clientNetId, soundFile, soundVolume)
  local src = source
  print(('[interact-sound] [^3WARNING^7] %s attempted to trigger InteractSound_SV:PlayOnOne'):format(GetPlayerName(src)))
end)

RegisterNetEvent('InteractSound_SV:PlayOnSource')
AddEventHandler('InteractSound_SV:PlayOnSource', function(soundFile, soundVolume)
    TriggerClientEvent('InteractSound_CL:PlayOnOne', source, soundFile, soundVolume)
end)

RegisterNetEvent('InteractSound_SV:PlayOnAll')
AddEventHandler('InteractSound_SV:PlayOnAll', function(soundFile, soundVolume)
  local src = source
  print(('[interact-sound] [^3WARNING^7] %s attempted to trigger InteractSound_SV:PlayOnAll'):format(GetPlayerName(src)))
end)

RegisterNetEvent('InteractSound_SV:PlayWithinDistance')
AddEventHandler('InteractSound_SV:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
  local src = source
  local DistanceLimit = 40
  if maxDistance < DistanceLimit then
    TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, GetEntityCoords(GetPlayerPed(src)), maxDistance, soundFile, soundVolume)
  else
    print(('[interact-sound] [^3WARNING^7] %s attempted to trigger InteractSound_SV:PlayWithinDistance over the distance limit ' .. DistanceLimit):format(GetPlayerName(src)))
  end
end)
