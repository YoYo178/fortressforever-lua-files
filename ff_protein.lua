
-- ff_protein.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_ctf")
IncludeScript("base_teamplay")
IncludeScript("base_location")

-----------------------------------------------------------------------------
-- custom protein packs
-----------------------------------------------------------------------------
proteinpack = genericbackpack:new({
	health = 40,
	armor = 40,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 50,
        mancannons = 1,
	gren1 = 4,
	gren2 = 4,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function proteinpack:dropatspawn() return false end

proteinpack2 = genericbackpack:new({
	health = 20,
	armor = 20,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 20,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function proteinpack2:dropatspawn() return false end

--PACK NAMES--

red_proteinpack = proteinpack:new({ touchflags = {AllowFlags.kRed} })
red_proteinpack2 = proteinpack2:new({ touchflags = {AllowFlags.kRed} })

blue_proteinpack = proteinpack:new({ touchflags = {AllowFlags.kBlue} })
blue_proteinpack2 = proteinpack2:new({ touchflags = {AllowFlags.kBlue} })

-----------------------------------------------------------------------------
--Resupply 
-----------------------------------------------------------------------------
resupply_full = trigger_ff_script:new({ team = Team.kUnassigned })

function resupply_full:ontouch( touch_entity )
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

--SUPPLY NAMES--

blue_resup = resupply_full:new({ team = Team.kBlue })
red_resup = resupply_full:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- Global
-----------------------------------------------------------------------------
KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })
function KILL_KILL_KILL:allowed( allowed_entity )
  if IsPlayer( allowed_entity ) then
    local player = CastToPlayer( allowed_entity )
    if player:GetTeamId() == self.team then
      return EVENT_ALLOWED
    end
  end

  return EVENT_DISALLOWED
end

-- red hurts blueteam and vice-versa --

red_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })
blue_slayer = KILL_KILL_KILL:new({ team = Team.kRed })


-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------
Yard = location_info:new({ text = "Yard", team = NO_TEAM })
red2 = location_info:new({ text = "Spawn", team = Team.kRed })
red1 = location_info:new({ text = "Red Base", team = Team.kRed })
blue2 = location_info:new({ text = "Spawn", team = Team.kBlue })
blue1 = location_info:new({ text = "Blue Base", team = Team.kBlue })
