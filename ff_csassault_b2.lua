
-- ff_csassault.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_hunted2")

-----------------------------------------------------------------------------
-- entities
-----------------------------------------------------------------------------

escape_door_top = base_escape_door



------------
---less nades
------------

function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	player:AddHealth( 400 )
	player:AddArmor( 400 )
	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
        end

---------------------------------
-- Red Spawn & Hostage Door
---------------------------------

red_respawn = trigger_ff_script:new({ team = Team.kRed }) 

function red_respawn:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_respawn:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_respawndoor", "Open")
   end 
end 

------
------

start = trigger_ff_script:new({ team = Team.kRed })

function start:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			OutputEvent( self.entity, "PlaySound" )
			BroadCastMessageToPlayer( player, "Kick the Bad Guys ASS & Bring the Hostage back to the truck!!!" )
		end
	end
end

red_start = start:new({ team = Team.kRed })
---------------------------------
-- Yellow Resupply
---------------------------------

startyellow = trigger_ff_script:new({ team = Team.kYellow })

function startyellow:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			OutputEvent( self.entity, "PlaySound" )
			BroadCastMessageToPlayer( player, "Keep Good Guys from allowing Hostage to escape!!!" )
		end
	end
end

startyellow = startyellow:new({ team = Team.kYellow })


-----------------------------
-----blue spawn door close
-----------------------------
blue_respawn = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_respawn:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_respawn:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("escape_door_top", "Close")
      OutputEvent("escape_door_bottom", "Close")
   end 
end 


-----------------------
------Red Resupply Bags
-----------------------

ff_genericpack = genericbackpack:new({
	health = 400,
	armor = 400,
	
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 400,
	
	gren1 = 0,
	gren2 = 0,
	
	respawntime = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_genericpack:dropatspawn() return false end
red_genericpack = ff_genericpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })


-----------------------
------Yellow Resupply Bags
-----------------------

ff_genericpack = genericbackpack:new({
	health = 20,
	armor = 20,
	
	grenades = 20,
	nails = 20,
	shells = 20,
	rockets = 20,
	cells = 20,
	
	gren1 = 0,
	gren2 = 0,
	
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_genericpack:dropatspawn() return false end
yellow_genericpack = ff_genericpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kYellow } })



