-- concmap_b00n_r

IncludeScript("base_location");

CONC_EFFECT = 0

function startup()

	SetTeamName( Team.kBlue, "Concs" )
	SetTeamName( Team.kRed, "Quad" )

	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 ) 
	
	local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kRed )
        team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, 0 )
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
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

end

function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	player:RemoveAmmo( Ammo.kDetpack, 1 )
	player:RemoveAmmo( Ammo.kManCannon, 1 )
	player:RemoveAmmo( Ammo.kGren1, 4 )
        player:AddAmmo( Ammo.kGren2, 4 )
	player:AddHealth( 400 )
	player:AddArmor( 400 )
	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
        class = player:GetClass()
	if class == Player.kSoldier or class == Player.kDemoman or class == Player.kPyro then
	    player:RemoveAmmo( Ammo.kGren2, 4 )
        end
end

skillspack = info_ff_script:new({
	health = 200,
	armor = 200,
	rockets = 400,
	shells = 400,
	cells = 400,
	nails = 400,
	gren = 4,
	respawntime = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed}
})

function skillspack:dropatspawn() return false end

function skillspack:precache( )
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)
	PrecacheModel(self.model)
end

function skillspack:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
	
		local dispensed = 0
		dispensed = dispensed + player:AddHealth( self.health )
		dispensed = dispensed + player:AddArmor( self.armor )
		dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets)
		dispensed = dispensed + player:AddAmmo(Ammo.kShells, self.shells)
		dispensed = dispensed + player:AddAmmo(Ammo.kNails, self.nails)
		dispensed = dispensed + player:AddAmmo(Ammo.kCells, self.cells)
		class = player:GetClass()
		if class == Player.kMedic or class == Player.kScout then
			dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren)
		end
		
		if dispensed >= 1 then
                        BroadCastMessageToPlayer( player, "Restocked!" )
			local backpack = CastToInfoScript(entity);
			if (backpack ~= nil) then
				backpack:EmitSound(self.touchsound);
				backpack:Respawn(self.respawntime);
			end
		end
	end
end

function skillspack:materialize( )
	entity:EmitSound(self.materializesound)
end

function player_ondamage( player, damageinfo )
	class = player:GetClass()
	if class == Player.kSoldier or class == Player.kDemoman or class == Player.kPyro then
	    local damageforce = damageinfo:GetDamageForce()
	    damageinfo:SetDamageForce(Vector( damageforce.x * 4, damageforce.y * 4, damageforce.z * 4))
	    damageinfo:SetDamage( 0 )
	end
end

function player_onconc( player_entity, concer_entity )
	if CONC_EFFECT == 0 then
		return EVENT_DISALLOWED
	end

	return EVENT_ALLOWED
end

j5_ledge_txt = trigger_ff_script:new({})

function j5_ledge_txt:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "What, you can't do it in one go?")
	end
end

tele_access_txt = trigger_ff_script:new({})

function tele_access_txt:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "Teleport Access..")
	end
end

end_tele_1_txt = trigger_ff_script:new({})

function end_tele_1_txt:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "Teleports 1-10")
	end
end

end_tele_2_txt = trigger_ff_script:new({})

function end_tele_2_txt:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "Teleports 11-20")
	end
end

endpoints = trigger_ff_script:new({})

function endpoints:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
            player:AddFortPoints( 1337, "Map Completed")
			player:AddFrags( 1337 )
            BroadCastMessage( player:GetName() .. " has completed the map!" )
         end
end

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
location_jump14 = location_info:new({ text = "Jump 14", team = NO_TEAM })
location_jump15 = location_info:new({ text = "Jump 15", team = NO_TEAM })
location_jump16 = location_info:new({ text = "Jump 16", team = NO_TEAM })
location_jump17 = location_info:new({ text = "Jump 17", team = NO_TEAM })
location_jump18 = location_info:new({ text = "Jump 18", team = NO_TEAM })
location_jump19 = location_info:new({ text = "Jump 19", team = NO_TEAM })
location_jump20 = location_info:new({ text = "Jump 20", team = NO_TEAM })
location_end = location_info:new({ text = "The End", team = NO_TEAM })