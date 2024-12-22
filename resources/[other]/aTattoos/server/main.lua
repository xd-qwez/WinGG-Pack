--[[
    This file is a part of aTattoos.
    Credits: .akisora (zRevenge - revengeback).
    Copyright (c) 2022 - All rights reserved;
]]

local ESX;
TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj;
end)

RegisterNetEvent('aTattoos:player:requestTattoos');
AddEventHandler('aTattoos:player:requestTattoos', function()
    local _source = source;
    local fetchQuery = "SELECT tattoos FROM `users` WHERE identifier = @identifier";

    local player = ESX.GetPlayerFromId(_source);
    while (not player) do
        Wait(0);
        player = ESX.GetPlayerFromId(_source);
    end

    MySQL.Async.fetchScalar(fetchQuery, { ['@identifier'] = player.identifier }, function(result)
        TriggerClientEvent('aTattoos:player:requestTattoos', _source, (json.decode(result) or {}))
    end)
end)

ESX.RegisterServerCallback('aTattoos:player:manageTattoo', function(source, cb, addState, price, tattoo, playerTattoos, shopId)
    local player = ESX.GetPlayerFromId(source);
    local playerTattoos = (playerTattoos or {});
    local query = "UPDATE `users` SET `tattoos` = @tattoos WHERE identifier = @identifier";

    local strings = {
        [true] = ("~g~Dziękujemy za zakupy w (%s)"):format(TATTOO_SHOPS[shopId].label),
        [false] = "~y~Usunięto tatuaż"
    };

    if (not player) then
        return;
    end

    if (player.getAccount('money').money >= price) then
        player.removeAccountMoney('money', price);

        if (addState) then
            table.insert(playerTattoos, tattoo);
        else
            table.remove(playerTattoos, tattoo);
        end

        MySQL.Sync.execute(query, {
            ['@identifier'] = player.identifier,
            ['@tattoos'] = json.encode(playerTattoos)
        })

        TriggerClientEvent('esx:showNotification', source, strings[addState]);
        cb(true);
    else
        TriggerClientEvent('esx:showNotification', source, "Nie posiadasz wystarczająco pieniędzy")
        cb(false);
    end
end)