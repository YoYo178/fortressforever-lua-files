
-- ff_beta.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_soldierarena");
IncludeScript("base_teamplay");
-----------------------------------------------------------------------------
-- startup 
-----------------------------------------------------------------------------
function startup()
	SetTeamName(Team.kBlue, "Blue Pirates")
	SetTeamName(Team.kRed, "Red Ninjas")
	SetTeamName(Team.kYellow, "Yellow Sasquatches")
	SetTeamName(Team.kGreen, "Green Zombies")
	
	-- set up team limits
	local team = GetTeam( Team.kBlue )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( 0 )

	team = GetTeam( Team.kRed )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( 0 ) 

	team = GetTeam( Team.kYellow )
	team:SetPlayerLimit( 0 )	
	team:SetClassLimit( 0 ) 

	team = GetTeam( Team.kGreen )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( 0 ) 

end
-----------------------------------------------------------------------------
-- Spawn Supplies
-----------------------------------------------------------------------------

function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	--player:AddAmmo( Ammo.kDetpack, 1 )

	--player:RemoveAmmo( Ammo.kGren2, 4 )
end



-----------------------------------------------------------------------------
-- Bags
-----------------------------------------------------------------------------

blue_bagcustom = genericbackpack:new({ 
	health = 100,
	armor = 300,
	grenades = 20,
	bullets = 300,
	nails = 300,
	shells = 300,
	rockets = 300,
	cells = 200,
	detpacks = 1,
	gren1 = 4,
	gren2 = 4,
	respawntime = 3,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}
})
red_bagcustom = genericbackpack:new({ 
	health = 100,
	armor = 300,
	grenades = 20,
	bullets = 300,
	nails = 300,
	shells = 300,
	rockets = 300,
	cells = 100,
	detpacks = 1,
	gren1 = 4,
	gren2 = 4,
	respawntime = 3,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}
})
-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

location_bluespawnpool = location_info:new({ text = "Blue Spawn Pool", team = Team.kBlue })
location_bluecompressionchamber = location_info:new({ text = "Blue Compression Chamber", team = Team.kBlue })
location_blueflagroom = location_info:new({ text = "Blue Flagroom", team = Team.kBlue })
location_bluebottomcorridors = location_info:new({ text = "Blue Bottom Corridors", team = Team.kBlue })
location_bluetopcorridors = location_info:new({ text = "Blue Top Corridors", team = Team.kBlue })

location_redspawnpool = location_info:new({ text = "Red Spawn Pool", team = Team.kRed })
location_redcompressionchamber = location_info:new({ text = "Red Compression Chamber", team = Team.kRed })
location_redflagroom = location_info:new({ text = "Red Flagroom", team = Team.kRed })
location_redbottomcorridors = location_info:new({ text = "Red Bottom Corridors", team = Team.kRed })
location_redtopcorridors = location_info:new({ text = "Red Top Corridors", team = Team.kRed })

location_middlesubmarine = location_info:new({ text = "Middle Submarine", team = NO_TEAM })

-----------------------------------------------------------------------------
-- Buttons
-----------------------------------------------------------------------------

bluebutton1 = func_button:new({}) 
function bluebutton1:ondamage() OutputEvent( "bluebutton1", "Open" ) end 
function bluebutton1:onpress() OutputEvent( "bluebutton1", "Open" ) end 
bluebutton2 = func_button:new({}) 
function bluebutton2:ondamage() OutputEvent( "bluebutton2", "Open" ) end 
function bluebutton2:onpress() OutputEvent( "bluebutton2", "Open" ) end 
bluebutton3 = func_button:new({}) 
function bluebutton3:ondamage() OutputEvent( "bluebutton3", "Open" ) end 
function bluebutton3:onpress() OutputEvent( "bluebutton3", "Open" ) end 
bluebutton4 = func_button:new({}) 
function bluebutton4:ondamage() OutputEvent( "bluebutton4", "Open" ) end 
function bluebutton4:onpress() OutputEvent( "bluebutton4", "Open" ) end 
bluebutton5 = func_button:new({}) 
function bluebutton5:ondamage() OutputEvent( "bluebutton5", "Open" ) end 
function bluebutton5:onpress() OutputEvent( "bluebutton5", "Open" ) end 
bluebutton6 = func_button:new({}) 
function bluebutton6:ondamage() OutputEvent( "bluebutton6", "Open" ) end 
function bluebutton6:onpress() OutputEvent( "bluebutton6", "Open" ) end 
bluebutton7 = func_button:new({}) 
function bluebutton7:ondamage() OutputEvent( "bluebutton7", "Open" ) end 
function bluebutton7:onpress() OutputEvent( "bluebutton7", "Open" ) end 
bluebutton8 = func_button:new({}) 
function bluebutton8:ondamage() OutputEvent( "bluebutton8", "Open" ) end 
function bluebutton8:onpress() OutputEvent( "bluebutton8", "Open" ) end 

redbutton1 = func_button:new({}) 
function redbutton1:ondamage() OutputEvent( "redbutton1", "Open" ) end 
function redbutton1:onpress() OutputEvent( "redbutton1", "Open" ) end 
redbutton2 = func_button:new({}) 
function redbutton2:ondamage() OutputEvent( "redbutton2", "Open" ) end 
function redbutton2:onpress() OutputEvent( "redbutton2", "Open" ) end 
redbutton3 = func_button:new({}) 
function redbutton3:ondamage() OutputEvent( "redbutton3", "Open" ) end 
function redbutton3:onpress() OutputEvent( "redbutton3", "Open" ) end 
redbutton4 = func_button:new({}) 
function redbutton4:ondamage() OutputEvent( "redbutton4", "Open" ) end 
function redbutton4:onpress() OutputEvent( "redbutton4", "Open" ) end 
redbutton5 = func_button:new({}) 
function redbutton5:ondamage() OutputEvent( "redbutton5", "Open" ) end 
function redbutton5:onpress() OutputEvent( "redbutton5", "Open" ) end 
redbutton6 = func_button:new({}) 
function redbutton6:ondamage() OutputEvent( "redbutton6", "Open" ) end 
function redbutton6:onpress() OutputEvent( "redbutton6", "Open" ) end 
redbutton7 = func_button:new({}) 
function redbutton7:ondamage() OutputEvent( "redbutton7", "Open" ) end 
function redbutton7:onpress() OutputEvent( "redbutton7", "Open" ) end 
redbutton8 = func_button:new({}) 
function redbutton8:ondamage() OutputEvent( "redbutton8", "Open" ) end 
function redbutton8:onpress() OutputEvent( "redbutton8", "Open" ) end 

bluearena0_telebutton1 = func_button:new({}) 
function bluearena0_telebutton1:ondamage() OutputEvent( "bluearena0_telebutton1", "Open" ) end 
function bluearena0_telebutton1:onpress() OutputEvent( "bluearena0_telebutton1", "Open" ) end 
bluearena0_telebutton2 = func_button:new({}) 
function bluearena0_telebutton2:ondamage() OutputEvent( "bluearena0_telebutton2", "Open" ) end 
function bluearena0_telebutton2:onpress() OutputEvent( "bluearena0_telebutton2", "Open" ) end 
bluearena0_telebutton3 = func_button:new({}) 
function bluearena0_telebutton3:ondamage() OutputEvent( "bluearena0_telebutton3", "Open" ) end 
function bluearena0_telebutton3:onpress() OutputEvent( "bluearena0_telebutton3", "Open" ) end 
bluearena0_telebutton4 = func_button:new({}) 
function bluearena0_telebutton4:ondamage() OutputEvent( "bluearena0_telebutton4", "Open" ) end 
function bluearena0_telebutton4:onpress() OutputEvent( "bluearena0_telebutton4", "Open" ) end 
bluearena0_telebutton5 = func_button:new({}) 
function bluearena0_telebutton5:ondamage() OutputEvent( "bluearena0_telebutton5", "Open" ) end 
function bluearena0_telebutton5:onpress() OutputEvent( "bluearena0_telebutton5", "Open" ) end 
bluearena0_telebutton6 = func_button:new({}) 
function bluearena0_telebutton6:ondamage() OutputEvent( "bluearena0_telebutton6", "Open" ) end 
function bluearena0_telebutton6:onpress() OutputEvent( "bluearena0_telebutton6", "Open" ) end 
bluearena0_telebutton7 = func_button:new({}) 
function bluearena0_telebutton7:ondamage() OutputEvent( "bluearena0_telebutton7", "Open" ) end 
function bluearena0_telebutton7:onpress() OutputEvent( "bluearena0_telebutton7", "Open" ) end 
bluearena0_telebutton8 = func_button:new({}) 
function bluearena0_telebutton8:ondamage() OutputEvent( "bluearena0_telebutton8", "Open" ) end 
function bluearena0_telebutton8:onpress() OutputEvent( "bluearena0_telebutton8", "Open" ) end 

redarena0_telebutton1 = func_button:new({}) 
function redarena0_telebutton1:ondamage() OutputEvent( "redarena0_telebutton1", "Open" ) end 
function redarena0_telebutton1:onpress() OutputEvent( "redarena0_telebutton1", "Open" ) end 
redarena0_telebutton2 = func_button:new({}) 
function redarena0_telebutton2:ondamage() OutputEvent( "redarena0_telebutton2", "Open" ) end 
function redarena0_telebutton2:onpress() OutputEvent( "redarena0_telebutton2", "Open" ) end 
redarena0_telebutton3 = func_button:new({}) 
function redarena0_telebutton3:ondamage() OutputEvent( "redarena0_telebutton3", "Open" ) end 
function redarena0_telebutton3:onpress() OutputEvent( "redarena0_telebutton3", "Open" ) end 
redarena0_telebutton4 = func_button:new({}) 
function redarena0_telebutton4:ondamage() OutputEvent( "redarena0_telebutton4", "Open" ) end 
function redarena0_telebutton4:onpress() OutputEvent( "redarena0_telebutton4", "Open" ) end 
redarena0_telebutton5 = func_button:new({}) 
function redarena0_telebutton5:ondamage() OutputEvent( "redarena0_telebutton5", "Open" ) end 
function redarena0_telebutton5:onpress() OutputEvent( "redarena0_telebutton5", "Open" ) end 
redarena0_telebutton6 = func_button:new({}) 
function redarena0_telebutton6:ondamage() OutputEvent( "redarena0_telebutton6", "Open" ) end 
function redarena0_telebutton6:onpress() OutputEvent( "redarena0_telebutton6", "Open" ) end 
redarena0_telebutton7 = func_button:new({}) 
function redarena0_telebutton7:ondamage() OutputEvent( "redarena0_telebutton7", "Open" ) end 
function redarena0_telebutton7:onpress() OutputEvent( "redarena0_telebutton7", "Open" ) end 
redarena0_telebutton8 = func_button:new({}) 
function redarena0_telebutton8:ondamage() OutputEvent( "redarena0_telebutton8", "Open" ) end 
function redarena0_telebutton8:onpress() OutputEvent( "redarena0_telebutton8", "Open" ) end 

-----------------------------------------------------------------------------
-- Spawns
-----------------------------------------------------------------------------

red_o_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kCivilian) or (player:GetClass() == Player.kCivilian) or (player:GetClass() == Player.kCivilian))) end
red_d_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kCivilian) == false))) end

red_ospawn = { validspawn = red_o_only }
red_dspawn = { validspawn = red_d_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kCivilian) or (player:GetClass() == Player.kCivilian) or (player:GetClass() == Player.kCivilian))) end
blue_d_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kCivilian) == false))) end

blue_ospawn = { validspawn = blue_o_only }
blue_dspawn = { validspawn = blue_d_only }

yellow_o_only = function(self,player) return ((player:GetTeamId() == Team.kYellow) and ((player:GetClass() == Player.kCivilian) or (player:GetClass() == Player.kCivilian) or (player:GetClass() == Player.kCivilian))) end
yellow_d_only = function(self,player) return ((player:GetTeamId() == Team.kYellow) and (((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kCivilian) == false))) end

yellow_ospawn = { validspawn = yellow_o_only }
yellow_dspawn = { validspawn = yellow_d_only }

green_o_only = function(self,player) return ((player:GetTeamId() == Team.kGreen) and ((player:GetClass() == Player.kCivilian) or (player:GetClass() == Player.kCivilian) or (player:GetClass() == Player.kCivilian))) end
green_d_only = function(self,player) return ((player:GetTeamId() == Team.kGreen) and (((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kCivilian) == false))) end

green_ospawn = { validspawn = green_o_only }
green_dspawn = { validspawn = green_d_only }
