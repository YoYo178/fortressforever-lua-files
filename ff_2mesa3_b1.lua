IncludeScript("base_ctf")
IncludeScript("base_location")

FLAG_RETURN_TIME = 45

---------------------------------
-- Packs
---------------------------------

blue_health = blue_healthkit
blue_armor = blue_armorkit:new({ modelskin = 0 })
blue_ammo = blue_ammobackpack
blue_nades = blue_grenadebackpack
blue_bmentsarmor = armorkit:new({ modelskin = 0 })
blue_bmentshealth = healthkit
red_health = red_healthkit
red_armor = red_armorkit:new({ modelskin = 1 })
red_ammo = red_ammobackpack
red_nades = red_grenadebackpack
red_bmentsarmor = armorkit:new({ modelskin = 1 })
red_bmentshealth = healthkit

bmentsnades = genericbackpack:new({
	grenades = 20,
	bullets = 50,
	nails = 50,
	shells = 50,
	rockets = 20,
	gren1 = 1,
	gren2 = 1,
	cells = 50,
    	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen},
	botgoaltype = Bot.kBackPack_Ammo
})

red_bmentsnades = bmentsnades:new({ })
blue_bmentsnades = bmentsnades:new({ })

-----------------------------------------------------------------------------------------------------------------------------
-- FrontLine Pack 
-----------------------------------------------------------------------------------------------------------------------------
blue_len_soldier = genericbackpack:new({
	
	health = 30,
	armor = 30,
	
	nails = 50,
	shells = 50,
	rockets = 50,
	cells = 50,
	
	gren1 = 1,
	gren2 = 0,
	
	respawntime = 25,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}

})
function blue_len_soldier:dropatspawn() return false end

red_len_soldier = genericbackpack:new({
	
	health = 30,
	armor = 30,
	
	nails = 50,
	shells = 50,
	rockets = 50,
	cells = 50,
	
	gren1 = 1,
	gren2 = 0,
	
	respawntime = 25,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}

})
function red_len_soldier:dropatspawn() return false end

-----------------------------------------------------------------------------------------------------------------------------
-- Lasers are cool
-----------------------------------------------------------------------------------------------------------------------------

hurt = trigger_ff_script:new({ team = Team.kUnassigned })
function hurt:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

red_laser_hurt = hurt:new({ team = Team.kBlue })
blue_laser_hurt = hurt:new({ team = Team.kRed })



