IncludeScript("base_location");
IncludeScript("base_teamplay");

location_jump1 = location_info:new({ text = "Jump 1", team = NO_TEAM })
location_jump2 = location_info:new({ text = "Jump 2", team = NO_TEAM })
location_jump3 = location_info:new({ text = "Jump 3", team = NO_TEAM })
location_jump4 = location_info:new({ text = "Jump 4", team = NO_TEAM })
location_jump5 = location_info:new({ text = "Jump 5", team = NO_TEAM })
location_jump6 = location_info:new({ text = "Jump 6", team = NO_TEAM })
location_jump7 = location_info:new({ text = "Jump 7", team = NO_TEAM })

specific_tele = info_ff_script:new({ class = Player.kCivilian, team = Team.kUnassigned })

function specific_tele:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team
   end
   return EVENT_DISALLOWED 
end

blue_tele = specific_tele:new({ team = Team.kBlue })
red_tele = specific_tele:new({ team = Team.kRed })


function startup()

	SetTeamName( Team.kBlue, "Quad" )
	
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kRed )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	SetTeamName( Team.kRed, "Quad" )

	local team = GetTeam( Team.kRed )
	team:SetAllies( Team.kBlue )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

end

----------------------------------------------------------------------
-- Set quad and invul when damage is taken by soldier and demoman
-- on red team
----------------------------------------------------------------------

function player_ondamage( player, damageinfo )
    local class = player:GetClass()
    if class == Player.kSoldier or class == Player.kDemoman then
	local damageforce = damageinfo:GetDamageForce()
	damageinfo:SetDamageForce(Vector( damageforce.x * 4, damageforce.y * 4, damageforce.z * 4))
	damageinfo:SetDamage( 0 )
    end
end

specific_tele = info_ff_script:new({ class = Player.kCivilian, team = Team.kUnassigned })

function specific_tele:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team
   end
   return EVENT_DISALLOWED 
end

blue_tele = specific_tele:new({ team = Team.kBlue })
red_tele = specific_tele:new({ team = Team.kRed })

------------------------------------------------------------------
-- BAGS
------------------------------------------------------------------

tyrantquad = genericbackpack:new({
	health = 200,
	armor = 150,
	grenades = 60,
	bullets = 60,
	nails = 60,
	shells = 60,
	rockets = 60,
	cells = 60,
	gren1 = 4,
	gren2 = 4,
	respawntime = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function tyrantquad:dropatspawn() return false end