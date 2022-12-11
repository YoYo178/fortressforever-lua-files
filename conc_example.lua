-- ff_juggleface.lua

IncludeScript("base_location");
IncludeScript("base_teamplay");

function startup()

	SetTeamName( Team.kBlue, "Concussion" )
	SetTeamName( Team.kRed, "No Concussion" )

	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kRed )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam( Team.kRed )
	team:SetAllies( Team.kBlue )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
end

function player_spawn( player_entity )

	local player = CastToPlayer( player_entity )
	local eventName = "rs_" .. player:GetName()
	RemoveSchedule(eventName)
	AddScheduleRepeating(eventName, 0.01, RestockSpam, player, eventName)
end

-- Make red team immune to the concussion effect :D~
function player_onconc( player_entity, concer_entity )
	local player = CastToPlayer( player_entity )
	if player:GetTeamId() == Team.kRed then
		return EVENT_DISALLOWED
	end
	return EVENT_ALLOWED
end

location_ground = location_info:new({ text = "Ground", team = NO_TEAM })
location_stage1 = location_info:new({ text = "Stage 1", team = NO_TEAM })
location_stage2 = location_info:new({ text = "Stage 2", team = NO_TEAM })
location_stage3 = location_info:new({ text = "Stage 3", team = NO_TEAM })
location_stage4 = location_info:new({ text = "Stage 4", team = NO_TEAM })
location_stage5 = location_info:new({ text = "Stage 5", team = NO_TEAM })
location_stage6 = location_info:new({ text = "Stage 6", team = NO_TEAM })
location_stage7 = location_info:new({ text = "Stage 7", team = NO_TEAM })
location_stage8 = location_info:new({ text = "Stage 8", team = NO_TEAM })
location_stage9 = location_info:new({ text = "Stage 9", team = NO_TEAM })
location_stage10 = location_info:new({ text = "Stage 10", team = NO_TEAM })
location_stage11 = location_info:new({ text = "Stage 11", team = NO_TEAM })
location_stage12 = location_info:new({ text = "Stage 12", team = NO_TEAM })
location_stage13 = location_info:new({ text = "Stage 13", team = NO_TEAM })
location_stage14 = location_info:new({ text = "Stage 14", team = NO_TEAM })
location_top = location_info:new({ text = "Top", team = NO_TEAM })


-- Don't give any thing else than concs pleaz
grenadebackpack.gren1 = 0
grenadebackpack.gren2 = 4
grenadebackpack.respawntime = 1
grenadebackpack.health = 400
grenadebackpack.armor = 400

-- Quite a shit method of giving concs, but it'l do for now
shittyconcgiver = trigger_ff_script:new({ })
function location_info:ontouch( touch_entity )

	-- set the location of the player
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		player:AddAmmo( Ammo.kGren2, 4 )
	end
end

function RestockSpam(player_entity, eventName)
	if IsPlayer(player_entity) then
		local player = CastToPlayer(player_entity)
		player:AddHealth(400)
		player:AddArmor(400)
		player:AddAmmo(Ammo.kRockets, 400)
		player:AddAmmo(Ammo.kCells, 400)
		player:AddAmmo(Ammo.kShells, 400)
		player:AddAmmo(Ammo.kNails, 400)
		player:AddAmmo(Ammo.kGren1, 400)
		player:AddAmmo(Ammo.kGren2, 400)
		player:AddAmmo(Ammo.kDetpack, 1)
		ApplyToPlayer(player, {AT.kReloadClips})
	else
		RemoveSchedule(eventName)
	end
end

function player_ondamage(player_entity, damageinfo)
	if IsPlayer(player_entity) then
		local player = CastToPlayer(player_entity)
		local damage = damageinfo:GetDamage()
		damage = damage*4
	end
end
