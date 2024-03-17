-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_cp_default")
IncludeScript("base_cp_sequential")

-----------------------------------------------------------------------------
--Globals
-----------------------------------------------------------------------------

POINTS_FOR_COMPLETE_CONTROL = 25

-----------------------------------------------------------------------------
-- event outputs
-----------------------------------------------------------------------------

function event_StartTouchingCC( entity, cc_team_number )
	return
end

function event_StopTouchingCC( entity, cc_team_number )
	return
end

function event_ChangeCPDefendingTeam( cp_number, new_defending_team )
	-- Change the skybeam and groundbeam color
	OutputEvent( "cp" .. cp_number .. "_groundbeam", "Color", team_info[new_defending_team].skybeam_color )
	OutputEvent( "cp" .. cp_number .. "_skybeam", "Color", team_info[new_defending_team].skybeam_color )
end

function event_ResetTeamCPCapping( cp, team_number )
	OutputEvent( "cp" .. cp.cp_number .. "_" .. team_info[team_number].team_name .. "_beam", "TurnOff" )
	OutputEvent( "cp" .. cp.cp_number .. "_capsound", "StopSound" )
end

function event_StartTeamCPCapping( cp, team_number )
	OutputEvent( "cp" .. cp.cp_number .. "_" .. team_info[team_number].team_name .. "_beam", "TurnOn" )
	OutputEvent( "cp" .. cp.cp_number .. "_capsound", "PlaySound" )
end


team_info = {

	[Team.kUnassigned] = {
		team_name = "neutral",
		enemy_team = Team.kUnassigned,
		objective_icon = nil,
		touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen },
		skybeam_color = "128 128 128",
		respawnbeam_color = { [0] = 100, [1] = 100, [2] = 100 },
		color_index = 1,
		skin = "0",
		flag_visibility = "TurnOff",
		cc_touch_count = 0,
		ccalarmicon = "hud_secdown.vtf", ccalarmiconx = 0, ccalarmicony = 0, ccalarmiconwidth = 16, ccalarmiconheight = 16, ccalarmiconalign = 2,
		detcc_sentence = "HTD_DOORS",
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
		}
	},

	[TEAM1] = {
		team_name = "blue",
		enemy_team = TEAM2,
		objective_icon = nil,
		touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue },
		skybeam_color = "64 64 255",
		respawnbeam_color = { [0] = 100, [1] = 100, [2] = 100 },
		color_index = 2,
		skin = "0",
		flag_visibility = "TurnOn",
		cc_touch_count = 0,
		ccalarmicon = "hud_secup_blue.vtf", ccalarmiconx = 60, ccalarmicony = 5, ccalarmiconwidth = 16, ccalarmiconheight = 16, ccalarmiconalign = 2,
		detcc_sentence = "CZ_BCC_DET",
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
		}
	},

	[TEAM2] = {
		team_name = "red",
		enemy_team = TEAM1,
		objective_icon = nil,
		touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed },
		skybeam_color = "255 64 64",
		respawnbeam_color = { [0] = 100, [1] = 100, [2] = 100 },
		color_index = 0,
		skin = "1",
		flag_visibility = "TurnOn",
		cc_touch_count = 0,
		ccalarmicon = "hud_secup_red.vtf", ccalarmiconx = 60, ccalarmicony = 5, ccalarmiconwidth = 16, ccalarmiconheight = 16, ccalarmiconalign = 3,
		detcc_sentence = "CZ_RCC_DET",
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
		}
	}
}

-----------------------------------------------------------------------------
-- spawn
-----------------------------------------------------------------------------

function player_spawn( player_entity )

	local player = CastToPlayer( player_entity )
	
	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:AddAmmo( Ammo.kManCannon, 1 )
	
	-- MUSHY SAYS NO DETPACKS
	player:RemoveAmmo( Ammo.kDetpack, 1 )
	
	ConsoleToAll("OB: "..team_info[player:GetTeamId()].objective_icon )
	UpdateObjectiveIcon( player, team_info[player:GetTeamId()].objective_icon )

end

-----------------------------------------------------------------------------
-- bags
-----------------------------------------------------------------------------

gen_pack = genericbackpack:new({
	health = 30,
	armor = 30,
	grenades = 20,
	nails = 50,
	shells = 300,
	rockets = 15,
	gren1 = 1,
	gren2 = 0,
	cells = 120,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"})

function gen_pack:dropatspawn() return false 
end

-----------------------------------------------------------------------------
-- overrides
-----------------------------------------------------------------------------

-- teleporting
ENABLE_CC_TELEPORTERS = false
ENABLE_CP_TELEPORTERS = false

-- command center
ENABLE_CC = false

-- command points
CP_COUNT = 3

command_points = {
		[1] = { cp_number = 1, defending_team = Team.kUnassigned, cap_requirement = { [TEAM1] = 1000, [TEAM2] = 1000 }, cap_status = { [TEAM1] = 0, [TEAM2] = 0 }, cap_speed = { [TEAM1] = 0, [TEAM2] = 0 }, next_cap_zone_timer = { [TEAM1] = 0, [TEAM2] = 0 }, delay_before_retouch = { [TEAM1] = 4.0, [TEAM2] = 4.0 }, touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, former_touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, point_value = { [TEAM1] = 1, [TEAM2] = 5 }, score_timer_interval = { [TEAM1] = 30.00, [TEAM2] = 15.00 }, hudstatusicon = "hud_cp_1.vtf", hudposx = -40, hudposy = 56, hudalign = 4, hudwidth = 16, hudheight = 16 },
		[2] = { cp_number = 2, defending_team = Team.kUnassigned, cap_requirement = { [TEAM1] = 1000, [TEAM2] = 1000 }, cap_status = { [TEAM1] = 0, [TEAM2] = 0 }, cap_speed = { [TEAM1] = 0, [TEAM2] = 0 }, next_cap_zone_timer = { [TEAM1] = 0, [TEAM2] = 0 }, delay_before_retouch = { [TEAM1] = 4.0, [TEAM2] = 4.0 }, touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, former_touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, point_value = { [TEAM1] = 3, [TEAM2] = 3 }, score_timer_interval = { [TEAM1] = 22.50, [TEAM2] = 22.50 }, hudstatusicon = "hud_cp_2.vtf", hudposx =   0, hudposy = 56, hudalign = 4, hudwidth = 16, hudheight = 16 },
	 [CP_COUNT] = { cp_number = 3, defending_team = Team.kUnassigned, cap_requirement = { [TEAM1] = 1000, [TEAM2] = 1000 }, cap_status = { [TEAM1] = 0, [TEAM2] = 0 }, cap_speed = { [TEAM1] = 0, [TEAM2] = 0 }, next_cap_zone_timer = { [TEAM1] = 0, [TEAM2] = 0 }, delay_before_retouch = { [TEAM1] = 4.0, [TEAM2] = 4.0 }, touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, former_touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, point_value = { [TEAM1] = 5, [TEAM2] = 1 }, score_timer_interval = { [TEAM1] = 15.00, [TEAM2] = 30.00 }, hudstatusicon = "hud_cp_3.vtf", hudposx =  40, hudposy = 56, hudalign = 4, hudwidth = 16, hudheight = 16 }
}


-- cap sounds based on control count
good_cap_sounds = {
		[1] = "misc.bloop",
		[2] = "misc.doop",
	 [CP_COUNT] = "yourteam.flagcap"
}

bad_cap_sounds = {
		[1] = "misc.deeoo",
		[2] = "misc.dadeda",
	 [CP_COUNT] = "otherteam.flagcap"
}

cap_resupply = {
	health = 100,
	armor = 300,
	nails = 400,
	shells = 400,
	cells = 400,
	grenades = 100,
	rockets = 50,
	detpacks = 0,
	mancannons = 1,
	gren1 = 2,
	gren2 = 1
}

