RegisterServerEvent("foltone_ticket:teleportPlayerTo")
AddEventHandler("foltone_ticket:teleportPlayerTo", function(player, coords)
    TriggerClientEvent("foltone_ticket:setPlayerCoords", player, coords)
end)

RegisterServerEvent("foltone_ticket:setAction")
AddEventHandler("foltone_ticket:setAction", function(player, action)
    print("Set action " .. action .. " for ticket " .. player)
    if action == "revive" then
        TriggerClientEvent("foltone_ticket:revivePlayer", player)
    elseif action == "heal" then
        TriggerClientEvent("foltone_ticket:healPlayer", player)
    elseif action == "armor" then
        TriggerClientEvent("foltone_ticket:armorPlayer", player)
    elseif action == "kill" then
        TriggerClientEvent("foltone_ticket:killPlayer", player)
    elseif action == "freeze" then
        TriggerClientEvent("foltone_ticket:freezePlayer", player)
    elseif action == "unfreeze" then
        TriggerClientEvent("foltone_ticket:unfreezePlayer", player)
    end
end)
