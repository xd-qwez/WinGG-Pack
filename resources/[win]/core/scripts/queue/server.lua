local DiscordServerID = 1058123253211725896
local DiscordBotToken = "MTI3MTkxMTkzMTY0ODgwNzA2NA.G-Lz38.0ozzEGWiCd02rb0g7eb7kb9ZVY-C6fIiHK0D8w"

local QueuePrio = {
    ['913509372011876413'] = 15, -- owner
    ['561261387331010570'] = 15, -- dev
    ['697604908270223361'] = 14, -- zarząd
    ['730440963381657630'] = 13, -- headadmin
    ['561261385527590913'] = 12, -- admin
    ['629837733820366858'] = 11, -- mod
    ['561261389520568321'] = 10, -- support
}

local queue = {}
local IdentifiersList = {}
local slots = GetConvarInt("sv_maxclients", 300)
local queueHalt = false

MySQL.ready(function()
    MySQL.query('SELECT * FROM `identifiers`', {}, function(data)
        if data then
            for i = 1, #data do
                IdentifiersList[data[i].discord] = {
                    name = data[i].name,
                    steamhex = data[i].steamhex,
                    license = data[i].license,
                    hwid = data[i].hwid,
                    xbl = data[i].xbl,
                    live = data[i].live,
                    edited = data[i].edited / 1000,
                }
            end
        end
	end)
end)

local function EntriesInTable(t)
    local count = 0
    for _ in pairs(t) do
        count += 1
    end
    return count
end

local function SecondsToClock(seconds)
    if seconds <= 0 then
        return "00:00";
    else
        local mins = string.format("%02.f", math.floor(seconds/60));
        local secs = string.format("%02.f", math.floor(seconds - mins *60));
        return mins..":"..secs
    end
end

local function SplitId(string)
    local output
    for str in string.gmatch(string, "([^:]+)") do
        output = str
    end
    return output
end

local function ExtractIdentifiers(src)
    local identifiers = {
        id = src,
        name = GetPlayerName(src),
        steamhex = "Brak",
        steamid = "Brak",
        ip = "Brak",
        discord = "213123",
        license = "asd",
        license2 = "asd",
        xbl = "asdasdasd",
        live = "asdasd",
        fivem = "asdasd",
        hwid = {}
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        ---@diagnostic disable-next-line: redundant-parameter
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
            identifiers.steamhex = SplitId(id)
            identifiers.steamid = tonumber(SplitId(id), 16)
        elseif string.find(id, "ip") then
            identifiers.ip = SplitId(id)
        elseif string.find(id, "discord") then
            identifiers.discord = SplitId(id)
        elseif string.find(id, "license2") then
            identifiers.license2 = SplitId(id)
        elseif string.find(id, "license") then
            identifiers.license = SplitId(id)
        elseif string.find(id, "xbl") then
            identifiers.xbl = SplitId(id)
        elseif string.find(id, "live") then
            identifiers.live = SplitId(id)
        elseif string.find(id, "fivem") then
            identifiers.fivem = SplitId(id)
        end
    end

    for i = 0, GetNumPlayerTokens(src) - 1 do
        table.insert(identifiers.hwid, GetPlayerToken(src, i))
    end

    return identifiers
end

local function SendAlert(Identifiers, nick, conflict)
    SendLogToDiscord("link", 'Nieautoryzowany identyfikator', '**Nick: **'..nick..'\n**Discord: **'..Identifiers.discord..'\n**Licencja: **'..IdentifiersList[Identifiers.discord].license..'\n**Steam: **'..IdentifiersList[Identifiers.discord].steamhex..'\n\n**KONFLIKT: **'..conflict, 5763719)
end

local function CheckIdentifierslist(Identifiers, nick)

	if Identifiers.discord == "Brak" then
        print(nick, "brak dsc")
        return true
    elseif IdentifiersList[Identifiers.discord] then
        if IdentifiersList[Identifiers.discord].steamhex ~= Identifiers.steamhex then
            SendAlert(Identifiers, nick, "inny steam: "..Identifiers.steamhex)
            print(nick, "inny steam")
            return true
        elseif IdentifiersList[Identifiers.discord].license ~= Identifiers.license then
            print(nick, "inna licka")
            SendAlert(Identifiers, nick, "inna licencja: "..Identifiers.license)
            return true
        end

        for i = 1, #IdentifiersList[Identifiers.discord].hwid do
            if IdentifiersList[Identifiers.discord].hwid[i] and IdentifiersList[Identifiers.discord].hwid[i] ~= Identifiers.hwid[i] then
                print(IdentifiersList[Identifiers.discord].hwid[i], Identifiers.hwid[i])
                SendAlert(Identifiers, nick, "inne tokeny:\nIteracja tokenu: "..i.."\nOrginał: "..IdentifiersList[Identifiers.discord].hwid[i].."\nNowy: "..Identifiers.hwid[i])
                return true
            end
        end

		MySQL.update('UPDATE `identifiers` SET `xbl` = @xbl, `live` = @live, `name` = @name, `edited` = @edited WHERE discord = @discord', {
			['@discord'] = Identifiers.discord,
			['@xbl'] = Identifiers.xbl,
			['@live'] = Identifiers.live,
			['@name'] = Identifiers.name,
			['@edited'] = os.date("%Y-%m-%d %H:%M:%S", os.time()),
		}, function(rowsChanged)
			IdentifiersList[Identifiers.discord].xbl = Identifiers.xbl
            IdentifiersList[Identifiers.discord].live = Identifiers.live
            IdentifiersList[Identifiers.discord].name = Identifiers.name
            IdentifiersList[Identifiers.discord].edited = os.time()
		end)
	else
		print("Dodano nowy rekord w `identifiers`")
		MySQL.update('INSERT INTO `identifiers` (`license`, `steamhex`, `xbl`, `live`, `discord`, `hwid`, `name`, `edited`) VALUES (@license, @steamhex, @xbl, @live, @discord, @hwid, @name, @edited)', {
			['@license'] = Identifiers.license,
			['@steamhex'] = Identifiers.steamhex,
			['@xbl'] = Identifiers.xbl,
			['@live'] = Identifiers.live,
			['@discord'] = Identifiers.discord,
			['@hwid'] = json.encode(Identifiers.hwid),
			['@name'] = Identifiers.name,
			['@edited'] = os.date("%Y-%m-%d %H:%M:%S", os.time()),
		}, function(rowsChanged)
			IdentifiersList[Identifiers.discord] = {
				steamhex = Identifiers.steamhex,
				xbl = Identifiers.xbl,
				live = Identifiers.live,
				license = Identifiers.license,
				hwid = json.encode(Identifiers.hwid),
				name = Identifiers.name,
				edited = os.time(),
			}
		end)
	end

	return false
end

AddEventHandler('playerConnecting', function(nickName, setKickReason, deferrals)
    local src = source
    local Identifiers = ExtractIdentifiers(source)

    deferrals.defer()

    deferrals.update("Wczytywanie...")

	local dot = ""
	for i = 1, math.random(3,4) do
		deferrals.presentCard([==[{
			"type": "AdaptiveCard",
			"$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
			"version": "1.5",
			"body": [
				{
					"type": "Container",
					"items": [
						{
							"type": "Image",
							"url": "https://i.imgur.com/S31YgSO.gif",
							"size": "Large",
							"horizontalAlignment": "Center",
							"altText": "Generalnie to głównie masa"
						},
						{
							"type": "TextBlock",
							"text": "Pobieranie Identyfikatorów]==]..dot..[==[",
							"wrap": true,
							"size": "Medium",
							"horizontalAlignment": "Center",
							"weight": "Default"
						}
					],
					"style": "default",
					"bleed": true,
					"height": "stretch"
				}
			]
		}]==])
		dot = dot.."."
		Wait(700)
	end

    local isIdentifierChanged = CheckIdentifierslist(Identifiers, nickName)

    if isIdentifierChanged then
        setKickReason("Wykryto zmiane identyfikatora")
        deferrals.done("Wykryto zmiane identyfikatora")
        CancelEvent()
    else
        PerformHttpRequest("https://discord.com/api/v9/guilds/"..DiscordServerID.."/members/"..Identifiers.discord, function(err, text, headers)
        --PerformHttpRequest("https://discord.com/api/v9/guilds/1105839344817811568/members/1062359203018190878", function(err, text, headers) -- Jakby jebany zllomek mial globala
            local DiscordData = json.decode(text)
            if DiscordData then
                local priority = 1
                for _, role in pairs(DiscordData.roles) do
                    if QueuePrio[role] and QueuePrio[role] > priority then
                        priority = QueuePrio[role]
                    end
                end


                local lowpos = EntriesInTable(queue) + 1
                for src2, values in pairs(queue) do
                    if values.ticket < priority then
                        if lowpos > queue[src2].pos then
                            lowpos = queue[src2].pos
                        end
                        queue[src2].pos += 1
                    end
                end

                queue[src or 0] = {ticket = priority, pos = lowpos}

                local time = 0
                local nick = nickName

                if DiscordData.nick then
                    nick = DiscordData.nick
                else
                    nick = DiscordData.user.username
                end

                local avatar = "https://icons-for-free.com/download-icon-man+person+profile+user+worker+icon-1320190557331309792_512.png"
                if DiscordData.user.avatar then
                    avatar = "https://cdn.discordapp.com/avatars/"..Identifiers.discord.."/"..DiscordData.user.avatar..".webp?size=128"
                end
                print(avatar)

                -- Kolejka
                print("["..nick.."] dołączył do kolejki")
                local randomTime = math.random(5, 15)
                while queueHalt or queue[src] and queue[src].pos > 1 and GetPlayerEndpoint(src) or time < randomTime or #GetPlayers() >= tonumber(slots) do
                    deferrals.presentCard([==[{
                        "type": "AdaptiveCard",
                        "body": [
                            {
                                "type": "Container",
                                "items": [
                                    {
                                        "type": "TextBlock",
                                        "text": "Wczytywanie",
                                        "wrap": true,
                                        "size": "Medium",
                                        "weight": "Bolder",
                                        "color": "Light"
                                    },
                                    {
                                        "type": "ColumnSet",
                                        "columns": [
                                            {
                                                "type": "Column",
                                                "items": [
                                                    {
                                                        "type": "Image",
                                                        "style": "Person",
                                                        "url": "]==]..(avatar)..[==[",
                                                        "size": "Small",
                                                        "altText": "cos sie zjebalo",
                                                        "selectAction": {
                                                            "type": "Action.OpenUrl",
                                                            "url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=5s"
                                                        }
                                                    }
                                                ],
                                                "width": "auto"
                                            },
                                            {
                                                "type": "Column",
                                                "items": [
                                                    {
                                                        "type": "TextBlock",
                                                        "weight": "Bolder",
                                                        "text": "]==]..(nick or "Twój nick")..[==[",
                                                        "wrap": true
                                                    },
                                                    {
                                                        "type": "TextBlock",
                                                        "spacing": "None",
                                                        "text": "Witaj na WinGG, zapnij pasy i wskakuj do gry",
                                                        "isSubtle": true,
                                                        "wrap": true
                                                    }
                                                ],
                                                "width": "stretch"
                                            }
                                        ]
                                    },
                                    {
                                        "type": "ColumnSet",
                                        "columns": [
                                            {
                                                "type": "Column",
                                                "items": [
                                                    {
                                                        "type": "TextBlock",
                                                        "weight": "Bolder",
                                                        "text": "Pozycja w kolejce:",
                                                        "wrap": true,
                                                        "spacing": "Small",
                                                        "horizontalAlignment": "Left"
                                                    },
                                                    {
                                                        "type": "TextBlock",
                                                        "weight": "Bolder",
                                                        "text": "Punkty biletu:",
                                                        "wrap": true,
                                                        "spacing": "Small",
                                                        "horizontalAlignment": "Left"
                                                    },
                                                    {
                                                        "type": "TextBlock",
                                                        "text": "Czas w kolejce:",
                                                        "wrap": true,
                                                        "weight": "Bolder",
                                                        "spacing": "Small",
                                                        "horizontalAlignment": "Left"
                                                    }
                                                ],
                                                "width": "auto",
                                                "spacing": "None",
                                                "horizontalAlignment": "Left"
                                            },
                                            {
                                                "type": "Column",
                                                "items": [
                                                    {
                                                        "type": "TextBlock",
                                                        "weight": "Default",
                                                        "text": "]==]..queue[src].pos.."/"..EntriesInTable(queue)..[==[",
                                                        "wrap": true,
                                                        "spacing": "Small"
                                                    },
                                                    {
                                                        "type": "TextBlock",
                                                        "weight": "Default",
                                                        "text": "]==]..priority..[==[",
                                                        "wrap": true,
                                                        "spacing": "Small"
                                                    },
                                                    {
                                                        "type": "TextBlock",
                                                        "text": "]==]..SecondsToClock(time)..[==[",
                                                        "wrap": true,
                                                        "weight": "Default",
                                                        "spacing": "Small"
                                                    }
                                                ],
                                                "width": "stretch"
                                            }
                                        ],
                                        "horizontalAlignment": "Left"
                                    },
                                    {
                                        "type": "ColumnSet",
                                        "columns": [
                                            {
                                                "type": "Column",
                                                "items": [
                                                    {
                                                        "type": "Image",
                                                        "style": "Person",
                                                        "url": "https://cdn.discordapp.com/attachments/880170322417029132/946447514834444338/Tjk5fBz.gif",
                                                        "size": "Small",
                                                        "altText": "cos sie zjebalo",
                                                        "selectAction": {
                                                            "type": "Action.OpenUrl",
                                                            "url": "https://youtu.be/Lr4tgoS-Uds?t=5"
                                                        }
                                                    }
                                                ],
                                                "width": "auto"
                                            },
                                            {
                                                "type": "Column",
                                                "items": [
                                                    {
                                                        "type": "TextBlock",
                                                        "text": "Czekasz w kolejce",
                                                        "size": "Default"
                                                    },
                                                    {
                                                        "type": "TextBlock",
                                                        "spacing": "None",
                                                        "text": "Cierpliwie poczekaj na swoją kolej",
                                                        "isSubtle": true,
                                                        "size": "Small",
                                                        "wrap": true
                                                    }
                                                ],
                                                "width": "stretch"
                                            }
                                        ],
                                        "separator": true,
                                        "spacing": "Medium"
                                    }
                                ]
                            }
                        ],
                        "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
                        "version": "1.5"
                    }]==])

                    time = time + 1
                    Wait(1000)
                end

                CreateThread(function()
                    if GetPlayerEndpoint(src) then
                        queueHalt = true
                        Wait(10*1000)
                        queueHalt = false
                    end
                end)

                if queue[src].pos <= 1 then -- jeśli jego kolej na dołączenie > przesuń kolejke 
                    queue[src or 0] = nil
                    for src2, values in pairs(queue) do
                        queue[src2].pos = values.pos - 1
                    end
                elseif queue[src].pos > 1 then -- jeśli wyszedł będąc w kolejce > przesuń kolejke 
                    for src2, values in pairs(queue) do
                        if values.pos > queue[src].pos then
                            queue[src2].pos = values.pos - 1
                        end
                    end
                    queue[src or 0] = nil
                end

                deferrals.done()
            else
                setKickReason("Aby zagrać musisz dołączyć \n na serwer discord")
                deferrals.done("Aby zagrać musisz dołączyć \n na serwer discord")
                CancelEvent()
            end
        end, 'GET', nil, {['Content-Type'] = 'application/json', ["Authorization"] = "Bot "..DiscordBotToken})
    end
end)

-- if deferrals then
--     counter += 1
--     deferrals.presentCard([==[{
--         "type": "AdaptiveCard",
--         "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
--         "version": "1.5",
--         "body": [
--             {
--                 "type": "Container",
--                 "items": [
--                     {
--                         "type": "Image",
--                         "url": "https://i.imgur.com/S31YgSO.gif",
--                         "size": "Large",
--                         "horizontalAlignment": "Center",
--                         "altText": "Generalnie to głównie masa"
--                     },
--                     {
--                         "type": "TextBlock",
--                         "text": "Dopasowywanie zbanowanych kont ]==]..counter..[==[/]==]..BanEntriesOveral..[==[",
--                         "wrap": true,
--                         "size": "Medium",
--                         "horizontalAlignment": "Center",
--                         "weight": "Default"
--                     }
--                 ],
--                 "style": "default",
--                 "bleed": true,
--                 "height": "stretch"
--             }
--         ]
--     }]==])
