local QBCore = exports['qbx_core']:GetCoreObject()
local Functions = require 'client.functions'

-- Start drug production
RegisterNetEvent('drugs:client:startProduction', function(drugType, location)
    local playerPed = PlayerPedId()
    local config = Config.Drugs[drugType]
    
    if not config then
        Functions.Notify('Error', 'Invalid drug type', 'error')
        return
    end
    
    -- Check inventory for ingredients
    local hasIngredient = QBCore.Functions.HasItem(config.ingredient, 1)
    if not hasIngredient then
        Functions.Notify('Error', 'You need ' .. config.ingredientLabel, 'error')
        return
    end
    
    -- Animation and progress
    Functions.ProgressBar('Producing ' .. config.label .. '...', config.time)
    
    Wait(config.time)
    
    -- Remove ingredient and add product
    TriggerServerEvent('drugs:server:completeProduction', drugType, location)
end)

-- Sell drugs to NPC
RegisterNetEvent('drugs:client:sellDrugs', function(drugType)
    local playerPed = PlayerPedId()
    local config = Config.Drugs[drugType]
    
    if not config then
        Functions.Notify('Error', 'Invalid drug type', 'error')
        return
    end
    
    -- Check inventory
    local hasProduct = QBCore.Functions.HasItem(config.product, Config.SellAmount)
    if not hasProduct then
        Functions.Notify('Error', 'You need ' .. config.productLabel, 'error')
        return
    end
    
    -- Animation
    Functions.PlayAnimation('mp_common', 'givetake_base', 1500)
    Wait(1500)
    
    -- Sell to server
    TriggerServerEvent('drugs:server:sellDrugs', drugType, Config.SellAmount)
end)

-- Use drug effect
RegisterNetEvent('drugs:client:useDrug', function(drugType)
    local config = Config.DrugEffects[drugType]
    
    if not config then
        Functions.Notify('Error', 'Invalid drug type', 'error')
        return
    end
    
    local playerPed = PlayerPedId()
    
    -- Animation
    Functions.PlayAnimation('mp_common', 'givetake_base', 1500)
    Wait(1500)
    
    -- Apply effects
    if config.effects.speed then
        SetRunSprintMultiplierForPlayer(PlayerId(), config.effects.speed)
    end
    
    -- Reset after duration
    SetTimeout(config.duration, function()
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
        Functions.Notify('Info', 'Drug effect wore off', 'inform')
    end)
    
    Functions.Notify('Success', 'You used ' .. Config.Drugs[drugType].label, 'success')
end)

-- Sync production stage
RegisterNetEvent('drugs:client:updateProduction', function(data)
    -- Update UI or send notification about production progress
    Functions.Notify('Info', 'Production stage ' .. data.stage .. ' complete', 'inform')
end)

return {}
