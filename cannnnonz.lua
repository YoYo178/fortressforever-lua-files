-----------------------------------------------------------------------------
-- cannnnonz.lua
-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base_ctf")
IncludeScript("base_location")
IncludeScript("base_respawnturret")

-----------------------------------------------------------------------------
-- Backpacks
-----------------------------------------------------------------------------

ff_cannnnonz_genericpack = genericbackpack:new({
	health           = 400,
	armor            = 400,

	grenades         = 400,
	nails            = 400,
	shells           = 400,
	rockets          = 400,
	cells            = 400,

	respawntime      = 10,
	model            = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound       = "Backpack.Touch",
	botgoaltype      = Bot.kBackPack_Ammo
})

function ff_cannnnonz_genericpack:dropatspawn() return false end

blue_cannnnonz_genericpack = ff_cannnnonz_genericpack:new({
	touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_cannnnonz_genericpack  = ff_cannnnonz_genericpack:new({
	touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

ff_cannnnonz_grenpack      = genericbackpack:new({
	health           = 400,
	armor            = 400,

	grenades         = 400,
	nails            = 400,
	shells           = 400,
	rockets          = 400,
	cells            = 400,

	gren1            = 2,
	gren2            = 2,

	respawntime      = 2,
	model            = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound       = "Backpack.Touch",
	botgoaltype      = Bot.kBackPack_Ammo
})

function ff_cannnnonz_grenpack:dropatspawn() return false end

blue_cannnnonz_grenpack = ff_cannnnonz_grenpack:new({
	touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_cannnnonz_grenpack  = ff_cannnnonz_grenpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

-----------------------------------------------------------------------------
-- aardvark resupply (bagless)
-----------------------------------------------------------------------------
aardvarkresup           = trigger_ff_script:new({ team = Team.kUnassigned })

function aardvarkresup:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		if player:GetTeamId() == self.team then
			player:AddHealth(400)
			player:AddArmor(400)
			player:AddAmmo(Ammo.kNails, 400)
			player:AddAmmo(Ammo.kShells, 400)
			player:AddAmmo(Ammo.kRockets, 400)
			player:AddAmmo(Ammo.kCells, 400)
		end
	end
end

blue_aardvarkresup         = aardvarkresup:new({ team = Team.kBlue })
red_aardvarkresup          = aardvarkresup:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

location_blue_upper_bments = location_info:new({ text = "Upper Battlements", team = Team.kBlue })
location_blue_lower_bments = location_info:new({ text = "Lower Front Door", team = Team.kBlue })
location_blue_ramp_room    = location_info:new({ text = "Ramp Room", team = Team.kBlue })
location_blue_spawn        = location_info:new({ text = "Blue Spawn", team = Team.kBlue })
location_blue_mid_route    = location_info:new({ text = "Middle Connector", team = Team.kBlue })
location_blue_side_route   = location_info:new({ text = "Side Connector", team = Team.kBlue })
location_blue_upper_route  = location_info:new({ text = "Upper Connector", team = Team.kBlue })
location_blue_flag_room    = location_info:new({ text = "Flag Room", team = Team.kBlue })

location_red_upper_bments  = location_info:new({ text = "Upper Battlements", team = Team.kRed })
location_red_lower_bments  = location_info:new({ text = "Lower Front Door", team = Team.kRed })
location_red_ramp_room     = location_info:new({ text = "Ramp Room", team = Team.kRed })
location_red_spawn         = location_info:new({ text = "Red Spawn", team = Team.kRed })
location_red_mid_route     = location_info:new({ text = "Middle Connector", team = Team.kRed })
location_red_side_route    = location_info:new({ text = "Side Connector", team = Team.kRed })
location_red_upper_route   = location_info:new({ text = "Upper Connector", team = Team.kRed })
location_red_flag_room     = location_info:new({ text = "Flag Room", team = Team.kRed })

location_midmap            = location_info:new({ text = "Midmap", team = Team.kUnassigned })
-----------------------------------------------------------------------------
-- respawn shields
-----------------------------------------------------------------------------

KILL_KILL_KILL             = trigger_ff_script:new({ team = Team.kUnassigned })

function KILL_KILL_KILL:allowed(activator)
	local player = CastToPlayer(activator)
	if player then
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

blue_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })
red_slayer  = KILL_KILL_KILL:new({ team = Team.kRed })
