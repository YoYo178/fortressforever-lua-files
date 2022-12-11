--ff_complex
-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript( "base_ctf" );





-----------------------------------------------------------------------------
-- aardvark security
-----------------------------------------------------------------------------
red_aardvarksec = trigger_ff_script:new()
blue_aardvarksec = trigger_ff_script:new()
bluesecstatus = 1
redsecstatus = 1

function red_aardvarksec:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kBlue then
			if redsecstatus == 1 then
				redsecstatus = 0
				AddSchedule("aardvarksecup10red",20,aardvarksecup10red)
				AddSchedule("aardvarksecupred",30,aardvarksecupred)
				OpenDoor("red_aardvarkdoorhack")
				BroadCastMessage("Red Security Deactivated for 30 Seconds")
				--BroadCastSound( "otherteam.flagstolen")
				SpeakAll( "SD_REDDOWN" )
				RemoveHudItemFromAll( "red-sec-up" )
				AddHudIconToAll( "hud_secdown.vtf", "red-sec-down", 60, 25, 16, 16, 3 )
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
				BroadCastMessage("Blue Security Deactivated for 30 Seconds")
				--BroadCastSound( "otherteam.flagstolen")
				SpeakAll( "SD_BLUEDOWN" )
				RemoveHudItemFromAll( "blue-sec-up" )
				AddHudIconToAll( "hud_secdown.vtf", "blue-sec-down", 60, 25, 16, 16, 2 )
			end
		end
	end
end

function aardvarksecupred()
	redsecstatus = 1
	CloseDoor("red_aardvarkdoorhack")
	BroadCastMessage("Red Security Online")
	SpeakAll( "SD_REDUP" )
	RemoveHudItemFromAll( "red-sec-down" )
	AddHudIconToAll( "hud_secup_red.vtf", "red-sec-up", 60, 25, 16, 16, 3 )
end

function aardvarksecupblue()
	bluesecstatus = 1
	CloseDoor("blue_aardvarkdoorhack")
	BroadCastMessage("Blue Security Online")
	SpeakAll( "SD_BLUEUP" )
	RemoveHudItemFromAll( "blue-sec-down" )
	AddHudIconToAll( "hud_secup_blue.vtf", "blue-sec-up", 60, 25, 16, 16, 2 )
end

function aardvarksecup10red()
	BroadCastMessage("Red Security Online in 10 Seconds")
end

function aardvarksecup10blue()
	BroadCastMessage("Blue Security Online in 10 Seconds")
end






-------------------------
-- flaginfo
-------------------------

---------------------------- COPIED FROM BASE_CTF ----------------

function flaginfo( player_entity )
-- at the moment this is crappy workaround - simply displays the home icon
	local player = CastToPlayer( player_entity )

	RemoveHudItem( player, blue_flag.name )
	RemoveHudItem( player, blue_flag.name .. "_c" )
	RemoveHudItem( player, blue_flag.name .. "_d" )

	RemoveHudItem( player, red_flag.name )
	RemoveHudItem( player, red_flag.name .. "_c" )
	RemoveHudItem( player, red_flag.name .. "_d" )

	-- copied from blue_flag variables
	AddHudIcon( player, blue_flag.hudstatusiconhome, ( blue_flag.name.. "_h" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )
	AddHudIcon( player, red_flag.hudstatusiconhome, ( red_flag.name.. "_h" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )
	
	local flag = GetInfoScriptByName("blue_flag")
	
	if flag:IsCarried() then
			AddHudIcon( player, blue_flag.hudstatusiconcarried, ( blue_flag.name.. "_h" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )
	elseif flag:IsDropped() then
			AddHudIcon( player, blue_flag.hudstatusicondropped, ( blue_flag.name.. "_h" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )
	end

	flag = GetInfoScriptByName("red_flag")
	
	if flag:IsCarried() then
			AddHudIcon( player, red_flag.hudstatusiconcarried, ( red_flag.name.. "_h" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )
	elseif flag:IsDropped() then
			AddHudIcon( player, red_flag.hudstatusicondropped, ( red_flag.name.. "_h" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )
	end

----------------- END PASTE FROM CTF ---------------------------------

	RemoveHudItem( player, "red-sec-down" )
	RemoveHudItem( player, "blue-sec-down" )
	RemoveHudItem( player, "red-sec-up" )
	RemoveHudItem( player, "blue-sec-up" )

		if bluesecstatus == 1 then
			AddHudIcon( player, "hud_secup_blue.vtf", "blue-sec-up", 60, 25, 16, 16, 2 )
		else
			AddHudIcon( player, "hud_secdown.vtf", "blue-sec-down", 60, 25, 16, 16, 2 )
		end

		if redsecstatus == 1 then
			AddHudIcon( player, "hud_secup_red.vtf", "red-sec-up", 60, 25, 16, 16, 3 )
		else
			AddHudIcon( player, "hud_secdown.vtf", "red-sec-down", 60, 25, 16, 16, 3 )
		end
end

---------------------------------------------------------------------------------
--Ammo bag2
---------------------------------------------------------------------------------

ammo = genericbackpack:new({
    respawntime = 35,
health = 50,
armor = 50,
grenades = 20, 
nails = 150,
shells = 100,
rockets = 30, 
cells = 100, 
model = "models/items/backpack/backpack.mdl",
materializesound = "Item.Materialize",
touchsound = "Backpack.Touch",
touchflags = {},
botgoaltype = Bot.kBackPack_Ammo
})

function ammo :dropatspawn() return false end

red_ammo2 = ammo:new({ touchflags = {AllowFlags.kRed} })
blue_ammo2 = ammo:new({ touchflags = {AllowFlags.kBlue} })

------------------------------------------------------------------------------------------
--Ammo bag
------------------------------------------------------------------------------------------
ammo = genericbackpack:new({
    respawntime = 20,
health = 100,
armor = 300,
grenades = 20,
nails = 150,
shells = 100,
rockets = 30,
cells = 150,
model = "models/items/backpack/backpack.mdl",
materializesound = "Item.Materialize",
touchsound = "Backpack.Touch",
touchflags = {},
botgoaltype = Bot.kBackPack_Ammo
})

function ammo :dropatspawn() return false end

red_ammo = ammo:new({ touchflags = {AllowFlags.kRed} })
blue_ammo = ammo:new({ touchflags = {AllowFlags.kBlue} })
------------------------------------------------------------------------------------------
-- lzr killer 
-- must be trigger_hurt
------------------------------------------------------------------------------------------
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

-- blue_slayer KILLS red

red_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })
blue_slayer = KILL_KILL_KILL:new({ team = Team.kRed })

------------------------------------------------------------------------------------------
-- lzr killer(flagroom)
-- must be trigger_hurt
------------------------------------------------------------------------------------------
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

-- blue_slayer2 KILLS red

red_slayer2 = KILL_KILL_KILL:new({ team = Team.kBlue })
blue_slayer2 = KILL_KILL_KILL:new({ team = Team.kRed })


