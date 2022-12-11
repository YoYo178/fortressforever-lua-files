------------------------------------------------------
-- scrummage_concept.lua v0.9 by Pon.AvD
--
-- Basic functional scrummage Lua
------------------------------------------------------

-- Entities used info:

-- paired arena capture points [trigger_ff_script - brush entities]:
-- 
-- [sp_ctr_1 + sp_ctr_2], [sp_red_1 + sp_red_2], [sp_blue_1 + sp_blue_2]


-- team-owned scrummage capture points [trigger_ff_script - brush entities]:
-- 
-- scrum_red, scrum_blue


-- team-owned teleporters [trigger_teleport - brush entities] - _ctr versions require ownership of central arena to work:
--
-- blue_teleporter, red_teleporter, blue_teleporter_ctr, red_teleporter_ctr


-- warning triggers [trigger_ff_script - brush entities]
--
-- blue_warning, red_warning

-- infinite bags - brush based so needs a model or something to show it's there [trigger_ff_script - brush entities]
--
-- red_infini_bag, blue_infini_bag, centre_infini_bag


-- ADDITIONAL INFORMATION
-- There must be at least one "genericbackpack" based info_ff_script entity placed in your map for this to work.
-- This is due to the normal precache function being shit, and having to use the info_ff_script:precache instead.
-- But, that precache function requires an entity of that type in the map to work!
-- So, add a fucking bag, fool! :D (anything defined in base_teamplay is good)

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay")


-----------------------------------------------------------------------------
-- Global Variables
-----------------------------------------------------------------------------

NEW_ROUND_DELAY = 5
TEAM_POINTS_PER_SCRUMMAGE = 20
TEAM_POINTS_PER_CONTROL_PERIOD = 1
WARNING_REACTIVATE_DELAY = 10
TEAMCALL_REACTIVATE_DELAY = 5

MESSAGE_RED1 = "Calling teammate to UPPER RED Arena!"
MESSAGE_RED2 = "Calling teammate to LOWER RED Arena!"

MESSAGE_BLUE1 = "Calling teammate to UPPER BLUE Arena!"
MESSAGE_BLUE2 = "Calling teammate to LOWER BLUE Arena!"

MESSAGE_CENTRE = "Calling teammate to CENTRAL Arena!"


local scrummage_state = {
	["sp_ctr_1"] = { population = Collection(), message = MESSAGE_CENTRE, textcol = Color.kYellow, sound = "scrum.tnacen" },
	["sp_ctr_2"] = { population = Collection(), message = MESSAGE_CENTRE, textcol = Color.kYellow, sound = "scrum.tnacen" },
	["sp_red_1"] = { population = Collection(), message = MESSAGE_RED1, textcol = Color.kRed, sound = "scrum.tnared" },
	["sp_red_2"] = { population = Collection(), message = MESSAGE_RED2, textcol = Color.kRed, sound = "scrum.tnared" },
	["sp_blue_1"] = { population = Collection(), message = MESSAGE_BLUE1, textcol = Color.kBlue, sound = "scrum.tnablue" },
	["sp_blue_2"] = { population = Collection(), message = MESSAGE_BLUE2, textcol = Color.kBlue, sound = "scrum.tnablue" }
}

-- the two "_base" entries are special cases, and don't count towards total control.
local pair_state = {
	["centre"] = { arena = "centre", controlling_team = Team.kUnassigned, prev_red = "red", prev_blue = "blue", hudposx = 0, hudposy = 36, hudalign = 4, hudwidth = 16, hudheight = 16 },
	["red"] = { arena = "red", controlling_team = Team.kUnassigned, prev_red = "red_base", prev_blue = "centre", hudposx = 30, hudposy = 36, hudalign = 4, hudwidth = 16, hudheight = 16 },
	["blue"] = { arena = "blue", controlling_team = Team.kUnassigned, prev_red = "centre", prev_blue = "blue_base", hudposx = -30, hudposy = 36, hudalign = 4, hudwidth = 16, hudheight = 16 },
	["red_base"] = { arena = "red_base", controlling_team = Team.kRed, prev_red = nil, prev_blue = nil },
	["blue_base"] = { arena = "blue_base", controlling_team = Team.kBlue, prev_red = nil, prev_blue = nil }
}

-- used so that warnings don't get triggered too often
local warnings = {
	[Team.kRed] = { disabled =  false },
	[Team.kBlue] = { disabled =  false },
	["centre"] = { disabled =  false },
	["red"] = { disabled =  false },
	["blue"] = { disabled =  false }
}

local icons = {
	[Team.kBlue] = { teamicon = "hud_cp_blue.vtf" },
	[Team.kRed] = { teamicon = "hud_cp_red.vtf" },
	[Team.kUnassigned] = { teamicon = "hud_cp_neutral.vtf" }
}


-- used so that the scrum cap can't be triggered multiple times during the round reset delay.
local win_state = false


-----------------------------------------------------------------------------
-- Entity Definitions
-----------------------------------------------------------------------------

-- base_scrum_pair is used for each pair of caps.

-- 'self' and 'pair' are used to refer to the scrummage_state array
-- 'team' is just storing the default ownership state 
-- current ownershipt/state is also handled by scrummage_state
base_scrum_pair = trigger_ff_script:new({  })

sp_ctr_1 = base_scrum_pair:new({ name = "sp_ctr_1", partner = "sp_ctr_2", pair = "centre", period_red = 20, period_blue = 20, period_takeover_red = 30, period_takeover_blue = 30 })
sp_ctr_2 = base_scrum_pair:new({ name = "sp_ctr_2", partner = "sp_ctr_1", pair = "centre", period_red = 20, period_blue = 20, period_takeover_red = 30, period_takeover_blue = 30 })

sp_red_1 = base_scrum_pair:new({ name = "sp_red_1", partner = "sp_red_2", pair = "red", period_red = 30, period_blue = 15, period_takeover_red = 0, period_takeover_blue = 20 })
sp_red_2 = base_scrum_pair:new({ name = "sp_red_2", partner = "sp_red_1", pair = "red", period_red = 30, period_blue = 15, period_takeover_red = 0, period_takeover_blue = 20 })

sp_blue_1 = base_scrum_pair:new({ name = "sp_blue_1", partner = "sp_blue_2", pair = "blue", period_red = 15, period_blue = 30, period_takeover_red = 20, period_takeover_blue = 0 })
sp_blue_2 = base_scrum_pair:new({ name = "sp_blue_2", partner = "sp_blue_1", pair = "blue", period_red = 15, period_blue = 30, period_takeover_red = 20, period_takeover_blue = 0 })


-- base_scrum_cap is used only for the single caps in each base.
base_scrum_cap = trigger_ff_script:new({ team = Team.kUnassigned })

scrum_red = base_scrum_cap:new({ team = Team.kRed })
scrum_blue = base_scrum_cap:new({ team = Team.kBlue })


-- team-based teleporters. Uses trigger_teleport in-map.
-- _ctr versions require ownership of the central arena to work
base_teleporter = trigger_ff_script:new({ team = Team.kUnassigned, pair_req = "" })

blue_teleporter = base_teleporter:new({ team = Team.kBlue, pair_req = "blue_base" })
red_teleporter = base_teleporter:new({ team = Team.kRed, pair_req = "red_base" })

blue_teleporter_ctr = base_teleporter:new({ team = Team.kBlue, pair_req = "centre" })
red_teleporter_ctr = base_teleporter:new({ team = Team.kRed, pair_req = "centre" })


-- warning trigger for scrummage button - triggers when someone of the opposite team touches it.

base_warning_trigger = trigger_ff_script:new({ team = Team.kUnassigned, warntext = "" })

blue_warning = base_warning_trigger:new({ team = Team.kBlue, warntext = "BLUE base is under threat!", textcol = Color.kBlue })
red_warning = base_warning_trigger:new({ team = Team.kRed, warntext = "RED base is under threat!", textcol = Color.kRed })


-- Infinite bag, stolen from ff_dm
infini_bag = trigger_ff_script:new({ touchsound = "Backpack.Touch" })

centre_infini_bag = infini_bag:new({ arena = "centre" })
red_infini_bag = infini_bag:new({ arena = "red" })
blue_infini_bag = infini_bag:new({ arena = "blue" })



-----------------------------------------------------------------------------
-- Startup functions (startup/precache etc.)
-----------------------------------------------------------------------------

function startup()
	-- set up team limits (only red & blue)
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kSniper, 1)
	team:SetClassLimit(Player.kEngineer, 2)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kSniper, 1)
	team:SetClassLimit(Player.kEngineer, 2)

end


-----------------------------------------------------------------------------
-- Entity-based functions
-----------------------------------------------------------------------------


function genericbackpack:precache( )
	-- precache sounds
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)

	PrecacheSound("scrum.scrumsoon")
	PrecacheSound("scrum.tnacen")
	PrecacheSound("scrum.tnared")
	PrecacheSound("scrum.tnablue")
	PrecacheSound("scrum.scrummage")
	PrecacheSound("otherteam.flagstolen")
	PrecacheSound("otherteam.flagreturn")
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("otherteam.flagcap")
	PrecacheSound("misc.doop")
	PrecacheSound("misc.buzwarn")
	PrecacheSound("misc.dadeda")

	-- precache models
	PrecacheModel(self.model)
end



-----
-- base_scrum_pair
-----


function base_scrum_pair:ontouch( touch_entity )

	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		local team = player:GetTeamId()
		local takeover = false
		
		-- Checks to see the player doesn't already belong to the owning team
		if team ~= pair_state[self.pair].controlling_team then
			if pair_state[self.pair].controlling_team ~= Team.kUnassigned then
				takeover = true
			end

			-- gets the owning team of the previous arena (in the order of capture for that team)
			local previous_sp_owner = ""

			if team == Team.kBlue then
				previous_sp_owner = pair_state[self.pair].prev_blue
			elseif team == Team.kRed then
				previous_sp_owner = pair_state[self.pair].prev_red
			end

			-- checks to see if the team can capture the scrum pad, if so adds the player to the population of that pad
			if team == pair_state[previous_sp_owner].controlling_team then
				scrummage_state[self.name].population:AddItem( player )
			else
				BroadCastMessageToPlayer(player, "Previous Arena not captured!", 3, scrummage_state[self.name].textcol)
				return
			end
		

			-- checks to see if the pair is owned
			if check_pair_state(self.partner, team) then
				self:oncapture( team, takeover )
			else
				if warnings[self.pair].disabled == false and win_state == false then
					SmartMessage( player, scrummage_state[self.name].message, scrummage_state[self.name].message, "", scrummage_state[self.name].textcol, scrummage_state[self.name].textcol, scrummage_state[self.name].textcol)
					SmartTeamSound( GetTeam(team), scrummage_state[self.name].sound, "")
					warnings[self.pair].disabled = true
					AddSchedule("teamcall_" .. self.pair .. "_reenable", TEAMCALL_REACTIVATE_DELAY, warning_reactivate, self.pair)
				end
			end
				
		end
	end
end


function base_scrum_pair:onendtouch( touch_entity )

	-- removes the player from the population collection
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )

		scrummage_state[self.name].population:RemoveItem( player )
	end
end


function base_scrum_pair:oncapture( team, takeover )

	SmartTeamMessage( GetTeam(team), "Arena Captured!", "Enemy Team captures Arena!", scrummage_state[self.name].textcol, scrummage_state[self.name].textcol)
	pair_state[self.pair].controlling_team = team
	SmartTeamSound( GetTeam(team), "misc.doop", "otherteam.flagstolen")


		
	-- Quick, hacky way of doing this, but fuck it :/

	if team == Team.kBlue then
		RemoveSchedule("period_scoring_blue")
		AddScheduleRepeating("period_scoring_blue", self.period_blue, period_scoring, team)

		if takeover then
			RemoveSchedule("period_scoring_red")
			if self.period_takeover_red ~= 0 then
				AddScheduleRepeating("period_scoring_red", self.period_takeover_red, period_scoring, Team.kRed)
			end
		end
	else
		RemoveSchedule("period_scoring_red")
		AddScheduleRepeating("period_scoring_red", self.period_red, period_scoring, team)

		if takeover then
			RemoveSchedule("period_scoring_blue")
			if self.period_takeover_blue ~= 0 then
				AddScheduleRepeating("period_scoring_blue", self.period_takeover_blue, period_scoring, Team.kBlue)
			end
		end
	end


	

	RemoveHudItemFromAll( self.pair .. "-icon")

	AddHudIconToAll( icons[ pair_state[self.pair].controlling_team ].teamicon , self.pair .. "-icon", pair_state[self.pair].hudposx, pair_state[self.pair].hudposy, pair_state[self.pair].hudwidth, pair_state[self.pair].hudheight, pair_state[self.pair].hudalign)

end


-----
-- base_scrum_cap
-----


function base_scrum_cap:ontouch( touch_entity )


	if win_state ~= true then

		if IsPlayer( touch_entity ) then
			local player = CastToPlayer( touch_entity )
		
			-- determines if the team owns all arena's, and captures the scrum cap if they do.
			if player:GetTeamId() ~= self.team then
				if determine_total_control(player:GetTeamId()) then
					self:oncapture(GetTeam(player:GetTeamId()))
				else
					BroadCastMessageToPlayer(player, "Your team does not own all Arenas!", 3, Color.kWhite)
				end
			end
		end
	end
end


function base_scrum_cap:oncapture(team)

	SmartTeamSound( team, "yourteam.flagcap", "otherteam.flagcap")
	SmartTeamMessage(team, "SCRUM!", "You lose!", Color.kWhite, Color.kWhite)

	RemoveSchedule("period_scoring_blue")
	RemoveSchedule("period_scoring_red")

	AddSchedule("schedulesound_scrummage", 3, scheduled_sound, "scrum.scrummage")
	AddSchedule("round_reset", NEW_ROUND_DELAY, round_reset)

	team:AddScore( TEAM_POINTS_PER_SCRUMMAGE )
	win_state = true
end


-----
-- base_warning_trigger
-----


function base_warning_trigger:ontouch( touch_entity )
	
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )

		if warnings[player:GetTeamId()].disabled == false and win_state == false then
		
			-- determines if the team owns all arena's, and captures the scrum cap if they do.
			if player:GetTeamId() ~= self.team then
				if determine_total_control(player:GetTeamId()) then
					BroadCastSound("scrum.scrumsoon")
					BroadCastMessage(self.warntext, 3, self.textcol)
					warnings[player:GetTeamId()].disabled = true
					AddSchedule("warning_" .. player:GetTeamId() .. "_reenable", WARNING_REACTIVATE_DELAY, warning_reactivate, player:GetTeamId())
				end
			end
		end
	end

end


-----
-- base_teleporter
-----


function base_teleporter:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		-- return true if the player is on the right team
		if player:GetTeamId() == self.team and player:GetTeamId() == pair_state[self.pair_req].controlling_team then 
			return EVENT_ALLOWED
		end

	end
	return EVENT_DISALLOWED
end


-----
-- infini_bag
-----


function infini_bag:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		-- 400 for overkill. of course the values
		-- get clamped in game code
		player:AddHealth( 400 )
		player:AddArmor( 400 )

		player:AddAmmo( Ammo.kNails, 400 )
		player:AddAmmo( Ammo.kShells, 400 )
		player:AddAmmo( Ammo.kRockets, 400 )
		player:AddAmmo( Ammo.kCells, 400 )

		-- Not required? Uncomment if wanted I guess.

		-- player:AddAmmo( Ammo.kDetpack, 1 )
		-- player:AddAmmo( Ammo.kManCannon, 1 )
		-- player:AddAmmo( Ammo.kGren1, 4 )
		-- player:AddAmmo( Ammo.kGren2, 4 )

		-- Play the touch sound
		player:EmitSound( self.touchsound )
	end
end


function infini_bag:allowed( allowed_entity )
-- teamchecking stuff
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		return player:GetTeamId() == pair_state[self.arena].controlling_team
	end

	return false
end


-----------------------------------------------------------------------------
-- Regular functions
-----------------------------------------------------------------------------


function determine_total_control (team)
	
	-- determines if the same team owns all 3 arena's
	if pair_state["centre"].controlling_team == team and pair_state["red"].controlling_team == team and pair_state["blue"].controlling_team == team then
		return true
	else 
		return false
	end
end


function check_pair_state(paired_scrumpad, team)

	-- checks if a given pair of scrum pads are both being activated at the same time.
	if  scrummage_state[paired_scrumpad].population:IsEmpty() then
		return false
	else
		for temp in scrummage_state[paired_scrumpad].population.items do
			local player = CastToPlayer(temp)

			if player:GetTeamId() == team then
				return true
			end
		end
	end

	return false

end


-----------------------------------------------------------------------------
-- Flaginfo function
-----------------------------------------------------------------------------

-- This sets up the HUD to the current state when people connect.
function flaginfo( player_entity )

	local player = CastToPlayer( player_entity )

	AddHudIcon( player, icons[ pair_state["blue"].controlling_team ].teamicon, pair_state["blue"].arena .. "-icon", pair_state["blue"].hudposx, pair_state["blue"].hudposy, pair_state["blue"].hudwidth, pair_state["blue"].hudheight, pair_state["blue"].hudalign)
	AddHudIcon( player, icons[ pair_state["centre"].controlling_team ].teamicon, pair_state["centre"].arena .. "-icon", pair_state["centre"].hudposx, pair_state["centre"].hudposy, pair_state["centre"].hudwidth, pair_state["centre"].hudheight, pair_state["centre"].hudalign)
	AddHudIcon( player, icons[ pair_state["red"].controlling_team ].teamicon, pair_state["red"].arena .. "-icon", pair_state["red"].hudposx, pair_state["red"].hudposy, pair_state["red"].hudwidth, pair_state["red"].hudheight, pair_state["red"].hudalign)

end


-----------------------------------------------------------------------------
-- Scheduled functions
-----------------------------------------------------------------------------


function round_reset()

	-- Just resets everything to the defaults and respawns/cleans up
	scrummage_state["sp_ctr_1"].population:RemoveAllItems()
	scrummage_state["sp_ctr_2"].population:RemoveAllItems()
	scrummage_state["sp_red_1"].population:RemoveAllItems()
	scrummage_state["sp_red_2"].population:RemoveAllItems()
	scrummage_state["sp_blue_1"].population:RemoveAllItems()
	scrummage_state["sp_blue_2"].population:RemoveAllItems()
	
	pair_state["centre"].controlling_team = Team.kUnassigned
	pair_state["red"].controlling_team = Team.kUnassigned
	pair_state["blue"].controlling_team = Team.kUnassigned

	RemoveHudItemFromAll( "centre-icon")
	RemoveHudItemFromAll( "red-icon")
	RemoveHudItemFromAll( "blue-icon")

	ApplyToAll( { AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips } )

	win_state = false

	AddHudIconToAll( icons[ pair_state["blue"].controlling_team ].teamicon , pair_state["blue"].arena .. "-icon", pair_state["blue"].controlling_team.hudposx, pair_state["blue"].controlling_team.hudposy, pair_state["blue"].controlling_team.hudwidth, pair_state["blue"].controlling_team.hudheight, pair_state["blue"].controlling_team.hudalign)
	AddHudIconToAll( icons[ pair_state["red"].controlling_team ].teamicon , pair_state["red"].arena .. "-icon", pair_state["red"].controlling_team.hudposx, pair_state["red"].controlling_team.hudposy, pair_state["red"].controlling_team.hudwidth, pair_state["red"].controlling_team.hudheight, pair_state["red"].controlling_team.hudalign)
	AddHudIconToAll( icons[ pair_state["centre"].controlling_team ].teamicon , pair_state["centre"].arena .. "-icon", pair_state["centre"].controlling_team.hudposx, pair_state["centre"].controlling_team.hudposy, pair_state["centre"].controlling_team.hudwidth, pair_state["centre"].controlling_team.hudheight, pair_state["centre"].controlling_team.hudalign)
end


function warning_reactivate( id )

	warnings[id].disabled = false
	
end

function scheduled_sound( sound )
	BroadCastSound(sound)
end

function period_scoring( team )
	GetTeam(team):AddScore(TEAM_POINTS_PER_CONTROL_PERIOD)
end