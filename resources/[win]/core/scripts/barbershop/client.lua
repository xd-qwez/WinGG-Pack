local hasPaid = false

local function OpenShopMenu()
	hasPaid = false

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		menu.close()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = 'Potwierdzasz zakup?',
			align = 'right',
			elements = {
				{label = 'Tak', value = 'yes'},
				{label = 'Nie',  value = 'no'}
		}}, function(data, menu)
			menu.close()

			if data.current.value == 'yes' then
				ESX.TriggerServerCallback('win-barbershop:pay', function(paid)
					if paid then
						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
						end)
						hasPaid = true
					else
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin) 
						end)

						ESX.ShowNotification('Nie posiadasz wystarczająco pieniędzy')
					end
				end)
			elseif data.current.value == 'no' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, function(data, menu)
		menu.close()
	end, {
		'beard_1',
		'beard_2',
		'beard_3',
		'beard_4',
		'hair_1',
		'hair_2',
		'hair_color_1',
		'hair_color_2',
		'eyebrows_1',
		'eyebrows_2',
		'eyebrows_3',
		'eyebrows_4',
		'makeup_1',
		'makeup_2',
		'makeup_3',
		'makeup_4',
		'lipstick_1',
		'lipstick_2',
		'lipstick_3',
		'lipstick_4',
		'ears_1',
		'ears_2',
	})
end

for k, v in pairs(Config['barbershop'].Shops) do
	CM.RegisterPlace(v, {}, false,
	function()
		OpenShopMenu()
	end,
	function()
		ESX.HideUI()
		ESX.UI.Menu.CloseAll()
		if not hasPaid then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end
	end, function()
		ESX.TextUI('[E] - skorzystanie z usług fryzjera')
	end)
end

CreateThread(function()
	for k, v in pairs(Config['barbershop'].Shops) do
		local blip = AddBlipForCoord(v)

		SetBlipSprite(blip, 71)
		SetBlipColour(blip, 0)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Fryzjer')
		EndTextCommandSetBlipName(blip)
	end
end)