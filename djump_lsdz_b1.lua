-----------------------------------------------------------------------------
-- djump_lsdz_b1.lua
-- modified for zE Palace servers
-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base_ctf4");
IncludeScript("base_location")

-----------------------------------------------------------------
-- Cvars specific for zE Palace servers, if you dont have those plugins remove this part or might crash your server!
-----------------------------------------------------------------

SetConvar("sv_skillutility", 1)
SetConvar("sv_helpmsg", 1)

----------------------------
-- Toggle Concussion Effect.
----------------------------
CONC_EFFECT = 0

function player_onconc()
	if CONC_EFFECT == 0 then return EVENT_DISALLOWED end
	return EVENT_ALLOWED
end

---------------------------------
function startup()
	AddScheduleRepeating("restock", 1, restock_all)

	SetTeamName(Team.kBlue, "Blue DoubleJumpers")
	SetTeamName(Team.kRed, "Red DoubleJumpers")
	SetTeamName(Team.kYellow, "Yellow DoubleJumpers")
	SetTeamName(Team.kGreen, "Newbies")

	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, 0)
	SetPlayerLimit(Team.kGreen, 0)

	local team = GetTeam(Team.kYellow)
	team:SetAllies(Team.kGreen)
	team:SetAllies(Team.kBlue)
	team:SetAllies(Team.kRed)

	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kSoldier, -1)
	team:SetClassLimit(Player.kDemoman, -1)
	team:SetClassLimit(Player.kMedic, -1)
	team:SetClassLimit(Player.kHwguy, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kSpy, -1)
	team:SetClassLimit(Player.kEngineer, -1)
	team:SetClassLimit(Player.kCivilian, -1)

	local team = GetTeam(Team.kGreen)
	team:SetAllies(Team.kYellow)
	team:SetAllies(Team.kBlue)
	team:SetAllies(Team.kRed)

	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kSoldier, -1)
	team:SetClassLimit(Player.kDemoman, -1)
	team:SetClassLimit(Player.kMedic, -1)
	team:SetClassLimit(Player.kHwguy, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kSpy, -1)
	team:SetClassLimit(Player.kEngineer, -1)
	team:SetClassLimit(Player.kCivilian, -1)

	local team = GetTeam(Team.kBlue)
	team:SetAllies(Team.kGreen)
	team:SetAllies(Team.kYellow)
	team:SetAllies(Team.kRed)

	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kSoldier, -1)
	team:SetClassLimit(Player.kDemoman, -1)
	team:SetClassLimit(Player.kMedic, -1)
	team:SetClassLimit(Player.kHwguy, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kSpy, -1)
	team:SetClassLimit(Player.kEngineer, -1)
	team:SetClassLimit(Player.kCivilian, -1)

	local team = GetTeam(Team.kRed)
	team:SetAllies(Team.kGreen)
	team:SetAllies(Team.kBlue)
	team:SetAllies(Team.kYellow)

	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kSoldier, -1)
	team:SetClassLimit(Player.kDemoman, -1)
	team:SetClassLimit(Player.kMedic, -1)
	team:SetClassLimit(Player.kHwguy, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kSpy, -1)
	team:SetClassLimit(Player.kEngineer, -1)
	team:SetClassLimit(Player.kCivilian, -1)
end

---Remove Grenades and stuff at spawn

function player_spawn(player_entity)
	local player = CastToPlayer(player_entity)

	-- Ammo removal
	if player:GetClass() == Player.kDemoman then
		player:RemoveWeapon("ff_weapon_deploydetpack")
		player:RemoveAmmo(Ammo.kGren2, 4)
		player:AddAmmo(Ammo.kRockets, 400)
		player:AddAmmo(Ammo.kShells, 400)
		player:AddArmor(400)
	elseif player:GetClass() == Player.kPyro then
		player:RemoveAmmo(Ammo.kGren2, 4)
		player:AddAmmo(Ammo.kCells, 400)
		player:AddAmmo(Ammo.kRockets, 400)
		player:AddAmmo(Ammo.kShells, 400)
		player:AddArmor(400)
	elseif player:GetClass() == Player.kSoldier then
		player:RemoveAmmo(Ammo.kGren2, 4)
		player:AddAmmo(Ammo.kShells, 400)
		player:AddAmmo(Ammo.kRockets, 400)
		player:AddArmor(400)
	elseif player:GetClass() == Player.kEngineer then
		player:RemoveAmmo(Ammo.kGren2, 4)
		player:AddAmmo(Ammo.kCells, 400)
		player:AddAmmo(Ammo.kNails, 400)
		player:AddAmmo(Ammo.kShells, 400)
		player:AddArmor(400)
	elseif player:GetClass() == Player.kMedic then
		player:RemoveAmmo(Ammo.kGren1, 4)
		player:AddAmmo(Ammo.kGren2, 4)
		player:AddAmmo(Ammo.kNails, 400)
		player:AddAmmo(Ammo.kShells, 400)
		player:AddArmor(400)
	elseif player:GetClass() == Player.kScout then
		player:RemoveAmmo(Ammo.kManCannon, 1)
		player:RemoveAmmo(Ammo.kCells, 400)
		player:RemoveAmmo(Ammo.kGren2, 4)
		player:AddAmmo(Ammo.kShells, 400)
		player:AddAmmo(Ammo.kNails, 400)
		player:AddArmor(400)
	elseif player:GetClass() == Player.kSpy then
		player:RemoveAmmo(Ammo.kGren2, 4)
		player:AddAmmo(Ammo.kShells, 400)
		player:AddAmmo(Ammo.kNails, 400)
		player:AddArmor(400)
	elseif player:GetClass() == Player.kSniper then
		player:AddAmmo(Ammo.kNails, 400)
		player:AddAmmo(Ammo.kShells, 400)
		player:AddArmor(400)
	end
end

--------------------
--Locations
--------------------

location_stage65  = location_info:new({ text = "Stage 1", team = NO_TEAM })
location_stage66  = location_info:new({ text = "Stage 2", team = NO_TEAM })
location_stage67  = location_info:new({ text = "Stage 3", team = NO_TEAM })
location_stage68  = location_info:new({ text = "Stage 4", team = NO_TEAM })
location_stage69  = location_info:new({ text = "Stage 5", team = NO_TEAM })
location_stage70  = location_info:new({ text = "Stage 6", team = NO_TEAM })
location_stage71  = location_info:new({ text = "Stage 7", team = NO_TEAM })
location_stage72  = location_info:new({ text = "Stage 8", team = NO_TEAM })
location_stage73  = location_info:new({ text = "Stage 9", team = NO_TEAM })
location_stage74  = location_info:new({ text = "Stage 10", team = NO_TEAM })
location_stage75  = location_info:new({ text = "Stage 11", team = NO_TEAM })
location_stage76  = location_info:new({ text = "Stage 12", team = NO_TEAM })
location_stage77  = location_info:new({ text = "Stage 13", team = NO_TEAM })
location_stage78  = location_info:new({ text = "Stage 14", team = NO_TEAM })
location_stage79  = location_info:new({ text = "Stage 15", team = NO_TEAM })
location_stage80  = location_info:new({ text = "Stage 16", team = NO_TEAM })
location_stage81  = location_info:new({ text = "Stage 17", team = NO_TEAM })
location_stage82  = location_info:new({ text = "Stage 18", team = NO_TEAM })
location_stage83  = location_info:new({ text = "Stage 19", team = NO_TEAM })
location_stage84  = location_info:new({ text = "Stage 20", team = NO_TEAM })
location_stage85  = location_info:new({ text = "Stage 21", team = NO_TEAM })
location_stage86  = location_info:new({ text = "Stage 22", team = NO_TEAM })
location_stage87  = location_info:new({ text = "Stage 23", team = NO_TEAM })
location_stage88  = location_info:new({ text = "Stage 24", team = NO_TEAM })
location_stage89  = location_info:new({ text = "Stage 25", team = NO_TEAM })
location_stage90  = location_info:new({ text = "Stage 26", team = NO_TEAM })
location_stage91  = location_info:new({ text = "Stage 27", team = NO_TEAM })
location_stage92  = location_info:new({ text = "Stage 28", team = NO_TEAM })
location_stage93  = location_info:new({ text = "Stage 29", team = NO_TEAM })
location_stage94  = location_info:new({ text = "Stage 30", team = NO_TEAM })
location_stage95  = location_info:new({ text = "Stage 31", team = NO_TEAM })
location_stage96  = location_info:new({ text = "Stage 32", team = NO_TEAM })
location_stage97  = location_info:new({ text = "Stage 33", team = NO_TEAM })
location_stage98  = location_info:new({ text = "Stage 34", team = NO_TEAM })
location_stage99  = location_info:new({ text = "Stage 35", team = NO_TEAM })
location_stage100 = location_info:new({ text = "Stage 36", team = NO_TEAM })
location_stage101 = location_info:new({ text = "Stage 37", team = NO_TEAM })
location_stage102 = location_info:new({ text = "Stage 38", team = NO_TEAM })
location_stage103 = location_info:new({ text = "Stage 39", team = NO_TEAM })
location_stage104 = location_info:new({ text = "Stage 40", team = NO_TEAM })
location_stage105 = location_info:new({ text = "Stage 41", team = NO_TEAM })
location_stage106 = location_info:new({ text = "Stage 42", team = NO_TEAM })
location_stage107 = location_info:new({ text = "Stage 43", team = NO_TEAM })
location_stage108 = location_info:new({ text = "Stage 44", team = NO_TEAM })
location_stage109 = location_info:new({ text = "Stage 45", team = NO_TEAM })
location_stage110 = location_info:new({ text = "Stage 46", team = NO_TEAM })
location_stage111 = location_info:new({ text = "Stage 47", team = NO_TEAM })
location_stage112 = location_info:new({ text = "Stage 48", team = NO_TEAM })
location_stage113 = location_info:new({ text = "Stage 49", team = NO_TEAM })
location_stage114 = location_info:new({ text = "Stage 50", team = NO_TEAM })
location_stage115 = location_info:new({ text = "Stage 51", team = NO_TEAM })
location_stage116 = location_info:new({ text = "Stage 52", team = NO_TEAM })
location_stage117 = location_info:new({ text = "Stage 53", team = NO_TEAM })
location_stage118 = location_info:new({ text = "Stage 54", team = NO_TEAM })
location_stage119 = location_info:new({ text = "Stage 55", team = NO_TEAM })
location_stage120 = location_info:new({ text = "Stage 56", team = NO_TEAM })
location_stage121 = location_info:new({ text = "Stage 57", team = NO_TEAM })
location_stage122 = location_info:new({ text = "Stage 58", team = NO_TEAM })
location_stage123 = location_info:new({ text = "Stage 59", team = NO_TEAM })
location_stage124 = location_info:new({ text = "Stage 60", team = NO_TEAM })
location_stage125 = location_info:new({ text = "Stage 61", team = NO_TEAM })
location_stage126 = location_info:new({ text = "Stage 62", team = NO_TEAM })
location_stage127 = location_info:new({ text = "Stage 63", team = NO_TEAM })
location_stage128 = location_info:new({ text = "Stage 64", team = NO_TEAM })
location_stage129 = location_info:new({ text = "Stage 65", team = NO_TEAM })
location_stage130 = location_info:new({ text = "Final Stage", team = NO_TEAM })
--------------------
--Finish Zones
--------------------

finish            = trigger_ff_script:new({})

function finish:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		player:AddFortPoints(100, "Map Completed")

		BroadCastMessage(player:GetName() .. " has Completed the Map!")
	end
end

finish2 = trigger_ff_script:new({})

function finish2:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		player:AddFortPoints(100, "Completed the Map")

		BroadCastMessage(player:GetName() .. " has Completed the Map!")
	end
end

------------------------------------------------------
--FLAGS -- taken from Concmap.lua by Public_Slots_Free
------------------------------------------------------

local flags  = { "red_flag", "blue_flag", "green_flag", "yellow_flag", "red_flag2", "blue_flag2", "green_flag2",
	"yellow_flag2" }

-----------------------------------------------------------------------------
-- entities
-----------------------------------------------------------------------------

-- hudalign and hudstatusiconalign : 0 = HUD_LEFT, 1 = HUD_RIGHT, 2 = HUD_CENTERLEFT, 3 = HUD_CENTERRIGHT
-- (pixels from the left / right of the screen / left of the center of the screen / right of center of screen,
-- AfterShock

blue_flag    = baseflag:new({
	team                 = Team.kBlue,
	modelskin            = 0,
	name                 = "Blue Flag",
	hudicon              = "hud_flag_blue_new.vtf",
	hudx                 = 5,
	hudy                 = 119,
	hudwidth             = 56,
	hudheight            = 56,
	hudalign             = 1,
	hudstatusicondropped = "hud_flag_dropped_blue.vtf",
	hudstatusiconhome    = "hud_flag_home_blue.vtf",
	hudstatusiconcarried = "hud_flag_carried_blue.vtf",
	hudstatusiconx       = 60,
	hudstatusicony       = 5,
	hudstatusiconw       = 15,
	hudstatusiconh       = 15,
	hudstatusiconalign   = 2,
	touchflags           = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kYellow, AllowFlags.kGreen,
		AllowFlags.kRed }
})

red_flag     = baseflag:new({
	team                 = Team.kRed,
	modelskin            = 1,
	name                 = "Red Flag",
	hudicon              = "hud_flag_red_new.vtf",
	hudx                 = 5,
	hudy                 = 119,
	hudwidth             = 56,
	hudheight            = 56,
	hudalign             = 1,
	hudstatusicondropped = "hud_flag_dropped_red.vtf",
	hudstatusiconhome    = "hud_flag_home_red.vtf",
	hudstatusiconcarried = "hud_flag_carried_red.vtf",
	hudstatusiconx       = 60,
	hudstatusicony       = 5,
	hudstatusiconw       = 15,
	hudstatusiconh       = 15,
	hudstatusiconalign   = 3,
	touchflags           = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kYellow, AllowFlags.kGreen,
		AllowFlags.kRed }
})

yellow_flag  = baseflag:new({
	team                 = Team.kYellow,
	modelskin            = 2,
	name                 = "Yellow Flag",
	hudicon              = "hud_flag_yellow_new.vtf",
	hudx                 = 5,
	hudy                 = 119,
	hudwidth             = 56,
	hudheight            = 56,
	hudalign             = 1,
	hudstatusicondropped = "hud_flag_dropped_yellow.vtf",
	hudstatusiconhome    = "hud_flag_home_yellow.vtf",
	hudstatusiconcarried = "hud_flag_carried_yellow.vtf",
	hudstatusiconx       = 53,
	hudstatusicony       = 25,
	hudstatusiconw       = 15,
	hudstatusiconh       = 15,
	hudstatusiconalign   = 2,
	touchflags           = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kYellow, AllowFlags.kGreen,
		AllowFlags.kRed }
})

green_flag   = baseflag:new({
	team                 = Team.kGreen,
	modelskin            = 3,
	name                 = "Green Flag",
	hudicon              = "hud_flag_green_new.vtf",
	hudx                 = 5,
	hudy                 = 119,
	hudwidth             = 56,
	hudheight            = 56,
	hudalign             = 1,
	hudstatusicondropped = "hud_flag_dropped_green.vtf",
	hudstatusiconhome    = "hud_flag_home_green.vtf",
	hudstatusiconcarried = "hud_flag_carried_green.vtf",
	hudstatusiconx       = 53,
	hudstatusicony       = 25,
	hudstatusiconw       = 15,
	hudstatusiconh       = 15,
	hudstatusiconalign   = 3,
	touchflags           = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kYellow, AllowFlags.kGreen,
		AllowFlags.kRed }
})

blue_flag2   = baseflag:new({
	team                 = Team.kBlue,
	modelskin            = 0,
	name                 = "Blue Flag",
	hudicon              = "hud_flag_blue_new.vtf",
	hudx                 = 5,
	hudy                 = 119,
	hudwidth             = 56,
	hudheight            = 56,
	hudalign             = 1,
	hudstatusicondropped = "hud_flag_dropped_blue.vtf",
	hudstatusiconhome    = "hud_flag_home_blue.vtf",
	hudstatusiconcarried = "hud_flag_carried_blue.vtf",
	hudstatusiconx       = 60,
	hudstatusicony       = 5,
	hudstatusiconw       = 15,
	hudstatusiconh       = 15,
	hudstatusiconalign   = 2,
	touchflags           = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kYellow, AllowFlags.kGreen,
		AllowFlags.kRed }
})

red_flag2    = baseflag:new({
	team                 = Team.kRed,
	modelskin            = 1,
	name                 = "Red Flag",
	hudicon              = "hud_flag_red_new.vtf",
	hudx                 = 5,
	hudy                 = 119,
	hudwidth             = 56,
	hudheight            = 56,
	hudalign             = 1,
	hudstatusicondropped = "hud_flag_dropped_red.vtf",
	hudstatusiconhome    = "hud_flag_home_red.vtf",
	hudstatusiconcarried = "hud_flag_carried_red.vtf",
	hudstatusiconx       = 60,
	hudstatusicony       = 5,
	hudstatusiconw       = 15,
	hudstatusiconh       = 15,
	hudstatusiconalign   = 3,
	touchflags           = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kYellow, AllowFlags.kGreen,
		AllowFlags.kRed }
})

yellow_flag2 = baseflag:new({
	team                 = Team.kYellow,
	modelskin            = 2,
	name                 = "Yellow Flag",
	hudicon              = "hud_flag_yellow_new.vtf",
	hudx                 = 5,
	hudy                 = 119,
	hudwidth             = 56,
	hudheight            = 56,
	hudalign             = 1,
	hudstatusicondropped = "hud_flag_dropped_yellow.vtf",
	hudstatusiconhome    = "hud_flag_home_yellow.vtf",
	hudstatusiconcarried = "hud_flag_carried_yellow.vtf",
	hudstatusiconx       = 53,
	hudstatusicony       = 25,
	hudstatusiconw       = 15,
	hudstatusiconh       = 15,
	hudstatusiconalign   = 2,
	touchflags           = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kYellow, AllowFlags.kGreen,
		AllowFlags.kRed }
})

green_flag2  = baseflag:new({
	team                 = Team.kGreen,
	modelskin            = 3,
	name                 = "Green Flag",
	hudicon              = "hud_flag_green_new.vtf",
	hudx                 = 5,
	hudy                 = 119,
	hudwidth             = 56,
	hudheight            = 56,
	hudalign             = 1,
	hudstatusicondropped = "hud_flag_dropped_green.vtf",
	hudstatusiconhome    = "hud_flag_home_green.vtf",
	hudstatusiconcarried = "hud_flag_carried_green.vtf",
	hudstatusiconx       = 53,
	hudstatusicony       = 25,
	hudstatusiconw       = 15,
	hudstatusiconh       = 15,
	hudstatusiconalign   = 3,
	touchflags           = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kYellow, AllowFlags.kGreen,
		AllowFlags.kRed }
})

-----------------------------------------------------------------------------
-- Flag (allows own team to get their flag)
-----------------------------------------------------------------------------

function baseflag:touch(touch_entity)
	local player = CastToPlayer(touch_entity)
	-- pickup if they can
	if self.notouch[player:GetId()] then return; end

	-- make sure they don't have any flags already
	for i, v in ipairs(flags) do
		if player:HasItem(v) then return end
	end

	-- let the teams know that the flag was picked up
	SmartSound(player, "yourteam.flagstolen", "yourteam.flagstolen", "otherteam.flagstolen")
	SmartSpeak(player, "CTF_YOUGOTFLAG", "CTF_GOTFLAG", "CTF_LOSTFLAG")
	SmartMessage(player, "#FF_YOUPICKUP", "#FF_TEAMPICKUP", "#FF_OTHERTEAMPICKUP")

	-- if the player is a spy, then force him to lose his disguise
	player:SetDisguisable(false)
	-- if the player is a spy, then force him to lose his cloak
	player:SetCloakable(false)

	-- note: this seems a bit backwards (Pickup verb fits Player better)
	local flag = CastToInfoScript(entity)
	flag:Pickup(player)
	AddHudIcon(player, self.hudicon, flag:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign)
	RemoveHudItemFromAll(flag:GetName() .. "_h")
	RemoveHudItemFromAll(flag:GetName() .. "_d")
	AddHudIconToAll(self.hudstatusiconhome, (flag:GetName() .. "_h"), self.hudstatusiconx, self.hudstatusicony,
		self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign)
	AddHudIconToAll(self.hudstatusiconcarried, (flag:GetName() .. "_c"), self.hudstatusiconx, self.hudstatusicony,
		self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign)

	-- 100 points for initial touch on flag
	if self.status == 0 then player:AddFortPoints(FORTPOINTS_PER_INITIALTOUCH, "#FF_FORTPOINTS_INITIALTOUCH") end
	self.status = 1
end

function baseflag:dropitemcmd() end

------------------
--No Fall Damage--
------------------

function player_ondamage(player, damageinfo)
	local attacker = damageinfo:GetAttacker()
	if damageinfo:GetDamageType() == 32 then
		damageinfo:SetDamage(0)
	end
end

------------------

function restock_all()
	local c = Collection()
	-- get all players
	c:GetByFilter({ CF.kPlayers })
	-- loop through all players
	for temp in c.items do
		local player = CastToPlayer(temp)
		if player then
			-- add ammo/health/armor/etc
			class = player:GetClass()
			if player:GetTeamId() == Team.kGreen then
				if player:GetClass() == Player.kScout then
					player:AddAmmo(Ammo.kGren2, 3)
					player:AddAmmo(Ammo.kShells, 50)
					player:AddAmmo(Ammo.kNails, 50)
				end
			end
		end
	end
end
