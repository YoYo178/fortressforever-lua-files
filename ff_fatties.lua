
-- ff_fatties1.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_ctf")
IncludeScript("base_location")

-----------------------------------------------------------------------------
-- globals (lawl... unless it starts with "local" its already a global!)
-----------------------------------------------------------------------------
-- override this
POINTS_PER_CAPTURE = 2

ROUND_TIMER_START = 60
ROUND_TIMER_STOP = 0
ROUND_TIMER_CURRENT = ROUND_TIMER_START

-----------------------------------------------------------------------------
-- initial stuff
-----------------------------------------------------------------------------
function startup()
	-- set up team limits	
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	-- both teams limited to medics & hwguys
	for i = Team.kBlue, Team.kRed do
		local team = GetTeam( i )

		team:SetClassLimit( Player.kScout, -1 )
		team:SetClassLimit( Player.kSniper, -1 )
		team:SetClassLimit( Player.kSoldier, -1 )
		team:SetClassLimit( Player.kDemoman, -1 )
		team:SetClassLimit( Player.kMedic, 0 )
		team:SetClassLimit( Player.kHwguy, 0 )
		team:SetClassLimit( Player.kPyro, -1 )
		team:SetClassLimit( Player.kSpy, -1 )
		team:SetClassLimit( Player.kEngineer, -1 )
		team:SetClassLimit( Player.kCivilian, -1 )
	end

	-- Start door schedule
	StartDoorOpenSchedule()
end

-----------------------------------------------------------------------------
-- player stuff
-----------------------------------------------------------------------------
function player_spawn( spawn_entity )
	local player = CastToPlayer( spawn_entity )

	player:AddHealth( 100 )
	player:AddArmor( 300 )

	-- Players get everything except grenades
	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:AddAmmo( Ammo.kDetpack, 1 )
	player:AddAmmo( Ammo.kManCannon, 1 )
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
end

function player_killed( killed_entity )
	local player = CastToPlayer( killed_entity )

	-- Guy stays dead until round is over
	player:SetRespawnable( false )
end

-----------------------------------------------------------------------------
-- capture point overrides
-----------------------------------------------------------------------------
function red_cap:oncapture( player, item )
	-- do base class stuff (play sounds)
	-- make the call passing in self as well as the params
	basecap.oncapture( self, player, item )

	DoCaptureLogic()
end

function blue_cap:oncapture( player, item )
	-- do base class stuff (play sounds)
	-- make the call passing in self as well as the params
	basecap.oncapture( self, player, item )

	DoCaptureLogic()
end

-----------------------------------------------------------------------------
-- map stuff
-----------------------------------------------------------------------------
function DoCaptureLogic()
	ConsoleToAll( "DoCaptureLogic" )
	DoRoundResetLogic()	
end

function DoRoundResetLogic()
	ConsoleToAll( "DoRoundResetLogic" )	

	-- stop round timer schedule if its still going
	DeleteSchedule( "round_timer_schedule" )

	-- Reset round timer
	ResetRoundTimer()	

	-- close door
	CloseDoor( "forceshield" )

	-- reset door schedule
	StartDoorOpenSchedule()
	
	-- finally, respawn everybody
	RespawnEveryone()
end

function DoRoundOverLogic()
	ConsoleToAll( "DoRoundOverLogic" )

	CheckTeamAliveState( Team.kBlue )
	CheckTeamAliveState( Team.kRed )
end

function CheckTeamAliveState( team )
	ConsoleToAll( "CheckTeamAliveState" )
	
	-- Need to test if one player on either team is still
	-- alive and if so, award that team a point
	
	local c = Collection()

	if (team == Team.kBlue) then
		c:GetByFilter({ CF.kPlayers, CF.kTeamBlue })
	else
		c:GetByFilter({ CF.kPlayers, CF.kTeamRed })
	end

	ConsoleToAll( "Count: " .. c:Count() )

	if (c:Count() > 0) then
		local bAlive = false

		for temp in c.items do
			local player = CastToPlayer( temp )
			if player:IsAlive() then
				bAlive = true
			end
		end

		if bAlive then
			local team = GetTeam( Team.kRed )
			team:AddScore( 1 )
		end
	end
end

function StartDoorOpenSchedule()
	ConsoleToAll( "starting door_open_schedule" )
	AddSchedule( "door_open_schedule", 3, door_open_schedule )
end

function ResetRoundTimer()
	ROUND_TIMER_CURRENT = ROUND_TIMER_START
end

function RespawnEveryone()
	ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips, AT.kAllowRespawn, AT.kReturnDroppedItems })
end

-----------------------------------------------------------------------------
-- map stuff - schedules
-----------------------------------------------------------------------------
function door_open_schedule()
	ConsoleToAll( "door_schedule" )

	ConsoleToAll( "opening forceshield" )
	OpenDoor( "forceshield" )	

	ConsoleToAll( "starting round timer schedule" )
	AddScheduleRepeating( "round_timer_schedule", 1, round_timer_schedule )
end

function round_timer_schedule()
	ConsoleToAll( "round_timer_schedule" )

	-- Adjust round timer
	ROUND_TIMER_CURRENT = ROUND_TIMER_CURRENT - 1

	ConsoleToAll( "Timer: " .. ROUND_TIMER_CURRENT )

	if (ROUND_TIMER_CURRENT < 1) then
		DoRoundOverLogic()
		DoRoundResetLogic()
	end	
end
