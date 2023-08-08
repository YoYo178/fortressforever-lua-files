-- ff_pigskin_night.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_push");
-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 6;
-----------------------------------------------------------------------------
-- Out of Bounds
-----------------------------------------------------------------------------
ob = trigger_ff_script:new({ 
	health = 100,
	armor = 300,
	grenades = 200,
	bullets = 200,
	nails = 200,
	rockets = 200,
	cells = 200,
	detpacks = 1,
	gren1 = 0,
	gren2 = 0,
	item = "",
	team = Team.kUnassigned,
	botgoaltype = Bot.kFlagCap
})

function ob:allowed ( allowed_entity )
	if IsPlayer( allowed_entity ) then
		-- get the player and his team
		local player = CastToPlayer( allowed_entity )
			
		-- check if the player is on our team
		if player:GetTeamId() ~= self.team then
			return EVENT_DISALLOWED
		end

		if player:HasItem( self.item ) then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

function ob:ontrigger( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
			
		-- check if the player is carrying the ball
		if player:HasItem( self.item ) then

			local ball = GetInfoScriptByName( "ball" )
			
			-- return the ball
			ball:Return()
				
			-- Remove any hud icons
			RemoveHudItem( player, ball:GetName() )
		local team = player:GetTeamId()
			if (team == Team.kBlue) then
				RemoveHudItemFromAll( "ball-icon-blue" )
			elseif (team == Team.kRed) then
				RemoveHudItemFromAll( "ball-icon-red" )
			end

			ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips })
		end
	end
end

-- declare the elements
red_ob = ob:new({ team = Team.kRed, item = "ball" })
blue_ob = ob:new({ team = Team.kBlue, item = "ball" })
-----------------------------------------------------------------------------
-- Safety
-----------------------------------------------------------------------------
safety = trigger_ff_script:new({ 
	health = 100,
	armor = 300,
	grenades = 200,
	bullets = 200,
	nails = 200,
	rockets = 200,
	cells = 200,
	detpacks = 1,
	gren1 = 0,
	gren2 = 0,
	item = "",
	team = Team.kUnassigned,
	botgoaltype = Bot.kFlagCap
})

function safety:allowed ( allowed_entity )
	ConsoleToAll( "safety allowed" )
	if IsPlayer( allowed_entity ) then
		-- get the player and his team
		local player = CastToPlayer( allowed_entity )
			
		-- check if the player is on our team
		if player:GetTeamId() ~= self.team then
			return EVENT_DISALLOWED
		end

		if player:HasItem( self.item ) then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

function safety:ontrigger( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
			
		-- check if the player is carrying the ball
		if player:HasItem( self.item ) then

			local ball = GetInfoScriptByName( "ball" )
			
			-- return the ball
			ball:Return()
				
			-- Remove any hud icons
			RemoveHudItem( player, ball:GetName() )
		local team = player:GetTeamId()
			if (team == Team.kBlue) then
				RemoveHudItemFromAll( "ball-icon-blue" )
			elseif (team == Team.kRed) then
				RemoveHudItemFromAll( "ball-icon-red" )
			end

			ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips })
		end
	end
end

-- declare the elements
red_safety = ob:new({ team = Team.kRed, item = "ball" })
blue_safety = ob:new({ team = Team.kBlue, item = "ball" })





