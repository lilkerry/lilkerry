local QBCore = exports['qbx_core']:GetCoreObject()
local Functions = require 'client.functions'
local inZone = {}
local productionBlips = {}
local sellerBlips = {}
local sellerNPCs = {}

-- Create all blips and NPCs on start
local function InitializeLocations()
    -- Create production location blips
    for _, location in ipairs(Config.ProductionLocations) do
        if location.blip then
            productionBlips[_] = Functions.CreateBlip(location.coords, location.blipSprite, location.blipColor, location.blipScale, location.name)
        end
    end
    
    -- Create seller NPCs and blips
    for _, seller in ipairs(Config.SellingLocations) do
        if seller.blip then
            sellerBlips[_] = Functions.CreateBlip(seller.coords, seller.blipSprite, seller.blipColor, seller.blipScale, seller.name)
        end
        sellerNPCs[_] = Functions.SpawnNPC(seller.coords.x, seller.coords.y, seller.coords.z, seller.heading, seller.model)
    end
end

-- Check zones near player
local function CheckZones()
    local playerCoords = GetEntityCoords(PlayerPedId())
    
    -- Check production zones
    for _, location in ipairs(Config.ProductionLocations) do
        local distance = #(playerCoords - location.coords)
        if distance < Config.DrawDistance then
            if distance < Config.InteractionDistance then
                if not inZone[location.name] then
                    inZone[location.name] = true
                    Functions.Notify('Info', 'Press [E] to produce ' .. Config.Drugs[location.type].label, 'inform')
                end
                
                -- Draw marker
                DrawMarker(2, location.coords.x, location.coords.y, location.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 0, 0, 255, false, true, 2, nil, nil, false)
                Functions.DrawText3D(location.coords.x, location.coords.y, location.coords.z, location.name, 0.4)
                
                -- Interaction
                if IsControlJustPressed(0, 38) then -- E key
                    TriggerEvent('drugs:client:startProduction', location.type, _)
                end
            else
                inZone[location.name] = nil
            end
        end
    end
    
    -- Check seller zones
    for idx, seller in ipairs(Config.SellingLocations) do
        local distance = #(playerCoords - seller.coords)
        if distance < Config.DrawDistance then
            if distance < Config.InteractionDistance then
                if not inZone[seller.name] then
                    inZone[seller.name] = true
                    Functions.Notify('Info', 'Press [E] to sell drugs', 'inform')
                end
                
                -- Draw marker
                DrawMarker(2, seller.coords.x, seller.coords.y, seller.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 255, false, true, 2, nil, nil, false)
                Functions.DrawText3D(seller.coords.x, seller.coords.y, seller.coords.z, seller.name, 0.4)
                
                -- Menu for selling
                if IsControlJustPressed(0, 38) then -- E key
                    -- Open sell menu
                    local menuOptions = {}
                    for drugType, config in pairs(Config.Drugs) do
                        table.insert(menuOptions, {
                            label = 'Sell ' .. config.label .. ' - $' .. (config.sellPrice * Config.SellAmount),
                            value = drugType,
                        })
                    end
                    
                    TriggerEvent('QBCore:OpenMenu', {
                        Header = 'Sell Drugs',
                        isMenuGrayed = false,
                        alignment = 'top-left',
                        elements = menuOptions,
                        lastmenu = 'mainmenu',
                    }, function(data)
                        TriggerEvent('drugs:client:sellDrugs', data.value)
                    end)
                end
            else
                inZone[seller.name] = nil
            end
        end
    end
end

-- Main loop
CreateThread(function()
    InitializeLocations()
    
    while true do
        Wait(0)
        CheckZones()
    end
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    for _, blip in ipairs(productionBlips) do
        RemoveBlip(blip)
    end
    
    for _, blip in ipairs(sellerBlips) do
        RemoveBlip(blip)
    end
    
    for _, npc in ipairs(sellerNPCs) do
        DeleteEntity(npc)
    end
end)
