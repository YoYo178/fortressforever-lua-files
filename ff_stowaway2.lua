
-- ff_stowaway2.lua
-- texture thanks: PhilipK

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

---

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


loc_upper_resup_blue = location_info:new({ text = "upper resup", team = Team.kBlue })
loc_lower_resup_blue = location_info:new({ text = "lower resup", team = Team.kBlue })
loc_rr_blue = location_info:new({ text = "ramp room", team = Team.kBlue })
loc_stairs_blue = location_info:new({ text = "stairs", team = Team.kBlue })
loc_fr_blue = location_info:new({ text = "flag room", team = Team.kBlue })
loc_yard = location_info:new({ text = "yard", team = NO_TEAM })
loc_upper_resup_red = location_info:new({ text = "upper resup", team = Team.kRed })
loc_lower_resup_red = location_info:new({ text = "lower resup", team = Team.kRed })
loc_rr_red = location_info:new({ text = "ramp room", team = Team.kRed })
loc_stairs_red = location_info:new({ text = "stairs", team = Team.kRed })
loc_fr_red = location_info:new({ text = "flag room", team = Team.kRed })

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
	cells = 40,
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

-----------------------------------------------------------------------------
-- Walls
-----------------------------------------------------------------------------


blue_wall_trigger = trigger_ff_script:new({ })

function blue_wall_trigger:onexplode( trigger_entity  ) 
	if IsDetpack( trigger_entity ) then 
		OutputEvent( "blue_wall", "Break" )
            BroadCastMessage("Blue ramp room wall lies in ruins!")
	end 
	return EVENT_ALLOWED
end
function blue_wall_trigger:allowed( trigger_entity ) return EVENT_DISALLOWED 
end

---

red_wall_trigger = trigger_ff_script:new({ })

function red_wall_trigger:onexplode( trigger_entity  ) 
	if IsDetpack( trigger_entity ) then 
		OutputEvent( "red_wall", "Break" )
            BroadCastMessage("Red ramp room wall lies in ruins!")
	end 
	return EVENT_ALLOWED
end
function red_wall_trigger:allowed( trigger_entity ) return EVENT_DISALLOWED 
end

