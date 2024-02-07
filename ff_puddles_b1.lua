-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------


IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_teamplay");
IncludeScript("base_location");
IncludeScript("base_respawnturret")



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
			[Player.kCivilian] = -1,
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
			[Player.kCivilian] = -1,
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
			[Player.kCivilian] = -1,
		},
	},
}

-----------------------------------------------------------------------------
-- startup
-----------------------------------------------------------------------------
function startup()
	SetGameDescription( "Capture the Flag" )
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
end

-----------------------------------------------------------------------------------------------------------------------------
-- door triggers
-----------------------------------------------------------------------------------------------------------------------------
blue_script_door_respawn_a = trigger_ff_script:new({ team = Team.kBlue })
function blue_script_door_respawn_a:allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function blue_script_door_respawn_a:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
    OutputEvent("blue_door_respawn_a", "Open")
   end
end

blue_script_door_respawn_b = trigger_ff_script:new({ team = Team.kBlue })
function blue_script_door_respawn_b:allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function blue_script_door_respawn_b:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
    OutputEvent("blue_door_respawn_b", "Open")
   end
end

red_script_door_respawn_a = trigger_ff_script:new({ team = Team.kRed })
function red_script_door_respawn_a:allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function red_script_door_respawn_a:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
    OutputEvent("red_door_respawn_a", "Open")
   end
end

red_script_door_respawn_b = trigger_ff_script:new({ team = Team.kRed })
function red_script_door_respawn_b:allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function red_script_door_respawn_b:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
    OutputEvent("red_door_respawn_b", "Open")
   end
end


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


red_pack = genericbackpack:new({
	grenades = 100,
	bullets = 100,
	nails = 100,
	shells = 100,
	rockets = 100,
	gren1 = 0,
	gren2 = 0,
	cells = 100,
	armor = 40,
	health = 30,
	respawntime = 16,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kRed},
	botgoaltype = Bot.kBackPack_Ammo
})

function red_pack:dropatspawn() return false end

red_grenpack = genericbackpack:new({
	grenades = 100,
	bullets = 100,
	nails = 100,
	shells = 100,
	rockets = 100,
	gren1 = 2,
	gren2 = 2,
	cells = 100,
	armor = 40,
	health = 30,
	respawntime = 16,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kRed},
	botgoaltype = Bot.kBackPack_Ammo
})

function red_grenpack:dropatspawn() return false end

blue_pack = genericbackpack:new({
	grenades = 100,
	bullets = 100,
	nails = 100,
	shells = 100,
	rockets = 100,
	gren1 = 0,
	gren2 = 0,
	cells = 100,
	armor = 40,
	health = 30,
	respawntime = 16,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kBlue},
	botgoaltype = Bot.kBackPack_Ammo
})

function blue_pack:dropatspawn() return false end

blue_grenpack = genericbackpack:new({
	grenades = 100,
	bullets = 100,
	nails = 100,
	shells = 100,
	rockets = 100,
	gren1 = 2,
	gren2 = 2,
	cells = 100,
	armor = 40,
	health = 30,
	respawntime = 16,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kBlue},
	botgoaltype = Bot.kBackPack_Ammo
})

function blue_grenpack:dropatspawn() return false end


-----------------------------------------------------------------------------
-- Clips on FlagSpawns
-----------------------------------------------------------------------------
clip_brush = trigger_ff_clip:new({ clipflags = 0 })

red_clip = clip_brush:new({ clipflags = {ClipFlags.kClipPlayersByTeam, ClipFlags.kClipTeamBlue, ClipFlags.kClipAllNonPlayers} })
blue_clip = clip_brush:new({ clipflags = {ClipFlags.kClipPlayersByTeam, ClipFlags.kClipTeamRed, ClipFlags.kClipAllNonPlayers} })

