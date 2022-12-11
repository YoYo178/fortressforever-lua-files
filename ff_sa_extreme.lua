IncludeScript("base_teamplay")
 
function startup()
	-- set up team names
	SetTeamName( Team.kRed, "Red Fish" )
	SetTeamName( Team.kBlue, "Blue Fish" )
	SetTeamName( Team.kGreen, "Green Fish" )
	SetTeamName( Team.kYellow, "Yellow Fish" )
 
	-- set up team limits (red, blue, green, and yellow)
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, 0 )
 
	local team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
 
	local team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
 
	local team = GetTeam( Team.kGreen )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
 
	local team = GetTeam( Team.kYellow )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
 
end
 
-- Give everyone a full resupply on a reset.
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	-- Remove all grenades/detpacks then just give one standard grenade 
	player:RemoveAmmo( Ammo.kDetpack, 1 )
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
	player:AddAmmo( Ammo.kGren1, 1 )
	-- give max health, armor and ammo
	player:AddHealth( 400 )
	player:AddArmor( 400 )
	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
end
 
resupplypack = genericbackpack:new({
	respawntime = 35,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	botgoaltype = Bot.kBackPack_Ammo
})
 
function resupplypack:dropatspawn() return false end
 
function resupplypack:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
	
		local dispensed = 0
		dispensed = dispensed + player:AddHealth( 0 )
		dispensed = dispensed + player:AddArmor( 0 )
		dispensed = dispensed + player:AddAmmo(Ammo.kNails, 400)
		dispensed = dispensed + player:AddAmmo(Ammo.kShells, 400)
		dispensed = dispensed + player:AddAmmo(Ammo.kRockets, 400)
		dispensed = dispensed + player:AddAmmo(Ammo.kCells, 400)
		-- TODO: check if player already has a single grenade then skip giving a grenade
		dispensed = dispensed + player:AddAmmo(Ammo.kGren1, 4)
		if dispensed >= 1 then
			BroadCastMessageToPlayer( player, "COOLZIEZ NADEZIEZ" )
			local backpack = CastToInfoScript(entity);
			if (backpack ~= nil) then
				backpack:EmitSound(self.touchsound);
				backpack:Respawn(self.respawntime);
			end
		end
	end
end
   
function player_ondamage( player, damageinfo )
  local attacker = damageinfo:GetAttacker()
  if IsPlayer(attacker) then
    local playerAttacker = CastToPlayer(attacker)
     if (player:GetId() == playerAttacker:GetId()) or (player:GetTeamId() == playerAttacker:GetTeamId()) then
      damageinfo:SetDamage(0)
      return
    end
  -- 32 is the ID for DamageTypes.kFall; DamageTypes doesn't seem to be working though
  elseif damageinfo:GetDamageType() == 32 then
    damageinfo:SetDamage(0)
    return
  end
end

function player_killed( player, damageinfo )
  local attacker = damageinfo:GetAttacker()
  if IsPlayer( attacker ) then
    local team = attacker:GetTeam()
    team:AddScore( 1 )
  end
end