

LoadScript("Test_level_33x31.lua")
local tmxData = Get_Tilemap_000()

LoadScript("TLuaTiled.lua")

local tiled = nil
local tid
local lid



-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.
function Init()

  -- Here we are manually changing the background color
  BackgroundColor(0)

  local display = Display()

  tiled = TLuaTiled:New(tmxData)
  tiled:Prepare()
  lid = tiled:GetLayerID("Platforms")
  tid = tiled:GetTile(lid,0,0)

  --tiled:DrawAsTileMap(lid)

end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame
-- before the Draw() method. It accepts one argument, timeDelta, which is the difference in
-- milliseconds since the last frame.
function Update(timeDelta)

  -- TODO add your own update logic here

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where
-- all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw()

  -- We can use the RedrawDisplay() method to clear the screen and redraw the tilemap in a
  -- single call.
  RedrawDisplay()

  -- TODO add your own draw logic here.

  -- draw tiles to screen with flip flag
  tiled:DrawAsSpriteMap(lid)

end
