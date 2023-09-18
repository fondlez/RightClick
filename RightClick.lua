local tt = CreateFrame('Frame', nil, GameTooltipStatusBar)
tt:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
tt:SetScript("OnEvent", function()
    local playerFaction = UnitFactionGroup("player")
    local mouseoverFaction = UnitFactionGroup("mouseover")

    this.name = UnitName("mouseover")
    this.isPlayer = UnitIsPlayer("mouseover")
    this.isEnemyFaction = mouseoverFaction ~= playerFaction
end)

WorldFrame:SetScript("OnMouseUp", function()
    if tt.isPlayer and tt.isEnemyFaction then
        TargetByName(tt.name)
        MouselookStop()
    end
end)
