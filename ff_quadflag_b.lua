-----------------------------------------------------------------------------
-- ff_hold.lua
-- version: 1.0
-- Author: A1win
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
FLAG_THROW_SPEED = 512 -- Initial speed of the flag when thrown
FLAG_RETURN_TIME = 5 -- Time in seconds after the flag returns to the middle

-- Scoring settings:
PERIOD_TIME = 10 -- Period in seconds to add scores for the flag holder and his team
POINTS_PER_PERIOD = 1 -- Amount of score to add for the flag holder's team each PERIOD_TIME seconds.
HOLDER_POINTS = 100 -- Amount of Fortress Points to add for the flag holder each PERIOD_TIME seconds.
TEAM_MEMBER_POINTS = 50 -- Amount of Fortress Points to add for each of the flag holder's team members each PERIOD_TIME seconds.

-- Flag holder settings:
REGEN_TIME = 1 -- Period in seconds to regenerate the flag holder inside the hold area.
				-- Amount is 5% - 10% of maximum health and armor depending on the number of players on the server.
DAMAGE_BONUS = 4 -- Multiplies the flag holder's damage by DAMAGE_BONUS when holding the flag. 1 = Normal damage, 4 = Quad damage

-----------------------------------------------------------------------------
-- Global variables, don't touch
-----------------------------------------------------------------------------
-- Defines when the flag holder's regeneration is enabled
REGENERATING_ENABLED = true

-- The player can hold the flag for a short period of time after picking it up until it starts to hurt him outside the area
PROTECTION_ENABLED = false

-----------------------------------------------------------------------------
-- Some Global Stuff
-----------------------------------------------------------------------------
function startup()

	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, 0)
	SetPlayerLimit(Team.kGreen, 0)

	local team = GetTeam( Team.kBlue )
	local team = GetTeam( Team.kRed )
	local team = GetTeam( Team.kYellow )
	local team = GetTeam( Team.kGreen )	
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

-----------------------------------------------------------------------------
-- Resupply stuff
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

location_holdarea = location_info:new({ text = "Hold Area", team = Team.kUnassigned })
location_water = location_info:new({ text = "Water", team = Team.kUnassigned })

location_tower_ry = location_info:new({ text = "Tower Red-Yellow", team = Team.kUnassigned })
location_tower_gr = location_info:new({ text = "Tower Green-Red", team = Team.kUnassigned })
location_tower_gb = location_info:new({ text = "Tower Blue-Green", team = Team.kUnassigned })
location_tower_by = location_info:new({ text = "Tower Blue-Yellow", team = Team.kUnassigned })

location_trench_blue = location_info:new({ text = "Trench", team = Team.kBlue })
location_trench_red = location_info:new({ text = "Trench", team = Team.kRed })
location_trench_yellow = location_info:new({ text = "Trench", team = Team.kYellow })
location_trench_green = location_info:new({ text = "Trench", team = Team.kGreen })

location_ramp_blue = location_info:new({ text = "Ramp", team = Team.kBlue })
location_ramp_red = location_info:new({ text = "Ramp", team = Team.kRed })
location_ramp_yellow = location_info:new({ text = "Ramp", team = Team.kYellow })
location_ramp_green = location_info:new({ text = "Ramp", team = Team.kGreen })

location_pipe_blue = location_info:new({ text = "Water Access", team = Team.kBlue })
location_pipe_red = location_info:new({ text = "Water Access", team = Team.kRed })
location_pipe_yellow = location_info:new({ text = "Water Access", team = Team.kYellow })
location_pipe_green = location_info:new({ text = "Water Access", team = Team.kGreen })

location_base_blue = location_info:new({ text = "Blue Base", team = Team.kBlue })
location_base_red = location_info:new({ text = "Red Base", team = Team.kRed })
location_base_yellow = location_info:new({ text = "Yellow Base", team = Team.kYellow })
location_base_green = location_info:new({ text = "Green Base", team = Team.kGreen })

location_balcony_blue = location_info:new({ text = "Balcony", team = Team.kBlue })
location_balcony_red = location_info:new({ text = "Balcony", team = Team.kRed })
location_balcony_yellow = location_info:new({ text = "Balcony", team = Team.kYellow })
location_balcony_green = location_info:new({ text = "Balcony", team = Team.kGreen })

location_respawn_blue = location_info:new({ text = "Respawn Room", team = Team.kBlue })
location_respawn_red = location_info:new({ text = "Respawn Room", team = Team.kRed })
location_respawn_yellow = location_info:new({ text = "Respawn Room", team = Team.kYellow })
location_respawn_green = location_info:new({ text = "Respawn Room", team = Team.kGreen })

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
	local team = player:GetTeam()
	-- pickup if they can
	if self.notouch[player:GetId()] then return; end
	
	-- Start counting scores
	AddScheduleRepeating("addpoints", PERIOD_TIME, addpoints, player)
	
	-- Start regenerating if it's allowed.
	-- We don't know if the player is inside the hold area when he picks the flag up
	-- which is why we need the REGENERATING_ENABLED variable to keep track of it.
	-- It's set to true periodically when the player is inside the hold area
	-- and set to false when the player drops the flag or goes away from the hold area.
	-- If there was a function to detect if the player is inside the holdarea entity, we could use that instead.
	if ( REGENERATING_ENABLED ) then
		AddScheduleRepeating("regen_holder", REGEN_TIME, regenerate_holder, player)
	end
	
	PROTECTION_ENABLED = true
	AddSchedule("disableprotection", 0.5, disableprotection)
	
	-- Start the flag return timer.
	AddSchedule("hotwarning", 1, hotwarning, player)
	AddSchedule("returnflag", FLAG_RETURN_TIME, returnflag)
	
	player:SetDisguisable( false )
	player:SetCloakable( false )
	
	-- Give the flag to the player
	local flag = CastToInfoScript(entity)
	flag:Pickup(player)

	-- Add HUD icons to the player and to the top of the screen indicating which team has the flag
	AddHudIcon( player, self.hudicon, flag:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign )
	
	RemoveHudItemFromAll( "flag-icon-dropped" )
	local team = player:GetTeamId()
	if (team == Team.kBlue) then
		AddHudIconToAll( self.hudstatusiconblue, "flag-icon-blue", self.hudstatusiconbluex, self.hudstatusiconbluey, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconbluealign )
	elseif (team == Team.kRed) then
		AddHudIconToAll( self.hudstatusiconred, "flag-icon-red", self.hudstatusiconredx, self.hudstatusiconredy, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconredalign )
	elseif (team == Team.kYellow) then
		AddHudIconToAll( self.hudstatusiconyellow, "flag-icon-yellow", self.hudstatusiconyellowx, self.hudstatusiconyellowy, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconyellowalign )
	elseif (team == Team.kGreen) then
		AddHudIconToAll( self.hudstatusicongreen, "flag-icon-green", self.hudstatusicongreenx, self.hudstatusicongreeny, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusicongreenalign )
	end
	
	-- Let the players know that the flag was picked up
	local teamid = player:GetTeamId()
	local teamname = ""
	
	if teamid == Team.kBlue then
		teamname = "Blue"
		OutputEvent("broadcast-flag-blue","PlaySound") -- "Blue team has the flag"
	elseif teamid == Team.kRed then
		teamname = "Red"
		OutputEvent("broadcast-flag-red","PlaySound") -- "Red team has the flag"
	elseif teamid == Team.kYellow then
		teamname = "Yellow"
		OutputEvent("broadcast-flag-yellow","PlaySound") -- "Yellow team has the flag"
	else
		teamname = "Green"
		OutputEvent("broadcast-flag-green","PlaySound") -- "Green team has the flag"
	end
	
	SmartMessage(player,"You gain Quad Damage!  Hold the flag on the Hold Area!", "Your team has the flag!", "The " .. teamname .. " team has the flag!")

	-- log action in stats
	player:AddAction(nil, "ctf_flag_touch", flag:GetName())
	
end

function baseflag:dropitemcmd( owner_entity )
	-- Throw the flag. Don't use return timer here.
	-- We need a seperate return Schedule so we can reset it if the flag is taken back to the hold area
	local flag = CastToInfoScript(entity)
	flag:Drop(-1, FLAG_THROW_SPEED)
end	

function baseflag:ondrop( owner_entity )
	local flag = CastToInfoScript(entity)
	flag:EmitSound(self.tosssound)
	BroadCastSound("yourteam.flagdrop")
	BroadCastMessage("The flag was dropped.")
	
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
	
	-- Reset the warning delay timer and the warning
	RemoveSchedule("hotwarning")

end

function baseflag:onownerdie( owner_entity )
	-- drop the flag
	local flag = CastToInfoScript(entity)
	flag:Drop(-1, 0.0)
end

function baseflag:hasanimation() return true end

-- Define the flag
flag = baseflag:new({})

-----------------------------------------------------------------------------
-- Hold area
-- The area where the flag is supposed to be held
-- If the holder leaves the area, the flag returns to the middle after a delay
-----------------------------------------------------------------------------

holdarea = trigger_ff_script:new({ })

-- This is called periodically (every 0.1 seconds or so)  when the player is inside the holdarea trigger.
function holdarea:ontrigger( trigger_entity )
	if ( IsPlayer( trigger_entity ) ) then
		local player = CastToPlayer( trigger_entity )
		-- Check if the player is carrying the flag.
		if player:HasItem( "flag" ) then
		
			-- Stop the flag return and warning timers ( the player is inside the hold area)
			RemoveSchedule("returnflag")
			RemoveSchedule("hotwarning")

			-- Start the flag return timer.
			AddSchedule("hotwarning", 1, hotwarning, player)
			AddSchedule("returnflag", FLAG_RETURN_TIME, returnflag)
			
			-- Allow the player to gain scores and regenerate.
			if ( not REGENERATING_ENABLED ) then
				AddScheduleRepeating("regen_holder", REGEN_TIME, regenerate_holder, player)
				REGENERATING_ENABLED = true
			end
		end
	end
end

-- This function is needed to only allow the flag holder to call the holdarea:ontrigger function,
-- because only one player can trigger the entity simultaneously.
function holdarea:allowed ( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
	
		if player:HasItem( "flag" ) then
			return true
		end
	end
	return false
end

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
				player:AddFortPoints(HOLDER_POINTS, "Holding the Flag")
			elseif player:GetTeamId() == team:GetTeamId() then
				player:AddFortPoints(TEAM_MEMBER_POINTS, "Protecting the Flag")
			end
		end
	end
	
end

-- Disables the protection feature that is used to not cause the flag holder to take damage when he picks up the flag inside the hold area.
function disableprotection()
	PROTECTION_ENABLED = false
end

function regenerate_holder( player_entity )
	if ( REGENERATING_ENABLED ) then
		local player = CastToPlayer( player_entity )
		-- Regeneration 5.25% with 1 players and 10% with 20 players, linear scaling
		player:AddHealth( player:GetMaxHealth() * (5+0.25*NumPlayers()) / 100 )
		player:AddArmor( player:GetMaxArmor() * (5+0.25*NumPlayers()) / 100 )
	end
end

-- This is called when the flag return timer finishes.
-- The flag is returned to the start location.
function returnflag()
	local flag = GetInfoScriptByName( "flag" )

	flag:Return()
	
	
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

-- Displays a warning message and plays a sound to the player when the he takes the flag outside the hold area.
-- Also disables regenerating the holder.
function hotwarning( player_entity )
	local player = CastToPlayer( player_entity )
	BroadCastSoundToPlayer( player, "otherteam.drop")
	BroadCastMessageToPlayer( player, "The flag is hot! Take it back to the Hold Area.")
	REGENERATING_ENABLED = false
end

-----------------------------------------------------------------------------
-- Hurt the player if they carry the flag outside the hold area
-- This trigger_hurt covers the whole map
-----------------------------------------------------------------------------
holdhurt = trigger_ff_script:new({})

function holdhurt:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if not PROTECTION_ENABLED and not REGENERATING_ENABLED and player:HasItem( "flag" ) then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

-----------------------------------------------------------------------------
-- Respawn force shields - trigger_ff_clip
-- Completely prevents players from other teams entering the respawn rooms. Also blocks their projectiles, but not grenades, rockets, pipes etc.
-- To get this working you need to modify the trigger_ff_clip brush in Hammer somehow by changing its entity type or something before changing it back to trigger_ff_clip.
-- I got this working by accident so I still have no idea how to do it properly.
-----------------------------------------------------------------------------

-- We need three of these at every respawn door. Red door has blue, yellow and green, and so on. One entity can be used to block only on team (as far as I know). If we add more clipflags, it blocks nothing.
bluerespawnshield = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamBlue} }) -- Blocks blue team
redrespawnshield = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamRed} }) -- Blocks red team
yellowrespawnshield = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamYellow} }) -- Blocks yellow team
greenrespawnshield = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamGreen} }) -- Blocks green team

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
