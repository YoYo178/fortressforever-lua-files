IncludeScript("base_ctf");
IncludeScript("base_location");
IncludeScript("base_respawnturret");

--------------------------------------------------------
-- Locations
--------------------------------------------------------

location_blue_capture = location_info:new({ text = "Capture Point", team = Team.kBlue })
location_blue_flagroom	= location_info:new({ text = "Flag Room", team = Team.kBlue })
location_blue_spawn		= location_info:new({ text = "Team Respawn", team = Team.kBlue })

location_blue_battlements	= location_info:new({ text = "Battlements", team = Team.kBlue })
location_blue_entrance	= location_info:new({ text = "Main Entrance", team = Team.kBlue })
location_blue_tunnel		= location_info:new({ text = "Tunnel", team = Team.kBlue })
location_blue_water		= location_info:new({ text = "Flooded Tunnel", team = Team.kBlue })
location_blue_yard		= location_info:new({ text = "Yard", team = Team.kBlue })


location_red_capture = location_info:new({ text = "Capture Point", team = Team.kRed })
location_red_flagroom	= location_info:new({ text = "Flag Room", team = Team.kRed })
location_red_spawn		= location_info:new({ text = "Team Respawn", team = Team.kRed })

location_red_battlements	= location_info:new({ text = "Battlements", team = Team.kRed })
location_red_entrance	= location_info:new({ text = "Main Entrance", team = Team.kRed })
location_red_tunnel		= location_info:new({ text = "Tunnel", team = Team.kRed })
location_red_water		= location_info:new({ text = "Flooded Tunnel", team = Team.kRed })
location_red_yard		= location_info:new({ text = "Yard", team = Team.kRed })

location_bunker	= location_info:new({ text = "Middle Fort", team = Team.kUnassigned })
location_bunkertop = location_info:new({ text = "Top Middle Fort", team = Team.kUnassigned })


--------------------------------------------------------
-- Custom BackPacks
--------------------------------------------------------

engiPack = genericbackpack:new({
	health = 0,
	armor = 0,
	grenades = 0,
	nails = 0,
	shells = 400,
	rockets = 400,
	cells = 140,
	gren1 = 0,
	gren2 = 0,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})


--------------------------------------------------------
-- Team based door, based on the FF_WELL lua script
--------------------------------------------------------

red_door1_trigger = trigger_ff_script:new({ team = Team.kRed }) 

function red_door1_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_door1_trigger:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_door1_left", "Open") 
      OutputEvent("red_door1_right", "Open") 
   end 
end 


red_door2_trigger = trigger_ff_script:new({ team = Team.kRed }) 

function red_door2_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_door2_trigger:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_door2_left", "Open") 
      OutputEvent("red_door2_right", "Open") 
   end 
end 

blue_door1_trigger = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_door1_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_door1_trigger:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_door1_left", "Open") 
      OutputEvent("blue_door1_right", "Open") 
   end 
end 


blue_door2_trigger = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_door2_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_door2_trigger:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_door2_left", "Open") 
      OutputEvent("blue_door2_right", "Open") 
   end 
end 


--------------------------------------------------------
-- Triggers slaying the players to prevent spawn killing
--------------------------------------------------------

Slay = trigger_ff_script:new({ team = Team.kUnassigned })

function Slay:allowed( activator )
	local player = CastToPlayer( activator )
	if player then
		if player:GetTeamId() == self.team then
			return EVENT_DISALLOWED
		end
	end
	return EVENT_ALLOWED
end

blue_slayer = Slay:new({ team = Team.kBlue })
red_slayer = Slay:new({ team = Team.kRed })
