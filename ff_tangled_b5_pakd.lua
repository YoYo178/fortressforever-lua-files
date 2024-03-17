-----------------------------------------------------------------------------
-- ff_tangled_a.lua
--Additional lighting final compile options:      -final -both -StaticPropPolys -StaticPropLighting 
-----------------------------------------------------------------------------

IncludeScript("base_ctf")
IncludeScript("base_location")
IncludeScript("base_teamplay")
IncludeScript("base_respawnturret")

--------------------KUDOS SECTION-------------------------------------
-- I borrowed and modified all kinds of lua for this map
--murderball, aardvark, hold, dm_squeek all kinds of things off the forum
--thanks for any help and or material  borrowed.
----------------------------------------------------------------------
--ball stuff
BALL_RETURN_TIME = 15
BALL_THROW_SPEED = 700
--schecule stuff when holding ball i.e. -points, score, hp etc.
SCORE_TIME = 15
HEALTH_TIME = 15
HEALTH_POINTS = 10
ARMOR_POINTS = 20
ADD_JUGGERNAUT_POINTS = 5
ADD_JUGGERNAUT_TEAM_POINTS = 10
PLAYER_POINTS_PER_BALL_CARRIER_KILLED = 100
TEAM_POINTS_PER_BALL_CARRIER_KILLED = 15
--code for juggernaut recognition
DAMAGE_STATUS = 0

current_ball_location = "yard"

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
	SetTeamName(Team.kBlue, "  Blooze")
	SetTeamName(Team.kRed,  "  Redz")
	SetTeamName(Team.kYellow,  "Yellerz")
	SetTeamName(Team.kGreen,  " Greenzies")
	
-----------------------------------------------------------------------------
-- Class Settings FOUR TEAMS, SET CLASS LIMITS
-----------------------------------------------------------------------------

local team = GetTeam(Team.kBlue)

	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kMedic, 0)
	team:SetClassLimit(Player.kDemoman, 0)
	team:SetClassLimit(Player.kSoldier, 0)
	team:SetClassLimit(Player.kHwguy, 0)
	team:SetClassLimit(Player.kSpy, 0)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kEngineer, 2)
	team:SetClassLimit(Player.kCivilian, -1)
    
local team = GetTeam(Team.kRed)

	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kMedic, 0)
	team:SetClassLimit(Player.kDemoman, 0)
	team:SetClassLimit(Player.kSoldier, 0)
	team:SetClassLimit(Player.kHwguy, 0)
	team:SetClassLimit(Player.kSpy, 0)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kEngineer, 2)
	team:SetClassLimit(Player.kCivilian, -1)
	
local team = GetTeam(Team.kYellow)

	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kMedic, 0)
	team:SetClassLimit(Player.kDemoman, 0)
	team:SetClassLimit(Player.kSoldier, 0)
	team:SetClassLimit(Player.kHwguy, 0)
	team:SetClassLimit(Player.kSpy, 0)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kEngineer, 2)
	team:SetClassLimit(Player.kCivilian, -1)
	
local team = GetTeam(Team.kGreen)

	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kMedic, 0)
	team:SetClassLimit(Player.kDemoman, 0)
	team:SetClassLimit(Player.kSoldier, 0)
	team:SetClassLimit(Player.kHwguy, 0)
	team:SetClassLimit(Player.kSpy, 0)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kEngineer, 2)
	team:SetClassLimit(Player.kCivilian, -1)
	
--local ball = GetEntityByName( "ball" )	
	
end




-----------------------------------------------------------------------------
--  To initially spawn full
-----------------------------------------------------------------------------
function player_spawn( player_entity )
    local player = CastToPlayer( player_entity )
--	player:RemoveAmmo( Ammo.kDetpack, 1) 
    player:RemoveAmmo( Ammo.kGren1, 4 )
    player:RemoveAmmo( Ammo.kGren2, 4 )

    player:AddAmmo( Ammo.kGren1, 2 )
    player:AddAmmo( Ammo.kGren2, 1 )
	
	
	player:SetGravity( 1 )

	--set the player's objective to the ball and clean up the hud
	local player = CastToPlayer( player_entity )
	UpdateObjectiveIcon( player, GetEntityByName( "murder_ball" ) )
	RemoveHudItem( player, "red-sec-up" )
	RemoveHudItem( player, "blue-sec-up" )
	
	
	--take status effects away when the juggernaut dies (could prob do this in the murderball section below but it worked here )
	player:RemoveEffect( EF.kConc ) 
	player:RemoveEffect( EF.kOnfire ) 
	player:RemoveEffect( EF.kTranq ) 
		
	--reset juggernaut status
	DAMAGE_STATUS = 0
	
end

------------------------------------------
-- base_trigger_jumppad
-- A trigger that emulates a jump pad
------------------------------------------

base_trigger_jumppad = trigger_ff_script:new({
	teamonly = false, 
	team = Team.kUnassigned, 
	needtojump = true, 
	push_horizontal = 150,
	push_vertical = 600,
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
-- standard definitions and map specific jumppad triggers
-----------------------------------------------------------------------------

jumppad = base_trigger_jumppad:new({})
jumppad_nojump = base_trigger_jumppad:new({ needtojump = false })

ele_jumppad = base_trigger_jumppad:new({
	needtojump = true, 
	push_horizontal = 0,
	push_vertical = 1900,
})

ceiling_jumppad = base_trigger_jumppad:new({
	needtojump = false, 
	push_horizontal = 450,
	push_vertical = 0,
})

lower_ramps_jumppad1 = base_trigger_jumppad:new({
	needtojump = true, 
	push_horizontal = 900,
	push_vertical = 170,
})

lower_ramps_jumppad2 = base_trigger_jumppad:new({
	needtojump = true, 
	push_horizontal = 900,
	push_vertical = 170,
})

second_floor_jumppad_ry = base_trigger_jumppad:new({
	needtojump = false, 
	push_horizontal = 350,
	push_vertical = 750,
})

second_floor_jumppad_br = base_trigger_jumppad:new({
	needtojump = false, 
	push_horizontal = 350,
	push_vertical = 750,
})
second_floor_jumppad_bg = base_trigger_jumppad:new({
	needtojump = false, 
	push_horizontal = 350,
	push_vertical = 750,
})
second_floor_jumppad_gy = base_trigger_jumppad:new({
	needtojump = false, 
	push_horizontal = 350,
	push_vertical = 750,
})



-----------------------------------------------------------
-- Packs
-----------------------------------------------------------

regular_pack = genericbackpack:new({
	health = 25,
	armor = 35,
	grenades = 20,
	nails = 50,
	shells = 300,
	rockets = 15,
	cells = 120,
	gren1 = 1,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function regular_pack:dropatspawn() return true 
end


spawn_pack = genericbackpack:new({
	health = 50,
	armor = 100,
	grenades = 50,
	nails = 80,
	shells = 300,
	rockets = 20,
	cells = 200,
	gren1 = 1,
	gren2 = 1,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function spawn_pack:dropatspawn() return true 
end



gren_pack = genericbackpack:new({
	health = 150,
	armor = 100,
	grenades = 50,
	nails = 80,
	shells = 300,
	rockets = 20,
	cells = 200,
	mancannons = 1,
	detpacks = 1,
	gren1 = 3,
	gren2 = 3,
	respawntime = 25,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function gren_pack:dropatspawn() return true 
end

-----------------------------------------------------------------------------
-- Reflecting pool resupply trigger (modified from aardvark)
-----------------------------------------------------------------------------
reflecting_pool_trigger = trigger_ff_script:new({ team = Team.kUnassigned })

function reflecting_pool_trigger:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
			AddScheduleRepeating("reflectpooltimer", 0.1, ReflectPool, player)
	end
end

function reflecting_pool_trigger:onendtouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
			RemoveSchedule("reflectpooltimer")
	end
end


-----------------------------------------------------------------------------------------------
-- DAMAGE EVENTS - NO FALL DAMAGE, 1/2 - SELF DAMAGE, DOUBLE DAMAGE FOR JUGGERNAUT
-----------------------------------------------------------------------------------------------	


function player_ondamage( player, damageinfo )
	-- Entity that is attacking
	local attacker = damageinfo:GetAttacker()
	-- if no damageinfo do nothing
	if not damageinfo then return end
	-- If no attacker then do nothing
	if not attacker then return	end
	-- If attacker is not a player and damage is fall damage take no damage
	if not IsPlayer(attacker) and damageinfo:GetDamageType() == Damage.kFall then 
		damageinfo:ScaleDamage(0)
	end
		-- Halve self damage more fun to pipe/rocket/nade jump	
	if IsPlayer(attacker) then
		local playerAttacker = CastToPlayer(attacker)
		if player:GetId() == playerAttacker:GetId()  then
			damageinfo:ScaleDamage( 0.5 )
		end
		--Give the juggernaut double damage
		--If the juggernaut throws the ball he still gets double damage :(
		if DAMAGE_STATUS == 2 then
			damageinfo:ScaleDamage( 2)
		end
	end
end



----------------------------------------------------------------------
----------------------------------------------------------------------
--	borrowed and modified from murderball, thank you!
---------I added some ondrop and dropitem stuff---------------
----------------------------------------------------------------------
----------------------------------------------------------------------
-- On Ball Holder Killed
----------------------------------------------------------------------

function player_killed( killed_player, damageinfo )

	if IsPlayer(killed_player) then
		local player = CastToPlayer(killed_player)
		if HasBall(player) then
			  -- Entity that is attacking
			  local attacker = damageinfo:GetAttacker()

			  -- If no attacker do nothing
			  if not attacker then
				return
			  end

			  -- If attacker not a player do nothing
			  if not IsPlayer(attacker) then
				return
			  end
			  
			  local player_attacker = CastToPlayer(attacker)
			  
			  -- If player is damaging self or damaged by own team do nothing
			  if (player:GetId() == playerAttacker:GetId()) or (player:GetTeamId() == playerAttacker:GetTeamId()) then
				return 
			  end
			  
			local team = player_attacker:GetTeam()
			
			-- Add points
			team:AddScore( TEAM_POINTS_PER_BALL_CARRIER_KILLED )
			player_attacker:AddFortPoints( PLAYER_POINTS_PER_BALL_CARRIER_KILLED, "Killed The Juggernaut!!!" )
		end
	end
	
end


----------------------------------------------------------------------
-- Ball Setup
----------------------------------------------------------------------

murder_ball = info_ff_script:new({
	name = "murder ball",
	team = Team.kUnassigned,
	model = "models/items/ball/ball.mdl",
	modelskin = 0,
	tosssound = "Flag.Toss",
	capnotouchtime = 1,
	dropnotouchtime = 1,
	returnnotouchtime = 3,
	notouchall = nil,
	status = 0,
	hudicon = "hud_ball",
	hudx = 5,
	hudy = 210,
	hudw = 48,
	hudh = 48,
	huda = 1,
	hudstatusiconxrb = 60,
	hudstatusiconyrb = 5,
	hudstatusiconxyg = 53,
	hudstatusiconyyg = 25,
	hudstatusicon = "hud_ball.vtf",
	hudstatusiconw = 15,
	hudstatusiconh = 15,
	hudstatusiconalignby = 2,
	hudstatusiconalignrg = 3,
	botgoaltype = Bot.kFlag,
	touchflags = {AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function murder_ball:hasanimation() return true end

function murder_ball:attachoffset() return Vector(32, 0, 0) end

function murder_ball:precache()
	PrecacheSound(self.tosssound)
	PrecacheSound("yourteam.flagstolen")
	PrecacheSound("otherteam.flagstolen")
	PrecacheSound("yourteam.drop")
	PrecacheSound("otherteam.drop")
	PrecacheSound("yourteam.flagreturn")
	PrecacheSound("otherteam.flagreturn")
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("otherteam.flagcap")
	PrecacheSound("misc.woop")
	info_ff_script.precache(self)
end

function murder_ball:spawn()
	self.notouch = {}
	info_ff_script.spawn(self)
	self.status = 0
end

function murder_ball:addnotouch(player_id, duration)
	self.notouch[player_id] = duration
	AddSchedule(self.name.."-"..player_id, duration, self.removenotouch, self, player_id)	
end

function murder_ball.removenotouch(self, player_id)
	self.notouch[player_id] = nil
end

function murder_ball:addnotouchall(duration)
	self.notouchall = duration
	AddSchedule(self.name.."-all", duration, self.removenotouchall, self)	
end

function murder_ball.removenotouchall(self)
	self.notouchall = nil
end

function murder_ball:touch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
			DAMAGE_STATUS = 2

		if self.notouch[player:GetId()] then return; end
		if self.notouchall then return; end
	
		if player:GetTeamId() ~= self.team then
			SmartSound(player, "yourteam.flagstolen", "yourteam.flagstolen", "otherteam.flagstolen")
			SmartSpeak(player, "CTF_YOUHAVEBALL", "CTF_TEAMHASBALL", "CTF_ENEMYHASBALL")
			SmartMessage(player, "You have the ball! Extra points for you!", "#FF_TEAMHASBALL", "#FF_ENEMYHASBALL")
			
			player:SetDisguisable(false)
			player:SetCloakable(false)
			
			local ball = CastToInfoScript(entity)
			ball:Pickup(player)
			self.status = 1
			AddHudIcon(player, self.hudicon, ball:GetName(), self.hudx, self.hudy, self.hudw, self.hudh, self.huda)
			RemoveHudItemFromAll("ball-icon-dropped")
			--Remove objective icon from ball carrier
			UpdateObjectiveIcon( player, nil )
			ball_carrier = player
			
			local team = player:GetTeamId()
			if (team == Team.kBlue) then
				AddHudIconToAll(self.hudstatusicon, "ball-icon-blue", self.hudstatusiconxrb, self.hudstatusiconyrb, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalignby)
			elseif (team == Team.kRed) then
				AddHudIconToAll(self.hudstatusicon, "ball-icon-red", self.hudstatusiconxrb, self.hudstatusiconyrb, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalignrg)
			elseif (team == Team.kYellow) then
				AddHudIconToAll(self.hudstatusicon, "ball-icon-yellow", self.hudstatusiconxyg, self.hudstatusiconyyg, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalignby)
			elseif (team == Team.kGreen) then
				AddHudIconToAll(self.hudstatusicon, "ball-icon-green", self.hudstatusiconxyg, self.hudstatusiconyyg, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalignrg)
			end
			--ADDS SCORE TO JUGGERNAUT AND JUG'S TEAM
			AddScheduleRepeating("scoretimer", SCORE_TIME, AddPoints, player)
			--ADDS HP AND ARMOR TO THE JUG
			AddScheduleRepeating("healthtimer", HEALTH_TIME, AddHealthPoints, player)		
		end
	end
end

function murder_ball:onownerdie(owner_entity)
	local ball = CastToInfoScript(entity)
	ball:Drop(BALL_RETURN_TIME, 10.0)
	self.status = 2
	if IsPlayer(owner_entity) then
		local player = CastToPlayer(owner_entity)
		RemoveHudItem(player, ball:GetName())

		local team = player:GetTeamId()
		if (team == Team.kBlue) then
			RemoveHudItemFromAll("ball-icon-blue")
		elseif (team == Team.kRed) then
			RemoveHudItemFromAll("ball-icon-red")
		elseif (team == Team.kYellow) then
			RemoveHudItemFromAll("ball-icon-yellow")
		elseif (team == Team.kGreen) then
			RemoveHudItemFromAll("ball-icon-green")
		end
	end
end

function murder_ball:ownerfeign(owner_entity)
	local ball = CastToInfoScript(entity)
	ball:Drop(BALL_RETURN_TIME, 0.0)
	self.status = 2
	if IsPlayer(owner_entity) then
		local player = CastToPlayer(owner_entity)
		RemoveHudItem(player, ball:GetName())
		DAMAGE_STATUS = 0

		local team = player:GetTeamId()
		if (team == Team.kBlue) then
			RemoveHudItemFromAll("ball-icon-blue")
		elseif (team == Team.kRed) then
			RemoveHudItemFromAll("ball-icon-red")
		elseif (team == Team.kYellow) then
			RemoveHudItemFromAll("ball-icon-yellow")
		elseif (team == Team.kGreen) then
			RemoveHudItemFromAll("ball-icon-green")
		end
	end
end



function murder_ball:dropitemcmd( drop_entity )
	if IsPlayer( drop_entity ) then
		local ball = CastToInfoScript( entity )
		local player = CastToPlayer( drop_entity )
		self.status = 2
		DAMAGE_STATUS = 0

		if not player:IsInUse() then
			ball:Drop(BALL_RETURN_TIME, BALL_THROW_SPEED)
			else
			ball:Drop(BALL_RETURN_TIME, BALL_THROW_SPEED * 0.333)
		end
		
		SmartSound( player, "misc.woop", "misc.woop", "misc.woop" )
		SmartMessage( player, "You lost the Juggernauts Power", "Your Teammate is no longer The Juggernaut!", "The Juggernaut has dropped the ball!", Color.kGrey, Color.kOrange, Color.kOrange)
		
		self:addnotouch(player:GetId(), 1)
		
	end
	

end	


function murder_ball:ondrop(owner_entity)
	if IsPlayer(owner_entity) then
		local ball = CastToInfoScript(entity)
			ball:EmitSound(self.tosssound)
		local player = CastToPlayer(owner_entity)
		DAMAGE_STATUS = 0
		SmartSound(player, "yourteam.drop", "yourteam.drop", "otherteam.drop")
		--SmartMessage(player, "#FF_YOUBALLDROP", "#FF_TEAMBALLDROP", "#FF_ENEMYBALLDROP")
		RemoveSchedule("scoretimer")
		RemoveSchedule("healthtimer")
		RemoveHudItem(player, ball:GetName())
		UpdateObjectiveIcon( player, GetEntityByName( "murder_ball" ) )
		
		--local player = CastToPlayer( player_entity )
		player:AddEffect( EF.kConc , 8, 5, 0 )
		player:AddEffect( EF.kOnfire , 5, 5, 0 )
		player:AddEffect( EF.kTranq , 3, 5, 0 )
		
		
		local team = player:GetTeamId()
		if (team == Team.kBlue) then
			RemoveHudItemFromAll("ball-icon-blue")
		elseif (team == Team.kRed) then
			RemoveHudItemFromAll("ball-icon-red")
		elseif (team == Team.kYellow) then
			RemoveHudItemFromAll("ball-icon-yellow")
		elseif (team == Team.kGreen) then
			RemoveHudItemFromAll("ball-icon-green")
		end
	end
end

function murder_ball:onloseitem(owner_entity)
	if IsPlayer(owner_entity) then
		local player = CastToPlayer(owner_entity)
		player:SetDisguisable(true)
		player:SetCloakable(true)
		DAMAGE_STATUS = 0

		self:addnotouch(player:GetId(), self.capnotouchtime)
	end
end

function murder_ball:onreturn()
	BroadCastMessage("#FF_BALLRETURN")
	BroadCastSound ("yourteam.flagreturn")
	SpeakAll("CTF_BALLRETURN")
	self.status = 0
	-- No touching for a bit after return
	self:addnotouchall(self.returnnotouchtime)
	-- Set ball location to yard
	current_ball_location = "yard"
end



ball = murder_ball:new({name = "Murderball"})

function HasBall(player_entity)
	if IsPlayer(player_entity) then
		local player = CastToPlayer(player_entity)
		local ball = GetInfoScriptByName("ball")
		if ball then
			if player:HasItem(ball:GetName()) then
				return true
			end
		end
	end
	return false
end




-------modified from waterpolo----------------------------------------
----------------------------------------------------------------------
-- returns the Ball if you run into this trigger_ff_script
ball_stripper = trigger_ff_script:new({ team = Team.kUnassigned })

 function ball_stripper:ontrigger ( trigger_entity )
	 if IsPlayer( trigger_entity ) and DAMAGE_STATUS == 2 then
		local player = CastToPlayer( trigger_entity )
		 UpdateObjectiveIcon( player, GetEntityByName( "murder_ball" ) )
		 SmartMessage( player, "Only mortals can pass. The Juggernaut weakens.", "The Juggernaut ball has returned", "The Juggernaut ball has returned", Color.kYellow, Color.kYellow, Color.kYellow )
		 SpeakAll ( "CTF_BALLRETURN" )
		 RemoveSchedule("scoretimer")
		 RemoveSchedule("healthtimer")
		 DAMAGE_STATUS = 0 
		local ball = GetInfoScriptByName( "murder_ball" )
		if ball then
			if player:HasItem(ball:GetName()) then
				ball:Return()
				RemoveHudItem(player, ball:GetName())
			end
		end
	end
 end



----------------------------------------------------------------------
-- Scheduling: Add Points and Health 
----------------------------------------------------------------------

function AddPoints(player_entity)
	if IsPlayer(player_entity) then
		local player = CastToPlayer(player_entity)
		player:AddFortPoints(ADD_JUGGERNAUT_POINTS, "+5 Juggernaut Bonus +10 Health +20 ARMOR.")
		local team = player:GetTeam()
		team:AddScore( ADD_JUGGERNAUT_TEAM_POINTS )
		
	end
end

function AddHealthPoints(player_entity)
	if IsPlayer( player_entity ) then
		local player = CastToPlayer( player_entity )
			player:AddHealth( HEALTH_POINTS )
			player:AddArmor( ARMOR_POINTS )
			player:AddAmmo( Ammo.kNails, 20 )
			player:AddAmmo( Ammo.kShells, 10 )
			player:AddAmmo( Ammo.kRockets, 10 )
			player:AddAmmo( Ammo.kCells, 50 )
		end
		
	end

function ReflectPool(player_entity)
	if IsPlayer( player_entity ) then
		local player = CastToPlayer( player_entity )
			player:AddHealth( 400 )
			player:AddArmor( 400 )
			player:AddAmmo( Ammo.kNails, 20 )
			player:AddAmmo( Ammo.kShells, 20 )
			player:AddAmmo( Ammo.kRockets, 20 )
			player:AddAmmo( Ammo.kCells, 50 )
			player:AddAmmo( Ammo.kGren1,  1 )
			player:AddAmmo( Ammo.kGren2,  1 )
			player:AddAmmo( Ammo.kManCannon, 1)
		end
		
	end



-----------------------------------------------------------------------------
-- FF_Tangled Locations 
-----------------------------------------------------------------------------


location_lowerred = location_info:new({ text = "LOWER LEVEL", team = Team.kRed })
location_lowerblue = location_info:new({ text = "LOWER LEVEL", team = Team.kBlue })
location_loweryellow = location_info:new({ text = "LOWER LEVEL", team = Team.kYellow })
location_lowergreen = location_info:new({ text = "LOWER LEVEL", team = Team.kGreen })
location_lowerhub = location_info:new({ text = "LOWER ELEVATOR HUB", team = NO_TEAM })
location_elevator = location_info:new({ text = "ELEVATOR SHAFT", team = NO_TEAM })
location_upper = location_info:new({ text = "UPPER LEVEL", team = NO_TEAM })
location_outside = location_info:new({ text = "OUTSIDE", team = NO_TEAM })
location_rooftops = location_info:new({ text = "ON THE ROOF", team = NO_TEAM })
location_final_destination = location_info:new({ text = "YOUR FINAL DESTINATION", team = NO_TEAM })
location_cells = location_info:new({ text = "CELLBLOCK 666: INTERROGATION/TORTURE ", team = Team.kRed })
location_labs = location_info:new({ text = "SECRET HL-2 LAB", team = Team.kBlue })
location_caves = location_info:new({ text = "CAVE SYSTEM", team = Team.kGreen })
location_reflecting_pool = location_info:new({ text = "Ahhhhh relax by the reflecting pool area", team = NO_TEAM })


-----------------------------------------------------------------------------
-- Easter egg shit
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--  Lower and reset gravities
-----------------------------------------------------------------------------

trigger_name = trigger_ff_script:new({})

function trigger_name:ontouch( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    player:SetGravity( 0.08 ) -- number > 0 and <= 1
  	BroadCastMessageToPlayer( player, "You have stepped inside the gravity well, you feel lighter...", 5 , Color.kPink )
  end
end

function trigger_name:onendtouch( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    player:SetGravity( 0.08 ) -- back to normal
  end
end

trigger_name2 = trigger_ff_script:new({})

function trigger_name2:ontouch( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    player:SetGravity( 1 ) -- number > 0 and <= 1
	BroadCastMessageToPlayer( player, "The Funnel has reset your gravity.", 5 , Color.kPink )
  end
end

function trigger_name2:onendtouch( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    player:SetGravity( 1 ) -- back to normal
  end
end


hw_low_grav = trigger_name:new({})
hw_normal_grav = trigger_name2:new({})


-----------------------------------------------------------
-- Extra points/Bonuses
-----------------------------------------------------------
CROW_FORTPOINTS = 10
FINAL_PTS_STATUS = 0

crow_points = trigger_ff_script:new({
	item = "",
	team = 0,
	botgoaltype = Bot.kFlagCap,
})

function crow_points:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
        
		player:AddFortPoints ( CROW_FORTPOINTS, "#FF_FORTPOINTS_CAPTUREFLAG" )
		BroadCastMessageToPlayer( player, "+10 PTS.    Mmmmmmmm get those pigeon points! ", 5, Color.kBlue )            
            
         end
end

crow_points_1 = crow_points:new({})


final_dest_points_1 = crow_points:new({})

function final_dest_points_1:ontouch(touch_entity)
    if IsPlayer(touch_entity) and FINAL_PTS_STATUS == 0 then
        local player = CastToPlayer(touch_entity)
			player:AddFortPoints ( 2000, "#FF_FORTPOINTS_CAPTUREFLAG" )
			BroadCastMessageToPlayer( player, "AWARDED 2000 FORTRESS POINTS FOR BEING A BADASS MOTHER FUCKER" )            
            FINAL_PTS_STATUS = 1
    end
end


-----------------------------------------------------------
-- OBJECTIVE 1: Fatty Button  
-----------------------------------------------------------
PROPRIETARY_COUNT = 0


function gen_onfat( player )
	-- add any thing you want to happen when the generator is hit by a wrench (while its detted) here
	ConsoleToAll("gen_onfat")
	
end

base_fat = func_button:new({ team = Team.kUnassigned })

--move this back to 100
NUM_HITS_TO_FAT = 100
FORT_POINTS_PER_FAT = 100

generatorsfat = 
{
	status = 0,
	repair_status = 0
}	

function base_fat:ondamage()
	if info_classname == "ff_weapon_assaultcannon" then
		generatorsfat.repair_status = generatorsfat.repair_status + 1
		BroadCastMessageToPlayer( player, "Fatty McFat Fat, try harder", 5, "12, 92, 97")
		if generatorsfat.repair_status >= NUM_HITS_TO_FAT then
			local player = CastToPlayer( GetPlayerByID(info_attacker) )
			player:AddFortPoints( FORT_POINTS_PER_FAT, "Being Fat" )
			OutputEvent( "beam1", "TurnOn" )
			OutputEvent( "beam1_sprite", "ShowSprite" )
			OutputEvent( "fat_glass", "break" )
			OutputEvent( "beam_loop_sound", "PlaySound" )
			BroadCastMessage("Anti-Gravity Well UNLOCKED!!! Beam 1 of 4 has been activated!")
			generatorsfat.repair_status = 0
			PROPRIETARY_COUNT = 1
		else 
			gen_onfat( player )
		end
	end

	return true
end

		
fatty_button = base_fat:new({ team = Team.kUnassigned })


-----------------------------------------------------------
-- OBJECTIVE 2A:  Spy easter egg shit  
-----------------------------------------------------------
function gen_onstab( player )
	-- add any thing you want to happen when the generator is hit by a wrench (while its detted) here
	ConsoleToAll("gen_onstab")
	
end

spy_base_gen = func_button:new({ team = Team.kUnassigned })
NUM_HITS_TO_STAB = 10
FORT_POINTS_PER_STAB = 50

generators2 = 
{
	status = 0,
	repair_status = 0
}	


function spy_base_gen:ondamage()
	if info_classname == "ff_weapon_knife" then
		generators2.repair_status = generators2.repair_status + 1
		if generators2.repair_status >= NUM_HITS_TO_STAB then
			local player = CastToPlayer( GetPlayerByID(info_attacker) )
			player:AddFortPoints( FORT_POINTS_PER_STAB, "Picking the lock" )
			OutputEvent( "gate_lock", "EnableMotion" )
			OutputEvent( "gate_left", "EnableMotion" )
			OutputEvent( "spy_knife_button", "Kill" )
			BroadCastMessage("A spy has picked the front gate lock!")
			generators2.repair_status = 0
		else 
			gen_onstab( player )
			BroadCastMessageToPlayer( player, "picking the lock", 5, "12, 92, 97")
	
		end
	end

	return true
end

spy_knife_button = spy_base_gen:new({ team = Team.kUnassigned })

-----------------------------------------------------------
-- OBJECTIVE 2B:  Spy easter egg shit  
-----------------------------------------------------------

function gen_onstab2( player )
	-- add any thing you want to happen when the generator is hit by a wrench (while its detted) here
	ConsoleToAll("gen_onstab2")
		
end

spy_base_gen2 = func_button:new({ team = Team.kUnassigned })
NUM_HITS_TO_HACK = 10
FORT_POINTS_PER_HACK = 50

generators3 = 
{
	status = 0,
	repair_status = 0
}	

function spy_base_gen2:ondamage()
	if info_classname == "ff_weapon_knife" then
		generators3.repair_status = generators3.repair_status + 1
		if generators3.repair_status >= NUM_HITS_TO_HACK then
			local player = CastToPlayer( GetPlayerByID(info_attacker) )
			player:AddFortPoints( FORT_POINTS_PER_HACK, "Hacking the generator" )
			OutputEvent( "beam2", "TurnOn" )
			OutputEvent( "beam2_sprite", "ShowSprite" )
			OutputEvent( "gen_spark", "StartSpark" )
			OutputEvent( "detpack_trigger", "Enable" )
			OutputEvent( "spy_knife_button2", "Kill" )
			OutputEvent( "gen_spark_on", "StopSpark" )
			OutputEvent( "detpack_trigger_reveal", "Enable" )
			OutputEvent( "transformer_loop_sound2", "StopSound" )
			OutputEvent( "transformer_sound", "PlaySound" )
			BroadCastMessage("A spy has hacked the Communications Generator! Beam 2 of 4 has been activated!")
			generators3.repair_status = 0
			PROPRIETARY_COUNT = 2
		else 
			gen_onstab2( player )
			BroadCastMessageToPlayer( player, "Hacking the Generator", 5, "12, 92, 97")
		end
	end

	return true
end

		
spy_knife_button2 = spy_base_gen2:new({ team = Team.kUnassigned })


-----------------------------------------------------------
-- OBJECTIVE 3:   Detpack trigger (Borrowed  and modified from Ksour/security)
-----------------------------------------------------------
FORT_POINTS_PER_DET = 100

detpack_trigger = trigger_ff_script:new({})
function detpack_trigger:onexplode( trigger_entity )
	if  PROPRIETARY_COUNT == 2  and IsDetpack( trigger_entity )  then
		detpack = CastToDetpack( trigger_entity )
		if IsPlayer( detpack:GetOwner() ) then
		local player = detpack:GetOwner()
			BroadCastMessage("Beam 3 of 4 has been activated!")
			OutputEvent("beam3", "TurnOn")
			OutputEvent( "beam3_sprite", "ShowSprite" )
			OutputEvent("beam_sound", "PlaySound")
			OutputEvent("detpack_trigger", "Kill") 
			OutputEvent("wrecking_ball_trigger", "Enable")
			OutputEvent("beam_loop_sound2", "PlaySound")
			player:AddFortPoints( FORT_POINTS_PER_DET, "Detting the generator" )
			PROPRIETARY_COUNT = 3
			end
		end
	return EVENT_ALLOWED
end

detpack_easter_egg = detpack_trigger:new({})


-----------------------------------------------------------
-- OBJECTIVE 4:  Engineer Repair trigger  (Borrowed and modified from FF_security_b1.lua thanks Exo and fixed by Dexter)
-----------------------------------------------------------
function gen_onclank( player )
	-- add any thing you want to happen when the generator is hit by a wrench (while its detted) here
	ConsoleToAll("gen_onclank")
	
end

base_gen = func_button:new({ team = Team.kUnassigned })

NUM_HITS_TO_REPAIR = 10
FORT_POINTS_PER_REPAIR = 100

generators = 
{
	status = 0,
	repair_status = 0
}	

function base_gen:ondamage()
	if  PROPRIETARY_COUNT == 3  and info_classname == "ff_weapon_spanner" then
		generators.repair_status = generators.repair_status + 1
		BroadCastMessageToPlayer( player, "Repairing the Crane", 5, "12, 92, 97")
		if generators.repair_status >= NUM_HITS_TO_REPAIR then
			local player = CastToPlayer( GetPlayerByID(info_attacker) )
			player:AddFortPoints( FORT_POINTS_PER_REPAIR, "Repairing the Crane" )
			OutputEvent( "beam4", "TurnOn" )
			OutputEvent( "beam4_sprite", "ShowSprite" )
			OutputEvent( "final_tele", "Enable" )
			OutputEvent( "detpack_trigger", "Enable" )
			--OutputEvent( "tele_2_trigger", "Enable" )
			--OutputEvent( "engy_button_sparks", "StopSpartk" )
			OutputEvent( "engy_button_timer", "Enable"  )
			OutputEvent( "stormy_sprite", "ShowSprite" )
			OutputEvent("tele_loop_sound", "PlaySound")
			BroadCastMessage("All beams have been activated. The final teleporter is ONLINE!")
			generators.repair_status = 0
		else 
			gen_onclank( player )
		end
	end

	return true
end

		
engy_spanner_button = base_gen:new({ team = Team.kUnassigned })



-----------------------------------------------------------
-- Detpack trigger (Borrowed  and modified from Ksour/security)
-----------------------------------------------------------
FORT_POINTS_PER_DET_2 = 100

detpack_trigger_last = trigger_ff_script:new({})

function detpack_trigger_last:onexplode( trigger_entity )
	if IsDetpack( trigger_entity ) then
		detpack = CastToDetpack( trigger_entity )
		if IsPlayer( detpack:GetOwner() ) then
		local player = detpack:GetOwner()
			BroadCastMessage("The Underground Lab has been Breached!")
			OutputEvent("wall_hole", "Disable")
			player:AddFortPoints( FORT_POINTS_PER_DET_2, "Blowing open the Lab" )
		end
	end
	return EVENT_ALLOWED
end

last_detpack = detpack_trigger_last:new({})
