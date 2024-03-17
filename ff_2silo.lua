-- ff_2silo

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_ctf")
IncludeScript("base_teamplay")
IncludeScript("base_location")
IncludeScript("base_respawnturret")

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60

-----------------------------------------------------------------------------
-- startup 
-----------------------------------------------------------------------------

function startup()
	-- set up team limits
	local team = GetTeam( Team.kBlue )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam( Team.kRed )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( Player.kCivilian, -1 ) 

	team = GetTeam( Team.kYellow )
	team:SetPlayerLimit( -1 )	

	team = GetTeam( Team.kGreen )
	team:SetPlayerLimit( -1 )
end

-----------------------------------------------------------------------------
-- backpacks
-----------------------------------------------------------------------------

silopackspawn = genericbackpack:new({
	health = 100,
	armor = 100,
	grenades = 50,
	nails = 50,
	shells = 50,
	rockets = 15,
	cells = 100,
	mancannons = 1,
	gren1 = 0,
	gren2 = 0,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function silopackspawn:dropatspawn() return false end

silopackgrenades = genericbackpack:new({
	health = 0,
	armor = 0,
	grenades = 0,
	nails = 0,
	shells = 0,
	rockets = 0,
	cells = 0,
	mancannons = 1,
	gren1 = 2,
	gren2 = 2,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function silopackgrenades:dropatspawn() return false end

silopackgeneric = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 15,
	nails = 25,
	shells = 25,
	rockets = 0,
	cells = 50,
	mancannons = 1,
	gren1 = 0,
	gren2 = 0,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function silopackgeneric:dropatspawn() return false end

-----------------------------------------------------------------------------
-- Doors
-----------------------------------------------------------------------------

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
      OutputEvent("blue_spawn_door_1", "Open")  
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
      OutputEvent("blue_spawn_door_2", "Open")  
   end 
end 

blue_door3_trigger = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_door3_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_door3_trigger:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_spawn_door_3", "Open") 
   end 
end 

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
      OutputEvent("red_spawn_door_1", "Open")  
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
      OutputEvent("red_spawn_door_2", "Open")  
   end 
end 

red_door3_trigger = trigger_ff_script:new({ team = Team.kRed }) 

function red_door3_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_door3_trigger:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_spawn_door_3", "Open") 
   end 
end 