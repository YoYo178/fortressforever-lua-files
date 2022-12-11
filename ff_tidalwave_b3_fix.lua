-- FF_Fiddlesticks_Revised.lua

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
-- Normal Pack
-----------------------------------------------------------------------------

fiddlepack = genericbackpack:new({
	health = 20,
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
	gren2 = 1,
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

-------------------------------------
-------------------
-- hurts
------------------
-------------------------------------

red_laser_hurtspawn = hurt:new({ team = Team.kBlue })
blue_laser_hurtspawn = hurt:new({ team = Team.kRed })

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
--Teh Clipz :DDDDDDDDDDDDDDDDDD

clip_brush = trigger_ff_clip:new({ clipflags = 0 })

redclip = clip_brush:new({ clipflags = {ClipFlags.kClipTeamBlue} })
blueclip = clip_brush:new({ clipflags = {ClipFlags.kClipTeamRed} })

-----------------------------------------------------------------------------

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

-----------------------------------------------------------------------------
-- hopefully dis my spawn lua
-----------------------------------------------------------------------------


red_o_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kDemoman) or (player:GetClass() == Player.kEngineer))) end
red_d_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kDemoman) == false) and ((player:GetClass() == Player.kEngineer) == false))) end

red_ospawn = { validspawn = red_o_only }
red_dspawn = { validspawn = red_d_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kDemoman) or (player:GetClass() == Player.kEngineer))) end
blue_d_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kDemoman) == false) and ((player:GetClass() == Player.kEngineer) == false))) end

blue_ospawn = { validspawn = blue_o_only }
blue_dspawn = { validspawn = blue_d_only }