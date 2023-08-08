-- swoop.lua

-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base_ctf")
IncludeScript("base_shutdown")
IncludeScript("base_location")

-----------------------------------------------------------------------------
-- aardvark security
-----------------------------------------------------------------------------
red_aardvarksec = trigger_ff_script:new()
blue_aardvarksec = trigger_ff_script:new()
bluesecstatus = 1
redsecstatus = 1

sec_iconx = 60
sec_icony = 30
sec_iconw = 16
sec_iconh = 16

function red_aardvarksec:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kBlue then
			if redsecstatus == 1 then
				redsecstatus = 0
				AddSchedule("aardvarksecup10red",20,aardvarksecup10red)
				AddSchedule("aardvarksecupred",30,aardvarksecupred)
				OpenDoor("red_aardvarkdoorhack")
				BroadCastMessage("#FF_RED_SEC_30")
				--BroadCastSound( "otherteam.flagstolen")
				SpeakAll( "SD_REDDOWN" )
				RemoveHudItemFromAll( "red-sec-up" )
				AddHudIconToAll( "hud_secdown.vtf", "red-sec-down", sec_iconx, sec_icony, sec_iconw, sec_iconh, 3 )
			end
		end
	end
end

function blue_aardvarksec:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kRed then
			if bluesecstatus == 1 then
				bluesecstatus = 0
				AddSchedule("aardvarksecup10blue",20,aardvarksecup10blue)
				AddSchedule("aardvarksecupblue",30,aardvarksecupblue)
				OpenDoor("blue_aardvarkdoorhack")
				BroadCastMessage("#FF_BLUE_SEC_30")
				--BroadCastSound( "otherteam.flagstolen")
				SpeakAll( "SD_BLUEDOWN" )
				RemoveHudItemFromAll( "blue-sec-up" )
				AddHudIconToAll( "hud_secdown.vtf", "blue-sec-down", sec_iconx, sec_icony, sec_iconw, sec_iconh, 2 )
			end
		end
	end
end

function aardvarksecupred()
	redsecstatus = 1
	CloseDoor("red_aardvarkdoorhack")
	BroadCastMessage("#FF_RED_SEC_ON")
	SpeakAll( "SD_REDUP" )
	RemoveHudItemFromAll( "red-sec-down" )
	AddHudIconToAll( "hud_secup_red.vtf", "red-sec-up", sec_iconx, sec_icony, sec_iconw, sec_iconh, 3 )
end

function aardvarksecupblue()
	bluesecstatus = 1
	CloseDoor("blue_aardvarkdoorhack")
	BroadCastMessage("#FF_BLUE_SEC_ON")
	SpeakAll( "SD_BLUEUP" )
	RemoveHudItemFromAll( "blue-sec-down" )
	AddHudIconToAll( "hud_secup_blue.vtf", "blue-sec-up", sec_iconx, sec_icony, sec_iconw, sec_iconh, 2 )
end

function aardvarksecup10red()
	BroadCastMessage("#FF_RED_SEC_10")
end

function aardvarksecup10blue()
	BroadCastMessage("#FF_BLUE_SEC_10")
end

-----------------------------------------------------------------------------
-- aardvark lasers and respawn shields
-----------------------------------------------------------------------------
KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })
lasers_KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })

function KILL_KILL_KILL:allowed( activator )
	local player = CastToPlayer( activator )
	if player then
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

function lasers_KILL_KILL_KILL:allowed( activator )
	local player = CastToPlayer( activator )
	if player then
		if player:GetTeamId() == self.team then
			if self.team == Team.kBlue then
				if redsecstatus == 1 then
					return EVENT_ALLOWED
				end
			end
			if self.team == Team.kRed then
				if bluesecstatus == 1 then
					return EVENT_ALLOWED
				end
			end
		end
	end
	return EVENT_DISALLOWED
end

blue_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })
red_slayer = KILL_KILL_KILL:new({ team = Team.kRed })
sec_blue_slayer = lasers_KILL_KILL_KILL:new({ team = Team.kBlue })
sec_red_slayer = lasers_KILL_KILL_KILL:new({ team = Team.kRed })

-------------------------
-- flaginfo
-------------------------
function flaginfo( player_entity )
	local player = CastToPlayer( player_entity )

	flaginfo_base(player_entity) --basic CTF HUD items

	RemoveHudItem( player, "red-sec-down" )
	RemoveHudItem( player, "blue-sec-down" )
	RemoveHudItem( player, "red-sec-up" )
	RemoveHudItem( player, "blue-sec-up" )

	if bluesecstatus == 1 then
		AddHudIcon( player, "hud_secup_blue.vtf", "blue-sec-up", sec_iconx, sec_icony, sec_iconw, sec_iconh, 2 )
	else
		AddHudIcon( player, "hud_secdown.vtf", "blue-sec-down", sec_iconx, sec_icony, sec_iconw, sec_iconh, 2 )
	end

	if redsecstatus == 1 then
		AddHudIcon( player, "hud_secup_red.vtf", "red-sec-up", sec_iconx, sec_icony, sec_iconw, sec_iconh, 3 )
	else
		AddHudIcon( player, "hud_secdown.vtf", "red-sec-down", sec_iconx, sec_icony, sec_iconw, sec_iconh, 3 )
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
	push_horizontal = 400,
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

-----------------------------------------------------------------------------
-- Give Full Concs on Respawn
-----------------------------------------------------------------------------
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
--	if player:GetClass() == Player.kMedic then
--		player:AddAmmo(Ammo.kGren2, 4)
--	end
--	if player:GetClass() == Player.kScout then
--		player:AddAmmo(Ammo.kGren2, 4)
--	end
	player:AddHealth( 400 )
	player:AddArmor( 400 )
	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:AddAmmo( Ammo.kGren2, 3)
end

-----------------------------------------------------------------------------
-- Backpacks
-----------------------------------------------------------------------------

ff_swoop_genbag = genericbackpack:new({
	health = 25,
	armor = 25,
	
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 100,
	
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_swoop_genbag:dropatspawn() return false end
blue_swoop_genbag = ff_swoop_genbag:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_swoop_genbag = ff_swoop_genbag:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

ff_swoop_nades = genericbackpack:new({
	health = 100,
	armor = 300,
	
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 200,
	gren1 = 4,
	gren2 = 4,
	
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_swoop_nades:dropatspawn() return false end
blue_swoop_nades = ff_swoop_nades:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_swoop_nades = ff_swoop_nades:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

location_blue_spawn	= location_info:new({ text = "Blue Respawn", team = Team.kBlue })

location_blue_security	= location_info:new({ text = "Security Room", team = Team.kBlue })

location_blue_ramproom		= location_info:new({ text = "Ramp Room", team = Team.kBlue })

location_blue_toproute	= location_info:new({ text = "Top Connector", team = Team.kBlue })

location_blue_flagroom		= location_info:new({ text = "Flag Room", team = Team.kBlue })



location_red_spawn	= location_info:new({ text = "Red Respawn", team = Team.kRed })

location_red_security	= location_info:new({ text = "Security Room", team = Team.kRed })

location_red_ramproom		= location_info:new({ text = "Ramp Room", team = Team.kRed })

location_red_toproute	= location_info:new({ text = "Top Connector", team = Team.kRed })

location_red_flagroom		= location_info:new({ text = "Flag Room", team = Team.kRed })

location_topyard	= location_info:new({ text = "Top Yard", team = Team.kUnassigned })

location_botyard	= location_info:new({ text = "Bottom Yard", team = Team.kUnassigned })
