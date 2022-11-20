-- © 2022 RAMPAGE Interactive
-- Written with love.

local Cache = {
    Calls = {},
    Responders = {}
}

function CreateDiscordEmbed(title, message)
    if not Config.Discord.Enabled then
        return
    end

    local embed = {{{
        ["color"] = 15548997,
        ["title"] = title,
        ["description"] = message,
        ["footer"] = {
            ["text"] = "© RAMPAGE Interactive"
        }
    }}}

    PerformHttpRequest(Config.Discord.Webhook, function(err, text, headers)
    end, 'POST', json.encode({
        username = name,
        embeds = embed
    }), {
        ['Content-Type'] = 'application/json'
    })
end

function CreateCall(PlayerId, Reason, Coords)
    local CallId = #Cache.Calls + 1

    Cache.Calls[CallId] = {
        ["Creator"] = PlayerId,
        ["CreatorName"] = GetPlayerName(PlayerId),
        ["Reason"] = (Reason or "Unknown reason"),
        ["Coords"] = Coords
    }

    CreateDiscordEmbed("New Call",
        "A new 911 call has been made by ``" .. (PlayerId > 0 and GetPlayerName(PlayerId) or "Server") .. "`` for *" ..
            (Reason or "Unknown reason") .. "*, CallId: ``" .. tostring(CallId) .. "``")

    if PlayerId > 0 then
        TriggerClientEvent("RAMPAGE_911:Notification", PlayerId, "911 System", "Your 911 call has been placed, emergency personnel will arrive soon.", "success")
    end

    for _, responderId in pairs(Cache.Responders) do
        if GetPlayerName(responderId) then
            if Config.CreateBlipsForFirstResponders then
                TriggerClientEvent("RAMPAGE_911:CreateBlip", responderId, Cache.Calls[CallId].Coords, "911 Call #" .. tostring(CallId))
            end

            TriggerClientEvent("RAMPAGE_911:Notification", responderId, "911 System", "New 911 Call for " .. Cache.Calls[CallId].Reason .. ", to respond run /respond " .. tostring(CallId), "error")
        end
    end

    return CallId
end

function DeleteCall(CallId)
    if Cache.Calls[CallId] ~= nil then
        Cache.Calls[CallId] = nil
    end
end

function RegisterResponder(PlayerId)
    Cache.Responders[PlayerId] = true
end

function RemoveResponder(PlayerId)
    if Cache.Responders[PlayerId] ~= nil then
        Cache.Responders[PlayerId] = nil
    end
end

function GetResponders()
    return Cache.Responders
end

function GetCalls()
    return Cache.Calls
end

AddEventHandler('playerDropped', function()
    if Cache.Responders[source] ~= nil then
        Cache.Responders[source] = nil
    end
end)

exports["kimi_callbacks"]:Register("RAMPAGE_911:GetCalls", function(source)
    return GetCalls()
end)

exports["kimi_callbacks"]:Register("RAMPAGE_911:GetResponders", function(source)
    return GetResponders
end)

exports["kimi_callbacks"]:Register("RAMPAGE_911:CreateCall", function(source, reason)
    return CreateCall(source, reason, GetEntityCoords(GetPlayerPed(source)))
end)

RegisterCommand("deletecall", function(source, args, raw)
    if not Config.CanFirstRespondersDeleteCalls then
        return TriggerClientEvent("RAMPAGE_911:Notification", source, "911 System", "You cannot use this command.", "error")
    end

    if args[1] == nil then
        return TriggerClientEvent("RAMPAGE_911:Notification", source, "911 System", "You must include the call id!", "error")
    end

    if Cache.Responders[source] == nil then
        return TriggerClientEvent("RAMPAGE_911:Notification", source, "911 System", "You are not a first responder!", "error")
    end

    if Cache.Calls[tonumber(args[1])] == nil then
        return TriggerClientEvent("RAMPAGE_911:Notification", source, "911 System", "Invalid call id!", "error")
    end
    
    DeleteCalol(tonumber(args[1]))
    TriggerClientEvent("RAMPAGE_911:Notification", source, "911 System", "The call has been deleted!", "success")
end)

RegisterCommand("respond", function(source, args, raw)
    if args[1] == nil then
        return TriggerClientEvent("RAMPAGE_911:Notification", source, "911 System", "You must include the call id!", "error")
    end

    if Cache.Responders[source] == nil then
        return TriggerClientEvent("RAMPAGE_911:Notification", source, "911 System", "You are not a first responder!", "error")
    end

    if Cache.Calls[tonumber(args[1])] == nil then
        return TriggerClientEvent("RAMPAGE_911:Notification", source, "911 System", "Invalid call id!", "error")
    end
    
    TriggerClientEvent("RAMPAGE_911:SetWaypoint", source, Cache.Calls[tonumber(args[1])].Coords);
    TriggerClientEvent("RAMPAGE_911:Notification", source, "911 System", "Call location marked, respond code 3!", "success")
end)

exports("GetCalls", GetCalls)
exports("CreateCall", CreateCall)
exports("DeleteCall", DeleteCall)
exports("RegisterResponder", RegisterResponder)
exports("RemoveResponder", RemoveResponder)
exports("GetResponders", GetResponders)