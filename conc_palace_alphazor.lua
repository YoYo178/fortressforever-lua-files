IncludeScript("base_teamplay");
-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------

-- Disable conc effect
CONC_EFFECT = 0

--
function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then
		return EVENT_DISALLOWED
	end

	return EVENT_ALLOWED
end

------------------------------------------------------------------
-- BAGS
------------------------------------------------------------------

trigger_conc = trigger_ff_script:new({ team = Team.kBlue })

function trigger_conc:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			player:AddHealth( 400 )
			player:AddArmor( 400 )
			player:AddAmmo( Ammo.kNails, 400 )
			player:AddAmmo( Ammo.kShells, 400 )
			player:AddAmmo( Ammo.kRockets, 400 )
			player:AddAmmo( Ammo.kCells, 400 )
			player:AddAmmo( Ammo.kGren2, 4 )
		end
	end
end



grenadebackpack = genericbackpack:new({
	health = 100,
	armor = 200,
	grenades = 200,
	bullets = 200,
	nails = 200,
	shells = 200,
	rockets = 200,
	cells = 60,
	gren1 = -4,
	gren2 = 200,
	respawntime = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function grenadebackpack:dropatspawn() return false end

function grenadebackpack:dropatspawn() return false end



function player_ondamage( player, damageinfo )
	class = player:GetClass()
	if class == Player.kSoldier or class == Player.kMedic or class == Player.kPyro or class == Player.kDemoman or class == Player.kCivilian then
	    local damageforce = damageinfo:GetDamageForce()
	    damageinfo:SetDamageForce(Vector( damageforce.x * 4, damageforce.y * 4, damageforce.z * 4))
	    damageinfo:SetDamage( 0 )
	end
end

function startup()
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, -1)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	-- CTF maps generally don't have civilians,
	-- so override in map LUA file if you want 'em
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, 10)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
end
