Config = {
    -- FR choix de la langue
    -- EN choice of language
    -- ES choice of language
    Locale = "en",

    -- FR list des positions de téléportation
    -- EN list of teleportation positions
    -- ES lista de posiciones de teletransporte
    teleport_list = {
        { name = "Police Station", coords = vector3(432.2, -981.8, 30.7) },
        { name = "Hospital", coords = vector3(296.8, -583.9, 43.1) },
        { name = "Mechanic", coords = vector3(-350.5, -133.5, 39.0) },
    },

    -- FR list des boutons de gestion de joueur
    -- EN list of player management buttons
    -- ES lista de botones de gestión de jugador
    addButtonInteractionPlayer = {
        {
            label = "Bring player",
            RightLabel = ">",
            RightBadge = "",
            execute = function(selectedPlayerServerId)
                TriggerServerEvent("foltone_ticket:teleportPlayerTo", selectedPlayerServerId, GetEntityCoords(PlayerPedId()))
            end
        },
        {
            label = "Go to player",
            RightLabel = ">",
            RightBadge = "",
            execute = function(selectedPlayerServerId)
                SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(selectedPlayerServerId))))
            end
        },
        {
            label = "Revive player",
            RightLabel = "",
            RightBadge = "Heart",
            execute = function (selectedPlayerServerId)
                TriggerServerEvent("foltone_ticket:setAction", selectedPlayerServerId, "revive")
            end
        },
        {
            label = "Heal player",
            RightLabel = "",
            RightBadge = "Heart",
            execute = function (selectedPlayerServerId)
                TriggerServerEvent("foltone_ticket:setAction", selectedPlayerServerId, "heal")
            end
        },
        {
            label = "Set armor player",
            RightLabel = "",
            RightBadge = "Armor",
            execute = function (selectedPlayerServerId)
                TriggerServerEvent("foltone_ticket:setAction", selectedPlayerServerId, "armor")
            end
        },
        {
            label = "Kill player",
            RightLabel = "",
            RightBadge = "Dead",
            execute = function (selectedPlayerServerId)
                TriggerServerEvent("foltone_ticket:setAction", selectedPlayerServerId, "kill")
            end
        },
        {
            label = "Freeze player",
            RightLabel = "",
            RightBadge = "Player",
            execute = function (selectedPlayerServerId)
                TriggerServerEvent("foltone_ticket:setAction", selectedPlayerServerId, "freeze")
            end
        },
        {
            label = "Unfreeze player",
            RightLabel = "",
            RightBadge = "Player",
            execute = function (selectedPlayerServerId)
                TriggerServerEvent("foltone_ticket:setAction", selectedPlayerServerId, "unfreeze")
            end
        }
    }
}
