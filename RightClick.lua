local tt = CreateFrame("Frame", nil, GameTooltipStatusBar)

tt:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
tt:SetScript("OnEvent", function()
    if event == "UPDATE_MOUSEOVER_UNIT" then
        local playerFaction = UnitFactionGroup("player")
        local mouseoverFaction = UnitFactionGroup("mouseover")

        this.name = UnitName("mouseover")
        this.isPlayer = UnitIsPlayer("mouseover")
        this.isEnemyFaction = mouseoverFaction ~= playerFaction
    end
end)

WorldFrame:SetScript("OnMouseUp", function()
    if arg1 == "RightButton" then
        local hasEnemyTarget = UnitExists("target") and not UnitIsDeadOrGhost("target") and not UnitIsFriend("player", "target")
        local isNewTarget = UnitName("target") ~= tt.name
        local isEnemyPlayer = tt.isPlayer and tt.isEnemyFaction

        if hasEnemyTarget and (isNewTarget or isEnemyPlayer) then
            MouselookStop()
            return
        end
    end
end)
