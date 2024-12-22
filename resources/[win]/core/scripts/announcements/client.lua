RegisterCommand('ogloszenia', function(src, args, raw)
    local disabled = GetResourceKvpString('win-aa:toggled') == 'true'
    disabled = not disabled

    ESX.ShowNotification(disabled and 'Wyłączono automatyczne ogłoszenia' or 'Włączono automatyczne ogłoszenia', 'info')

    SetResourceKvp('win-aa:toggled', tostring(disabled))
    TriggerServerEvent('win-announcements:SetPlayerUnsubscribed', disabled)
end)

CreateThread(function()
    TriggerServerEvent('win-announcements:SetPlayerUnsubscribed', GetResourceKvpString('win-aa:toggled') == 'true')
    TriggerEvent('chat:addSuggestion', 'ogloszenia', 'Włącz/Wyłącz automatyczne ogłoszenia na czacie')
end)