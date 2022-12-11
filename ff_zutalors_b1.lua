-- WELCOME TO ZUTALORS
-- GET THE FUCK OUT OF MY LUA
-- THANK YOU
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
-- Button Lift
-----------------------------------------------------------------------------

base_jump = trigger_ff_script:new({ pushz = 0 })

function base_jump:ontouch( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		local playerVel = player:GetVelocity()
		playerVel.z = self.pushz
		player:SetVelocity( playerVel )
	end
end

lift_red = base_jump:new({ pushz = 1000 })
lift_blue = base_jump:new({ pushz = 1000 })

-----------------------------------------------------------------------------
-- Ramp Room Bag
-----------------------------------------------------------------------------

rrbag = genericbackpack:new({
	health = 35,
	armor = 75,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 130,
	gren1 = 1,
	gren2 = 0,
	respawntime = 45,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function rrbag:dropatspawn() return false end

redrrbag = rrbag:new({ touchflags = {AllowFlags.kRed} })
bluerrbag = rrbag:new({ touchflags = {AllowFlags.kBlue}
})

-----------------------------------------------------------------------------
-- Double Ramp Bag
-----------------------------------------------------------------------------

drbag = genericbackpack:new({
	health = 35,
	armor = 75,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 130,
	gren1 = 2,
	gren2 = 0,
	respawntime = 45,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function drbag:dropatspawn() return false end

reddrbag = drbag:new({ touchflags = {AllowFlags.kRed} })
bluedrbag = drbag:new({ touchflags = {AllowFlags.kBlue}
})

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
-- Clips on Spawns
-----------------------------------------------------------------------------

clip_brush = trigger_ff_clip:new({ clipflags = 0 })

red_clip = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamBlue} })
blue_clip = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamRed} })

-----------------------------------------------------------------------------
-- Buttons
-----------------------------------------------------------------------------

redlift_button = func_button:new ({})
bluelift_button = func_button:new ({})