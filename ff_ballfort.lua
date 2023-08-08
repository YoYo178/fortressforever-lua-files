IncludeScript("base_teamplay")



local Balls = 
	{
	"models/props/ff_crazygolf/balls/bluesmiley/bluesmiley.mdl",
	"models/props/ff_crazygolf/balls/redsmiley/redsmiley.mdl", 
	"models/props/ff_crazygolf/balls/greensmiley/greensmiley.mdl",
	"models/props/ff_crazygolf/balls/yellowsmiley/yellowsmiley.mdl"
	}
local function_table = 
	{
	precache = precache, 
	player_spawn = player_spawn 
	}
function precache()
	if type(function_table.precache) == "function" then function_table.precache()	end
	for k,v in pairs(Balls) do PrecacheModel(Balls[k]) end
end
function startup()
	SetGameDescription( "Happy Ballz Death Match" )

	SetTeamName(Team.kBlue, "Blue Ballz")
	SetTeamName(Team.kRed, "Red Ballz")
	SetTeamName(Team.kYellow, "Yellow Ballz")
	SetTeamName(Team.kGreen, "Green Ballz")

	local team = GetTeam(Team.kBlue)
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam(Team.kRed)
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam(Team.kYellow)
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam(Team.kGreen)
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
end

function player_spawn( player_entity )
	local player = CastToPlayer ( player_entity )
	player:AddHealth( 400 )
	player:AddArmor( 400 )

	player:RemoveAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:RemoveAmmo( Ammo.kCells, 400 )
	player:RemoveAmmo( Ammo.kDetpack, 1 )
	player:RemoveAmmo( Ammo.kManCannon, 1 )
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )

	-- Players get 1 gren1
	player:AddAmmo( Ammo.kGren1, 1 )
	
	if player:GetTeamId() == Team.kBlue then
		player:SetModel(Balls[1])
	elseif player:GetTeamId() == Team.kRed then
		player:SetModel(Balls[2])
	elseif player:GetTeamId() == Team.kGreen then
		player:SetModel(Balls[3])
	elseif player:GetTeamId() == Team.kYellow then
		player:SetModel(Balls[4])
	end
end

function player_killed( player_id )
	-- If you kill someone, give your team a point
	local killer = GetPlayer(killer)
	local victim = GetPlayer(player_id)
	
	if not (victim:GetTeamId() == killer:GetTeamId()) then
		local killersTeam = killer:GetTeam()
		killersTeam:AddScore(1)
	end
end