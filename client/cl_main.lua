local tableTickets = {}
local ticketSelected;

local function helpNotifcation(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

local function resetVars()
    ticketSelected = nil
end

local function refreshTickets()
    TriggerServerEvent("foltone_ticket:getTickets")
end

Citizen.CreateThread(function()
    refreshTickets()
end)

local menuTicket = RageUI.CreateMenu(_U('name_menu'), _U('description_menu'))

local ticketList = RageUI.CreateSubMenu(menuTicket, _U('name_menu'), _U('ticketList_menu'))
local myTicketList = RageUI.CreateSubMenu(menuTicket, _U('name_menu'), _U('myTicketList_menu'))
local closeTicketList = RageUI.CreateSubMenu(menuTicket, _U('name_menu'), _U('closeTicketList_menu'))

local optionTicket = RageUI.CreateSubMenu(menuTicket, _U('name_menu'), _U('optionTicket_menu'))

local CheckBox1 = false
local ListIndex = 1;

function RageUI.PoolMenus:FoltoneTicket()
    menuTicket:IsVisible(function(Items)
        Items:AddButton(_U('available_ticket'), nil, { RightLabel = ">", IsDisabled = false, LeftBadge = RageUI.BadgeStyle.Tick }, function(onSelected)
        end, ticketList)
        Items:AddButton(_U('my_ticket'), nil, { RightLabel = ">", IsDisabled = false, LeftBadge = RageUI.BadgeStyle.Player }, function(onSelected)
        end, myTicketList)
        Items:AddButton(_U('ticket_close'), nil, { RightLabel = ">", IsDisabled = false, LeftBadge = RageUI.BadgeStyle.Lock }, function(onSelected)
        end, closeTicketList)
    end, function(Panels)
    end)

    ticketList:IsVisible(function(Items)
        Items:CheckBox(_U('show_free_ticket'), nil, CheckBox1, { Style = 1 }, function(onSelected, IsChecked)
            if (onSelected) then
                CheckBox1 = IsChecked
            end
        end)
        for k, v in pairs(tableTickets) do
            if (v.admin == nil or v.admin <= 0) and v.closed ~= true then
                Items:AddButton(_U('ticket_button', v.permid, v.name), _U('press_enter_get_ticket'), { RightLabel = ">", IsDisabled = false }, function(onSelected)
                    if (onSelected) then
                        TriggerServerEvent("foltone_ticket:takeTicket", v.permid)
                        ticketSelected = v
                    end
                end, optionTicket)
            elseif v.admin and (v.admin > 0) and CheckBox1 ~= true then
                Items:AddButton(_U('ticket_button', v.permid, v.name), _U('take_by', GetPlayerName(GetPlayerFromServerId(v.admin))), { RightLabel = ">", IsDisabled = true }, function(onSelected)
                end, optionTicket)
            end
        end
    end, function()
    end)

    myTicketList:IsVisible(function(Items)
        --print("tickets: " .. json.encode(tableTickets))
        for k, v in pairs(tableTickets) do
            if v.admin == GetPlayerServerId(PlayerId()) and v.closed == false then
                Items:AddButton(_U('ticket_button', v.permid, v.name), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
                    if (onSelected) then
                        ticketSelected = v
                    end
                end, optionTicket)
            end
        end
    end, function(Panels)
    end)

    closeTicketList:IsVisible(function(Items)
        for k, v in pairs(tableTickets) do
            if v.closed == true then
                Items:AddButton(_U('ticket_button', v.permid, v.name), _U('press_enter_get_ticket'), { RightLabel = ">", IsDisabled = false }, function(onSelected)
                    if (onSelected) then
                        ticketSelected = v
                    end
                end, optionTicket)
            end
        end
    end, function(Panels)
    end)

    optionTicket:IsVisible(function(Items)
        Items:AddSeparator(_U('ticket_separator', ticketSelected.permid, ticketSelected.name))

        -- teleport player to
        Items:AddList(_U("teleport_player_to"), Config.teleport_list, Config.teleport_list[ListIndex].name, ListIndex, nil, {RightLabel = "", IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                ListIndex = Index
            end
            if (onSelected) then
                TriggerServerEvent("foltone_ticket:teleportPlayerTo", ticketSelected.id, Config.teleport_list[ListIndex].coords)
            end
        end)

        for i = 1, #Config.addButtonInteractionPlayer, 1 do
            local action = Config.addButtonInteractionPlayer[i]
            if action.RightBadge == "" then
                action.RightBadge = RageUI.BadgeStyle.None
            end
            Items:AddButton(action.label, nil, { RightLabel = action.RightLabel, RightBadge = RageUI.BadgeStyle[action.RightBadge], IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    action.execute(ticketSelected.id)
                end
            end)
        end

        if ticketSelected.closed == true then
            -- open ticket
            Items:AddButton(_U('open_ticket'), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    TriggerServerEvent("foltone_ticket:openTicket", ticketSelected.permid)
                    resetVars()
                    refreshTickets()
                    RageUI.GoBack()
                end
            end)

            -- open and takeTicket
            Items:AddButton(_U('open_take_ticket'), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    TriggerServerEvent("foltone_ticket:openTicket", ticketSelected.permid)
                    TriggerServerEvent("foltone_ticket:takeTicket", ticketSelected.permid)
                    refreshTickets()
                end
            end)
        else
            -- giv eup ticket
            Items:AddButton(_U('giveup_ticket'), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    TriggerServerEvent("foltone_ticket:giveupTicket", ticketSelected.permid)
                    resetVars()
                    refreshTickets()
                    RageUI.GoBack()
                end
            end)

            -- close ticket
            Items:AddButton(_U('close_ticket'), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    TriggerServerEvent("foltone_ticket:closeTicket", ticketSelected.permid)
                    resetVars()
                    refreshTickets()
                    RageUI.GoBack()
                end
            end)
        end

        -- delete ticket
        Items:AddButton(_U('delete_ticket'), nil, { RightBadge = RageUI.BadgeStyle.Alert, IsDisabled = false }, function(onSelected)
            if (onSelected) then
                TriggerServerEvent("foltone_ticket:deleteTicket", ticketSelected.permid)
                resetVars()
                refreshTickets()
                RageUI.GoBack()
            end
        end)

    end, function()
    end)
end

RegisterNetEvent("foltone_ticket:receiveTickets")
AddEventHandler("foltone_ticket:receiveTickets", function(tickets)
    --print("Tickets: " .. json.encode(tickets))
    tableTickets = tickets
end)

RegisterNetEvent("foltone_ticket:openMenu")
AddEventHandler("foltone_ticket:openMenu", function()
    RageUI.Visible(menuTicket, not RageUI.Visible(menuTicket))
end)
