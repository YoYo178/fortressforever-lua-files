
-- ff_flare.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_ctf");
IncludeScript("base_location");
IncludeScript("base_respawnturret");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 60;


-----------------------------------------------------------------------------
-- doors
-----------------------------------------------------------------------------

blue_tri_door2 = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_tri_door2:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_tri_door2:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_door_2", "Open") 
   end 
end 

blue_tri_door1 = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_tri_door1:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_tri_door1:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_door_1", "Open") 
   end 
end 

red_tri_door2 = trigger_ff_script:new({ team = Team.kRed }) 

function red_tri_door2:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_tri_door2:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_door_2", "Open") 
   end 
end 

red_tri_door1 = trigger_ff_script:new({ team = Team.kRed }) 

function red_tri_door1:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_tri_door1:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_door_1", "Open") 
   end 
end 

-----------------------------------------------------------------------------
-- locations
-----------------------------------------------------------------------------

loc_upper_base_red = location_info:new({ text = "upper base", team = Team.kRed })
loc_lower_base_red = location_info:new({ text = "lower base", team = Team.kRed })
loc_frontbase_red = location_info:new({ text = "front base", team = Team.kRed })
loc_fr_red = location_info:new({ text = "flag room", team = Team.kRed })
loc_airlift_red = location_info:new({ text = "airlift", team = Team.kRed })

loc_upper_base_blue = location_info:new({ text = "upper base", team = Team.kBlue })
loc_lower_base_blue = location_info:new({ text = "lower base", team = Team.kBlue })
loc_frontbase_blue = location_info:new({ text = "front base", team = Team.kBlue })
loc_fr_blue = location_info:new({ text = "flag room", team = Team.kBlue })
loc_airlift_blue = location_info:new({ text = "airlift", team = Team.kBlue })

------------------------------------------------------------------------------
-- fr backpacks
------------------------------------------------------------------------------

bigpack2 = genericbackpack:new({
	health = 40,
	armor = 40,
	grenades = 50,
	bullets = 150,
	nails = 0,
	shells = 50,
	rockets = 20,
	cells = 200,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function bigpack2:dropatspawn() return false end

-----------------------------------------------------------------------------
-- backpack entity setup 
-----------------------------------------------------------------------------
function build_backpacks(tf)
	return healthkit:new({touchflags = tf}),
		   armorkit:new({touchflags = tf}),
		   ammobackpack:new({touchflags = tf}),
		   bigpack:new({touchflags = tf}),
		   grenadebackpack:new({touchflags = tf}),
		   bigpack2:new({touchflags = tf})
end

blue_healthkit, blue_armorkit, blue_ammobackpack, blue_bigpack, blue_grenadebackpack, blue_bigpack2 = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
red_healthkit, red_armorkit, red_ammobackpack, red_bigpack ,red_grenadebackpack, red_bigpack2 = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kRed})
yellow_healthkit, yellow_armorkit, yellow_ammobackpack, yellow_bigpack, yellow_grenadebackpack, yellow_bigpack2 = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kYellow})
green_healthkit, green_armorkit, green_ammobackpack, green_bigpack, green_grenadebackpack, green_bigpack2 = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kGreen})



