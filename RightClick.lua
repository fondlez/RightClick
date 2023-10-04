local mouseInfo = CreateFrame("Frame", nil, GameTooltipStatusBar)

mouseInfo:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

mouseInfo.time = 0
mouseInfo.isEnemy = false
mouseInfo.isAlive = false

mouseInfo:SetScript("OnEvent", function()
    if event == "UPDATE_MOUSEOVER_UNIT" then
        local playerFaction = UnitFactionGroup("player")
        local mouseoverFaction = UnitFactionGroup("mouseover")
        local exists = UnitExists("mouseover")

        if exists then
            this.time = GetTime()
            this.isEnemy = not UnitIsFriend("player", "mouseover")
            this.isAlive = not UnitIsDeadOrGhost("mouseover")
            -- this.name = UnitName("mouseover")
            -- this.isEnemyPlayer = UnitIsPlayer("mouseover") and mouseoverFaction ~= playerFaction
        end
    end
end)

WorldFrame:SetScript("OnMouseUp", function()
    if arg1 == "RightButton" then
        local now = GetTime()
        local mouseoverWasNow = (now - mouseInfo.time) <= 1
        local hasTarget = UnitExists("target")

        -- let stuff happen if not about to click on a current mouseover unit
        if not mouseoverWasNow then return end

        local shouldPrevent = not hasTarget and mouseInfo.isAlive and mouseInfo.isEnemy

        -- | target | mouseover | what |
        -- | -      | -         | -    |
        -- | f      | f         | N    |
        -- | f      | e         | P    |
        -- | f      | nil       | N    |
        -- | e      | f         | P    |
        -- | e      | e         | P    |
        -- | e      | nil       | N    |

        if not shouldPrevent then
            local targetIsAliveEnemy = UnitExists("target") and not UnitIsDeadOrGhost("target") and not UnitIsFriend("player", "target")
            local inCombat = UnitAffectingCombat("player") or UnitAffectingCombat("target")

            shouldPrevent = hasTarget and (inCombat or targetIsAliveEnemy or mouseInfo.isEnemy)
        end

        if shouldPrevent then MouselookStop() end
    end
end)
