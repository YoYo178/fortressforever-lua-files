--[[
ISC License

Copyright 2024 mv <mv@darkok.xyz>

Permission to use, copy, modify, and/or distribute this software for any 
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES 
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN 
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF 
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
--]]

IncludeScript("base_teamplay");
IncludeScript("base_location");
IncludeScript("base_multimode");
IncludeScript("lbgotyfunctions");

function startup()
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, 0)
	SetPlayerLimit(Team.kGreen, 0)
end

function precache()
	PrecacheSound("Backpack.Touch")
	PrecacheSound("misc.bloop")
end

tdm_spawn = function (player_entity)
	local player = CastToPlayer( player_entity )
	player:AddHealth(400)
	player:AddArmor(400)

	player:AddAmmo(Ammo.kNails,   400)
	player:AddAmmo(Ammo.kShells,  400)
	player:AddAmmo(Ammo.kRockets, 400)
	player:AddAmmo(Ammo.kCells,   400)
	player:AddAmmo(Ammo.kDetpack,   1)
	player:AddAmmo(Ammo.kManCannon, 1)
	player:AddAmmo(Ammo.kGren1,		4)
	player:AddAmmo(Ammo.kGren2,		4)
	if player:GetClass() == Player.kCivilian then
		player:GiveWeapon("ff_weapon_tommygun", true)
	end
end

tdm_killed = function (player_entity, damageinfo)
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

tdm_ondamage = function (player_entity, damageinfo) end

player_spawn = tdm_spawn
player_killed = tdm_killed
player_ondamage = tdm_ondamage

-- locations
location_bay = location_info:new({text = "Loading Bay"})
location_basement = location_info:new({text = "Basement"})
location_booth = location_info:new({text = "Security Booth"})
location_compartment = location_info:new({text = "Compartment"})
location_hwmid = location_info:new({text = "Mid Hallway"})
location_hwsewer = location_info:new({text = "Sewer Entrance Hallway"})
location_hwbasement = location_info:new({text = "Basement Hallway"})
location_sewer = location_info:new({text = "Sewer"})
location_sewerentrance = location_info:new({text = "Sewer Entrance"})
location_deadend = location_info:new({text = "Dead End"})

-----------------------------------------------------------------------------------------------------------------------------
-- bags
-----------------------------------------------------------------------------------------------------------------------------
ff_packs = genericbackpack:new({
	health = 40,
	armor = 50,
	
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 80,
	
	gren1 = 1,
	gren2 = 0,
	
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

ff_spam = genericbackpack:new({
	health = 70,
	armor = 100,
	
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 80,
	
	gren1 = 4,
	gren2 = 4,
	
	respawntime = 60,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function resetclasses()
	for i = Team.kBlue, Team.kGreen do
		team = GetTeam(i)
		team:SetClassLimit(Player.kScout, 0)
		team:SetClassLimit(Player.kSniper, 0)
		team:SetClassLimit(Player.kSoldier, 0)
		team:SetClassLimit(Player.kDemoman, 0)
		team:SetClassLimit(Player.kMedic, 0)
		team:SetClassLimit(Player.kHwguy, 0)
		team:SetClassLimit(Player.kPyro, 0)
		team:SetClassLimit(Player.kSpy, 0)
		team:SetClassLimit(Player.kEngineer, 0)
		team:SetClassLimit(Player.kCivilian, 0)
	end
end

function spawn_check(self, player_entity)
	fbs = self.fbs
	if (gamemodes["fux"].currentlyrunning and fbs == false) then return false end
	if (gamemodes["fux"].currentlyrunning == false and fbs) then return false end
	return true
end

fuxbox_spawn = {validspawn = spawn_check, fbs = true}
spawn = {validspawn = spawn_check, fbs = false}

-- gamemode registry

register_gm("tdm","Team Deathmatch", function()
	ConsoleToAll("tdm running")
	player_spawn = tdm_spawn
	player_killed = tdm_killed
	player_ondamage = tdm_ondamage	
end, function() end)
gamemodes["tdm"].currentlyrunning = true -- its a hack i know but i couldn't think of anything else that isn't convoluted

register_gm("ca","Clan Arena", function()
	OutputEvent("hevcharger", "Disable")
	OutputEvent("hpcharger", "Disable")
	for ent_id, ent in ipairs(GlobalEntityList) do
	    if ent:GetClassName() == "info_ff_script" then
	        CastToInfoScript(ent):Remove()
	    end
	end
	player_spawn = tdm_spawn
	player_killed = ca_killed
	player_ondamage = ca_ondamage
end, function()
		OutputEvent("hevcharger", "Enable")
		OutputEvent("hpcharger", "Enable")
		for ent_id, ent in ipairs(GlobalEntityList) do
		    if ent:GetClassName() == "info_ff_script" then
		        CastToInfoScript(ent):Restore()
		    end
		end
		ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, 
		AT.kStopPrimedGrens, AT.kReloadClips, AT.kAllowRespawn, AT.kReturnDroppedItems })
end)

register_gm("dpm","Detpack Mania", function()
	player_spawn = dpm_spawn
	player_killed = tdm_killed
	player_ondamage = dpm_ondamage
	ff_packs.detpacks = 1
	ff_spam.detpacks = 1
	for i = Team.kBlue, Team.kGreen do
		team = GetTeam(i)
		team:SetClassLimit(Player.kScout, -1)
		team:SetClassLimit(Player.kSniper, -1)
		team:SetClassLimit(Player.kSoldier, -1)
		team:SetClassLimit(Player.kDemoman, 0)
		team:SetClassLimit(Player.kMedic, -1)
		team:SetClassLimit(Player.kHwguy, -1)
		team:SetClassLimit(Player.kPyro, -1)
		team:SetClassLimit(Player.kSpy, -1)
		team:SetClassLimit(Player.kEngineer, -1)
		team:SetClassLimit(Player.kCivilian, -1)
	end
	for _,player in ipairs(GetPlayers()) do 
			if player_table[player:GetSteamID()] == nil then player_table[player:GetSteamID()] = {} end
			BroadCastMessageToPlayer(player, "DPM is on! Switching everyone to Demoman")
			player_table[player:GetSteamID()].previousclass = player:GetClass()
			ApplyToPlayer(player, {AT.kChangeClassDemoman, AT.kRespawnPlayers})
	end
end,
function()
	ff_packs.detpacks = 0
	ff_spam.detpacks = 0
	AddSchedule("asdz", 1, function() -- shitty hack to give time for the next gamemode init function
	for _,player in ipairs(GetPlayers()) do 
		if player_table[player:GetSteamID()].previousclass ~= nil then
			local resp = player_table[player:GetSteamID()].previousclass+16
			print(resp)
			ApplyToPlayer(player, {resp, AT.kRespawnPlayers})
		end
	end
	end)
	resetclasses()
end)

register_gm("fux","Fuxbox Mode", function()
	player_spawn = tdm_spawn
	player_killed = tdm_killed
	player_ondamage = tdm_ondamage	
	OutputEvent("fuxbox",           "Enable")
	OutputEvent("greencrates_main", "Disable")
	OutputEvent("rail_fb",          "Disable")
	ApplyToAll({AT.kRespawnPlayers})
end, function()
	OutputEvent("fuxbox",           "Disable")
	OutputEvent("greencrates_main", "Enable")
	OutputEvent("rail_fb",          "Enable")
	ApplyToAll({AT.kRespawnPlayers})
end)


