
-- For use with CTF Style maps.
-- Intended for use with Red and Blue Teams only. Blue = Offense / Red = Defense.

-- Default Settings --


-- Useful Stuff --
local offense_caps = 0
local FULL_GAME = false
local half_prematch = 10
local function_table = { startup = startup }

function_table.baseflag = { touch = baseflag.touch }

---[[ FF Functions --
function startup()
	if type(function_table.startup) == "function" then function_table.startup()	end
	
	local RED_TEAM = GetTeam(Team.kRed)
	local BLUE_TEAM = GetTeam(Team.kBlue)
	local YELLOW_TEAM = GetTeam(Team.kYellow)
	local timelimit = GetConvar( "mp_timelimit" )
	
	BLUE_TEAM:SetName("Offense")
	RED_TEAM:SetName("Defense")
	YELLOW_TEAM:SetName("R00Kie's Army") -- Temp team for switching
	
	RED_TEAM:SetClassLimit(Player.kScout, -1)
	BLUE_TEAM:SetClassLimit(Player.kHwguy, -1)
	AddSchedule( "Half-Round", ((timelimit * 60) / 2) - 10, SwitchTeams)
	AddSchedule( "Round_Warning", ((timelimit * 60) / 2) - 20 , ChatToAll, "^2Round ending in 10 seconds!")
	AddSchedule( "Game_mode_warning", 5 , ChatToAll, "This Server is running ^1O^5v^2D ^Mode! The Teams will switch half-way!")
end
--]]
---[[ Causes crashing too??!
function baseflag:touch ( touch_entity )
	local player = CastToPlayer ( touch_entity )
	
	if FULL_GAME == false then
		if player:GetTeamId() == 2 then
			if type(function_table.baseflag.touch) == "function" then function_table.baseflag.touch (self, touch_entity) end
			
			-- Send message to players trying to take a protected flag
		else	
			ChatToPlayer(player,"^5( ^2PROTECTED^5 ) Game is currently in OvD, the teams will switch half-way." )
		end
	else
		if type(function_table.baseflag.touch) == "function" then function_table.baseflag.touch (self, touch_entity) end
	end
end

function basecap:ontouch( touch_entity )
	local player = CastToPlayer ( touch_entity )
	offense_caps = offense_caps + 1
end
--]]
--Custom Functions
---[[ -- Causes Crashing!??
function SwitchTeams()
	local RED_TEAM = GetTeam(Team.kRed)
	local BLUE_TEAM = GetTeam(Team.kBlue)
	local YELLOW_TEAM = GetTeam(Team.kYellow)
	
	RED_TEAM:SetClassLimit(Player.kScout, 0) -- Add scout on red so they can switch
	RED_TEAM:AddScore(offense_caps * 10)
	BLUE_TEAM:AddScore(offense_caps * -10)
	ApplyToTeam(RED_TEAM, {AT.kChangeTeamYellow, AT.kChangeClassScout})	
	ApplyToTeam(BLUE_TEAM, {AT.kChangeTeamRed, AT.kChangeClassSoldier})
	ApplyToTeam(YELLOW_TEAM, {AT.kChangeTeamBlue })	
	ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips, AT.kReturnDroppedItems })
	RED_TEAM:SetClassLimit(Player.kScout, -1) -- Remove Scout on red
	PseudoPrematch()  -- Turn off Prematch for now
end

function PseudoPrematch()
	ChatToAll("^2ROUND OVER!")
	ChatToAll("^5Change classes now before the next round starts!")
	
	for i = 1, half_prematch do
		AddSchedule( "Prematch"..i,  i, BroadCastMessage, "Next half starts in: "..(half_prematch -i), 1 )
	end 
	
	AddSchedule( "RespawnDelay",  half_prematch, RespawnDelay )
end

function RespawnDelay()
	ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips, AT.kReturnDroppedItems })
end
--]]