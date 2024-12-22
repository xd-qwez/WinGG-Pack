local playersLeft = {}

CreateThread(function()
    while true do
        local sleep = true

        for k, v in pairs(playersLeft) do
            if #(pedData.coords - v.coords) < 15.0 then
                sleep = false
                ESX.Game.Utils.DrawText3D(v.coords, '~r~ID: '..k..' ('..v.name..')~n~~g~Opuścił/a serwer~y~~n~'..v.date, 1.5, 4)
            end
        end

        if sleep then
            Wait(1000)
        else
            Wait(0)
        end
    end
end)

RegisterNetEvent('win:playerLeft')
AddEventHandler('win:playerLeft', function(data)
    playersLeft[data.source] = data

    SetTimeout(120000, function()
        playersLeft[data.source] = nil
    end)
end)