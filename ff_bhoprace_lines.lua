IncludeScript("base_teamplay")
IncludeScript("base_race")

function startup()
	SetGameDescription( "BHOP Race" )
	
	-- set up team limits
	local team = GetTeam( Team.kBlue )
	team:SetPlayerLimit( 0 )

	team = GetTeam( Team.kRed )
	team:SetPlayerLimit( -1 )

	team = GetTeam( Team.kYellow )
	team:SetPlayerLimit( -1 )

	team = GetTeam( Team.kGreen )
	team:SetPlayerLimit( -1 )
	
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kScout, -1)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kSoldier, -1)
	team:SetClassLimit(Player.kDemoman, -1)
	team:SetClassLimit(Player.kMedic, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kEngineer, -1)
	team:SetClassLimit(Player.kHwguy, -1)
	team:SetClassLimit(Player.kSpy, -1)
	
	SetTeamName( Team.kBlue, "Racers" )
end

function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	player:AddHealth( 100 )
	player:AddArmor( 300 )
end

function player_ondamage( player, damageinfo )
	damageinfo:ScaleDamage(0)
end

trigger_reset = trigger_ff_script:new()

function trigger_reset:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		RunReset( player )
		player:Respawn()
	end
end

trigger_start = trigger_ff_script:new()

function trigger_start:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		RunStarted( player )
	end
end

trigger_end = trigger_ff_script:new()

function trigger_end:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		RunFinished( player )
		player:Respawn()
	end
end

trigger_end_upper = trigger_end:new()
trigger_end_lower = trigger_end:new()