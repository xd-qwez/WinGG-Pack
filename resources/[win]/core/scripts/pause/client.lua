local pauseOpened = false

RegisterCommand('openSetting', function()
    OpenPauseMenu()
end, false)

RegisterKeyMapping('openSetting', 'Menu pauzy', 'keyboard', 'ESCAPE')
TriggerEvent('chat:removeSuggestion', '/openSetting')

RegisterNUICallback('button', function(data, cb)
    local frontendMenu = nil
    if data.type == 'settings' then
        frontendMenu = `FE_MENU_VERSION_LANDING_MENU`
    elseif data.type == 'map' then
        frontendMenu = `FE_MENU_VERSION_MP_PAUSE`
    end

    pauseOpened = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'pause-close',
    })

    if frontendMenu and not LocalPlayer.state.dead then
        ActivateFrontendMenu(frontendMenu, 0, -1)
    end
end)

function OpenPauseMenu()
    if not pauseOpened and not IsPauseMenuActive() then
        
        ESX.UI.Menu.CloseAll()

        disablePausemenu()

        SetNuiFocus(true, true)

        SendNUIMessage({
            type = 'pause-open'
        })

        pauseOpened = true
    end
end

function disablePausemenu()
    CreateThread(function()
        while pauseOpened do
            SetPauseMenuActive(false)
            Wait(1)
        end
    end)
end

local function IsPauseActive()
    return pauseOpened
end

exports("IsPauseActive", IsPauseActive)