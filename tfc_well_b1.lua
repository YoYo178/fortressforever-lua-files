IncludeScript("base_ctf");
IncludeScript("base_location");
IncludeScript("base_respawnturret");

-----------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-----------------------------------------------------------------------------------------------------------------------------

location_blue_flagroom = location_info:new({ text = "Flag Room", team = Team.kBlue })
location_red_flagroom = location_info:new({ text = "Flag Room", team = Team.kRed })

location_blue_flagwater = location_info:new({ text = "Flag Room Water", team = Team.kBlue })
location_red_flagwater = location_info:new({ text = "Flag Room Water", team = Team.kRed })

location_blue_roof = location_info:new({ text = "Roof", team = Team.kBlue })
location_red_roof = location_info:new({ text = "Roof", team = Team.kRed })

location_blue_battlements = location_info:new({ text = "Battlements", team = Team.kBlue })
location_red_battlements = location_info:new({ text = "Battlements", team = Team.kRed })


location_blue_canal = location_info:new({ text = "Yard Canal", team = Team.kBlue })
location_red_canal = location_info:new({ text = "Yard Canal", team = Team.kRed })

location_blue_yard = location_info:new({ text = "Yard", team = Team.kBlue })
location_red_yard = location_info:new({ text = "Yard", team = Team.kRed })

location_blue_water = location_info:new({ text = "Water tunnels", team = Team.kBlue })
location_red_water = location_info:new({ text = "Water tunnels", team = Team.kRed })

location_blue_water = location_info:new({ text = "Water tunnels", team = Team.kBlue })
location_red_water = location_info:new({ text = "Water tunnels", team = Team.kRed })

location_blue_base = location_info:new({ text = "Blue Base", team = Team.kBlue })
location_red_base = location_info:new({ text = "Red Base", team = Team.kRed })

-----------------------------------------------------------------------------
-- Buttons
-----------------------------------------------------------------------------

blue_fr_button = func_button:new({}) 
function blue_fr_button:ondamage() OutputEvent( "blue_front", "Open" ) end 
function blue_fr_button:ondamage() OutputEvent( "blue_front", "Open" ) end 
function blue_fr_button:ontouch() OutputEvent( "blue_front", "Open" ) end 
function blue_fr_button:ontouch() OutputEvent( "blue_front", "Open" ) end 

red_fr_button = func_button:new({}) 
function red_fr_button:ondamage() OutputEvent( "red_front", "Open" ) end 
function red_fr_button:ondamage() OutputEvent( "red_front", "Open" ) end 
function red_fr_button:ontouch() OutputEvent( "red_front", "Open" ) end 
function red_fr_button:ontouch() OutputEvent( "red_front", "Open" ) end 

blue_fd_button = func_button:new({}) 
function blue_fd_button:ondamage() OutputEvent( "bbars1", "Open" ) end 
function blue_fd_button:ontouch() OutputEvent( "bbars1", "Open" ) end 

red_fd_button = func_button:new({}) 
function red_fd_button:ondamage() OutputEvent( "rbars1", "Open" ) end  
function red_fd_button:ontouch() OutputEvent( "rbars1", "Open" ) end 

-----------------------------------------------------------------------------------------------------------------------------
-- bag for respawns
-----------------------------------------------------------------------------------------------------------------------------
ff_2fort_genericpack = genericbackpack:new({
	health = 400,
	armor = 400,
	
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 400,
	
	gren1 = 0,
	gren2 = 0,
	
	respawntime = 2,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_2fort_genericpack:dropatspawn() return false end
blue_2fort_genericpack = ff_2fort_genericpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_2fort_genericpack = ff_2fort_genericpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

-----------------------------------------------------------------------------------------------------------------------------
-- grenpack
-----------------------------------------------------------------------------------------------------------------------------
ff_2fort_grenpack = genericbackpack:new({
	health = 0,
	armor = 0,
	
	grenades = 0,
	nails = 0,
	shells = 0,
	rockets = 0,
	cells = 0,
	
	gren1 = 2,
	gren2 = 2,
	
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_2fort_grenpack:dropatspawn() return false end
blue_2fort_grenpack = ff_2fort_grenpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_2fort_grenpack = ff_2fort_grenpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

-----------------------------------------------------------------------------------------------------------------------------
-- battlements bags
-----------------------------------------------------------------------------------------------------------------------------
ff_pack = genericbackpack:new({
	health = 20,
	armor = 20,
	
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 80,
	
	gren1 = 0,
	gren2 = 0,
	
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_pack:dropatspawn() return false end

ff_packnade = genericbackpack:new({
	health = 20,
	armor = 20,
	
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 80,
	
	gren1 = 2,
	gren2 = 1,
	
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_packnade:dropatspawn() return false end
-----------------------------------------------------------------------------
-- SPAWNS
-----------------------------------------------------------------------------
red_spiral = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSniper) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kEngineer))) end
red_balc = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSniper) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kSoldier) or (player:GetClass() == Player.kHwguy) or (player:GetClass() == Player.kDemoman) or (player:GetClass() == Player.kPyro))) end

red_spiralspawn = { validspawn = red_spiral }
red_balcspawn = { validspawn = red_balc }

blue_spiral = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSniper) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kEngineer))) end
blue_balc = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSniper) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kSoldier) or (player:GetClass() == Player.kHwguy) or (player:GetClass() == Player.kDemoman) or (player:GetClass() == Player.kPyro))) end

blue_spiralspawn = { validspawn = blue_spiral }
blue_balcspawn = { validspawn = blue_balc }
