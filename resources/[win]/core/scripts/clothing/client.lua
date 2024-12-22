local defaultVariants = {
    [0] = {
        ['helmet'] = -1,
        ['ears'] = -1,
        ['mask'] = 0,
        ['glasses'] = 5,
        ['chain'] = 0,
        ['bags'] = 0,
        ['torso'] = 15,
        ['tshirt'] = 15,
        ['arms'] = 15,
        ['bproof'] = 0,
        ['pants'] = 61,
        ['shoes'] = 34,
        ['watches'] = -1,
        ['bracelets'] = -1,
    },
    [1] = {
        ['helmet'] = -1,
        ['ears'] = -1,
        ['mask'] = 0,
        ['glasses'] = 5,
        ['chain'] = 0,
        ['bags'] = 0,
        ['torso'] = 15,
        ['tshirt'] = 15,
        ['arms'] = 15,
        ['bproof'] = 0,
        ['pants'] = 15,
        ['shoes'] = 35,
        ['watches'] = -1,
        ['bracelets'] = -1,
    }
}

function OpenClothingMenu()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'win_clothing_menu', {
		title = 'Ubrania',
		align = 'right',
		elements = {
			{label = 'Hełm / Czapka', value = 'helmet'},
			{label = 'Akcesoria na uszy', value = 'ears'},
			{label = 'Maska', value = 'mask'},
			{label = 'Okulary', value = 'glasses'},
			{label = 'Szalik', value = 'chain'},
            {label = 'Torba', value = 'bags'},
			{label = 'Koszulka', value = 'torso'},
			{label = 'Kamizelka', value = 'bproof'},
            {label = 'Spodnie', value = 'pants'},
			{label = 'Buty', value = 'shoes'},
			{label = 'Dodatek lewej ręki', value = 'watches'},
			{label = 'Dodatek prawej ręki', value = 'bracelets'},
		}
	}, function(data, menu)
		TriggerEvent('skinchanger:getSkin', function(skin)
            ClothingMainFunction(data.current.value, skin)
		end)
	end, function(data, menu)
		menu.close()
	end)
end

function ClothingMainFunction(accessory, skin)

    if accessory == 'torso' then
        if skin['torso_1'] and (skin['torso_1'] ~= defaultVariants[skin.sex]['torso'] or skin['tshirt_1'] ~= defaultVariants[skin.sex]['tshirt']) then
            TriggerEvent('skinchanger:loadClothes', skin, {
				['tshirt_1'] = defaultVariants[skin.sex]['tshirt'],
				['tshirt_2'] = 0,
				['torso_1'] = defaultVariants[skin.sex]['torso'],
				['torso_2'] = 0,
				['arms'] = defaultVariants[skin.sex]['arms'],
				['arms_2'] = 0
            })
            TriggerServerEvent('win:setDataClothing', accessory, {
				['torso_1'] = skin['torso_1'],
				['torso_2'] = skin['torso_2'],
				['tshirt_1'] = skin['tshirt_1'],
				['tshirt_2'] = skin['tshirt_2'],
				['arms'] = skin['arms'],
				['arms_2'] = skin['arms_2']
            })
        else
            ESX.TriggerServerCallback('win:getDataClothing', function(save)
                if save then
                    TriggerEvent('skinchanger:loadClothes', skin, {
                        ['torso_1'] = save['torso_1'],
                        ['torso_2'] = save['torso_2'],
                        ['tshirt_1'] = save['tshirt_1'],
                        ['tshirt_2'] = save['tshirt_2'],
                        ['arms'] = save['arms'],
                        ['arms_2'] = save['arms_2']
                    })
                end
            end, accessory)
        end
        return
    end

    if skin[accessory..'_1'] and skin[accessory..'_1'] ~= defaultVariants[skin.sex][accessory] then
        TriggerEvent('skinchanger:loadClothes', skin, {
            [accessory..'_1'] = defaultVariants[skin.sex][accessory],
            [accessory..'_2'] = 0
        })
        TriggerServerEvent('win:setDataClothing', accessory, {
            [accessory..'_1'] = skin[accessory..'_1'],
            [accessory..'_2'] = skin[accessory..'_2']
        })
    elseif skin[accessory..'_1'] and skin[accessory..'_1'] == defaultVariants[skin.sex][accessory] then
        ESX.TriggerServerCallback('win:getDataClothing', function(save)
            if save then
                TriggerEvent('skinchanger:loadClothes', skin, {
                    [accessory..'_1'] = save[accessory..'_1'],
                    [accessory..'_2'] = save[accessory..'_2']
                })
            end
        end, accessory)
    end
end

ESX.RegisterInput('clothing', 'Zdejmowanie/zakładanie ubrań', 'keyboard', 'F10', function()
    if LocalPlayer.state.dead or IsPedCuffed(PlayerPedId()) then
        return
    end

    OpenClothingMenu()
end)