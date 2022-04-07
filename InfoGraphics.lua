if TNTG == nil then
    TNTG = {}
end
TNTG.Frames = {}
TNTG.Nameplates = {}
TNTG.Last = 10

PlayerFrame:Hide();
TargetFrame:Hide();

function CreateNamePlateFrame(ParentFrame, PreviousFrame, NamePlateUnitToken)
    TNTG.Frames[NamePlateUnitToken] = CreateFrame("Frame", "TNTG-" .. NamePlateUnitToken, ParentFrame)
    TNTG.Frames[NamePlateUnitToken]:SetSize(100, 20)
    if PreviousFrame ~= nil then
        TNTG.Frames[NamePlateUnitToken]:SetPoint("TOP", PreviousFrame, "BOTTOM", 0, 0)
    else
        TNTG.Frames[NamePlateUnitToken]:SetPoint("TOP", ParentFrame, "TOP", 0, 0)
    end
    TNTG.Frames[NamePlateUnitToken]:SetFrameStrata("BACKGROUND")

    local defaultTexture = TNTG.Frames[NamePlateUnitToken]:CreateTexture(nil, "BACKGROUND")
    defaultTexture:SetColorTexture(0,0,0,1)
    defaultTexture:SetAllPoints(TNTG.Frames[NamePlateUnitToken])
    TNTG.Frames[NamePlateUnitToken].texture = defaultTexture

    TNTG.Frames[NamePlateUnitToken]:Show()
    return TNTG.Frames[NamePlateUnitToken]
end

function UpdateNamePlate(nameplate)
    TNTG.Nameplates[nameplate.namePlateUnitToken] = {
        Nameplate = nameplate,
        UnitName = UnitName(nameplate.namePlateUnitToken),
        UnitGUID = UnitGUID(nameplate.namePlateUnitToken),
        UnitHealth = UnitHealth(nameplate.namePlateUnitToken),
        UnitHealthMax = UnitHealthMax(nameplate.namePlateUnitToken),
        UnitPower = UnitPower(nameplate.namePlateUnitToken),
        UnitPowerMax = UnitPowerMax(nameplate.namePlateUnitToken),
        UnitPowerType = UnitPowerType(nameplate.namePlateUnitToken),
        UnitClass = UnitClass(nameplate.namePlateUnitToken),
        UnitLevel = UnitLevel(nameplate.namePlateUnitToken),
        UnitIsPlayer = UnitIsPlayer(nameplate.namePlateUnitToken),
        UnitIsEnemy = UnitIsEnemy(nameplate.namePlateUnitToken, "player"),
        UnitIsPVP = UnitIsPVP(nameplate.namePlateUnitToken),
        UnitIsTrivial = UnitIsTrivial(nameplate.namePlateUnitToken),
        UnitIsWildBattlePet = UnitIsWildBattlePet(nameplate.namePlateUnitToken),
        UnitIsBattlePet = UnitIsBattlePet(nameplate.namePlateUnitToken),
        UnitIsOtherPlayersPet = UnitIsOtherPlayersPet(nameplate.namePlateUnitToken),
        UnitIsDead = UnitIsDead(nameplate.namePlateUnitToken),
        UnitIsGhost = UnitIsGhost(nameplate.namePlateUnitToken),
        UnitIsFeignDeath = UnitIsFeignDeath(nameplate.namePlateUnitToken),
        UnitIsPossessed = UnitIsPossessed(nameplate.namePlateUnitToken),
        UnitIsQuestBoss = UnitIsQuestBoss(nameplate.namePlateUnitToken)
    }
end

function RenderNamePlate(ParentFrame, PreviousFrame, Nameplate)
    local frame = TNTG.Frames[Nameplate.namePlateUnitToken] or CreateNamePlateFrame(ParentFrame, PreviousFrame, Nameplate.namePlateUnitToken)

    return frame
end

local MasterFrame = CreateFrame("Frame", nil, UIParent)
MasterFrame:SetFrameStrata("BACKGROUND")
MasterFrame:SetSize(64,16)

local MasterFrameTexture = MasterFrame:CreateTexture(nil, "BACKGROUND")
MasterFrameTexture:SetColorTexture(0,0,0,1)
MasterFrameTexture:SetAllPoints(MasterFrame)
MasterFrameTexture.texture = MasterFrameTexture

MasterFrame:SetPoint("TOPLEFT",0,0)
MasterFrame:SetScript("OnUpdate", function(self, elapsed)
    TNTG.Last = TNTG.Last + elapsed
    if TNTG.Last > 10 then
        TNTG.Last = 0
        local count = 0
        local nameplates = C_NamePlate.GetNamePlates(false)
        local previous = nil
        TNTG.Nameplates = {}
        for i, v in pairs(nameplates) do
            UpdateNamePlate(v)
            previous = RenderNamePlate(MasterFrame, previous, v)
            count = count + 1
        end
    end
end)
MasterFrame:Show()

