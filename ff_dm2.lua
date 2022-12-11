-- ff_dm2.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base_teamplay");

-- Get team points for killing a player
function player_killed( player_entity, damageinfo )
	-- suicides have no damageinfo
	if damageinfo ~= nil then
		local killer = damageinfo:GetAttacker()
		
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
end

function startup()

	SetGameDescription( "DM" )
	
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, 0)
	SetPlayerLimit(Team.kGreen, 0)

end

	
-----------------------------------------------------------------------------
-- Teleport 1
-----------------------------------------------------------------------------

teleport_trigger = trigger_ff_script:new({ target="HealthTeleEntrance", speed =375 })

function teleport_trigger:ontrigger( trigger_entity )
	if IsPlayer(trigger_entity) then
		local player = CastToPlayer(trigger_entity)
		TeleportToEntity( player, self.target, self.speed )
	end
end

function TeleportToEntity( player, HealthTeleExit, speed)
	if GetEntityByName( HealthTeleExit ) ~= nil then
		local entity = GetEntityByName( HealthTeleExit )
		local neworigin = entity:GetOrigin()
		neworigin = Vector(neworigin.x,neworigin.y,neworigin.z+36+16)
		local newangles = entity:GetAngles()
		--local speed = player:GetVelocity():Length() -- get 3d speed
		if (player:GetSpeed() < speed) then -- GetSpeed gets 2d (horizontal) speed
			speed = player:GetSpeed()
		end
		local facing = entity:GetAbsFacing()
		local newvelocity = Vector( facing.x * speed, facing.y * speed, facing.z * speed ) -- * operator is not yet exposed to lua :(
		player:Teleport( neworigin, newangles, newvelocity )
		return true
	else
		return false
	end
end

HealthTeleEntrance = teleport_trigger:new({ target="HealthTeleExit" })

-----------------------------------------------------------------------------
-- Teleport 2
-----------------------------------------------------------------------------

teleport_trigger = trigger_ff_script:new({ target="TowerTeleEntrance", speed =500 })

function teleport_trigger:ontrigger( trigger_entity )
	if IsPlayer(trigger_entity) then
		local player = CastToPlayer(trigger_entity)
		TeleportToEntity( player, self.target, self.speed )
	end
end

function TeleportToEntity( player, TowerTeleExit, speed)
	if GetEntityByName( TowerTeleExit ) ~= nil then
		local entity = GetEntityByName( TowerTeleExit )
		local neworigin = entity:GetOrigin()
		neworigin = Vector(neworigin.x,neworigin.y,neworigin.z+36+16)
		local newangles = entity:GetAngles()
		--local speed = player:GetVelocity():Length() -- get 3d speed
		if (player:GetSpeed() < speed) then -- GetSpeed gets 2d (horizontal) speed
			speed = player:GetSpeed()
		end
		local facing = entity:GetAbsFacing()
		local newvelocity = Vector( facing.x * speed, facing.y * speed, facing.z * speed ) -- * operator is not yet exposed to lua :(
		player:Teleport( neworigin, newangles, newvelocity )
		return true
	else
		return false
	end
end

TowerTeleEntrance = teleport_trigger:new({ target="TowerTeleExit" })

-----------------------------------------------------------------------------
-- Teleport 3
-----------------------------------------------------------------------------

teleport_trigger = trigger_ff_script:new({ target="AltTowerTeleEntrance", speed =500 })

function teleport_trigger:ontrigger( trigger_entity )
	if IsPlayer(trigger_entity) then
		local player = CastToPlayer(trigger_entity)
		TeleportToEntity( player, self.target, self.speed )
	end
end

function TeleportToEntity( player, AltTowerTeleExit, speed)
	if GetEntityByName( AltTowerTeleExit ) ~= nil then
		local entity = GetEntityByName( AltTowerTeleExit )
		local neworigin = entity:GetOrigin()
		neworigin = Vector(neworigin.x,neworigin.y,neworigin.z+36+16)
		local newangles = entity:GetAngles()
		--local speed = player:GetVelocity():Length() -- get 3d speed
		if (player:GetSpeed() < speed) then -- GetSpeed gets 2d (horizontal) speed
			speed = player:GetSpeed()
		end
		local facing = entity:GetAbsFacing()
		local newvelocity = Vector( facing.x * speed, facing.y * speed, facing.z * speed ) -- * operator is not yet exposed to lua :(
		player:Teleport( neworigin, newangles, newvelocity )
		return true
	else
		return false
	end
end

AltTowerTeleEntrance = teleport_trigger:new({ target="AltTowerTeleExit" })

-----------------------------------------------------------------------------
-- Teleport 4
-----------------------------------------------------------------------------

teleport_trigger = trigger_ff_script:new({ target="SideTeleEntrance", speed =500 })

function teleport_trigger:ontrigger( trigger_entity )
	if IsPlayer(trigger_entity) then
		local player = CastToPlayer(trigger_entity)
		TeleportToEntity( player, self.target, self.speed )
	end
end

function TeleportToEntity( player, SideTeleExit, speed)
	if GetEntityByName( SideTeleExit ) ~= nil then
		local entity = GetEntityByName( SideTeleExit )
		local neworigin = entity:GetOrigin()
		neworigin = Vector(neworigin.x,neworigin.y,neworigin.z+36+16)
		local newangles = entity:GetAngles()
		--local speed = player:GetVelocity():Length() -- get 3d speed
		if (player:GetSpeed() < speed) then -- GetSpeed gets 2d (horizontal) speed
			speed = player:GetSpeed()
		end
		local facing = entity:GetAbsFacing()
		local newvelocity = Vector( facing.x * speed, facing.y * speed, facing.z * speed ) -- * operator is not yet exposed to lua :(
		player:Teleport( neworigin, newangles, newvelocity )
		return true
	else
		return false
	end
end

SideTeleEntrance = teleport_trigger:new({ target="SideTeleExit" })

-----------------------------------------------------------------------------
-- Jump Pads
-----------------------------------------------------------------------------
base_jump = trigger_ff_script:new({ pushz = 0 })

function base_jump:ontouch( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		local playerVel = player:GetVelocity()
		playerVel.z = self.pushz
		player:SetVelocity( playerVel )
	end
end

lift_side = base_jump:new({ pushz = 1150 })