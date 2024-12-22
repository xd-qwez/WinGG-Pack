InZone = false
CenterZone = vector3(-6.9176, -2572.9133, 6.0049)

CreateThread(function()
    while true do
        Wait(1000)
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), CenterZone, true) <= 620.0 then
            if not InZone then
                ESX.ShowNotification('Znajdujesz się w strefie bez lootowania')
                InZone = true
            end
        else
            if InZone then
                ESX.ShowNotification('Opuszczasz strefę bez lootowania')
                InZone = false
            end
        end
    end
end)

function InLootZone()
    return InZone
end