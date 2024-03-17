IncludeScript("base_teamplay");


---------------------------------
-- Global Variables (these can be changed to whatever you want)
---------------------------------

TEAM_POINTS_PER_WIN = 1
BLUE_TEAM_NAME = "Blue team"
RED_TEAM_NAME = "Red team"
GREEN_TEAM_NAME = "Green team"
YELLOW_TEAM_NAME = "Yellow team"


---------------------------------
-- Functions
---------------------------------

function startup()
-- set up team limits
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, 0 )

	SetTeamName( Team.kRed, RED_TEAM_NAME )
	SetTeamName( Team.kBlue, BLUE_TEAM_NAME )
	SetTeamName( Team.kGreen, GREEN_TEAM_NAME )
	SetTeamName( Team.kYellow, YELLOW_TEAM_NAME )

	-- Blue Team Class limits
	local team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	
	-- Red Team class limits
	team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	-- Green Team class limits
	team = GetTeam( Team.kGreen )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	-- Yellow Team class limits
	team = GetTeam( Team.kYellow )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

end


-- Everyone to spawn with everything.
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	player:AddHealth( 400 )
	player:AddArmor( 400 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:AddAmmo( Ammo.kGren1, 4 )
	player:AddAmmo( Ammo.kDetpack, 1 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
	player:RemoveAmmo( Ammo.kGren1, 3 )
end

function precache()
	PrecacheSound("misc.bloop")
end


-- Calls a function to check if a team has won every time someone dies
function player_killed( killed_entity )
	local player = CastToPlayer( killed_entity )
	player:Spectate ( SpecMode.kRoaming )
	player:SetRespawnable( false )
	CheckTeamAliveState( killed_entity)
end


function Spectate( player )
	player:Spectate( SpecMode.kRoaming )
end 


-- Checks to see if people are still alive. If one team is all dead, declare the other team the winners.
function CheckTeamAliveState(killed_player)
	ConsoleToAll( "CheckTeamAliveState" )
	
	local blue = Collection()
	local red = Collection()
	local green = Collection()
	local yellow = Collection()

	-- Filter players online into seperate teams. Ignore spectators.
	blue:GetByFilter({ CF.kPlayers, CF.kTeamBlue })
	red:GetByFilter({ CF.kPlayers, CF.kTeamRed })
	green:GetByFilter({ CF.kPlayers, CF.kTeamGreen })
	yellow:GetByFilter({ CF.kPlayers, CF.kTeamYellow })

	-- If either team has no players, then exit. Just one person running about shouldn't get boxed up.
if (blue:Count() + red:Count() + green:Count() + yellow:Count() < 2) then
AddSchedule("respawnall", 1 , respawnall)
end


	local bAlive = 0
	local rAlive = 0
	local gAlive = 0
	local yAlive = 0

	-- Check all blue team players to see who is still alive
	for temp in blue.items do
		local player = CastToPlayer( temp )
		if player:IsAlive() then
			bAlive = bAlive + 1
		end
	end
	
	-- Same for red
	for temp in red.items do
		local player = CastToPlayer( temp )
		if player:IsAlive() then
			rAlive = rAlive + 1
		end
	end

	-- Same for green
	for temp in green.items do
		local player = CastToPlayer( temp )
		if player:IsAlive() then
			gAlive = gAlive + 1
		end
	end
	
	-- Same for yellow
	for temp in yellow.items do
		local player = CastToPlayer( temp )
		if player:IsAlive() then
			yAlive = yAlive + 1
		end
	end

	-- checks to see if either team is all dead. If so, declare other team the winner, and start new round. If not, set the killed player to spectate
	if (bAlive >= 1) and (rAlive == 0) and (gAlive == 0) and (yAlive == 0) then
		BroadCastMessage(BLUE_TEAM_NAME .. " wins!")
		BroadCastSound( "misc.bloop" )
		local team = GetTeam (Team.kBlue)
		team:AddScore(TEAM_POINTS_PER_WIN)
		AddSchedule("respawnall", 3 , respawnall)
	elseif (rAlive >= 1) and (bAlive == 0) and (gAlive == 0) and (yAlive == 0) then
		BroadCastMessage(RED_TEAM_NAME .. " wins!")
		BroadCastSound( "misc.bloop" )
		local team = GetTeam (Team.kRed)
		team:AddScore(TEAM_POINTS_PER_WIN)
		AddSchedule("respawnall", 3 , respawnall)
	elseif (gAlive >= 1) and (bAlive == 0) and (rAlive == 0) and (yAlive == 0) then
		BroadCastMessage(GREEN_TEAM_NAME .. " wins!")
		BroadCastSound( "misc.bloop" )
		local team = GetTeam (Team.kGreen)
		team:AddScore(TEAM_POINTS_PER_WIN)
		AddSchedule("respawnall", 3 , respawnall)
	elseif (yAlive >= 1) and (bAlive == 0) and (rAlive == 0) and (gAlive == 0) then
		BroadCastMessage(YELLOW_TEAM_NAME .. " wins!")
		BroadCastSound( "misc.bloop" )
		local team = GetTeam (Team.kYellow)
		team:AddScore(TEAM_POINTS_PER_WIN)
		AddSchedule("respawnall", 3 , respawnall)
	else
		return
	end
end


-- Respawns all players.
function RespawnEveryone()
	ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips, AT.kAllowRespawn, AT.kReturnDroppedItems })
end


---------------------------------
-- Scheduled functions
---------------------------------

function respawnall()
	RespawnEveryone()
end



-----------------------------------------------------------------------------
-- spawn validty checking
-----------------------------------------------------------------------------

-- makes sure the VIP can only spawn in their teams base
normal_spawn = info_ff_teamspawn:new({ validspawn = function(self, player)
		return EVENT_ALLOWED
end})

-- Ties the map's spawn entities to the above functions
normalspawn = normal_spawn:new()

-- team spawns, if wanted
team_spawn = info_ff_teamspawn:new({ validspawn = function(self, player)
		return player:GetTeamId() == self.team
end})

bluespawn = team_spawn:new({ team = Team.kBlue })
redspawn = team_spawn:new({ team = Team.kRed })
greenspawn = team_spawn:new({ team = Team.kGreen })
yellowspawn = team_spawn:new({ team = Team.kYellow })