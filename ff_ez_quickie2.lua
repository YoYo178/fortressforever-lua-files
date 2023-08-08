IncludeScript("base_teamplay");



function startup()

SetTeamName( Team.kBlue, "Easy Quadskis" )
SetTeamName( Team.kRed, "Hard Quadskis" )

SetPlayerLimit( Team.kBlue, 0 )

SetPlayerLimit( Team.kRed, 0 )

SetPlayerLimit( Team.kGreen, -1 )

SetPlayerLimit( Team.kYellow, -1 )


	-- BLUE TEAM
	local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kRed )

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

	-- RED TEAM
	local team = GetTeam( Team.kRed )
	team:SetAllies( Team.kBlue )

	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	te

	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kEngineer, -1 )

end


-----------------------------------------------------------------------------

-- global overrides

-----------------------------------------------------------------------------



-- Disable conc effect

CONC_EFFECT = 0

LEET_POINTS = 1337
END_POINTS = 1337


--

function player_onconc( player_entity, concer_entity )



	if CONC_EFFECT == 0 then

		return EVENT_DISALLOWED

	end



	return EVENT_ALLOWED

end


----------------------------------------------------------------------
-- Quad icon
----------------------------------------------------------------------

hudicon = "hud_quad"
hudx = 5
hudy = 110
hudw = 48
hudh = 48
huda = 1
hudstatusicon = "hud_quad.vtf"

----------------------------------------------------------------------
-- Set hud icon at spawn
----------------------------------------------------------------------

function player_spawn( player_entity )
    local player = CastToPlayer( player_entity )
    local class = player:GetClass()
    if class == Player.kSoldier or class == Player.kDemoman or class==Player.kPyro then
	AddHudIcon(player, hudicon, hudstatusicon, hudx, hudy, hudw, hudh, huda)
    else
	RemoveHudItem( player, hudstatusicon )
    end
end

								
----------------------------------------------------------------------
-- Remove hud icon if player changes to spectator
---

    if desiredteam == Team.kSpectator then
    	RemoveHudItem( player, hudstatusicon )
    end
    return true
end

----------------------------------------------------------------------
-- Set quad and invul when damage is taken by soldier and demoman and pyro
----------------------------------------------------------------------

function player_ondamage( player, damageinfo )
   

	local damageforce = damageinfo:GetDamageForce()
	damageinfo:SetDamageForce(Vector( damageforce.x * 4, damageforce.y * 4, damageforce.z * 4))
	damageinfo:SetDamage( 0 )
	if player:GetTeamId() ~= Team.kBlue  then return end
		ApplyToPlayer(player, { AT.kReloadClips })
    end
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

	gren2 = 0,

	respawntime = 1,

	model = "models/items/backpack/backpack.mdl",

	materializesound = "Item.Materialize",

	touchsound = "Backpack.Touch",

	botgoaltype = Bot.kBackPack_Ammo

})

function grenadebackpack:dropatspawn() return false end

