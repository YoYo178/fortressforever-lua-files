--ff_civibash_g.lua v0.1
--LUA by sidd
--map by GambiT *robbheb82@cox.net*

-----------------------------------------------------------------------------
-- Entities:
-----------------------------------------------------------------------------
--fullgrenbag is a info_ff_script with full grenades. blue_fullgrenbag and red_fullgrenbag are team specific
--fullammobag is same, but with ammo
-----------------------------------------------------------------------------
-- Gameplay info
-----------------------------------------------------------------------------
-- There are 3 teams, blue soldiers, red soldiers, and yellow civi's
-- dogs get 1 point for killing a fox, and 10 for a rabbit
-- foxes get 1 for a dog, 10 for a rabbit
-- rabbits get points at an increasing rate by staying alive
-----------------------------------------------------------------------------

	-------- IMPORTANT FIXME INFORMATION
	-------- THIS LINE DOES NOT WORK AND DON'T KNOW HOW TO FIX IT
	-------- CANT GIVE FOXES OR DOGS POINTS TILL THIS WORKS
	-- local killer = damageinfo.GetAttacker()
	-------- PLS TO BE FIXING FF PLS

IncludeScript("base_teamplay");
        -- Number of seconds between restocks
        RESTOCK_INTERVAL = 1

        -- Amount of rockets to restock every RESTOCK_INTERVAL seconds
        RESTOCK_AMT_ROCKETS = 25

function startup()
        -- Do other team and class limit setup here
        AddScheduleRepeating( "RestockPlayers", RESTOCK_INTERVAL, RestockPlayers )
	
        -- red, blue, and yellow teams
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, -1 )
	
	
	SetTeamName( Team.kBlue, "Blue Soldier's" )
	SetTeamName( Team.kRed, "Red Soldier's" )
	SetTeamName( Team.kYellow, "Yellow Civi's" )
	
	-- red and blue are soldiers only
	-- yellow is civilian only
	local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kRed )
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

	team = GetTeam( Team.kRed )
	team:SetAllies( Team.kBlue )
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

	team = GetTeam( Team.kYellow )
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

-- Run the addscore loop once every 5 seconds
	-- incresaing this frequency will increase the rate at which yellow scores points!
	AddScheduleRepeating("addpoints", 10, addpoints)
end

-- function to perform the actual restock
function RestockPlayers()
    for i = 1, 32 do
        local player = CastToPlayer(GetEntity(i))
        if (player ~= nil) then
            if player:IsAlive() and (player:GetClass() == Player.kSoldier) then
                player:AddAmmo( Ammo.kRockets, RESTOCK_AMT_ROCKETS )
            end
        end
    end
end

-- initialise table of living yellow players
t={}

-- Players only get rockets, full helath and armor
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	
	--give health
	player:AddHealth( 100 )
	player:AddArmor( 300 )
	
	--take grenades
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
	
	-- give rockets
	player:AddAmmo( Ammo.kRockets, 400 )
	
	if player:GetTeamId() ~= Team.kYellow then
		--remove weapons 
		player:RemoveWeapon("ff_weapon_shotgun")
		player:RemoveWeapon("ff_weapon_supershotgun")
		player:RemoveWeapon("ff_weapon_umbrella")
	else
		--add yellow players to table
		t[player_entity] = 1
		--ConsoleToAll(tostring(t[player_entity]))
	end
	 -- This for loop prints out all the lifescoures
	 --for k,v in pairs(t) do
	 --ConsoleToAll(tostring(v))
	 --end
end

remover = trigger_ff_script:new({ })

function remover:allowed( allowed_entity )
	if IsPlayer(allowed_entity) or IsDispenser(allowed_entity) or IsSentrygun(allowed_entity) then
		return EVENT_DISALLOWED
	end
	return EVENT_ALLOWED
end

function player_killed( player_entity, damageinfo )
	-- give red and blue 10 points if they kill a yellow.
	-- give 5 point if red kills blue and vice versa.
	-- -1 point for a teamkill or selfkill
	
	-------- THIS LINE DOES NOT WORK AND DON'T KNOW HOW TO FIX IT
	local killer = damageinfo.GetAttacker()
	-------- PLS TO BE FIXING FF PLS
	
	
	if IsPlayer(killer) then -- only give points to players
		killer = CastToPlayer(killer);
		local player = CastToPlayer( player_entity )
		local killerTeam = killer:GetTeamId()
		local playerTeam = player:GetTeamId()
		if (playerTeam == killerTeam) then
			-- minus one for a teamkill
			killerTeam:AddScore(-1)
			killer:AddFortPoints(-1)
		else
		if (playerTeam == Team.kYellow) then
				-- plus 10 for a civi kill
				killerTeam:AddScore(10)
				killer:AddFortPoints(10)
			else
				-- plus 1 for a opponent kill
				killerTeam:AddScore(5)
				killer:AddFortPoints(5)
			end
		end
	end
	-- remove dead yellow players from the table
	if (playerTeam == Team.kYellow) then
		t[player_entity] = nil
	end
end

function addpoints()
	local yell = GetTeam(Team.kYellow);
	for player_entity, lifescore in pairs(t) do 
		ConsoleToAll(tostring("lifescore = " .. lifescore))
		
		local player = CastToPlayer(player_entity);
		
		-- check they are still yellow
		if ( player:GetTeamId() == Team.kYellow ) then
			ConsoleToAll("Player is still yellow")
			if player:IsAlive() then
			ConsoleToAll(tostring("Still alive with lifescore of " .. lifescore))
				if lifescore < 1 then 
					t[player_entity] = 1
				else
					--incrase pointrate at 10% each second
					t[player_entity] = lifescore*1.1
				end
			else
				-- no points for being dead! remove from table
				t[player_entity] = nil
			end
			yell:AddScore(lifescore/1)
			player:AddFortPoints(lifescore/1)
		else
			--not iterested in them if they have changed team
			ConsoleToAll("Player is not yellow anymore")
			t[player_entity] = nil
		end
	end
end

-----------------------------------------------------------------------------
-- bag containing fullgrens, comes back every 10 seconds
-----------------------------------------------------------------------------
fullgrenbag = genericbackpack:new({
	gren1 = 1,
	gren2 = 1,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Grenades
})
-----------------------------------------------------------------------------
-- bag containing fullammo, but no grenades, health or armor
-----------------------------------------------------------------------------
fullammobag = genericbackpack:new({
	grenades = 400,  -- this is pipe launcher grenades, not frags
	bullets = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 400,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function fullgrenbag:dropatspawn() return false end
function fullammobag:dropatspawn() return false end

-----------------------------------------------------------------------------
-- backpack entity setup (modified for fullgrenbag and fullammobag)
-----------------------------------------------------------------------------
function build_backpacks(tf)
	return healthkit:new({touchflags = tf}),
		   armorkit:new({touchflags = tf}),
		   ammobackpack:new({touchflags = tf}),
		   bigpack:new({touchflags = tf}),
		   grenadebackpack:new({touchflags = tf}),
		   fullgrenbag:new({touchflags = tf}),
		   fullammobag:new({touchflags = tf})
end

blue_healthkit, blue_armorkit, blue_ammobackpack, blue_bigpack, blue_grenadebackpack, blue_fullgrenbag, blue_fullammobag = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
red_healthkit, red_armorkit, red_ammobackpack, red_bigpack ,red_grenadebackpack, red_fullgrenbag, red_fullammobag = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kRed})
