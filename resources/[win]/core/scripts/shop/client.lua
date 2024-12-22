CreateThread(function()

    RequestModel(`mp_m_shopkeep_01`)
	while not HasModelLoaded(`mp_m_shopkeep_01`) do
	  Wait(100)
	end

    for k, v in pairs(Config['shops'].coords) do
        local ped = CreatePed(5, `mp_m_shopkeep_01`, v.x, v.y, v.z, v.w, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedCanRagdollFromPlayerImpact(ped, false)
    end

end)

for i, v in ipairs(Config['shops'].coords) do
	CM.RegisterPlace(v, {size = vector3(2.0, 2.0, 0.3)}, "otworzyć sklep",
	function()
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
		    OpenShopInventory()
        end
	end,
	function()
		ESX.UI.Menu.CloseAll()
	end)
end

RegisterCommand("sklep", function ()
    if exports["core"]:isInGreenzone() then
        OpenShopInventory()
    else
        TriggerEvent('win:showNotification', {
            type = 'error',
            title = 'Sklep',
            text = 'Nie możesz otworzyć sklepu poza greenzonem'
        })
    end
end,false)

function OpenShopInventory()
    local elements = {}

    for k, v in pairs(Config['shops'].shopItems) do
        table.insert(elements, {label = v.label..' - <span style="color:green;">'..v.price..'$</span>', value = v.item})
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'win_shop', {
		title    = 'Sklep',
		align    = 'center',
		elements = elements
    }, function(data, menu)
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'win_shop_count', {
            title = 'Ilość'
        }, function(data2, menu2)
            local count = tonumber(data2.value)

            if not count then
                TriggerEvent('win:showNotification', {
                    type = 'error',
                    title = 'Sklep',
                    text = 'Błędna ilość'
                })
            else
                menu2.close()
                menu.close()
                TriggerServerEvent('win_shop:buyItem', data.current.value, count)
            end
        end, function(data2, menu2)
            menu2.close()
        end)
    end, function(data, menu)
		menu.close()
	end)
end