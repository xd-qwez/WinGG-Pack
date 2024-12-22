RegisterNetEvent('win:syncAccepted', function(requester, id)
    local accepted = source
    
    TriggerClientEvent('win:playSynced', accepted, requester, id, 'Accepter')
    TriggerClientEvent('win:playSynced', requester, accepted, id, 'Requester')
end)

RegisterNetEvent('win:requestSynced', function(target, id)
    local requester = source

	TriggerClientEvent('esx:showNotification', requester, 'Wysłano propozycję animacji do '..target, 'success')
	TriggerClientEvent('win:syncRequest', target, requester, id)
end)

RegisterNetEvent('win:cancelSync', function(requester)
	TriggerClientEvent('esx:showNotification', requester, 'Osoba odrzuciła propozycję wspólnej animacji', 'info')
end)

RegisterNetEvent('win:requestSyncedCarry', function(target, carryType)
    TriggerClientEvent('win:requestClientSyncedCarry', target, source, carryType)
end)

RegisterNetEvent('win:answerSyncedCarry', function(sender, carryType)
    TriggerClientEvent('win:playSyncedCarry', sender, source, carryType, 'sender')
    TriggerClientEvent('win:playSyncedCarry', source, sender, carryType)
end)

RegisterNetEvent('win:cancelSyncedCarry', function(target)
    TriggerClientEvent('win:cancelClientSyncedCarry', target)
end)