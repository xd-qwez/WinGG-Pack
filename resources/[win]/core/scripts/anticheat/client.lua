RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    HitboxCheck()
    MetaDMGBoostCheck()
end)

function HitboxCheck()
    CreateThread(function()
        local models = {
            [`mp_m_freemode_01`] = {
                vector3(-0.6095175, -0.25, -1.3),
                vector3(0.6099811, 0.25, 0.945)
            },
            [`mp_f_freemode_01`] = {
                vector3(-0.6095175, -0.25, -1.3),
                vector3(0.6099811, 0.25, 0.945)
            },
        }
        for modelHash, coords in pairs(models) do

            ESX.Streaming.RequestModel(modelHash)

            local val1, val2 = GetModelDimensions(modelHash)
            if tostring(coords[1]) ~= tostring(val1) or tostring(coords[2]) ~= tostring(val2) then
                TriggerServerEvent('win:1Q3t2j5doL9jLon', 'hitbox')
                break
            end
        end
    end)
end

function MetaDMGBoostCheck()
    CreateThread(function()
        local weapons = {
            `COMPONENT_PISTOL_CLIP_01`,
            `COMPONENT_PISTOL_CLIP_02`,
            `COMPONENT_COMBATPISTOL_CLIP_01`,
            `COMPONENT_COMBATPISTOL_CLIP_02`,
            `COMPONENT_VINTAGEPISTOL_CLIP_01`,
            `COMPONENT_VINTAGEPISTOL_CLIP_02`,
            `COMPONENT_SNSPISTOL_CLIP_01`,
            `COMPONENT_SNSPISTOL_CLIP_02`,
        }

        for i = 1, #weapons do
            local dmg_mod = GetWeaponComponentDamageModifier(weapons[i])
            local accuracy_mod = GetWeaponComponentAccuracyModifier(weapons[i])
            if dmg_mod > 1.1 or accuracy_mod > 1.2 then
                TriggerServerEvent('win:1Q3t2j5doL9jLon', 'metadmg')
                break
            end
        end
    end)
end

local blockedModels = {
	[`buzzard`] = true,
	[`buzzard2`] = true,
	[`lazer`] = true,
}

AddEventHandler('gameEventTriggered', function(event, args)
    if event == 'CEventNetworkEntityDamage' then
        local victim, attacker = args[1], args[2]
        if IsPedAPlayer(victim) then
            if attacker == PlayerPedId() and not IsPedInAnyVehicle(attacker, false) then
                local weaponHash = GetSelectedPedWeapon(attacker)
                if weaponHash ~= `WEAPON_UNARMED` then
                    local allowedWeapon = ESX.IsWeaponAItem(weaponHash)
                    if not allowedWeapon then
                        TriggerServerEvent('win:1Q3t2j5doL9jLon', 'weaponSpawn', weaponHash)
                    else
                        if ESX.SearchInventory(allowedWeapon, true) <= 0 then
                            TriggerServerEvent('win:1Q3t2j5doL9jLon', 'weaponSpawn', weaponHash)
                        end
                    end
                end
            end
        end
    elseif event == 'CEventNetworkPlayerEnteredVehicle' then
        local vehicle = args[2]
        if blockedModels[GetEntityModel(vehicle)] then
            DeleteEntity(vehicle)
        end
    end
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    TriggerServerEvent('win:1Q3t2j5doL9jLon', 'clientStart', resourceName)
end)

AddEventHandler('onResourceStop', function(resourceName)
    TriggerServerEvent('win:1Q3t2j5doL9jLon', 'clientStop', resourceName)
end)