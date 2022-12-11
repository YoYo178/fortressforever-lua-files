
--Author: R00Kie
--ff_tomb_dm.lua



-- Includes
IncludeScript("base_teamplay");



function startup()
		SetGameDescription( "Free for all Death Match" )
		SetTeamName( Team.kBlue, "Death Match" )
	
		set_cvar("mp_friendlyfire" , 1)
		local BLUE_TEAM =  GetTeam(Team.kBlue)
		SetPlayerLimit(Team.kBlue, 0)
		SetPlayerLimit(Team.kRed, -1)
		SetPlayerLimit(Team.kYellow, -1)
		SetPlayerLimit(Team.kGreen, -1)
	
	
	
		BLUE_TEAM:SetClassLimit(Player.kScout, -1)
		BLUE_TEAM:SetClassLimit(Player.kMedic, -1)
		BLUE_TEAM:SetClassLimit(Player.kSpy, -1)
		

		BLUE_TEAM:SetClassLimit(Player.kSoldier, -1)
		BLUE_TEAM:SetClassLimit(Player.kDemoman, 0)
		BLUE_TEAM:SetClassLimit(Player.kHwguy, -1)
	
		BLUE_TEAM:SetClassLimit(Player.kEngineer, -1)
		
		BLUE_TEAM:SetClassLimit(Player.kSniper, -1)
		BLUE_TEAM:SetClassLimit(Player.kPyro, -1)
		BLUE_TEAM:SetClassLimit(Player.kCivilian, -1)
	
end

function player_spawn( player_entity )

	local player = CastToPlayer ( player_entity )

	player:RemoveAllWeapons()
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
	
	player:GiveWeapon("ff_weapon_shotgun", false)
	player:GiveWeapon("ff_weapon_crowbar", false)
	
	player:AddAmmo(Ammo.kShells, 32)
	

end
---[[
weapon = info_ff_script:new({
	useweapon = "Null",
	secondweapon = "Null",
	health = 0,
	armor = 0,
	shells = 0,
	nails = 0,
	rockets = 0,
	cells = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 40,
	model = "models/weapons/crowbar/w_crowbar.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function weapon:precache( )
	-- precache sounds
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)
	-- precache models
	PrecacheModel(self.model)
end
function weapon:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		
		local dispensed = 0
		
		-- give player some health and armor
		if self.health ~= nil and self.health ~= 0 then dispensed = dispensed + player:AddHealth( self.health ) end
		if self.armor ~= nil and self.armor ~= 0 then dispensed = dispensed + player:AddArmor( self.armor ) end
		
		-- give player ammo
		if self.nails ~= nil and self.nails ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kNails, self.nails) end
		if self.shells ~= nil and self.shells ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kShells, self.shells) end
		if self.rockets ~= nil and self.rockets ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets) end
		if self.cells ~= nil and self.cells ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kCells, self.cells) end
		if self.gren1 ~= nil and self.gren1 ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kGren1, self.gren1) end
		if self.gren2 ~= nil and self.gren2 ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren2) end		
		
		
		if self.useweapon ~= nil and self.useweapon ~= "Null" then player:GiveWeapon(self.useweapon, false) end
		if self.secondweapon ~= nil and self.secondweapon ~= "Null" then player:GiveWeapon(self.secondweapon, false) end
		
		-- if the player took ammo, then have the backpack respawn with a delay
		if dispensed >= 1 then
			-- Give player weapon
		
			local weapon = CastToInfoScript(entity);
			if weapon then
				weapon:EmitSound(self.touchsound);
				weapon:Respawn(self.respawntime);
			end
		end
	end
end
function weapon:dropatspawn() return true end


weapon_rpg = weapon:new({ useweapon = "ff_weapon_rpg", rockets = 4, model =  "models/weapons/rpg/w_rpg.mdl" })
weapon_sniperrifle = weapon:new({ useweapon = "ff_weapon_sniperrifle", shells = 16, model =  "models/weapons/sniperrifle/w_sniperrifle.mdl" })
weapon_autorifle = weapon:new({ useweapon = "ff_weapon_autorifle", shells = 32, model =  "models/weapons/autorifle/w_autorifle.mdl" })
weapon_railgun = weapon:new({ useweapon = "ff_weapon_railgun", nails = 10, model =  "models/weapons/railgun/w_railgun.mdl" })
weapon_flamethrower = weapon:new({ useweapon = "ff_weapon_flamethrower", cells = 25, model =  "models/weapons/flamethrower/w_flamethrower.mdl" })
weapon_assaultcannon = weapon:new({ useweapon = "ff_weapon_assaultcannon", shells = 50, model =  "models/weapons/assaultcannon/w_assaultcannon.mdl" })
weapon_ic = weapon:new({ useweapon = "ff_weapon_ic", rockets = 8, model = "models/weapons/incendiarycannon/w_incendiarycannon.mdl" })
weapon_supershotgun = weapon:new({ useweapon = "ff_weapon_supershotgun", shells = 16, model =  "models/weapons/supershotgun/w_supershotgun.mdl" })
weapon_gl = weapon:new({ useweapon = "ff_weapon_grenadelauncher", secondweapon = "ff_weapon_pipelauncher", rockets = 6, model =  "models/weapons/pipelauncher/w_pipelauncher.mdl" })
weapon_supernailgun = weapon:new({ useweapon = "ff_weapon_supernailgun", nails = 50, model =  "models/weapons/supernailgun/w_supernailgun.mdl" })


grenade = weapon:new({	gren1 = 1, respawntime = 30, model = "models/grenades/frag/frag.mdl" })
grenade2 = weapon:new({	gren2 = 1, respawntime = 30, model = "models/grenades/mirv/mirv.mdl" })

ammo_shells = weapon:new({ shells = 32, respawntime = 30, model = "models/items/boxbuckshot.mdl" })
ammo_rocket = weapon:new({ rockets = 4, respawntime = 30, model = "models/projectiles/rocket/w_rocket.mdl" })
ammo_nails = weapon:new({ nails = 50, respawntime = 30, model = "models/projectiles/nail/w_nail.mdl" })
ammo_pipes = weapon:new({ rockets = 4, respawntime = 30, model = "models/projectiles/pipe/w_pipe.mdl" })
ammo_cells = weapon:new({ cells = 25, respawntime = 30, model = "models/items/car_battery01.mdl" })
ammo_rails = weapon:new({ nails = 10, respawntime = 30, model = "models/projectiles/dart/w_dart.mdl" })

armor = weapon:new({armor = 25, respawntime = 25, model = "models/items/armour/armour.mdl", materializesound = "Item.Materialize", touchsound = "ArmorKit.Touch" })

function player_killed( player_entity, damageinfo )
	-- suicides have no damageinfo
	if damageinfo ~= nil then
		local killer = damageinfo:GetAttacker()
		
		local player = CastToPlayer( player_entity )
		if IsPlayer(killer) then
			killer = CastToPlayer(killer)
			--local victim = GetPlayer(player_id)
			
			if not (player:GetId() == killer:GetId()) then
				
				killer:AddFrags(2)				
				killer:AddFortPoints(150, "Frag!")
			end
		end	
	end
end

--]]


