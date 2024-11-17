local QBCore = exports['qb-core']:GetCoreObject()

local function TeleportToCoords(coords, reason)
    local playerPed = PlayerPedId()
    DoScreenFadeOut(500)
    Wait(500)
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
    DoScreenFadeIn(500)

    local playerName = GetPlayerName(PlayerId())
    TriggerServerEvent("helptp:sendDiscordNotification", GetPlayerServerId(PlayerId()), playerName, coords, reason)

    QBCore.Functions.Notify("Teleported.", "success", 5000)
end

local function GetClosestLocation()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local closestDistance = -1
    local closestCoords = nil

    for _, location in ipairs(Config.Locations) do
        local distance = #(playerCoords - location)
        if closestDistance == -1 or distance < closestDistance then
            closestDistance = distance
            closestCoords = location
        end
    end

    return closestCoords
end

RegisterCommand("helptp", function()
    local closestCoords = GetClosestLocation()
    if not closestCoords then
        QBCore.Functions.Notify("I can't find a location near you.", "error", 5000)
        return
    end

    -- text box
    local input = exports['qb-input']:ShowInput({
        header = "Please enter your reason for using tp",
        submitText = "Send (to tp)",
        inputs = {
            {
                text = "reason", -- Placeholders for input fields
                name = "reason", -- Key name of input data
                type = "text", -- text entry
                isRequired = true -- indispensable
            }
        }
    })

    if input and input.reason then
        TeleportToCoords(closestCoords, input.reason)
    else
        QBCore.Functions.Notify("No reason entered. Canceled.", "error", 5000)
    end
end, false)


TriggerEvent('chat:addSuggestion', '/helptp', 'Teleport to a nearby safe location.')
