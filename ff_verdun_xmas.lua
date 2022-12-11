-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Special infy style
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base");
IncludeScript("base_ctf");
--SetConvar( "mp_falldamage", 0 ) (does not work...)
-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
function startup()

	-- set up team names
	SetTeamName( Team.kBlue, "Blue" )
	SetTeamName( Team.kRed, "Red" )

	-- set start score of footy to 0-0
	ball=0

	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	local team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 1 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 1 )
	team:SetClassLimit( Player.kPyro, 1 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 1 )
	team:SetClassLimit( Player.kCivilian, 1 )

	team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 1 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 1 )
	team:SetClassLimit( Player.kPyro, 1 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 1 )
	team:SetClassLimit( Player.kCivilian, 1 )

end

-----------------------------------------------------------------------------------------------------------------------------
-- PreCache Sound
-----------------------------------------------------------------------------------------------------------------------------

function precache()
	PrecacheSound("gridiron.intercepted")
--	PrecacheSound("")
--	PrecacheSound("")
end

-----------------------------------------------------------------------------------------------------------------------------
-- FrontLine Pack &amp;amp; Flagroom BLUE
-----------------------------------------------------------------------------------------------------------------------------
blue_infy_soldier = genericbackpack:new({
	
	health = 75,
	armor = 75,
	
	nails = 50,
	shells = 50,
	rockets = 50,
	cells = 100,
	
	gren1 = 1,
	gren2 = 0,
	
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}

})
function blue_infy_soldier:dropatspawn() return false end

red_len_soldier = genericbackpack:new({
	
	health = 75,
	armor = 75,
	
	nails = 50,
	shells = 50,
	rockets = 50,
	cells = 100,
	
	gren1 = 1,
	gren2 = 0,
	
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}
})
function red_len_soldier:dropatspawn() return false end

-----------------------------------------------------------------------------------------------------------------------------
-- Lasers are cool
-----------------------------------------------------------------------------------------------------------------------------

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

red_laser_hurt = hurt:new({ team = Team.kBlue })
blue_laser_hurt = hurt:new({ team = Team.kRed })

-----------------------------------------------------------------------------------------------------------------------------
-- Spawn stuff
-----------------------------------------------------------------------------------------------------------------------------

spawn_red_civ = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kCivilian))) end
spawn_red_other = function(self,player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kMedic) == false))) end
spawn_red_other_top = function(self,player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kSoldier) == false) and ((player:GetClass() == Player.kSpy) == false) and ((player:GetClass() == Player.kDemoman) == false) and ((player:GetClass() == Player.kEngineer) == false) and ((player:GetClass() == Player.kHwguy) == false))) end


red_spawn_civ = { validspawn = spawn_red_civ }
red_spawn_other = { validspawn = spawn_red_other }
red_spawn_other_top = { validspawn = spawn_red_other_top }


spawn_blue_civ = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kCivilian))) end
spawn_blue_other = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kMedic) == false))) end
spawn_blue_other_top = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kSoldier) == false) and ((player:GetClass() == Player.kSpy) == false) and ((player:GetClass() == Player.kDemoman) == false) and ((player:GetClass() == Player.kEngineer) == false) and ((player:GetClass() == Player.kHwguy) == false))) end


blue_spawn_civ = { validspawn = spawn_blue_civ }
blue_spawn_other = { validspawn = spawn_blue_other }
blue_spawn_other_top = { validspawn = spawn_blue_other_top }

-----------------------------------------------------------------------------------------------------------------------------
-- civ fall
-----------------------------------------------------------------------------------------------------------------------------
function RestartPlayer( player )
	ApplyToPlayer( player, { AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens })
end

stay_or_die = trigger_ff_script:new()

function stay_or_die:onendtouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )

		BroadCastMessage( player:GetName() .. "has fallen" )
		SmartSound(player, "gridiron.intercepted", "", "")
--		SpeakAll( "" )

		RestartPlayer ( player )
	end
end


-----------------------------------------------------------------------------
-- Footy. (edit from caesium battleships)
-----------------------------------------------------------------------------

goal_blue = trigger_ff_script:new()
goal_red = trigger_ff_script:new()

function goal_blue:ontouch()

	ball = ball + 1
	givescore()
end

function goal_blue:onendtouch()
	ball = ball - 1
	givescore()
end

function goal_red:ontouch()
	ball = ball + 2
	givescore()
end

function goal_red:onendtouch()
	ball = ball - 2
	givescore()
end

function givescore()
	if ball == 0 then
		BroadCastMessage("PSV : 0 - 0 : Liverpool")
	end
	if ball == 1 then
		BroadCastMessage("PSV : 0 - 1 : Liverpool")
		--SmartSound(player, "", "", "")
	end
	if ball == 2 then
		BroadCastMessage("PSV : 1 - 0 : Liverpool")
		--SmartSound(player, "", "", "")
	end
end

-----------------------------------------------------------------------------
--endzone
-----------------------------------------------------------------------------

endzone = trigger_ff_script:new({ team = Team.kUnassigned })

function endzone:ontouch( touch_entity )
	local player = CastToPlayer( touch_entity )
	if player:GetTeamId() == self.team then
		ConsoleToAll( player:GetName() .. " has made it across." )
		BroadCastMessage( player:GetName() .. " has made it across." )
	end
end

endzone_red = endzone:new({ team = Team.kRed })
endzone_blue = endzone:new({ team = Team.kBlue })

-----------------------------------------------------------------------------
-- ondamage; remove fall damage for medic
-----------------------------------------------------------------------------

function player_ondamage ( player, damageinfo )

	-- if no damageinfo do nothing
	if not damageinfo then return end
	
	-- Get Damage Force
	local damagetype = damageinfo:GetDamageType()
	
	ConsoleToAll( "damage type: "..damagetype.." - expected: "..Damage.kFall )

	if damagetype == Damage.kFall and player:GetClass() == Player.kMedic then
		damageinfo:SetDamage(0)
	end
end

-----------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------
clip_brush = trigger_ff_clip:new({ clipflags = 0 })
blue_block = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamRed} })
red_block = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamBlue} })
