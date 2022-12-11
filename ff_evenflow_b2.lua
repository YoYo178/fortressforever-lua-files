-----------------------------------------------------------------------------
-- ff_evenflow_b2.lua
-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_shutdown");
-----------------------------------------------------------------------------
-- respawn protection
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
-----------------------------------------------------------------------------
-- bags without nades
-----------------------------------------------------------------------------
resupplypack = genericbackpack:new({
	health = 400,
	armor = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 400,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function resupplypack:dropatspawn() return false end
-----------------------------------------------------------------------------
-- bags with nades only
-----------------------------------------------------------------------------
nadebag = genericbackpack:new({
	gren1 = 2,
	gren2 = 1,
	detpacks = 1,
	mancannons = 1,
	respawntime = 60,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function nadebag:dropatspawn() return false end
-----------------------------------------------------------------------------
-- blue doors
-----------------------------------------------------------------------------
blue_spawn1door_trigger = trigger_ff_script:new({ team = Team.kBlue }) 
function blue_spawn1door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 
        return EVENT_DISALLOWED 
end 
function blue_spawn1door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_spawn1door", "Open")
   end 
end

blue_spawn2door_trigger = trigger_ff_script:new({ team = Team.kBlue }) 
function blue_spawn2door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 
        return EVENT_DISALLOWED 
end 
function blue_spawn2door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_spawn2door", "Open")
   end 
end 

blue_spawn3door_trigger = trigger_ff_script:new({ team = Team.kBlue }) 
function blue_spawn3door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 
        return EVENT_DISALLOWED 
end 
function blue_spawn3door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_spawn3door", "Open")
   end 
end 

blue_spawn4door_trigger = trigger_ff_script:new({ team = Team.kBlue }) 
function blue_spawn4door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 
        return EVENT_DISALLOWED 
end 
function blue_spawn4door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_spawn4door", "Open")
   end 
end
-----------------------------------------------------------------------------
-- red doors
-----------------------------------------------------------------------------
red_spawn1door_trigger = trigger_ff_script:new({ team = Team.kRed }) 
function red_spawn1door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 
        return EVENT_DISALLOWED 
end 
function red_spawn1door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_spawn1door", "Open")
   end 
end

red_spawn2door_trigger = trigger_ff_script:new({ team = Team.kRed }) 
function red_spawn2door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 
        return EVENT_DISALLOWED 
end 
function red_spawn2door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_spawn2door", "Open")
   end 
end 

red_spawn3door_trigger = trigger_ff_script:new({ team = Team.kRed }) 
function red_spawn3door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 
        return EVENT_DISALLOWED 
end 
function red_spawn3door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_spawn3door", "Open")
   end 
end 

red_spawn4door_trigger = trigger_ff_script:new({ team = Team.kRed }) 
function red_spawn4door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 
        return EVENT_DISALLOWED 
end 
function red_spawn4door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_spawn4door", "Open")
   end 
end