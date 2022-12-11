-- snipe_bullseye
IncludeScript("base_location");
IncludeScript("base_teamplay");

function startup()

	SetTeamName( Team.kRed, "Red Snipers" )
	SetTeamName( Team.kBlue, "Blue Snipers" )
	
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	local team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	local team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
end

-- Get team points for killing a player
function player_killed( player_entity, damageinfo )
	local killer = GetAttacker.GetAttacker()
	
	local player = CastToPlayer( player_entity )
	if IsPlayer(killer) then
		killer = CastToPlayer(killer)
		--local victim = GetPlayer(player_id)
		
		if not (player:GetTeamId() == killer:GetTeamId()) then
			local killersTeam = killer:GetTeam()	
			killersTeam:AddScore(1)
		end
	end
end

grenadebackpack = genericbackpack:new({
	health = 200,
	armor = 150,
	grenades = 60,
	bullets = 60,
	nails = 60,
	shells = 60,
	rockets = 60,
	cells = 60,
	gren1 = 4,
	gren2 = 4,
	respawntime = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function grenadebackpack:dropatspawn() return false end