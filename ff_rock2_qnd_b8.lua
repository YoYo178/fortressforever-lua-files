-----------------------------------------------------------------------------
-- Description and Info
-----------------------------------------------------------------------------
-- ff_rock2_qnd_b8.lua
-- Rock2 (capture key/gas release) gameplay stuff

-- TO-DO List
--
-- Detailed writeup on how this all works/function and timings of various entities used.
-- Cleanup and optimisation.
-- Stop milk, pay papers, invade Czechoslovakia.

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base_teamplay");
IncludeScript("base_location");

-----------------------------------------------------------------------------
-- Game Mode Variables (Overridable, tweak as you see fit)
-----------------------------------------------------------------------------

GAS_EFFECT_START = 12
GAS_EFFECT_END = 16
GAS_HURT_START = 15
GAS_HURT_END = 17
SIREN_END = 18
PROTECTIVE_SUIT_CLOSEDOOR = 18
CONTROL_CENTER_DOOR_REOPEN = 25

SUIT_PROTECTION_DURATION = 20
SPOTLIGHT_DURATION = 10
POINTS_PER_CAPTURE = 15

-----------------------------------------------------------------------------
-- Game Mode Constants (DO NOT OVERRIDE!)
-----------------------------------------------------------------------------

--Yes, i know it's technically a gas mask I used, but hopefully, one day, I can use the suits :)
suits = {"gas_suit"}

-----------------------------------------------------------------------------
-- base classes
-----------------------------------------------------------------------------

-- Hook Hurts, so I can tell it to ignore suited players
basehurt = trigger_ff_script:new({ team = Team.kUnassigned, item = "gas suit" })

-----------------------------------------------------------------------------
-- entities
-----------------------------------------------------------------------------

-- The keys (flags)
red_key = baseflag:new({			 team = Team.kRed,
						 model = "models/keycard/keycard.mdl",
						 modelskin = 1,
						 name = "Red Key",
						 hudicon = "hud_flag_red_new.vtf",
						 hudx = 5,
						 hudy = 150,
						 hudwidth = 70,
						 hudheight = 70,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_red.vtf",
						 hudstatusiconhome = "hud_flag_home_red.vtf",
						 hudstatusiconcarried = "hud_flag_carried_red.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 objectiveicon = true,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen}
						 })

blue_key = baseflag:new({			 team = Team.kBlue,
						 model = "models/keycard/keycard.mdl",
						 modelskin = 0,
						 name = "Blue Key",
						 hudicon = "hud_flag_blue_new.vtf",
						 hudx = 5,
						 hudy = 80,
						 hudwidth = 70,
						 hudheight = 70,
						 hudalign = 1, 
						 hudstatusicondropped = "hud_flag_dropped_blue.vtf",
						 hudstatusiconhome = "hud_flag_home_blue.vtf",
						 hudstatusiconcarried = "hud_flag_carried_blue.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 objectiveicon = true,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed,AllowFlags.kYellow,AllowFlags.kGreen}
						 })

-- The buttons (cap points)					   
blue_gasbutton = basecap:new({			team = Team.kBlue, 
						item = {"red_key","yellow_key","green_key"},
						closedoor = "gasdoor"
						})

red_gasbutton = basecap:new({			team = Team.kRed, 
						item = {"blue_key","yellow_key","green_key"},
						closedoor = "gasdoor"
						})

-- The suits (half flag, half bullshit :P)
basesuit = info_ff_script:new({
	name = "base suit",
	team = 0,
	model = "models/barneyhelmet_faceplate.mdl",
	modelskin = 0,
	allowdrop = false,
	touchflags = {AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

gas_suit = basesuit:new({name = "gas suit"})
gas_hurt = basehurt:new({ })

-----------------------------------------------------------------------------
-- map handlers
-----------------------------------------------------------------------------

-- Usual shit
function startup()
	-- set up team limits on each team. Blue/Red only.
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	-- No civvies
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
end

-- Precache as part of the info_ff_script, as standard precache is borked.
function genericbackpack:precache()

	-- precache sounds
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)

	PrecacheSound("yourteam.flagstolen")
	PrecacheSound("otherteam.flagstolen")
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("otherteam.flagcap")
	PrecacheSound("yourteam.drop")
	PrecacheSound("otherteam.drop")
	PrecacheSound("yourteam.flagreturn")
	PrecacheSound("otherteam.flagreturn")
	PrecacheSound("misc.buzwarn")
	PrecacheSound("misc.bloop")

	PrecacheSound("rock2qnd.bluescores")
	PrecacheSound("rock2qnd.redscores")
	PrecacheSound("rock2qnd.teamhaskey")
	PrecacheSound("rock2qnd.enemyhaskey")
	PrecacheSound("rock2qnd.yourkeyreturn")
	PrecacheSound("rock2qnd.enemykeyreturn")
	PrecacheSound("rock2qnd.bluebreach")
	PrecacheSound("rock2qnd.redbreach")
	PrecacheSound("rock2qnd.tochamber")


	-- precache models
	PrecacheModel(self.model)
end

-----------------------------------------------------------------------------
-- altered functions from base_teamplay.lua
-----------------------------------------------------------------------------

-- Speech changes mostly.
function baseflag:touch( touch_entity )
	local player = CastToPlayer( touch_entity )
	-- pickup if they can
	if self.notouch[player:GetId()] then return; end
	
	if player:GetTeamId() ~= self.team then
		-- let the teams know that the flag was picked up
		SmartSound(player, "yourteam.flagstolen", "yourteam.flagstolen", "otherteam.flagstolen")
		SmartSound(player, "rock2qnd.tochamber", "rock2qnd.teamhaskey", "rock2qnd.enemyhaskey")
		SmartMessage(player, "Take key to enemy Gas Chamber!", "Your Team has the Enemy Key!", "The Enemy has your Key!")
		
		-- if the player is a spy, then force him to lose his disguise
		player:SetDisguisable( false )
		-- if the player is a spy, then force him to lose his cloak
		player:SetCloakable( false )
		
		-- note: this seems a bit backwards (Pickup verb fits Player better)
		local flag = CastToInfoScript(entity)
		flag:Pickup(player)
		AddHudIcon( player, self.hudicon, flag:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign )

		-- log action in stats
		LogLuaEvent(player:GetId(), 0, "flag_touch", "flag_name", flag:GetName(), "player_origin", (string.format("%0.2f",player:GetOrigin().x) .. ", " .. string.format("%0.2f",player:GetOrigin().y) .. ", " .. string.format("%0.1f",player:GetOrigin().z) ), "player_health", "" .. player:GetHealth());	
		
		local team = nil
		-- get team as a lowercase string
		if player:GetTeamId() == Team.kBlue then team = "blue" end
		if player:GetTeamId() == Team.kRed then team = "red" end
		if player:GetTeamId() == Team.kGreen then team = "green" end  
		if player:GetTeamId() == Team.kYellow then team = "yellow" end
		
		-- objective icon pointing to the cap
		UpdateObjectiveIcon( player, GetEntityByName( team.."_gasbutton" ) )

		-- 100 points for initial touch on flag
		if self.status == 0 then player:AddFortPoints(FORTPOINTS_PER_INITIALTOUCH, "#FF_FORTPOINTS_INITIALTOUCH") end
		self.status = 1
		self.carriedby = player:GetName()
		self:refreshStatusIcons(flag:GetName())
	end
end

-- more speech changes
function baseflag:onreturn( )
	-- let the teams know that the flag was returned
	local team = GetTeam( self.team )
	SmartTeamMessage(team, "Your Key has returned!", "The enemy key has returned!")
	SmartTeamSound(team, "yourteam.flagreturn", "otherteam.flagreturn")
	SmartTeamSound(team, "rock2qnd.yourkeyreturn", "rock2qnd.enemykeyreturn")
	local flag = CastToInfoScript( entity )

	LogLuaEvent(0, 0, "flag_returned","flag_name",flag:GetName());

	RemoveHudItemFromAll( flag:GetName() .. "location" )
	self.status = 0
	self.droppedlocation = ""
	self:refreshStatusIcons(flag:GetName())
end

function baseflag:attachoffset()

	local offset = Vector( 0, 0, 72 )
	return offset
end

-- Again, speech changes mostly. 
function basecap:oncapture(player, item)

	OutputEvent( "siren_sound", "PlaySound" )
	OutputEvent( "gas_hurt", "SetDamage", "125" )
	OutputEvent( self.closedoor, "Close" )
	OutputEvent( "gasmask_door", "Open" )
	OutputEvent( "gasmask_light", "TurnOn")

	AddSchedule( "gaseffectON", GAS_EFFECT_START, gas_effect_ON)
	AddSchedule( "gaseffectOFF", GAS_EFFECT_END, gas_effect_OFF)
	AddSchedule( "gashurtON", GAS_HURT_START, gas_hurt_ON)
	AddSchedule( "gashurtOFF", GAS_HURT_END, gas_hurt_OFF)
	AddSchedule( "stopsiren", SIREN_END, siren_OFF)
	AddSchedule( "closesuitdoors", PROTECTIVE_SUIT_CLOSEDOOR, protective_suit_doors_CLOSE)
	AddSchedule( "reopencontroldoor", CONTROL_CENTER_DOOR_REOPEN, control_center_door_OPEN, self.closedoor)

	-- Countdown schedule
	AddSchedule( "gas_5sectimer", GAS_HURT_START-5, gas_timewarn, 5 )
	AddSchedule( "gas_4sectimer", GAS_HURT_START-4, gas_timewarn, 4 )
	AddSchedule( "gas_3sectimer", GAS_HURT_START-3, gas_timewarn, 3 )
	AddSchedule( "gas_2sectimer", GAS_HURT_START-2, gas_timewarn, 2 )
	AddSchedule( "gas_1sectimer", GAS_HURT_START-1, gas_timewarn, 1 )

	-- let the teams know that a capture occured
	SmartMessage(player, "#FF_YOUCAP", "#FF_TEAMCAP", "#FF_OTHERTEAMCAP")

	if self.team == Team.kBlue then
		BroadCastSound("rock2qnd.bluescores")
	else
		BroadCastSound("rock2qnd.redscores")
	end
end

-- Making sure suits spawn correctly
function basesuit:spawn()
	self.notouch = { }
	info_ff_script.spawn(self)
	local suit = CastToInfoScript( entity )
end

-- Can't drop suits.
function basesuit:dropitemcmd( owner_entity )
	return false
end

-- Well, it doesn't!
function basesuit:hasanimation() return false end

-- Pickup a suit
function basesuit:touch( touch_entity )

	local player = CastToPlayer( touch_entity )
	local suit = CastToInfoScript(entity)
	
	for i,v in ipairs(suits) do
		if player:HasItem( v ) then 
			BroadCastMessageToPlayer (player, "You already have a Gas Mask!")
			return EVENT_DISALLOWED 
		end
	end

	AddSchedule( "pickup_" .. player:GetName() .."_suit", SUIT_PROTECTION_DURATION, returnsuit, suit, player )
	RemoveHudItem(player, player:GetName() .. "_suit_timer")
	RemoveHudItem(player, player:GetName() .. "_suit_message")
	AddHudText(player, player:GetName() .. "_suit_message", "Gas Mask Protection:", 0, 40, 4)
	AddHudTimer(player, player:GetName() .. "_suit_timer", SUIT_PROTECTION_DURATION +1, -1, 0, 48, 4)

	suit:Pickup(player)
end

-- Moves where the mask is displayed/attached to the player
function basesuit:attachoffset()

	local offset = Vector( 0, 0, 80 )
	return offset
end


-- Only hurt players if they have no suit.
function gas_hurt:allowed ( allowed_entity )
	if IsPlayer( allowed_entity ) then
		-- get the player
		local player = CastToPlayer( allowed_entity )

		-- check if the player has a suit
		for i,v in ipairs(suits) do
			if player:HasItem( v ) then return EVENT_DISALLOWED end
		end

	end
	
	return EVENT_ALLOWED
end

-- checks that enemies are damaging, not self or fall damage
function player_ondamage( player, damageinfo )

	-- check if the player has a suit
	for i,v in ipairs(suits) do
		if player:HasItem( v ) then 
		
			if damageinfo:GetDamageType() == Damage.kEnergyBeam then
				return EVENT_ALLOWED
			else 
				damageinfo:SetDamage(0)
			end
		end
	end

end

---------------------------------------------------
-- Hurts (Copied and very slightly altered from Shutdown LUA)
---------------------------------------------------

hurt = trigger_ff_script:new({ team = Team.kUnassigned })
function hurt:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_DISALLOWED
		end
	end

	return EVENT_ALLOWED
end

blue_respawnlaser = hurt:new({ team = Team.kBlue })
red_respawnlaser = hurt:new({ team = Team.kRed })
green_respawnlaser = hurt:new({ team = Team.kGreen })
yellow_respawnlaser = hurt:new({ team = Team.kYellow })



-----------------------------------------------------------------------------
-- Detable triggers, 2 varieties.  One multiple times, one single use.
-----------------------------------------------------------------------------

-- Multiple Variety - used for the rockslide underground.
detpack_trigger_multiple = trigger_ff_script:new({ team = Team.kUnassigned, team_name = "neutral" })

function detpack_trigger_multiple:onexplode( explosion_entity )
   if IsDetpack( explosion_entity ) then
      local detpack = CastToDetpack( explosion_entity )

         OutputEvent( self.team_name .. "_detpack_hole_multiple", "toggle" )
	 OutputEvent( self.team_name .. "_detpack_hurt_multiple", "toggle" )
	 OutputEvent( self.team_name .. "_detpack_clip_multiple", "toggle" )
   end

   return EVENT_ALLOWED
end

red_detpack_trigger_multiple = detpack_trigger_multiple:new({ team = Team.kRed, team_name = "red" })
blue_detpack_trigger_multiple = detpack_trigger_multiple:new({ team = Team.kBlue, team_name = "blue" })
green_detpack_trigger_multiple = detpack_trigger_multiple:new({ team = Team.kGreen, team_name = "green" })
yellow_detpack_trigger_multiple = detpack_trigger_multiple:new({ team = Team.kYellow, team_name = "yellow" })

-- Single Variety - used for the base breach.
detpack_trigger_single = trigger_ff_script:new({ team = Team.kUnassigned, team_name = "neutral" })

function detpack_trigger_single:onexplode( explosion_entity )
   if IsDetpack( explosion_entity ) then
        local detpack = CastToDetpack( explosion_entity )

	BroadCastSound("misc.buzwarn")
	BroadCastSound(self.sentence)

	BroadCastMessage (self.text, 5, self.textcol )

        OutputEvent( self.team_name .. "_detpack_hole_single", "kill" )
	OutputEvent( self.team_name .. "_detpack_trigger_single", "kill" )

   end

   return EVENT_ALLOWED
end

red_detpack_trigger_single = detpack_trigger_single:new({ team = Team.kRed, team_name = "red", text = "Red Yard has been Breached!", textcol = Color.kRed, sentence = "rock2qnd.redbreach" })
blue_detpack_trigger_single = detpack_trigger_single:new({ team = Team.kBlue, team_name = "blue", text = "Blue Yard has been Breached!", textcol = Color.kBlue, sentence = "rock2qnd.bluebreach" })
green_detpack_trigger_single = detpack_trigger_single:new({ team = Team.kGreen, team_name = "green", text = "Green Yard has been Breached!", textcol = Color.kGreen, sentence = "rock2qnd.greenbreach" })
yellow_detpack_trigger_single = detpack_trigger_single:new({ team = Team.kYellow, team_name = "yellow", text = "Yellow Yard has been Breached!", textcol = Color.kYellow, sentence = "rock2qnd.yellowbreach" })

-----------------------------------------------------------------------------
-- Front doors
-----------------------------------------------------------------------------

frontdoor_trigger = trigger_ff_script:new({ door = "neutral_frontdoor" })

function frontdoor_trigger:ontrigger( trigger_entity )

	if IsPlayer( trigger_entity ) then
		OutputEvent( self.door, "Open")
	end
end

blue_frontdoor_trigger = frontdoor_trigger:new({ door = "blue_frontdoor" })
red_frontdoor_trigger = frontdoor_trigger:new({ door = "red_frontdoor" })
green_frontdoor_trigger = frontdoor_trigger:new({ door = "green_frontdoor" })
yellow_frontdoor_trigger = frontdoor_trigger:new({ door = "yellow_frontdoor" })

-----------------------------------------------------------------------------
-- spotlights
-----------------------------------------------------------------------------

base_spotlight_trigger = trigger_ff_script:new({team = Team.kUnassigned, lightname = "spotlight", pointname = "pointlight", model = "modellight"})

function base_spotlight_trigger:ontrigger( trigger_entity )
	if IsPlayer( trigger_entity ) then
		-- get the player
		local player = CastToPlayer( trigger_entity )

		-- If player is the same team, ignore.
		if player:GetTeamId() == self.team then return end

		-- if player is disguised spy, then ignore.
		if player:IsDisguised() and player:GetDisguisedTeam() == self.team then return end

	end
	
	RemoveSchedule( "turnoff_" .. self.lightname)
	OutputEvent( self.pointname, "LightOn" )
	OutputEvent( self.lightname, "TurnOn" )
	OutputEvent( self.model, "Skin", "0")
	AddSchedule( "turnoff_" .. self.lightname, SPOTLIGHT_DURATION, spotlight_turnoff, self.lightname, self.pointname, self.model )
end

blue_spotlight_trigger_yardfront = base_spotlight_trigger:new({team = Team.kBlue, lightname = "blue_spotlight_yardfront", pointname = "blue_spotlight_yardfront_point", model = "blue_spotlight_yardfront_lamp"})
blue_spotlight_trigger_keyside = base_spotlight_trigger:new({team = Team.kBlue, lightname = "blue_spotlight_keyside", pointname = "blue_spotlight_keyside_point", model = "blue_spotlight_keyside_lamp"})
blue_spotlight_trigger_chamberside = base_spotlight_trigger:new({team = Team.kBlue, lightname = "blue_spotlight_chamberside", pointname = "blue_spotlight_chamberside_point", model = "blue_spotlight_chamberside_lamp"})

red_spotlight_trigger_yardfront = base_spotlight_trigger:new({team = Team.kRed, lightname = "red_spotlight_yardfront", pointname = "red_spotlight_yardfront_point", model = "red_spotlight_yardfront_lamp"})
red_spotlight_trigger_keyside = base_spotlight_trigger:new({team = Team.kRed, lightname = "red_spotlight_keyside", pointname = "red_spotlight_keyside_point", model = "red_spotlight_keyside_lamp"})
red_spotlight_trigger_chamberside = base_spotlight_trigger:new({team = Team.kRed, lightname = "red_spotlight_chamberside", pointname = "red_spotlight_chamberside_point", model = "red_spotlight_chamberside_lamp"})

green_spotlight_trigger_yardfront = base_spotlight_trigger:new({team = Team.kGreen, lightname = "green_spotlight_yardfront", pointname = "green_spotlight_yardfront_point", model = "green_spotlight_yardfront_lamp"})
green_spotlight_trigger_keyside = base_spotlight_trigger:new({team = Team.kGreen, lightname = "green_spotlight_keyside", pointname = "green_spotlight_keyside_point", model = "green_spotlight_keyside_lamp"})
green_spotlight_trigger_chamberside = base_spotlight_trigger:new({team = Team.kGreen, lightname = "green_spotlight_chamberside", pointname = "green_spotlight_chamberside_point", model = "green_spotlight_chamberside_lamp"})

yellow_spotlight_trigger_yardfront = base_spotlight_trigger:new({team = Team.kYellow, lightname = "yellow_spotlight_yardfront", pointname = "yellow_spotlight_yardfront_point", model = "yellow_spotlight_yardfront_lamp"})
yellow_spotlight_trigger_keyside = base_spotlight_trigger:new({team = Team.kYellow, lightname = "yellow_spotlight_keyside", pointname = "yellow_spotlight_keyside_point", model = "yellow_spotlight_keyside_lamp"})
yellow_spotlight_trigger_chamberside = base_spotlight_trigger:new({team = Team.kYellow, lightname = "yellow_spotlight_chamberside", pointname = "yellow_spotlight_chamberside_point", model = "yellow_spotlight_chamberside_lamp"})

-----------------------------------------------------------------------------
-- Scheduled Events
-----------------------------------------------------------------------------

function spotlight_turnoff(lightname, pointname, model)
	OutputEvent( lightname, "TurnOff" )
	OutputEvent( pointname, "LightOff" )
	OutputEvent( model, "Skin", "1" )
end

-- Suit effect wears out, suit returns.
function returnsuit(suit, player)
	suit:Return()
	RemoveHudItem(player, player:GetName() .. "_suit_timer")
	RemoveHudItem(player, player:GetName() .. "_suit_message")
end

function gas_effect_ON()

	OutputEvent( "gas_sound", "PlaySound" )
	OutputEvent( "dustcloud1", "TurnOn" )
	OutputEvent( "gas_fade1", "Fade" )
end

function gas_effect_OFF()

	OutputEvent( "gas_sound", "StopSound" )
	OutputEvent( "dustcloud1", "TurnOff" )
	OutputEvent( "gas_fade2", "Fade" )
end

function gas_hurt_ON()
	ApplyToAll({AT.kDisallowRespawn})
	OutputEvent( "gas_hurt", "Enable" )
end

function gas_hurt_OFF()

	OutputEvent( "gas_hurt", "Disable" )
	ApplyToAll({AT.kAllowRespawn})
end

function siren_OFF()

	OutputEvent( "siren_sound", "StopSound" )
end

function protective_suit_doors_CLOSE()

	OutputEvent( "gasmask_door", "Close" )
	OutputEvent( "gasmask_light", "TurnOff")
end

function control_center_door_OPEN( door )

	OutputEvent( door, "Open")
end

function gas_timewarn( time )
	BroadCastMessage( "#FF_MAP_" .. time .. "SECWARN", 1, Color.kWhite )
	SpeakAll( "AD_" .. time .. "SEC" )
end


-----------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-----------------------------------------------------------------------------------------------------------------------------

location_foyer_blue = location_info:new({ text = "Foyer", team = Team.kBlue})
location_underground_blue = location_info:new({ text = "Underground Tunnel", team = Team.kBlue})
location_yard_blue = location_info:new({ text = "Yard", team = Team.kBlue})
location_offices_corridor_blue = location_info:new({ text = "Offices Corridor", team = Team.kBlue})
location_offices_spawn_blue = location_info:new({ text = "Offices Spawn", team = Team.kBlue})
location_library_blue = location_info:new({ text = "Library", team = Team.kBlue})
location_warden_corridor_blue = location_info:new({ text = "Wardens Office Corridor", team = Team.kBlue})
location_wardensoffice_blue = location_info:new({ text = "Wardens Office", team = Team.kBlue})
location_sewers_blue = location_info:new({ text = "Sewers", team = Team.kBlue})
location_chamberside_corridor_blue = location_info:new({ text = "Chamberside Corridor", team = Team.kBlue})
location_chamberside_spawn_blue = location_info:new({ text = "Chamberside Spawn", team = Team.kBlue})
location_cell_block_observation_blue = location_info:new({ text = "Cellblock Observation", team = Team.kBlue})
location_cell_block_a_blue = location_info:new({ text = "Cellblock 'A'", team = Team.kBlue})
location_cell_block_b_blue = location_info:new({ text = "Cellblock 'B'", team = Team.kBlue})
location_cell_block_corridor_blue = location_info:new({ text = "Cellblock Corridor", team = Team.kBlue})
location_showers_blue = location_info:new({ text = "Shower Room", team = Team.kBlue})
location_gas_chamber_corridor_blue = location_info:new({ text = "Gaschamber Corridor", team = Team.kBlue})
location_outside_chamber_blue = location_info:new({ text = "Outside Gas Chamber", team = Team.kBlue})
location_gas_chamber_blue = location_info:new({ text = "Inside Gas Chamber", team = Team.kBlue})

location_midmap	= location_info:new({ text = "The Waterway", team = Team.kUnassigned})

location_foyer_red = location_info:new({ text = "Foyer", team = Team.kRed})
location_underground_red = location_info:new({ text = "Underground Tunnel", team = Team.kRed})
location_yard_red = location_info:new({ text = "Yard", team = Team.kRed})
location_offices_corridor_red = location_info:new({ text = "Offices Corridor", team = Team.kRed})
location_offices_spawn_red = location_info:new({ text = "Offices Spawn", team = Team.kRed})
location_library_red = location_info:new({ text = "Library", team = Team.kRed})
location_warden_corridor_red = location_info:new({ text = "Wardens Office Corridor", team = Team.kRed})
location_wardensoffice_red = location_info:new({ text = "Wardens Office", team = Team.kRed})
location_sewers_red = location_info:new({ text = "Sewers", team = Team.kRed})
location_chamberside_corridor_red = location_info:new({ text = "Chamberside Corridor", team = Team.kRed})
location_chamberside_spawn_red = location_info:new({ text = "Chamberside Spawn", team = Team.kRed})
location_cell_block_observation_red = location_info:new({ text = "Cellblock Observation", team = Team.kRed})
location_cell_block_a_red = location_info:new({ text = "Cellblock 'A'", team = Team.kRed})
location_cell_block_b_red = location_info:new({ text = "Cellblock 'B'", team = Team.kRed})
location_cell_block_corridor_red = location_info:new({ text = "Cellblock Corridor", team = Team.kRed})
location_showers_red = location_info:new({ text = "Shower Room", team = Team.kRed})
location_gas_chamber_corridor_red = location_info:new({ text = "Gaschamber Corridor", team = Team.kRed})
location_outside_chamber_red = location_info:new({ text = "Outside Gas Chamber", team = Team.kRed})
location_gas_chamber_red = location_info:new({ text = "Inside Gas Chamber", team = Team.kRed})