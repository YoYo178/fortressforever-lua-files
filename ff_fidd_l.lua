-- FF_Fiddlesticky.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base_shutdown");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------

POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60

-----------------------------------------------------------------------------
-- full concs 2.5 testing
-----------------------------------------------------------------------------

local player_spawn_base = player_spawn
function player_spawn_base(player_entity)
local player = CastToPlayer(player_entity)

if player:GetClass() == Player.kScout or player:GetClass() == Player.kMedic then
	player:AddAmmo( Ammo.kGren2, 4 )
        end
end
-----------------------------------------------------------------------------
-- Normal Pack
-----------------------------------------------------------------------------

fiddlepack = genericbackpack:new({
	health = 25,
	armor = 50,
	grenades = 50,
	nails = 50,
	shells = 50,
	rockets = 50,
	cells = 75,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function fiddlepack:dropatspawn() return false end

redfiddlepack = fiddlepack:new({ touchflags = {AllowFlags.kRed} })
bluefiddlepack = fiddlepack:new({ touchflags = {AllowFlags.kBlue} })

------------------------------------------------
-- Solly Pack
------------------------------------------------

fiddlesollypack = genericbackpack:new({
	health = 25,
	armor = 50,
	grenades = 50,
	nails = 50,
	shells = 50,
	rockets = 50,
	cells = 100,
	gren1 = 1,
	gren2 = 0,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function fiddlesollypack:dropatspawn() return false end

redfiddlesollypack = fiddlesollypack:new({ touchflags = {AllowFlags.kRed} })
bluefiddlesollypack = fiddlesollypack:new({ touchflags = {AllowFlags.kBlue} })

------------------------------------------------
-- Heavy Pack
------------------------------------------------

fiddleheavypack = genericbackpack:new({
	health = 35,
	armor = 115,
	grenades = 50,
	nails = 50,
	shells = 50,
	rockets = 50,
	cells = 100,
	gren1 = 1,
	gren2 = 0,
	respawntime = 45,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function fiddleheavypack:dropatspawn() return false end

redfiddleheavypack = fiddleheavypack:new({ touchflags = {AllowFlags.kRed} })
bluefiddleheavypack = fiddleheavypack:new({ touchflags = {AllowFlags.kBlue} })

--------------------------------------------------
--Grenade Pack
--------------------------------------------------

fiddlenades = genericbackpack:new({
	health = 200,
	armor = 200,
	grenades = 90,
	nails = 90,
	shells = 90,
	rockets = 90,
	cells = 200,
	gren1 = 4,
	gren2 = 2,
	respawntime = 60,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function fiddlenades:dropatspawn() return false end

redfiddlenades = fiddlenades:new({ touchflags = {AllowFlags.kRed} })
bluefiddlenades = fiddlenades:new({ touchflags = {AllowFlags.kBlue} })

-----------------------------------------------------------------------------
-- aardvark security
-----------------------------------------------------------------------------
red_aardvarksec = trigger_ff_script:new()
blue_aardvarksec = trigger_ff_script:new()
bluesecstatus = 1
redsecstatus = 1

function red_aardvarksec:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kBlue then
			if redsecstatus == 1 then
				redsecstatus = 0
				AddSchedule("aardvarksecup10red",50,aardvarksecup10red)
				AddSchedule("aardvarksecupred",60,aardvarksecupred)
				OpenDoor("red_aardvarkdoorhack")
				BroadCastMessage("Red Security Deactivated for 60 Seconds")
				--BroadCastSound( "otherteam.flagstolen")
				SpeakAll( "SD_REDDOWN" )
				RemoveHudItemFromAll( "red-sec-up" )
				AddHudIconToAll( "hud_secdown.vtf", "red-sec-down", 60, 25, 16, 16, 3 )
			end
		end
	end
end

function blue_aardvarksec:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kRed then
			if bluesecstatus == 1 then
				bluesecstatus = 0
				AddSchedule("aardvarksecup10blue",50,aardvarksecup10blue)
				AddSchedule("aardvarksecupblue",60,aardvarksecupblue)
				OpenDoor("blue_aardvarkdoorhack")
				BroadCastMessage("Blue Security Deactivated for 60 Seconds")
				--BroadCastSound( "otherteam.flagstolen")
				SpeakAll( "SD_BLUEDOWN" )
				RemoveHudItemFromAll( "blue-sec-up" )
				AddHudIconToAll( "hud_secdown.vtf", "blue-sec-down", 60, 25, 16, 16, 2 )
			end
		end
	end
end

function aardvarksecupred()
	redsecstatus = 1
	CloseDoor("red_aardvarkdoorhack")
	BroadCastMessage("Red Security Online")
	SpeakAll( "SD_REDUP" )
	RemoveHudItemFromAll( "red-sec-down" )
	AddHudIconToAll( "hud_secup_red.vtf", "red-sec-up", 60, 25, 16, 16, 3 )
end

function aardvarksecupblue()
	bluesecstatus = 1
	CloseDoor("blue_aardvarkdoorhack")
	BroadCastMessage("Blue Security Online")
	SpeakAll( "SD_BLUEUP" )
	RemoveHudItemFromAll( "blue-sec-down" )
	AddHudIconToAll( "hud_secup_blue.vtf", "blue-sec-up", 60, 25, 16, 16, 2 )
end

function aardvarksecup10red()
	BroadCastMessage("Red Security Online in 10 Seconds")
end

function aardvarksecup10blue()
	BroadCastMessage("Blue Security Online in 10 Seconds")
end

-------------------------
-- flaginfo
-------------------------
function flaginfo( player_entity )
	local player = CastToPlayer( player_entity )

	flaginfo_base(player_entity) --basic CTF HUD items

	RemoveHudItem( player, "red-sec-down" )
	RemoveHudItem( player, "blue-sec-down" )
	RemoveHudItem( player, "red-sec-up" )
	RemoveHudItem( player, "blue-sec-up" )

	if bluesecstatus == 1 then
		AddHudIcon( player, "hud_secup_blue.vtf", "blue-sec-up", button_blue.iconx, button_blue.icony, button_blue.iconw, button_blue.iconh, 2 )
	else
		AddHudIcon( player, "hud_secdown.vtf", "blue-sec-down", button_blue.iconx, button_blue.icony, button_blue.iconw, button_blue.iconh, 2 )
	end

	if redsecstatus == 1 then
		AddHudIcon( player, "hud_secup_red.vtf", "red-sec-up", button_red.iconx, button_red.icony, button_red.iconw, button_red.iconh, 3 )
	else
		AddHudIcon( player, "hud_secdown.vtf", "red-sec-down", button_red.iconx, button_red.icony, button_red.iconw, button_red.iconh, 3 )
	end
end

-----------------------------------------------------------------------------
-- 2.5 yard jp
-----------------------------------------------------------------------------

base_angle_jump = trigger_ff_script:new( {pushz=0, pushx=0, pushy=0} )

function base_angle_jump:ontouch( trigger_entity )
	if IsPlayer(trigger_entity) then
		local player = CastToPlayer(trigger_entity)
		local playerVel = player:GetVelocity()
		if self.pushz ~= 0 then playerVel.z = self.pushz end
		if self.pushx ~= 0 then playerVel.x = self.pushx end
		if self.pushy ~= 0 then playerVel.y = self.pushy end
		player:SetVelocity( playerVel )
	end
end

yard_blue = base_angle_jump:new( {pushz=500, pushy=625} )
yard_red = base_angle_jump:new( {pushz=500, pushy=-625} )

-----------------------------------------------------------------------------
-- Hurts
-----------------------------------------------------------------------------
hurt = trigger_ff_script:new({ team = Team.kUnassigned })
function hurt:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

-- red lasers hurt blue and vice-versa

red_laser_hurt = hurt:new({ team = Team.kBlue })
blue_laser_hurt = hurt:new({ team = Team.kRed })

-- function precache()
	-- precache sounds
--	PrecacheSound("vox.blueup")
--	PrecacheSound("vox.bluedown")
--	PrecacheSound("vox.redup")
--	PrecacheSound("vox.reddown")
-- end

-----------------------------------------------------------------------------
--Spawn Clips
-----------------------------------------------------------------------------

clip_brush = trigger_ff_clip:new({ clipflags = 0 })

red_clip = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamBlue} })
blue_clip = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamRed} })

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
