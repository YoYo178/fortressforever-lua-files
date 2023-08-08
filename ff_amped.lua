-- ff_amped.lua
-- Author: NzNexus (a.k.a Ambex)

-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------
IncludeScript("base_respawnturret");
IncludeScript("base_ctf")

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- backpacks  smallpack1=bottomfloor  smallpack2=middlefloor  smallpack3=upperfloor
-----------------------------------------------------------------------------
smallpack = genericbackpack:new({
	grenades = 100,
	bullets = 100,
	nails = 100,
	shells = 100,
	rockets = 100,
	gren1 = 1,
	gren2 = 1,
      cells = 200,
	armor = 100,
	health = 100,
      respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})
function smallpack:dropatspawn() return false end

redsmallpack1 = smallpack:new({ touchflags = {AllowFlags.kRed} })
redsmallpack2 = smallpack:new({ touchflags = {AllowFlags.kRed} })
redsmallpack3 = smallpack:new({ touchflags = {AllowFlags.kRed} })
bluesmallpack1 = smallpack:new({ touchflags = {AllowFlags.kBlue} })
bluesmallpack2 = smallpack:new({ touchflags = {AllowFlags.kBlue} }) 
bluesmallpack3 = smallpack:new({ touchflags = {AllowFlags.kBlue} })
