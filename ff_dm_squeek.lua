IncludeScript( "base_teamplay" );

TEAM_POINTS_PER_AIRSHOT = 1
PLAYER_POINTS_PER_AIRSHOT = 100

COMBO_RESET_TIME = 1.5

playerStateTable = {}

function startup()
	
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, 0 ) 
	
	-- Blue team
	local team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
	
	-- Red team
	team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
	
	-- Green team
	team = GetTeam( Team.kGreen )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
	
	-- Yellow team
	team = GetTeam( Team.kYellow )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
end

-- precache (sounds)
function precache()
	PrecacheSound("misc.bloop")
	PrecacheSound("misc.doop")
end

-----------------------------------------------------------------------------
-- Red Doors
-----------------------------------------------------------------------------
-- Spawn 1
-----------------------------------------------------------------------------
red_spawn1door_trigger = trigger_ff_script:new({ team = Team.kRed }) 

function red_spawn1door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_spawn1door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_spawn1door_left", "Open") 
      OutputEvent("red_spawn1door_right", "Open") 
   end 
end 

-----------------------------------------------------------------------------
-- Spawn 2
-----------------------------------------------------------------------------
red_spawn2door_trigger = trigger_ff_script:new({ team = Team.kRed }) 

function red_spawn2door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_spawn2door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_spawn2door_left", "Open") 
      OutputEvent("red_spawn2door_right", "Open") 
   end 
end 

-----------------------------------------------------------------------------
-- Blue Doors
-----------------------------------------------------------------------------
-- Spawn 1
-----------------------------------------------------------------------------
blue_spawn1door_trigger = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_spawn1door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_spawn1door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_spawn1door_left", "Open") 
      OutputEvent("blue_spawn1door_right", "Open") 
   end 
end 

-----------------------------------------------------------------------------
-- Spawn 2
-----------------------------------------------------------------------------
blue_spawn2door_trigger = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_spawn2door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_spawn2door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_spawn2door_left", "Open") 
      OutputEvent("blue_spawn2door_right", "Open") 
   end 
end 


-----------------------------------------------------------------------------
-- Green Doors
-----------------------------------------------------------------------------
-- Spawn 1
-----------------------------------------------------------------------------
green_spawn1door_trigger = trigger_ff_script:new({ team = Team.kGreen }) 

function green_spawn1door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function green_spawn1door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("green_spawn1door_left", "Open") 
      OutputEvent("green_spawn1door_right", "Open") 
   end 
end 

-----------------------------------------------------------------------------
-- Spawn 2
-----------------------------------------------------------------------------
green_spawn2door_trigger = trigger_ff_script:new({ team = Team.kGreen }) 

function green_spawn2door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function green_spawn2door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("green_spawn2door_left", "Open") 
      OutputEvent("green_spawn2door_right", "Open") 
   end 
end 


-----------------------------------------------------------------------------
-- Yellow Doors
-----------------------------------------------------------------------------
-- Spawn 1
-----------------------------------------------------------------------------
yellow_spawn1door_trigger = trigger_ff_script:new({ team = Team.kYellow }) 

function yellow_spawn1door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function yellow_spawn1door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("yellow_spawn1door_left", "Open") 
      OutputEvent("yellow_spawn1door_right", "Open") 
   end 
end 

-----------------------------------------------------------------------------
-- Spawn 2
-----------------------------------------------------------------------------
yellow_spawn2door_trigger = trigger_ff_script:new({ team = Team.kYellow }) 

function yellow_spawn2door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function yellow_spawn2door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("yellow_spawn2door_left", "Open") 
      OutputEvent("yellow_spawn2door_right", "Open") 
   end 
end 

-----------------------------------------------------------------------------
-- On Spawn
-----------------------------------------------------------------------------
function player_spawn( player_id )

	local player = GetPlayer(player_id)
	player:AddHealth( 400 )
	player:RemoveArmor( 400 )
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
	
	-- Give spy grens for popping people in the air
	if player:GetClass() == Player.kSpy then
		player:AddAmmo( Ammo.kGren1, 4 )
	end
	
	-- Remove any players not on a team from playerstatetable
	for playerx, recordx in pairs(playerStateTable) do
		local playert = GetPlayerByID( playerx )
		if (playert:GetTeamId() ~= Team.kRed) and (playert:GetTeamId() ~= Team.kBlue) and (playert:GetTeamId() ~= Team.kGreen) and (playert:GetTeamId() ~= Team.kYellow) then
			playerStateTable[playerx] = nil
		end
	end
	
	-- add to table and reset combo to 0
	playerStateTable[player:GetId()] = {combo = 0, railgun = 0}
	
end

-----------------------------------------------------------------------------
-- On Damage
-----------------------------------------------------------------------------
function player_ondamage( player, damageinfo )

  -- Get Damage Force
  local damageforce = damageinfo:GetDamageForce()

  -- Entity that is attacking
  local attacker = damageinfo:GetAttacker()

  -- If no attacker do nothing
  if not attacker then 
	damageinfo:SetDamage(0)
	return
  end

  -- If attacker not a player do nothing
  if not IsPlayer(attacker) then 
	damageinfo:SetDamage(0)
	return
  end
  
  local playerAttacker = CastToPlayer(attacker)

  -- If player is damaging self do nothing
  if (player:GetId() == playerAttacker:GetId()) or (player:GetTeamId() == playerAttacker:GetTeamId()) then
	damageinfo:SetDamage(0)
	return 
  end
  
  -- If player is standing on ground set damage to 0
  if player:IsOnGround() then 
	damageinfo:SetDamage(0)
	damageinfo:SetDamageForce(Vector( 0, 0, damageforce.z * 2 ))
	if weapon == "ff_projectile_ic" then
		damageinfo:SetDamageForce(Vector( 0, 0, damageforce.z * 10 ))
	end
  end
  
  local weapon = damageinfo:GetInflictor():GetClassName()
  --only allow railgun, crowbar, rocket launcher, bluepipes, frags, knife, ic, and spanner
  if weapon ~= "ff_projectile_rail" and weapon ~= "ff_projectile_rocket" and weapon ~= "ff_weapon_crowbar" and weapon ~= "ff_projectile_dart" and weapon ~= "ff_weapon_knife" and weapon ~= "ff_projectile_gl" and weapon ~= "ff_grenade_normal" and weapon ~= "ff_weapon_knife" and weapon ~= "ff_projectile_ic" and weapon ~= "ff_weapon_spanner" then
	damageinfo:ScaleDamage(0)
	damageinfo:SetDamageForce(Vector( 0, 0, 0 ))
	return
  end
  
  if weapon == "ff_grenade_normal" then
	damageinfo:ScaleDamage(0)
	damageinfo:SetDamageForce(Vector( 0, 0, damageforce.z * 1.5 ))
	return
  end
  
  -- If player is in air, instagib (? if not, increase this number)
  if player:IsInAir() then 
	local pos = player:GetOrigin()
	if pos.z > -400 then
		local id = playerAttacker:GetId()
		local team = playerAttacker:GetTeam()
		local playername = playerAttacker:GetName()
		
		if weapon == "ff_projectile_rocket" and damageinfo:GetDamage() < 64 then
			damageinfo:SetDamage(0)
			return
		end
		if weapon == "ff_projectile_gl" and damageinfo:GetDamage() < 50 then
			damageinfo:SetDamage(0)
			return
		end
		if weapon == "ff_projectile_ic" and damageinfo:GetDamage() < 40 then
			damageinfo:SetDamage(0)
			return
		end
		if weapon == "ff_projectile_rail" or weapon == "ff_projectile_rocket" or weapon == "ff_projectile_gl" or weapon == "ff_projectile_ic" then
			damageinfo:SetDamage(25)
			-- gib if about to die
			if player:GetHealth() < 26 then damageinfo:SetDamage(500) end
			-- add to rail count
			if weapon == "ff_projectile_rail" then
				playerStateTable[id].railgun = playerStateTable[id].railgun + 1
			end
		elseif weapon == "ff_projectile_dart" or weapon == "ff_weapon_knife" or weapon == "ff_weapon_crowbar" or weapon == "ff_weapon_spanner" then
			damageinfo:SetDamage(500)
		end
		
		-- Increase combo count
		if playerStateTable[id].railgun >= 2 or playerStateTable[id].railgun == 0 then
			playerStateTable[id].combo = playerStateTable[id].combo + 1
			playerStateTable[id].railgun = 0
		else
			RemoveSchedule( "reset_rail"..playername )
			AddSchedule( "reset_rail"..playername, .5, reset_rail, playerAttacker )
		end
		-- Add team score
		if playerStateTable[id].combo > 0 then
			team:AddScore(TEAM_POINTS_PER_AIRSHOT * playerStateTable[id].combo)
		else
			team:AddScore(TEAM_POINTS_PER_AIRSHOT)
		end
		
		RemoveSchedule( "reset_combo"..playername )
		AddSchedule( "reset_combo"..playername, COMBO_RESET_TIME, reset_combo, playerAttacker )
		
		-- Add FP
		if (playerStateTable[id].combo > 1) then
			playerAttacker:AddFortPoints( PLAYER_POINTS_PER_AIRSHOT * playerStateTable[id].combo, playerStateTable[id].combo.." Airshot Combo" ) 
			BroadCastSound ( "misc.bloop" )
			BroadCastMessage ( playername.." got a "..playerStateTable[id].combo.." Airshot Combo" )
		else 
			playerAttacker:AddFortPoints( PLAYER_POINTS_PER_AIRSHOT, "Airshot" )
			BroadCastSound ( "misc.doop" )
		end
	else
		damageinfo:SetDamage(0)
		damageinfo:SetDamageForce(Vector( 0, 0, damageforce.z * 2 ))
		if weapon == "ff_projectile_ic" then
			damageinfo:SetDamageForce(Vector( 0, 0, damageforce.z * 4 ))
		end
	end
  end

end

function reset_combo( player )
	local id = player:GetId()
	playerStateTable[id].combo = 0
end

function reset_rail( player )
	local id = player:GetId()
	playerStateTable[id].railgun = 0
end

area_arena = trigger_ff_script:new({})

function area_arena:onbuild( build_entity )
	return EVENT_DISALLOWED 
end

function area_arena:allowed(allowed_entity)
	if IsPlayer(allowed_entity) then
		return true
	end
	return false
end

function area_arena:ontrigger(trigger_entity)
	if IsPlayer(trigger_entity) then
		local player = CastToPlayer(trigger_entity)
		-- Reload
		ApplyToAll({AT.kReloadClips })
	end

	for playerx, recordx in pairs(playerStateTable) do
		local playert = GetPlayerByID( playerx )
		if (playert:GetTeamId() ~= Team.kRed) and (playert:GetTeamId() ~= Team.kBlue) and (playert:GetTeamId() ~= Team.kGreen) and (playert:GetTeamId() ~= Team.kYellow) then
			playerStateTable[playerx] = nil
		else
			playert:AddAmmo( Ammo.kNails, 300 )
			playert:AddAmmo( Ammo.kShells, 300 )
			playert:AddAmmo( Ammo.kRockets, 300 )
			playert:AddAmmo( Ammo.kCells, 300 )
			if playert:GetClass() == Player.kSpy then
				playert:AddAmmo( Ammo.kGren1, 4 )
			end
			playert:RemoveArmor( 400 )
		end
	end
end

area_wall = trigger_ff_script:new({ })

function area_wall:allowed(allowed_entity)
	if IsPlayer(allowed_entity) then
		return false
	end
	return true
end

spawnclip = trigger_ff_clip:new({ clipflags = 0 })

blue_spawnclip = spawnclip:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamRed, ClipFlags.kClipTeamGreen, ClipFlags.kClipTeamYellow} })
red_spawnclip = spawnclip:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamBlue, ClipFlags.kClipTeamGreen, ClipFlags.kClipTeamYellow} })
green_spawnclip = spawnclip:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamRed, ClipFlags.kClipTeamBlue, ClipFlags.kClipTeamYellow} })
yellow_spawnclip = spawnclip:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamRed, ClipFlags.kClipTeamGreen, ClipFlags.kClipTeamBlue} })

info_button = trigger_ff_script:new({ })

function info_button:allowed( allowed_entity )
	if IsPlayer(allowed_entity) then
		local player = CastToPlayer(allowed_entity)
		if player:IsInUse() then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

function info_button:ontrigger(trigger_entity)
	if IsPlayer(trigger_entity) then
		local player = CastToPlayer(trigger_entity)
		
		-- Mode
		ConsoleToAll("-----------------------------")
		ConsoleToAll("GAME MODE: Airshots Only")
		ConsoleToAll("-----------------------------")
		ConsoleToAll("You can only do damage while the enemy is in the air")
		
		BroadCastMessageToPlayer( player, "GAME MODE: Airshots Only" )
	end
end

-----------------------------------------------------------------------------
-- Ammo/Health Kit (backpack-based)
-----------------------------------------------------------------------------
full_pack = genericbackpack:new({
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 0,
	respawntime = 2,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function full_pack:dropatspawn() return false end

