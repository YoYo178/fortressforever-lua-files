-----------------------------------------------------------------------------
-- base_slaughterball.lua
-- variant of murderball where the ball returns to a random spot every time
-----------------------------------------------------------------------------
--== File last modified:
-- 11 / 01 / 2024 ( dd / mm / yyyy ) by gumbuk
--== Contributors:
-- gumbuk 9
--== Mode is hosted & developed at:
-- https://github.com/Fortress-Forever-Mapper-Union/ffmu-modes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay")

-----------------------------------------------------------------------------
-- Globals
-----------------------------------------------------------------------------

BALL_RETURN_TIME = 5 -- the time it takes the ball to return after dropped
SCORE_TIME = 10 -- the interval in seconds to hand out score while ball is held
ADD_POINTS = 5 -- how many team points to hand out
POINT_MULTIPLIER = 10 -- how many fortpoints (player score) to hand out
HUD_BALLNAME = "base_ball" -- hacky way to always have the ball for flaginfo

----------------------------------------------------------------------
-- Entities
----------------------------------------------------------------------
----====----====----====----====----
-- Pickups
----====----====----====----====----
genericbackpack = info_ff_script:new({
	health = 0,
	armor = 0,
	shells = 0,
	nails = 0,
	rockets = 0,
	cells = 0,
	detpacks = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 5,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	touchsound = "HealthKit.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers, AllowFlags.kRed, AllowFlags.kBlue, AllowFlags.kYellow, AllowFlags.kGreen},
	noball = false
})

function genericbackpack:precache()
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)
	PrecacheModel(self.model)
end

function genericbackpack:touch(touch_entity)
	if IsPlayer(touch_entity) then -- check if touched by player
		local player = CastToPlayer(touch_entity) -- cast to player entity
		local dispensed = 0

		if self.noball and HasBall(player) then return; end -- if noball and player having the ball are both true do nothing

		if self.health ~= nil then -- if health is not zero
			dispensed = dispensed + player:AddHealth(self.health) -- add health
		end
		if self.armor ~= nil then -- if armor is not zero
			dispensed = dispensed + player:AddArmor(self.armor) -- add armor
		end
		if self.nails ~= nil then -- if nails are not zero
			dispensed = dispensed + player:AddAmmo(Ammo.kNails, self.nails) -- add nails
		end
		if self.shells ~= nil then -- if shells are not zero
			dispensed = dispensed + player:AddAmmo(Ammo.kShells, self.shells) -- add shells
		end
		if self.rockets ~= nil then -- if rockets are not zero
			dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets) -- add rockets
		end
		if self.cells ~= nil then -- if cells are not zero
			dispensed = dispensed + player:AddAmmo(Ammo.kCells, self.cells) -- add cells
		end
		if self.detpacks ~= nil then -- if detpacks are not zero
			dispensed = dispensed + player:AddAmmo(Ammo.kDetpack, self.detpacks) -- add a detpack
		end
		if self.gren1 ~= nil then -- if frags are not zero
			dispensed = dispensed + player:AddAmmo(Ammo.kGren1, self.gren1) -- add frag grenades
		end
		if self.gren2 ~= nil then -- if secondary nades are not zero
			dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren2) -- add secondaries
		end

		if dispensed >= 1 then
			local backpack = CastToInfoScript(entity);
			if (backpack ~= nil) then
				backpack:EmitSound(self.touchsound);
				backpack:Respawn(self.respawntime);
			end
		end
	end
end

function genericbackpack:materialize() entity:EmitSound(self.materializesound) end
function genericbackpack:dropatspawn() return false end

everyonepack = genericbackpack:new({
	health = 60,
	armor = 60,
	gren1 = 1,
	noball = false
})

noballpack = genericbackpack:new({
	health = 25,
	armor = 25,
	noball = true
})
-- inherit from these in map.lua, base_mode.lua should have the bare minimum

----====----====----====----====----
-- Ball Functionality
----====----====----====----====----

base_ball = info_ff_script:new({
	name = "base_ball",
	team = Team.kUnassigned,
	model = "models/items/ball/ball.mdl",
	modelskin = 0,
	tosssound = "Flag.Toss",
	status = 0,
	h_ax = 2,
	h_ay = 0,
	h_dx = 110,
	h_dy = 15,
	ico_w = 64,
	ico_h = 32,
	lastreturn = "", -- set this to default spawn in map.lua
	lastarea = "", -- this too
	carriedby = "",
	botgoaltype = Bot.kFlag,
	touchflags = {AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function base_ball:hasanimation() return true end

function base_ball:attachoffset() return Vector(32, 0, 0) end

function base_ball:precache()
	PrecacheSound(self.tosssound)
	PrecacheSound("yourteam.flagstolen")
	PrecacheSound("otherteam.flagstolen")
	PrecacheSound("yourteam.drop")
	PrecacheSound("otherteam.drop")
	PrecacheSound("yourteam.flagreturn")
	PrecacheSound("otherteam.flagreturn")
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("otherteam.flagcap")
	info_ff_script.precache(self)
end

function base_ball:spawn()
	self.notouch = {}
	info_ff_script.spawn(self)
	self.status = 0
end

function base_ball:addnotouch(player_id, duration)
	self.notouch[player_id] = duration
	AddSchedule(self.name.."-"..player_id, duration, self.removenotouch, self, player_id)
end

function base_ball.removenotouch(self, player_id)
	self.notouch[player_id] = nil
end

function base_ball:touch(touch_entity)
	if IsPlayer(touch_entity) then -- check if touched by player
		local player = CastToPlayer(touch_entity) -- cast to player entity
		if self.notouch[player:GetId()] then return; end -- check if player is allowed to touch ball

		if player:GetTeamId() ~= self.team then -- if player is not the same team as the ball
			SmartSound(player, "yourteam.flagstolen", "yourteam.flagstolen", "otherteam.flagstolen")
			SmartSpeak(player, "CTF_YOUHAVEBALL", "CTF_TEAMHASBALL", "CTF_ENEMYHASBALL")
			SmartMessage(player, "You have the ball! Don't get slaughtered!", "#FF_TEAMHASBALL", "#FF_ENEMYHASBALL")

			player:SetDisguisable(false)
			player:SetCloakable(false)

			local ball = CastToInfoScript(entity)
			ball:Pickup(player)
			self.carriedby = player:GetName()
			self.status = 1
			self:UpdateHudForAll()

			AddScheduleRepeating("scoretimer", SCORE_TIME, AddPoints, player) -- add points on loop
		end
	end
end

function base_ball:onownerdie(owner_entity)
	local ball = CastToInfoScript(entity)
	self.status = 2
	ball:Drop(BALL_RETURN_TIME, 0.0)
	if IsPlayer(owner_entity) then
		local player = CastToPlayer(owner_entity)
	end
end

function base_ball:ownerfeign(owner_entity)
	local ball = CastToInfoScript(entity)
	self.status = 2
	ball:Drop(BALL_RETURN_TIME, 0.0)
	if IsPlayer(owner_entity) then
		local player = CastToPlayer(owner_entity)
	end
end

function base_ball:dropitemcmd(owner_entity) return false end

function base_ball:ondrop(owner_entity)
	if IsPlayer(owner_entity) then
		local player = CastToPlayer(owner_entity)
		SmartSound(player, "yourteam.drop", "yourteam.drop", "otherteam.drop")
		SmartMessage(player, "#FF_YOUBALLDROP", "#FF_TEAMBALLDROP", "#FF_ENEMYBALLDROP")
		RemoveSchedule("scoretimer")
	end

	local ball = CastToInfoScript(entity)
	ball:EmitSound(self.tosssound)
	self:UpdateHudForAll()
end

function base_ball:onloseitem(owner_entity)
	if IsPlayer(owner_entity) then
		local player = CastToPlayer(owner_entity)
		player:SetDisguisable(true)
		player:SetCloakable(true)
		self:addnotouch(player:GetId(), 2)
		self:UpdateHudForAll()
	end
end

function base_ball:onreturn()
	BroadCastMessage("#FF_BALLRETURN")
	BroadCastSound ("yourteam.flagreturn")
	SpeakAll("CTF_BALLRETURN")
	self:randomreturn()
end

function base_ball:randomreturn()
	local ball = CastToInfoScript(entity)
	local randint = RandomInt( 1, #poslist )
	local rposent = poslist[randint].entity
	local rposentdata = poslist[randint].entity_data
	local randorigin = rposent:GetOrigin()

	ball:SetStartOrigin( Vector( randorigin.x, randorigin.y, randorigin.z ) )
	self.lastreturn = rposentdata
	self.lastarea = _G[rposentdata.area_ref]
	self.status = 0
	self:UpdateHudForAll()
end

function base_ball:UpdateHudForAll()
	local ball = _G[HUD_BALLNAME]
	local baller = GetPlayerByName(ball.carriedby)
	
	local returnpos = ball.lastreturn
	local area = ball.lastarea
	
	local ballis = "GUMBUKPLSFIX" -- status, what's happening
	local ballico = "GUMBUKPLSFIX" -- location or area icon
	local balltxt = "GUMBUKPLSFIX" -- extra information
	local teamico = "GUMBUKPLSFIX" -- baller team icon
	
	if ball.status == 0 then
		ballis = "The Ball is Stopped at"
		ballico = returnpos.ico_dir
		balltxt = returnpos.loc_str
	elseif ball.status == 1 then
		ballis = "The Ball is being Held"
		ballico = area.ico_dir
		balltxt = baller:GetName()
		teamico = baller:GetTeamId()
	elseif ball.status == 2 then
		ballis = "The Ball is Dropped"
		ballico = area.ico_dir
		balltxt = ""
	end
	
	AddHudTextToAll( "ballis", ballis, ball.h_dx, ( ball.h_dy - ball.ico_h * .3), ball.h_ax, ball.h_ay )
	AddHudIconToAll(  ballico, "ballico", ball.h_dx, ball.h_dy, ball.ico_w, ball.ico_h, ball.h_ax, ball.h_ay )
	AddHudTextToAll( "balltxt", balltxt, ball.h_dx, ( ball.h_dy + ball.ico_h ), ball.h_ax, ball.h_ay )
	if teamico ~= "GUMBUKPLSFIX" then
	AddHudIconToAll(  "slaughterball/icon_team_"..teamico, "teamico", ball.h_dx + ball.ico_w, ball.h_dy, ball.ico_h, ball.ico_h, ball.h_ax, ball.h_ay ) end
end

----====----====----====----====----
-- Areas
----====----====----====----====----

base_area = trigger_ff_script:new({ text = "Unknown", team = Team.kUnassigned, ico_dir = "slaughterball/location_default" })

function base_area:ontouch( touch_entity )

	-- set the location of the player
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		player:SetLocation(entity:GetId(), self.text, self.team)
	end
	if HasBall(touch_entity) then
		_G[HUD_BALLNAME].lastarea = self
		_G[HUD_BALLNAME]:UpdateHudForAll()
	end
end

----==== return positions
base_returnpos = info_ff_script:new({
	ico_dir = "slaughterball/location_default.vtf", -- location icon to display
	loc_str = "MAPPERPLSFIX", -- location name to display
	area_ref = "base_area" -- reference to a location trigger to set the icon on pickup
})
poslist = {  }

function base_returnpos:spawn()
  local position = CastToInfoScript(entity)
  poslist[ (#poslist + 1) ] = { entity = position, entity_data = self }
end

----====----====----====----====----
-- Misc
----====----====----====----====----
----==== Ball Triggers
-- mainly used to stop people from entering their spawn with the ball

hasball_trigger = trigger_ff_script:new({})

function hasball_trigger:allowed(allowed_entity)
	if IsPlayer(allowed_entity) then
		local player = CastToPlayer(allowed_entity)
		if HasBall(player) then
			return true
		end
	end
	return false
end

blue_base = hasball_trigger:new({})
red_base = hasball_trigger:new({})
yellow_base = hasball_trigger:new({})
green_base = hasball_trigger:new({})
spawn_antiball = hasball_trigger:new({})

-----------------------------------------------------------------------------
-- Functions
-----------------------------------------------------------------------------

function startup()

	SetPlayerLimit(Team.kBlue, 8)
	SetPlayerLimit(Team.kRed, 8)
	SetPlayerLimit(Team.kYellow, 8)
	SetPlayerLimit(Team.kGreen, 8)

	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kYellow)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kGreen)
	team:SetClassLimit(Player.kCivilian, -1)

end

function flaginfo( input_player )
	local player = CastToPlayer( input_player )
	
	local ball = _G[HUD_BALLNAME]
	local baller = GetPlayerByName(ball.carriedby)
	
	local returnpos = ball.lastreturn
	local area = ball.lastarea
	
	local ballis = "GUMBUKPLSFIX" -- status, what's happening
	local ballico = "GUMBUKPLSFIX" -- location or area icon
	local balltxt = "GUMBUKPLSFIX" -- extra information
	local teamico = "GUMBUKPLSFIX" -- baller team icon
	
	if ball.status == 0 then
		ballis = "The Ball is Stopped at"
		ballico = returnpos.ico_dir
		balltxt = returnpos.loc_str
	elseif ball.status == 1 then
		ballis = "The Ball is being Held"
		ballico = area.ico_dir
		balltxt = baller:GetName()
		teamico = baller:GetTeamId()
	elseif ball.status == 2 then
		ballis = "The Ball is Dropped"
		ballico = area.ico_dir
		balltxt = ""
	end
	
	AddHudText( player, "ballis", ballis, ball.h_dx, ( ball.h_dy - ball.ico_h * .3), ball.h_ax, ball.h_ay )
	AddHudIcon( player,  ballico, "ballico", ball.h_dx, ball.h_dy, ball.ico_w, ball.ico_h, ball.h_ax, ball.h_ay )
	AddHudText( player, "balltxt", balltxt, ball.h_dx, ( ball.h_dy + ball.ico_h ), ball.h_ax, ball.h_ay )
	if teamico ~= "GUMBUKPLSFIX" then
	AddHudIconToAll(  "slaughterball/icon_team_"..teamico, "teamico", ball.h_dx + ball.ico_w, ball.h_dy, ball.ico_h, ball.ico_h, ball.h_ax, ball.h_ay ) end
end

function HasBall(player_entity) -- helper function to see if someone's holding a ball
	if IsPlayer(player_entity) then -- if it's a player
		local player = CastToPlayer(player_entity) -- cast to player entity
		local ball = GetInfoScriptByName(HUD_BALLNAME) -- define the ball locally
		if ball then -- if ball exists
			if player:HasItem(ball:GetName()) then -- see if player has ball
				return true -- yeah, he does.
			end
		end
	end
	return false
end

function AddPoints(player_entity) -- helper function to add teamscore and fortpoints fast
	if IsPlayer(player_entity) then
		local player = CastToPlayer(player_entity)
		local team = player:GetTeam()
		team:AddScore(ADD_POINTS)
		player:AddFortPoints(ADD_POINTS*POINT_MULTIPLIER, "Holding the ball.")
	end
end