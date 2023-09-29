InfoFrame = {}

function InfoFrame:new (o, parentFrame, previousFrame, onRender, name)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.onRender = onRender

    self.frame = CreateFrame("Frame", parentFrame:GetName() .. '-' .. name, ParentFrame)
    self.frame:SetWidth(16)
    self.frame:SetHeight(12)

    self.frame.texture = self.frame:CreateTexture(nil, "BACKGROUND")
    self.frame.texture:SetColorTexture(0,0,0,1)
    self.frame.texture:SetPoint("CENTER", 0, 0)
    if previousFrame ~= nil then
        self.frame:SetPoint("LEFT", previousFrame, "RIGHT", 0, 0)
    else
        self.frame:SetPoint("LEFT", parentFrame, "LEFT", 0, 0)
    end
    self.frame:Show();

    return o
end