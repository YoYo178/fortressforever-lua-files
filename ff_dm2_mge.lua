-- WELCOME TO DM2
-- GET THE FUCK OUT OF MY LUA
-- THANK YOU
-- NEON

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
 
IncludeScript("base_soldierarena");
IncludeScript("base_teamplay");
 
function startup()
        -- set up team limits (only yellow & green)
        SetPlayerLimit( Team.kBlue, -1 )
        SetPlayerLimit( Team.kRed, -1 )
        SetPlayerLimit( Team.kYellow, 0 )
        SetPlayerLimit( Team.kGreen, 0 )
 
        -- Yellow team
        local team = GetTeam( Team.kYellow )
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
       
        -- Green team
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
-----------------------------------------------------------------------------
-- Spawn Locations
-----------------------------------------------------------------------------

function player_spawn( player )
	local player = CastToPlayer ( player )
	local MaxHealth = (player:GetMaxHealth() * 1.25) - player:GetMaxHealth()
	
	player:AddHealth(MaxHealth, true)
	player:AddArmor(MaxArmor, true)
end

function player_killed( player, damageinfo )
	-- suicides have no damageinfo
	if not damageinfo then return end
	
	local player = CastToPlayer( player )
	local attacker_entity = damageinfo:GetAttacker()
	local attacker = CastToPlayer(attacker_entity)

	if not attacker then return end
	
	if IsPlayer( attacker ) then
		if player:GetId() ~= attacker:GetId() then
			local MaxHealth = (attacker:GetMaxHealth() * 1.25) - attacker:GetMaxHealth()
			
			attacker:ReloadClips()
			attacker:AddHealth(100, false)
			attacker:AddHealth(MaxHealth, true)
		end
	elseif IsSentrygun(attacker) then
	elseif IsDetpack(attacker) then
	elseif IsDispenser(attacker) then
	else
		return
	end	
end