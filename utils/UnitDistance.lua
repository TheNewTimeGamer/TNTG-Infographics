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

function GetUnitDistance(unit)   
    for i=1, 80 do
        if IsItemInRange(itemRanges[i], unit) then
            return i
        end
    end
    return nil
end