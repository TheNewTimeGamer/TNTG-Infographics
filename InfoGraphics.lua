if TNTG == nil then
    TNTG = {}
end
TNTG.Frames = {}
TNTG.Last = 10

function CreateNamePlateFrame(ParentFrame, yIndex, Nameplate)
    TNTG.Frames[Nameplate.namePlateUnitToken] = CreateFrame("Frame", "TNTG-" .. Nameplate.namePlateUnitToken,
        ParentFrame)
    TNTG.Frames[Nameplate.namePlateUnitToken]:SetSize(256, 16)
    TNTG.Frames[Nameplate.namePlateUnitToken]:SetPoint("TOP", ParentFrame, "TOP", 0, -((yIndex - 1) * 16))
    TNTG.Frames[Nameplate.namePlateUnitToken]:SetFrameStrata("BACKGROUND")

    local defaultTexture = TNTG.Frames[Nameplate.namePlateUnitToken]:CreateTexture(nil, "BACKGROUND")
    defaultTexture:SetColorTexture(0, 0, 0, 1)
    defaultTexture:SetAllPoints(TNTG.Frames[Nameplate.namePlateUnitToken])
    TNTG.Frames[Nameplate.namePlateUnitToken].texture = defaultTexture

    TNTG.Frames[Nameplate.namePlateUnitToken].infoFrames = {InfoFrame:new(nil,
        TNTG.Frames[Nameplate.namePlateUnitToken], nil, onRenderHealthMana, 'health-mana')}

    UpdateNamePlate(Nameplate)

    TNTG.Frames[Nameplate.namePlateUnitToken]:Show()
    return TNTG.Frames[Nameplate.namePlateUnitToken]
end

function UpdateNamePlate(nameplate)
    if TNTG.Frames[nameplate.namePlateUnitToken] == nil then
        return
    end
    local frame = TNTG.Frames[nameplate.namePlateUnitToken]
    frame.Nameplate = nameplate
    frame.UnitName = UnitName(nameplate.namePlateUnitToken)
    frame.UnitGUID = UnitGUID(nameplate.namePlateUnitToken)
    frame.UnitHealth = UnitHealth(nameplate.namePlateUnitToken)
    frame.UnitHealthMax = UnitHealthMax(nameplate.namePlateUnitToken)
    frame.UnitPower = UnitPower(nameplate.namePlateUnitToken)
    frame.UnitPowerMax = UnitPowerMax(nameplate.namePlateUnitToken)
    frame.UnitPowerType = UnitPowerType(nameplate.namePlateUnitToken)
    frame.UnitClass = UnitClass(nameplate.namePlateUnitToken)
    frame.UnitLevel = UnitLevel(nameplate.namePlateUnitToken)
    frame.UnitIsPlayer = UnitIsPlayer(nameplate.namePlateUnitToken)
    frame.UnitIsEnemy = UnitIsEnemy(nameplate.namePlateUnitToken, "player")
    frame.UnitIsPVP = UnitIsPVP(nameplate.namePlateUnitToken)
    frame.UnitIsTrivial = UnitIsTrivial(nameplate.namePlateUnitToken)
    frame.UnitIsWildBattlePet = UnitIsWildBattlePet(nameplate.namePlateUnitToken)
    frame.UnitIsBattlePet = UnitIsBattlePet(nameplate.namePlateUnitToken)
    frame.UnitIsOtherPlayersPet = UnitIsOtherPlayersPet(nameplate.namePlateUnitToken)
    frame.UnitIsDead = UnitIsDead(nameplate.namePlateUnitToken)
    frame.UnitIsGhost = UnitIsGhost(nameplate.namePlateUnitToken)
    frame.UnitIsFeignDeath = UnitIsFeignDeath(nameplate.namePlateUnitToken)
    frame.UnitIsPossessed = UnitIsPossessed(nameplate.namePlateUnitToken)
    frame.UnitIsQuestBoss = UnitIsQuestBoss(nameplate.namePlateUnitToken)
    frame.UnitDistance = GetUnitDistance(nameplate.namePlateUnitToken)
end

function RenderNamePlate(Nameplate)
    local frame = TNTG.Frames[Nameplate.namePlateUnitToken];

    for i = 1, 5, 1 do
        if frame.infoFrames[i] ~= nil then
            frame.infoFrames[i]:onRender(frame);
        end
    end

    return frame
end

local MasterFrame = CreateFrame("Frame", nil, UIParent)
MasterFrame:SetFrameStrata("BACKGROUND")
MasterFrame:SetSize(256, 256)

local MasterFrameTexture = MasterFrame:CreateTexture(nil, "BACKGROUND")
MasterFrameTexture:SetColorTexture(0, 0, 0, 1)
MasterFrameTexture:SetAllPoints(MasterFrame)
MasterFrameTexture.texture = MasterFrameTexture

MasterFrame:SetPoint("TOP", 0, 0)
MasterFrame:SetScript("OnUpdate", function(self, elapsed)
    TNTG.Last = TNTG.Last + elapsed
    if TNTG.Last > 1 then
        TNTG.Last = 0
        local count = 0
        local nameplates = C_NamePlate.GetNamePlates(false)
        local previous = nil
        for i = 1, 20, 1 do
            if nameplates[i] ~= nil then
                nameplate = nameplates[i]
                if TNTG.Frames[nameplate.namePlateUnitToken] == nil then
                    TNTG.Frames[nameplate.namePlateUnitToken] = CreateNamePlateFrame(MasterFrame, i, nameplate)
                end
                UpdateNamePlate(nameplate)
                RenderNamePlate(nameplate)
                previous = TNTG.Frames[nameplate.namePlateUnitToken];
                count = count + 1
            end
        end
    end
end)
MasterFrame:Show()

