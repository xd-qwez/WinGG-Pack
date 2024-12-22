local function SplitId(string)
    local output
    for str in string.gmatch(string, "([^:]+)") do
        output = str
    end
    return output
end

local function extractLicense(src)
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "license") then
            return SplitId(id)
        end
    end
end

function SendLogToDiscord(link, title, message, color)
    if link and title and message then

        if not color then
            color = 2303786
        end

        local embeds = {
            {
                ["title"] = title,
                ["type"] = "rich",
                ["description"] = message,
                ["color"] = color,
                ["footer"] =  {
                    ["text"] = os.date("%Y/%m/%d %H:%M"),
                },
            }
        }
        PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({username = title, embeds = embeds}), { ['Content-Type'] = 'application/json' })    
    end
end

function SendPlayerLogToDiscord(link, title, targetSrc, message, color)
    if link and title and targetSrc and message then

        if not color then
            color = 2303786
        end

        local embeds = {}

        if type(targetSrc) == "table" then
            local finalMessage = ""

            for i = 1, #targetSrc do
                finalMessage = "**Identyfikatory: **["..GetPlayerName(targetSrc[i]).."](https://cdn.wingg.eu/identifiers?license="..extractLicense(targetSrc[i])..")\n"
            end

            embeds = {
                {
                    ["title"] = title,
                    ["type"] = "rich",
                    ["description"] = finalMessage..message,
                    ["color"] = color,
                    ["footer"] =  {
                        ["text"] = os.date("%Y/%m/%d %H:%M"),
                    },
                }
            }
        else
            local finalMessage = "**Identyfikatory: **["..GetPlayerName(targetSrc).."](https://cdn.wingg.eu/identifiers?license="..extractLicense(targetSrc)..")\n"..message
            embeds = {
                {
                    ["title"] = GetPlayerName(targetSrc).." ["..targetSrc.."]",
                    ["type"] = "rich",
                    ["description"] = finalMessage,
                    ["color"] = color,
                    ["footer"] =  {
                        ["text"] = os.date("%Y/%m/%d %H:%M"),
                    },
                }
            }
        end
        PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({username = title, embeds = embeds}), { ['Content-Type'] = 'application/json' })
    end
end

function SendPlayerImageLogToDiscord(link, title, targetSrc, img, color)
    if link and title and targetSrc and img then

        if not color then
            color = 2303786
        end

        local embeds = {}

        local finalMessage = "**Identyfikatory: **["..GetPlayerName(targetSrc).."](https://cdn.wingg.eu/identifiers?license="..extractLicense(targetSrc)..")"
        embeds = {
            {
                ["title"] = GetPlayerName(targetSrc).." ["..targetSrc.."]",
                ["type"] = "rich",
                ["description"] = finalMessage,
                ["image"] = {
                    ["url"] = img,
                },
                ["color"] = color,
                ["footer"] =  {
                    ["text"] = os.date("%Y/%m/%d %H:%M"),
                },
            }
        }
        PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({username = title, embeds = embeds}), { ['Content-Type'] = 'application/json' })
    end
end

exports('SendLogToDiscord', SendLogToDiscord)
exports('SendPlayerLogToDiscord', SendPlayerLogToDiscord)
exports('SendPlayerImageLogToDiscord', SendPlayerImageLogToDiscord)