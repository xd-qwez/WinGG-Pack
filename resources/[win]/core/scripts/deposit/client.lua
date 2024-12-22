CreateThread(function()
    local pedModel = `s_m_m_ammucountry`

    RequestModel(pedModel)
	while not HasModelLoaded(pedModel) do
	  Wait(100)
	end

    for k, v in pairs(Config['deposit'].Zones) do
        local ped = CreatePed(5, pedModel, v.x, v.y, v.z, v.w, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedCanRagdollFromPlayerImpact(ped, false)
    end

end)

for i, v in ipairs(Config['deposit'].Zones) do
	CM.RegisterPlace(v, {size = vector3(2.0, 2.0, 0.3)}, "otworzyć schowek",
	function()
		if not IsPedInAnyVehicle(PlayerPedId(), false) then
		    depositOptions()
        end
	end,
	function()
		ESX.UI.Menu.CloseAll()
	end)
end

function depositOptions()
    local elements = {
        {label = 'Wyjmij przedmioty',  value = 'deposit_inventory'},
        {label = 'Włóż przedmioty', value = 'player_inventory'},
        {label = 'Ubrania', value = 'clothes'},
		{label = 'Kup ubrania', value = 'buy_clothes'},
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'deposit', {
		title    = 'Schowek',
		align    = 'center',
		elements = elements
    }, function(data, menu)
        menu.close()
		if data.current.value == 'deposit_inventory' then
			OpenDepositInventoryMenu()
		elseif data.current.value == 'player_inventory' then
            OpenPlayerInventoryMenu()
        elseif data.current.value == 'clothes' then
            PlayerDressings()
		elseif data.current.value == 'buy_clothes' then
			exports['esx_clotheshop']:OpenShopMenu()
        end
    end, function(data, menu)
		menu.close()
	end)
end

function OpenDepositInventoryMenu()
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback('win_deposits:getDepositInventory', function(inventory)
        local foundDepositItems = false

        if (inventory.items and #inventory.items > 0) or (inventory.money and inventory.money > 0) then
            foundDepositItems = true
        end

        if foundDepositItems then

			local elements = {}

            if inventory.money > 0 then
                table.insert(elements, {
                    label = 'Pieniądze ' .. ESX.Math.GroupDigits(inventory.money) .. '$',
                    type = 'item_account',
                    value = 'money'
                })
            end

            for i=1, #inventory.items, 1 do
                local item = inventory.items[i]

                if item.count > 0 then
                    table.insert(elements, {
                        label = item.label .. ' x' .. item.count,
                        type = 'item_standard',
                        value = item.item
                    })
                end
            end

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'deposit_inventory', {
                title    = 'Schowek',
                align    = 'center',
                elements = elements
            }, function(data, menu)
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_get_item_count', {
                    title = 'Ilość'
                }, function(data2, menu2)
                    local quantity = tonumber(data2.value)
                    if not quantity then
                        ESX.ShowNotification('Nieprawidłowa ilość', 'error')
                    else
                        TriggerServerEvent('win_deposits:getItem', data.current.type, data.current.value, quantity)
                        menu2.close()
                        ESX.SetTimeout(300, function()
                            OpenDepositInventoryMenu()
                        end)
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            end, function(data, menu)
                menu.close()
                depositOptions()
            end)
        else
            ESX.ShowNotification('Nie posiadasz przedmiotów w schowku', 'error')
        end
	end)
end

function OpenPlayerInventoryMenu()
	ESX.TriggerServerCallback('win_deposits:getPlayerInventory', function(inventory)
		local elements = {}

		if inventory.money > 0 then
			table.insert(elements, {
				label = 'Pieniądze: ' .. ESX.Math.GroupDigits(inventory.money) .. '$',
				type  = 'item_account',
				value = 'money'
			})
		end

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type  = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'deposit_player_inventory', {
			title    = 'Schowek',
			align    = 'center',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_put_item_count', {
				title = 'Ilość'
			}, function(data2, menu2)
				local quantity = tonumber(data2.value)

				if not quantity then
					ESX.ShowNotification('Nieprawidłowa ilość', 'error')
				else
					menu2.close()

                    TriggerServerEvent('win_deposits:putItem', data.current.type, data.current.value, quantity)

					ESX.SetTimeout(300, function()
						OpenPlayerInventoryMenu()
					end)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
			depositOptions()
		end)
	end)
end

function PlayerDressings()
	ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dress_menu',
	{
		title    = 'Twoja Garderoba',
		align    = 'center',
		elements = {
            {label = "Ubrania", value = 'player_dressing'},
	        {label = "Usuń ubranie", value = 'remove_cloth'}
        }
	}, function(data, menu)

		if data.current.value == 'player_dressing' then 
			ESX.TriggerServerCallback('win-dressings:getPlayerDressing', function(dressing)
				local elements = {}
				for k, v in pairs(dressing) do
				  table.insert(elements, {label = v, value = k})
				end

				if #elements > 0 then
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
						title    = 'Ubrania',
						align    = 'center',
						elements = elements,
					}, function(data2, menu2)
						TriggerEvent('skinchanger:getSkin', function(skin)
							ESX.TriggerServerCallback('win-dressings:getPlayerOutfit', function(clothes)
								TriggerEvent('skinchanger:loadClothes', skin, clothes)
								TriggerEvent('esx_skin:setLastSkin', skin)

								TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
								end)
							end, data2.current.value)
						end)
					end, function(data2, menu2)
						menu2.close()
					end)
				else
					ESX.ShowNotification('Brak zapisanych strojów', 'error')
				end
			end)
		elseif data.current.value == 'remove_cloth' then
			ESX.TriggerServerCallback('win-dressings:getPlayerDressing', function(dressing)
				local elements = {}
				for k, v in pairs(dressing) do
					table.insert(elements, {label = v, value = k})
				end

				if #elements > 0 then
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth',
					{
						title    = 'Usuń ubrania',
						align    = 'center',
						elements = elements,
					},
					function(data2, menu2)
						menu2.close()
						TriggerServerEvent('win-dressings:removeOutfit', data2.current.value)
						ESX.ShowNotification('Ubranie zostało usunięte z twojej garderoby', 'success')
					end,
					function(data2, menu2)
						menu2.close()
					end)
				else
					ESX.ShowNotification('Brak zapisanych strojów', 'error')
				end
			end)
		end
	end, function(data, menu)
        menu.close()
	end)
end

exports('PlayerDressings', PlayerDressings)