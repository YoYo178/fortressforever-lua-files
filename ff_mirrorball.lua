
-- ff_waterpolo.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_fortball_default")
IncludeScript("base_fortball")

----------------------------------------

-- teams
TEAM1 = Team.kBlue
TEAM2 = Team.kRed
DISABLED_TEAM3 = Team.kYellow
DISABLED_TEAM4 = Team.kGreen

teams = { TEAM1, TEAM2 }
disabled_teams = { DISABLED_TEAM3, DISABLED_TEAM4 }

-- Give everyone a full resupply
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:AddAmmo( Ammo.kGren1, 4 )
	player:AddAmmo( Ammo.kGren2, 4 )

	-- god damn right
	player:RemoveAmmo( Ammo.kDetpack, 1 )
	player:RemoveAmmo( Ammo.kManCannon, 1 )

	-- goalies run fast
	if player:GetClass() ~= Player.kCivilian then
		player:RemoveEffect( EF.kSpeedlua1 )
	else
		player:AddEffect( EF.kSpeedlua1, -1, 0, GOALIE_SPEED )

		-- stop the goalie breathing sound
		--player:StopSound("ff_waterpolo.psychotic_goalie")

		-- play the goalie breathing sound
		--player:EmitSound("ff_waterpolo.psychotic_goalie")
	end

	-- objective
	UpdateObjectiveIcon( player, objective_entities[player:GetTeamId()] )
end

-- Objective icon is on ball carrier no matter what
function base_ball:touch( touch_entity )
	if IsPlayer( touch_entity ) then

		local player = CastToPlayer( touch_entity )
		if self.notouch[player:GetId()] then return end

		local ball = CastToInfoScript( entity )

		if player:GetClass() ~= Player.kCivilian then
			-- if the player is a spy, then force him to lose his disguise
			player:SetDisguisable( false )
			player:SetCloakable( false )

			ConsoleToAll( player:GetName() .. " has the ball!" )
			SmartSound( player, "misc.bloop", "misc.bloop", "misc.bloop" )
			SmartMessage( player, "#FF_WATERPOLO_YOU_PICKUP", "#FF_WATERPOLO_TEAM_PICKUP", "#FF_WATERPOLO_ENEMY_PICKUP" )
			ball:Pickup( player )

			AddHudIcon( player, self.hudicon, ball:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign )
			local team = player:GetTeamId()
			if (team == TEAM1) then
				AddHudIconToAll( self.hudstatusiconblue, "ball-icon-blue", self.hudstatusiconbluex, self.hudstatusiconbluey, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconbluealign )
			elseif (team == TEAM2) then
				AddHudIconToAll( self.hudstatusiconred, "ball-icon-red", self.hudstatusiconredx, self.hudstatusiconredy, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconredalign )
			end

			-- 100 points for initial touch on ball
			if self.status == 0 then player:AddFortPoints(POINTS_PER_INITIALTOUCH, "#FF_FORTPOINTS_INITIALTOUCH") end
			self.status = 1

			local enemy_team = team_info[player:GetTeamId()].enemy_team

			objective_entities[player:GetTeamId()] = ball
			objective_entities[enemy_team] = ball
			update_team_objectives()
			UpdateObjectiveIcon( player, goal_entities[player:GetTeamId()] )

		-- goalies return the ball
		else
			if ball:IsDropped() then
				ConsoleToAll( "Goalie, " .. player:GetName() .. ", returned the ball!" )
				SmartSound( player, "misc.deeoo", "misc.deeoo", "misc.deeoo" )
				SmartMessage( player, "#FF_WATERPOLO_YOU_RETURN", "#FF_WATERPOLO_TEAM_GOALIE_RETURN", "#FF_WATERPOLO_ENEMY_GOALIE_RETURN" )
				player:AddFortPoints( POINTS_PER_GOALIE_RETURN, "#FF_FORTPOINTS_GOALIE_RETURN" )
				ball:Return()
				self.status = 0

				for i,v in pairs(teams) do
					objective_entities[v] = ball
				end
				update_team_objectives()
			end
		end
	end
end

-- Team info
team_info = {
	[Team.kUnassigned] = {
		team_name = "neutral",
		enemy_team = Team.kUnassigned,
		class_limits = {
			[Player.kScout] = 0,
			[Player.kSniper] = 0,
			[Player.kSoldier] = 0,
			[Player.kDemoman] = 0,
			[Player.kMedic] = 0,
			[Player.kHwguy] = 0,
			[Player.kPyro] = 0,
			[Player.kSpy] = 0,
			[Player.kEngineer] = 0,
			[Player.kCivilian] = 0,
		},
	},
	[TEAM1] = {
		team_name = "blue",
		enemy_team = TEAM2,
		class_limits = {
			[Player.kScout] = 0,
			[Player.kSniper] = -1,
			[Player.kSoldier] = 0,
			[Player.kDemoman] = 0,
			[Player.kMedic] = 0,
			[Player.kHwguy] = 0,
			[Player.kPyro] = 0,
			[Player.kSpy] = 0,
			[Player.kEngineer] = 0,
			[Player.kCivilian] = -1,
		},
	},
	[TEAM2] = {
		team_name = "red",
		enemy_team = TEAM1,
		class_limits = {
			[Player.kScout] = 0,
			[Player.kSniper] = -1,
			[Player.kSoldier] = 0,
			[Player.kDemoman] = 0,
			[Player.kMedic] = 0,
			[Player.kHwguy] = 0,
			[Player.kPyro] = 0,
			[Player.kSpy] = 0,
			[Player.kEngineer] = 0,
			[Player.kCivilian] = -1,
		},
	},
}