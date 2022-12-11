IncludeScript("base_teamplay");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------

-- Disable conc effect
CONC_EFFECT = 0

--
function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then
		return EVENT_DISALLOWED
	end

	return EVENT_ALLOWED
end

-------------------------------------------------------------------------------------

-- Fully resupplies the player.
function fullresupply( player )
	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 100 )
	player:AddAmmo( Ammo.kCells, -400 )
	
	player:AddAmmo( Ammo.kGren1, 4 )
	player:AddAmmo( Ammo.kGren2, 4 )
end

resupply = trigger_ff_script:new({ })

-- Fully resupplies the players once every 0.1 seconds when they are inside the resupply zone.
function resupply:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		fullresupply( player )
	end
	-- Return true to allow triggering the zone if needed.
	return true
end

openDoor = trigger_ff_script:new({ })

function openDoor:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		OutputEvent("door1", "Open")
	end
	-- Return true to allow triggering the zone if needed.
	return true
end

endRace = trigger_ff_script:new({ })

function endRace:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		ConsoleToAll( player:GetName() .. " has won the race!" )
		BroadCastMessage( player:GetName() .. " has won the race!" )
		player:AddFortPoints(1000, "Winner")
		OutputEvent("endRace", "Disable")
		
	end
end

enableEndRace = trigger_ff_script:new({ })

function enableEndRace:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		ConsoleToAll( "enableEndRace triggered" )
		OutputEvent("endRace", "Enable")
	end
	return true
end

function startup()

	SetTeamName( Team.kBlue, "Blue Team" )
	SetTeamName( Team.kRed, "Red Team" )
	SetTeamName( Team.kYellow, "Yellow Team" )
	SetTeamName( Team.kGreen, "Green Team" )

	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, 0 ) 
	
	-- BLUE TEAM
	local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kGreen )
	team:SetAllies( Team.kYellow )
	team:SetAllies( Team.kRed )
	
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kSoldier, 0)
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	
	
	-- RED TEAM
	team = GetTeam( Team.kRed )
	team:SetAllies( Team.kGreen )
	team:SetAllies( Team.kYellow )
	team:SetAllies( Team.kBlue )
	
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kScout, -1 )

	-- GREEN TEAM
	team = GetTeam( Team.kGreen )
	team:SetAllies( Team.kBlue )
	team:SetAllies( Team.kYellow )
	team:SetAllies( Team.kRed )
	
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	
	-- YELLOW TEAM
	team = GetTeam( Team.kYellow )
	team:SetAllies( Team.kGreen )
	team:SetAllies( Team.kBlue )
	team:SetAllies( Team.kRed )
	
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kSoldier, 0)
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	
end

function precache()
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("misc.doop")
	PrecacheModels("buggy")
end