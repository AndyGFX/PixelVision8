

LoadScript("Test_level_33x31.lua")
local tmxData = Get_Tilemap_000()

LoadScript("TLuaTiled.lua")

local tiled = nil
local tid
local lid
local anim


-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.
function Init()

  -- Here we are manually changing the background color
  BackgroundColor(0)

  local display = Display()

  tiled = TLuaTiled:New(tmxData)
  tiled:PrepareAnimations()
  --tiled:ResetAnimations()
  lid = tiled:GetLayerID("Platforms")
  --tid = tiled:GetTile(lid,0,0)

  -- Draw Tilemap as DrawMode.Tile
  tiled:DrawAsTileMap(lid)

end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame
-- before the Draw() method. It accepts one argument, timeDelta, which is the difference in
-- milliseconds since the last frame.
function Update(timeDelta)

  -- update animated tiles
   tiled:Update(timeDelta)

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where
-- all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw(timeDelta)

  -- We can use the RedrawDisplay() method to clear the screen and redraw the tilemap in a
  -- single call.
  RedrawDisplay()

  -- update animated tile when DrawMode.Tile is used (don't us this call in Sprite mode)
  tiled:UpdateAnimatedTiles()

  -- draw tiles + animated tile to screen with flip flag in DrawMode.Sprite
  --tiled:DrawAsSpriteMap(lid)

end
