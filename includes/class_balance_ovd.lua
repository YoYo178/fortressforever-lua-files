

--local player_connected = player_connected

function player_connected( player )
	--if player_connected ~= nil then player_connected( player ) end
	local player = CastToPlayer(player)

	AddSchedule("startup", 1, class_deny)
	
end 
function player_switchteam( player, old, new )
	class_deny()
	return true
end

function player_disconnected( player )
	class_deny()
end

function class_deny()
	local BLUE_TEAM = GetTeam(Team.kBlue)
	local RED_TEAM = GetTeam(Team.kRed)

	local numplayers = 0
	local playing_players = RED_TEAM:GetNumPlayers() + BLUE_TEAM:GetNumPlayers()
	ConsoleToAll("Total: ".. playing_players.." Red: "..RED_TEAM:GetNumPlayers().." Blue: "..BLUE_TEAM:GetNumPlayers())
	--2v2 or less
	if playing_players <= 4 then
	
	--Blue Team
		BLUE_TEAM:SetClassLimit(Player.kScout, 2)
		BLUE_TEAM:SetClassLimit(Player.kMedic, 2)
		BLUE_TEAM:SetClassLimit(Player.kSpy, 2)
		

		BLUE_TEAM:SetClassLimit(Player.kSoldier, -1)
		BLUE_TEAM:SetClassLimit(Player.kDemoman, -1)
		BLUE_TEAM:SetClassLimit(Player.kHwguy, -1)
	
		BLUE_TEAM:SetClassLimit(Player.kEngineer, -1)
		
		BLUE_TEAM:SetClassLimit(Player.kSniper, -1)
		BLUE_TEAM:SetClassLimit(Player.kPyro, -1)
		BLUE_TEAM:SetClassLimit(Player.kCivilian, -1)
	
	--Red Team
		-- Red Offy
		RED_TEAM:SetClassLimit(Player.kScout, -1)
		RED_TEAM:SetClassLimit(Player.kMedic, -1)
		RED_TEAM:SetClassLimit(Player.kSpy, -1)
		
		-- Red Deffy
		RED_TEAM:SetClassLimit(Player.kSoldier, 2)
		RED_TEAM:SetClassLimit(Player.kDemoman, 1)
		RED_TEAM:SetClassLimit(Player.kHwguy, -1)
		RED_TEAM:SetClassLimit(Player.kEngineer, -1)
		
		-- Red Other Guys
		RED_TEAM:SetClassLimit(Player.kSniper, -1)
		RED_TEAM:SetClassLimit(Player.kPyro, -1)
		RED_TEAM:SetClassLimit(Player.kCivilian, -1)
	
	-- 3v3 to 3v4
	elseif playing_players >= 6 and playing_players < 8 then
	--Red Team
		-- +1 HWGuy
		RED_TEAM:SetClassLimit(Player.kHwguy, 1)
	
	-- 4v4 to 4v5
	elseif playing_players >= 8 and playing_players < 10 then
	-- Red Team
		-- +1 Engi
		RED_TEAM:SetClassLimit(Player.kEngineer, 1)
		
	-- Blue Team
		-- +1 Scout
		BLUE_TEAM:SetClassLimit(Player.kScout, 3)
	
	--5v5 or more
	elseif playing_players >= 10 then
	-- Red Team
		--Give Def more guys
		RED_TEAM:SetClassLimit(Player.kSoldier, 3)
		RED_TEAM:SetClassLimit(Player.kDemoman, 2)
		RED_TEAM:SetClassLimit(Player.kHwguy, 2)
		RED_TEAM:SetClassLimit(Player.kEngineer, 2)
		
		-- Allow Red to play offense
		RED_TEAM:SetClassLimit(Player.kScout, 3)
		RED_TEAM:SetClassLimit(Player.kMedic, 3)
		RED_TEAM:SetClassLimit(Player.kSpy, 3)
		
		-- Let Pyros and Snipers Join in
		RED_TEAM:SetClassLimit(Player.kSniper, 1)
		RED_TEAM:SetClassLimit(Player.kPyro, 1)
		
	-- Blue Team
		-- Allow Blue to Defend
		BLUE_TEAM:SetClassLimit(Player.kSoldier, 3)
		BLUE_TEAM:SetClassLimit(Player.kDemoman, 2)
		BLUE_TEAM:SetClassLimit(Player.kHwguy, 2)
		BLUE_TEAM:SetClassLimit(Player.kEngineer, 2)
		
		-- Give Blue Some more guys
		BLUE_TEAM:SetClassLimit(Player.kScout, 3)
		BLUE_TEAM:SetClassLimit(Player.kMedic, 3)
		BLUE_TEAM:SetClassLimit(Player.kSpy, 3)
		
		-- Let Pyros and Snipers Join in
		BLUE_TEAM:SetClassLimit(Player.kSniper, 1)
		BLUE_TEAM:SetClassLimit(Player.kPyro, 1)	
	end
end
