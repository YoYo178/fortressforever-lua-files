IncludeScript("base_ctf");
IncludeScript("base_location");

   
GIVE_GRENADE_NUMGREN1 = 1 --number of primary grenades to give each restock
GIVE_GRENADE_NUMGREN2 = 1 --number of secondary grenades to give each restock
GIVE_GRENADE_INTERVAL = 1 --seconds between each gren restock when inside the restock trigger

restock_trigger = trigger_ff_script:new({ team = Team.kUnassigned })

function restock_trigger:allowed( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		return player:GetTeamId() == self.team
	end
	
	return EVENT_DISALLOWED
end

function restock_trigger:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		
		player:AddHealth( 100 )
		player:AddArmor( 300 )
		
		player:AddAmmo( Ammo.kNails, 300 )
		player:AddAmmo( Ammo.kShells, 300 )
		player:AddAmmo( Ammo.kRockets, 300 )
		player:AddAmmo( Ammo.kCells, 300 )
		
		-- give grens on touch
		player:AddAmmo( Ammo.kGren1, GIVE_GRENADE_NUMGREN1 )
		player:AddAmmo( Ammo.kGren2, GIVE_GRENADE_NUMGREN2 )
		
		-- start giving grens every second afterwards
		AddScheduleRepeating( "givegrenades"..player:GetId(), GIVE_GRENADE_INTERVAL, restock_give_grenades, player, GIVE_GRENADE_NUMGREN1, GIVE_GRENADE_NUMGREN2 )
	end
end

function restock_trigger:onendtouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		-- stop giving grens
		DeleteSchedule( "givegrenades"..player:GetId() )
	end
end

red_health = restock_trigger:new({ team = Team.kRed })
blue_health = restock_trigger:new({ team = Team.kBlue })

function restock_give_grenades( player, num_gren1, num_gren2 )
	if IsPlayer( player ) then
		player:AddAmmo( Ammo.kGren1, num_gren1 )
		player:AddAmmo( Ammo.kGren2, num_gren2 )
	end
end