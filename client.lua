-- © 2022 RAMPAGE Interactive
-- Written with love.

local function CreateBlip(x, y, z, Name, Sprite, Size, Colour)
    local BackupBlip = AddBlipForCoord(x, y, z)
    SetBlipSprite(BackupBlip, Sprite)
    SetBlipDisplay(BackupBlip, 4)
    SetBlipScale(BackupBlip, Size)
    SetBlipColour(BackupBlip, Colour)
    SetBlipAsShortRange(BackupBlip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(Name)
    EndTextCommandSetBlipName(BackupBlip)

    Citizen.Wait(300 * 1000)
    RemoveBlip(BackupBlip)
end

RegisterNetEvent("RAMPAGE_911:Notification")
AddEventHandler("RAMPAGE_911:Notification", function(title, desc, type)
    lib.notify({
        title = title,
        description = desc,
        type = type
    })
end)

RegisterNetEvent("RAMPAGE_911:SetWaypoint")
AddEventHandler("RAMPAGE_911:SetWaypoint", function(coords)
    SetNewWaypoint(coords.x, coords.y)
end)

RegisterNetEvent("RAMPAGE_911:CreateBlip")
AddEventHandler("RAMPAGE_911:CreateBlip", function(coords, title)
    CreateBlip(coords.x, coords.y, coords.z, title, 56, 1.2, 49)
end)

RegisterCommand("911", function(source, args, raw)
    local input = lib.inputDialog('911, What\'s your emergency?', {'Reason'})

    if not input then
        return lib.notify({
            title = '911 System',
            description = 'Error occured processing call.',
            type = 'error'
        })
    end

    if not input[1] then
        return lib.notify({
            title = '911 System',
            description = 'Please fill all fields out.',
            type = 'error'
        })
    end

    exports["kimi_callbacks"]:Trigger("RAMPAGE_911:CreateCall", input[1])
end)