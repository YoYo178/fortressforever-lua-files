-- ff_dm2.lua

-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base_soldierarena");
IncludeScript("base_teamplay");

function startup()
	-- set up team limits (only red & blue)
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	-- Blue team
	local team = GetTeam( Team.kBlue )
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
	
	-- Red team
	team = GetTeam( Team.kRed )
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

