local mouseInfo = CreateFrame("Frame", nil, GameTooltipStatusBar)

mouseInfo:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

mouseInfo.time = 0
mouseInfo.isAliveEnemy = false

mouseInfo:SetScript("OnEvent", function()
    if event == "UPDATE_MOUSEOVER_UNIT" then
        local playerFaction = UnitFactionGroup("player")
        local mouseoverFaction = UnitFactionGroup("mouseover")
        local exists = UnitExists("mouseover")

        if exists then
            this.time = GetTime()
            this.isAliveEnemy = not UnitIsDeadOrGhost("mouseover") and not UnitIsFriend("player", "mouseover") and not UnitIsCivilian("mouseover")
            -- this.isEnemyPlayer = UnitIsPlayer("mouseover") and mouseoverFaction ~= playerFaction
        end
    end
end)

WorldFrame:SetScript("OnMouseUp", function()
    if arg1 == "RightButton" then
        local mouseoverWasNow = (GetTime() - mouseInfo.time) <= 5
        local targetIsAliveEnemy = UnitExists("target") and not UnitIsDeadOrGhost("target") and not UnitIsFriend("player", "target") and not UnitIsCivilian("mouseover")
        local shouldPrevent = (mouseoverWasNow and mouseInfo.isAliveEnemy) or targetIsAliveEnemy

        if shouldPrevent then MouselookStop() end
    end
end)
