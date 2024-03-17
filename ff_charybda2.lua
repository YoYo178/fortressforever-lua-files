
-- FF_Charybda2.lua

---------------------------------

IncludeScript("base_ctf");
IncludeScript("base_teamplay");
IncludeScript("base_quad");
IncludeScript("base_location");
IncludeScript("base_respawnturret");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------

-- Disable conc effect
CONC_EFFECT = 0
LEET_POINTS = 1337
END_POINTS = 2000

local playerFinishTable = {}
local playerSecretTable = {}

-----------------------------------------------------------------------------
-- Precache Sounds
-----------------------------------------------------------------------------

function precache()
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("misc.doop")
end


-----------------------------------------------------------------------------
-- Charybda Locations
-----------------------------------------------------------------------------

location_facilitye = location_info:new({ text = "Facility Enterance", team = NO_TEAM })
location_security1 = location_info:new({ text = "Facility Main Secutiry", team = NO_TEAM })
location_restspot1 = location_info:new({ text = "Restspot 1", team = NO_TEAM })
location_restspot2 = location_info:new({ text = "Restspot 2", team = NO_TEAM })
location_restspot3 = location_info:new({ text = "Restspot 3", team = NO_TEAM })
location_jump1 = location_info:new({ text = "Jump 1", team = NO_TEAM })
location_jump2 = location_info:new({ text = "Jump 2", team = NO_TEAM })
location_jump3 = location_info:new({ text = "Jump 3", team = NO_TEAM })
location_jump4 = location_info:new({ text = "Jump 4", team = NO_TEAM })
location_jump5 = location_info:new({ text = "Jump 5", team = NO_TEAM })
location_jump6 = location_info:new({ text = "Jump 6", team = NO_TEAM })
location_jump7 = location_info:new({ text = "Jump 7", team = NO_TEAM })
location_jump8 = location_info:new({ text = "Jump 8", team = NO_TEAM })
location_jump9 = location_info:new({ text = "Jump 9", team = NO_TEAM })
location_jump10 = location_info:new({ text = "Jump 10", team = NO_TEAM })
location_jump11 = location_info:new({ text = "Jump 11", team = NO_TEAM })
location_jump12 = location_info:new({ text = "Jump 12", team = NO_TEAM })
location_jump13 = location_info:new({ text = "Jump 13", team = NO_TEAM })
location_facilityend = location_info:new({ text = "End zone", team = NO_TEAM })
endzone = location_info:new({ text = "Finished!", team = NO_TEAM })

-- Deathmatch Area
location_dm = location_info:new({ text = "Deathmatch Zone", team = NO_TEAM })



---------------------------------
-- Team Setup
---------------------------------

function startup()

	SetTeamName( Team.kBlue, "Team Charybda: Concussion" )
	SetTeamName( Team.kRed, "Team Charybda: Quad" )
	SetTeamName( Team.kYellow, "Test Subjects: Yellow" )
	SetTeamName( Team.kGreen, "Test Subjects: Green" )

	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, 0 )


	-- BLUE TEAM
	local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kRed )

	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )

	-- RED TEAM
	local team = GetTeam( Team.kRed )
	team:SetAllies( Team.kBlue )

	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kEngineer, -1 )

	-- YELLOW TEAM
	local team = GetTeam( Team.kYellow )

	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )

	-- GREEN TEAM
	local team = GetTeam( Team.kGreen )

	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
end

-----------------------------------------------------------------------------
-- CREATE PLAYER TABLE AT SPAWN
-----------------------------------------------------------------------------

function player_spawn(player_entity)
	if IsPlayer(player_entity) then
		local player = CastToPlayer(player_entity)
		if not playerFinishTable then
			playerFinishTable[player:GetId()] = 0
		end

		if not playerSecretTable then
			playerSecretTable[player:GetId()] = 0
		end

		team = player:GetTeam()
		if playerFinishTable[player:GetId()] ~= nil then
			finish = playerFinishTable[player:GetId()]['finish'] + 1
		end

		if playerSecretTable[player:GetId()] ~= nil then
			secret = playerSecretTable[player:GetId()]['secret'] + 1
		end
	end
end

finished = trigger_ff_script:new({pos = 0})
takesecret = trigger_ff_script:new({pos = 0})

-----------------------------------------------------------------------------
-- CHECK
-----------------------------------------------------------------------------

function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then
		return EVENT_DISALLOWED
	end

	return EVENT_ALLOWED
end

-----------------------------------------------------------------------------
-- Auto health
-----------------------------------------------------------------------------

		
function GiveHealth(player_entity)
    if IsPlayer(player_entity) then
            local player = CastToPlayer(player_entity)
            player:AddHealth(400)
            player:AddArmor(400)
    end
end

------------------------------------------------------------------
-- CONCUSSION RESTOCK FIELD
------------------------------------------------------------------

conc_resup = trigger_ff_script:new()
function conc_resup:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		player:AddAmmo( Ammo.kGren2, 4 )		
		BroadCastSoundToPlayer(player, "misc.doop")
	end
end

-----------------------------------------------------------------------------
-- End zone
-----------------------------------------------------------------------------

function finished:onendtouch(touch_entity)
	local player = CastToPlayer(touch_entity)
	local class = player:GetClass()
	if playerFinishTable[player:GetId()] == nil then playerFinishTable[player:GetId()] = {finish = 0, maxfinish = 0} end
	if playerFinishTable[player:GetId()]['finish'] < self.pos then
    		if class == Player.kCivilian then return end
		playerFinishTable[player:GetId()]['finish'] = self.pos
		if playerFinishTable[player:GetId()]['maxfinish'] < self.pos then
			playerFinishTable[player:GetId()]['maxfinish'] = self.pos
			player:AddFortPoints( END_POINTS, "Reached The End" )
			ConsoleToAll( player:GetName() .. " has finished!" )
			BroadCastMessage( player:GetName() .. " has finished!" )
			SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "yourteam.flagcap")
		end
	end		
end

------------------------------------------------------------------
-- FREE THE ID IF SOMEONE DISCONNECT
------------------------------------------------------------------

function player_disconnect( player_entity )
  local player = CastToPlayer(player_entity)
  playerFinishTable[player:GetId()] = nil;  
  playerSecretTable[player:GetId()] = nil;  
  return true;
end

------------------------------------------------------------------
-- BAGS
------------------------------------------------------------------

grenadebackpack = genericbackpack:new({
	health = 200,
	armor = 150,
	grenades = 60,
	bullets = 60,
	nails = 60,
	shells = 60,
	rockets = 60,
	cells = 60,
	gren1 = 0,
	gren2 = 4,
	respawntime = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function grenadebackpack:dropatspawn() return false end


endzone = finished:new({pos = 1})
secretzone = takesecret:new({pos = 1})