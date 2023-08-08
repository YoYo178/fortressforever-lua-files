
-- ff_nyx_b1.lua

-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------
IncludeScript("base_ctf");
-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60
-----------------------------------------------------------------------------
--lzr
-----------------------------------------------------------------------------
KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })
function KILL_KILL_KILL:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

blue_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })
red_slayer = KILL_KILL_KILL:new({ team = Team.kRed })

-----------------------------------------------------------------------------
--health
-----------------------------------------------------------------------------
resup = trigger_ff_script:new({ team = Team.kUnassigned })

function resup:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			player:AddHealth( 400 )
			player:AddArmor( 400 )
			player:AddAmmo( Ammo.kNails, 400 )
			player:AddAmmo( Ammo.kShells, 400 )
			player:AddAmmo( Ammo.kRockets, 400 )
			player:AddAmmo( Ammo.kCells, 400 )
		end
	end
end

bluehealth = resup:new({ team = Team.kBlue })
redhealth = resup:new({ team = Team.kRed })

---------------------------------
-- Packsnormal
---------------------------------

pack = genericbackpack:new({
	health = 30,
	armor = 20,
	grenades = 60,
	nails = 60,
	shells = 60,
	rockets = 60,
	cells = 60,
	mancannons = 1,
	gren1 = 1,
	gren2 = 0,
	respawntime = 45,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function pack :dropatspawn() return false end

red_pack = pack:new({ touchflags = {AllowFlags.kRed} })
blue_pack = pack:new({ touchflags = {AllowFlags.kBlue} })

---------------------------------
-- Packs nade
---------------------------------

packnade = genericbackpack:new({
	health = 200,
	armor = 200,
	grenades = 90,
	nails = 90,
	shells = 90,
	rockets = 90,
	cells = 200,
	gren1 = 4,
	gren2 = 4,
	respawntime = 60,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function pack :dropatspawn() return false end

fullnades_red = packnade:new({ touchflags = {AllowFlags.kRed} })
fullnades_blue = packnade:new({ touchflags = {AllowFlags.kBlue} })

--------------------------------------------------
-- flag return fixes by -_YoYo178_-
--------------------------------------------------

--------------------------------------------------
-- Make the flag return after falling in the void
--------------------------------------------------

blueflagreturn = trigger_ff_script:new()
midflagreturn = trigger_ff_script:new()
redflagreturn = trigger_ff_script:new()

--------------------------------------------------
function blueflagreturn:allowed(trigger_player)
	if IsPlayer(trigger_player) then
		local player = CastToPlayer(trigger_player)
		return EVENT_ALLOWED
	else
		return EVENT_DISALLOWED
	end
end

function midflagreturn:allowed(trigger_player)
	if IsPlayer(trigger_player) then
		local player = CastToPlayer(trigger_player)
		return EVENT_ALLOWED
	else
		return EVENT_DISALLOWED
	end
end

function redflagreturn:allowed(trigger_player)
	if IsPlayer(trigger_player) then
		local player = CastToPlayer(trigger_player)
		return EVENT_ALLOWED
	else
		return EVENT_DISALLOWED
	end
end

function blueflagreturn:ontrigger(trigger_player)
	if IsPlayer(trigger_player) then
		local player = CastToPlayer(trigger_player)
		
		local redflag = GetInfoScriptByName("red_flag")
		local redflagorigin = redflag:GetOrigin()
		
		local blueflag = GetInfoScriptByName("blue_flag")
		local blueflagorigin = blueflag:GetOrigin()
		
		local target = GetEntityByName("void")
		local targetorigin = target:GetOrigin()
		
		if redflag:IsCarried() == true then
			if redflagorigin.z < targetorigin.z then
				FLAG_RETURN_TIME = 1
				AddSchedule( "redflagtime", 2.0, restoreflagreturntime)
			end
		end
		if blueflag:IsCarried() == true then
			if blueflagorigin.z < targetorigin.z then
				FLAG_RETURN_TIME = 1
				AddSchedule( "blueflagtime", 2.0, restoreflagreturntime)
			end
		end
	end
end 

function midflagreturn:ontrigger(trigger_player)
	if IsPlayer(trigger_player) then
		local player = CastToPlayer(trigger_player)
		
		local redflag = GetInfoScriptByName("red_flag")
		local redflagorigin = redflag:GetOrigin()
		
		local blueflag = GetInfoScriptByName("blue_flag")
		local blueflagorigin = blueflag:GetOrigin()
		
		local midtarget = GetEntityByName("voidmid")
		local midtargetorigin = midtarget:GetOrigin()
		
		if redflag:IsCarried() == true then
			if redflagorigin.z < midtargetorigin.z then
				FLAG_RETURN_TIME = 1
				AddSchedule( "redflagtime", 2.0, restoreflagreturntime)
			end
		end
		if blueflag:IsCarried() == true then
			if blueflagorigin.z < midtargetorigin.z then
				FLAG_RETURN_TIME = 1
				AddSchedule( "blueflagtime", 2.0, restoreflagreturntime)
			end
		end
	end
end 

function redflagreturn:ontrigger(trigger_player)
	if IsPlayer(trigger_player) then
		local player = CastToPlayer(trigger_player)
		
		local redflag = GetInfoScriptByName("red_flag")
		local redflagorigin = redflag:GetOrigin()
		
		local blueflag = GetInfoScriptByName("blue_flag")
		local blueflagorigin = blueflag:GetOrigin()
		
		local target = GetEntityByName("void")
		local targetorigin = target:GetOrigin()
		
		if redflag:IsCarried() == true then
			if redflagorigin.z < targetorigin.z then
				FLAG_RETURN_TIME = 1
				AddSchedule( "redflagtime", 2.0, restoreflagreturntime)
			end
		end
		if blueflag:IsCarried() == true then
			if blueflagorigin.z < targetorigin.z then
				FLAG_RETURN_TIME = 1
				AddSchedule( "blueflagtime", 2.0, restoreflagreturntime)
			end
		end
	end
end 

function restoreflagreturntime()
	FLAG_RETURN_TIME = 60
end 