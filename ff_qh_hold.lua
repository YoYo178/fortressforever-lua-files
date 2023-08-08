-----------------------------------------------------------------------------
-- ff_qh_hold.lua
-- version: 1.0
-- Author: A1win
-- Editor: -_YoYo178_-
-- (Full credit to the main author A1win for creating this epic map!)
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay")
IncludeScript("base_location")

-----------------------------------------------------------------------------
-- Settings
-----------------------------------------------------------------------------
-- Flag settings:
FLAG_THROW_SPEED = 512 	-- Initial speed of the flag when thrown
FLAG_RETURN_TIME = 60 	-- Time in seconds after the flag returns to the middle

-- Scoring settings:
PERIOD_TIME = 10 		-- Period in seconds to add scores for the flag holder and his team
POINTS_PER_PERIOD = 1 	-- Amount of score to add for the flag holder's team each PERIOD_TIME seconds.
HOLDER_POINTS = 100 	-- Amount of Fortress Points to add for the flag holder each PERIOD_TIME seconds.
TEAM_MEMBER_POINTS = 50 -- Amount of Fortress Points to add for each of the flag holder's team members each PERIOD_TIME seconds.

-- Flag holder settings:
REGEN_TIME = 1 			-- Period in seconds to regenerate the flag holder inside the hold area. Amount is 5% - 10% of maximum health and armor depending on the number of players on the server.
DAMAGE_BONUS = 4 		-- Multiplies the flag holder's damage by DAMAGE_BONUS when holding the flag. 1 = Normal damage, 4 = Quad damage

-----------------------------------------------------------------------------
-- Global variables, don't touch
-----------------------------------------------------------------------------
-- Defines when the flag holder's regeneration is enabled
REGENERATING_ENABLED = true

-- Define Teams

REBELLIONS_TEAM = Team.kBlue
QUADHOG_TEAM = Team.kRed

-- Player Info Variables
PLAYER_CONNECTED_COUNT = 0
PLAYER_ARRAY = {}
QH = nil

-----------------------------------------------------------------------------
-- Set Team name, Player limit, name, etc.
-----------------------------------------------------------------------------
function startup()
	SetTeamName( REBELLIONS_TEAM, "Quad Hunters" )
	SetTeamName( QUADHOG_TEAM, "Quad Hog" )
	
	-- Set up team limits on each team
	SetPlayerLimit(REBELLIONS_TEAM, 0)
	SetPlayerLimit(QUADHOG_TEAM, -1)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)
	-- Blue are Quad Hunters
	local team = GetTeam( REBELLIONS_TEAM )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	-- Blue is scared
	local team = GetTeam( QUADHOG_TEAM )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	
	--AddSchedule("selectrandomquadhog", 10, selectRandomqh)
	blue_barriers_reset()
end

function blue_barriers_reset()
	OutputEvent( "blue_barriers", "Enable" )
	AddSchedule("blue_barriers_disable", 12.5, blue_barriers_disable )
	AddSchedule("blue_barriers_10secwarn", 2.5, blue_barriers_10secwarn )
end

function blue_barriers_disable()
	OutputEvent( "blue_barriers", "Disable" )
	BroadCastMessage("#FF_ROUND_STARTED")
	BroadCastSound("otherteam.flagstolen")
	selectRandomqh()
end

function blue_barriers_10secwarn()
	BroadCastMessage("#FF_MAP_10SECWARN")
	AddSchedule("blue_barriers_9secwarn", 1, blue_barriers_9secwarn )
end

function blue_barriers_9secwarn()
	BroadCastMessage("#FF_MAP_9SECWARN")
	AddSchedule("blue_barriers_8secwarn", 1, blue_barriers_8secwarn )
end

function blue_barriers_8secwarn()
	BroadCastMessage("#FF_MAP_8SECWARN")
	AddSchedule("blue_barriers_7secwarn", 1, blue_barriers_7secwarn )
end

function blue_barriers_7secwarn()
	BroadCastMessage("#FF_MAP_7SECWARN")
	AddSchedule("blue_barriers_6secwarn", 1, blue_barriers_6secwarn )
end

function blue_barriers_6secwarn()
	BroadCastMessage("#FF_MAP_6SECWARN")
	AddSchedule("blue_barriers_5secwarn", 1, blue_barriers_5secwarn )
end

function blue_barriers_5secwarn()
	BroadCastMessage("#FF_MAP_5SECWARN")
	SpeakAll( "AD_5SEC" )
	AddSchedule("blue_barriers_4secwarn", 1, blue_barriers_4secwarn )
end

function blue_barriers_4secwarn()
	BroadCastMessage("#FF_MAP_4SECWARN")
	SpeakAll( "AD_4SEC" )
	AddSchedule("blue_barriers_3secwarn", 1, blue_barriers_3secwarn )
end

function blue_barriers_3secwarn()
	BroadCastMessage("#FF_MAP_3SECWARN")
	SpeakAll( "AD_3SEC" )
	AddSchedule("blue_barriers_2secwarn", 1, blue_barriers_2secwarn )
end

function blue_barriers_2secwarn()
	BroadCastMessage("#FF_MAP_2SECWARN")
	SpeakAll( "AD_2SEC" )
	AddSchedule("blue_barriers_1secwarn", 1, blue_barriers_1secwarn )
end

function blue_barriers_1secwarn()
	BroadCastMessage("#FF_MAP_1SECWARN")
	SpeakAll( "AD_1SEC" )
end
-----------------------------------------------------------------------------
-- Damage event - Add Quad Damage
-----------------------------------------------------------------------------
function player_ondamage( player, damageInfo )

	-- If the flagholder isn't on the hold area do nothing
	if not REGENERATING_ENABLED then return end

	-- Entity that is attacking
	local attacker = damageInfo:GetAttacker()

	-- If no attacker do nothing
	if not attacker then return end

	-- If attacker is a player
	if IsPlayer(attacker) then
	
		local playerAttacker = CastToPlayer(attacker)
	
		-- If player isn't carrying the flag do nothing
		if not playerAttacker:HasItem("flag") then return end
		
		-- If player is damaging self do nothing
		if player:GetId() == playerAttacker:GetId() then return end
		
		-- If all conditions are true, increase player's damage to 400% - Quad Damage
		damageInfo:SetDamage(damageInfo:GetDamage() * DAMAGE_BONUS)
    end

	-- If attacker is a sentry gun or dispenser
	local playerAttacker = nil
	if IsSentrygun(attacker) then
		playerAttacker = CastToSentrygun(attacker)
	elseif IsDispenser(attacker) then
		playerAttacker = CastToDispenser(attacker)
	else return
	end

	-- If owner isn't carrying the flag do nothing
	if not playerAttacker:GetOwner():HasItem("flag") then return end

	-- If owner is damaging self do nothing
	if player:GetId() == playerAttacker:GetOwner():GetId() then return end
	
	-- If all conditions are true, increase sentry gun's or dispenser's damage to 400% - Quad Damage
	damageInfo:SetDamage(damageInfo:GetDamage() * DAMAGE_BONUS)
		

end

-- Restore Quad Hog's Vaporisation Timer

function player_killed( player_killed, damageinfo )
	-- if no damageinfo do nothing
	if not damageinfo then return end

	local attacker = damageinfo:GetAttacker()
	local inflictor = damageinfo:GetInflictor()
	local attackerplayer = CastToPlayer(attacker)

	if IsPlayer( attacker ) then
		if attacker:GetTeamId() == player_killed:GetTeamId() then return end
		if attacker:GetTeamId() ~= player_killed:GetTeamId() then
			if attacker:GetTeamId() == 3 then
				if attackerplayer:HasItem( "flag" ) then
					RemoveSchedule("killqh")
					AddSchedule( "killqh", 60, killqh, attackerplayer)
					RemoveTimer( "qhtimer" )
					qhTimerReset( attacker )
					for i = 1,PLAYER_CONNECTED_COUNT
					do
						if PLAYER_ARRAY[i]:GetTeamId() == 2 then
							blueTimerReset( PLAYER_ARRAY[i] )
						end
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------
-- Store player info in a array
-----------------------------------------------------------------------------
function player_connected( player_entity )
	PLAYER_CONNECTED_COUNT = PLAYER_CONNECTED_COUNT + 1
	local player = CastToPlayer( player_entity )
	for i = PLAYER_CONNECTED_COUNT,22 do
		PLAYER_ARRAY[i] = player
		break
	end
end

function player_disconnected( player_entity )
	ConsoleToAll("lmao you gay loloxod")
end
-----------------------------------------------------------------------------
-- Resupply and Set Team Objective
-----------------------------------------------------------------------------

function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	
	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:AddAmmo( Ammo.kDetpack, 1 )

	if player:GetTeamId() == Team.kBlue then
		UpdateTeamObjectiveIcon( GetTeam( Team.kBlue ), GetEntityByName( "flag" ) )
	end
	if player:GetTeamId() == Team.kRed then
		UpdateTeamObjectiveIcon( GetTeam( Team.kRed ), nil )
	end
end

-- Respawn Room:

holdbasekit = genericbackpack:new({
	health = 100,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	respawntime = 5,
	touchsound = "HealthKit.Touch",
	botgoaltype = Bot.kBackPack_Health
})

function holdbasekit:dropatspawn() return false end

holdarmorkit = genericbackpack:new({
	armor = 200,
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",
	respawntime = 5,
	touchsound = "ArmorKit.Touch",
	botgoaltype = Bot.kBackPack_Armor
})

function holdarmorkit:dropatspawn() return false end

blue_holdarmorkit = holdarmorkit:new({ modelskin = 0 })
red_holdarmorkit = holdarmorkit:new({ modelskin = 1 })
yellow_holdarmorkit = holdarmorkit:new({ modelskin = 3 })
green_holdarmorkit = holdarmorkit:new({ modelskin = 2 })

holdbasepack = genericbackpack:new({
	grenades = 200,
	bullets = 200,
	nails = 200,
	shells = 200,
	rockets = 200,
	cells = 200,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	respawntime = 5,
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function holdbasepack:dropatspawn() return false end

-- Outdoors:

-- Healthkits are located at the basements of the four small buildings at the corners of the Hold Area
holdhealthkit = genericbackpack:new({
	health = 50,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	respawntime = 20,
	touchsound = "HealthKit.Touch",
	botgoaltype = Bot.kBackPack_Health
})

function holdhealthkit:dropatspawn() return false end

-- Ammo packs are located inside the four small buildings at the corners of the Hold Area
holdammopack = genericbackpack:new({
	armor = 50,
	grenades = 20,
	bullets = 100,
	nails = 100,
	shells = 100,
	rockets = 20,
	cells = 100,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	respawntime = 20,
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function holdammopack:dropatspawn() return false end

-- Grenade packs are located under the water at the middle of the map.
holdgrenpack = genericbackpack:new({
	grenades = 10,
	bullets = 50,
	nails = 50,
	shells = 50,
	rockets = 5,
	cells = 50,
	gren1 = 1,
	gren2 = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	respawntime = 30,
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function holdgrenpack:dropatspawn() return false end

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------
location_water = location_info:new({ text = "Water", team = Team.kUnassigned })

location_tower_blue = location_info:new({ text = "Blue Tower", team = Team.kBlue })
location_trench_blue = location_info:new({ text = "Trench", team = Team.kBlue })
location_ramp_blue = location_info:new({ text = "Ramp", team = Team.kBlue })
location_pipe_blue = location_info:new({ text = "Water Access", team = Team.kBlue })
location_base_blue = location_info:new({ text = "Blue Base", team = Team.kBlue })
location_balcony_blue = location_info:new({ text = "Balcony", team = Team.kBlue })
location_respawn_blue = location_info:new({ text = "Respawn Room", team = Team.kBlue })

location_qharena = location_info:new({ text = "Quad Hog's Arena", team = Team.kRed })

-----------------------------------------------------------------------------
-- baseflag
-----------------------------------------------------------------------------
baseflag = info_ff_script:new({
	name = "base flag",
	team = 0,
	model = "models/flag/flag.mdl",
	modelskin = 3, -- 0: Blue, 1: Red, 2: Yellow, 3: Green -- Green skin is replaced by a custom texture using bspzip.
	tosssound = "Flag.Toss",
	dropnotouchtime = 2,
	capnotouchtime = 2,	
	hudicon = "hud_flag_neutral", -- Custom hud icon included using bspzip.
	hudx = 5,
	hudy = 210,
	hudwidth = 48,
	hudheight = 48,
	hudalign = 1, 
	hudstatusiconbluex = 60,
	hudstatusiconbluey = 5,
	hudstatusiconredx = 60,
	hudstatusiconredy = 5,
	hudstatusiconyellowx = 55,
	hudstatusiconyellowy = 26,
	hudstatusicongreenx = 55,
	hudstatusicongreeny = 26,
	hudstatusiconblue = "hud_flag_carried_blue.vtf",
	hudstatusiconred = "hud_flag_carried_red.vtf",
	hudstatusiconyellow = "hud_flag_carried_yellow.vtf",
	hudstatusicongreen = "hud_flag_carried_green.vtf",
	hudstatusiconw = 15,
	hudstatusiconh = 15,
	hudstatusiconbluealign = 2,
	hudstatusiconredalign = 3,
	hudstatusiconyellowalign = 2,
	hudstatusicongreenalign = 3,

	touchflags = {AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen},
	botgoaltype = Bot.kFlag
})

function baseflag:precache()
	PrecacheSound(self.tosssound)
	PrecacheSound("yourteam.flagstolen")
	PrecacheSound("yourteam.drop")
	PrecacheSound("otherteam.drop")
	PrecacheSound("yourteam.flagreturn")
	PrecacheSound("otherteam.flagreturn")
	info_ff_script.precache(self)
end

function baseflag:spawn()
	self.notouch = { }
	info_ff_script.spawn(self)
end

function baseflag:addnotouch(player_id, duration)
	self.notouch[player_id] = duration
	AddSchedule(self.name .. "-" .. player_id, duration, self.removenotouch, self, player_id)
end

function baseflag.removenotouch(self, player_id)
	self.notouch[player_id] = nil
end

function baseflag:touch( touch_entity )
	local player = CastToPlayer( touch_entity )
	ApplyToPlayer( player, { AT.kChangeTeamRed } )
	local team = player:GetTeam()
	-- pickup if they can
	if self.notouch[player:GetId()] then return; end
	
	-- Start counting scores
	AddScheduleRepeating("addpoints", PERIOD_TIME, addpoints, player)
	
	-- just start regenerating
	REGENERATING_ENABLED = true
	if ( REGENERATING_ENABLED ) then
		AddScheduleRepeating("regen_holder", REGEN_TIME, regenerate_holder, player)
	end

	RemoveSchedule("returnflag")
	
	player:SetDisguisable( false )
	player:SetCloakable( false )
	
	-- Give the flag to the player
	local flag = CastToInfoScript(entity)
	flag:Pickup(player)

	-- Add HUD icons to the player and to the top of the screen indicating which team has the flag
	AddHudIcon( player, self.hudicon, flag:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign )

	-- Let the players know that the flag was picked up
	RemoveHudItemFromAll( "flag-icon-dropped" )
	local team = player:GetTeamId()
	if (team == Team.kRed) then
		AddHudIconToAll( self.hudstatusiconred, "flag-icon-red", self.hudstatusiconredx, self.hudstatusiconredy, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconredalign )
	end
	
	-- Play "Quad Damage" sound effect

	if player:GetTeamId() == Team.kRed then
		OutputEvent("broadcast-quad-damage","PlaySound") -- "Quad Damage!"
		OutputEvent("broadcast-quad-damage2","PlaySound") -- "BWAAAAA"
	end
	
	-- Broadcast a message to the Quad Hog and Set Quad Hog's Timer

	SmartMessage(player,"You are the Quad Hog! Defend yourself from the Quad Hunters!", "Your team has the flag!", player:GetName().. " has become the Quad Hog!")
	if player:GetTeamId() == Team.kRed then
		UpdateTeamObjectiveIcon( GetTeam( Team.kRed ), nil )
	end
	AddSchedule( "killqh", 60, killqh, player)
	qhTimerAdd( player )
	blueTimerDelay()
	
end

function blueTimerDelay()
	for i = 1, PLAYER_CONNECTED_COUNT do
		if PLAYER_ARRAY[i]:GetTeamId() == 2 then
			blueTimerAdd( PLAYER_ARRAY[i] )
		end
	end
end

function baseflag:ondrop( owner_entity )
	local flag = CastToInfoScript(entity)
	flag:EmitSound(self.tosssound)
	BroadCastSound("yourteam.flagdrop")

	-- Stop counting scores and regenerating the holder.
	RemoveSchedule("addpoints")
	RemoveSchedule("regen_holder")
	REGENERATING_ENABLED = false
	
	-- Remove all HUD flag icons from all players
	RemoveHudItemFromAll( flag:GetName() )
	
	RemoveHudItemFromAll( "flag-icon-blue" )
	RemoveHudItemFromAll( "flag-icon-red" )
	RemoveHudItemFromAll( "flag-icon-yellow" )
	RemoveHudItemFromAll( "flag-icon-green" )
end

function baseflag:onloseitem( owner_entity )
	local player = CastToPlayer( owner_entity )
	
	player:SetDisguisable( true )
	player:SetCloakable( true )

	-- Prevent the player from picking the flag up again for a couple of seconds.
	self:addnotouch(player:GetId(), self.capnotouchtime)
	
	-- Stop counting scores and regenerating the holder
	RemoveSchedule("addpoints")
	RemoveSchedule("regen_holder")

end

function baseflag:onownerdie( owner_entity )
	-- drop the flag
	local flag = CastToInfoScript(entity)
	flag:Drop(-1, 0.0)
	BroadCastMessage("The Quad Hog died.")

	AddSchedule("returnflag", FLAG_RETURN_TIME, returnflag)

	local player = CastToPlayer( owner_entity )

	qhTimerRemove( player )
	RemoveSchedule("killqh")
	for i = 1,PLAYER_CONNECTED_COUNT
	do
		blueTimerRemove( PLAYER_ARRAY[i] )
	end
	player:SetRespawnable( false )
	AddSchedule( "changeqhteam", 1, changeqhteam, player)
	AddSchedule( "respawnqh", 2, respawnqh, player)
	BroadCastMessageToPlayer(player, "Respawning in 2 seconds...", 2)
end

function baseflag:onreturn()
	RemoveSchedule("returnflag")
end

function baseflag:hasanimation() return true end

-- Define the flag
flag = baseflag:new({})

-----------------------------------------------------------------------------
-- timed functions
-----------------------------------------------------------------------------
function addpoints( player_entity )

	-- Scoring is enabled even when the flag holder leaves the hold area.
	-- This makes it easier for medics and scouts to "flagrun" around the map or in the water without losing scoring time
	
	-- Add score for the flag holder's team
	local flagholder = CastToPlayer( player_entity )
	local team = flagholder:GetTeam()
	team:AddScore(POINTS_PER_PERIOD)

	-- Add fortress points for each member of the team to encourage teamplay

	-- Get a collection of all players
	local c = Collection()
	c:GetByFilter({CF.kPlayers})
	
	for temp in c.items do
		local player = CastToPlayer( temp )
		if player then
			if player:GetId() == flagholder:GetId() then
				player:AddFortPoints(HOLDER_POINTS, "Surviving as Quad Hog")
			elseif player:GetTeamId() == team:GetTeamId() then
				player:AddFortPoints(TEAM_MEMBER_POINTS, "Protecting the Flag")
			end
		end
	end
	
end

function regenerate_holder( player_entity )
	if ( REGENERATING_ENABLED ) then
		local player = CastToPlayer( player_entity )
		-- Regeneration 5.50% with 1 players and 10% with 20 players, linear scaling
		player:AddHealth( player:GetMaxHealth() * (5+0.50*NumPlayers()) / 100 )
		player:AddArmor( player:GetMaxArmor() * (5+0.50*NumPlayers()) / 100 )
	end
end

-- This is called when the flag return timer finishes.
-- The flag is returned to the start location.
function returnflag()
	local flag = GetInfoScriptByName( "flag" )

	flag:Return()
	
	-- Set the flag entity's parent to the invisible func_rotating at the middle of the map so the flag starts rotating again
	OutputEvent("flag","SetParent","flagrotator")
	
	-- Let the players know that the flag has returned.
	BroadCastMessage("The flag has returned to the middle.")
	OutputEvent("broadcast-flag-returned","PlaySound") -- "The flag has returned"
	
	-- Stop counting scores and regenerating the holder
	RemoveSchedule("addpoints")
	RemoveSchedule("regen_holder")
	REGENERATING_ENABLED = true
		
	-- Remove any hud icons
	RemoveHudItemFromAll( flag:GetName() )

	RemoveHudItemFromAll( "flag-icon-blue" )
	RemoveHudItemFromAll( "flag-icon-red" )
	RemoveHudItemFromAll( "flag-icon-yellow" )
	RemoveHudItemFromAll( "flag-icon-green" )
end

function qhTimerAdd( player_entity )
	local player = CastToPlayer( player_entity )
	AddTimer( "qhtimer", 60, -1 )
	AddHudTimer( player, "hud_qhtimer", "qhtimer", 0, 61, 4, 0, 5 )
	AddHudText( player, "qhtext", string.format("Time until Vaporisation:"), -65, 70, 4 )
end

function qhTimerRemove( player_entity )
	local player = CastToPlayer( player_entity )
	RemoveHudItem(player, "hud_qhtimer")
	RemoveHudItem(player, "qhtext")
	RemoveTimer( "qhtimer" )
end

function qhTimerReset( player_entity )
	local player = CastToPlayer( player_entity )
	RemoveHudItem(player, "hud_qhtimer")
	RemoveHudItem(player, "qhtext")
	RemoveTimer( "qhtimer" )
	AddTimer( "qhtimer", 60, -1 )
	AddHudTimer( player, "hud_qhtimer", "qhtimer", 0, 61, 4, 0, 5 )
	AddHudText( player, "qhtext", string.format("Time until Vaporisation:"), -65, 70, 4 )
end

function blueTimerAdd( player_entity )
	local player = CastToPlayer( player_entity )
	AddTimer( "bluetimer", 60, -1 )
	AddHudTimer( player, "hud_bluetimer", "bluetimer", 0, 61, 4, 0, 5 )
	AddHudText( player, "bluetext", string.format("Time until Quad Hog's Death:"), -80, 70, 4 )
end

function blueTimerRemove( player_entity )
	local player = CastToPlayer( player_entity )
	RemoveHudItem(player, "hud_bluetimer")
	RemoveHudItem(player, "bluetext")
	RemoveTimer( "bluetimer" )
end

function blueTimerReset( player_entity )
	local player = CastToPlayer( player_entity )
	RemoveHudItem(player, "hud_bluetimer")
	RemoveHudItem(player, "bluetext")
	RemoveTimer( "bluetimer" )
	AddTimer( "bluetimer", 60, -1 )
	AddHudTimer( player, "hud_bluetimer", "bluetimer", 0, 61, 4, 0, 5 )
	AddHudText( player, "bluetext", string.format("Time until Quad Hog's Death:"), -80, 70, 4 )
end

function killqh( player_entity )
	local player = CastToPlayer( player_entity )
	ApplyToPlayer( player, { AT.kKillPlayers } )
end

function changeqhteam( player_entity )
	local player = CastToPlayer( player_entity )
	ApplyToPlayer( player, { AT.kChangeTeamBlue } )
	player:SetRespawnable( true )
end

function respawnqh( player_entity )
	local player = CastToPlayer( player_entity )
	ApplyToPlayer( player, { AT.kRespawnPlayers } )
	player:SetRespawnable( true )
end

function qhrand1()
	local i = math.random(1, PLAYER_CONNECTED_COUNT)
	QH = PLAYER_ARRAY[i]
	ApplyToPlayer( QH, { AT.kKillPlayers } )
	QH:SetRespawnable( false )
end

function qhrand2()
	ApplyToPlayer( QH, { AT.kChangeTeamRed } )
	QH:SetRespawnable( false )
end

function qhrand3()
	ApplyToAll( { AT.kRespawnPlayers } )
	QH:SetRespawnable( true )
end

function selectRandomqh()
	qhrand1()
	AddSchedule("qhrand2", 1, qhrand2)
	AddSchedule("qhrand3", 2, qhrand3)
end
-----------------------------------------------------------------------------
-- Respawn force shields - trigger_ff_clip
-- Completely prevents players from other teams entering the respawn rooms. Also blocks their projectiles, but not grenades, rockets, pipes etc.
-- To get this working you need to modify the trigger_ff_clip brush in Hammer somehow by changing its entity type or something before changing it back to trigger_ff_clip.
-- i got this working by accident so i still have no idea how to do it properly.
-----------------------------------------------------------------------------

-- We need three of these at every respawn door. Red door has blue, yellow and green, and so on. One entity can be used to block only on team (as far as i know). If we add more clipflags, it blocks nothing.
bluerespawnshield = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipPlayersByTeam, ClipFlags.kClipTeamRed, ClipFlags.kClipTeamYellow, ClipFlags.kClipTeamGreen, ClipFlags.kClipAllNonPlayers} })-- Blocks blue team

-- Stops projectiles and explosives. Also blocks all players for some reason. Used at the flag stand to block explosion decals from messing the model up.
blockdamage = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipProjectiles, ClipFlags.kClipGrenades} })

-----------------------------------------------------------------------------
-- Respawn force shields - trigger_remove
-- These will make all grenades, pipes, rockets etc. disappear when fired at a force field.
-- The allowed function for these entities is very important. If a trigger_remove tries to remove a player, the server will crash.
-----------------------------------------------------------------------------

forcefield_remover = trigger_ff_script:new({ })

function forcefield_remover:allowed( allowed_entity )
	-- Prevent the trigger_remove from removing players, sentryguns or dispensers (not that you could even build them there, but just in case).
	if IsPlayer(allowed_entity) or IsDispenser(allowed_entity) or IsSentrygun(allowed_entity) then
		return EVENT_DISALLOWED
	end
	return EVENT_ALLOWED
end
