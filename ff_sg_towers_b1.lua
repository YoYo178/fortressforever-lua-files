-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base");
IncludeScript("base_ctf_sg_battle");
IncludeScript("base_location");

-----------------------------------------------------------------------------
-- SPAWNS
-----------------------------------------------------------------------------

red_o_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kEngineer))) end

red_ospawn = { validspawn = red_o_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kEngineer))) end

blue_ospawn = { validspawn = blue_o_only }

-----------------------------------------------------------------------------
-- bags
-----------------------------------------------------------------------------
bluepack = genericbackpack:new({
	health = 80,
	armor = 50,
	grenades = 100,
	nails = 100,
	shells = 100,
	rockets = 20,
	cells = 200,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kBlue},
	botgoaltype = Bot.kBackPack_Ammo
})

function bluepack:dropatspawn() return false end

redpack = genericbackpack:new({
	health = 80,
	armor = 50,
	grenades = 100,
	nails = 100,
	shells = 100,
	rockets = 20,
	cells = 200,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kRed},
	botgoaltype = Bot.kBackPack_Ammo
})

function redpack:dropatspawn() return false end

genpack = genericbackpack:new({
	health = 0,
	armor = 0,
	grenades = 20,
	nails = 100,
	shells = 100,
	rockets = 20,
	cells = 200,
	respawntime = 2,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function genpack:dropatspawn() return false 
end


-----------------------------------------------------------------------------
-- Stuff that resup trigger give
-----------------------------------------------------------------------------


jugglezone = trigger_ff_script:new({ })

function jugglezone:ontrigger( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetClass() == Player.kEngineer then
			player:AddAmmo( Ammo.kGren1, -4 )
			player:AddAmmo( Ammo.kGren2, -4 )
			player:AddAmmo( Ammo.kNails, 500 )
			player:AddAmmo( Ammo.kShells, 500 )
			player:AddAmmo( Ammo.kCells, 200 )
			player:AddAmmo( Ammo.kRockets, 200 )
		end
	end
end