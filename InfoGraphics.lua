if TNTG == nil then
    TNTG = {}
end
TNTG.nameplates = {}
TNTG.last = 10

function UpdateNamePlate(nameplate)
    TNTG.nameplates[nameplate.namePlateUnitToken] = {
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

local nameplates = C_NamePlate.GetNamePlates(false)
for i, v in pairs(nameplates) do
    local name = v.namePlateUnitToken
    print(name)
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
    TNTG.last = TNTG.last + elapsed
    if TNTG.last > 10 then
        TNTG.last = 0
        local count = 0
        local nameplates = C_NamePlate.GetNamePlates(false)
        for i, v in pairs(nameplates) do
            print("checking")
            UpdateNamePlate(v)
            print("done")
            count = count + 1
        end
        print(count .. " nameplates")
    end
end)
MasterFrame:Show()