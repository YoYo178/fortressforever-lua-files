
IncludeScript("base_ctf");

--------------------------------------------------
-- Clips (Modified from something MulchmanMM posted on the forums, some random post I dunno :P)
---------------------------------------------------

clip_brush = trigger_ff_clip:new({ clipflags = 0 })

bouncedoor = clip_brush:new({ clipflags = {ClipFlags.kClipProjectiles, ClipFlags.kClipTeamBlue} })
