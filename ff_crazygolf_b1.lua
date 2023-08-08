--[[ ff_crazygolf_b1.lua (3-16-15) 10:46
	-- R00Kie
	Stuff to Add:
				Top 5  for both golfer and ball	#| --golfer-- | --ball-- | --score--|
							Example:			1| R00kie     | Headyz   | 1790     |
				Make scoreboard for top 5
				More Commands?
				add more than one start point for all holes if possiable
				Improve ball movement while in air or above XXX velocity 
				make loading screen 
				Fix - Check for ball speed before freezing the ball 
				Fix teleporters on legoman				
				make lua reset bolder on 19
--]]

--Includes--
IncludeScript("base_teamplay")

--Presets--
local BONUS_POINTS = 800
local DISPLAY_TIME = 8
local REQUEST_RADIUS = 128
local UNFREEZE_SHOT_TIME = 3
local PUTTER_BOOST = 10
local MID_BOOST = 15
local LONG_BOOST = 25
local BOTH_ACCEPT = true-- False for Debugging | True for normal mode

-- Required --
local player_table = {}
local civi_golfer = "models/player/civilian/civilian.mdl"
local SoundPrecache =
	{
	"ff_crazygolf/start/lope_makes_me_feel_gay.wav",
	"ff_crazygolf/start/goodsign.wav",
	"ff_crazygolf/hole/belowparr.wav",
	"ff_crazygolf/hole/birdie.wav",
	"ff_crazygolf/hole/tigerwoods.wav",
	"ff_crazygolf/hole/whistle.wav",
	"ff_crazygolf/miss/umm.wav",
	"ff_crazygolf/miss/lope_games_broken.wav",
	"ff_crazygolf/miss/awwohoh.wav",
	"^ff_crazygolf/ballhole.wav",
	"ff_crazygolf/lopefinishgamesound.wav",
	"ff_hunted/CrowdCheer.wav",
	"misc/unagi.wav",
	"ff_hunted/i_am_the_werewolf.wav"
	}
local GolfSounds = 
	{
	"ff_crazygolf.hole",
	"ff_crazygolf.start",
	"ff_crazygolf.inone",
	"ff_crazygolf.miss",
	"ff_crazygolf.finish"
	}
local Balls = 
	{
	"models/props/ff_crazygolf/balls/bluesmiley/bluesmiley.mdl",
	"models/props/ff_crazygolf/balls/redsmiley/redsmiley.mdl", 
	"models/props/ff_crazygolf/balls/greensmiley/greensmiley.mdl",
	"models/props/ff_crazygolf/balls/yellowsmiley/yellowsmiley.mdl",
	"models/props/ff_crazygolf/balls/boulder/boulder.mdl"
	}

function precache()
	for k,v in pairs(Balls) do PrecacheModel(Balls[k]) end
	for k,v in pairs(SoundPrecache) do PrecacheSound(SoundPrecache[k]) end
end

function startup()
	SetGameDescription( "Crazy Golf" ) -- This is crazy golf?
	
 	SetTeamName(Team.kBlue, "Balls")
	SetTeamName(Team.kRed, "Golfers")
	
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)
	
	local team = GetTeam(Team.kBlue)
	
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, 0 ) -- Only Civis on Blue
	team:SetAllies(Team.kRed) -- Red should be allies
	
	team = GetTeam(Team.kRed)
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, 0 ) --JK RED HAS CIVIS TOO
	team:SetAllies(Team.kBlue) -- Blue should be allies
end

function player_spawn( player_entity )
	local player = CastToPlayer ( player_entity )
	
	player_table[player:GetId()] = { accepted_date = false, started_date = false, stroke = 0, current_hole = 0, total_score = 0 }	
	player:SetLocation(player:GetId(), "Matchmaking Area", Team.kUnassigned)
	
	-- Remove HUD info on spawn
	RemoveHudItem( player, "hud_strokes" )
	RemoveHudItem( player, "hud_partner" )
	RemoveHudItem( player, "hud_timer" )
	RemoveHudItem( player, "hud_time" )
	RemoveHudItem( player, "hud_movement" )
	-- Cast stuff to Red players
	if player:GetTeamId() == Team.kRed then	
		-- Remove Unused weapons and ammo --
		player:AddAmmo(Ammo.kGren1, -4)
		player:AddAmmo(Ammo.kGren2, -4)
		player:AddArmor(100)
		player:SetModel(civi_golfer)
		
		player:RemoveWeapon("ff_weapon_supershotgun")
		player:RemoveWeapon("ff_weapon_shotgun")
		player:RemoveWeapon("ff_weapon_crowbar")
		player:RemoveWeapon("ff_weapon_spanner")
		player:RemoveWeapon("ff_weapon_autorifle")
		player:RemoveWeapon("ff_weapon_nailgun")
		player:RemoveWeapon("ff_weapon_deploydispenser")
		player:RemoveWeapon("ff_weapon_deploysentrygun")
		player:RemoveWeapon("ff_weapon_deploydetpack")
		
		player:GiveWeapon("ff_weapon_umbrella", false)
		-- Give Civi something extra
		if player:GetClass() == 10 then
			player:AddEffect( EF.kSpeedlua1, -1, 0, 1.3 )
			player:GiveWeapon("ff_weapon_crowbar", false)
			player:GiveWeapon("ff_weapon_knife", false)
			ChatToPlayer(player, "Driver: ^2Crowbar")
			ChatToPlayer(player, "Iron: ^1Knife")
			ChatToPlayer(player, "Putter: ^4Umbrella")
		end
		
	end
	
	-- Do stuff when Blue spawns too
	if player:GetTeamId() == Team.kBlue then
		local RandomNum = RandomInt(1, #Balls - 1)
		player:SetModel(Balls[RandomNum])
		player:RemoveAllWeapons()
		player:Freeze(true)
		--player:LockInPlace(true)
		player:AddEffect( EF.kSpeedlua1, -1, 0, 0.5 )
	end
end
-- Do Stuff when a player loses their partner
function player_disconnected( player )
	local player = CastToPlayer ( player )
	local partner = player_table[player:GetId()].partner
	
	if partner ~= nil then
		AddSchedule( "Respawnin_partner_"..player:GetId(), 3, no_partner, partner)
	end
end

function player_killed( player )
	local player = CastToPlayer ( player )
	local partner = player_table[player:GetId()].partner
	RemoveTimer( "timer"..player:GetId() )
	RemoveHudItem( player, "hud_strokes" )
	RemoveHudItem( player, "hud_partner" )
	RemoveHudItem( player, "hud_timer" )
	RemoveHudItem( player, "hud_time" )
	RemoveHudItem( player, "hud_movement" )
	
	if partner ~= nil then
		AddSchedule( "Respawnin_partner_"..player:GetId(), 3, no_partner, partner)
	end
end

-- Send you back to the starting area if you dont have a partner
function no_partner(player)
	ChatToPlayer(player, "Your partner has quit or left the game.")
	ChatToPlayer(player, "Sending you back to the Matchmaking Area...")
	
	AddSchedule( "no_partner_"..player:GetId(), 3, pRespawn, player)
end

-- Detect stuff in matchmaking!
pair_matching = trigger_ff_script:new({})

function pair_matching:allowed(allowed_entity)
	if IsPlayer(allowed_entity) then
		return true
	end
	return false
end
function pair_matching:ontrigger( trigger_entity )
	search_player()
end

-- Search for a date
function search_player()
	local c = Collection()
	
	c:GetByFilter({CF.kPlayers, CF.kTeamRed})
	for temp in c.items do
		local player = CastToPlayer( temp )
		if player then
			date_request( player )
		end
	end
end
-- Ask for a date
function date_request(Golfer)
	local c = Collection()
	local radius = REQUEST_RADIUS
	
	c:GetInSphere( Golfer, radius, {CF.kPlayers, CF.kTeamBlue, CF.kTraceBlockWalls} )
	for temp in c.items do
		local player = CastToPlayer( temp )
		local Ball = player
		
		local requester_date = player_table[Golfer:GetId()].accepted_date
		local player_date = player_table[Ball:GetId()].accepted_date
		
		if player then
			if Golfer:GetTeamId() == Team.kRed and not requester_date then 
				if Ball:IsInUse() then
					request_message(Ball, Golfer)
				end
			end	
			if Ball:GetTeamId() == Team.kBlue and not player_date then
				if Golfer:IsInUse() then
					request_message(Golfer, Ball)
				end
			end
			if BOTH_ACCEPT then
				if Golfer:IsInUse() and Ball:IsInUse() and not requester_date then
					accept_date(Ball, Golfer)
				end
			elseif not BOTH_ACCEPT then
				if Golfer:IsInUse() or Ball:IsInUse() and not requester_date then
					accept_date(Ball, Golfer)
				end
			end	
		end
	end
end

function request_message(PlayerOne, PlayerTwo)
	BroadCastMessageToPlayer( PlayerOne, "Are you feeling Lucky?" )
	BroadCastMessageToPlayer( PlayerOne, "Hold USE until Accepted!" )
	BroadCastMessageToPlayer( PlayerTwo, PlayerOne:GetName().." wants you to be your partner. " )
	BroadCastMessageToPlayer( PlayerTwo, "Hold USE to Accept!" )
end

-- Date accepted!
function accept_date(Ball, Golfer)
	local BallID = Ball:GetId()
	local GolferID = Golfer:GetId()
	--Lock the golfer while waiting
	Golfer:LockInPlace(true)
	Golfer:Freeze(true)
	
	start_game_message( Golfer, Ball )
	start_game_message( Ball, Golfer )
	
	--Send Other Information
	ObjectiveNotice( Golfer," and")
	ObjectiveNotice( Ball," are now Dating!")
	
	AddSchedule( "Start Game"..BallID, 4, start_game, Ball, Golfer )
end

function start_game_message( player, partner )
	local matched_message = "COUPLE MATCHED"
	local sending_message = "Sending Couple to the First Hole.."
	local PlayerID = player:GetId()
	
	BroadCastSoundToPlayer(player, GolfSounds[2])
	BroadCastMessageToPlayer(player, matched_message)
	
	AddSchedule( "SendingIn3_"..PlayerID, 1, BroadCastMessageToPlayer, player, sending_message)
	AddSchedule( "SendingIn2_"..PlayerID, 2, BroadCastMessageToPlayer, player, sending_message)
	AddSchedule( "SendingIn1_"..PlayerID, 3, BroadCastMessageToPlayer, player, sending_message)
	
	AddSchedule( "3_"..PlayerID, 1, BroadCastMessageToPlayer, player, "3")
	AddSchedule( "2_"..PlayerID, 2, BroadCastMessageToPlayer, player, "2")
	AddSchedule( "1_"..PlayerID, 3, BroadCastMessageToPlayer, player, "1")

	player_table[PlayerID].accepted_date = true
	player_table[PlayerID].partner = partner
	player_table[PlayerID].partner_sid = partner:GetSteamID()
	player_table[PlayerID].partner_name = partner:GetName()
	player_table[PlayerID].current_hole = 1
	
	
	AddHudText(player, "hud_time", "Time: ", 5, 90, 0, 2)
	AddHudText(player, "hud_partner", "Partner: "..player_table[PlayerID].partner_name, 5, 80, 0, 2)
	AddHudText(player, "hud_strokes", "Stroke: "..player_table[PlayerID].stroke, 5, 70, 0, 2)
	AddHudText(player, "hud_movement", "Status: Stopped", 5, 60, 0, 2)
end
-- Start the date !
 function start_game (Ball, Golfer)
	local hole_number = "Hole One"
	local hole_name = "R00Kie's Lump"
	
	TeleportToEntity( Ball, "hole_1_ball_teleport" )
	TeleportToEntity( Golfer, "hole_1_golfer_teleport" )
	if Golfer:GetClass() == 10 then
		ChatToPlayer(Golfer, "Driver: ^2Crowbar")
		ChatToPlayer(Golfer, "Iron: ^1Knife")
		ChatToPlayer(Golfer, "Putter: ^4Umbrella")
	end
	Golfer:LockInPlace(false)
	Golfer:Freeze(false)
	Ball:LockInPlace(false)
	UpdateObjectiveIcon(Golfer, Ball)
	RemoveTimer( "timer"..Ball:GetId() )
	RemoveTimer( "timer"..Golfer:GetId() )
	AddTimer( "timer"..Ball:GetId(), 0, 1 )
	AddTimer( "timer"..Golfer:GetId(), 0, 1 )
	AddHudTimer(Ball,"hud_timer", "timer"..Ball:GetId(), 38, 90, 0, 2)
	AddHudTimer(Golfer,"hud_timer", "timer"..Golfer:GetId(), 38, 90, 0, 2)
	BroadCastMessageToPlayer( Ball, hole_number, DISPLAY_TIME )
	BroadCastMessageToPlayer( Ball, hole_name, DISPLAY_TIME )
	BroadCastMessageToPlayer( Golfer, hole_number, DISPLAY_TIME )
	BroadCastMessageToPlayer( Golfer, hole_name, DISPLAY_TIME )
end
-- Thanks Squeek !
function TeleportToEntity( player, entity_name )
	if GetEntityByName( entity_name ) ~= nil then
		local neworigin = GetEntityByName( entity_name ):GetOrigin()
		neworigin = Vector(neworigin.x,neworigin.y,neworigin.z+36+16)
		local newangles = GetEntityByName( entity_name ):GetAngles()
		local newvelocity = Vector(0,0,0)
		player:Teleport( neworigin, newangles, newvelocity )
		return true
	else
		return false
	end
end

-- Teleport player back to the starting point of the current hole
function reset_hole(player)
	local hole = player_table[player:GetId()].current_hole
	
	if hole ~= 0 then
		TeleportToEntity( player, "hole_"..tostring(hole).."_ball_teleport" )
		ChatToPlayer(player, "Reset.")
	else
		ChatToPlayer(player, "you can't reset in the Matchmaking Area")
	end
end
-- Clip the golfer so he doesn't fall into holes
clip_golfer = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipPlayersByTeam, ClipFlags.kClipTeamRed, ClipFlags.kClipTeamYellow, ClipFlags.kClipTeamGreen} })

-- Allow the ball to move within a trigger and for one second after leaving it.
ball_movement = trigger_ff_script:new({})
--allow only the ball to touch the trigger
function ball_movement:allowed( allowed_entity ) 
	local player = CastToPlayer( allowed_entity )
	if player:GetTeamId() == Team.kBlue then
		return true 
	end
	return false
end
-- Unfreeze the ball while inside the trigger
function ball_movement:ontrigger( trigger_entity )
	local player = CastToPlayer( trigger_entity )
	player:Freeze(false)
end
-- freeze the ball on leaving the trigger
function ball_movement:onendtouch( trigger_entity )
	local player = CastToPlayer( trigger_entity )
	AddSchedule( "Freezing_"..player:GetId(), 1, pFreeze, player, true)
end
-----------------------------------------------------
--[[ Testing solo play with a Phyx ball
solo_play = func_button:new({})

function solo_play:onuse( player )
	local player = CastToPlayer( player )
	local ball = GetEntityByName( "golf_ball" )
	
	player_table[player:GetId()].play_solo = true
	TeleportToEntity( ball, "hole_1_ball_teleport" )
	TeleportToEntity( player, "hole_1_golfer_teleport" )
	
	ChatToAll("Solo Player: "..player:GetName())
end

function solo_play:allowed() return true end
--]]
-----------------------------------------------------

--Base Hole information
base_goal = trigger_ff_script:new({})

function base_goal:allowed(allowed_entity)
if IsPlayer(allowed_entity) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == Team.kBlue then
			return true
		end		
	end

	return false
end

function base_goal:ontrigger( trigger_entity )
end

function base_goal:ontouch( touch_entity )
	local player = CastToPlayer( touch_entity )
	local Ball = player
	local Golfer = player_table[Ball:GetId()].partner
	local Stroke = player_table[Golfer:GetId()].stroke
	
	player:EmitSound(GolfSounds[1])
	if self.next_hole == 16 then
		GoalTouch(self, Golfer, Ball)
	else
		AddSchedule( "GoalDelay"..Golfer:GetId(), 1.5, GoalTouch, self, Golfer, Ball)
	end
	if Stroke  == 1 then
		AddSchedule( "HoleInOne"..Golfer:GetId(), 1.25, HoleInOne, self, Ball, Golfer)
	end
end

function GoalTouch(self, player, partner)
	TeleportToEntity( player, "hole_"..tostring(self.next_hole).."_golfer_teleport" )
	TeleportToEntity( partner, "hole_"..tostring(self.next_hole).."_ball_teleport" )
end
--Make Sounds and send notice on hole in one
function HoleInOne(self, player, partner)
	BroadCastSoundToPlayer(player, GolfSounds[3])
	BroadCastSoundToPlayer(partner, GolfSounds[3])
	ObjectiveNotice( partner, "and" )
	ObjectiveNotice( player, "Got a Hole in One on Hole "..tostring(self.next_hole - 1).."!" )
end
function base_goal:onendtouch( trigger_entity )
	local Ball = CastToPlayer( trigger_entity )
	local Golfer = player_table[Ball:GetId()].partner
	local Stroke = player_table[Golfer:GetId()].stroke
	if Stroke <= 10 then
		player_table[Ball:GetId()].total_score = player_table[Ball:GetId()].total_score + (110 - (Stroke * 10))
		player_table[Golfer:GetId()].total_score = player_table[Golfer:GetId()].total_score + (110 - (Stroke * 10))
		Ball:AddFortPoints(110 - (Stroke * 10),tostring(Stroke).." Stroke Hole!" )
		Golfer:AddFortPoints(110 - (Stroke * 10),tostring(Stroke).." Stroke Hole!" )
	else
		player_table[Ball:GetId()].total_score = player_table[Ball:GetId()].total_score + 10
		player_table[Golfer:GetId()].total_score = player_table[Golfer:GetId()].total_score + 10
		Ball:AddFortPoints(10, "Over 10 Strokes... You suck.")
		Golfer:AddFortPoints(10, "Over 10 Strokes... You suck.")
		BroadCastSoundToPlayer(Ball, GolfSounds[4])
		BroadCastSoundToPlayer(Golfer, GolfSounds[4])
	end
	UpdateObjectiveIcon(Ball, GetEntityByName("hole_"..tostring(self.next_hole).."_goal"))
	pFreeze(Ball, true)
	player_table[Ball:GetId()].stroke = 0
	player_table[Ball:GetId()].current_hole = self.next_hole
	
	player_table[Golfer:GetId()].stroke = 0
	player_table[Golfer:GetId()].current_hole = self.next_hole

	BroadCastMessageToPlayer( Ball, "Hole "..tostring(self.next_hole), DISPLAY_TIME )
	BroadCastMessageToPlayer( Ball, self.next_name, DISPLAY_TIME )
	BroadCastMessageToPlayer( Golfer, "Hole "..tostring(self.next_hole), DISPLAY_TIME )
	BroadCastMessageToPlayer( Golfer, self.next_name, DISPLAY_TIME )
	
	Ball:SetLocation(entity:GetId(), "Hole "..tostring(self.next_hole).." | "..self.next_name, Team.kUnassigned)
	Golfer:SetLocation(entity:GetId(), "Hole "..tostring(self.next_hole).." | "..self.next_name, Team.kUnassigned)
	
	AddHudText(Golfer, "hud_strokes" , "Stroke: "..player_table[Golfer:GetId()].stroke, 5, 70, 0, 2)
	AddHudText(Ball, "hud_strokes" , "Stroke: "..player_table[Golfer:GetId()].stroke, 5, 70, 0, 2)
	-- End game
	if self.next_hole == 20 then 
		local timerval = GetTimerTime( "timer"..Ball:GetId() )
		local bonus = BONUS_POINTS - math.floor((timerval / 60) * 10)
		
		player_table[Ball:GetId()].total_score = player_table[Ball:GetId()].total_score + bonus
		player_table[Golfer:GetId()].total_score = player_table[Golfer:GetId()].total_score + bonus
		Ball:AddFortPoints(bonus, "Bonus Points!")
		Golfer:AddFortPoints(bonus, "Bonus Points!")
		ObjectiveNotice( Golfer," and")
		ObjectiveNotice( Ball," beat the course!")
		BroadCastMessage(Golfer:GetName().." and "..Ball:GetName()..string.format(" finished the course at %.1f with ", timerval)..tostring(player_table[Golfer:GetId()].total_score).." Points!", 10, Color.kRed)
		BroadCastSound ( "ff_crazygolf.finish" )
		ChatToPlayer(Ball, "Well Done!")
		ChatToPlayer(Ball, "Now sending you to Spectate...")
		ChatToPlayer(Golfer, "Well Done!")
		ChatToPlayer(Golfer, "Now sending you to Spectate...")
	
		AddSchedule( "End_game"..Golfer:GetId(), 7, end_course, Golfer)
		AddSchedule( "End_game"..Ball:GetId(), 7, end_course, Ball)
	end
end
function end_course (player)
	RemoveTimer( "timer"..player:GetId() )
	RemoveHudItem( player, "hud_strokes" )
	RemoveHudItem( player, "hud_partner" )
	RemoveHudItem( player, "hud_timer" )
	RemoveHudItem( player, "hud_time" )
	RemoveHudItem( player, "hud_movement" )
UpdateObjectiveIcon( player, nil )
ChatToPlayer(player, "^5You may watch other players or join in and play again!")
ApplyToPlayer(player, {AT.kRespawnPlayers, AT.kChangeTeamSpectator, AT.kRemoveBuildables})
end
-----------------------------------------------------------------------------
-- bouncepads for lifts
-----------------------------------------------------------------------------
base_jump = trigger_ff_script:new({ pushz = 0 })

function base_jump:ontouch( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		local playerVel = player:GetVelocity()
		playerVel.z = self.pushz
		player:SetVelocity( playerVel )
	end
end

lift_red = base_jump:new({ pushz = 600 })
lift_blue = base_jump:new({ pushz = 600 })

function player_ondamage(player, damageinfo) 
	if not damageinfo then return end

	local damage = damageinfo:GetDamage()
	local attacker = damageinfo:GetAttacker()
	local weapon = damageinfo:GetInflictor():GetClassName()
	
	if not attacker then return end

	local player_attacker = nil
	
	damageinfo:SetDamage(0) -- All Damage is Zero Damage
	-- get the attacking player
	if IsPlayer(attacker) then
		attacker = CastToPlayer(attacker)
		player_attacker = attacker
		
		attacker:AddAmmo(Ammo.kRockets, 100)
		attacker:AddAmmo(Ammo.kNails, 100)
		attacker:AddAmmo( Ammo.kShells, 100 )
		
	-- Only Damage your partner
	if  player_table[attacker:GetId()].partner_sid == player:GetSteamID() and player:GetTeamId() ~= Team.kRed then
		if damageinfo:GetDamageType() ~= 64 then
			player_table[attacker:GetId()].stroke = player_table[attacker:GetId()].stroke + 1
		end
		AddHudText(attacker, "hud_strokes" , "Stroke: "..player_table[attacker:GetId()].stroke, 5, 70, 0, 2)
		AddHudText(player, "hud_strokes" , "Stroke: "..player_table[attacker:GetId()].stroke, 5, 70, 0, 2)
		AddHudText(player, "hud_movement", "Status: Moving", 5, 60, 0, 2)
		AddHudText(attacker, "hud_movement", "Status: Moving", 5, 60, 0, 2)
		player:Freeze(false)
		AddSchedule( "first_move_ball"..player:GetId(), 0.5, ball_speed, player)
		
		-- Give these weapons Force Boosts
		if weapon == "ff_weapon_umbrella" then
			damageinfo:SetDamageForce( damageinfo:GetDamageForce() * PUTTER_BOOST )
		end
		if weapon == "ff_weapon_knife" then
			damageinfo:SetDamageForce( damageinfo:GetDamageForce() * MID_BOOST )
		end
		if weapon == "ff_weapon_crowbar" then
			damageinfo:SetDamageForce( damageinfo:GetDamageForce() * LONG_BOOST )
		end
		
	elseif player:GetId() == attacker:GetId() then
	--ChatToAll("X: "..player:GetVelocity().x.." Y: "..player:GetVelocity().y.." Z: "..player:GetVelocity().z) -- GetVelocity Debug 
		return
	else
		--ChatToAll(weapon)
		--ChatToAll(tostring(damageinfo:GetDamageType())) -- DEBUG INFO
		
		-- Players shouldn't touch things that are not theirs.
		if player:GetTeamId() == Team.kBlue then
			ChatToPlayer(attacker, "You Can't Touch other player's Balls.")
			
		end
		if player:GetTeamId() == Team.kRed then
			--ChatToPlayer(attacker, "You Can't Touch other players.") -- No Message Required?
		end
		damageinfo:SetDamageForce( Vector(0,0,0) )
	end
	
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

	local damageforce = damageinfo:GetDamageForce()
end

function pFreeze(player, bool)
	local partner = player_table[player:GetId()].partner
	player:Freeze(bool)
	if bool then
		AddHudText(player, "hud_movement", "Status: Stopped", 5, 60, 0, 2)
		AddHudText(partner, "hud_movement", "Status: Stopped", 5, 60, 0, 2)
	end
end

function pRespawn(player)
	ApplyToPlayer(player,{AT.kRespawnPlayers})
end

function player_onchat( player, chatstring )
	local player = CastToPlayer( player )
	local partner = player_table[player:GetId()].partner
	
	-- string.gsub call removes all control characters (newlines, return carriages, etc)
	-- string.sub call removes the playername: part of the string, leaving just the message
	local message = string.sub( string.gsub( chatstring, "%c", "" ), string.len(player:GetName())+3 )
	
	if message == "/quit" then 
		ChatToPlayer(player, "You have Quit.")
		ChatToPlayer(player, "Now returning you to the Matchmaking Area...")
		AddSchedule( "Respawning"..player:GetId(), 3, pRespawn, player)
		if partner ~= nil then
			AddSchedule( "Respawnin_partner_"..player:GetId(), 3, no_partner, partner)
		end
		return false
	end
	if message == "/reset" then 
		reset_hole(player)
		return false
	end
	if message == "/skin" then 
		if player:GetTeamId() == Team.kBlue then
			DestroyMenu( "skin_menu" )
			CreateMenu( "skin_menu", "Ball Skin", 30 )
			AddMenuOption( "skin_menu", 1, "Drugged Blue Ball" )
			AddMenuOption( "skin_menu", 2, "Horny Red Ball" )
			AddMenuOption( "skin_menu", 3, "LOL! Yellow Ball!?" )
			AddMenuOption( "skin_menu", 4, "Green Karl Balls" )
			AddMenuOption( "skin_menu", 5, "....Lope?" )
			AddMenuOption( "skin_menu", 6, "Exit" )
			ShowMenuToPlayer( player, "skin_menu" )
		end
		return false
	end
	if message == "/sound" then
	--BroadCastSoundToPlayer(player, GolfSounds[2]) -- for testing sounds
	player:EmitSound(GolfSounds[2])
	end
	return true
end
function player_onmenuselect( player, menu_name, selection )
	if menu_name == "skin_menu" then
		if selection == 1 then
			player:SetModel(Balls[1]) -- Blue
			ChatToPlayer(player, "Skin Changed to Drugged Ball")
		elseif selection == 2 then
			player:SetModel(Balls[2]) -- Red
			ChatToPlayer(player, "Skin Changed to Horny Ball")
		elseif selection == 3 then
			player:SetModel(Balls[4]) -- Green
			ChatToPlayer(player, "Skin Changed to LOL?!")
		elseif selection == 4 then
			player:SetModel(Balls[3]) -- Yellow
			ChatToPlayer(player, "Skin Changed to Karl")
		elseif selection == 5 then
			player:SetModel(Balls[5]) -- Yellow
			ChatToPlayer(player, "Skin Changed to Lope")
		elseif selection == 6 then
		DestroyMenu( "skin_menu" )
		return
		end
	end
end
function ball_speed (player)
	local speed = player:GetSpeed()
	local playerID = player:GetId()
	local partner = player_table[playerID].partner
	local zVel = player:GetVelocity().z
	if speed > 300 or zVel > 300 or zVel < -300 then 
		--ChatToAll("Passed")
		DeleteSchedule("Add_speed"..playerID)
		AddHudText(player, "hud_movement", "Status: Moving", 5, 60, 0, 2)
		AddHudText(partner, "hud_movement", "Status: Moving", 5, 60, 0, 2)
		AddSchedule( "Add_speed"..playerID, 0.5, ball_speed, player)
		return
	else
		--ChatToAll("Stopped")
		DeleteSchedule("pFreeze_"..player:GetId())
		AddSchedule( "pFreeze_"..player:GetId(), UNFREEZE_SHOT_TIME, pFreeze, player, true)
		return
	end
end

-- Hole 0 RooKies Starting Hole --
hole_1_goal = base_goal:new({next_hole = 2, next_name = "Underpass"}) -- Headzys hole
hole_2_goal = base_goal:new({next_hole = 3, next_name = "Mofo's hole!"}) -- Mofos hole
hole_3_goal = base_goal:new({next_hole = 4, next_name = "Islands"}) -- Headzys hole
hole_4_goal = base_goal:new({next_hole = 5, next_name = "Ski Jump"}) -- Headzys hole
hole_5_goal = base_goal:new({next_hole = 6, next_name = "Around the Bend"}) 	-- Pens Hole
hole_6_goal = base_goal:new({next_hole = 7, next_name = "Cabin Maze"}) -- Airtreks Hole
hole_7_goal = base_goal:new({next_hole = 8, next_name = "Destroyed"}) -- Headzy Destroyed hole
hole_8_goal = base_goal:new({next_hole = 9, next_name = "Windy Day"}) -- Pens Hole Windmill
hole_9_goal = base_goal:new({next_hole = 10, next_name = "Up and Over"}) -- Pens Hole
hole_10_goal = base_goal:new({next_hole = 11, next_name = "Whirl"})-- Ender
hole_11_goal = base_goal:new({next_hole = 12, next_name = "Valley of Ez"})   -- Airtreks Hole
hole_12_goal = base_goal:new({next_hole = 13, next_name = "Frustrating Bastard Hole!"})   --Headzy
hole_13_goal = base_goal:new({next_hole = 14, next_name = "Pekets Sunny Ramps"}) --Peket  
hole_14_goal = base_goal:new({next_hole = 15, next_name = "Jobabob's Hole"})  --Headzy
hole_15_goal = base_goal:new({next_hole = 16, next_name = "Mushroom Land"})   -- Pens Hole
hole_16_goal = base_goal:new({next_hole = 17, next_name = "Knocked-Up"})  --Headzy
hole_17_goal = base_goal:new({next_hole = 18, next_name = "Hot Balls"})	--Headzy
hole_18_goal = base_goal:new({next_hole = 19, next_name = "Bonus Hole!"}) --Headzy
hole_19_goal = base_goal:new({next_hole = 20, next_name = "Fin."}) --R00kie