local QBCore = exports['qb-core']:GetCoreObject()

local drugLocations = {
    {
        name = "Weed",
        coords = vector3(221.43, -937.57, 24.86),
        heading = 0.0,
        model = `a_m_m_business_1`,
        anim = "amb@medic@standing@kneel@base",
        animName = "base",
        duration = 5000,
        item = "weed",
        amount = 3
    },
    {
        name = "Cocaine",
        coords = vector3(309.31, -1434.57, 29.61),
        heading = 180.0,
        model = `a_m_m_business_1`,
        anim = "amb@medic@standing@kneel@base",
        animName = "base",
        duration = 5000,
        item = "cocaine",
        amount = 2
    },
    {
        name = "Methamphetamine",
        coords = vector3(-480.47, -288.57, 35.3),
        heading = 90.0,
        model = `a_m_m_business_1`,
        anim = "amb@medic@standing@kneel@base",
        animName = "base",
        duration = 5000,
        item = "methamphetamine",
        amount = 2
    }
}

local ProcessingLocations = {
    {
        name = "Weed Processing",
        coords = vector3(368.57, -1399.57, 29.29),
        heading = 0.0,
        model = `a_m_m_business_1`,
        anim = "amb@medic@standing@kneel@base",
        animName = "base",
        duration = 5000,
        inputItem = "weed",
        outputItem = "weed_bag",
        amount = 1
    },
    {
        name = "Cocaine Processing",
        coords = vector3(309.31, -1434.57, 29.61),
        heading = 180.0,
        model = `a_m_m_business_1`,
        anim = "amb@medic@standing@kneel@base",
        animName = "base",
        duration = 5000,
        inputItem = "cocaine",
        outputItem = "cocaine_bag",
        amount = 1
    }
}

Citizen.CreateThread(function()
    for _, location in ipairs(drugLocations) do
        exports['qb-target']:AddBoxZone(location.name, location.coords, 1.5, 1.5, {
            name = location.name,
            heading = location.heading,
            debugPoly = false,
            minZ = location.coords.z - 1,
            maxZ = location.coords.z + 1
        }, {
            options = {
                {
                    type = "client",
                    event = "drugs:client:harvest",
                    icon = "fas fa-cannabis",
                    label = "Harvest " .. location.name,
                    location = location
                }
            },
            distance = 2.5
        })
    end
end)

Citizen.CreateThread(function()
    for _, location in ipairs(ProcessingLocations) do
        exports['qb-target']:AddBoxZone(location.name, location.coords, 1.5, 1.5, {
            name = location.name,
            heading = location.heading,
            debugPoly = false,
            minZ = location.coords.z - 1,
            maxZ = location.coords.z + 1
        }, {
            options = {
                {
                    type = "client",
                    event = "drugs:client:process",
                    icon = "fas fa-mortar-pestle",
                    label = "Process " .. location.name,
                    location = location
                }
            },
            distance = 2.5
        })
    end
end)

RegisterNetEvent('drugs:client:harvest', function(data)
    local location = data.location
    local hasItem = QBCore.Functions.HasItem(location.item)

    if hasItem then
        QBCore.Functions.Notify("You already have " .. location.item, "error", 3000)
        return
    end

    TriggerEvent('animations:client:EmoteCommandStart', {"medic"})
    
    local dict = location.anim
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
    
    local ped = PlayerPedId()
    TaskPlayAnim(ped, dict, location.animName, 8.0, -8.0, location.duration, 0, 0, false, false, false)
    
    local progressBar = exports['progressbar']:Progress({
        name = "harvest_" .. location.name,
        duration = location.duration,
        label = "Harvesting " .. location.name .. "...",
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = dict,
            anim = location.animName,
            flags = 16,
        },
        prop = {},
        completed = function()
            TriggerServerEvent('drugs:server:harvest', location.item, location.amount)
            ClearAnimDict(dict)
        end,
        cancelled = function()
            ClearAnimDict(dict)
        end
    })
end)

RegisterNetEvent('drugs:client:process', function(data)
    local location = data.location
    local hasItem = QBCore.Functions.HasItem(location.inputItem)

    if not hasItem then
        QBCore.Functions.Notify("You need " .. location.inputItem, "error", 3000)
        return
    end

    TriggerEvent('animations:client:EmoteCommandStart', {"medic"})
    
    local dict = location.anim
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
    
    local ped = PlayerPedId()
    TaskPlayAnim(ped, dict, location.animName, 8.0, -8.0, location.duration, 0, 0, false, false, false)
    
    local progressBar = exports['progressbar']:Progress({
        name = "process_" .. location.name,
        duration = location.duration,
        label = "Processing " .. location.name .. "...",
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = dict,
            anim = location.animName,
            flags = 16,
        },
        prop = {},
        completed = function()
            TriggerServerEvent('drugs:server:process', location.inputItem, location.outputItem, location.amount)
            ClearAnimDict(dict)
        end,
        cancelled = function()
            ClearAnimDict(dict)
        end
    })
end)

RegisterNetEvent('drugs:client:sellDrug', function()
    local hasWeedBag = QBCore.Functions.HasItem("weed_bag")
    local hasCocaineBag = QBCore.Functions.HasItem("cocaine_bag")

    if not hasWeedBag and not hasCocaineBag then
        QBCore.Functions.Notify("You don't have any drugs to sell", "error", 3000)
        return
    end

    TriggerServerEvent('drugs:server:sellDrug')
end)
