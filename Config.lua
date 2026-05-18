Config = {}

-- Enable/Disable Debug Mode
Config.Debug = false

-- Drug Harvesting Locations
Config.HarvestLocations = {
    {
        name = "Weed Farm",
        coords = vector3(221.43, -937.57, 24.86),
        heading = 0.0,
        item = "weed",
        amount = 3,
        requiresJob = false,
        jobRequired = nil
    },
    {
        name = "Cocaine Farm",
        coords = vector3(309.31, -1434.57, 29.61),
        heading = 180.0,
        item = "cocaine",
        amount = 2,
        requiresJob = false,
        jobRequired = nil
    },
    {
        name = "Meth Lab",
        coords = vector3(-480.47, -288.57, 35.3),
        heading = 90.0,
        item = "methamphetamine",
        amount = 2,
        requiresJob = false,
        jobRequired = nil
    }
}

-- Drug Processing Locations
Config.ProcessingLocations = {
    {
        name = "Weed Processing",
        coords = vector3(368.57, -1399.57, 29.29),
        heading = 0.0,
        inputItem = "weed",
        outputItem = "weed_bag",
        processingTime = 5000,
        requiresJob = false,
        jobRequired = nil
    },
    {
        name = "Cocaine Processing",
        coords = vector3(309.31, -1434.57, 29.61),
        heading = 180.0,
        inputItem = "cocaine",
        outputItem = "cocaine_bag",
        processingTime = 5000,
        requiresJob = false,
        jobRequired = nil
    },
    {
        name = "Methamphetamine Processing",
        coords = vector3(-480.47, -288.57, 35.3),
        heading = 90.0,
        inputItem = "methamphetamine",
        outputItem = "methamphetamine_bag",
        processingTime = 5000,
        requiresJob = false,
        jobRequired = nil
    }
}

-- Drug Seller Location
Config.SellerLocation = {
    coords = vector3(426.15, -986.37, 29.41),
    heading = 180.0,
    model = "a_m_m_business_1"
}

-- Drug Prices
Config.DrugPrices = {
    weed_bag = 150,
    cocaine_bag = 300,
    methamphetamine_bag = 250
}

-- Animation Settings
Config.Animations = {
    harvest = {
        dict = "amb@medic@standing@kneel@base",
        name = "base",
        duration = 5000
    },
    process = {
        dict = "amb@medic@standing@kneel@base",
        name = "base",
        duration = 5000
    }
}
