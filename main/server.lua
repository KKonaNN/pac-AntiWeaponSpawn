QBCore = nil
ESX = nil

Citizen.CreateThread(function()
    if Config.FrameWork == 'ESX' then
        while ESX == nil do
            TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
    elseif Config.FrameWork == 'QBCore' then
        while QBCore == nil do
            --TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)
            QBCore = exports[Config.CoreResource]:GetCoreObject()
            Citizen.Wait(0)
        end
    end
    print('^2'..GetCurrentResourceName()..' is ^2online^0')
    print('^4Made by ^1KonaN#8557^0')
    print('Loaded '..Config.FrameWork..' Framework')
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for _, player in pairs(GetPlayers()) do
            local playerPed = GetPlayerPed(player)
            local weapon = GetSelectedPedWeapon(playerPed)
            if weapon ~= GetHashKey('WEAPON_UNARMED') then
                if ESX then
                    local xPlayer = ESX.GetPlayerFromId(player)
                    if xPlayer.getInventoryItem(Config.Weapon[weapon]["name"]).count < 1 then
                        RemoveWeaponFromPed(playerPed, GetHashKey(weapon))
                        LogMeDaddy(tonumber(player),'`Weapon Hash :` '..weapon..'\n`Weapon Hash :` '..Config.Weapon[weapon]["name"] , Config.webhook, 16777215)
                    end
                elseif QBCore then
                    local Player = QBCore.Functions.GetPlayer(tonumber(player))
                    if Player and Player.PlayerData.items[weapon] == nil then
                        RemoveWeaponFromPed(playerPed, GetHashKey(weapon))
                        LogMeDaddy(tonumber(player), '`Weapon Hash :` '..weapon..'\n`Weapon Name :` '..Config.Weapon[weapon]["name"], Config.webhook, 16777215)
                    end
                end
            end
        end
    end
end)



function ExtractIdentifiers(src)
    local identifiers = {
        steam = "Not-Found",
        ip = "Not-Found",
        discord = "Not-Found",
        license = "Not-Found",
        xbl = "Not-Found",
        live = "Not-Found",
        fivem = "Not-Found"
    }

    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license:") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        elseif string.find(id, "fivem") then
            identifiers.fivem = id
        end
    end
    return identifiers
end

function LogMeDaddy(source, message, webhook_name, color)

    local ids = ExtractIdentifiers(source)
    local player = GetPlayerName(source)
    local ip = GetPlayerEndpoint(source)
    local discord = ids.discord
    local steamhex = ids.steam
    local gameLicense = ids.license
    local xbl = ids.xbl
    local live = ids.live
    local fivem = ids.fivem
    if ip == nil then return end

    local embed = {
        {
            ["color"] = color,
            ["fields"] = {
                { ["name"] = "User Information", ["value"] = "**`Name:`** "..player.."\n**`Server ID:`** "..source.."\n**`IP:`** "..ip.."\n**`Steam:`** "..steamhex.."\n**`License:`** "..gameLicense.."\n**`Discord:`** "..discord.."\n**`XBL:`** "..xbl.."\n**`Live:`** "..live.."\n**`FiveM ID:`** "..fivem, ["inline"] = true },
                { ["name"] = "Log Information", ["value"] = message, ["inline"] = true }
            },
            ["author"] = {
                ["name"] = "Perdition Collective LTD",
                ["icon_url"] = "https://cdn.discordapp.com/attachments/847909683716554782/1008712749762748427/Untitled-56461.png",
                ["url"] = "https://discord.gg/pca"
            },
            ["footer"] = {
                ["text"] = "Perdition Collective LTD .gg/psu",
                ["icon_url"] = "https://cdn.discordapp.com/attachments/847909683716554782/1008712749762748427/Untitled-56461.png"
            },
        }
    }
    PerformHttpRequest(webhook_name, function(err, text, headers) end, "POST", json.encode({embeds = embed}), { ["Content-Type"] = "application/json" })
end

