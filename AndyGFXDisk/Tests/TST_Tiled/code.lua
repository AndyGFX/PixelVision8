

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
  tid = tiled:GetTile(lid,0,0)



--[[
  if tiled:IsAnimated(2) then
    anim = tiled:GetAnimationDataForTile(20)
    DrawText("ID       :" .. anim.id, 1, 1, DrawMode.Tile, "large",15)
    DrawText("frame ID :" .. anim.frame_id, 1, 2, DrawMode.Tile, "large",15)
    DrawText("frames   :" .. anim.frames, 1, 3, DrawMode.Tile, "large",15)
    DrawText("tile ID  :" ..  anim.animation[anim.frame_id].tileid, 1, 4, DrawMode.Tile, "large",15)
    DrawText("Time     :".. anim.time, 1, 5, DrawMode.Tile, "large",15)
  end
]]
  --tiled:DrawAsTileMap(lid)

end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame
-- before the Draw() method. It accepts one argument, timeDelta, which is the difference in
-- milliseconds since the last frame.
function Update(timeDelta)

  -- TODO add your own update logic here
   tiled:Update(timeDelta)
end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where
-- all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw(timeDelta)

  -- We can use the RedrawDisplay() method to clear the screen and redraw the tilemap in a
  -- single call.
  RedrawDisplay()

  -- TODO add your own draw logic here.

  -- draw tiles to screen with flip flag
  tiled:DrawAsSpriteMap(lid)

  local t97 = tiled:GetTile(lid,9,7)
  if tiled:IsAnimated(t97.id) then

    anim = tiled:GetAnimationDataForTile(t97.id)

    DrawText("ID       :" .. anim.id, 1, 1*8, DrawMode.Sprite, "large",15)
    DrawText("frame ID :" .. anim.frame_id, 1, 2*8, DrawMode.Sprite, "large",15)
    DrawText("frames   :" .. anim.frames, 1, 3*8, DrawMode.Sprite, "large",15)
    DrawText("tile ID  :" ..  anim.animation[anim.frame_id].tileid, 1, 4*8, DrawMode.Sprite, "large",15)
    DrawText("Time     :".. anim.time, 1, 5*8, DrawMode.Sprite, "large",15)
    DrawText("map tile :".. t97.id, 1, 6*8, DrawMode.Sprite, "large",15)
  end



end
