-----------------------------------------------------------------------------------------------------------------------------
-- INCLUDES
-----------------------------------------------------------------------------------------------------------------------------

IncludeScript("base_ctf");
IncludeScript("base_location");
IncludeScript("base_respawnturret");

-----------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-----------------------------------------------------------------------------------------------------------------------------

location_yard				= location_info:new({ text = "Yard", team = Team.kUnassigned })
location_blue_tunnelrespawn		= location_info:new({ text = "Lower Respawn", team = Team.kBlue })
location_blue_tunnelresupply		= location_info:new({ text = "Lower Resupply", team = Team.kBlue })
location_blue_voltage			= location_info:new({ text = "Voltage Tube", team = Team.kBlue })
location_blue_rhall			= location_info:new({ text = "Right Flagroom Hall", team = Team.kBlue })
location_blue_lhall			= location_info:new({ text = "Left Flagroom Hall", team = Team.kBlue })
location_blue_flagroom			= location_info:new({ text = "Flagroom", team = Team.kBlue })
location_blue_upperrespawn		= location_info:new({ text = "Upper Respawn", team = Team.kBlue })
location_blue_upperresupply		= location_info:new({ text = "Upper Resupply", team = Team.kBlue })
location_blue_battlements		= location_info:new({ text = "Battlements", team = Team.kBlue })
location_blue_primary			= location_info:new({ text = "Main Entrance", team = Team.kBlue })
location_blue_secondary			= location_info:new({ text = "Secondary Entrance", team = Team.kBlue })
location_blue_cap_point			= location_info:new({ text = "Capture Point", team = Team.kBlue })
location_blue_gatebutton		= location_info:new({ text = "Security Room", team = Team.kBlue })
location_blue_ramproom			= location_info:new({ text = "Ramp Room", team = Team.kBlue })
location_blue_main			= location_info:new({ text = "Main Entrance", team = Team.kBlue })

-----------------------------------------------------------------------------
--  PACKS
-----------------------------------------------------------------------------
	genpack = genericbackpack:new({
	health = 50,
	armor = 25,
	
	grenades = 0,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 400,
	
	gren1 = 0,
	gren2 = 0,
	
	respawntime = 2,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function genpack:dropatspawn() return false end
blue_genpack = genpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_genpack = genpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

grenpack = grenadebackpack:new({ gren1 = 4, gren2 = 4 })
SNIPER_LIMIT = 1;

-----------------------------------------------------------------------------
-- TOUCH RESUP
-----------------------------------------------------------------------------

touch_resup = trigger_ff_script:new({ team = Team.kUnassigned })

function touch_resup:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			player:AddHealth( 400 )
			player:AddArmor( 400 )
			player:AddAmmo( Ammo.kNails, 400 )
			player:AddAmmo( Ammo.kShells, 400 )
			player:AddAmmo( Ammo.kRockets, 400 )
			player:AddAmmo( Ammo.kCells, 400 )
			
		end
	end
end

blue_touch_resup = touch_resup:new({ team = Team.kBlue })
red_touch_resup = touch_resup:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- No Annoyances
-----------------------------------------------------------------------------
noannoyances = trigger_ff_script:new({})
 
function noannoyances:onbuild( build_entity )
        return EVENT_DISALLOWED
end
 
function noannoyances:onexplode( explode_entity )
        if IsGrenade( explode_entity ) then
                return EVENT_DISALLOWED
        end
        return EVENT_DISALLOWED
end
 
function noannoyances:oninfect( infect_entity )
        return EVENT_DISALLOWED
end
 
no_annoyances = noannoyances

