local tableTickets = {}
local svPermId = 0

local function addTicket(_source, message)
    print("addTicket")
    svPermId = svPermId + 1
    local ticket = {
        permid = svPermId,
        id = _source,
        name = GetPlayerName(_source),
        message = message,
        admin = 0,
        closed = false
    }
    table.insert(tableTickets, ticket)
    print("Tickets sv : " .. json.encode(tableTickets))
    TriggerClientEvent("foltone_ticket:receiveTickets", -1, tableTickets)
end

AddEventHandler("playerDropped", function(reason)
    local _source = source
    print("Player " .. _source .. " dropped")
    for i = 1, #tableTickets do
        if tableTickets[i].id == _source then
            table.remove(tableTickets, i)
            break
        end
    end
end)

RegisterServerEvent("foltone_ticket:getTickets")
AddEventHandler("foltone_ticket:getTickets", function()
    local _source = source
    TriggerClientEvent("foltone_ticket:receiveTickets", _source, tableTickets)
end)

RegisterServerEvent("foltone_ticket:deleteTicket")
AddEventHandler("foltone_ticket:deleteTicket", function(id)
    for i = 1, #tableTickets do
        if tableTickets[i].permid == id then
            table.remove(tableTickets, i)
            break
        end
    end
    TriggerClientEvent("foltone_ticket:receiveTickets", -1, tableTickets)
end)

RegisterServerEvent("foltone_ticket:takeTicket")
AddEventHandler("foltone_ticket:takeTicket", function(id)
    local _source = source
    print("Player " .. _source .. " take ticket " .. id)
    for i = 1, #tableTickets do
        if tableTickets[i].permid == id then
            print("Ticket " .. id .. " found")
            tableTickets[i].admin = _source
            break
        end
    end
    TriggerClientEvent("foltone_ticket:receiveTickets", -1, tableTickets)
end)

RegisterServerEvent("foltone_ticket:giveupTicket")
AddEventHandler("foltone_ticket:giveupTicket", function(id)
    for i = 1, #tableTickets do
        if tableTickets[i].permid == id then
            tableTickets[i].admin = nil
            break
        end
    end
    TriggerClientEvent("foltone_ticket:receiveTickets", -1, tableTickets)
end)

RegisterServerEvent("foltone_ticket:closeTicket")
AddEventHandler("foltone_ticket:closeTicket", function(id)
    for i = 1, #tableTickets do
        if tableTickets[i].permid == id then
            tableTickets[i].closed = true
            tableTickets[i].admin = nil
            break
        end
    end
    TriggerClientEvent("foltone_ticket:receiveTickets", -1, tableTickets)
end)

RegisterServerEvent("foltone_ticket:openTicket")
AddEventHandler("foltone_ticket:openTicket", function(id)
    for i = 1, #tableTickets do
        if tableTickets[i].permid == id then
            tableTickets[i].closed = false
            break
        end
    end
    TriggerClientEvent("foltone_ticket:receiveTickets", -1, tableTickets)
end)

RegisterCommand("report", function(source, args, rawCommand)
    local _source = source
    print("Tickets: " .. json.encode(tableTickets))
    print("Source: " .. _source)
    if _source <= 0 then
        print(_U("console_error"))
        return
    else
        for v, v in pairs(tableTickets) do
            if v.id == _source and v.closed ~= true then
                print("You already have a ticket open.")
                return
            end
        end
        TriggerClientEvent("foltone_ticket:clientNotify", _source, _U("ticket_submitted"))
        addTicket(_source, table.concat(args, " "))
    end
end, false)
