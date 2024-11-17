local QBCore = exports['qb-core']:GetCoreObject()


local function SendDiscordNotification(playerName, discordID, coords, reason)
    local webhookURL = Config.WebhookURL
    local message = string.format(
        "**%s** teleported.\n**Discord ID**: %s\n**Location**: (%.2f, %.2f, %.2f)\n**Reason**: %s", 
        playerName, discordID or "unknown", coords.x, coords.y, coords.z, reason or "None"
    )

    local data = {
        content = message,
        username = "Teleport Logger",
        avatar_url = "https://i.imgur.com/4M34hi2.png"
    }

    PerformHttpRequest(webhookURL, function(err, text, headers)
        if err ~= 204 then
            print("Discord Webhook sending error:", err)
        else
            print("Message has been sent to Discord")
        end
    end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end



local function GetDiscordID(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)
    for _, identifier in ipairs(identifiers) do
        if string.match(identifier, "discord:") then
            return identifier
        end
    end
    return nil
end

RegisterNetEvent("helptp:sendDiscordNotification", function(playerServerId, playerName, coords, reason)
    local discordID = GetDiscordID(playerServerId)
    SendDiscordNotification(playerName, discordID, coords, reason)
end)
