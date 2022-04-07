print("Info Graphics Loaded")

PlayerFrame:Hide();
TargetFrame:Hide();

local mainFrame = CreateFrame("Frame", nil, UIParent)
mainFrame:SetFrameStrata("BACKGROUND")
mainFrame:SetSize(64,16)

local mainFrameTexture = mainFrame:CreateTexture(nil, "BACKGROUND")
mainFrameTexture:SetColorTexture(0,0,0,1)
mainFrameTexture:SetAllPoints(mainFrame)
mainFrame.texture = mainFrameTexture

mainFrame:SetPoint("TOPLEFT",0,0)
mainFrame:Show()

local InfoGraphicsFrameIndex = 1 -- Lua indexing starts at 1 ;(
local InfoGraphicsFrames = {}

local infoGraphicsNpUnits = {}

local itemRanges = {
    [4] = 90175,
    [6] = 37727,
    [8] = 8149, -- Voodoo Charm
    [13] = 32321, -- Frostwolf Muzzle
    [18] = 6450, -- Silk Bandage
    [23] = 21519, -- Mistletoe
    [28] = 13289,--Egan's Blaster
    [33] = 1180, -- Scroll of Stamina
    [43] = 34471,
    [48] = 32698,
    [53] = 116139,
    [60] = 32825,
    [80] = 35278
}

function checkForEmptyFrame()
    for i=1, #InfoGraphicsFrames do
        if InfoGraphicsFrames[i].GUID == nil then
            return InfoGraphicsFrames[i]
        end
    end
end

function AddInfoGraphicFrame(xIndex, colorFunction, instanceColorFunction, GUID)
    local emptyFrame = checkForEmptyFrame()
    if emptyFrame then
        emptyFrame.colorFunction = colorFunction
        emptyFrame.instanceColorFunction = instanceColorFunction
        emptyFrame.texture:SetColorTexture(0,0,0,1)
        emptyFrame.GUID = GUID
        return emptyFrame
    end

    local yIndex = -math.floor(#InfoGraphicsFrames / 10) * 16

    local childFrame = CreateFrame("Frame", nil, mainFrame)
    childFrame:SetSize(16,16)

    local childFrameTexture = childFrame:CreateTexture(nil, "BACKGROUND")
    childFrameTexture:SetColorTexture(0,0,0,1)
    childFrameTexture:SetAllPoints(childFrame)

    childFrame.texture = childFrameTexture
    childFrame:SetPoint("LEFT",xIndex,yIndex)
    childFrame:Show()

    InfoGraphicsFrames[InfoGraphicsFrameIndex] = {
        xIndex = xIndex,
        yIndex = yIndex,
        colorFunction = colorFunction,
        instanceColorFunction = instanceColorFunction,
        frame = childFrame,
        texture = childFrameTexture,
        GUID = GUID
    }
    InfoGraphicsFrameIndex = InfoGraphicsFrameIndex + 1
    return childFrame
end

function positionColorFunction(frame)
    if infoGraphicsNpUnits[frame.GUID].unit ~= "player" then
        local header, metadata = convertGUID(frame.GUID)
        return convertDecimalToRGB(header)
    end
    local map = C_Map.GetBestMapForUnit(infoGraphicsNpUnits[frame.GUID].unit)
    local position = C_Map.GetPlayerMapPosition(map, infoGraphicsNpUnits[frame.GUID].unit)

    local facing = GetPlayerFacing()
    if facing == nil then
        facing = 0
    else
        facing = facing / 6.283185308
    end
    return position.x,position.y,facing,1
end

function mapColorFunction(frame)
    if infoGraphicsNpUnits[frame.GUID].unit ~= "player" then
        local header, metadata = convertGUID(frame.GUID)
        return convertDecimalToRGB(metadata)
    end
    local map = C_Map.GetBestMapForUnit(infoGraphicsNpUnits[frame.GUID].unit)
    local main = "" .. map
    local r = tonumber(string.sub(main, 0, 2))
    local g = tonumber(string.sub(main, 3, 4))
    local b = tonumber(string.sub(main, 5, 6))

    r = r / 100

    if g == nil then
        g = 0
    else
        g = g / 100
    end

    if b == nil then
        b = 0
    else
        b = b / 100
    end

    return r,g,b,1
end

function healthManaColorFunction(frame)
    local health = UnitHealth(infoGraphicsNpUnits[frame.GUID].unit)
    local maxHealth = UnitHealthMax(infoGraphicsNpUnits[frame.GUID].unit)
    local mana = UnitPower(infoGraphicsNpUnits[frame.GUID].unit, SPELL_POWER_MANA)
    local maxMana = UnitPowerMax(infoGraphicsNpUnits[frame.GUID].unit, SPELL_POWER_MANA)

    local r = health / maxHealth
    local g = mana / maxMana
    local b = 0

    return r,g,b,1
end

function levelXpColorFunction(frame)
    local level = UnitLevel(infoGraphicsNpUnits[frame.GUID].unit)
    local xp = UnitXP(infoGraphicsNpUnits[frame.GUID].unit)
    local maxXp = UnitXPMax(infoGraphicsNpUnits[frame.GUID].unit)

    local r = level / 100
    local g = xp / maxXp
    local b = 0
    
    return r,g,b,1
end

function instanceInfoColorFunction()
    local instanceID = select(8, GetInstanceInfo())
    local main = "" .. instanceID

    local r = tonumber(string.sub(main, 0, 2))
    local g = tonumber(string.sub(main, 3, 4))
    local b = tonumber(string.sub(main, 5, 6))

    r = r / 100

    if g == nil then
        g = 0
    else
        g = g / 100
    end

    if b == nil then
        b = 0
    else
        b = b / 100
    end

    return r,g,b,1
end

function blackColorFunction()
    return 0,0,0,1
end

function inCombatColorFunction(frame)
    if UnitAffectingCombat(infoGraphicsNpUnits[frame.GUID].unit) then
        return 1,0,0,1
    else
        return 0,1,0,1
    end
end

function getUnitRange(GUID)
    for i=1, 80 do
        --print("Checking: " .. infoGraphicsNpUnits[GUID].unit)
        if IsItemInRange(itemRanges[i], "target") then
            return i
        end
    end
    --print("No range found")
    return nil
end

function convertGUID(GUID)
    local header = nil
    local metadata = nil
    local part1, part2, part3, part4, part5, part6, part7 = string.split("-", GUID)
    if part1 == "Player" then
        header = part2
        metadata = part3
    elseif part1 == "Creature" then
        header = part6
        metadata = part7
    else
        return nil, nil
    end

    local headerNumber = tonumber(header, 16)
    local metadataNumber = tonumber(metadata, 16)

    return headerNumber, metadataNumber    
end

function convertDecimalToRGB(number)
    local r = math.floor(number / 256^2)
    local g = math.floor((number - r * 256^2) / 256)
    local b = number - r * 256^2 - g * 256
    return r/255, g/255, b/255, 1
end

function getFramesFlaggedForLiberation()
    local count = 1
    local frames = {}
    for i = 1, #InfoGraphicsFrames do
        if InfoGraphicsFrames[i].GUID == nil then
            frames[count] = InfoGraphicsFrames[i]
            count = count + 1
        else
            if infoGraphicsNpUnits[InfoGraphicsFrames[i].GUID].deletionTime ~= nil then
                if GetTime() - infoGraphicsNpUnits[InfoGraphicsFrames[i].GUID].deletionTime > 5 then
                    frames[count] = InfoGraphicsFrames[i]
                    count = count + 1
                end
            end
        end
    end
    return frames
end

local lastFreedFramesTime = 0

mainFrame:SetScript("OnUpdate", function(self, elapsed)
    for i = 1, #InfoGraphicsFrames do
        local isInInstance, instanceType = IsInInstance()
        if isInInstance == false and InfoGraphicsFrames[i].GUID ~= nil and InfoGraphicsFrames[i].colorFunction ~= nil then
            InfoGraphicsFrames[i].texture:SetColorTexture(InfoGraphicsFrames[i].colorFunction(InfoGraphicsFrames[i]))
        end
        if isInInstance == true and InfoGraphicsFrames[i].GUID ~= nil and InfoGraphicsFrames[i].instanceColorFunction ~= nil then
            InfoGraphicsFrames[i].texture:SetColorTexture(InfoGraphicsFrames[i].instanceColorFunction(InfoGraphicsFrames[i]))
        end
    end
    if GetTime() - lastFreedFramesTime > 5 then
        local frames = getFramesFlaggedForLiberation()
        for i = 1, #frames do
            freeFrames(frames[i].GUID)
        end
        lastFreedFramesTime = GetTime()
    end
end)

function rangeBufferColorFunction(frame)
    if infoGraphicsNpUnits[frame.GUID].unit == "player" then
        return 0,0,0,1
    end
    if frame.GUID ~= UnitGUID("target") then
        local r = (infoGraphicsNpUnits[frame.GUID].rangeBuffer[1] or 0) / 80
        local g = (infoGraphicsNpUnits[frame.GUID].rangeBuffer[2] or 0) / 80
        local b = (infoGraphicsNpUnits[frame.GUID].rangeBuffer[3] or 0) / 80
        return r,g,b,1
    end
    local range = getUnitRange(frame.GUID)
    if range == nil then
        return 0,0,0,1
    end

    infoGraphicsNpUnits[frame.GUID].rangeBuffer[3] = infoGraphicsNpUnits[frame.GUID].rangeBuffer[2]
    infoGraphicsNpUnits[frame.GUID].rangeBuffer[2] = infoGraphicsNpUnits[frame.GUID].rangeBuffer[1]
    infoGraphicsNpUnits[frame.GUID].rangeBuffer[1] = range
    
    local r = (infoGraphicsNpUnits[frame.GUID].rangeBuffer[1] or 0) / 80
    local g = (infoGraphicsNpUnits[frame.GUID].rangeBuffer[2] or 0) / 80
    local b = (infoGraphicsNpUnits[frame.GUID].rangeBuffer[3] or 0) / 80
    return r,g,b,1
end


function AddInfoGraphicFramesForUnit(GUID)
    AddInfoGraphicFrame(0,positionColorFunction, nil, GUID)
    AddInfoGraphicFrame(16,mapColorFunction, nil, GUID)
    AddInfoGraphicFrame(32,healthManaColorFunction, healthManaColorFunction, GUID)
    AddInfoGraphicFrame(48,levelXpColorFunction, levelXpColorFunction, GUID)
    AddInfoGraphicFrame(64,blackColorFunction, instanceInfoColorFunction, GUID)
    AddInfoGraphicFrame(64,inCombatColorFunction, inCombatColorFunction, GUID)

    AddInfoGraphicFrame(80,rangeBufferColorFunction, rangeBufferColorFunction, GUID)
    AddInfoGraphicFrame(96,blackColorFunction, blackColorFunction, GUID)
    AddInfoGraphicFrame(112,blackColorFunction, blackColorFunction, GUID)
    AddInfoGraphicFrame(128,blackColorFunction, blackColorFunction, GUID)
end

function freeFrames(GUID)
    if infoGraphicsNpUnits[GUID] == nil or infoGraphicsNpUnits[GUID].unit == "player" or GUID == UnitGUID("player") then
        return
    end
    processingFrameLiberation = true

    infoGraphicsNpUnits[GUID] = nil
    for i=1, #InfoGraphicsFrames do
        if InfoGraphicsFrames[i].GUID == GUID then
            InfoGraphicsFrames[i].GUID = nil
            InfoGraphicsFrames[i].texture:SetColorTexture(0,0,0,1)
        end
    end
    processingFrameLiberation = false
end

local processingFrameLiberation = false

local f = CreateFrame("Frame")
f:RegisterEvent("NAME_PLATE_UNIT_ADDED")
f:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
f:RegisterEvent("UNIT_FLAGS")

f:SetScript( "OnEvent", function(self, event, unit)
    if event == "NAME_PLATE_UNIT_ADDED" then
        local id = UnitGUID( unit )
        if infoGraphicsNpUnits[id] ~= nil then
            infoGraphicsNpUnits[id].creationTime = GetTime()
            infoGraphicsNpUnits[id].deletionTime = nil
            return
        end
        infoGraphicsNpUnits[id] = {
            unit = unit,
            rangeBuffer = {},
            creationTime = GetTime(),
            deletionTime = nil
        }
        while(processingFrameLiberation) do
            -- Hang until all frames flagged for liberation are freed.
            -- This is to maintain concurrency within the frame pooling system.
        end
        AddInfoGraphicFramesForUnit(id)
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        local id = UnitGUID( unit )
        infoGraphicsNpUnits[id].deletionTime = GetTime()
    elseif event == "UNIT_FLAGS" and not UnitIsUnit( "player", unit ) and UnitIsFriend( "player", unit ) then
        local id = UnitGUID( unit )
        infoGraphicsNpUnits[id].deletionTime = GetTime()
    end
end )

local playerGUID = UnitGUID("player")
infoGraphicsNpUnits[playerGUID] = {
    unit = "player"
}

AddInfoGraphicFramesForUnit(playerGUID)