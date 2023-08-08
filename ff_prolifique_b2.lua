-- ff_prolifique.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base_ctf")
IncludeScript("base_location")
IncludeScript("base_respawnturret")

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------

POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60

function startup()
	SetGameDescription("Capture the Flag")
	
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	-- CTF maps generally don't have civilians,
	-- so override in map LUA file if you want 'em
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
end

-----------------------------------------------------------------------------
-- Backpacks
-----------------------------------------------------------------------------

ff_prolif_genericpack = genericbackpack:new({
	health = 25,
	armor = 25,
	
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 100,
	
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_prolif_genericpack:dropatspawn() return false end
blue_prolif_genericpack = ff_prolif_genericpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_prolif_genericpack = ff_prolif_genericpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

ff_prolif_grenpack = genericbackpack:new({
	health = 400,
	armor = 400,
	
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 400,
	
	gren1 = 2,
	gren2 = 2,
	
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_prolif_grenpack:dropatspawn() return false end
blue_prolif_grenpack = ff_prolif_grenpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_prolif_grenpack = ff_prolif_grenpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

location_blue_upper_bments	= location_info:new({ text = "Upper Battlements", team = Team.kBlue })

location_blue_lower_bments	= location_info:new({ text = "Lower Front Door", team = Team.kBlue })

location_blue_ramp_room		= location_info:new({ text = "Ramp Room", team = Team.kBlue })

location_blue_spawn	= location_info:new({ text = "Blue Spawn", team = Team.kBlue })

location_blue_mid_route	= location_info:new({ text = "Middle Connector", team = Team.kBlue })

location_blue_side_route	= location_info:new({ text = "Side Connector", team = Team.kBlue })

location_blue_upper_route	= location_info:new({ text = "Upper Connector", team = Team.kBlue })

location_blue_flag_room		= location_info:new({ text = "Flag Room", team = Team.kBlue })

location_red_upper_bments	= location_info:new({ text = "Upper Battlements", team = Team.kRed })

location_red_lower_bments	= location_info:new({ text = "Lower Front Door", team = Team.kRed })

location_red_ramp_room		= location_info:new({ text = "Ramp Room", team = Team.kRed })

location_red_spawn	= location_info:new({ text = "Red Spawn", team = Team.kRed })

location_red_mid_route	= location_info:new({ text = "Middle Connector", team = Team.kRed })

location_red_side_route	= location_info:new({ text = "Side Connector", team = Team.kRed })

location_red_upper_route	= location_info:new({ text = "Upper Connector", team = Team.kRed })

location_red_flag_room		= location_info:new({ text = "Flag Room", team = Team.kRed })

location_midmap	= location_info:new({ text = "Midmap", team = Team.kUnassigned })

-----------------------------------------------------------------------------
-- respawn shields
-----------------------------------------------------------------------------

KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })

function KILL_KILL_KILL:allowed( activator )
	local player = CastToPlayer( activator )
	if player then
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

blue_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })
red_slayer = KILL_KILL_KILL:new({ team = Team.kRed })
