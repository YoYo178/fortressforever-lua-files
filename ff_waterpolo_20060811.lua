
-- ff_waterpolo.lua

-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_GOAL = 10
POINTS_PER_GOALIE_RETURN = 1
BALL_RETURN_TIME = 10
BALL_THROW_SPEED = 512

-- precache (sounds)
function precache()
	PrecacheSound("misc.bizwarn")
	PrecacheSound("misc.bloop")
	PrecacheSound("misc.buzwarn")
	PrecacheSound("misc.dadeda")
	PrecacheSound("misc.deeoo")
	PrecacheSound("misc.doop")
	PrecacheSound("misc.woop")

	-- Unagi Power!  Unagi!
	PrecacheSound("misc.unagi")
end

function startup()

	-- set up team limits (blue & red are unlimited, while yellow and green get 1 goalie each)
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, 0 )

	SetTeamName( Team.kBlue, "Blue" )
	SetTeamName( Team.kRed, "Red" )
	SetTeamName( Team.kYellow, "Blue Goalie" )
	SetTeamName( Team.kGreen, "Red Goalie" )

	local team = GetTeam(Team.kBlue)
	team:SetAllies( Team.kYellow )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam(Team.kRed)
	team:SetAllies( Team.kGreen )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam(Team.kYellow)
	team:SetAllies( Team.kBlue )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, 0 )

	team = GetTeam(Team.kGreen)
	team:SetAllies( Team.kRed )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, 0 )

-- To constantly spam the ball's status
   AddScheduleRepeating( "DoScoring", 1, DoScoring, 0 )

end

--TIME = 0

--function DoScoring( ent_id )
--	if IsPlayer( ent_id ) then
--		local player = GetPlayer( ent_id )
--		local team = player:GetTeam()
--		team:AddScore( POINTS_PER_HOLDING )
--		--AddSchedule( "DoScoring", 2, DoScoring, ent_id )
--	end
--	
--	-- Find the ball
--	local entity = GetInfoScriptByName( "ball" )
--	
--	-- Print its state
--	ConsoleToAll( "[C] " .. PrintBool(entity:IsCarried()) .. " [D] " .. PrintBool(entity:IsDropped()) .. " [R] " .. PrintBool(entity:IsReturned()) .. " [A] " .. PrintBool(entity:IsActive()) .. " [I] " .. PrintBool(entity:IsInactive()) .. " [RE] " .. PrintBool(entity:IsRemoved()) .. " [" .. TIME .. "]" )
--
--	TIME = TIME + 1
--
--	if TIME == 20 then
--		entity:Remove()
--	end
--
--	if TIME == 40 then
--		entity:Restore()
--	end
--	
--end


function player_ondamage( player, damageinfo )

	-- goalies are invincible
	--local player = GetPlayerByID( player_id )
	if player then

		if player:GetTeamId() == Team.kYellow or player:GetTeamId() == Team.kGreen then
			-- ConsoleToAll( player:GetName() .. " is an invincible goalie!" )
			damageinfo:SetDamage(0)
		-- goalies also have Unagi Power!  Unagi!
		--elseif 
--
--			local goalie = GetPlayer( info_attacker )
--			if goalie then
--
--				if goalie:GetTeamId() == Team.kYellow or goalie:GetTeamId() == Team.kGreen then
--					ConsoleToAll( GetPlayerName( info_attacker ) .. " has Unagi Power!  Unagi!" )
--					BroadCastSound ( "misc.unagi" )
--					info_damage = info_damage * 69
--				end
--
--			end
		end

	end

end



-- ball information
base_ball = info_ff_script:new({
	name = "base ball",
	model = "models/items/ball/ball.mdl",
	modelskin = 0
})

function base_ball:hasanimation() return true end
function base_ball:usephysics() return true end

function base_ball:touch( touch_entity )
	if IsPlayer( touch_entity ) then

		local player = CastToPlayer( touch_entity )
		if self.notouch[player:GetId()] then return end

		local ball = CastToInfoScript( entity )
	
		-- goalies return the ball
		if player:GetTeamId() == Team.kYellow or player:GetTeamId() == Team.kGreen then
			ConsoleToAll( player:GetName() .. " returned the ball!" )
			SmartSound( player, "misc.deeoo", "misc.deeoo", "misc.deeoo" )
			SmartMessage( player, "#FF_WATERPOLO_YOU_RETURN", "#FF_WATERPOLO_TEAM_GOALIE_RETURN", "#FF_WATERPOLO_ENEMY_GOALIE_RETURN" )
			player:AddFrags( POINTS_PER_GOALIE_RETURN )
			ball:Return()
		-- non-goalies pick up the ball
		-- else
		-- unless feigned?
		elseif not player:IsFeigned() then
			ConsoleToAll( player:GetName() .. " has the ball!" )
			SmartSound( player, "misc.bloop", "misc.bloop", "misc.bloop" )
			SmartMessage( player, "#FF_WATERPOLO_YOU_PICKUP", "#FF_WATERPOLO_TEAM_PICKUP", "#FF_WATERPOLO_ENEMY_PICKUP" )
			ball:Pickup( player )
		end
	end
end

function base_ball:ownerdie( owner_entity )
	if IsPlayer( owner_entity ) then
		local player = CastToPlayer( owner_entity )
		-- drop the ball
		ConsoleToAll( player:GetName() .. " died and dropped the ball!" )
		local ball = CastToInfoScript( entity )
		ball:Drop( BALL_RETURN_TIME )
	end
end

function base_ball:ownerfeign( owner_entity )
	if IsPlayer( owner_entity ) then
		local player = CastToPlayer( owner_entity )
		-- drop the ball
		ConsoleToAll( player:GetName() .. " feigned and dropped the ball!" )
		local ball = CastToInfoScript( entity )
		ball:Drop( BALL_RETURN_TIME )
	end
end

function base_ball:dropitemcmd( drop_entity )
	if IsPlayer( drop_entity ) then
		-- throw the ball
		local ball = CastToInfoScript( entity )

		local player = CastToPlayer( drop_entity )
		if not player:IsInUse() then
			ball:Drop(BALL_RETURN_TIME, BALL_THROW_SPEED)
			ConsoleToAll( player:GetName() .. " passed the ball!" )
		else
			-- ball:Drop(BALL_RETURN_TIME, BALL_THROW_SPEED * 2)
			-- speed actually seems to be capped or somehtin' on the C++ side, because watch this ball not go fast at * 100...
			ball:Drop(BALL_RETURN_TIME, BALL_THROW_SPEED * 100)
			ConsoleToAll( player:GetName() .. " passed the ball really far!" )
		end
	
		SmartSound( player, "misc.woop", "misc.woop", "misc.woop" )
	
		-- Make it so the player can't touch the ball for 1 second
		-- (so it can't be thrown and not stick to the player)
		self:addnotouch(player:GetId(), 1)
	end
end

function base_ball:spawn()
	self.notouch = { }
	info_ff_script.spawn(self)
end

function base_ball:addnotouch( player_id, duration )
	self.notouch[player_id] = duration
	AddSchedule(self.name .. "-" .. player_id, duration, self.removenotouch, self, player_id)
end

function base_ball.removenotouch(self, player_id)
	self.notouch[player_id] = nil
end

-- Custom position in relation to the player's GetAbsOrigin()
function base_ball:attachoffset()
	local offset = Vector( 16, 0, 32 )
	return offset
end

function base_ball:onreturn()
	ConsoleToAll( "The ball has returned!" )
	BroadCastSound ( "misc.deeoo" )
	BroadCastMessage( "#FF_WATERPOLO_BALL_RETURN" )
end

ball = base_ball:new({})



-- generic goal
base_goal = trigger_ff_script:new({
	health = 100,
	armor = 300,
	grenades = 200,
	bullets = 200,
	nails = 200,
	rockets = 200,
	cells = 200,
	detpacks = 1,
	radiotags = 10,
	gren1 = 4,
	gren2 = 4,
	item = "",
	team = 0
})

function player_spawn( player )
end
function player_killed( player )
end
function player_ondamage( player, damage_info )
end

function base_goal:allowed ( allowed_entity )
	if IsPlayer( allowed_entity ) then		
		-- player has to be carrying the item
		local player = CastToPlayer( allowed_entity )
		return player:HasItem( self.item )
	end

	return EVENT_DISALLOWED
end

function base_goal:ontrigger ( trigger_entity )
	if IsPlayer( trigger_entity ) then

		-- player should capture now
		local player = CastToPlayer( trigger_entity )
		local team = GetTeam( self.team )
		team:AddScore( POINTS_PER_CAPTURE )

		local ball = GetInfoScriptByName( self.item )
		ball:Return()

		if player:GetTeamId() == self.team then
			ConsoleToAll( player:GetName() .. " scored a goal!" )
			SmartSound( player, "misc.doop", "misc.doop", "misc.dadeda" )
			SmartMessage( player, "#FF_WATERPOLO_YOU_GOAL", "#FF_WATERPOLO_TEAM_GOAL", "#FF_WATERPOLO_ENEMY_GOAL" )
			player:AddFrags( POINTS_PER_CAPTURE )
		else
			ConsoleToAll( player:GetName() .. " scored an own goal!\nWait, what?!  Kill him like that Columbian a few years ago!  OWN GOAL!  OWN GOAL!" )
			SmartSound( player, "misc.dadeda", "misc.dadeda", "misc.doop" )
			SmartMessage( player, "#FF_WATERPOLO_YOU_OWN_GOAL", "#FF_WATERPOLO_TEAM_OWN_GOAL", "#FF_WATERPOLO_ENEMY_OWN_GOAL" )
			player:AddFrags( -POINTS_PER_CAPTURE )
		end	

		ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kForceDropItems, AT.kReturnDroppedItems })
	end
end

-- on blue's side of map, but points go to red
blue_goal = base_goal:new({ item = "ball", team = Team.kRed })

-- on red's side of map, but points go to blue
red_goal = base_goal:new({ item = "ball", team = Team.kBlue })



-- returns the item
base_item_returner = trigger_ff_script:new({
	item = "",
	message = ""
})

function base_item_returner:allowed ( allowed_entity )

	if IsPlayer( allowed_entity ) then
		-- player has to be carrying the item
		local player = CastToPlayer( allowed_entity )
		return player:HasItem( self.item )
	end

	return EVENT_ALLOWED

end

function base_item_returner:ontrigger ( trigger_entity )

	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		-- return the item
		local item = GetInfoScriptByName( self.item )
		item:Return()
		ConsoleToAll( player:GetName() .. self.message )
		SmartSound( player, "misc.deeoo", "misc.deeoo", "misc.deeoo" )
		SmartMessage( player, "#FF_WATERPOLO_YOU_BOUNDS", "#FF_WATERPOLO_TEAM_BOUNDS", "#FF_WATERPOLO_ENEMY_BOUNDS" )
	end

end

-- ball stripper
ball_stripper = base_item_returner:new({ item = "ball", message = " took the ball out of bounds!" })



-- goalie trigger_teleports
trigger_teleport = trigger_ff_script:new({})
base_goalie_teleport = trigger_teleport:new({ team = 0 })
function base_goalie_teleport:allowed( allowed_entity ) 
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		return player:GetTeamId() == self.team 
	end

	return EVENT_ALLOWED
end

-- blue goalie is on the yellow team
blue_goalie_teleport = base_goalie_teleport:new({ team = Team.kYellow })

-- red goalie is on the green team
red_goalie_teleport = base_goalie_teleport:new({ team = Team.kGreen })



-- spawn pack
waterpolo_pack_spawn = genericbackpack:new({
	health = 100,
	armor = 300,
	grenades = 200,
	bullets = 200,
	nails = 200,
	rockets = 200,
	cells = 200,
	detpacks = 0,
	radiotags = 10,
	gren1 = 0,
	gren2 = 0,
	respawntime = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

-- grenade pack
waterpolo_pack_grenades = genericbackpack:new({
	health = 100,
	armor = 300,
	grenades = 200,
	bullets = 200,
	nails = 200,
	rockets = 200,
	cells = 200,
	detpacks = 1,
	radiotags = 10,
	gren1 = 4,
	gren2 = 4,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	team = 0
})

function waterpolo_pack_grenades:dispenseallowed ( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		else
			-- This doesn't seem to work? 
			-- It does too? - Mulch
			BroadCastMessageToPlayer( player, "#FF_NOTALLOWEDPACK" )
			return EVENT_DISALLOWED
		end
	end
end

waterpolo_pack_grenades_blue = waterpolo_pack_grenades:new({ team = Team.kBlue })
waterpolo_pack_grenades_red = waterpolo_pack_grenades:new({ team = Team.kRed })

