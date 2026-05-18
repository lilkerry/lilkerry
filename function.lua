local QBCore = exports['qbx_core']:GetCoreObject()

-- Draw 3D text
function DrawText3D(x, y, z, text, size)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(size, size)
        SetTextFont(4)
        SetTextPropsOutlined(0.0, 0.7, 2.0, 2.0, 1.0)
        BeginTextCommandDisplayText('STRING')
        AddTextComponentString(text)
        DrawText(_x - 0.0125, _y - 0.0158)
    end
end

-- Create blip
function CreateBlip(coords, sprite, color, scale, label)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipScale(blip, scale)
    SetBlipAsShortRange(blip, false)
    AddTextEntry('BLIP_' .. label, label)
    BeginTextCommandSetBlipName('BLIP_' .. label)
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
    SetBlipRoute(blip, false)
    return blip
end

-- Load model
function LoadModel(hash)
    RequestModel(GetHashKey(hash))
    local count = 0
    while not HasModelLoaded(GetHashKey(hash)) and count < 100 do
        Wait(10)
        count = count + 1
    end
end

-- Spawn NPC
function SpawnNPC(x, y, z, heading, model)
    LoadModel(model)
    local npc = CreatePed(4, GetHashKey(model), x, y, z, heading, true, false)
    FreezeEntityPosition(npc, true)
    TaskStartScenarioInPlace(npc, 'WORLD_HUMAN_STUPOR', 0, true)
    return npc
end

-- Play animation
function PlayAnimation(animDict, animName, duration)
    RequestAnimDict(animDict)
    local count = 0
    while not HasAnimDictLoaded(animDict) and count < 100 do
        Wait(10)
        count = count + 1
    end
    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, -8.0, duration, 0, 0, false, false, false)
end

-- Progress bar
function ProgressBar(label, duration)
    TriggerEvent('progressbar:client:progress', {
        name = 'drug_' .. math.random(1000, 9999),
        label = label,
        duration = duration,
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = 'combat@damage@rb_writhe',
            anim = 'rb_writhe_loop',
            flags = 1,
        },
        prop = {
            model = 'prop_cs_bucket_01',
        },
    })
end

-- Notify function
function Notify(title, message, type)
    TriggerEvent('QBCore:Notify', message, type or 'info')
end

return {
    DrawText3D = DrawText3D,
    CreateBlip = CreateBlip,
    LoadModel = LoadModel,
    SpawnNPC = SpawnNPC,
    PlayAnimation = PlayAnimation,
    ProgressBar = ProgressBar,
    Notify = Notify,
}
