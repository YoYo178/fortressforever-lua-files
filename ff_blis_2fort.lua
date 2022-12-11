
-- ff_blis_2fort.lua

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

---------

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

---------

blue_tri_door3 = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_tri_door3:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_tri_door3:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_door_3", "Open") 
   end 
end 

---------

blue_tri_door4 = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_tri_door4:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_tri_door4:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_door_4", "Open") 
   end 
end 

---------

blue_tri_door5 = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_tri_door5:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_tri_door5:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_door_5", "Open") 
   end 
end 

---------

blue_tri_door6 = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_tri_door6:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_tri_door6:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_door_6", "Open") 
   end 
end 

---------

blue_tri_elev = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_tri_elev:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_tri_elev:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_elevator", "Open") 
   end 
end 


------------------------------

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

---------

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

---------

red_tri_door3 = trigger_ff_script:new({ team = Team.kRed }) 

function red_tri_door3:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_tri_door3:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_door_3", "Open") 
   end 
end 

---------

red_tri_door4 = trigger_ff_script:new({ team = Team.kRed }) 

function red_tri_door4:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_tri_door4:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_door_4", "Open") 
   end 
end 

---------

red_tri_door5 = trigger_ff_script:new({ team = Team.kRed }) 

function red_tri_door5:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_tri_door5:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_door_5", "Open") 
   end 
end 

---------

red_tri_door6 = trigger_ff_script:new({ team = Team.kRed }) 

function red_tri_door6:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_tri_door6:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_door_6", "Open") 
   end 
end 

---------

red_tri_elev = trigger_ff_script:new({ team = Team.kRed }) 

function red_tri_elev:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_tri_elev:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_elevator", "Open") 
   end 
end 

-----------------------------------------------------------------------------
-- locations
-----------------------------------------------------------------------------


loc_elev_area_red = location_info:new({ text = "elevator area", team = Team.kRed })
loc_basement_red = location_info:new({ text = "basement", team = Team.kRed })
loc_spiral_red = location_info:new({ text = "spiral", team = Team.kRed })
loc_floorlevel_red = location_info:new({ text = "floor level", team = Team.kRed })
loc_water_red = location_info:new({ text = "water", team = Team.kRed })
loc_tsp_red = location_info:new({ text = "top spiral", team = Team.kRed })
loc_rspawn_red = location_info:new({ text = "outer spawn", team = Team.kRed })


loc_elev_area_blue = location_info:new({ text = "elevator area", team = Team.kBlue })
loc_basement_blue = location_info:new({ text = "basement", team = Team.kBlue })
loc_spiral_blue = location_info:new({ text = "spiral", team = Team.kBlue })
loc_floorlevel_blue = location_info:new({ text = "floor level", team = Team.kBlue })
loc_water_blue = location_info:new({ text = "water", team = Team.kBlue })
loc_tsp_blue = location_info:new({ text = "top spiral", team = Team.kBlue })
loc_rspawn_blue = location_info:new({ text = "outer spawn", team = Team.kBlue })

loc_yard = location_info:new({ text = "yard", team = Team.kUnassigned })




