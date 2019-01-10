--[[
  Pixel Vision 8 - New Template Script
  Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
  Created by Jesse Freeman (@jessefreeman)

  This project was designed to display some basic instructions when you create
  a new game.  Simply delete the following code and implement your own Init(),
  Update() and Draw() logic.

  Learn more about making Pixel Vision 8 games at https://www.gitbook.com/@pixelvision8
]]--

-- This this is an empty game, we will the following text. We combined two sets of fonts into
-- the default.font.png. Use uppercase for larger characters and lowercase for a smaller one.
local message = "SPRITE BLOCK DEMO\n\n\nThe DrawSpriteBlock() API allows you to create larger sprites from a 'block' of sprites in memory. The first example is 2x2 collection, the second is 3x3 and the last is 4x4."
-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.

local mode = 0
local delay = 1
local time = 2

function Init()

  -- Here we are manually changing the background color
  BackgroundColor(32)

  local display = Display()

  -- We are going to render the message in a box as tiles. To do this, we need to wrap the
  -- text, then split it into lines and draw each line.
  local wrap = WordWrap(message, (display.x / 8) - 2)
  local lines = SplitLines(wrap)
  local total = #lines
  local startY = ((display.y / 8) - 1) - total

  -- We want to render the text from the bottom of the screen so we offset it and loop backwards.
  for i = total, 1, - 1 do
    DrawText(lines[i], 1, startY + (i - 1), DrawMode.Tile, "default")
  end

  -- DrawSprites({16, 17, 18, 29}, 0, 0, 2, false, false, DrawMode.TilemapCache)--, colorOffset, onScreen, useScrollPos, bounds)
  DrawSpriteBlock(16, 1, 8, 16, 4, false, false, DrawMode.Tile, 5)
  -- DrawSprite(16, 0, 0, false, false, DrawMode.TilemapCache)
  -- DrawSprite(17, 8, 0, false, false, DrawMode.TilemapCache)
end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame
-- before the Draw() method. It accepts one argument, timeDelta, which is the difference in
-- milliseconds since the last frame.
function Update(timeDelta)

  -- TODO add your own update logic here

  time = time + timeDelta

  if(time > delay) then
    time = 0
    mode = mode + 1

    if(mode > 3) then
      mode = 1
    end

    ChangeMode(mode)

  end

end

function ChangeMode(mode)

  -- Reset the tiles
  DrawSpriteBlock(16, 1, 8, 4, 4, false, false, DrawMode.Tile, 5)

  local size = mode + 1

  DrawSpriteBlock(16, 1, 8, size, size, false, false, DrawMode.Tile, 0)

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where
-- all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw()

  -- We can use the RedrawDisplay() method to clear the screen and redraw the tilemap in a
  -- single call.
  RedrawDisplay()

  DrawSpriteBlock(16, 8, 8, 2, 2, false, false, DrawMode.Sprite, mode == 1 and 0 or 5)
  --
  DrawSpriteBlock(16, 40, 8, 3, 3, false, false, DrawMode.Sprite, mode == 2 and 0 or 5)
  --
  DrawSpriteBlock(16, 80, 8, 4, 4, false, false, DrawMode.Sprite, mode == 3 and 0 or 5)
  -- TODO add your own draw logic here.

end
