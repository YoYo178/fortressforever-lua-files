-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------


IncludeScript("base");
IncludeScript("base_teamplay");
IncludeScript("base_location");

-- global overrides
TEAM1 = Team.kBlue
TEAM2 = Team.kRed
DISABLED_TEAM3 = Team.kYellow
DISABLED_TEAM4 = Team.kGreen

teams = { TEAM1, TEAM2 }
disabled_teams = { DISABLED_TEAM3, DISABLED_TEAM4 }
team_info = {
	[Team.kUnassigned] = {
		team_name = "neutral",
		enemy_team = Team.kUnassigned,
		class_limits = {
			[Player.kScout] = 0,
			[Player.kSniper] = 0,
			[Player.kSoldier] = 0,
			[Player.kDemoman] = 0,
			[Player.kMedic] = 0,
			[Player.kHwguy] = 0,
			[Player.kPyro] = 0,
			[Player.kSpy] = 0,
			[Player.kEngineer] = 0,
			[Player.kCivilian] = 0,
		},
	},
	[TEAM1] = {
		team_name = "blue",
		enemy_team = TEAM2,
		class_limits = {
			[Player.kScout] = 0,
			[Player.kSniper] = 0,
			[Player.kSoldier] = 0,
			[Player.kDemoman] = 0,
			[Player.kMedic] = 0,
			[Player.kHwguy] = 0,
			[Player.kPyro] = 0,
			[Player.kSpy] = 0,
			[Player.kEngineer] = 0,
			[Player.kCivilian] = 0,
		},
	},
	[TEAM2] = {
		team_name = "red",
		enemy_team = TEAM1,
		class_limits = {
			[Player.kScout] = 0,
			[Player.kSniper] = 0,
			[Player.kSoldier] = 0,
			[Player.kDemoman] = 0,
			[Player.kMedic] = 0,
			[Player.kHwguy] = 0,
			[Player.kPyro] = 0,
			[Player.kSpy] = 0,
			[Player.kEngineer] = 0,
			[Player.kCivilian] = 0,
		},
	},
}


-- objectives
objective_entities = { [TEAM1] = nil, [TEAM2] = nil }
goal_entities = { [TEAM1] = nil, [TEAM2] = nil }
ball_carrier = nil
BALL_ALWAYS_ENEMY_OBJECTIVE = true

-- scoring
POINTS_PER_GOAL = 10
POINTS_PER_INITIALTOUCH = 100
POINTS_PER_GOALIE_RETURN = 50
POINTS_PER_GOALIE_ATTACK = 10
BALL_RETURN_TIME = 15
BALL_THROW_SPEED = 2048
GOALIE_SPEED = 2.0
THE_WALL_TIMER_DISABLE = 12.5
THE_WALL_TIMER_WARN = 2.5


-- arena globals
RED_PRESENT = 0
BLUE_PRESENT = 0


blue_competitors = Collection()
red_competitors = Collection()

function getRedString()
  local myString = ""
  for i=0,(red_competitors:Count()-1) do
    local myPlayer = CastToPlayer(red_competitors:Element( i ))
    local myName = myPlayer:GetName()
    myString = myString .. myName .. " "
  end
return myString
end

function getBlueString()
  local myString = ""
  for i=0,(blue_competitors:Count()-1) do
    local myPlayer = CastToPlayer(blue_competitors:Element( i ))
    local myName = myPlayer:GetName()
    myString = myString .. myName .. " "
  end
return myString
end

-----------------------------------------------------------------------------
-- startup
-----------------------------------------------------------------------------
function startup()
	SetGameDescription( "Mulch" )
	-- disable certain teams
	for i,v in pairs(disabled_teams) do
		SetPlayerLimit( v, -1 )
	end
	-- set up team limits
	for i1,v1 in pairs(teams) do
		local team = GetTeam(v1)
		for i2,v2 in ipairs(team_info[team:GetTeamId()].class_limits) do
			team:SetClassLimit( i2, v2 )
		end
	end
	local ball = GetEntityByName( "ball" )
	for i,v in pairs(teams) do
		objective_entities[v] = ball
	end
end

function db(myinput)
  ConsoleToAll( "Debug: " .. myinput )
end

function remove_hud_items()
  RemoveHudItemFromAll( "blue_kings" )
  RemoveHudItemFromAll( "red_kings" )
  RemoveHudItemFromAll( "winner_tag" )
end

function reset_ball_carrier()
	if ball_carrier ~= nil and IsPlayer( ball_carrier ) then
		local player = CastToPlayer(ball_carrier)
		UpdateObjectiveIcon( player, objective_entities[player:GetTeamId()] )
		if not BALL_ALWAYS_ENEMY_OBJECTIVE then
			local enemy_team = team_info[player:GetTeamId()].enemy_team
			objective_entities[enemy_team] = GetEntityByName( "ball" )
			UpdateTeamObjectiveIcon( GetTeam(enemy_team), objective_entities[enemy_team] )
		end
	end
	ball_carrier = nil
end

-----------------------------------------------------------------------------
-- ball information
-- status: 0 = home, 1 = carried, 2 = dropped
-----------------------------------------------------------------------------
base_ball = info_ff_script:new({
	name = "base ball",
	team = Team.kUnassigned,
	model = "models/props/crown2/crown2.mdl",
	modelskin = 0,
	tosssound = "Flag.toss",
	dropnotouchtime = 0,
	capnotouchtime = 2,
	hudicon = "hud_crown",
	hudx = 5,
	hudy = 210,
	hudwidth = 48,
	hudheight = 48,
	hudalign = 1, 
	hudstatusiconbluex = 60,
	hudstatusiconbluey = 5,
	hudstatusiconredx = 60,
	hudstatusiconredy = 5,
	hudstatusiconblue = "hud_crown.vtf",
	hudstatusiconred = "hud_crown.vtf",
	hudstatusiconw = 15,
	hudstatusiconh = 15,
	hudstatusiconbluealign = 2,
	hudstatusiconredalign = 3,
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed},
	botgoaltype = Bot.kFlag,
	status = 0
})

function base_ball:hasanimation() return false end
function base_ball:usephysics() return true end
function base_ball:touch( touch_entity ) end
function base_ball:onownerdie( owner_entity )
	if IsPlayer( owner_entity ) then
		local player = CastToPlayer( owner_entity )
		-- drop the ball
		remove_hud_items()
		--ConsoleToAll( player:GetName() .. " died and dropped the ball!" )
		local ball = CastToInfoScript( entity )
		--ball:Drop(BALL_RETURN_TIME, 0.0)
		ball:Return()
		--remove_hud_items(ball, player)
		self.status = 2

		reset_ball_carrier()
	end
end
function base_ball:dropitemcmd( drop_entity ) end
function base_ball:ondrop( owner_entity )
	if IsPlayer( owner_entity ) then
		local player = CastToPlayer( owner_entity )
		-- let the teams know that the flag was dropped
		remove_hud_items()
		--SmartSound(player, "yourteam.drop", "yourteam.drop", "otherteam.drop")
		--SmartMessage(player, "#FF_YOUBALLDROP", "#FF_TEAMBALLDROP", "#FF_ENEMYBALLDROP", Color.kYellow, Color.kYellow, Color.kYellow)
	end
	
	local ball = CastToInfoScript(entity)
	--ball:EmitSound(self.tosssound)
end

function base_ball:onloseitem( owner_entity )
	if IsPlayer( owner_entity ) then
		-- let the player that lost the ball put on a disguise
		remove_hud_items()
		--self:addnotouch(player:GetId(), self.capnotouchtime)
	end
end

function base_ball:spawn()
	self.notouch = { }
	info_ff_script.spawn(self)
	self.status = 0
end


-- For when this object is carried, these offsets are used to place
-- the info_ff_script relative to the players feet
function base_ball:attachoffset()
	-- x = forward/backward
	-- y = left/right
	-- z = up/down
	local offset = Vector( 3, 0, 78 )
	return offset
end

function base_ball:precache()
	PrecacheSound(self.tosssound)
	info_ff_script.precache(self)
end

function base_ball:onreturn()
	remove_hud_items()
	--ConsoleToAll( "The ball has returned!" )
	--SpeakAll ( "CTF_BALLRETURN" )
	--BroadCastMessage( "#FF_WATERPOLO_BALL_RETURN", Color.kYellow )
	self.status = 0
	reset_ball_carrier()
end

ball = base_ball:new({
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed},
	botgoaltype = Bot.kFlag
})



-----------------------------------------------------------------------------
-- arenaclips
-----------------------------------------------------------------------------

clip_brush = trigger_ff_clip:new({ clipflags = 0 })

arena_clipall = clip_brush:new({ clipflags = {ClipFlags.kClipPlayersByTeam, ClipFlags.kClipTeamBlue, ClipFlags.kClipTeamRed, ClipFlags.kClipAllBullets, ClipFlags.kClipAllProjectiles, ClipFlags.kClipAllGrenades, ClipFlags.kClipAllNonPlayers} })


-----------------------------------------------------------------------------------------------------------------------------
-- door triggers
-----------------------------------------------------------------------------------------------------------------------------

red_door_trigger= trigger_ff_script:new({ team = Team.kRed })
function red_door_trigger:allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function red_door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
    OutputEvent("red_iris_door_blade", "Open")
   end
end

blue_door_trigger= trigger_ff_script:new({ team = Team.kBlue })
function blue_door_trigger:allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function blue_door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
    OutputEvent("blue_iris_door_blade", "Open")
   end
end

-----------------------------------------------------------------------------------------------------------------------------
-- arena triggers
-----------------------------------------------------------------------------------------------------------------------------

trigger_arena_redplayer = trigger_ff_script:new({ team = Team.kRed })
function trigger_arena_redplayer:allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function trigger_arena_redplayer:ontrigger( touch_entity )
  if IsPlayer( touch_entity ) then
	RED_PRESENT = 1
	if not red_competitors:HasItem( touch_entity ) then
	  red_competitors:AddItem( touch_entity )
    end
	OutputEvent("red_door_indicator", "Open")
	local text_align = 3
	local text_x = 10
	local text_line1y = 35
	AddHudTextToAll( "red_comp_text", getRedString(), text_x, text_line1y, text_align )
	AddHudTextToAll( "vs_text","vs", -1, text_line1y, 2 )
	--local myBall = GetInfoScriptByName("ball")
	--myBall:Pickup(touch_entity)
  end
end
function trigger_arena_redplayer:onendtouch( touch_entity )
  if IsPlayer( touch_entity ) then
    --RED_PRESENT = 0
	red_competitors:RemoveItem( touch_entity )
    OutputEvent("red_door_indicator", "Close")   
  end
end




trigger_arena_blueplayer = trigger_ff_script:new({ team = Team.kBlue })
function trigger_arena_blueplayer:allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function trigger_arena_blueplayer:ontrigger( touch_entity )
  if IsPlayer( touch_entity ) then
    BLUE_PRESENT = 1
	if not blue_competitors:HasItem( touch_entity ) then
	  blue_competitors:AddItem( touch_entity )
    end
	OutputEvent("blue_door_indicator", "Open")   
	local text_align = 2
	local text_x = 10
	local text_line1y = 35
	AddHudTextToAll( "blue_comp_text", getBlueString(), text_x, text_line1y, text_align )
	AddHudTextToAll( "vs_text","vs", -1, text_line1y, text_align )

  end
end
function trigger_arena_blueplayer:onendtouch( touch_entity )
  if IsPlayer( touch_entity ) then
    --BLUE_PRESENT = 0
	blue_competitors:RemoveItem( touch_entity )
	OutputEvent("blue_door_indicator", "Close")   
  end
end



-----------------------------------------------------------------------------
-- bagless resupply
-----------------------------------------------------------------------------
aardvarkresup = trigger_ff_script:new({ team = Team.kUnassigned })

function aardvarkresup:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			player:AddHealth( 400 )
			player:AddArmor( 400 )
			player:AddAmmo( Ammo.kNails, 400 )
			player:AddAmmo( Ammo.kShells, 400 )
			player:AddAmmo( Ammo.kRockets, 400 )
			player:AddAmmo( Ammo.kCells, 400 )
			player:AddAmmo( Ammo.kDetpack, 1)
			player:AddAmmo( Ammo.kGren1 , 4)
			player:AddAmmo( Ammo.kGren2 , 4) 
		end
	end
end

blue_aardvarkresup = aardvarkresup:new({ team = Team.kBlue })
red_aardvarkresup = aardvarkresup:new({ team = Team.kRed })


-----------------------------------------------------------------------------
-- arena indicators
-----------------------------------------------------------------------------
red_door_indicator = trigger_ff_script:new({})
blue_door_indicator = trigger_ff_script:new({})

function red_door_indicator:onclose()
  RED_PRESENT = 0
  RemoveHudItemFromAll( "red_comp_text" )
  red_competitors:RemoveAllItems()
  if BLUE_PRESENT == 0 then
    RemoveHudItemFromAll("vs_text")
  end
end

function blue_door_indicator:onclose()
  BLUE_PRESENT = 0
  RemoveHudItemFromAll( "blue_comp_text" )
  blue_competitors:RemoveAllItems()
    if RED_PRESENT == 0 then
    RemoveHudItemFromAll("vs_text")
  end
end


-----------------------------------------------------------------------------
-- arena points
-----------------------------------------------------------------------------
--function player_killed( player_id )
	-- If you kill someone, give your team a point
--	local killer = GetPlayer(killer)
--	local victim = GetPlayer(player_id)
	
--
--	if not (victim:GetTeamId() == killer:GetTeamId()) then
--		local killersTeam = killer:GetTeam()
--		killersTeam:AddScore(1)
        
		
--local myBall = GetInfoScriptByName("ball")
--				myBall:Return()
--				myBall:Pickup(killer)
--
--	end
--end


function player_killed( player_entity, damageinfo )
	-- suicides have no damageinfo
	if damageinfo ~= nil then
		local killer = damageinfo:GetAttacker()
		local player = CastToPlayer( player_entity )
		if IsPlayer(killer) then
			killer = CastToPlayer(killer)
			--local victim = GetPlayer(player_id)
			
			if not (player:GetTeamId() == killer:GetTeamId()) then
				local killersTeam = killer:GetTeam()	
				killersTeam:AddScore(1)
				local myBall = GetInfoScriptByName("ball")
				myBall:Return()
				--local myAngles = GetInfoScriptByName("ball"):GetAngles()
				--myBall:SetStartAngles(myAngles)
				--myBall:SetAngles(myAngles)
				myBall:Pickup(killer)
				GetInfoScriptByName("ball"):SetAngles(QAngle(0,0,90))
				--local myAngles = myBall:GetAngles()
				--local self = myBall
				BroadCastMessage(killer:GetName() .. " killed " .. player:GetName() .. " with [" .. killer:GetHealth() .. "h|" .. killer:GetArmor() .. "a].", 5)
				remove_hud_items()
			 AddHudIcon( killer, "hud_crown", "winner_tag", 5, 210, 48, 48, 1 )
			local team = killer:GetTeamId()
			if (team == TEAM1) then
				AddHudIconToAll( "hud_crown", "blue_kings", 60, 5, 15, 15, 2 )
			elseif (team == TEAM2) then
				AddHudIconToAll( "hud_crown", "red_kings", 60, 5, 15, 15, 3 )
			end
				--db(myAngles)

			end
		end	
	end
end

-----------------------------------------------------------------------------
-- team-only teleports
-----------------------------------------------------------------------------
teamteleport = trigger_ff_script:new({ team = Team.kUnassigned })

function teamteleport:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

teleblue = teamteleport:new({ team = Team.kBlue })
telered = teamteleport:new({ team = Team.kRed })