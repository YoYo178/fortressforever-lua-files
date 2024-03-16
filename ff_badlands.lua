
-- ff_badlands.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_ctf")
IncludeScript("base_teamplay")
IncludeScript("base_location")
IncludeScript("base_respawnturret")

location_blue_sniper_towers = location_info:new({ text = "Sniper Towers", team = Team.kBlue })
location_red_sniper_towers = location_info:new({ text = "Sniper Towers", team = Team.kRed })

location_blue_canyon_pipe = location_info:new({ text = "Short Pipe", team = Team.kBlue })
location_red_canyon_pipe = location_info:new({ text = "Short Pipe", team = Team.kRed })

location_blue_bridge_ramp = location_info:new({ text = "Central Bridge Ramp", team = Team.kBlue })
location_red_bridge_ramp = location_info:new({ text = "Central Bridge Ramp", team = Team.kRed })

location_blue_lower_canyon = location_info:new({ text = "Lower Base Canyon", team = Team.kBlue })
location_red_lower_canyon = location_info:new({ text = "Lower Base Canyon", team = Team.kRed })

location_blue_upper_canyon = location_info:new({ text = "Upper Base Canyon", team = Team.kBlue })
location_red_upper_canyon = location_info:new({ text = "Upper Base Canyon", team = Team.kRed })

location_blue_sniper_decks = location_info:new({ text = "Sniper Decks", team = Team.kBlue })
location_red_sniper_decks = location_info:new({ text = "Sniper Decks", team = Team.kRed })

location_blue_flagpit = location_info:new({ text = "Flag Pipe", team = Team.kBlue })
location_red_flagpit = location_info:new({ text = "Flag Pipe", team = Team.kRed })

location_blue_tunnel = location_info:new({ text = "Tunnel", team = Team.kBlue })
location_red_tunnel = location_info:new({ text = "Tunnel", team = Team.kRed })

location_blue_sidehall = location_info:new({ text = "Side Hall", team = Team.kBlue })
location_red_sidehall = location_info:new({ text = "Side Hall", team = Team.kRed })

location_blue_flagexit = location_info:new({ text = "Main Flag Exit", team = Team.kBlue })
location_red_flagexit = location_info:new({ text = "Main Flag Exit", team = Team.kRed })

location_blue_spiral = location_info:new({ text = "Spiral Stairs", team = Team.kBlue })
location_red_spiral = location_info:new({ text = "Spiral Stairs", team = Team.kRed })

location_blue_sniper_hall = location_info:new({ text = "Sniper Hall", team = Team.kBlue })
location_red_sniper_hall = location_info:new({ text = "Sniper Hall", team = Team.kRed })

location_blue_rocktunnel = location_info:new({ text = "Rock Hall", team = Team.kBlue })
location_red_rocktunnel = location_info:new({ text = "Rock Hall", team = Team.kRed })

location_blue_sidehall = location_info:new({ text = "Side Hall", team = Team.kBlue })
location_red_sidehall = location_info:new({ text = "Side Hall", team = Team.kRed })

location_blue_upper_hall = location_info:new({ text = "Upper Hall", team = Team.kBlue })
location_red_upper_hall = location_info:new({ text = "Upper Hall", team = Team.kRed })

location_blue_resupply = location_info:new({ text = "Resupply", team = Team.kBlue })
location_red_resupply = location_info:new({ text = "Resupply", team = Team.kRed })

location_blue_sidehall = location_info:new({ text = "Side Hall", team = Team.kBlue })
location_red_sidehall = location_info:new({ text = "Side Hall", team = Team.kRed })

location_blue_flagexit2 = location_info:new({ text = "Alternative Flag Exit", team = Team.kBlue })
location_red_flagexit2 = location_info:new({ text = "Alternative Flag Exit", team = Team.kRed })

location_blue_flagroom = location_info:new({ text = "Flag Room", team = Team.kBlue })
location_red_flagroom = location_info:new({ text = "Flag Room", team = Team.kRed })

location_blue_sidehall = location_info:new({ text = "Side Hall", team = Team.kBlue })
location_red_sidehall = location_info:new({ text = "Side Hall", team = Team.kRed })

location_blue_pipe = location_info:new({ text = "Pipe", team = Team.kBlue })
location_red_pipe = location_info:new({ text = "Pipe", team = Team.kRed })

location_neutral_canyon = location_info:new({ text = "Main Canyon", team = NO_TEAM })
location_neutral_bridge = location_info:new({ text = "Central Bridge", team = NO_TEAM })


redsniperspawn = { validspawn = redsniperallowedmethod }
bluesniperspawn = { validspawn = bluesniperallowedmethod }

-----------------------------------------------------------------------------
-- Class Spawn functions
-----------------------------------------------------------------------------

redsniperallowedmethod = function(self,player) return player:GetTeamId() == Team.kRed and player:GetClass() == Player.kSniper end
bluesniperallowedmethod = function(self,player) return player:GetTeamId() == Team.kBlue and player:GetClass() == Player.kSniper end

rednosniperallowedmethod = function(self,player) return player:GetTeamId() == Team.kRed and (player:GetClass() == Player.kSniper) == false end
bluenosniperallowedmethod = function(self,player) return player:GetTeamId() == Team.kBlue and (player:GetClass() == Player.kSniper) == false end


red_sniper_spawn = { validspawn = redsniperallowedmethod }
blue_sniper_spawn = { validspawn = bluesniperallowedmethod }

red_spawn = { validspawn = rednosniperallowedmethod }
blue_spawn = { validspawn = bluenosniperallowedmethod }


-----------------------------------------------------------------------------
-- Class Door Triggers
-----------------------------------------------------------------------------
classrespawndoor = trigger_ff_script:new({ team = Team.kUnassigned, class = false })

function classrespawndoor:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		
		local player = CastToPlayer( allowed_entity )
		
		if player:GetClass() == self.class and player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

function classrespawndoor:onfailtouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer( player, "#FF_NOTALLOWEDDOOR" )
	end
end

bluesniperrespawndoor = classrespawndoor:new({ team = Team.kBlue, class = Player.kSniper })
redsniperrespawndoor = classrespawndoor:new({ team = Team.kRed, class = Player.kSniper })

-----------------------------------------------------------------------------
-- Badlands Backpacks -- Canyon Bags
-----------------------------------------------------------------------------
-- ammo_shells 50 ammo_cells 50 ammo_rockets 5 ammo_nails 50 armorvalue 30 health 15
-----------------------------------------------------------------------------

canyonbag = genericbackpack:new({
	grenades = 20,
	bullets = 50,
	nails = 50,
	shells = 50,
	rockets = 5,
	cells = 50,
	armor = 30,
	healt = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

-----------------------------------------------------------------------------
-- Badlands Backpacks -- Canyon Bridge Bag
-----------------------------------------------------------------------------
-- ammo_shells 50 ammo_cells 50 ammo_rockets 20 ammo_nails 50 armorvalue 10 health 10
-----------------------------------------------------------------------------

canyonbridgebag = genericbackpack:new({
	grenades = 20,
	bullets = 50,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 50,
	armor = 10,
	health = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

-----------------------------------------------------------------------------
-- Badlands Backpacks -- Front of Base Bag
-----------------------------------------------------------------------------
-- ammo_medkit 20 ammo_shells 50 ammo_cells 150 ammo_rockets 20 ammo_nails 50 armorvalue 100 health 25 team only
-----------------------------------------------------------------------------

basefrontbag = genericbackpack:new({
	grenades = 20,
	bullets = 50,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 50,
	armor = 10,
	health = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

red_basefrontbag = basefrontbag:new({touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}})
blue_basefrontbag = basefrontbag:new({touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}})
-----------------------------------------------------------------------------
-- Badlands Backpacks -- Flag Exit Bag
-----------------------------------------------------------------------------
-- ammo_shells 50 ammo_cells 150 ammo_rockets 20 ammo_nails 50 armorvalue 100 health 25 team only
-----------------------------------------------------------------------------

flagexitbag = genericbackpack:new({
	grenades = 20,
	bullets = 50,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 150,
	armor = 100,
	health = 25,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
red_flagexitbag  = flagexitbag:new({touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}})
blue_flagexitbag  = flagexitbag:new({touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}})

-----------------------------------------------------------------------------
-- Badlands Backpacks -- Flagroom Bag
-----------------------------------------------------------------------------
-- ammo_shells 50 ammo_cells 75 ammo_rockets 20 ammo_nails 50 armorvalue 100 health 25 team only
-----------------------------------------------------------------------------

flagroombag = genericbackpack:new({
	grenades = 20,
	bullets = 50,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 50,
	armor = 100,
	health = 25,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
red_flagroombag = flagroombag:new({touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}})
blue_flagroombag = flagroombag:new({touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}})

-----------------------------------------------------------------------------
-- Badlands Backpacks -- Resupply Bag
-----------------------------------------------------------------------------
-- ammo_shells 50 ammo_cells 50 ammo_rockets 20 ammo_nails 50 armorvalue 100 health 50 grenades_1 2 grenades_2 2 team only
-----------------------------------------------------------------------------

resupplybag = genericbackpack:new({
	grenades = 20,
	bullets = 50,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 50,
	armor = 100,
	health = 50,
	gren1 = 2,
	gren2 = 2,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
red_resupplybag = resupplybag:new({touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}})
blue_resupplybag = resupplybag:new({touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}})

-----------------------------------------------------------------------------
-- Badlands Backpacks -- Sniper Bag
-----------------------------------------------------------------------------
-- ammo_medkit 20 ammo_shells 50 ammo_cells 100 ammo_rockets 20 ammo_nails 50 armorvalue 100 health 25 team only
-----------------------------------------------------------------------------

sniperbag = genericbackpack:new({
	grenades = 20,
	bullets = 50,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 50,
	armor = 100,
	health = 25,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
red_sniperbag = sniperbag:new({touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}})
blue_sniperbag = sniperbag:new({touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}})


