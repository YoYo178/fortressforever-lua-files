IncludeScript("base_teamplay")

	VERTICAL_JUMP_TOUCHED = 0
	VERTICAL_JUMP_BROADCASTED = 0

function startup()

	SetTeamName( Team.kBlue, "Jumpers" )
	
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, -1)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)
	
	local team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kCivilian, -1 )
	
end


height_measure = trigger_ff_script:new({ })

function height_measure:ontouch( touch_entity ) 
	if VERTICAL_JUMP_BROADCASTED == 0 then
	if IsPlayer( touch_entity ) then
		local p = CastToPlayer( touch_entity )
		if not p:IsBot() then
			local origin = entity:GetOrigin()
			if origin.z > VERTICAL_JUMP_TOUCHED then
				-------------
				ConsoleToAll( "Upped to: " .. origin.z )
				--------------
				VERTICAL_JUMP_TOUCHED = origin.z
			end
		end
	end	
	end
end

jump_floor = trigger_ff_script:new({ })

function jump_floor:ontouch( touch_entity ) 
	if IsPlayer( touch_entity ) then
		local p = CastToPlayer( touch_entity )
		if not p:IsBot() then
	
			p:AddHealth( 400 )
			p:AddArmor( 400 )
			p:AddAmmo(Ammo.kRockets, 100)
			p:AddAmmo(Ammo.kCells, 100)
			p:AddAmmo(Ammo.kGren1, 4)
			p:AddAmmo(Ammo.kGren2, 4)
			
			if (VERTICAL_JUMP_TOUCHED > 0) then
			------------------
			ConsoleToAll(VERTICAL_JUMP_TOUCHED.." marker touched")
			BroadCastMessage( "Height reached: " .. VERTICAL_JUMP_TOUCHED )
			------------------
			end
		end
	end	
	
	VERTICAL_JUMP_TOUCHED = 0
	VERTICAL_JUMP_BROADCASTED = 0
	
	------------------
	ConsoleToAll( "Reset" )
	------------------
	
end

function player_ondamage( player, damageinfo )
	damageinfo:SetDamage( 0 )
end
