local currentMsgIndex = 0
local unsubscribedIds = {}

RegisterNetEvent('win-announcements:SetPlayerUnsubscribed', function(value)
    local src = tostring(source)
    unsubscribedIds[src] = (value == true and true or nil)
end)

CreateThread(function()
    while true do
        Wait(3 * 60000)
        currentMsgIndex = (currentMsgIndex % #Config['announcements'].Messages) + 1
        local message = Config['announcements'].Messages[currentMsgIndex]

        for k, v in pairs(GetPlayers()) do
            if not unsubscribedIds[v] then
                TriggerClientEvent('win:chatMessage', v, 'rgb(255, 215, 0)', 'fa-solid fa-megaphone', 'AUTOMATYCZNE OGŁOSZENIE', message)
            end
        end
    end
end)

AddEventHandler('playerDropped', function()
    local src = tostring(source)
    unsubscribedIds[src] = nil
end)