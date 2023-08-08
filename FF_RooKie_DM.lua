-- FF_rooKie_Dm
-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_location");

-----------------------------------------------------------------------------
-- Teams
-----------------------------------------------------------------------------
function startup()
	-- Names
	SetTeamName( Team.kRed, "Red Aristocrats" )
	SetTeamName( Team.kBlue, "Blue Bums" )
	SetTeamName( Team.kYellow, "Watchers" )
	SetTeamName( Team.kGreen, "Watchers" )
 
	-- Team limits
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, 0 )
 
	local team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
 
	local team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
 
	
 	local team = GetTeam( Team.kYellow )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, 0 )

 	local team = GetTeam( Team.kGreen )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, 0 )
 
end

 -----------------------------------------------------------------------------
-- Full supply on spawn
-----------------------------------------------------------------------------

 function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	player:AddAmmo( Ammo.kDetpack, 1 )
	player:AddAmmo( Ammo.kGren1, 4 )
	player:AddAmmo ( Ammo.kGren2, -4 )
	player:AddHealth( 200 )
	player:AddArmor( 400 )
	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
 end



-----------------------------------------------------------------------------
--Team points for killing
-----------------------------------------------------------------------------
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

-- Just here because
function player_ondamage( player_entity, damageinfo )
end

-----------------------------------------------------------------------------
-- One Nade
-----------------------------------------------------------------------------

nade = genericbackpack:new({
	gren1 = 1,
    respawntime = 1,
	model = "models/grenades/frag/frag.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function nade :dropatspawn() return false end

red_nade = nade:new({ touchflags = {AllowFlags.kRed} })
blue_nade = nade:new({ touchflags = {AllowFlags.kBlue} })

-----------------------------------------------------------------------------
-- Shells
-----------------------------------------------------------------------------

pipes = genericbackpack:new({
	shells = 20,
    respawntime = 1,
	model = "models/items/boxbuckshot.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function pipes :dropatspawn() return false end

red_pipes = pipes:new({ touchflags = {AllowFlags.kRed} })
blue_pipes = pipes:new({ touchflags = {AllowFlags.kBlue} })

-----------------------------------------------------------------------------
-- rockets
-----------------------------------------------------------------------------

rockets = genericbackpack:new({
	rockets = 20,
    respawntime = 1,
	model = "models/projectiles/rocket/w_rocket.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function rockets :dropatspawn() return false end

red_rockets = rockets:new({ touchflags = {AllowFlags.kRed} })
blue_rockets = rockets:new({ touchflags = {AllowFlags.kBlue} })

-----------------------------------------------------------------------------
-- Nails
-----------------------------------------------------------------------------

nails = genericbackpack:new({
	nails = 50,
    respawntime = 1,
	model = "models/projectiles/nail/w_nail.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function nails :dropatspawn() return false end

red_nails = nails:new({ touchflags = {AllowFlags.kRed} })
blue_nails = nails:new({ touchflags = {AllowFlags.kBlue} })

-----------------------------------------------------------------------------
-- Health Kit (backpack-based)
-----------------------------------------------------------------------------
rlife = genericbackpack:new({
	health = 25,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	respawntime = 1,
	touchsound = "HealthKit.Touch",
	botgoaltype = Bot.kBackPack_Health
})

function healthkit:dropatspawn() return true end
red_health = rlife:new({ touchflags = {AllowFlags.kRed} })
blue_health = rlife:new({ touchflags = {AllowFlags.kBlue} })

-----------------------------------------------------------------------------
--Locations
-----------------------------------------------------------------------------
--Blue
location_alley = location_info:new({ text = "Filthy Alley", team = Team.kBlue })
location_window = location_info:new({ text = "Bum's Lucky Window", team = Team.kBlue })

--Red
location_mansion = location_info:new({ text = "Royal Mansion", team = Team.kRed })
location_viewing = location_info:new({ text = "Aristocrat's Viewing Area", team = Team.kRed })

-- NO TEAM
location_shhh = location_info:new({ text = "SHHH its a secret", team = NO_TEAM })
location_dynamic = location_info:new({ text = "Dynamic Arena", team = NO_TEAM })
location_shot = location_info:new({ text = "Dont get shot!", team = NO_TEAM })

