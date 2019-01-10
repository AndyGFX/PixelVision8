--[[
  Pixel Vision 8 - New Template Script
  Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
  Created by Jesse Freeman (@jessefreeman)

  This project was designed to display some basic instructions when you create
  a new game.  Simply delete the following code and implement your own Init(),
  Update() and Draw() logic.

  Learn more about making Pixel Vision 8 games at https://www.gitbook.com/@pixelvision8
]]--

LoadScript("sb-sprites")
LoadScript("entities")

-- This this is an empty game, we will the following text. We combined two sets of fonts into
-- the default.font.png. Use uppercase for larger characters and lowercase for a smaller one.
local message = "NES SPRITE EXAMPLE\n\n\nThis example shows how to render sprites based on the original Nintendo's limitation of 3 colors per sprite (the 4th color was transparent). To get additional colors, extra sprite are overlaid on top of the base animation."

local guyEntity = CreateGuyEntity(8, 8)

local girlEntity = CreateGirlEntity(32, 8, 8)

local zombieEntity = CreateZombieEntity(56, 8)

local state = 1
local totalStates = 3
local speed = .08

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.
function Init()

  -- Here we are manually changing the background color
  BackgroundColor(33)

  local display = Display()

  -- We are going to render the message in a box as tiles. To do this, we need to wrap the
  -- text, then split it into lines and draw each line.
  local wrap = WordWrap(message, (display.x / 8) - 2)
  local lines = SplitLines(wrap)
  local total = #lines
  local startY = ((display.y / 8) - 1) - total

  -- We want to render the text from the bottom of the screen so we offset it and loop backwards.
  for i = total, 1, - 1 do
    DrawText(lines[i], 1, startY + (i - 1), DrawMode.Tile, "default", 32)
  end

  -- Draw Furniture
  local furniture = {
    furniturecouch,
    furnituredresserlarge,
    furnituredressermedium,
    furnituredressersmall,
    furnituretable,
    furnituretv
  }
  local nextCol = 1

  for i=1,#furniture do

    local item = furniture[i]

    DrawSprites(item.spriteIDs, nextCol, 8, item.width, false, false, DrawMode.Tile, 24)

    nextCol = nextCol + item.width + 1

  end

end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame
-- before the Draw() method. It accepts one argument, timeDelta, which is the difference in
-- milliseconds since the last frame.
function Update(timeDelta)

  UpdateAnimatedEntity(guyEntity, timeDelta)
  UpdateAnimatedEntity(girlEntity, timeDelta)
  UpdateAnimatedEntity(zombieEntity, timeDelta)

  -- Up Arrow
  if( Button(0, InputState.Released, 0)) then
    speed = speed - .01
  -- Down Arrow
  elseif( Button(1, InputState.Released, 0)) then
    speed = speed + .01
  end

  -- Left Arrow
  if( Button(2, InputState.Released, 0)) then
    state = Clamp(state - 1, 1, 3)
  -- Right Arrow
  elseif( Button(3, InputState.Released, 0)) then
    state = Clamp(state + 1, 1, 3)
  end

  -- Update entities
  guyEntity.frameDelay = speed
  girlEntity.frameDelay = speed
  zombieEntity.frameDelay = speed
  guyEntity.currentState = state
  girlEntity.currentState = state

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where
-- all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw()

  -- We can use the RedrawDisplay() method to clear the screen and redraw the tilemap in a
  -- single call.
  RedrawDisplay()

  DrawAnimatedEntity(guyEntity)
  DrawAnimatedEntity(girlEntity)
  DrawAnimatedEntity(zombieEntity)

  -- Draw new text on top of the tilemap data cache so we can maintain the transparency
  DrawText("TSP " .. ReadTotalSprites(), 12 * 8, 8, DrawMode.UI, "default", 32)
  DrawText("FPS " .. ReadFPS(), 20 * 8, 8, DrawMode.UI, "default", 32)
  DrawText("State " .. state, 12 * 8, 16, DrawMode.UI, "default", 32)
  DrawText("Speed " .. speed, 12 * 8, 24, DrawMode.UI, "default", 32)

end
