-----------------------------------------------------------------------------
-- ff_zoom_a.lua
-----------------------------------------------------------------------------
IncludeScript("base_location")
IncludeScript("base_teamplay")
IncludeScript("base_fortball")

----------------------------------------------------------------------
-- Definitions  maybe not used in this map
----------------------------------------------------------------------
CROW_FORTPOINTS = 15

-----------------------------------------------------------------------------
-- Team settings/NAMES
-----------------------------------------------------------------------------


function startup()
	
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, 0)
	SetPlayerLimit(Team.kGreen, 0)

	-- set up team names
	SetTeamName(Team.kBlue, "The Racers")
	SetTeamName(Team.kRed,  "The Rockets")
	SetTeamName(Team.kGreen,  "The Turtles")
	SetTeamName(Team.kYellow,  "The Blazers")
	
-----------------------------------------------------------------------------
-- Class Settings FOUR TEAMS, SET CLASS LIMITS
-----------------------------------------------------------------------------

local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kMedic, 0)
	team:SetClassLimit(Player.kDemoman, -1)
	team:SetClassLimit(Player.kSoldier, -1)
	team:SetClassLimit(Player.kHwguy, -1)
	team:SetClassLimit(Player.kSpy, -1)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kEngineer, -1)
	team:SetClassLimit(Player.kCivilian, -1)
    
local team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kMedic, 0)
	team:SetClassLimit(Player.kDemoman, -1)
	team:SetClassLimit(Player.kSoldier, -1)
	team:SetClassLimit(Player.kHwguy, -1)
	team:SetClassLimit(Player.kSpy, -1)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kEngineer, -1)
	team:SetClassLimit(Player.kCivilian, -1)
	
local team = GetTeam(Team.kGreen)
	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kMedic, 0)
	team:SetClassLimit(Player.kDemoman, -1)
	team:SetClassLimit(Player.kSoldier, -1)
	team:SetClassLimit(Player.kHwguy, -1)
	team:SetClassLimit(Player.kSpy, -1)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kEngineer, -1)
	team:SetClassLimit(Player.kCivilian, -1)

	
local team = GetTeam(Team.kYellow)
	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kMedic, 0)
	team:SetClassLimit(Player.kDemoman, -1)
	team:SetClassLimit(Player.kSoldier, -1)
	team:SetClassLimit(Player.kHwguy, -1)
	team:SetClassLimit(Player.kSpy, -1)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kEngineer, -1)
	team:SetClassLimit(Player.kCivilian, -1)
	
	the_wall_reset()
	
end

function the_wall_reset()
	OutputEvent( "the_wall", "Enable" )
	OutputEvent ( "the_wall_textured", "Toggle" )
    AddSchedule("the_wall_disable", THE_WALL_TIMER_DISABLE, the_wall_disable )
	AddSchedule("the_wall_10secwarn", THE_WALL_TIMER_WARN, the_wall_10secwarn )
end

function the_wall_disable()
	OutputEvent( "the_wall", "Disable" )
	OutputEvent ( "the_wall_textured", "Toggle" )
    BroadCastMessage("#FF_ROUND_STARTED")
	BroadCastSound("otherteam.flagstolen")
end



--  To initially spawn without grenades or jumppads
function player_spawn( player_entity )
    local player = CastToPlayer( player_entity )
    player:AddAmmo( Ammo.kGren2, -4 )
	player:AddAmmo( Ammo.kMancannons, -1) 
    
	player:RemoveAmmo( Ammo.kDetpack, 1) 
	player:RemoveAmmo( Ammo.kMancannons, 1) 
	
--	self.POINT_TRACK_1 == 0
--	self.POINT_TRACK_2 == 0
--	self.POINT_TRACK_3 == 0
--	self.POINT_TRACK_4 == 0
	
end

------------------------------------------
-- base_trigger_jumppad
-- A trigger that emulates a jump pad at your own height/velocity
------------------------------------------

base_trigger_jumppad = trigger_ff_script:new({
	teamonly = false, 
	team = Team.kUnassigned, 
	needtojump = true, 
	push_horizontal = 150,
	push_vertical = 600,
	notouchtime = 0.3,
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
				--hopefully makes players touch the floor before jumppad activates
				--hopefully makes players touch the floor before jumppad activates
				--hopefully makes players touch the floor before jumppad activates
				if self.needtojump and player:IsInAir() then return false; end
				-- if haven't returned yet, allow
		return true;
	end
	return false;
end

function base_trigger_jumppad:ontrigger( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		--if player:IsInJump or player:IsInAir then
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

-----------------------------------------------------------------------------
-- map specific jumppad triggers
-----------------------------------------------------------------------------

jumppad = base_trigger_jumppad:new({})
jumppad_nojump = base_trigger_jumppad:new({ needtojump = false })

jump_01 = base_trigger_jumppad:new({
	needtojump = false, 
	push_horizontal = 1500,
	push_vertical = 50,
})

jump_02 = base_trigger_jumppad:new({
	needtojump = false, 
	push_horizontal = 950,
	push_vertical = 50,
})

jump_03 = base_trigger_jumppad:new({
	needtojump = false, 
	push_horizontal = 1250,
	push_vertical = 0,
})

jump_03a = base_trigger_jumppad:new({
	needtojump = false, 
	push_horizontal = 1450,
	push_vertical = 0,
})



-----------------------------------------------------------
-- Packs
-----------------------------------------------------------

--concbackpack has a single conc
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
		player:RemoveAmmo( Ammo.kGren2, 3 )
		player:AddAmmo( Ammo.kGren2, 1 )
		player:AddArmor( 10 )
		player:AddHealth( 10 )
    	local class = player:GetClass()
        if class == Player.kScout or class == Player.kMedic then BroadCastMessageToPlayer( player, "One conc only" ) end
	end	
end

function concbackpack:dropatspawn() return false 
end

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



-----------------------------------------------------------------------------
-- ff_Zoom Locations 
-----------------------------------------------------------------------------


location_area_01 = location_info:new({ text = "AREA 01", team = Team.kRed })
location_area_02 = location_info:new({ text = "AREA 02", team = Team.kBlue })
location_area_03 = location_info:new({ text = "AREA 03", team = Team.kYellow })
location_area_04 = location_info:new({ text = "AREA 04", team = Team.kYellow })


-----------------------------------------------------------------------------
-- Easter egg shit
-----------------------------------------------------------------------------

--  Lower and reset gravities
trigger_lower_gravity = trigger_ff_script:new({})

function trigger_lower_gravity:ontouch( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    player:SetGravity( 0.08 ) -- number > 0 and <= 1
  	BroadCastMessageToPlayer( player, "::::-Entering Low Grav Space Simulator-::::", 3 , Color.kPink )
  end
end

function trigger_lower_gravity:onendtouch( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    player:SetGravity( 0.08 ) -- back to normal
  end
end

trigger_normal_gravity = trigger_ff_script:new({})

function trigger_normal_gravity:ontouch( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    player:SetGravity( 1 ) -- number > 0 and <= 1
	BroadCastMessageToPlayer( player, "::::-SIMULATION COMPLETE::NORMALIZING GRAVITY-::::", 3 , Color.kPink )
  end
end

function trigger_normal_gravity:onendtouch( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    player:SetGravity( 1 ) -- back to normal
  end
end



-- Extra points/Bonuses
----------------------------------------------------------
--NEED TO RESET THE POINT_TRACKERS TO 0 ON ROUND RESET
--NEED TO RESET THE POINT_TRACKERS TO 0 ON ROUND RESET    -so player can get the skill points again
--NEED TO RESET THE POINT_TRACKERS TO 0 ON ROUND RESET
----------------------------------------------------------

crow_points = trigger_ff_script:new({
	item = "",
	team = 0,
	POINT_TRACK_1 = 0,
	POINT_TRACK_2 = 0,
	POINT_TRACK_3 = 0,
	POINT_TRACK_4 = 0,
	botgoaltype = Bot.kFlagCap,
})

function crow_points:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
			player:AddFortPoints ( CROW_FORTPOINTS, "#FF_FORTPOINTS_CAPTUREFLAG" )
			BroadCastMessageToPlayer( player, "15 SKILL PTS AWARDED! ", 5, Color.kBlue )            
         end
end

crow_points_1 = crow_points:new({})
function crow_points_1:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
			 if self.POINT_TRACK_1 == 0 then  
				player:AddFortPoints ( CROW_FORTPOINTS, "#FF_FORTPOINTS_CAPTUREFLAG" )
				BroadCastMessageToPlayer( player, "15 SKILL PTS AWARDED!", 5, Color.kBlue )   
				OutputEvent ( "points_1_sound", "PlaySound" )
            end
		if self.POINT_TRACK_1 == 1 then  
			BroadCastMessageToPlayer( player, "You already snagged these sucka. NO SKILL PTS AWARDED.", 5, Color.kRed )  
		end
		self.POINT_TRACK_1 = 1	
         end
end

crow_points_2 = crow_points:new({})
function crow_points_2:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
			 if self.POINT_TRACK_2 == 0 then  
				player:AddFortPoints ( CROW_FORTPOINTS, "#FF_FORTPOINTS_CAPTUREFLAG" )
				BroadCastMessageToPlayer( player, "15 SKILL PTS AWARDED!", 5, Color.kBlue )            
            	OutputEvent ( "points_2_sound", "PlaySound" )
            end
		if self.POINT_TRACK_2 == 1 then  
			BroadCastMessageToPlayer( player, "You already snagged these sucka. NO SKILL PTS AWARDED.", 5, Color.kRed )  
		end
		self.POINT_TRACK_2 = 1	
         end
end

crow_points_3 = crow_points:new({})
function crow_points_3:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
			 if self.POINT_TRACK_3 == 0 then  
				player:AddFortPoints ( CROW_FORTPOINTS, "#FF_FORTPOINTS_CAPTUREFLAG" )
				BroadCastMessageToPlayer( player, "15 SKILL PTS AWARDED!", 5, Color.kBlue )            
            OutputEvent ( "points_3_sound", "PlaySound" )
            end
		if self.POINT_TRACK_3 == 1 then  
			BroadCastMessageToPlayer( player, "You already snagged these sucka. NO SKILL PTS AWARDED.", 5, Color.kRed )  
		end
		self.POINT_TRACK_3 = 1	
         end
end

crow_points_4 = crow_points:new({})
function crow_points_4:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
			 if self.POINT_TRACK_4 == 0 then  
				player:AddFortPoints ( CROW_FORTPOINTS, "#FF_FORTPOINTS_CAPTUREFLAG" )
				BroadCastMessageToPlayer( player, "15 SKILL PTS AWARDED!", 5, Color.kBlue )            
            OutputEvent ( "points_4_sound", "PlaySound" )
            end
		if self.POINT_TRACK_4 == 1 then  
			BroadCastMessageToPlayer( player, "You already snagged these sucka. NO SKILL PTS AWARDED.", 5, Color.kRed )  
		end
		self.POINT_TRACK_4 = 1	
         end
end



-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--Base_fortball_Default copied here
--And edited as necessary for my map
-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
ball_carrier = nil
BALL_ALWAYS_ENEMY_OBJECTIVE = false

-- scoring
THE_WALL_TIMER_DISABLE = 12.5
THE_WALL_TIMER_WARN = 2.5

