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
    if arg1 == "RightButton" then
        local isNewTarget = UnitName("target") ~= tt.name
        local isEnemyPlayer = tt.isPlayer and tt.isEnemyFaction

        if isNewTarget or isEnemyPlayer then
            MouselookStop()
            return
        end
    end
end)
