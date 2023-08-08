
-- ff_reflection_b1.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript( "base_ctf" );

-----------------------------------------------------------------------------
-- resupply
-----------------------------------------------------------------------------
supply = trigger_ff_script:new({ team = Team.kUnassigned })

function supply:ontouch( touch_entity )
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

blue_supply = supply:new({ team = Team.kBlue })
red_supply = supply:new({ team = Team.kRed })
-----------------------------------------------------------------------------
-- Ammo
-----------------------------------------------------------------------------
ammo = genericbackpack:new({
    respawntime = 10,
	health = 25,
	armor = 50,
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 15,
	cells = 70,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function ammo :dropatspawn() return false end

red_ammo = ammo:new({ touchflags = {AllowFlags.kRed} })
blue_ammo = ammo:new({ touchflags = {AllowFlags.kBlue} })

