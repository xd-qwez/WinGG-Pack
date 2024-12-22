ESX.RegisterServerCallback('win-barbershop:pay', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= Config['barbershop'].Price then
		xPlayer.removeMoney(Config['barbershop'].Price)
		xPlayer.showNotification('Zapłacono '..Config['barbershop'].Price..'$', 'info')
		cb(true)
	elseif xPlayer.getAccount('bank').money >= Config['barbershop'].Price then
		xPlayer.removeAccountMoney('bank', Config['barbershop'].Price)
		xPlayer.showNotification('Zapłacono '..Config['barbershop'].Price..'$ (konto bankowe)', 'info')
		cb(true)
	else
		cb(false)
	end
end)
