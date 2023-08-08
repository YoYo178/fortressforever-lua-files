-----------------------------------------------------------------------------
-- FF_SESSION LUA FILE
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Include LUA Scripts
-----------------------------------------------------------------------------

IncludeScript("base_ctf")
IncludeScript("base_teamplay")
IncludeScript("base_location")
IncludeScript("base_respawnturret")

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

location_yard = location_info:new({ text = "Yard", team = NO_TEAM })

location_blue_upperconcourse = location_info:new({ text = "Upper Concourse", team = Team.kBlue })
location_blue_lowerconcourse = location_info:new({ text = "Lower Concourse", team = Team.kBlue })
location_red_upperconcourse = location_info:new({ text = "Upper Concourse", team = Team.kRed })
location_red_lowerconcourse = location_info:new({ text = "Lower Concourse", team = Team.kRed })

location_blue_spire_upper = location_info:new({ text = "Central Spire - Upper", team = Team.kBlue })
location_blue_spire_lower = location_info:new({ text = "Central Spire - Lower", team = Team.kBlue })
location_red_spire_upper = location_info:new({ text = "Central Spire - Upper", team = Team.kRed })
location_red_spire_lower = location_info:new({ text = "Central Spire - Lower", team = Team.kRed })

location_blue_atrium = location_info:new({ text = "Atrium", team = Team.kBlue })
location_blue_courtyard = location_info:new({ text = "Courtyard", team = Team.kBlue })
location_blue_flagroom = location_info:new({ text = "Flagroom", team = Team.kBlue })
location_red_atrium = location_info:new({ text = "Atrium", team = Team.kRed })
location_red_courtyard = location_info:new({ text = "Courtyard", team = Team.kRed })
location_red_flagroom = location_info:new({ text = "Flagroom", team = Team.kRed })

location_blue_flagroom_access = location_info:new({ text = "Lower Flag Access", team = Team.kBlue })
location_blue_water = location_info:new({ text = "Water", team = Team.kBlue })
location_blue_bunker = location_info:new({ text = "Bunker", team = Team.kBlue })
location_red_flagroom_access = location_info:new({ text = "Lower Flag Access", team = Team.kRed })
location_red_water = location_info:new({ text = "Water", team = Team.kRed })
location_red_bunker = location_info:new({ text = "Bunker", team = Team.kRed })

location_blue_dspawn_upper = location_info:new({ text = "Defensive Spawn - Upper", team = Team.kBlue })
location_blue_dspawn_lower = location_info:new({ text = "Defensive Spawn - Lower", team = Team.kBlue })
location_blue_ospawn = location_info:new({ text = "Offensive Spawn", team = Team.kBlue })
location_red_dspawn_upper = location_info:new({ text = "Defensive Spawn - Upper", team = Team.kRed })
location_red_dspawn_lower = location_info:new({ text = "Defensive Spawn - Lower", team = Team.kRed })
location_red_ospawn = location_info:new({ text = "Offensive Spawn", team = Team.kRed })

-----------------------------------------------------------------------------
-- Players Spawn with Full Health/Armor/Ammo
-----------------------------------------------------------------------------

function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	--player:AddAmmo( Ammo.kDetpack, 1 )

	--player:RemoveAmmo( Ammo.kGren2, 4 )
end

-----------------------------------------------------------------------------
-- Offensive and Defensive Spawns
-- Medic, Spy, and Scout spawn in the offensive spawns, other classes spawn in the defensive spawn,
-- Feel free to reuse this if needed.
-----------------------------------------------------------------------------

red_o_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy))) end
red_d_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false))) end

red_ospawn = { validspawn = red_o_only }
red_dspawn = { validspawn = red_d_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy))) end
blue_d_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false))) end

blue_ospawn = { validspawn = blue_o_only }
blue_dspawn = { validspawn = blue_d_only }

-----------------------------------------------------------------------------
-- Custom Backpacks
-- These are available to both teams and distributed throughout both bases.
-- Restores a small amounts of health, armor, and ammo.
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Regular gives 90 metal, 
-----------------------------------------------------------------------------

sessionpack = genericbackpack:new({
	health = 15,
	armor = 10,
	
	nails = 50,
	shells = 20,
	rockets = 10,
	cells = 90,
	
	gren1 = 0,
	gren2 = 0,
	
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function sessionpack:dropatspawn() return false end

-----------------------------------------------------------------------------
-- Lowmetal gives 20 metal and is located in the central spire.
-- This is to discourage defensive engys from building too quickly and to prevent offensive engys from infesting the enemy base.
-----------------------------------------------------------------------------

sessionpack_lowmetal = genericbackpack:new({
	health = 15,
	armor = 10,
	
	nails = 50,
	shells = 20,
	rockets = 10,
	cells = 20,
	
	gren1 = 0,
	gren2 = 0,
	
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function sessionpack_lowmetal:dropatspawn() return false end

-----------------------------------------------------------------------------
-- Conc Pack
-- Gives concs, nothing else.
-- There are two team-specific varieties.
-----------------------------------------------------------------------------

concpack = genericbackpack:new({
	
	gren1 = 0,
	gren2 = 4,
	
	respawntime = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function concpack:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		local dispensed = 0
		
		local class = player:GetClass()
		if class == Player.kScout or class == Player.kMedic then
			if self.gren2 ~= nil then dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren2) end
		end
		
		if dispensed >= 1 then
			local backpack = CastToInfoScript(entity);
			if (backpack ~= nil) then
				backpack:EmitSound(self.touchsound);
				backpack:Respawn(self.respawntime);
			end
		end
	end
end

function concpack:dropatspawn() return false end

blue_concpack = concpack:new({
	touchflags = {AllowFlags.kBlue}
})

red_concpack = concpack:new({
	touchflags = {AllowFlags.kRed}
})

-----------------------------------------------------------------------------
-- END.
-----------------------------------------------------------------------------