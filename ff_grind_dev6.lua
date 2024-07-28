---------------------------------------------------------------------

--ff_grind
--by Average

---------------------------------------------------------------------

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay");

-----------------------------------------------------------------------------
-- global stuff
-----------------------------------------------------------------------------

function startup()
	local team = GetTeam( Team.kBlue )
	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kSniper, 0)
	team:SetClassLimit(Player.kSoldier, 0)
	team:SetClassLimit(Player.kDemoman, 0)
	team:SetClassLimit(Player.kMedic, 0)
	team:SetClassLimit(Player.kHwguy, 0)
	team:SetClassLimit(Player.kPyro, 0)
	team:SetClassLimit(Player.kSpy, 0)
	team:SetClassLimit(Player.kEngineer, 0)
	team:SetClassLimit(Player.kCivilian, -1)
	
	local team = GetTeam( Team.kRed )
	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kSniper, 0)
	team:SetClassLimit(Player.kSoldier, 0)
	team:SetClassLimit(Player.kDemoman, 0)
	team:SetClassLimit(Player.kMedic, 0)
	team:SetClassLimit(Player.kHwguy, 0)
	team:SetClassLimit(Player.kPyro, 0)
	team:SetClassLimit(Player.kSpy, 0)
	team:SetClassLimit(Player.kEngineer, 0)
	team:SetClassLimit(Player.kCivilian, -1)
	
	local team = GetTeam( Team.kYellow )
	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kSniper, 0)
	team:SetClassLimit(Player.kSoldier, 0)
	team:SetClassLimit(Player.kDemoman, 0)
	team:SetClassLimit(Player.kMedic, 0)
	team:SetClassLimit(Player.kHwguy, 0)
	team:SetClassLimit(Player.kPyro, 0)
	team:SetClassLimit(Player.kSpy, 0)
	team:SetClassLimit(Player.kEngineer, 0)
	team:SetClassLimit(Player.kCivilian, -1)
	
	local team = GetTeam( Team.kGreen )
	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kSniper, 0)
	team:SetClassLimit(Player.kSoldier, 0)
	team:SetClassLimit(Player.kDemoman, 0)
	team:SetClassLimit(Player.kMedic, 0)
	team:SetClassLimit(Player.kHwguy, 0)
	team:SetClassLimit(Player.kPyro, 0)
	team:SetClassLimit(Player.kSpy, 0)
	team:SetClassLimit(Player.kEngineer, 0)
	team:SetClassLimit(Player.kCivilian, -1)
	
	end
	
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