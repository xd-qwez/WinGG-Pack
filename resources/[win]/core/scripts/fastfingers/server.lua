local currentGame, currentWord, currentPrize = false, nil, 0
local maxPrize = 100

local function generateWord()
    local upperCase = "ABCDEFGHJKMNPQRSTUVWXYZ"
    local lowerCase = "abcdefghjkmnpqrstuvwxyz"
    local numbers = "123456789"
    
    local characterSet = upperCase .. lowerCase .. numbers
    
    local keyLength = 16
    local output = ""
    
    for	i = 1, keyLength do
        local rand = math.random(#characterSet)
        output = output .. string.sub(characterSet, rand, rand)
    end

    return output
end

local function startGame(prize)
    currentGame = true
    TriggerClientEvent('win:chatMessage', -1, 'rgb(255, 215, 0)', 'fa-solid fa-hand', 'SZYBKIE PALCE', 'Za 30 sekund pojawi się kod! Kto pierwszy go przepisze otrzyma '..prize..' gold coins!')
    ESX.SetTimeout(30000, function()
        currentWord = generateWord()
        currentPrize = prize
        TriggerClientEvent('win:chatMessage', -1, 'rgb(255, 215, 0)', 'fa-solid fa-hand', 'SZYBKIE PALCE', '/kod '..currentWord)
    end)
end

ESX.RegisterCommand('kod', 'user', function(xPlayer, args, showError)
    if currentGame then
        if currentWord then
            if currentWord == args.code then
                xPlayer.showNotification('Gratulacje, wygrano '..currentPrize..' gold coins z gry szybkie palce', 'info')
                TriggerClientEvent('win:chatMessage', -1, 'rgb(255, 215, 0)', 'fa-solid fa-hand', 'SZYBKIE PALCE', 'Gracz '..xPlayer.name..' przepisał/a kod jako pierwszy/a, zgarnia '..currentPrize..' gold coins')
                exports['win-cases']:AddCoins(xPlayer.source, currentPrize)
                currentGame, currentWord, currentPrize = false, nil, 0
            else
                xPlayer.showNotification('Podany kod jest nieprawidłowy', 'error')
            end
        else
            xPlayer.showNotification('Kod nie został jeszcze podany', 'error')
        end
    else
        xPlayer.showNotification('Aktualnie nie trwa gra w szybkie palce', 'error')
    end
end, false, {help = 'Wpisz kod z gry szybkie palce', validate = true, arguments = {
    {name = 'code', help = 'Kod', type = 'string'},
}})

ESX.RegisterCommand('fastfingers', 'admin', function(xPlayer, args, showError)
    if not currentGame and args.coins > 0 and args.coins <= maxPrize then
        if xPlayer then
            xPlayer.showNotification('Rozpoczęto grę w szybkie palce', 'success')
        else
            print('Rozpoczęto grę w szybkie palce')
        end
        startGame(args.coins)
        LogCommands('fastfingers', xPlayer, {
            coins = args.coins
        })
    end
end, true, {help = 'Rozpoczyna gre w szybkie palce', validate = true, arguments = {
    {name = 'coins', help = 'Liczba gold coinsów (max '..maxPrize..')', type = 'number'},
}})