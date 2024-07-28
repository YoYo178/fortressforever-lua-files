-----------------------------------------------------------------------------
-- base_quadhog.lua
-- by Alw1n (original creator of the map ff_hold and its lua)
--    -_YoYo178_- (creator of the map ff_qh_hold, which is based entirely on ff_hold)
-----------------------------------------------------------------------------
IncludeScript("base_teamplay")
IncludeScript("base_location")

-----------------------------------------------------------------------------
-- Settings
-----------------------------------------------------------------------------
-- Flag settings:
FLAG_THROW_SPEED        = 512 -- Initial speed of the flag when thrown
FLAG_RETURN_TIME        = 60  -- Time in seconds after the flag returns to the middle

-- Scoring settings:
PERIOD_TIME             = 10  -- Period in seconds to add scores for the quad hog and his team
POINTS_PER_PERIOD       = 1   -- Amount of score to add for the quad hog's team each PERIOD_TIME seconds.
HOLDER_POINTS           = 100 -- Amount of Fortress Points to add for the quad hog each PERIOD_TIME seconds.
TEAM_MEMBER_POINTS      = 50  -- Amount of Fortress Points to add for each of the quad hog's team members each PERIOD_TIME seconds.

-- Quad hog settings:
REGEN_TIME              = 1 -- Period in seconds to regenerate the quad hog inside the hold area. Amount is 5% - 10% of maximum health and armor depending on the number of players on the server.
DAMAGE_BONUS            = 4 -- Multiplies the quad hog's damage by DAMAGE_BONUS when holding the flag. 1 = Normal damage, 4 = Quad damage

-- Health bar settings:
HEALTH_BAR_ENABLED      = true

-----------------------------------------------------------------------------
-- Critical health bar variables, DO NOT TOUCH!!
-----------------------------------------------------------------------------

HEALTH_BAR_X            = 0
HEALTH_BAR_Y            = 35
HEALTH_BAR_WIDTH        = 250
HEALTH_BAR_HEIGHT       = 37
HEALTH_BAR_ALIGN        = 4

HEALTHBAR_HEALTH_X      = 0
HEALTHBAR_HEALTH_Y      = 40
HEALTHBAR_HEALTH_WIDTH  = 238
HEALTHBAR_HEALTH_HEIGHT = 15
HEALTHBAR_HEALTH_ALIGN  = 4

HEALTHBAR_ARMOR_X       = 0
HEALTHBAR_ARMOR_Y       = 54
HEALTHBAR_ARMOR_WIDTH   = 210
HEALTHBAR_ARMOR_HEIGHT  = 12
HEALTHBAR_ARMOR_ALIGN   = 4

-----------------------------------------------------------------------------
-- Global variables, don't touch
-----------------------------------------------------------------------------

-- Defines when the quad hog's regeneration is enabled
REGENERATING_ENABLED    = true

-- Define Teams
QUADHUNTERS_TEAM        = Team.kBlue
QUADHOG_TEAM            = Team.kRed

-- Used by `player_spawn` to determine when to start counting the timer to open the barriers.
FIRST_PLAYER_JOIN       = false

-- Stores casted player object of the Quad Hog.
-- and is nil when the Quad Hog dies.
QH                      = nil

-----------------------------------------------------------------------------
-- Set Team name, Player limit, name, etc.
-----------------------------------------------------------------------------
function startup()
	SetTeamName(QUADHUNTERS_TEAM, "Quad Hunters")
	SetTeamName(QUADHOG_TEAM, "Quad Hog")

	-- Set up team limits on each team
	SetPlayerLimit(QUADHUNTERS_TEAM, 0)
	SetPlayerLimit(QUADHOG_TEAM, -1)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	-- Blue are Quad Hunters
	local team = GetTeam(QUADHUNTERS_TEAM)
	for i = Player.kScout, Player.kCivilian, 1 do
		if (i == Player.kCivilian) then
			team:SetClassLimit(i, -1)
		else
			team:SetClassLimit(i, 0)
		end
	end

	-- Red is Quad Hog
	team = GetTeam(QUADHOG_TEAM)
	for i = Player.kScout, Player.kCivilian, 1 do
		if (i == Player.kCivilian) then
			team:SetClassLimit(i, -1)
		else
			team:SetClassLimit(i, 0)
		end
	end
end

function blue_barriers_reset()
	OutputEvent("blue_barriers", "Enable")
	AddSchedule("blue_barriers_disable", 12.5, blue_barriers_disable)
	AddSchedule("blue_barriers_10secwarn", 2.5, blue_barriers_10secwarn)
end

function blue_barriers_disable()
	OutputEvent("blue_barriers", "Disable")
	BroadCastMessage("#FF_ROUND_STARTED")
	BroadCastSound("otherteam.flagstolen")
	PickQuadHog()
end

function blue_barriers_10secwarn()
	BroadCastMessage("#FF_MAP_10SECWARN")
	AddSchedule("blue_barriers_9secwarn", 1, blue_barriers_9secwarn)
end

function blue_barriers_9secwarn()
	BroadCastMessage("#FF_MAP_9SECWARN")
	AddSchedule("blue_barriers_8secwarn", 1, blue_barriers_8secwarn)
end

function blue_barriers_8secwarn()
	BroadCastMessage("#FF_MAP_8SECWARN")
	AddSchedule("blue_barriers_7secwarn", 1, blue_barriers_7secwarn)
end

function blue_barriers_7secwarn()
	BroadCastMessage("#FF_MAP_7SECWARN")
	AddSchedule("blue_barriers_6secwarn", 1, blue_barriers_6secwarn)
end

function blue_barriers_6secwarn()
	BroadCastMessage("#FF_MAP_6SECWARN")
	AddSchedule("blue_barriers_5secwarn", 1, blue_barriers_5secwarn)
end

function blue_barriers_5secwarn()
	BroadCastMessage("#FF_MAP_5SECWARN")
	SpeakAll("AD_5SEC")
	AddSchedule("blue_barriers_4secwarn", 1, blue_barriers_4secwarn)
end

function blue_barriers_4secwarn()
	BroadCastMessage("#FF_MAP_4SECWARN")
	SpeakAll("AD_4SEC")
	AddSchedule("blue_barriers_3secwarn", 1, blue_barriers_3secwarn)
end

function blue_barriers_3secwarn()
	BroadCastMessage("#FF_MAP_3SECWARN")
	SpeakAll("AD_3SEC")
	AddSchedule("blue_barriers_2secwarn", 1, blue_barriers_2secwarn)
end

function blue_barriers_2secwarn()
	BroadCastMessage("#FF_MAP_2SECWARN")
	SpeakAll("AD_2SEC")
	AddSchedule("blue_barriers_1secwarn", 1, blue_barriers_1secwarn)
end

function blue_barriers_1secwarn()
	BroadCastMessage("#FF_MAP_1SECWARN")
	SpeakAll("AD_1SEC")
end

-----------------------------------------------------------------------------
-- Damage event - Add Quad Damage
-----------------------------------------------------------------------------
function player_ondamage(player, damageinfo)
	if not damageinfo then return end

	--- Entity that is attacking. Can be a player, a sentrygun, a dispenser, etc
	local attacker = damageinfo:GetAttacker()

	local cast_atk = nil

	-- If the attacker isn't nil and is a player
	if attacker and IsPlayer(attacker) then
		cast_atk = CastToPlayer(attacker)

		-- If the attacker is the quadhog, not damaging himself,
		if cast_atk:GetTeamId() == QUADHOG_TEAM and player:GetId() ~= cast_atk:GetId() then
			-- multiply damage
			damageinfo:SetDamage(damageinfo:GetDamage() * DAMAGE_BONUS)
		end
		return
		-- If attacker is a sentry gun or dispenser
	elseif attacker and IsSentrygun(attacker) then
		cast_atk = CastToSentrygun(attacker)
	elseif attacker and IsDispenser(attacker) then
		cast_atk = CastToDispenser(attacker)
	end

	if not cast_atk then return end

	-- If the attacker is the quadhog, not damaging himself
	if cast_atk:GetOwner():GetTeamId() == QUADHOG_TEAM and player:GetId() ~= cast_atk:GetOwner():GetId() then
		-- multiply damage
		damageinfo:SetDamage(damageinfo:GetDamage() * DAMAGE_BONUS)
	end
	
	-- if the quadhog takes damage, update the health bar
	if player:GetTeamId() == QUADHOG_TEAM then
		UpdateHealthBar()
	end
end

-----------------------------------------------------------------------------
-- Restore quad hog's vaporisation timer on kill
-----------------------------------------------------------------------------
---@param player_killed Player
---@param damageinfo DamageInfo
function player_killed(player_killed, damageinfo)
	-- if no damageinfo do nothing
	if not damageinfo then return end

	local attacker = damageinfo:GetAttacker()
	local castedAttacker = nil

	-- if blue player dies, set respawnable to true, in case it's false
	if (player_killed:GetTeamId() == QUADHUNTERS_TEAM) then player_killed:SetRespawnable(true) end

	-- if red player dies, respawn him on the blue team.
	if (player_killed:GetTeamId() == QUADHOG_TEAM) then
		BroadCastMessageToPlayer(player_killed, "You will automatically respawn in 2 seconds, Please wait...")
		RespawnQuadHog()
	end

	if (IsPlayer(attacker)) then
		castedAttacker = CastToPlayer(attacker)

		-- if it was a team kill (unlikely), do nothing
		if castedAttacker:GetTeamId() == player_killed:GetTeamId() then return end

		-- if attacker and player are both on different teams and the attacker is the Quad Hog, reset the timers on the hud
		if castedAttacker:GetTeamId() ~= player_killed:GetTeamId() and castedAttacker:GetTeamId() == QUADHOG_TEAM then
			ResetQuadHogTimer()
			local PlayersCollection = Collection()
			PlayersCollection:GetByFilter({ CF.kPlayers, CF.kTeamBlue })
			for p in PlayersCollection.items do ResetBlueTimer(CastToPlayer(p)) end
		end
	end
end

function player_onkill(player_entity)
	local p = CastToPlayer(player_entity)

	-- quad hog can't just suicide, coward
	if (p:GetTeamId() == QUADHOG_TEAM) then return EVENT_DISALLOWED end
	return EVENT_ALLOWED
end

function player_switchclass(player_entity)
	local p = CastToPlayer(player_entity)

	if (p:GetTeamId() == QUADHOG_TEAM) then return EVENT_DISALLOWED end
	return EVENT_ALLOWED
end

function player_switchteam(player_entity)
	local p = CastToPlayer(player_entity)

	if (p:GetTeamId() == QUADHOG_TEAM) then return EVENT_DISALLOWED end
	return EVENT_ALLOWED
end

-----------------------------------------------------------------------------
-- Resupply and Set Team Objective
-----------------------------------------------------------------------------
function player_spawn(player_entity)
	if not FIRST_PLAYER_JOIN then
		FIRST_PLAYER_JOIN = true
		blue_barriers_reset()
	end

	local player = CastToPlayer(player_entity)

	player:AddHealth(100)
	player:AddArmor(300)

	player:AddAmmo(Ammo.kNails, 400)
	player:AddAmmo(Ammo.kShells, 400)
	player:AddAmmo(Ammo.kRockets, 400)
	player:AddAmmo(Ammo.kCells, 400)
	player:AddAmmo(Ammo.kDetpack, 1)

	if player:GetTeamId() == QUADHUNTERS_TEAM then
		UpdateTeamObjectiveIcon(GetTeam(QUADHUNTERS_TEAM), GetEntityByName("flag"))
	end
	if player:GetTeamId() == QUADHOG_TEAM then
		UpdateTeamObjectiveIcon(GetTeam(QUADHOG_TEAM), nil)
	end
end

-----------------------------------------------------------------------------
-- baseflag
-----------------------------------------------------------------------------
basequadflag = baseflag:new({})

function basequadflag:spawn()
	self.notouch = {}
	info_ff_script.spawn(self)
end

function basequadflag:touch(touch_entity)
	local player = CastToPlayer(touch_entity)

	-- if they can't pickup, do nothing
	if self.notouch[player:GetId()] then return; end

	-- move them to red, they're now the Quad Hog
	ApplyToPlayer(player, { AT.kChangeTeamRed })

	-- Start counting scores
	AddScheduleRepeating("addpoints", PERIOD_TIME, addpoints, player)

	-- just start regenerating
	REGENERATING_ENABLED = true
	AddScheduleRepeating("regen_holder", REGEN_TIME, regenerate_holder, player)

	-- we don't want the flag to return anymore
	RemoveSchedule("returnflag")

	-- spies can't cloak, nor disguise
	player:SetDisguisable(false)
	player:SetCloakable(false)

	-- Give the flag to the player
	local flag = CastToInfoScript(entity)
	flag:Pickup(player)

	-- start displaying health bar to Quad Hunters
	DisplayHealthBar()

	-- QH SHOULD NOT BE NIL WHEN HEALTH BAR UPDATE SCHEDULE IS ACTIVE
	QH = player

	-- Broadcast a message to the Quad Hog and Set Quad Hog's Timer
	SmartMessage(player, "You are the Quad Hog! Defend yourself from the Quad Hunters!", "", player:GetName() .. " has become the Quad Hog!")

	-- Play "Quad Damage" sound effect
	OutputEvent("broadcast-quad-damage", "PlaySound") -- "Quad Damage!"
	OutputEvent("broadcast-quad-damage2", "PlaySound") -- "BWAAAAA"

	UpdateTeamObjectiveIcon(GetTeam(QUADHOG_TEAM), nil)
	StartQuadHogTimer()

	local PlayersCollection = Collection()
	PlayersCollection:GetByFilter({ CF.kPlayers, CF.kTeamBlue })
	for p in PlayersCollection.items do AddBlueTimer(CastToPlayer(p)) end
end

function basequadflag:onownerdie()
	-- drop the flag
	local flag = CastToInfoScript(entity)
	flag:Drop(-1, 0.0)
	BroadCastMessage("The Quad Hog died.")

	RemoveSchedule("regen_holder")
	RemoveSchedule("addpoints")

	AddSchedule("returnflag", FLAG_RETURN_TIME, returnflag)

	RemoveQuadHogTimer()
	RemoveHealthBar()

	local PlayersCollection = Collection()
	PlayersCollection:GetByFilter({ CF.kPlayers, CF.kTeamBlue })
	for p in PlayersCollection.items do RemoveBlueTimer(CastToPlayer(p)) end
end

function basequadflag:dropitemcmd() return EVENT_DISALLOWED end

function basequadflag:ondrop() end

function basequadflag:onloseitem() end

function basequadflag:onownerforcerespawn() end

function basequadflag:onreturn() RemoveSchedule("returnflag") end

function basequadflag:hasanimation() return true end

-- Define the flag
flag = basequadflag:new({
	modelskin = 3, -- 0: Blue, 1: Red, 2: Yellow, 3: Green -- Green skin is replaced by a custom texture using bspzip.
})

-----------------------------------------------------------------------------
-- extended backpack
-----------------------------------------------------------------------------
qhgenerickit = genericbackpack:new({
	health = 100,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	respawntime = 5,
	touchsound = "HealthKit.Touch",
	botgoaltype = Bot.kBackPack_Health
})

function qhgenerickit:touch( input_player )
	genericbackpack.touch( self, input_player )
	
	local player = CastToPlayer( input_player )
	if player:GetTeamId() == QUADHOG_TEAM then UpdateHealthBar() end
end

-----------------------------------------------------------------------------
-- timed functions
-----------------------------------------------------------------------------
function addpoints(player_entity)
	-- Add score for the quad hog
	local flagholder = CastToPlayer(player_entity)
	local team = flagholder:GetTeam()
	team:AddScore(POINTS_PER_PERIOD)
	flagholder:AddFortPoints(HOLDER_POINTS)
end

function regenerate_holder(player_entity)
	if (REGENERATING_ENABLED) then
		local player = CastToPlayer(player_entity)
		-- Regeneration 5.50% with 1 players and 10% with 20 players, linear scaling
		player:AddHealth(player:GetMaxHealth() * (5 + 0.50 * NumPlayers()) / 100)
		player:AddArmor(player:GetMaxArmor() * (5 + 0.50 * NumPlayers()) / 100)
		UpdateHealthBar()
	end
end

-- This is called when the flag return timer finishes.
-- The flag is returned to the start location.
function returnflag()
	local flag = GetInfoScriptByName("flag")

	flag:Return()

	-- Set the flag entity's parent to the invisible func_rotating at the middle of the map so the flag starts rotating again
	OutputEvent("flag", "SetParent", "flagrotator")

	-- Let the players know that the flag has returned.
	BroadCastMessage("The flag has returned to the middle.")
	OutputEvent("broadcast-flag-returned", "PlaySound") -- "The flag has returned"

	-- Stop counting scores and regenerating the holder
	RemoveSchedule("addpoints")
	RemoveSchedule("regen_holder")
	REGENERATING_ENABLED = false
end

function StartQuadHogTimer()
	if not QH then return end

	AddSchedule("killqh", 60, RespawnQuadHog)
	AddTimer("qhtimer", 60, -1)
	AddHudTimer(QH, "hud_qhtimer", "qhtimer", 0, 70, 4, 0, 5)
	AddHudText(QH, "qhtext", string.format("Time until Vaporisation:"), -65, 80, 4)
end

function RemoveQuadHogTimer()
	if not QH then return end

	RemoveSchedule("killqh")
	RemoveHudItem(QH, "hud_qhtimer")
	RemoveHudItem(QH, "qhtext")
	RemoveTimer("qhtimer")
end

function ResetQuadHogTimer()
	if not QH then return end

	RemoveSchedule("killqh")
	RemoveHudItem(QH, "hud_qhtimer")
	RemoveHudItem(QH, "qhtext")
	RemoveTimer("qhtimer")

	AddSchedule("killqh", 60, RespawnQuadHog)
	AddTimer("qhtimer", 60, -1)
	AddHudTimer(QH, "hud_qhtimer", "qhtimer", 0, 70, 4, 0, 5)
	AddHudText(QH, "qhtext", string.format("Time until Vaporisation:"), -65, 80, 4)
end

function AddBlueTimer(player_entity)
	local player = CastToPlayer(player_entity)

	AddTimer("bluetimer", 60, -1)
	AddHudTimer(player, "hud_bluetimer", "bluetimer", 0, 70, 4, 0, 5)
	AddHudText(player, "bluetext", string.format("Time until Quad Hog's Death:"), -80, 80, 4)
end

function RemoveBlueTimer(player_entity)
	local player = CastToPlayer(player_entity)

	RemoveHudItem(player, "hud_bluetimer")
	RemoveHudItem(player, "bluetext")
	RemoveTimer("bluetimer")
end

function ResetBlueTimer(player_entity)
	local player = CastToPlayer(player_entity)

	RemoveHudItem(player, "hud_bluetimer")
	RemoveHudItem(player, "bluetext")
	RemoveTimer("bluetimer")

	AddTimer("bluetimer", 60, -1)
	AddHudTimer(player, "hud_bluetimer", "bluetimer", 0, 70, 4, 0, 5)
	AddHudText(player, "bluetext", string.format("Time until Quad Hog's Death:"), -80, 80, 4)
end

function DisplayHealthBar()
	if not HEALTH_BAR_ENABLED then return end
	if not QH then return end

	local PlayersCollection = Collection()
	PlayersCollection:GetByFilter({ CF.kPlayers, CF.kTeamBlue })

	for p in PlayersCollection.items do
		local player = CastToPlayer(p)

		local healthWidth = ((HEALTHBAR_HEALTH_WIDTH * ((QH:GetHealth() * 100) / QH:GetMaxHealth())) / 100) or 1 -- make sure it's not zero or below
		local armorWidth = ((HEALTHBAR_ARMOR_WIDTH * ((QH:GetArmor() * 100) / QH:GetMaxArmor())) / 100) or 1 -- make sure it's not zero or below

		AddHudIcon(player, "ff_qh_hold_healthbar-health.vtf", "qhHealthBarHealth", HEALTHBAR_HEALTH_X, HEALTHBAR_HEALTH_Y, healthWidth, HEALTHBAR_HEALTH_HEIGHT, HEALTHBAR_HEALTH_ALIGN)

		AddHudIcon(player, "ff_qh_hold_healthbar-armor.vtf", "qhHealthBarArmor", HEALTHBAR_ARMOR_X, HEALTHBAR_ARMOR_Y, armorWidth, HEALTHBAR_ARMOR_HEIGHT, HEALTHBAR_ARMOR_ALIGN)

		AddHudIcon(player, "ff_qh_hold_healthbar2.vtf", "qhHealthBar", HEALTH_BAR_X, HEALTH_BAR_Y, HEALTH_BAR_WIDTH, HEALTH_BAR_HEIGHT, HEALTH_BAR_ALIGN)
	end
end

function UpdateHealthBar()
	if not HEALTH_BAR_ENABLED then return end
	if not QH then return end

	RemoveHudItemFromAll("qhHealthBarHealth")
	RemoveHudItemFromAll("qhHealthBarArmor")
	RemoveHudItemFromAll("qhHealthBar")

	local PlayersCollection = Collection()
	PlayersCollection:GetByFilter({ CF.kPlayers, CF.kTeamBlue })

	for p in PlayersCollection.items do
		local player = CastToPlayer(p)

		local healthWidth = ((HEALTHBAR_HEALTH_WIDTH * ((QH:GetHealth() * 100) / QH:GetMaxHealth())) / 100) or 1 -- make sure it's not zero or below
		local armorWidth = ((HEALTHBAR_ARMOR_WIDTH * ((QH:GetArmor() * 100) / QH:GetMaxArmor())) / 100) or 1 -- make sure it's not zero or below

		AddHudIcon(player, "ff_qh_hold_healthbar-health.vtf", "qhHealthBarHealth", HEALTHBAR_HEALTH_X, HEALTHBAR_HEALTH_Y, healthWidth, HEALTHBAR_HEALTH_HEIGHT, HEALTHBAR_HEALTH_ALIGN)

		AddHudIcon(player, "ff_qh_hold_healthbar-armor.vtf", "qhHealthBarArmor", HEALTHBAR_ARMOR_X, HEALTHBAR_ARMOR_Y, armorWidth, HEALTHBAR_ARMOR_HEIGHT, HEALTHBAR_ARMOR_ALIGN)

		AddHudIcon(player, "ff_qh_hold_healthbar2.vtf", "qhHealthBar", HEALTH_BAR_X, HEALTH_BAR_Y, HEALTH_BAR_WIDTH, HEALTH_BAR_HEIGHT, HEALTH_BAR_ALIGN)
	end
end

function RemoveHealthBar()
	if not HEALTH_BAR_ENABLED then return end

	RemoveHudItemFromAll("qhHealthBarHealth")
	RemoveHudItemFromAll("qhHealthBarArmor")
	RemoveHudItemFromAll("qhHealthBar")
end

function RespawnQuadHog()
	if not QH then return end

	-- We deny the player to randomly respawn on input
	QH:SetRespawnable(false)

	-- Remove Health Bar
	RemoveHealthBar()

	-- If the Quad Hog is alive, we kill it
	if QH:IsAlive() then ApplyToPlayer(QH, { AT.kKillPlayers }) end

	-- Shift the Quad Hog to blue team after a second (so it doesn't count as a team kill)
	AddSchedule("changeqhteamtoblue", 1, ApplyToPlayer, QH, { AT.kChangeTeamBlue })

	-- Respawn the (late) Quad Hog after 2 seconds (so a blue player doesn't spawn on the middle of the map, i.e, the red spawn)
	AddSchedule("respawnqhinblue", 2, ApplyToPlayer, QH, { AT.kRespawnPlayers })
end

function PickQuadHog()
	-- Create a collection
	local PlayersCollection = Collection()

	-- Get players from blue team
	PlayersCollection:GetByFilter({ CF.kPlayers, CF.kTeamBlue })

	-- Pick a random player from the blue team as the Quad Hog
	QH = CastToPlayer(PlayersCollection.entities[math.random(1, #PlayersCollection.entities)])

	-- If still no Quad Hog was assigned, something went wrong
	if not QH then return end

	-- If the picked player is alive, then we kill it (idk, to make it look cooler or something rofl)
	if QH:IsAlive() then ApplyToPlayer(QH, { AT.kKillPlayers }) end

	-- We deny the player to randomly respawn on input
	QH:SetRespawnable(false)

	-- We change the Quad Hog's team to Red and respawn it after a second (so it doesn't respawn in the blue spawn).
	ApplyToPlayer(QH, { AT.kChangeTeamRed })
	AddSchedule("respawnselectedqh", 1, ApplyToPlayer, QH, { AT.kRespawnPlayers })
end

-----------------------------------------------------------------------------
-- Respawn force shields - trigger_ff_clip
-- Completely prevents players from other teams entering the respawn rooms. Also blocks their projectiles, but not grenades, rockets, pipes etc.
-- To get this working you need to modify the trigger_ff_clip brush in Hammer somehow by changing its entity type or something before changing it back to trigger_ff_clip.
-- i got this working by accident so i still have no idea how to do it properly.
-----------------------------------------------------------------------------

-- We need three of these at every respawn door. Red door has blue, yellow and green, and so on. One entity can be used to block only on team (as far as i know). If we add more clipflags, it blocks nothing.
bluerespawnshield = trigger_ff_clip:new({
	clipflags = { ClipFlags.kClipPlayersByTeam, ClipFlags.kClipTeamRed, ClipFlags.kClipTeamYellow, ClipFlags.kClipTeamGreen, ClipFlags.kClipAllNonPlayers }
}) -- Blocks blue team

-- Stops projectiles and explosives. Also blocks all players for some reason. Used at the flag stand to block explosion decals from messing the model up.
blockdamage = trigger_ff_clip:new({ clipflags = { ClipFlags.kClipProjectiles, ClipFlags.kClipGrenades } })

-----------------------------------------------------------------------------
-- Respawn force shields - trigger_remove
-- These will make all grenades, pipes, rockets etc. disappear when fired at a force field.
-- The allowed function for these entities is very important. If a trigger_remove tries to remove a player, the server will crash.
-----------------------------------------------------------------------------

forcefield_remover = trigger_ff_script:new({})

-- Prevents the trigger_remove from removing players, sentryguns or dispensers (not that you could even build them there, but just in case).
function forcefield_remover:allowed(allowed_entity)
	if IsPlayer(allowed_entity) or IsBuildable(allowed_entity) then return EVENT_DISALLOWED end
	return EVENT_ALLOWED
end
