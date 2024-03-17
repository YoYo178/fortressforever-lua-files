-- ff_jayconc.lua

IncludeScript("base_ctf");
IncludeScript("base_location");
IncludeScript("base_teamplay");
IncludeScript("base_conc");


-----------------------------------------------------------------------------
-- Gametype Setup
-----------------------------------------------------------------------------
-- Disable/Enable Concussion Effect.
CONC_EFFECT = 0

-- Freestyle / Race modes.
CONC_MODE = CONC_FREESTYLE

-- Race Restart Delay
RESTART_DELAY = 10

-- Points and Frags you receive for touching EndZone.
CONC_POINTS = 110
CONC_FRAGS = 10
CROW_FORTPOINTS = 5
BEGINNER_FORTPOINTS = 1
MEDIUM_FORTPOINTS = 2
ADVANCED_FORTPOINTS = 3


reached_end = 0
CONC_FREESTYLE = 0
CONC_RACE = 1


-----------------------------------------------------------------------------
-- Timer for map, needs tweaked
-----------------------------------------------------------------------------
--local player = CastToPlayer( player_entity )
--AddHudTimer(player, "timer", 1000, -1, 0, 70, 4)



-----------------------------------------------------------------------------
-- Concussion Check
-----------------------------------------------------------------------------
function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then
		return EVENT_DISALLOWED
	end

	return EVENT_ALLOWED
end



-----------------------------------------------------------------------------
-- Team settings
-----------------------------------------------------------------------------


function startup()
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, 0)

	SetTeamName(Team.kBlue, " Conc Pimps")
	SetTeamName(Team.kRed,  " Quad Men")
	SetTeamName(Team.kGreen,  " Quad Women")

-----------------------------------------------------------------------------
-- Class Settings
-----------------------------------------------------------------------------
--no overload of  'Team:SetAllies' matched the arguments (Team, number, number)

local team = GetTeam(Team.kBlue)
	team:SetAllies( Team.kRed )
	team:SetAllies( Team.kGreen )
	
	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kMedic, 0)
	
	team:SetClassLimit(Player.kDemoman, -1)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kSoldier, -1)
	team:SetClassLimit(Player.kHwguy, -1)
	team:SetClassLimit(Player.kSpy, -1)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kEngineer, -1)
	
local team = GetTeam( Team.kRed )
	team:SetAllies( Team.kBlue )
	team:SetAllies( Team.kGreen )
	
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )

local team = GetTeam( Team.kGreen )
	team:SetAllies( Team.kBlue )
	team:SetAllies( Team.kRed )
	
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )

AddScheduleRepeating( "restock", 1, restock_all )
end

-----------------------------------------------------------------------------
--  To initially strip ammo
-----------------------------------------------------------------------------
--function player_spawn( player_entity )
--    local player = CastToPlayer( player_entity )
--		player:RemoveAmmo( Ammo.kManCannon, 1 )
--		player:RemoveAmmo( Ammo.kGren1, 4 )
--		player:RemoveAmmo( Ammo.kGren2, 4 )
--		
--end





-----------------------------------------------------------------------------
-- Strip Concs/Jumppads
-----------------------------------------------------------------------------


strip_conc = trigger_ff_script:new({})

function strip_conc:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
		player:RemoveAmmo( Ammo.kGren2, 4 )
		
		player:AddArmor( 200 )
		player:AddHealth( 100 )
		player:AddAmmo( Ammo.kRockets, 50 )
		touchsound = "Backpack.Touch"
		local id = player:GetId()		
		
	local class = player:GetClass()
	if class == Player.kScout or class == Player.kMedic then BroadCastMessageToPlayer( player, "Concs stripped" )   end	             
         end
end

--function strip_conc:touch( touch_entity )
--	if IsPlayer( touch_entity ) then
--		local player = CastToPlayer( touch_entity )
--		local id = player:GetId()		
--		
--	local class = player:GetClass()
--	if class == Player.kScout or class == Player.kMedic then BroadCastMessageToPlayer( player, "Concs stripped" )   end
--	
--	end	
--end


-----------------------------------------------------------------------------
-- Conc trigger -when you pass through get full concs
-----------------------------------------------------------------------------
resupplyzone = trigger_ff_script:new({ })

-- Fully resupplies the players once every 0.1 seconds when they are inside the resupply zone.
function resupplyzone:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		fullresupply( player )
	end
	-- Return true to allow triggering the zone if needed.
	return true
end

-- Fully resupplies the player.
function fullresupply( player )
  player:AddHealth( 100 )
  player:AddArmor( 300 )

  player:AddAmmo( Ammo.kNails, 100 )
  player:AddAmmo( Ammo.kShells, 50 )
  player:AddAmmo( Ammo.kRockets, 50 )
  player:AddAmmo( Ammo.kCells, 400 )
  
  player:AddAmmo( Ammo.kGren1, 4 )
  player:AddAmmo( Ammo.kGren2, 4 )
end


-----------------------------------------------------------
-- Packs
-----------------------------------------------------------
concbackpack = genericbackpack:new({
	health = 50,
	armor = 50,
	nails = 50,
	rockets = 50,
	gren2 = 1,
	respawntime = 0,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"})

	
function concbackpack:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		local id = player:GetId()
		local class = player:GetClass()
    
	if class == Player.kSoldier or class == Player.kDemoman or class==Player.kPyro then	
	player:RemoveAmmo( Ammo.kGren2, 3 )
	player:RemoveAmmo( Ammo.kGren1, 3 )
	player:AddArmor( 200 )
	player:AddHealth( 100 )
	Player:AddAmmo ( Ammo.kRockets, 30 )
	else
	player:RemoveAmmo ( Ammo.kGren2, 3)
	player:AddAmmo( Ammo.kGren2, 1 )
    player:AddArmor( 200 )
	player:AddHealth( 100 )
	end
    	local class = player:GetClass()
        if class == Player.kScout or class == Player.kMedic then BroadCastMessageToPlayer( player, "One conc only" ) end

	end	
end
function concbackpack:dropatspawn() return false 
end



fullconcs = genericbackpack:new({
	health = 50,
	armor = 50,
	nails = 50,
	rockets = 50,
	gren2 = 3,
	mancannons = 0,
	respawntime = 0,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"})

	
function fullconcs:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		local id = player:GetId()		
		local class = player:GetClass()
    if class == Player.kSoldier or class == Player.kDemoman or class==Player.kPyro then	
	player:RemoveAmmo( Ammo.kGren2, 3 )
   
    player:AddAmmo( Ammo.kGren1, 3 )
	player:AddArmor( 200 )
	player:AddHealth( 100 )
	player:AddAmmo ( Ammo.kRockets, 30 )
	else
	player:AddAmmo( Ammo.kGren2, 3 )
    player:AddAmmo( Ammo.kGren1, 3 )
	player:AddArmor( 200 )
	player:AddHealth( 100 )
	end
				
	local class = player:GetClass()
    if class == Player.kScout or class == Player.kMedic then BroadCastMessageToPlayer( player, "Full concs" )    end
  	end	
end

function fullconcs:dropatspawn() return false 
end


-----------------------------------------------------------
-- Extra points/Bonuses
-----------------------------------------------------------
crow_points = trigger_ff_script:new({
	item = "",
	team = 0,
	botgoaltype = Bot.kFlagCap,
})

function crow_points:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
        
		player:AddFortPoints ( CROW_FORTPOINTS, "#FF_FORTPOINTS_CAPTUREFLAG" )
		BroadCastMessageToPlayer( player, "Nice Conc - 10 bonuses points added" )            
            
         end
end



beg_points = trigger_ff_script:new({
	item = "",
	team = 0,
	botgoaltype = Bot.kFlagCap,
})

function beg_points:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
        
		player:AddFortPoints ( BEGINNER_FORTPOINTS, "#FF_FORTPOINTS_CAPTUREFLAG" )
		BroadCastMessageToPlayer( player, "Nice Conc - 1 bonuses points added" )            
            
         end
end

med_points = trigger_ff_script:new({
	item = "",
	team = 0,
	botgoaltype = Bot.kFlagCap,
})

function med_points:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
        
		player:AddFortPoints ( MEDIUM_FORTPOINTS, "#FF_FORTPOINTS_CAPTUREFLAG" )
		BroadCastMessageToPlayer( player, "Nice Conc - 2 bonuses points added" )            
            
         end
end

adv_points = trigger_ff_script:new({
	item = "",
	team = 0,
	botgoaltype = Bot.kFlagCap,
})

function adv_points:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
        
		player:AddFortPoints ( ADVANCED_FORTPOINTS, "#FF_FORTPOINTS_CAPTUREFLAG" )
		BroadCastMessageToPlayer( player, "Nice Conc - 3 bonuses points added" )            
            
         end
end


------------------------------------------
-- base_trigger_jumppad
-- A trigger that emulates a jump pad
------------------------------------------

base_trigger_jumppad = trigger_ff_script:new({
	teamonly = false, 
	team = Team.kUnassigned, 
	needtojump = true, 
	push_horizontal = 1024,
	push_vertical = 512,
	notouchtime = 1,
	notouch = {}
})

function base_trigger_jumppad:allowed( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		-- if jump needs to be pressed and it isn't, disallow
		if self.needtojump and not player:IsInJump() then return false; end
		-- if not able to touch, disallow
		if self.notouch[player:GetId()] then return false; end
		-- if team only and on the wrong team, disallow
		if self.teamonly and player:GetTeamId() ~= self.team then return false; end
		-- if haven't returned yet, allow
		return true;
	end
	return false;
end

function base_trigger_jumppad:ontrigger( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		-- get the direction the player is facing
		local facingdirection = player:GetAbsFacing()
		-- normalize just in case
		facingdirection:Normalize()
		-- calculate new velocity vector using the facing direction
		local newvelocity = Vector( facingdirection.x * self.push_horizontal, facingdirection.y * self.push_horizontal, self.push_vertical )
		-- really hacky way to do this, but make sure the length of the horiz of the new velocity is correct
		-- the proper way to do it is to use the player's eyeangles right vector x Vector(0,0,1)
		local newvelocityhoriz = Vector( newvelocity.x, newvelocity.y, 0 )
		while newvelocityhoriz:Length() < self.push_horizontal do
			newvelocityhoriz.x = newvelocityhoriz.x * 1.1
			newvelocityhoriz.y = newvelocityhoriz.y * 1.1
		end
		newvelocity.x = newvelocityhoriz.x
		newvelocity.y = newvelocityhoriz.y
		-- set player's velocity
		player:SetVelocity( newvelocity )
		self:addnotouch(player:GetId(), self.notouchtime)
	end
end

function base_trigger_jumppad:addnotouch(player_id, duration)
	self.notouch[player_id] = duration
	AddSchedule("jumppad"..entity:GetId().."notouch-" .. player_id, duration, self.removenotouch, self, player_id)
end

function base_trigger_jumppad.removenotouch(self, player_id)
	self.notouch[player_id] = nil
end

-- standard definitions
jumppad = base_trigger_jumppad:new({})
jumppad_nojump = base_trigger_jumppad:new({ needtojump = false })

-- teamonly definitions
jumppad_blue = base_trigger_jumppad:new({ teamonly = true, team = Team.kBlue })
jumppad_red = base_trigger_jumppad:new({ teamonly = true, team = Team.kRed })
jumppad_green = base_trigger_jumppad:new({ teamonly = true, team = Team.kGreen })
jumppad_yellow = base_trigger_jumppad:new({ teamonly = true, team = Team.kYellow })

jumppad_nojump_blue = base_trigger_jumppad:new({ needtojump = false, teamonly = true, team = Team.kBlue })
jumppad_nojump_red = base_trigger_jumppad:new({ needtojump = false, teamonly = true, team = Team.kRed })
jumppad_nojump_green = base_trigger_jumppad:new({ needtojump = false, teamonly = true, team = Team.kGreen })
jumppad_nojump_yellow = base_trigger_jumppad:new({ needtojump = false, teamonly = true, team = Team.kYellow })


--new shit	
--new shit	
--new shit	
--new shit	
--new shit	
--new shit	

------------------------------------------------------
--FLAGS -- taken from Concmap.lua by Public_Slots_Free
------------------------------------------------------
local flags = {"red_flag", "blue_flag", "green_flag", "yellow_flag", "red_flag2", "blue_flag2", "green_flag2", "yellow_flag2"}
-----------------------------------------------------------------------------
-- entities
-----------------------------------------------------------------------------
-- hudalign and hudstatusiconalign : 0 = HUD_LEFT, 1 = HUD_RIGHT, 2 = HUD_CENTERLEFT, 3 = HUD_CENTERRIGHT 
-- (pixels from the left / right of the screen / left of the center of the screen / right of center of screen,
-- AfterShock

blue_flag = baseflag:new({team = Team.kBlue,
						 modelskin = 0,
						 name = "Blue Flag",
						 hudicon = "hud_flag_blue_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
						 hudalign = 1, 
						 hudstatusicondropped = "hud_flag_dropped_blue.vtf",
						 hudstatusiconhome = "hud_flag_home_blue.vtf",
						 hudstatusiconcarried = "hud_flag_carried_blue.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})

red_flag = baseflag:new({team = Team.kRed,
						 modelskin = 1,
						 name = "Red Flag",
						 hudicon = "hud_flag_red_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_red.vtf",
						 hudstatusiconhome = "hud_flag_home_red.vtf",
						 hudstatusiconcarried = "hud_flag_carried_red.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})
						  
yellow_flag = baseflag:new({team = Team.kYellow,
						 modelskin = 2,
						 name = "Yellow Flag",
						 hudicon = "hud_flag_yellow_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_yellow.vtf",
						 hudstatusiconhome = "hud_flag_home_yellow.vtf",
						 hudstatusiconcarried = "hud_flag_carried_yellow.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})

green_flag = baseflag:new({team = Team.kGreen,
						 modelskin = 3,
						 name = "Green Flag",
						 hudicon = "hud_flag_green_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_green.vtf",
						 hudstatusiconhome = "hud_flag_home_green.vtf",
						 hudstatusiconcarried = "hud_flag_carried_green.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})

blue_flag2 = baseflag:new({team = Team.kBlue,
						 modelskin = 0,
						 name = "Blue Flag",
						 hudicon = "hud_flag_blue_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_blue.vtf",
						 hudstatusiconhome = "hud_flag_home_blue.vtf",
						 hudstatusiconcarried = "hud_flag_carried_blue.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})

red_flag2 = baseflag:new({team = Team.kRed,
						 modelskin = 1,
						 name = "Red Flag",
						 hudicon = "hud_flag_red_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_red.vtf",
						 hudstatusiconhome = "hud_flag_home_red.vtf",
						 hudstatusiconcarried = "hud_flag_carried_red.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})
						  
yellow_flag2 = baseflag:new({team = Team.kYellow,
						 modelskin = 2,
						 name = "Yellow Flag",
						 hudicon = "hud_flag_yellow_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_yellow.vtf",
						 hudstatusiconhome = "hud_flag_home_yellow.vtf",
						 hudstatusiconcarried = "hud_flag_carried_yellow.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})

green_flag2 = baseflag:new({team = Team.kGreen,
						 modelskin = 3,
						 name = "Green Flag",
						 hudicon = "hud_flag_green_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_green.vtf",
						 hudstatusiconhome = "hud_flag_home_green.vtf",
						 hudstatusiconcarried = "hud_flag_carried_green.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})

-----------------------------------------------------------------------------
-- Flag (allows own team to get their flag)
-----------------------------------------------------------------------------

function baseflag:touch( touch_entity )
	local player = CastToPlayer( touch_entity )
	-- pickup if they can
	if self.notouch[player:GetId()] then return; end
	
	-- make sure they don't have any flags already
	for i,v in ipairs(flags) do
		if player:HasItem(v) then return end
	end
	
		-- let the teams know that the flag was picked up
		SmartSound(player, "yourteam.flagstolen", "yourteam.flagstolen", "otherteam.flagstolen")
		SmartSpeak(player, "CTF_YOUGOTFLAG", "CTF_GOTFLAG", "CTF_LOSTFLAG")
		SmartMessage(player, "#FF_YOUPICKUP", "#FF_TEAMPICKUP", "#FF_OTHERTEAMPICKUP")
		
		-- if the player is a spy, then force him to lose his disguise
		player:SetDisguisable( false )
		-- if the player is a spy, then force him to lose his cloak
		player:SetCloakable( false )
		
		-- note: this seems a bit backwards (Pickup verb fits Player better)
		local flag = CastToInfoScript(entity)
		flag:Pickup(player)
		AddHudIcon( player, self.hudicon, flag:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign )
		RemoveHudItemFromAll( flag:GetName() .. "_h" )
		RemoveHudItemFromAll( flag:GetName() .. "_d" )
		AddHudIconToAll( self.hudstatusiconhome, ( flag:GetName() .. "_h" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )
		AddHudIconToAll( self.hudstatusiconcarried, ( flag:GetName() .. "_c" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )

		-- log action in stats
		player:AddAction(nil, "ctf_flag_touch", flag:GetName())

		-- 100 points for initial touch on flag
		if self.status == 0 then player:AddFortPoints(FORTPOINTS_PER_INITIALTOUCH, "#FF_FORTPOINTS_INITIALTOUCH") end
		self.status = 1
end


function baseflag:dropitemcmd( owner_entity )

end


--new shit	
--new shit	
--new shit	
--new shit	
--new shit	
--new shit	



----------------------------------------------------------------------
-- Quad icon
----------------------------------------------------------------------

hudicon = "hud_quad"
hudx = 5
hudy = 110
hudw = 48
hudh = 48
huda = 1
hudstatusicon = "hud_quad.vtf"

----------------------------------------------------------------------
-- Set hud icon at spawn
----------------------------------------------------------------------

function player_spawn( player_entity )
    local player = CastToPlayer( player_entity )
		player:RemoveAmmo( Ammo.kManCannon, 1 )
		player:RemoveAmmo( Ammo.kGren1, 4 )
		player:RemoveAmmo( Ammo.kGren2, 4 )
	local class = player:GetClass()
     	
	if class == Player.kSoldier or class == Player.kDemoman or class==Player.kPyro then
        if player:GetTeamId() ~= Team.kRed then
	    RemoveHudItem( player, hudstatusicon )
 	else
 	    AddHudIcon(player, hudicon, hudstatusicon, hudx, hudy, hudw, hudh, huda)
	end
    else
	RemoveHudItem( player, hudstatusicon )
    end
end


----------------------------------------------------------------------
-- Remove hud icon if player changes to spectator
----------------------------------------------------------------------

function player_switchteam( player, currentteam, desiredteam )
    if desiredteam == Team.kSpectator then
    	RemoveHudItem( player, hudstatusicon )
    end
    return true
end

----------------------------------------------------------------------
-- Set quad and invul when damage is taken by soldier and demoman and pyro
----------------------------------------------------------------------

function player_ondamage( player, damageinfo )
    if player:GetTeamId() ~= Team.kRed and player:GetTeamId() ~= Team.kGreen  then return end
    local class = player:GetClass()
    if class == Player.kSoldier or class == Player.kDemoman or class==Player.kPyro then
	local damageforce = damageinfo:GetDamageForce()
	damageinfo:SetDamageForce(Vector( damageforce.x * 4, damageforce.y * 4, damageforce.z * 4))
	damageinfo:SetDamage( 0 )
	if player:GetTeamId() ~= Team.kGreen  then return end
		ApplyToPlayer(player, { AT.kReloadClips })
    end
end

--new shit	
--new shit	
--new shit	
--new shit	
--new shit	
--new shit	


function restock_all()
	local c = Collection()
--	-- get all scouts and medics
	c:GetByFilter({CF.kPlayers, CF.kPlayerSoldier, CF.kPlayerDemoman, DF.kPlayerPyro})
--	-- loop through all players in the collection
	for temp in c.items do
		local player = CastToPlayer( temp )
		if player then
--			-- add ammo/health/armor/grens/etc
			player:AddAmmo( Ammo.kRockets, 50 )
		end
	end
end
--
--
--Then add this in your startup() function:--
--
--AddScheduleRepeating( "restock", 1, restock_all )








-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

location_j1 = location_info:new({ text = "Jump - 1", team = NO_TEAM })
location_j2 = location_info:new({ text = "Jump - 2", team = NO_TEAM })
location_j3 = location_info:new({ text = "Jump - 3", team = NO_TEAM })
location_j4 = location_info:new({ text = "Jump - 4", team = NO_TEAM })
location_j5 = location_info:new({ text = "Jump - 5", team = NO_TEAM })
location_j6 = location_info:new({ text = "Jump - 6", team = NO_TEAM })
location_j7 = location_info:new({ text = "Jump - 7", team = NO_TEAM })
location_j8 = location_info:new({ text = "Jump - 8", team = NO_TEAM })
location_j9 = location_info:new({ text = "Jump - 9", team = NO_TEAM })
location_j10 = location_info:new({ text = "Jump - 10", team = NO_TEAM })
location_j11 = location_info:new({ text = "Jump - 11", team = NO_TEAM })
location_j12 = location_info:new({ text = "Jump - 12", team = NO_TEAM })
location_j13 = location_info:new({ text = "Jump - 13", team = NO_TEAM })
location_j14 = location_info:new({ text = "Jump - 14", team = NO_TEAM })
location_j15 = location_info:new({ text = "Jump - 15", team = NO_TEAM })
location_j16 = location_info:new({ text = "Jump - 16", team = NO_TEAM })
location_j17 = location_info:new({ text = "Jump - 17", team = NO_TEAM })
location_j18 = location_info:new({ text = "Jump - 18", team = NO_TEAM })
location_j19 = location_info:new({ text = "Jump - 19", team = NO_TEAM })
location_j20 = location_info:new({ text = "Jump - 20", team = NO_TEAM })
location_j21 = location_info:new({ text = "Jump - 21", team = NO_TEAM })
location_j22 = location_info:new({ text = "Jump - 22", team = NO_TEAM })
location_j23 = location_info:new({ text = "Jump - 23", team = NO_TEAM })
location_j24 = location_info:new({ text = "Jump - 24", team = NO_TEAM })
location_j25 = location_info:new({ text = "Jump - 25", team = NO_TEAM })
location_j26 = location_info:new({ text = "Jump - 26", team = NO_TEAM })
location_j27 = location_info:new({ text = "Jump - 27", team = NO_TEAM })
location_j28 = location_info:new({ text = "Jump - 28", team = NO_TEAM })
location_j29 = location_info:new({ text = "Jump - 29", team = NO_TEAM })
location_j30 = location_info:new({ text = "Jump - 30", team = NO_TEAM })
location_funroom = location_info:new({ text = "Fun Room", team = NO_TEAM })
location_tzone = location_info:new({ text = "Teleporter Room", team = NO_TEAM })
