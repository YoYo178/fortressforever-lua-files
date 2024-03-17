IncludeScript("base_teamplay")
IncludeScript("base_location")
IncludeScript("base_respawnturret")

-----------------------------------------------------------------------------
-- Globals
-----------------------------------------------------------------------------
if POINTS_PER_CAPTURE == nil then POINTS_PER_CAPTURE = 10 end
if FORTPOINTS_PER_PUSH == nil then FORTPOINTS_PER_PUSH = 5 end
if FORTPOINTS_PER_DEFENSE == nil then FORTPOINTS_PER_DEFENSE = 100 end
if FORTPOINTS_PER_BLOCK == nil then FORTPOINTS_PER_BLOCK = 10 end
--if TRAIN_SPEED_MAX == nil then TRAIN_SPEED_MAX = 300 end 
if TRAIN_PUSHERS_MAX == nil then TRAIN_PUSHERS_MAX = 11 end 
if INITIAL_ROUND_DELAY == nil then INITIAL_ROUND_DELAY = 45; end

draw_hud = false

attackers = Team.kBlue
defenders = Team.kRed

max_train_progress = 333 -- approx. player*seconds it takes to reach the end of the line
train_progress = 0
-----------------
--spawns
-----------------

--never bothered to rename the map spawns
redallowedmethod = function(self,player) return player:GetTeamId() == defenders end
blueallowedmethod = function(self,player) return player:GetTeamId() == attackers end


-----------------
--setup functions
-----------------

function precache()
	PrecacheSound("yourteam.flagcap")
end

function startup()
	SetGameDescription( "Payload" )
	
	-- set up team limits
	local team = GetTeam( Team.kBlue )
	team:SetPlayerLimit( 0 )

	team = GetTeam( Team.kRed )
	team:SetPlayerLimit( 0 )

	team = GetTeam( Team.kYellow )
	team:SetPlayerLimit( -1 )

	team = GetTeam( Team.kGreen )
	team:SetPlayerLimit( -1 )

	-- CTF maps generally don't have civilians,
	-- so override in map LUA file if you want 'em
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
	
	-- set them team names
--	SetTeamName( attackers, "Attackers" )
--	SetTeamName( defenders, "Defenders" )

	setup_door_timer("start_gate", INITIAL_ROUND_DELAY)
	
	ATTACKERS_OBJECTIVE_ENTITY = GetEntityByName( "cart_train" )
	DEFENDERS_OBJECTIVE_ENTITY = GetEntityByName( "cart_train" )
	UpdateTeamObjectiveIcon( GetTeam(Team.kBlue ), ATTACKERS_OBJECTIVE_ENTITY )
	UpdateTeamObjectiveIcon( GetTeam(Team.kRed ), DEFENDERS_OBJECTIVE_ENTITY )

	AddScheduleRepeating("track_progress", 1, track_progress)

	AddScheduleRepeating("update_hud", 3, update_hud)
end

function round_30secwarn()
	BroadCastMessage("#FF_ROUND_30SECWARN")
end
function round_10secwarn()
	BroadCastMessage("#FF_ROUND_10SECWARN")
end
function round_5secwarn()
	BroadCastMessage("5")
	SpeakAll("AD_5SEC")
end
function round_4secwarn()
	BroadCastMessage("4")
	SpeakAll("AD_4SEC")
end
function round_3secwarn()
	BroadCastMessage("3")
	SpeakAll("AD_3SEC")
end
function round_2secwarn()
	BroadCastMessage("2")
	SpeakAll("AD_2SEC")
end
function round_1secwarn()
	BroadCastMessage("1")
	SpeakAll("AD_1SEC")
end

-------------------------
--The Payload Trigger
-------------------------
basePushVolume = trigger_ff_script:new({
	enabled = false,
	health = 4,
	armor = 2,
	shells = 1,
	nails = 5,
	rockets = 1,
	cells = 5,
	detpacks = 0,
	mancannons = 0,
	gren1 = 0,
	gren2 = 0,
	team = 0,
	blocked = false
})

colPushers = Collection()
colBlockers = Collection()

function basePushVolume:allowed(entity)
	if not self.enabled then return end
	if IsPlayer( entity ) then
		local player = CastToPlayer( entity )
		if player:IsCloaked() then return EVENT_DISALLOWED end
		if player:IsDisguised() and player:GetTeamId() ~= player:GetDisguisedTeam()  then return EVENT_DISALLOWED
		else return EVENT_ALLOWED	
		end
	end
	return EVENT_DISALLOWED --not a player
end

function basePushVolume:ontrigger (entity)
	if not self.enabled then return end
	if IsPlayer( entity ) then
		local player = CastToPlayer( entity )
		if player:GetTeamId() == self.team then
			player:AddFortPoints(FORTPOINTS_PER_PUSH, "Pushing the Train")
			player:AddHealth( self.health ) 
			player:AddArmor( self.armor ) 

			player:AddAmmo( Ammo.kNails, self.nails ) 
			player:AddAmmo( Ammo.kShells, self.shells ) 
			player:AddAmmo( Ammo.kRockets, self.rockets ) 
			player:AddAmmo( Ammo.kCells, self.cells ) 
		elseif colPushers:Count() > 0 then
			player:AddFortPoints( FORTPOINTS_PER_BLOCK, "Blocking the Train" )
		end
	end
end

function basePushVolume:ontouch (entity)
	if not self.enabled then return end
	if IsPlayer( entity ) then
		local player = CastToPlayer( entity )
		player:SetDisguisable(false)
		player:SetCloakable(false)
		if player:GetTeamId() == self.team then
			colPushers:AddItem(player)
			refreshTrainSpeed()
		else
			colBlockers:AddItem(player)
			refreshTrainSpeed()			
		end
	end
end

function basePushVolume:onendtouch (entity)
	if not self.enabled then return end
	if IsPlayer( entity ) then
		local player = CastToPlayer( entity )
		player:SetDisguisable(true)
		player:SetCloakable(true)
		--players who change teams, change before triggering onendtouch
		--but both teams are being removed anyway
		colPushers:RemoveItem(player)
		colBlockers:RemoveItem(player)
		refreshTrainSpeed()
	end
end

blue_PushVolume = basePushVolume:new({team = attackers})
red_PushVolume = basePushVolume:new({team = Team.kRed})
yellow_PushVolume = basePushVolume:new({team = Team.kYellow})
green_PushVolume = basePushVolume:new({team = Team.kGreen})

------------------
--track end
------------------
--this is a trigger_multiple that can only be activated by the train.

trigger_trainend = trigger_ff_script:new({
	team = attackers
})

function trigger_trainend:ontouch()
	if not blue_PushVolume.enabled then return end
	BroadCastSound("yourteam.flagcap")
	local team = GetTeam( self.team )
	team:AddScore(POINTS_PER_CAPTURE)
	colPushers:RemoveAllItems()
	colBlockers:RemoveAllItems()
	refreshTrainSpeed()
	train_progress = 0
	blue_PushVolume.enabled = false
	AddSchedule("round_reset", 5, round_reset)
	OutputEvent("roundend_relay", "Trigger")
end

------------------
--functions
------------------
function refreshTrainSpeed()
	if colPushers:Count() > 0 then
		if colBlockers:Count() > 0 then
			stopTrain()
			basePushVolume.blocked = true
		else
			moveTrain(colPushers:Count())
			basePushVolume.blocked = false
		end
	else
		stopTrain()
		basePushVolume.blocked = false
	end
	update_hud()
end

--This just serves the HUD
--Fairly inaccurate, but might be close enough.
function track_progress()
	if colPushers:Count() > 0 and colBlockers:Count() < 1 then
		train_progress = train_progress + colPushers:Count()
		--ConsoleToAll("progress: "..train_progress)
	end
end

function moveTrain(nPushers)
	OutputEvent( "cart_train", "SetSpeed", tostring(nPushers/TRAIN_PUSHERS_MAX) )
end

function stopTrain()
	OutputEvent( "cart_train", "Stop" )
end

function setup_door_timer(doorname, duration)
	CloseDoor(doorname)
	OutputEvent( "fullcap_trigger", "Trigger")
	AddSchedule("round_start", duration, round_start, doorname)
	AddSchedule("round_30secwarn", duration-30, round_30secwarn)
	AddSchedule("round_10secwarn", duration-10, round_10secwarn)
	AddSchedule("round_5secwarn", duration-5, round_5secwarn)
	AddSchedule("round_4secwarn", duration-4, round_4secwarn)
	AddSchedule("round_3secwarn", duration-3, round_3secwarn)
	AddSchedule("round_2secwarn", duration-2, round_2secwarn)
	AddSchedule("round_1secwarn", duration-1, round_1secwarn)
end

function round_start(doorname)
	BroadCastMessage("#FF_AD_GATESOPEN")
	SpeakAll("AD_GATESOPEN")
	blue_PushVolume.enabled = true
	OpenDoor(doorname)
	draw_hud = true
end

function round_reset()
	setup_door_timer("start_gate", INITIAL_ROUND_DELAY)
	OutputEvent( "cart_train", "SetSpeed", "1" )
	RespawnAllPlayers()
	draw_hud = false
	if teamswitch then
		if attackers == Team.kBlue then
			attackers = Team.kRed
			defenders = Team.kBlue
		else
			attackers = Team.kBlue
			defenders = Team.kRed
		end
		
		-- switch them team names
		SetTeamName( attackers, "Attackers" )
		SetTeamName( defenders, "Defenders" )
	end
end

---------------------
--HUD
---------------------

--I want this to be minimal because it will be called all the time.
function update_hud( )

	if draw_hud then
		RemoveHudItemFromAll( "HUD_Tank" )
		RemoveHudItemFromAll( "HUD_Pushers" )
		RemoveHudItemFromAll( "HUD_Blocked" )
	
		train_x = train_progress/max_train_progress*128-80
		
		AddHudIconToAll( "hud_tank.vtf", "HUD_Tank", train_x, 28, 32, 32, 3 )
		AddHudTextToAll( "HUD_Pushers", "x"..colPushers:Count(), 96, 44, 2 )

		if basePushVolume.blocked then
			AddHudIconToAll( "hud_stop.vtf", "HUD_Blocked", train_x+5, 36, 16, 16, 3 )
		end
	end
end

function flaginfo(player)
	local player = CastToPlayer( player )

	RemoveHudItem( player, "Zone_Status_BG" )
	RemoveHudItem( player, "Zone_Team"..attackers )
	RemoveHudItem( player, "Zone_Team"..defenders )

	
	AddHudIcon( player, "hud_track.vtf", "Zone_Status_BG", -64, 50, 128, 16, 3 )
		
	if player:GetTeamId() == attackers then
		AddHudIcon( player, "hud_offense.vtf", "Zone_Team"..attackers, -110, 38, 24, 24, 3 )
	elseif player:GetTeamId() == defenders then
		AddHudIcon( player, "hud_defense.vtf", "Zone_Team"..defenders, -110, 38, 24, 24, 3 )
	end

	RemoveHudItem( player, "HUD_Tank" )
	RemoveHudItem( player, "HUD_Pushers" )
	RemoveHudItem( player, "HUD_Blocked" )

	train_x = train_progress/max_train_progress*128-80
		
	AddHudIcon( player, "hud_tank.vtf", "HUD_Tank", train_x, 28, 32, 32, 3 )
	AddHudText( player, "HUD_Pushers", "x"..colPushers:Count(), 96, 44, 2 )

	if basePushVolume.blocked then
		AddHudIcon( player, "hud_stop.vtf", "HUD_Blocked", train_x, 36, 16, 16, 3 )
	end
end

---------------------
--Events
---------------------

function player_killed ( player, damageinfo )

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
	if (player:GetId() == player_attacker:GetId()) or (player:GetTeamId() == player_attacker:GetTeamId()) then return end
  
	-- Check if he's in the cap point
	for playerx in colPushers.items do
		playerx = CastToPlayer(playerx)

		if playerx:GetId() == player:GetId() then
			player_attacker:AddFortPoints( FORTPOINTS_PER_DEFENSE, "Defending the Train" ) 
		
			-- for safety, remove player from collection
--			zone_collection:RemoveItem( player )
			-- also for safety, if no more players, reset the cap
--			if zone_collection:Count() == 0 then
--				update_zone_all( )
--				zone_turnoff( phase )
--			end
		end
	end
end

function player_spawn( player_entity )
	
	local player = CastToPlayer( player_entity )
	
	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	
	player:SetCloakable( true )
	player:SetDisguisable( true )	
end