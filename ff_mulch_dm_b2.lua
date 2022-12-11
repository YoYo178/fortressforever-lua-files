IncludeScript("base_teamplay")
 
function startup()
	-- set up team names
	SetTeamName( Team.kRed, "Red Team" )
	SetTeamName( Team.kBlue, "Blue Team" )
	SetTeamName( Team.kYellow, "Watchers" )
	SetTeamName( Team.kGreen, "Watchers" )
 
	-- set up team limits (red, blue, green, and yellow)
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, 0 )
 
	local team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
 
	local team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
 
	
 	local team = GetTeam( Team.kYellow )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, 0 )

 	local team = GetTeam( Team.kGreen )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, 0 )
 
end
 
-- Give everyone a full resupply on a reset.
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	-- Remove all grenades/detpacks then just give one standard grenade 
	player:AddAmmo( Ammo.kDetpack, 1 )
	player:AddAmmo( Ammo.kGren1, 4 )
	player:AddAmmo ( Ammo.kGren2, 4 )
	player:AddHealth( 200 )
	player:AddArmor( 400 )
	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
end
 

resupplypack = genericbackpack:new({
	gren1 = 4,
	gren2 = 4,
	detpacks = 1,
	mancannons = 1,
	respawntime = 3,
	health = 400,
	armor = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 400,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function resupplypack:dropatspawn() return false end
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

