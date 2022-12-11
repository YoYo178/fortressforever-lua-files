-- WELCOME TO DAMMIT
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
-- Ramp Room Bag
-----------------------------------------------------------------------------

rrbag = genericbackpack:new({
	health = 50,
	armor = 100,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 130,
	gren1 = 1,
	gren2 = 0,
	respawntime = 40,
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
-- Lift Bag
-----------------------------------------------------------------------------

drbag = genericbackpack:new({
	health = 50,
	armor = 100,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 130,
	gren1 = 2,
	gren2 = 0,
	respawntime = 40,
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
-- Spawn Locations
-----------------------------------------------------------------------------

ramproom_validspawn = function (self,player) return player:GetTeamId() == self.team and (player:GetClass() == Player.kSoldier or player:GetClass() == Player.kEngineer) end
doubleramps_validspawn = function (self,player) return player:GetTeamId() == self.team and (player:GetClass() == Player.kDemoman or player:GetClass() == Player.kHwguy) end
offense_validspawn = function (self,player) return player:GetTeamId() == self.team and (player:GetClass{} == Player.kScout or player:GetClass() == Player.kSniper or player:GetClass() == Player.kMedic or player:GetClass() == Player.kPyro or player:GetClass() == Player.kSpy) end

--blue_ramproom = info_ff_teamspawn:new( { validspawn = ramproom_validspawn, team=Team.kBlue } )
--blue_doubleramps = info_ff_teamspawn:new( { validspawn = doubleramps_validspawn, team=Team.kBlue } )
--blue_offense = info_ff_teamspawn:new( { validspawn = offense_validspawn, team=Team.kBlue } )

red_ramproom = info_ff_teamspawn:new( { validspawn = ramproom_validspawn, team=Team.kRed } )
red_doubleramps = info_ff_teamspawn:new( { validspawn = doubleramps_validspawn, team=Team.kRed } )
red_offense = info_ff_teamspawn:new( { validspawn = offense_validspawn, team=Team.kRed } )

-----------------------------------------------------------------------------
-- Buttons
-----------------------------------------------------------------------------

redwater_button1 = func_button:new ({})
redwater_button2 = func_button:new ({})
bluewater_button1 = func_button:new ({})
bluewater_button2 = func_button:new ({})
