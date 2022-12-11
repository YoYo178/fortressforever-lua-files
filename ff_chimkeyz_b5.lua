IncludeScript("base_ctf");
IncludeScript("base_shutdown");

-----------------------------------------------------------------------------
--yfni knows how to block shit (greatest FF player ever!)--- visit rip.pwnz.it -- chimkey uses #10 --need
-----------------------------------------------------------------------------

clip_brush = trigger_ff_clip:new({ clipflags = 0 })
yfni1 = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamRed} })
yfni2 = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamBlue} })
yfni3 = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers} })
yfni4 = clip_brush:new({ clipflags = {ClipFlags.kClipTeamBlue} })
yfni5 = clip_brush:new({ clipflags = {ClipFlags.kClipTeamRed} })
yfni6 = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamRed, ClipFlags.kClipTeamBlue} })
yfni7 = clip_brush:new({ clipflags = {} })
yfni8 = clip_brush:new({ clipflags = {ClipFlags.kClipGrenades} })
yfni9 = clip_brush:new({ clipflags = {ClipFlags.kClipProjectiles} })
yfni10 = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipProjectiles, ClipFlags.kClipGrenades} }) 
yfni11 = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipProjectiles, ClipFlags.kClipGrenades, ClipFlags.kClipTeamBlue} })
yfni12 = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipProjectiles, ClipFlags.kClipGrenades, ClipFlags.kClipTeamRed} })


-----------------------------------------------------------------------------
-- plasma resupply (bagless)
-----------------------------------------------------------------------------
plasmaresup = trigger_ff_script:new({ team = Team.kUnassigned })

function plasmaresup:ontouch( touch_entity )
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

blue_plasmaresup = plasmaresup:new({ team = Team.kBlue })
red_plasmaresup = plasmaresup:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- backpacks
-----------------------------------------------------------------------------

phantompack = genericbackpack:new({
	health = 50,
	gren1 = 2,
	gren2 = 1,
	armor = 50,
	grenades = 50,
	nails = 50,
	shells = 50,
	rockets = 50,
	cells = 50,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function phantompack:dropatspawn() return false end

red_phantompack = phantompack:new({ touchflags = {AllowFlags.kRed} })
blue_phantompack = phantompack:new({ touchflags = {AllowFlags.kBlue} })



-----------------------------------------------------------------------------
-- phantom lasers and respawn shields
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

-- red hurts blueteam and vice-versa

red_slayer = KILL_KILL_KILL:new({ team = Team.kRed })
blue_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })




