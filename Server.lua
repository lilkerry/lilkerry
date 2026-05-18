local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('drugs:server:harvest')
AddEventHandler('drugs:server:harvest', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    local hasItem = Player.Functions.GetItemByName(item)

    if not hasItem then
        Player.Functions.AddItem(item, amount)
        TriggerClientEvent('QBCore:Notify', src, "You harvested " .. amount .. "x " .. item, "success", 3000)
        TriggerEvent('qb-log:server:CreateLog', 'drugs', 'Player ' .. Player.PlayerData.charinfo.firstname .. ' harvested ' .. amount .. 'x ' .. item, 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, "You already have this item", "error", 3000)
    end
end)

RegisterServerEvent('drugs:server:process')
AddEventHandler('drugs:server:process', function(inputItem, outputItem, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    local itemData = Player.Functions.GetItemByName(inputItem)

    if itemData then
        Player.Functions.RemoveItem(inputItem, amount)
        Player.Functions.AddItem(outputItem, amount)
        TriggerClientEvent('QBCore:Notify', src, "You processed " .. amount .. "x " .. inputItem .. " into " .. outputItem, "success", 3000)
        TriggerEvent('qb-log:server:CreateLog', 'drugs', 'Player ' .. Player.PlayerData.charinfo.firstname .. ' processed ' .. amount .. 'x ' .. inputItem .. ' into ' .. outputItem, 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, "You don't have " .. inputItem, "error", 3000)
    end
end)

RegisterServerEvent('drugs:server:sellDrug')
AddEventHandler('drugs:server:sellDrug', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    local weedBag = Player.Functions.GetItemByName("weed_bag")
    local cocaineBag = Player.Functions.GetItemByName("cocaine_bag")
    
    local totalMoney = 0

    if weedBag then
        local weedAmount = weedBag.amount or 0
        totalMoney = totalMoney + (weedAmount * 500)
        Player.Functions.RemoveItem("weed_bag", weedAmount)
    end

    if cocaineBag then
        local cocaineAmount = cocaineBag.amount or 0
        totalMoney = totalMoney + (cocaineAmount * 1500)
        Player.Functions.RemoveItem("cocaine_bag", cocaineAmount)
    end

    if totalMoney > 0 then
        Player.Functions.AddMoney("cash", totalMoney)
        TriggerClientEvent('QBCore:Notify', src, "You sold your drugs for $" .. totalMoney, "success", 3000)
        TriggerEvent('qb-log:server:CreateLog', 'drugs', 'Player ' .. Player.PlayerData.charinfo.firstname .. ' sold drugs for $' .. totalMoney, 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, "You don't have any drugs to sell", "error", 3000)
    end
end)
