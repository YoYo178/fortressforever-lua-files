-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base_teamplay")
IncludeScript("base_location")
IncludeScript("base_respawnturret")

-----------------------------------------------------------------------------
-- global overrides that you can do what you want with
-----------------------------------------------------------------------------

FORT_POINTS_PER_HIT = 50
FORT_POINTS_PER_KILL = 100
FORT_POINTS_PER_ESCAPE = 250

POINTS_PER_KILL = 10
POINTS_PER_ESCAPE = 10

THE_WALL_TIMER_DISABLE = 12.5
THE_WALL_TIMER_WARN = 2.5

status = false
num_escaped = 0
round_started = false

-----------------------------------------------------------------------------
-- functions that do sh... stuff
-----------------------------------------------------------------------------

-- sounds, right?
function precache()
	PrecacheSound("otherteam.flagstolen")
	PrecacheSound("misc.bloop")
	PrecacheSound("misc.deeoo")
	PrecacheSound("misc.doop")
end

-- pretty standard setup, aside from scoring starting
function startup()
	-- set up team limits on each team
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	SetTeamName( Team.kBlue, "Runners" )
	SetTeamName( Team.kRed, "Killers" )
	
	-- No civvies.
	local team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kScout, 1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	
	the_wall_reset()
	
	AddScheduleRepeating( "checkalive", 1, CheckTeamAliveState )
	OutputEvent( "moving_block", "Open" )
	OutputEvent( "moving_block2", "Open" )
end

function the_wall_reset()
	RespawnAllPlayers()
	OutputEvent( "green_light", "LightOff" )
	OutputEvent( "red_light", "LightOn" )
	OutputEvent( "invis_wall", "Enable" )
	OutputEvent( "start_beam", "TurnOn" )
	AddSchedule("the_wall_disable", THE_WALL_TIMER_DISABLE, the_wall_disable )
	AddSchedule("the_wall_10secwarn", THE_WALL_TIMER_WARN, the_wall_10secwarn )
end

function the_wall_disable()
	round_start()
	OutputEvent( "invis_wall", "Disable" )
	OutputEvent( "start_beam", "TurnOff" )
	BroadCastMessage("#FF_ROUND_STARTED")
	BroadCastSound("misc.doop")
end

function the_wall_10secwarn()
	BroadCastMessage("#FF_MAP_10SECWARN")
	AddSchedule("the_wall_9secwarn", 1, the_wall_9secwarn )
end

function the_wall_9secwarn()
	BroadCastMessage("#FF_MAP_9SECWARN")
	AddSchedule("the_wall_8secwarn", 1, the_wall_8secwarn )
end

function the_wall_8secwarn()
	BroadCastMessage("#FF_MAP_8SECWARN")
	AddSchedule("the_wall_7secwarn", 1, the_wall_7secwarn )
end

function the_wall_7secwarn()
	BroadCastMessage("#FF_MAP_7SECWARN")
	AddSchedule("the_wall_6secwarn", 1, the_wall_6secwarn )
end

function the_wall_6secwarn()
	BroadCastMessage("#FF_MAP_6SECWARN")
	AddSchedule("the_wall_5secwarn", 1, the_wall_5secwarn )
end

function the_wall_5secwarn()
	BroadCastMessage("#FF_MAP_5SECWARN")
	AddSchedule("the_wall_4secwarn", 1, the_wall_4secwarn )
end

function the_wall_4secwarn()
	BroadCastMessage("#FF_MAP_4SECWARN")
	AddSchedule("the_wall_3secwarn", 1, the_wall_3secwarn )
end

function the_wall_3secwarn()
	BroadCastMessage("#FF_MAP_3SECWARN")
	AddSchedule("the_wall_2secwarn", 1, the_wall_2secwarn )
end

function the_wall_2secwarn()
	BroadCastMessage("#FF_MAP_2SECWARN")
	AddSchedule("the_wall_1secwarn", 1, the_wall_1secwarn )
end

function the_wall_1secwarn()
	BroadCastMessage("#FF_MAP_1SECWARN")
end

-- spawns attackers with flags
function player_spawn( player_entity )

	local player = CastToPlayer( player_entity )
	
	player:AddHealth( 100 )
	player:AddArmor( 300 )
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
	
	player:SetCloakable( true )
	player:SetDisguisable( false )
	
	show_zone_status( player )
	
	-- goalies run fast
	if player:GetClass() == Player.kSpy then
		player:AddEffect( EF.kSpeedlua1, -1, 0, .5 )
		
		player:RemoveWeapon( "ff_weapon_tranq" )
		player:RemoveWeapon( "ff_weapon_nailgun" )
		player:RemoveWeapon( "ff_weapon_supershotgun" )
	elseif player:GetClass() == Player.kScout then
		player:RemoveEffect( EF.kSpeedlua1 )
		player:AddEffect( EF.kSpeedlua2, -1, 0, .1 )
		
		player:RemoveAllWeapons()
	else
		player:RemoveEffect( EF.kSpeedlua1 )
		player:RemoveEffect( EF.kSpeedlua2 )
		
		player:RemoveWeapon( "ff_weapon_autorifle" )
		player:RemoveWeapon( "ff_weapon_nailgun" )
	end
end

function player_killed ( player, damageinfo )

	-- Guy stays dead until round is over
	if round_started then
		player:SetRespawnable( false )
	end
	
	-- if no damageinfo do nothing
	if not damageinfo then return end

	-- Entity that is attacking
	local attacker = damageinfo:GetAttacker()

	-- If no attacker do nothing
	if not attacker then return end

	local player_attacker = nil

	-- get the attacking player
	if IsPlayer(attacker) then
		attacker = CastToPlayer(attacker)
		player_attacker = attacker
	elseif IsSentrygun(attacker) then
		attacker = CastToSentrygun(attacker)
		player_attacker = attacker:GetOwner()
	elseif IsDetpack(attacker) then
		attacker = CastToDetpack(attacker)
		player_attacker = attacker:GetOwner()
	elseif IsDispenser(attacker) then
		attacker = CastToDispenser(attacker)
		player_attacker = attacker:GetOwner()
	else
		return
	end

	-- if still no attacking player after all that, forget about it
	if not player_attacker then return end

  -- If player killed self or teammate do nothing
  if (player:GetId() == player_attacker:GetId()) or (player:GetTeamId() == player_attacker:GetTeamId()) then
	return 
  end
  
  -- If player is an attacker, then do stuff
  if player:GetTeamId() == Team.kBlue then
	player_attacker:AddFortPoints( FORT_POINTS_PER_KILL, "Killing a Runner" )
	local team = player_attacker:GetTeam()
	team:AddScore( POINTS_PER_KILL ) 
  end
  
end

function player_ondamage ( player, damageinfo )
	
	-- if no damageinfo do nothing
	if not damageinfo then return end

	-- Entity that is attacking
	local attacker = damageinfo:GetAttacker()

	-- If no attacker do nothing
	if not attacker then return end

	local player_attacker = nil

	-- get the attacking player
	if IsPlayer(attacker) then
		attacker = CastToPlayer(attacker)
		player_attacker = attacker
	elseif IsSentrygun(attacker) then
		attacker = CastToSentrygun(attacker)
		player_attacker = attacker:GetOwner()
	elseif IsDetpack(attacker) then
		attacker = CastToDetpack(attacker)
		player_attacker = attacker:GetOwner()
	elseif IsDispenser(attacker) then
		attacker = CastToDispenser(attacker)
		player_attacker = attacker:GetOwner()
	else
		return
	end

	-- if still no attacking player after all that, forget about it
	if not player_attacker then return end

  -- If player killed self or teammate do nothing
  if (player:GetId() == player_attacker:GetId()) or (player:GetTeamId() == player_attacker:GetTeamId()) then
	return 
  end
  
  -- If player is an attacker, then do stuff
  if player:GetTeamId() == Team.kBlue then
	player_attacker:AddFortPoints( FORT_POINTS_PER_HIT, "Hitting a Runner" ) 
  end
  
end

finish_line = trigger_ff_script:new({})
-- registers attackers as they enter the cap room
function finish_line:allowed( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		if player:GetTeamId() == Team.kBlue then
			return true
		end
	end
	return false
end
function finish_line:ontouch( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		
		BroadCastSound( "misc.bloop" )
		
		num_escaped = num_escaped + 1
		
		player:AddFortPoints( FORT_POINTS_PER_ESCAPE, "Escaping" ) 
		local team = player:GetTeam( )
		team:AddScore( POINTS_PER_ESCAPE )
	end
end

function update_zone_status( on )
	RemoveHudItemFromAll( "Zone_Status" )
	if on then
		AddHudIconToAll( "hud_cp_green.vtf", "Zone_Status", -16, 48, 32, 32, 3 )
		status = true;
		BroadCastMessage( "GREEN LIGHT!" )
	else
		AddHudIconToAll( "hud_cp_red.vtf", "Zone_Status", -16, 48, 32, 32, 3 )
		status = false;
		BroadCastMessage( "RED LIGHT!" )
	end
end
function show_zone_status( player )
	RemoveHudItem( player, "Zone_Status" )
	if status then
		AddHudIcon( player, "hud_cp_green.vtf", "Zone_Status", -16, 48, 32, 32, 3 )
	else
		AddHudIcon( player, "hud_cp_red.vtf", "Zone_Status", -16, 48, 32, 32, 3 )
	end
end

-- I dunno, does something, not sure what!
function RespawnAllPlayers()
	ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips, AT.kAllowRespawn, AT.kReturnDroppedItems })
end

function CheckTeamAliveState( )
	
	if round_started then
		local c = Collection()

		c:GetByFilter({ CF.kPlayers, CF.kTeamBlue })

		if (c:Count() > 0) then
			local bAlive = false

			num_alive = 0
			for temp in c.items do
				local player = CastToPlayer( temp )
				if player:IsAlive() then
					num_alive = num_alive + 1
				end
			end

			if num_alive == num_escaped then
				round_end()
			end
		end
	end
end

-----------------------------------------------------------------------------
-- Scheduled functions that do stuff
-----------------------------------------------------------------------------

-- Opens the gates and schedules the round's end.
function red_light()
	OutputEvent( "green_light", "LightOff" )
	OutputEvent( "red_light", "LightOn" )
	OutputEvent( "flood_gate", "Open" )
	
	update_zone_status( false )
	
	local time_till_green = math.random(3,5)
	AddSchedule( "changetogreen", time_till_green, green_light )
end

-- Checks to see if it's the first or second round, then either swaps teams, or ends the game.
function green_light()
	OutputEvent( "red_light", "LightOff" )
	OutputEvent( "green_light", "LightOn" )
	OutputEvent( "flood_gate", "Close" )
	
	update_zone_status( true )
	
	local time_till_red = math.random(1,3) + math.random()
	AddSchedule( "changetored", time_till_red, red_light )
end

-- Sends a message to all after the determined time
function schedulemessagetoall( message )
	BroadCastMessage( message )
end

-- Plays a sound to all after the determined time
function schedulesound( sound )
	BroadCastSound( sound )
end

-- Opens the gates and schedules the round's end.
function round_start()
	green_light()
	OutputEvent( "end_beam", "Color", "22 128 233" )
	num_escaped = 0
	round_started = true
end

-- Checks to see if it's the first or second round, then either swaps teams, or ends the game.
function round_end()
	
	red_light()
	OutputEvent( "flood_gate", "Close" )
	
	RemoveSchedule( "changetored" )
	RemoveSchedule( "changetogreen" )
	
	OutputEvent( "end_beam", "Color", "255 255 255" )
	
	num_escaped = 0
	
	ApplyToAll({ AT.kDisallowRespawn })
	BroadCastMessage( "Round restarting! Wait to respawn..." )
	AddSchedule( "reset", 3, the_wall_reset )
	
	round_started = false
	
end

red_spawn = { validspawn = function(self,player) return player:GetTeamId() == Team.kRed and player:GetClass() ~= Player.kScout end }
detector_spawn = { validspawn = function(self,player) return player:GetTeamId() == Team.kRed and player:GetClass() == Player.kScout end }
