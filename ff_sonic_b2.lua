
-- ff_sonic_b2.lua


-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_location");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 60;
-----------------------------------------------------------------------------
-- One Nade
-----------------------------------------------------------------------------

nade = genericbackpack:new({
	gren1 = 1,
    respawntime = 25,
	model = "models/grenades/frag/frag.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function nade :dropatspawn() return false end

red_nade = nade:new({ touchflags = {AllowFlags.kRed} })
blue_nade = nade:new({ touchflags = {AllowFlags.kBlue} })


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

