local savedClothings = {
    ['helmet'] = {},
    ['ears'] = {},
    ['mask'] = {},
    ['glasses'] = {},
    ['chain'] = {},
    ['bags'] = {},
    ['torso'] = {},
    ['tshirt'] = {},
    ['arms'] = {},
    ['bproof'] = {},
    ['pants'] = {},
    ['shoes'] = {},
    ['watches'] = {},
    ['bracelets'] = {},
}

RegisterServerEvent('win:setDataClothing')
AddEventHandler('win:setDataClothing', function(accessory, clothTable)
    if accessory then
        if clothTable then
            savedClothings[accessory][source] = clothTable
        end
    end
end)

ESX.RegisterServerCallback('win:getDataClothing', function(source, cb, accessory)
	if savedClothings[accessory][source] then
		cb(savedClothings[accessory][source])
        savedClothings[accessory][source] = nil
	else
		cb(false)
	end
end)