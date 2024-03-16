IncludeScript("base_location");
IncludeScript("base_teamplay");

function startup()

	SetTeamName( Team.kBlue, "-t5 Tiger Scouts" )
	
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, -1 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kRed )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
end
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

grenadebackpack = genericbackpack:new({
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
function grenadebackpack:dropatspawn() return false end

Finished_Players = Collection()

function player_ondisconnect(player_id)
	local player = CastToPlayer(player_id)
	if Finished_Players:HasItem(player) then
		Finished_Players:RemoveItem(player) -- Remove player from Finished Players when they leave.
	end
end

Victory_Point = trigger_ff_script:new({})

function Victory_Point:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		if Finished_Players:HasItem(player) then
			return 0 -- This player has already finished the map.
		else
			BroadCastMessage(player:GetName() .. ' has completed Concmasta! Congratulations!', 5, Color.kRed) -- 5 seconds, red color
			player:AddFortPoints(19547796, 'Completed Concmasta!')
			Finished_Players:AddItem(player)
		end
	end
end

Base_Trigger = trigger_ff_script:new({ message = '', seconds = 5, color = Color.kYellow })

function Base_Trigger:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		BroadCastMessageToPlayer(player, self.message, self.seconds, self.color)
	end
end

Jump_1_Trigger = Base_Trigger:new({ message = 'Jump 1. Double Conc.', seconds = 5 })
Jump_2_Trigger = Base_Trigger:new({ message = 'Jump 2. Hand Held.', seconds = 5 })
Jump_3_Trigger = Base_Trigger:new({ message = 'Jump 3. Ramp Slide.', seconds = 5 })
Jump_4_Trigger = Base_Trigger:new({ message = 'Jump 4. Trimps! =D', seconds = 5 })
Jump_5_Trigger = Base_Trigger:new({ message = 'Jump 5. 2 Concs, you don't need 3 you vagina.', seconds = 5 })
Jump_6_Trigger = Base_Trigger:new({ message = 'Jump 6. Drop under, and up.', seconds = 5 })
Jump_7_Trigger = Base_Trigger:new({ message = 'Jump 7. Schtop? 1 hand held, Do it!', seconds = 5 })
Jump_8_Trigger = Base_Trigger:new({ message = 'Jump 8. Tripple, watch out on the other side ;)', seconds = 5 })
Jump_9_Trigger = Base_Trigger:new({ message = 'Jump 1. double conc.', seconds = 5 })
Jump_10_Trigger = Base_Trigger:new({ message = 'Jump 10. Around Teh Corner.', seconds = 5 })
Jump_11_Trigger = Base_Trigger:new({ message = 'Jump 11. In the hole.', seconds = 5 })
Jump_12_Trigger = Base_Trigger:new({ message = 'Jump 12. UP, in the hole, Drop.', seconds = 5 })
Jump_13_Trigger = Base_Trigger:new({ message = 'Jump 13. Ender, Up, Down, Up. Goodluck ;)', seconds = 5 })
Jump_14_Trigger = Base_Trigger:new({ message = 'Jump 14. Nice. You finished. Go through portal to surf =D', seconds = 5 })
Jump_15_Trigger = Base_Trigger:new({ message = 'Surf! Fuck around and wait for everyone to finish =D', seconds = 5 })