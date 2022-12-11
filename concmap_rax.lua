IncludeScript("base_location");
IncludeScript("base_teamplay");

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
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kScout, 0 )
	
	
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
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kScout, 0 )

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
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kScout, 0 )
	
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
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kScout, 0 )

end

function precache()
	PrecacheSound("misc.doop")
end

-- Disable conc effect.
function player_onconc( player_entity, concer_entity )
	return false
end


-- Fully resupplies the player.
function fullresupply( player )
	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, -400 )
	player:AddAmmo( Ammo.kCells, -400 )
	
	player:AddAmmo( Ammo.kGren1, -4 )
	player:AddAmmo( Ammo.kGren2, 4 )
end


-- Fully resupplies the player on spawn.
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	fullresupply( player )
end

resup = trigger_ff_script:new({ })

-- Fully resupplies the players once every 0.1 seconds when they are inside the resupply zone.
function resup:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		fullresupply( player )
	end
	-- Return true to allow triggering the zone if needed.
	return true
end

------------------------------------------------------------------
-- LOCATIONS
------------------------------------------------------------------

location_jump1 = location_info:new({ text = "Jump 1", team = NO_TEAM })
location_jump2 = location_info:new({ text = "Jump 2", team = NO_TEAM })
location_jump3 = location_info:new({ text = "Jump 3", team = NO_TEAM })
location_jump4 = location_info:new({ text = "Jump 4", team = NO_TEAM })
location_jump5 = location_info:new({ text = "Jump 5", team = NO_TEAM })
location_jump6 = location_info:new({ text = "Jump 6", team = NO_TEAM })
location_jump7 = location_info:new({ text = "Jump 7", team = NO_TEAM })
location_jump8 = location_info:new({ text = "Jump 8", team = NO_TEAM })
location_jump9 = location_info:new({ text = "Jump 9", team = NO_TEAM })
location_jump10 = location_info:new({ text = "Jump 10", team = NO_TEAM })
location_end = location_info:new({ text = "END", team = NO_TEAM })

------------------------------------------------------------------
-- DOORS
------------------------------------------------------------------

openDoor1 = trigger_ff_script:new({ })

function openDoor1:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		OutputEvent("enddoor1_fdr", "Open")
	end
	-- Return true to allow triggering the zone if needed.
	return true
end

openDoor2 = trigger_ff_script:new({ })

function openDoor2:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		OutputEvent("enddoor2_fdr", "Open")
	end
	-- Return true to allow triggering the zone if needed.
	return true
end

openDoor3= trigger_ff_script:new({ })

function openDoor3:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		OutputEvent("enddoor3_fdr", "Open")
	end
	-- Return true to allow triggering the zone if needed.
	return true
end

openDoor4 = trigger_ff_script:new({ })

function openDoor4:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		OutputEvent("enddoor4_fdr", "Open")
	end
	-- Return true to allow triggering the zone if needed.
	return true
end

openDoor5 = trigger_ff_script:new({ })

function openDoor5:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		OutputEvent("enddoor5_fdr", "Open")
	end
	-- Return true to allow triggering the zone if needed.
	return true
end

openDoor6 = trigger_ff_script:new({ })

function openDoor6:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		OutputEvent("enddoor6_fdr", "Open")
	end
	-- Return true to allow triggering the zone if needed.
	return true
end

openDoor7 = trigger_ff_script:new({ })

function openDoor7:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		OutputEvent("enddoor7_fdr", "Open")
	end
	-- Return true to allow triggering the zone if needed.
	return true
end

------------------------------------------------------------------
-- FF POINTS
------------------------------------------------------------------

tele7 = trigger_ff_script:new({})

function tele7:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		player:AddFortPoints(600, "Map Completed")
	end
end

tele6 = trigger_ff_script:new({})

function tele6:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		player:AddFortPoints(800, "Map Completed")
	end
end

tele5 = trigger_ff_script:new({})

function tele5:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		player:AddFortPoints(1000, "Map Completed")
	end
end

tele4 = trigger_ff_script:new({})

function tele4:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		player:AddFortPoints(1200, "Map Completed")
	end
end

tele3 = trigger_ff_script:new({})

function tele3:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		player:AddFortPoints(1400, "Map Completed")
	end
end

tele2 = trigger_ff_script:new({})

function tele2:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		player:AddFortPoints(1600, "Map Completed")
	end
end

tele1 = trigger_ff_script:new({})

function tele1:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		player:AddFortPoints(1800, "Map Completed")
	end
end

------------------------------------------------------------------
-- MESSAGES TO PLAYER
------------------------------------------------------------------

message1 = trigger_ff_script:new({})

function message1:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "Good Luck!")
	end
end

message2 = trigger_ff_script:new({})

function message2:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "Here's something different...")
	end
end

message3 = trigger_ff_script:new({})

function message3:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "Don't get tired now...")
	end
end

message4 = trigger_ff_script:new({})

function message4:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "Take a break and relax, you're half-way done...")
	end
end

message5 = trigger_ff_script:new({})

function message5:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "Get ready for a juggle, and take to the sky...")
	end
end

message6 = trigger_ff_script:new({})

function message6:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "For a new approach...")
	end
end

message7 = trigger_ff_script:new({})

function message7:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "You're on the brink of completion...")
	end
end

messagedone = trigger_ff_script:new({})

function messagedone:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "Congrats, you've finished the map.")
	end
end