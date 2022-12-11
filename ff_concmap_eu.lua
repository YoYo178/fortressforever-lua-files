IncludeScript("base_teamplay");
IncludeScript("base_quad");

function startup()
SetTeamName( Team.kBlue, "Conc Jumpers" )
SetTeamName( Team.kRed, "Quad Jumpers" )
SetTeamName( Team.kGreen, "The Plaza People" )

SetPlayerLimit( Team.kBlue, 0 )
SetPlayerLimit( Team.kRed, 0 )
SetPlayerLimit( Team.kYellow, -1 )
SetPlayerLimit( Team.kGreen, 0 )

-- BLUE TEAM
local team = GetTeam( Team.kBlue )
team:SetAllies( Team.kRed )
team:SetAllies( Team.kGreen )

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
team:SetAllies( Team.kGreen )

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

-- GREEN TEAM
local team = GetTeam( Team.kGreen )
team:SetAllies( Team.kBlue )
team:SetAllies( Team.kRed )

team:SetClassLimit( Player.kHwguy, -1 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kCivilian, 0 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kScout, -1 )
team:SetClassLimit( Player.kMedic, -1 )
team:SetClassLimit( Player.kSoldier, -1 )
team:SetClassLimit( Player.kDemoman, -1 )
team:SetClassLimit( Player.kPyro, -1 )
team:SetClassLimit( Player.kEngineer, -1 )
end



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
-- CHECK IF DIZZYNESS SHOULD BE TURNED ON
-----------------------------------------------------------------------------

function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then
		return EVENT_DISALLOWED
	end

	return EVENT_ALLOWED
end

-----------------------------------------------------------------------------
-- Precache Sounds
-----------------------------------------------------------------------------

function precache()
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("misc.doop")
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

-----------------------------------------------------------------------------
-- Secret Bag
-----------------------------------------------------------------------------

function takesecret:onendtouch(touch_entity)
	local player = CastToPlayer(touch_entity)
	local class = player:GetClass()
	if playerSecretTable[player:GetId()] == nil then playerSecretTable[player:GetId()] = {secret = 0, maxsecret = 0} end
	if playerSecretTable[player:GetId()]['secret'] < self.pos then
    		if class == Player.kCivilian then return end
		playerSecretTable[player:GetId()]['secret'] = self.pos
		if playerSecretTable[player:GetId()]['maxsecret'] < self.pos then
			playerSecretTable[player:GetId()]['maxsecret'] = self.pos
			player:AddFortPoints( LEET_POINTS, "Reached Secret Zone" )
			ConsoleToAll( player:GetName() .. " found Renegade's bag of 1337ness!" )
			BroadCastMessage( player:GetName() .. " found Renegade's bag of 1337ness!" )
			SmartSound(player, "misc.doop", "", "")
		end
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
			player:AddFortPoints( END_POINTS, "Reached The Plaza" )
			ConsoleToAll( player:GetName() .. " has finished ff_concmap_eu" )
			BroadCastMessage( player:GetName() .. " has finished ff_concmap_eu" )
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