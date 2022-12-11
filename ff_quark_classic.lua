-- WELCOME TO QUARK
-- NEON

-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_teamplay");

-----------------------------------------------------------------------------
-- Global Overrides
-----------------------------------------------------------------------------

POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 60;

-----------------------------------------------------------------------------
-- touch resupply
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
-- FR Bag
-----------------------------------------------------------------------------

frbag = genericbackpack:new( {
	health = 45,
	armor = 75,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 125,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
} )

function frbag:dropatspawn() return false end

redfrbag = frbag:new({ touchflags = {AllowFlags.kRed} })
bluefrbag = frbag:new({ touchflags = {AllowFlags.kBlue}
})

-----------------------------------------------------------------------------
-- Gren Bag
-----------------------------------------------------------------------------

grenbag = genericbackpack:new({
	gren1 = 2,
	gren2 = 2,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function grenbag:dropatspawn() return false end

redgrenbag = grenbag:new({ touchflags = {AllowFlags.kRed} })
bluegrenbag = grenbag:new({ touchflags = {AllowFlags.kBlue}
})

-----------------------------------------------------------------------------
-- Clips on Spawns
-----------------------------------------------------------------------------

clip_brush = trigger_ff_clip:new({ clipflags = 0 })

red_clip = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamBlue} })
blue_clip = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamRed} })