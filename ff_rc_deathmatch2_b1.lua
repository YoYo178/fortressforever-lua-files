IncludeScript( "base_teamplay" );

local last_damaged_by = {}
local LAST_DAMAGE_RESET_TIME = 4

-- see powerup:precache at the bottom...
function precache()
end

function startup()
	
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, 0 ) 
	
	-- Blue team
	local team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	
	-- Red team
	team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	
	-- Red team
	team = GetTeam( Team.kYellow )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	
	-- Red team
	team = GetTeam( Team.kGreen )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
end

-----------------------------------------------------------------------------
-- On Spawn
-----------------------------------------------------------------------------
function player_spawn( player )

	local player = GetPlayer(player)
	player:AddHealth( 400 )
	player:RemoveArmor( 400 )
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
	player:AddAmmo( Ammo.kRockets, 400 )
	
	player:RemoveWeapon( "ff_weapon_supershotgun" )
	player:RemoveWeapon( "ff_weapon_shotgun" )
	
	RemoveSchedule("lastdamage"..player:GetSteamID())
	last_damaged_by[player:GetSteamID()] = nil
	
end

-----------------------------------------------------------------------------
-- On damage
-----------------------------------------------------------------------------
function player_ondamage( player, damageinfo )

	-- Get Damage Force
	local damageforce = damageinfo:GetDamageForce()

	-- Entity that is attacking
	local attacker = damageinfo:GetAttacker()

	local damagetype = damageinfo:GetDamageType()
	-- remove fall damage
	if damagetype == Damage.kFall then
		damageinfo:SetDamage(0)
		return
	end
	
	-- If attacker not a player do nothing
	if not IsPlayer(attacker) then 
		return
	end

	local playerAttacker = CastToPlayer(attacker)

	-- If player is damaging self do nothing
	if (player:GetId() == playerAttacker:GetId()) or (player:GetTeamId() == playerAttacker:GetTeamId()) then
		damageinfo:SetDamage(0)
		damageinfo:SetDamageForce(Vector( 0, 0, 0 ))
		return 
	end
  
	local weapon = damageinfo:GetInflictor():GetClassName()
  
	if weapon == "ff_grenade_normal" then
		-- grens do normal damage
	end

	if weapon == "ff_projectile_dart" or weapon == "ff_weapon_knife" or weapon == "ff_weapon_crowbar" or weapon == "ff_weapon_spanner" then
		-- melee = instagib
		damageinfo:SetDamage(500)
	end
	
	last_damaged_by[player:GetSteamID()] = playerAttacker
	AddSchedule("lastdamage"..player:GetSteamID(), LAST_DAMAGE_RESET_TIME, function() 
		last_damaged_by[player:GetSteamID()] = nil 
	end)
end

-----------------------------------------------------------------------------
-- On kill
-----------------------------------------------------------------------------
function player_killed( player, damageinfo )
	local attacker = damageinfo:GetAttacker()
	if not IsPlayer( attacker ) and IsPlayer( last_damaged_by[player:GetSteamID()] ) and attacker:GetClassName() == "trigger_hurt" then
		attacker = last_damaged_by[player:GetSteamID()]
		attacker:AddFortPoints( 100, "Knocking a player into the abyss" )
		attacker:AddFrags( 1 )
		BroadCastMessageToPlayer( attacker, "You knocked "..player:GetName().." into the abyss" )
	end
	if IsPlayer( attacker ) then
		local team = attacker:GetTeam()
		team:AddScore( 1 )
	end
end

------------------------------------------
-- pit trigger
------------------------------------------
pit = trigger_ff_script:new({})

function pit:ontouch( player )
	if IsPlayer( player) then
		local player = CastToPlayer(player)
		player:EmitSound("ricochet.scream")
	end
end

------------------------------------------
-- jump triggers
------------------------------------------
base_jump = trigger_ff_script:new({ pushx = 0,
								 pushy = 0,
								 pushz = 0 })

-- registers attackers as they enter the zone
function base_jump:ontouch( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		
		player:SetVelocity( Vector( self.pushx, self.pushy, self.pushz ) )
		entity:EmitSound("ricochet.triggerjump")
	end
end

-- standard
jump_standard_north = base_jump:new({ pushx = 0, pushy = 700, pushz = 400 })
jump_standard_east = base_jump:new({ pushx = 700, pushy = 0, pushz = 400 })
jump_standard_south = base_jump:new({ pushx = 0, pushy = -700, pushz = 400 })
jump_standard_west = base_jump:new({ pushx = -700, pushy = 0, pushz = 400 })

jump_standard_northeast = base_jump:new({ pushx = 600, pushy = 600, pushz = 500 })
jump_standard_northwest = base_jump:new({ pushx = -600, pushy = 600, pushz = 500 })
jump_standard_southeast = base_jump:new({ pushx = 600, pushy = -600, pushz = 500 })
jump_standard_southwest = base_jump:new({ pushx = -600, pushy = -600, pushz = 500 })

-- short
jump_short_north = base_jump:new({ pushx = 0, pushy = 300, pushz = 400 })
jump_short_east = base_jump:new({ pushx = 300, pushy = 0, pushz = 400 })
jump_short_south = base_jump:new({ pushx = 0, pushy = -300, pushz = 400 })
jump_short_west = base_jump:new({ pushx = -300, pushy = 0, pushz = 400 })

jump_short_northeast = base_jump:new({ pushx = 350, pushy = 350, pushz = 400 })
jump_short_northwest = base_jump:new({ pushx = -350, pushy = 350, pushz = 400 })
jump_short_southeast = base_jump:new({ pushx = 350, pushy = -350, pushz = 400 })
jump_short_southwest = base_jump:new({ pushx = -350, pushy = -350, pushz = 400 })

-- long
jump_long_north = base_jump:new({ pushx = 0, pushy = 950, pushz = 600 })
jump_long_east = base_jump:new({ pushx = 950, pushy = 0, pushz = 600 })
jump_long_south = base_jump:new({ pushx = 0, pushy = -950, pushz = 600 })
jump_long_west = base_jump:new({ pushx = -950, pushy = 0, pushz = 600 })

jump_long_northeast = base_jump:new({ pushx = 750, pushy = 750, pushz = 600 })
jump_long_northwest = base_jump:new({ pushx = -750, pushy = 750, pushz = 600 })
jump_long_southeast = base_jump:new({ pushx = 750, pushy = -750, pushz = 600 })
jump_long_southwest = base_jump:new({ pushx = -750, pushy = -750, pushz = 600 })

-- up level
jump_uplevel_north = base_jump:new({ pushx = 0, pushy = 300, pushz = 800 })
jump_uplevel_east = base_jump:new({ pushx = 300, pushy = 0, pushz = 800 })
jump_uplevel_south = base_jump:new({ pushx = 0, pushy = -300, pushz = 800 })
jump_uplevel_west = base_jump:new({ pushx = -300, pushy = 0, pushz = 800 })

jump_uplevel_northeast = base_jump:new({ pushx = 200, pushy = 200, pushz = 800 })
jump_uplevel_northwest = base_jump:new({ pushx = -200, pushy = 200, pushz = 800 })
jump_uplevel_southeast = base_jump:new({ pushx = 200, pushy = -200, pushz = 800 })
jump_uplevel_southwest = base_jump:new({ pushx = -200, pushy = -200, pushz = 800 })

-- down level(s)
jump_downlevel_north = base_jump:new({ pushx = 0, pushy = 350, pushz = 125 })
jump_downlevel_east = base_jump:new({ pushx = 350, pushy = 0, pushz = 125 })
jump_downlevel_south = base_jump:new({ pushx = 0, pushy = -350, pushz = 125 })
jump_downlevel_west = base_jump:new({ pushx = -350, pushy = 0, pushz = 125 })

jump_downlevel_northeast = base_jump:new({ pushx = 350, pushy = 350, pushz = 125 })
jump_downlevel_northwest = base_jump:new({ pushx = -350, pushy = 350, pushz = 125 })
jump_downlevel_southeast = base_jump:new({ pushx = 350, pushy = -350, pushz = 125 })
jump_downlevel_southwest = base_jump:new({ pushx = -350, pushy = -350, pushz = 125 })

-----------------------------------
-- powerups
-----------------------------------

powerup = genericbackpack:new({
	gren1 = 1,
	gren2 = 0,
	model = "models/items/armour/armour.mdl",
	materializesound = "ricochetpowerup.pspawn",
	respawntime = 30,
	touchsound = "ricochetpowerup.powerup",
	botgoaltype = Bot.kBackPack_Grenades
})

function powerup:dropatspawn() return false end

------------------
--HACKHACKHACK
--piggyback on powerup precaching because dedicated servers hate precaching normally
------------------
local powerup_precache_saved = powerup.precache
function powerup:precache()
	powerup_precache_saved(self)
	
	PrecacheSound( "ricochet.scream" )
	PrecacheSound( "ricochet.triggerjump" )
end
------------------
--END HACKHACKHACK
------------------

powerup_top = powerup
powerup_mid = powerup
