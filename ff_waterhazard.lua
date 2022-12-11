------------------------------------------------
-- This is essentially an edit of ff_cz2.lua, with some stuff from other official .lua's put in, and some minor tweaks
-- by myself to get it all working.
--
-- Pon.id
-- ff_waterhazard.lua (warpath_tut.lua v0.92 for Mongoose)
--
-- TO-DO List:
-- Respawn doors
-- Clean up everything/make sure all cz2 code thats not needed is removed
------------------------------------------------


-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay")
IncludeScript("base_location")
IncludeScript("base_respawnturret")

-----------------------------------------------------------------------------
-- globals
-----------------------------------------------------------------------------

-- Scoring globals
NUMBER_OF_COMMAND_POINTS = 5
POINTS_FOR_COMPLETE_CONTROL = 30
FORTPOINTS_FOR_COMPLETE_CONTROL = 1000
FORTPOINTS_FOR_CAP = 200


-- Other Globals (Initial round delay used only for first round, give people time to log in)

INITIAL_ROUND_DELAY = 45
RECAPTURE_DELAY = 15
NORMAL_ROUND_DELAY = 30

-- Counters for spawn validty
cp_blue = 1
cp_red = 5


-- A global table for storing some team info
team_info = {
 
	[Team.kUnassigned] = {
		team_name = "neutral",
		enemy_team = Team.kUnassigned,
		ammo_armor_touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen},
		color_index = 1,
		skin = "0",
		flag_visibility = "TurnOff"
	},

	[Team.kBlue] = {
		team_name = "blue",
		enemy_team = Team.kRed,
		ammo_armor_touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue},
		color_index = 2,
		skin = "0",
		flag_visibility = "TurnOn"
	},

	[Team.kRed] = {
		team_name = "red",
		enemy_team = Team.kBlue,
		ammo_armor_touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed},
		color_index = 0,
		skin = "1",
		flag_visibility = "TurnOn"
	}
}

-- This table is for keeping track of which team controls which CP
command_points = {
	[1] = { controlling_team = Team.kBlue, cp_number = 1, disable_capture = 0, hudstatusicon = "hud_cp_1.vtf", hudposx = -40, hudposy = 36, hudalign = 4, hudwidth = 16, hudheight = 16 },
	[2] = { controlling_team = Team.kUnassigned, cp_number = 2, disable_capture = 0, hudstatusicon = "hud_cp_2.vtf", hudposx = -20, hudposy = 36, hudalign = 4, hudwidth = 16, hudheight = 16 },
	[3] = { controlling_team = Team.kUnassigned, cp_number = 3, disable_capture = 0, hudstatusicon = "hud_cp_3.vtf", hudposx = 0, hudposy = 36, hudalign = 4, hudwidth = 16, hudheight = 16 },
	[4] = { controlling_team = Team.kUnassigned, cp_number = 4, disable_capture = 0, hudstatusicon = "hud_cp_4.vtf", hudposx = 20, hudposy = 36, hudalign = 4, hudwidth = 16, hudheight = 16 },
	[5] = { controlling_team = Team.kRed, cp_number = 5, disable_capture = 0, hudstatusicon = "hud_cp_5.vtf", hudposx = 40, hudposy = 36, hudalign = 4, hudwidth = 16, hudheight = 16 }
}

icons = {
	[Team.kBlue] = { teamicon = "hud_cp_blue.vtf", disabled = "hud_disabled.vtf" },
	[Team.kRed] = { teamicon = "hud_cp_red.vtf", disabled = "hud_disabled.vtf" },
	[Team.kUnassigned] = { teamicon = "hud_cp_neutral.vtf", disabled = "hud_disabled.vtf" }
}


function startup()

	-- set up team limits
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	local team = GetTeam(Team.kBlue)
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )


	local team = GetTeam(Team.kRed)
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )


	-- Reset all command points
	command_point_one:ChangeControllingTeam(Team.kBlue)
	command_point_two:ChangeControllingTeam(Team.kUnassigned)
	command_point_three:ChangeControllingTeam(Team.kUnassigned)
	command_point_four:ChangeControllingTeam(Team.kUnassigned)
	command_point_five:ChangeControllingTeam(Team.kRed)

	-- Setup Doors for first round

	setup_door_timer("startgate_blue", INITIAL_ROUND_DELAY)
	setup_door_timer("startgate_red", INITIAL_ROUND_DELAY)

end

function precache()
	-- precache sounds
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("otherteam.flagcap")
	PrecacheSound("otherteam.flagstolen")


	PrecacheSound("misc.bizwarn")
	PrecacheSound("misc.bloop")
	PrecacheSound("misc.buzwarn")
	PrecacheSound("misc.dadeda")
	PrecacheSound("misc.deeoo")
	PrecacheSound("misc.doop")
	PrecacheSound("misc.woop")

	

	-- Unagi Power!  Unagi!
	PrecacheSound("misc.unagi")


end

-----------------------------------------------------------------------------
-- timed scoring
-----------------------------------------------------------------------------

function complete_control_notification ( player )

	SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "otherteam.flagcap")
	SmartMessage(player, "Your team captured ALL Command Points!", "Your team captured ALL Command Points!", "The enemy team captured ALL Command Points!")


end


base_team_trigger = trigger_ff_script:new({ team = Team.kUnassigned, failtouch_message = "" })

function base_team_trigger:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

function base_team_trigger:onfailtouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer( player, failtouch_message )
	end
end

blue_door_trigger = base_team_trigger:new({ team = Team.kBlue , failtouch_message = "#FF_NOTALLOWEDDOOR" })
red_door_trigger = base_team_trigger:new({ team = Team.kRed , failtouch_message = "#FF_NOTALLOWEDDOOR" })



-----------------------------------------------------------------------------
-- base_cp_trigger
-----------------------------------------------------------------------------

base_cp_trigger = trigger_ff_script:new({
	health = 100,
	armor = 300,
	grenades = 200,
	nails = 200,
	shells = 200,
	rockets = 200,
	cells = 200,
	detpacks = 1,
	gren1 = 1,
	gren2 = 1,
	item = "",
	team = 0,
	botgoaltype = Bot.kFlagCap,
	cp_number = 0,
})

function base_cp_trigger:ontrigger( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		local cp = command_points[self.cp_number]


		local new_controlling_team = player:GetTeamId()
		local old_controlling_team = cp.controlling_team
		local team = GetTeam(new_controlling_team)


		-- No capping if player's team already controls this CP
		if player:GetTeamId() == cp.controlling_team then return end


		-- No Capping if team doesn't own preceeding point
		if new_controlling_team == Team.kBlue then
			local last_blue_cp = self.cp_number - 1
			if command_points[last_blue_cp].controlling_team ~= new_controlling_team then return end
		elseif new_controlling_team == Team.kRed then
			local last_red_cp = self.cp_number + 1
			if command_points[last_red_cp].controlling_team ~= new_controlling_team then return end
		end


		-- No Capping if disabled due to recent capture
		if cp.disable_capture == 1 then return end


		-- Find out if any team has complete control
		local team_with_complete_control = Team.kUnassigned
		local control_count = { [Team.kBlue] = 0, [Team.kRed] = 0 }
		control_count[new_controlling_team] = 1
		for i,v in ipairs(command_points) do
			if v.controlling_team ~= Team.kUnassigned and v.cp_number ~= self.cp_number then
				control_count[v.controlling_team] = control_count[v.controlling_team] + 1
			end
			if control_count[v.controlling_team] == NUMBER_OF_COMMAND_POINTS then
				team_with_complete_control = v.controlling_team
			end
		end

		-- Ends round if a team has all cp's, else just sorts out a normal cp capture.
		if team_with_complete_control ~= Team.kUnassigned then

			-- Team points for complete control, more FortPoints too
			team:AddScore(POINTS_FOR_COMPLETE_CONTROL)
			player:AddFortPoints(FORTPOINTS_FOR_COMPLETE_CONTROL, "Final CP Captured")

			AddSchedule("complete_control_notification", 0.1, complete_control_notification, player)
			
			-- Reset all command points
			command_point_one:ChangeControllingTeam(Team.kBlue)
			command_point_two:ChangeControllingTeam(Team.kUnassigned)
			command_point_three:ChangeControllingTeam(Team.kUnassigned)
			command_point_four:ChangeControllingTeam(Team.kUnassigned)
			command_point_five:ChangeControllingTeam(Team.kRed)

			-- Reset extended spawn areas and door
			cp_blue = 1
			cp_red = 5

			-- Reset doors and set up timers for the next round
			setup_door_timer("startgate_blue", NORMAL_ROUND_DELAY)
			setup_door_timer("startgate_red", NORMAL_ROUND_DELAY)

			-- Clean up HUD and capture disabled status for all CP's
			for i,v in ipairs(command_points) do
				RemoveHudItemFromAll( v.cp_number .. "-disabled-" .. Team.kRed )
				RemoveHudItemFromAll( v.cp_number .. "-disabled-" .. Team.kBlue )
				v.disable_capture = 0
			end

			-- Respawns everyone/clean up map. Done in schedule to give delay
			AddSchedule( "new_round_respawn", 0.1, new_round_respawn)

		else

			-- Give points to player for single cap
			player:AddFortPoints(FORTPOINTS_FOR_CAP, "Captured CP" .. self.cp_number)


			-- Set new owning team, change spawn validity, then disable capture for a bit
			self:ChangeControllingTeam(new_controlling_team, old_controlling_team)
			cp.disable_capture = 1
			AddSchedule ("cp" .. self.cp_number .. "_reenable", RECAPTURE_DELAY, cp_reenable, cp, new_controlling_team)


			-- have to do messages here since player is here
			-- could just pass player to ChangeControllingTeam, but fuck you

			SmartMessage(player, "You captured Command Point " .. self.cp_number, "Your team captured Command Point " .. self.cp_number, "The enemy team captured Command Point " .. self.cp_number)

			-- sounds will get more and more crazy
			-- NOTE: These checks are hardcoded for 5 CPs...if you have more CPs, change how these are checked

			if control_count[new_controlling_team] == 4 then
				SmartSound(player, "misc.unagi", "misc.unagi", "misc.bizwarn")
			elseif control_count[new_controlling_team] == 3 then
				SmartSound(player, "misc.woop", "misc.woop", "misc.buzwarn")
			elseif control_count[new_controlling_team] == 2 then
				SmartSound(player, "misc.doop", "misc.doop", "misc.dadeda")
			else
				SmartSound(player, "misc.bloop", "misc.bloop", "misc.deeoo")
			end


		end

		-- give player some health and armor
		if self.health ~= nil and self.health ~= 0 then player:AddHealth( self.health ) end
		if self.armor ~= nil and self.armor ~= 0 then player:AddArmor( self.armor ) end
	
		-- give player ammo
		if self.nails ~= nil and self.nails ~= 0 then player:AddAmmo(Ammo.kNails, self.nails) end
		if self.shells ~= nil and self.shells ~= 0 then player:AddAmmo(Ammo.kShells, self.shells) end
		if self.rockets ~= nil and self.rockets ~= 0 then player:AddAmmo(Ammo.kRockets, self.rockets) end
		if self.cells ~= nil and self.cells ~= 0 then player:AddAmmo(Ammo.kCells, self.cells) end
		if self.detpacks ~= nil and self.detpacks ~= 0 then player:AddAmmo(Ammo.kDetpack, self.detpacks) end
		if self.gren1 ~= nil and self.gren1 ~= 0 then player:AddAmmo(Ammo.kGren1, self.gren1) end
		if self.gren2 ~= nil and self.gren2 ~= 0 then player:AddAmmo(Ammo.kGren2, self.gren2) end

	end
end

function base_cp_trigger:ChangeControllingTeam( new_controlling_team, old_controlling_team )


		-- Change the cap flag around
		OutputEvent( "cp" .. self.cp_number .. "_flag", "Skin", team_info[new_controlling_team].skin )
		OutputEvent( "cp" .. self.cp_number .. "_flag", team_info[new_controlling_team].flag_visibility)

		local cp = command_points[self.cp_number]


		-- remove old flaginfo icons and add new ones
		RemoveHudItemFromAll( self.cp_number .. "-background-" .. cp.controlling_team )
		RemoveHudItemFromAll( self.cp_number .. "-foreground-" .. cp.controlling_team )

		AddHudIconToAll( icons[ new_controlling_team ].teamicon , self.cp_number .. "-background-" .. new_controlling_team , cp.hudposx, cp.hudposy, cp.hudwidth, cp.hudheight, cp.hudalign)

		AddHudIconToAll( cp.hudstatusicon, self.cp_number .. "-foreground-" .. new_controlling_team , cp.hudposx, cp.hudposy, cp.hudwidth, cp.hudheight, cp.hudalign)

		-- 
		if (new_controlling_team ~= Team.kUnassigned) then
			AddHudIconToAll( icons[ new_controlling_team ].disabled, self.cp_number .. "-disabled-" .. new_controlling_team , cp.hudposx, cp.hudposy, cp.hudwidth, cp.hudheight, cp.hudalign)
		end



		-- Change valid spawns
		

		if new_controlling_team == Team.kBlue then
			cp_blue = self.cp_number
			if old_controlling_team == Team.kRed then
				cp_red = self.cp_number + 1
			end
		elseif new_controlling_team == Team.kRed then
			cp_red = self.cp_number
			if old_controlling_team == Team.kBlue then
				cp_blue = self.cp_number - 1
			end
		end


		cp.controlling_team = new_controlling_team

end


command_point_one = base_cp_trigger:new({ cp_number = 1 })
command_point_two = base_cp_trigger:new({ cp_number = 2 })
command_point_three = base_cp_trigger:new({ cp_number = 3 })
command_point_four = base_cp_trigger:new({ cp_number = 4 })
command_point_five = base_cp_trigger:new({ cp_number = 5 })



-------------------------
-- Re-enable disabled CP after RECAPTURE_DELAY (default 15 seconds)
-------------------------

function cp_reenable (cp, team)
	RemoveHudItemFromAll( cp.cp_number .. "-disabled-" .. team )
	cp.disable_capture = 0
end

function new_round_respawn()
	ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, kReloadClips })
end

-------------------------------------------
-- Initial HUD Stuff
-------------------------------------------

function flaginfo( player_entity )
	local player = CastToPlayer( player_entity )

	for i,v in ipairs(command_points) do

		AddHudIcon( player, icons[ v.controlling_team ].teamicon , v.cp_number .. "-background-" .. v.controlling_team , command_points[v.cp_number].hudposx, command_points[v.cp_number].hudposy, command_points[v.cp_number].hudwidth, command_points[v.cp_number].hudheight, command_points[v.cp_number].hudalign)
		AddHudIcon( player, command_points[v.cp_number].hudstatusicon, v.cp_number .. "-foreground-" .. v.controlling_team , command_points[v.cp_number].hudposx, command_points[v.cp_number].hudposy, command_points[v.cp_number].hudwidth, command_points[v.cp_number].hudheight, command_points[v.cp_number].hudalign)

	end
end


-------------------------------------------
-- Door stuff
-------------------------------------------

function setup_door_timer(doorname, duration)
	CloseDoor(doorname)
	AddSchedule("round_opendoor_" .. doorname, duration, round_start, doorname)
	AddSchedule("round_10secwarn", duration-10, round_10secwarn)
end

function round_start(doorname)
	BroadCastMessage("Gates are now open!")
	BroadCastSound( "otherteam.flagstolen" )
	OpenDoor(doorname)
end

function round_10secwarn() BroadCastMessage("10 Seconds until round starts") end



-------------------------------------------
-- Spawns Stuff
-------------------------------------------

base_blue_spawn = info_ff_teamspawn:new({ cp = 0, validspawn = function(self,player)
	return player:GetTeamId() == Team.kBlue and self.cp == cp_blue
end })
base_red_spawn = info_ff_teamspawn:new({ cp = 0, validspawn = function(self,player)
	return player:GetTeamId() == Team.kRed and self.cp == cp_red
end })
bluespawn_cp1 = base_blue_spawn:new({cp=1})
bluespawn_cp2 = base_blue_spawn:new({cp=2})
bluespawn_cp3 = base_blue_spawn:new({cp=3})
bluespawn_cp4 = base_blue_spawn:new({cp=4})
redspawn_cp5 = base_red_spawn:new({cp=5})
redspawn_cp4 = base_red_spawn:new({cp=4})
redspawn_cp3 = base_red_spawn:new({cp=3})
redspawn_cp2 = base_red_spawn:new({cp=2})


--------------------------------------------
--Grates
--------------------------------------------

base_grate_trigger = trigger_ff_script:new({ team = Team.kUnassigned, team_name = "neutral" })

function base_grate_trigger:onexplode( explosion_entity )
	if IsDetpack( explosion_entity ) then
		local detpack = CastToDetpack( explosion_entity )

		-- GetTemId() might not exist for buildables, they have their own seperate shit and it might be named differently
		if detpack:GetTeamId() ~= self.team then
			OutputEvent( self.team_name .. "_grate", "Kill" )
			OutputEvent( self.team_name .. "_grate_wall", "Kill" )
		end
	end

	-- I think this is needed so grenades and other shit can blow up here. They won't fire the events, though.
	return EVENT_ALLOWED
end

red_grate_trigger = base_grate_trigger:new({ team = Team.kRed, team_name = "red" })
blue_grate_trigger = base_grate_trigger:new({ team = Team.kBlue, team_name = "blue" })


--------------------------------------------
-- Custon Bags by the Mighty Mongoose
--------------------------------------------

bagcustom = genericbackpack:new({ 
	health = 50,
	armor = 75,
	bullets = 300,
	nails = 300,
	rockets = 300,
	grenades = 300,
	cells = 100,
	detpacks = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"})

grencustom = genericbackpack:new({ 
	health = 100,
	armor = 200,
	bullets = 300,
	nails = 300,
	rockets = 300,
	genardes = 300,
	cells = 100,
	detpacks = 0,
	gren1 = 1,
	gren2 = 1,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"})

dockbag = genericbackpack:new({ 
	health = 20,
	armor = 50,
	bullets = 300,
	nails = 300,
	rockets = 300,
	genardes = 300,
	cells = 100,
	detpacks = 0,
	gren1 = 1,
	gren2 = 1,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"})

----------------------------------------------
-- Locations
----------------------------------------------

location_cp1 = location_info:new({ text = "Command Point 1", team = NO_TEAM })
location_cp2 = location_info:new({ text = "Command Point 2", team = NO_TEAM })
location_cp3 = location_info:new({ text = "Command Point 3", team = NO_TEAM })
location_cp4 = location_info:new({ text = "Command Point 4", team = NO_TEAM })
location_cp5 = location_info:new({ text = "Command Point 5", team = NO_TEAM })
location_bluedock = location_info:new({ text = "Blue Docks", team = Team.kBlue })
location_reddock = location_info:new({ text = "Red Docks", team = Team.kRed })
location_blueslime = location_info:new({ text = "Blue Slime", team = Team.kBlue })
location_redslime = location_info:new({ text = "Red Slime", team = Team.kRed })
