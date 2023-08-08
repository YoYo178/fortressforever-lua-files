---------------------------------------------
-- Includes
---------------------------------------------
IncludeScript("base_teamplay");

---------------------------------------------
-- Globals
---------------------------------------------

blue = Team.kBlue
red = Team.kRed

RESTOCK_ITERATION_TIME = 10
POINTS_PER_GOAL = 1
POINTS_TO_WIN = 21
MUST_WIN_BY = 2

---------------------------------------------
-- Packs
---------------------------------------------

bluesmallpack = genericbackpack:new({
	grenades = 100,
	bullets = 100,
	nails = 0,
	shells = 0,
	rockets = 100,
	gren1 = 0,
	gren2 = 0,
      cells = 0,
	armor = 0,
	health = 0,
      respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kBlue},
	botgoaltype = Bot.kBackPack_Ammo
})

function bluesmallpack:dropatspawn() return false end


redsmallpack = genericbackpack:new({
	grenades = 100,
	bullets = 100,
	nails = 0,
	shells = 0,
	rockets = 100,
	gren1 = 0,
	gren2 = 0,
      cells = 0,
	armor = 0,
	health = 0,
      respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kRed},
	botgoaltype = Bot.kBackPack_Ammo
})

function redsmallpack:dropatspawn() return false end

---------------------------------------------
-- Main section
---------------------------------------------

function precache()
	PrecacheSound("misc.bizwarn")
	PrecacheSound("misc.bloop")
	PrecacheSound("misc.buzwarn")
	PrecacheSound("misc.dadeda")
	PrecacheSound("misc.deeoo")
	PrecacheSound("misc.doop")
	PrecacheSound("misc.woop")

	PrecacheSound("otherteam.flagstolen")

	-- Unagi Power!  Unagi!
	PrecacheSound("misc.unagi_spatial")

	-- goalie sounds
	--PrecacheSound( goalie_sound_loop )
	--PrecacheSound( goalie_sound_idle )
	--PrecacheSound( goalie_sound_pain )
	--PrecacheSound( goalie_sound_kill )
end

function startup()
	SetGameDescription("Fun")

	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	local team = GetTeam( blue )
	
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kCivilian, -1)

	team = GetTeam( red )
	
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	
	AddScheduleRepeating( "Restock", RESTOCK_ITERATION_TIME, schedule_restock )

end

function schedule_restock()
	local c = Collection()
	-- get all players
	c:GetByFilter({CF.kPlayers})
	-- loop through all players
	for temp in c.items do
		local player = CastToPlayer( temp )
		if player then
			if player:GetClass() == Player.kHwguy then
				player:AddAmmo( Ammo.kShells, 400 )
			elseif player:GetClass() == Player.kDemoman or player:GetClass() == player.kSoldier then
				player:AddAmmo( Ammo.kRockets, 400 )
			else
				player:AddAmmo( Ammo.kNails, 400 )
				player:AddAmmo( Ammo.kShells, 400 )
				player:AddAmmo( Ammo.kRockets, 400 )
				player:AddAmmo( Ammo.kCells, 400 )
			end
		end
	end
end

function player_spawn( player_entity )
-- Removes some weapons and all grenades on spawn.

	local player = CastToPlayer( player_entity )
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
	player:RemoveAmmo( Ammo.kDetpack, 1 )
	
	if player:GetClass() == Player.kHwguy then
		player:AddAmmo( Ammo.kShells, 400 )
	elseif player:GetClass() == Player.kDemoman or player:GetClass() == player.kSoldier then
		player:AddAmmo( Ammo.kRockets, 400 )
	else
		player:AddAmmo( Ammo.kNails, 400 )
		player:AddAmmo( Ammo.kShells, 400 )
		player:AddAmmo( Ammo.kRockets, 400 )
		player:AddAmmo( Ammo.kCells, 400 )
	end

	player:RemoveWeapon( "ff_weapon_shotgun" )
	player:RemoveWeapon( "ff_weapon_supershotgun" )
	player:RemoveWeapon( "ff_weapon_nailgun" )
	player:RemoveWeapon( "ff_weapon_supernailgun" )
	player:RemoveWeapon( "ff_weapon_autorifle" )

end

function player_ondamage( player, damageinfo )
  
	damageinfo:ScaleDamage(0)

	-- if no damageinfo do nothing
	if not damageinfo then return end

	-- Entity that is attacking
	local attacker = damageinfo:GetAttacker()

	-- If no attacker do nothing
	if not attacker then return end

	local player_attacker = nil

	-- get the attacking player
	if IsPlayer(attacker) then
		attacker = CastToPlayer(attacker)
		player_attacker = attacker
	elseif IsSentrygun(attacker) then
		attacker = CastToSentrygun(attacker)
		player_attacker = attacker:GetOwner()
	elseif IsDetpack(attacker) then
		attacker = CastToDetpack(attacker)
		player_attacker = attacker:GetOwner()
	elseif IsDispenser(attacker) then
		attacker = CastToDispenser(attacker)
		player_attacker = attacker:GetOwner()
	else
		return
	end

	-- if still no attacking player after all that, forget about it
	if not player_attacker then return end

	-- If player killed self or teammate do nothing
	if (player:GetId() ~= player_attacker:GetId() and player:GetTeamId() == player_attacker:GetTeamId()) or player:GetTeamId() ~= player_attacker:GetTeamId() then
		damageinfo:SetDamageForce(Vector(0,0,0))
		return
	end
  
end

base_goaltrigger = trigger_ff_script:new({ team = Team.kUnassigned, scoringteam = Team.kUnassigned })

function base_goaltrigger:allowed( touch_entity )
	if touch_entity:GetId() == GetEntityByName( "ball" ):GetId() then
		return true
	end
	return false
end

function base_goaltrigger:ontouch( touch_entity )
	if touch_entity:GetId() == GetEntityByName( "ball" ):GetId() then
		local team = GetTeam(self.team)
		local scoringteam = GetTeam(self.scoringteam)
	
		scoringteam:AddScore( POINTS_PER_GOAL )
		local yourteam = "Your team scored a point!"
		local enemyteam = "The enemy team scored a point!"
		SmartTeamSound( scoringteam, "misc.doop", "misc.dadeda" )
		SmartTeamMessage( scoringteam, yourteam, enemyteam, Color.kGreen, Color.kRed )
		
		CheckForWinner()
	end
end

function CheckForWinner()
	local team1 = GetTeam(blue)
	local team2 = GetTeam(red)
	local team1_score = team1:GetScore()
	local team2_score = team2:GetScore()
	
	if team1_score >= POINTS_TO_WIN and team1_score - team2_score >= MUST_WIN_BY then
		GameWon(team1)
	elseif team2_score >= POINTS_TO_WIN and team2_score - team1_score >= MUST_WIN_BY then
		GameWon(team2)
	elseif team1_score >= POINTS_TO_WIN-1 and team1_score - team2_score >= MUST_WIN_BY-1 then
		ChatToAll("Game point for ^"..(team1:GetTeamId()-1)..team1:GetName())
		BroadCastMessage("Game point for "..team1:GetName().."!")
	elseif team2_score >= POINTS_TO_WIN-1 and team2_score - team1_score >= MUST_WIN_BY-1 then
		ChatToAll("Game point for ^"..(team2:GetTeamId()-1)..team2:GetName())
		BroadCastMessage("Game point for "..team2:GetName())
	end
end

function GameWon(team)
	ChatToAll("^"..(team:GetTeamId()-1)..team:GetName().." ^wins!")
	BroadCastMessage( team:GetName().." wins!" )
	GoToIntermission()
end

blue_goal = base_goaltrigger:new({ team = Team.kRed, scoringteam = Team.kBlue })
red_goal = base_goaltrigger:new({ team = Team.kBlue, scoringteam = Team.kRed })
