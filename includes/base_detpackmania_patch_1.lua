
-- BASE_DETPACKMANIA.LUA by average
-- gamemode based primarily around detpacks
-- thanks to Gumbuk 9 and Yoyo178 for helping with lua

--Older version of Detpackmania (Ver. 2/Initial Patch)

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay");

-----------------------------------------------------------------------------
-- global stuff
-----------------------------------------------------------------------------

function startup()
	SetGameDescription( "Detpackmania" )
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, 0)
	SetPlayerLimit(Team.kGreen, 0)

	local team = GetTeam( Team.kBlue )
	team:SetClassLimit(Player.kScout, -1)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kSoldier, -1)
	team:SetClassLimit(Player.kDemoman, 0)
	team:SetClassLimit(Player.kMedic, -1)
	team:SetClassLimit(Player.kHwguy, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kSpy, -1)
	team:SetClassLimit(Player.kEngineer, -1)
	team:SetClassLimit(Player.kCivilian, -1)
	
	local team = GetTeam( Team.kRed )
	team:SetClassLimit(Player.kScout, -1)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kSoldier, -1)
	team:SetClassLimit(Player.kDemoman, 0)
	team:SetClassLimit(Player.kMedic, -1)
	team:SetClassLimit(Player.kHwguy, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kSpy, -1)
	team:SetClassLimit(Player.kEngineer, -1)
	team:SetClassLimit(Player.kCivilian, -1)
	
	local team = GetTeam( Team.kYellow )
	team:SetClassLimit(Player.kScout, -1)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kSoldier, -1)
	team:SetClassLimit(Player.kDemoman, 0)
	team:SetClassLimit(Player.kMedic, -1)
	team:SetClassLimit(Player.kHwguy, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kSpy, -1)
	team:SetClassLimit(Player.kEngineer, -1)
	team:SetClassLimit(Player.kCivilian, -1)
	
	local team = GetTeam( Team.kGreen )
	team:SetClassLimit(Player.kScout, -1)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kSoldier, -1)
	team:SetClassLimit(Player.kDemoman, 0)
	team:SetClassLimit(Player.kMedic, -1)
	team:SetClassLimit(Player.kHwguy, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kSpy, -1)
	team:SetClassLimit(Player.kEngineer, -1)
	team:SetClassLimit(Player.kCivilian, -1)
	
	end
	--class limits, only allows demoman 

function player_killed( player_entity, damageinfo )
	if damageinfo ~= nil then
		local killer = damageinfo:GetAttacker()
		local player = CastToPlayer( player_entity )
		if IsPlayer(killer) then
			killer = CastToPlayer(killer)
			if not (player:GetTeamId() == killer:GetTeamId()) then
		 		local killersTeam = killer:GetTeam()    
				killersTeam:AddScore(1)
			end
		end    
	end
end
-- team scores one point per kill

-----------------------------------------------------------------------------
-- ammo backpack
-----------------------------------------------------------------------------

ammobackpack = genericbackpack:new({
	detpacks = 1,
	--armor = 200,
	health = 100,
	shells = 50,
	respawntime = 3,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function ammobackpack:dropatspawn() return false end
--basic backpack

-----------------------------------------------------------------------------
-- player spawns
-----------------------------------------------------------------------------
function player_spawn( player_entity ) 
	local player = CastToPlayer( player_entity ) 

	player:AddHealth( 400 ) 
	--player:AddArmor( 400 ) 
	player:RemoveArmor( 400 )
	--removes armor to make pelletgun fighting bearable, if you want armor, comment this and uncomment the positive AddArmor function
	
	
	player:RemoveAllWeapons()
	player:GiveWeapon("ff_weapon_deploydetpack", true)
	player:GiveWeapon("ff_weapon_shotgun", true)
	-- strips player off all weapons and gives detpack and pellet gun
	
	--player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
	-- removes all grenades upon spawning 
	--player spawns with primary nades at the moment, uncomment both player functions if you dont want to have nades 
	
end

-----------------------------------------------------------------------------
-- not get instakilled by nades 
-----------------------------------------------------------------------------
function player_ondamage( input_player, damageinfo )
  local player = CastToPlayer( input_player )
  local weapon = damageinfo:GetInflictor():GetClassName()

  ConsoleToAll( tostring( weapon ) )
  if weapon == "ff_grenade_normal" then damageinfo:SetDamage( 40 ); ConsoleToAll( "it procs" ) end
end