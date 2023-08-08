-- ff_asti.lua

-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay")
IncludeScript("base_id")
IncludeScript("base_location")
IncludeScript("base_respawnturret")

-----------------------------------------------------------------------------
-- overrides
-----------------------------------------------------------------------------
POINTS_PER_PERIOD = 5
NUM_PHASES = 3
FLAG_RETURN_TIME = 30

-----------------------------------------------------------------------------
-- locations
-----------------------------------------------------------------------------
location_ospawn = location_info:new({ text = "Attacker Spawn", team = NO_TEAM })
location_alley = location_info:new({ text = "Grenade Alley", team = NO_TEAM })
location_cp1 = location_info:new({ text = "Main Road - CP1", team = NO_TEAM })
location_uproad = location_info:new({ text = "Box Warehouse Road", team = NO_TEAM })
location_sroad = location_info:new({ text = "Asti Plaza Road", team = NO_TEAM })
location_cp2 = location_info:new({ text = "Asti Show Lounge - CP2", team = NO_TEAM })
location_froad = location_info:new({ text = "Grenade Factory Road", team = NO_TEAM })
location_cp3l = location_info:new({ text = "FF Building - Lower", team = NO_TEAM })
location_cp3 = location_info:new({ text = "FF Building - Upper - CP3", team = NO_TEAM })
location_box = location_info:new({ text = "Box Warehouse", team = NO_TEAM })
location_dspawn = location_info:new({ text = "Defense Spawn", team = NO_TEAM })

-----------------------------------------------------------------------------
-- backpacks
-----------------------------------------------------------------------------
astipack = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 25,
	shells = 50,
	nails = 50,
	rockets = 25,
	cells = 100,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed}
})

function astipack:dropatspawn() return false 
end

astigren = genericbackpack:new({
	health = 50,
	armor = 100,
	grenades = 20,
	shells = 50,
	nails = 75,
	rockets = 10,
	cells = 100,
	gren1 = 2,
	gren2 = 1,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed}
})
	if dispensed >= 1 then
                        BroadCastMessageToPlayer( player, "Got grenades!" )
			local backpack = CastToInfoScript(entity);
			if (backpack ~= nil) then
				backpack:EmitSound(self.touchsound);
				backpack:Respawn(self.respawntime);
			end
		end

function astigren:dropatspawn() return false 
end

-----------------------------------------------------------------------------
-- respawn turrets
-----------------------------------------------------------------------------
turret_a = base_respawnturret:new({ team = Attackers })
turret_d = base_respawnturret:new({ team = Defenders })