local _, _, _, client = GetBuildInfo()
client = client or 11200

local GetTime = GetTime
local MouselookStop = MouselookStop
local UnitCanAttack = UnitCanAttack
local UnitExists = UnitExists
local UnitIsDeadOrGhost = UnitIsDeadOrGhost

local mouseInfo = CreateFrame("Frame")

mouseInfo:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

mouseInfo.time = 0
mouseInfo.isAliveEnemy = false

mouseInfo:SetScript("OnEvent", function(self, e)
  local this = self or this
  local event = e or event
  
  if event == "UPDATE_MOUSEOVER_UNIT" then
    this.time = GetTime()
    this.isAliveEnemy = not UnitIsDeadOrGhost("mouseover") 
      and UnitCanAttack("player", "mouseover")
  end
end)

local OnMouseUp = function(self, button)
  local arg1 = button or arg1
  
  if arg1 == "RightButton" then
    if (GetTime() - mouseInfo.time) > 5 then return end
    
    local targetIsAliveEnemy = UnitExists("target") 
      and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target")
    local shouldPrevent = mouseInfo.isAliveEnemy or targetIsAliveEnemy

    if shouldPrevent then MouselookStop() end
  end
end

-- HookScript does not exist before TBC
if client >= 20000 then
  WorldFrame:HookScript("OnMouseUp", OnMouseUp)
else
  WorldFrame:SetScript("OnMouseUp", OnMouseUp)
end
