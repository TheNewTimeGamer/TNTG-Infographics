
function onRenderHealthMana(infoFrame, nameplate)
    if nameplate.UnitHealth == nil then
        return
    end
    local r = nameplate.UnitHealth / nameplate.UnitHealthMax
    local g = nameplate.UnitPower / nameplate.UnitPowerMax
    local b = 0

    infoFrame.frame.texture:SetColorTexture(r,g,b,1)
    infoFrame.frame.texture:SetAllPoints(infoFrame.frame)
end

function onRenderDistance()

end