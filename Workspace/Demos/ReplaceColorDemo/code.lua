--[[
  Pixel Vision 8 - Replace Color Demo
  Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
  Created by Jesse Freeman (@jessefreeman)

  This demo simulates how the gameboy color remapped the screen colors based on a
  direction and key press when booting a game.

  Learn more about making Pixel Vision 8 games at https://www.gitbook.com/@pixelvision8
]]--

-- This this is an empty game, we will the following text. We combined two sets of fonts into
-- the default.font.png. Use uppercase for larger characters and lowercase for a smaller one.
local title = "REPLACE COLOR DEMO"
local message = "THIS DEMO SIMULATES HOW THE GAMEBOY COLOR REMAPPED THE SCREEN COLORS BASED ON A DIRECTION AND KEY PRESS WHEN BOOTING A GAME."

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.
function Init()

  -- Here we are manually changing the background color
  BackgroundColor(3)

  local display = Display()

  -- We are going to render the message in a box as tiles. To do this, we need to wrap the
  -- text, then split it into lines and draw each line.
  local wrap = WordWrap(message, ((display.x / 8) * 2) - 2)
  local lines = SplitLines(wrap)
  local total = #lines
  local startY = display.y - (total * 8) + 4

  -- We want to render the text from the bottom of the screen so we offset it and loop backwards.
  for i = total, 1, - 1 do
    DrawText(lines[i], 4, startY + ((i - 1) * 8), DrawMode.TilemapCache, "default", 0, - 4)
  end

  DrawText(title, 4, startY - 12, DrawMode.TilemapCache, "default", 0, - 4)

end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame
-- before the Draw() method. It accepts one argument, timeDelta, which is the difference in
-- milliseconds since the last frame.
function Update(timeDelta)

  -- On first run, check to see if the system colors should be changed
  if(firstRun == nil)then

    -- Call this to remap the system colors based on what key combination is being pressed
    ChangeScreenColor()

    -- Set first run flag to false so this isn't triggered again
    firstRun = false

  end

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where
-- all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw()

  -- We can use the RedrawDisplay() method to clear the screen and redraw the tilemap in a
  -- single call.
  RedrawDisplay()

end

-- This method simulates how the GameBoy Color changed original GameBoy game colors by
-- holding down a special key combination.
-- Press    |   Color       |   Press      |   Color
-- Up       |   Brown       |   Left       |   Blue
-- Up + A   |   Red         |   Left + A   |   Dark Blue
-- Up + B   |   Dark Brown  |   Left + B   |   Grey
-- Down     |   Pale Yellow |   Right      |   Green
-- Down + A |   Orange      |   Right + A  |   Dark Green
-- Down + B |   Yellow      |   Right + B  |   Reverse
function ChangeScreenColor()

  -- Create two variables to store our direction and button values
  local dir = nil
  local button = nil

  -- Look to see what key direction is pressed
  if( Button(0) == true) then
    dir = 1
  elseif( Button(1) == true) then
    dir = 2
  elseif( Button(2) == true) then
    dir = 3
  elseif( Button(3) == true) then
    dir = 4
  end


  -- Look to see what button is pressed
  if( Button(4) == true) then
    button = 1
  elseif( Button(5) == true) then
    button = 2
  end

  -- Set an offset value
  local offset = 0

  -- Make sure a direction has been pressed before calculating the new offset
  if(dir ~= nil) then

    -- Set the offset to the direction value multiplied by 4 (the total colors per pallet)
    offset = dir * 4

    -- Look to see if a button is also down
    if(button ~= nil) then

      -- Add the button value multiplied by 16 to the current offset
      offset = offset + (button * 16)

    end

  end

  -- Loop through the first 4 colors
  for i=0,3 do

    -- Replace each of the first 4 colors with a new color starting at the offset value
    ReplaceColor(i, i + offset)

  end

end
