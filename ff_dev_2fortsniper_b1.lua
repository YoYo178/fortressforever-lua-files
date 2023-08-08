--FF_DEV_2FORTSNIPER--

IncludeScript("base_teamplay");

------------------
--Startup---------
------------------

function startup()

	SetTeamName( Team.kBlue, "BLUE TEAM" )
        SetTeamName( Team.kRed, "RED TEAM" )

	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 ) 

        local team = GetTeam(Team.kBlue)
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam(Team.kRed)
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

end

---------------------
--Ammo Check---------
---------------------
function player_spawn( player_entity )
	-- 400 for overkill. of course the values
	-- get clamped in game code
	--local player = GetPlayer(player_id)
	local player = CastToPlayer( player_entity )
	player:AddHealth( 400 )
	player:AddArmor( 400 )

	
	player:AddAmmo( Ammo.kShells, 400 )
	player:RemoveAmmo( Ammo.kRockets, 400 )
	player:RemoveAmmo( Ammo.kCells, 400 )
	player:RemoveAmmo( Ammo.kDetpack, 1 )
	player:RemoveAmmo( Ammo.kManCannon, 1 )
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
        player:RemoveWeapon( "ff_weapon_nailgun" )
        
end

---------------------
--Backpacks----------
---------------------

sniperammo = genericbackpack:new({
	grenades = 0,
	bullets = 100,
	nails = 0,
	shells = 100,
	rockets = 0,
	gren1 = 0,
	gren2 = 0,
	cells = 0,
	armor = 0,
	health = 0,
    respawntime = 5,
	model = "models/items/backpack/backpack_sniperammo.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function sniperammo :dropatspawn() return false end

red_sniperammo = sniperammo:new({ touchflags = {AllowFlags.kRed} })
blue_sniperammo = sniperammo:new({ touchflags = {AllowFlags.kBlue} })


sniperhealth = genericbackpack:new({
	grenades = 0,
	bullets = 100,
	nails = 0,
	shells = 100,
	rockets = 0,
	gren1 = 0,
	gren2 = 0,
	cells = 0,
	armor = 0,
	health = 0,
    respawntime = 5,
	model = "models/items/backpack/backpack_sniperhealth.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function sniperhealth :dropatspawn() return false end

red_sniperhealth = sniperhealth:new({ touchflags = {AllowFlags.kRed} })
blue_sniperhealth = sniperhealth:new({ touchflags = {AllowFlags.kBlue} })

---------------------
--Health Trigger-----
---------------------

healthtrigger = trigger_ff_script:new({})

function healthtrigger:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
            player:AddHealth( 200 )
            player:AddArmor( 200 )

            
	    -- Who is resupplying.
		
	    ConsoleToAll( player:GetName() .. " used the health bag." )
		
	    BroadCastMessageToPlayer( player, "Resupplying..." )
	
        end
end
	
	
	
	
