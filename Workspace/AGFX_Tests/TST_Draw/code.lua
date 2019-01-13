--[[
  Pixel Vision 8 - New Template Script
  Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
  Created by Jesse Freeman (@jessefreeman)

  This project was designed to display some basic instructions when you create
  a new game.  Simply delete the following code and implement your own Init(),
  Update() and Draw() logic.

  Learn more about making Pixel Vision 8 games at https://www.gitbook.com/@pixelvision8
]]--

LoadScript("TDraw.lua")


draw = TDraw:New()

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.
function Init()

  -- Here we are manually changing the background color
  BackgroundColor(0)

  local display = Display()

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


  for id=1,16 do
    draw:Line(1,id,264,id,id)
  end

  local c = 0
  for x=1,264,2 do
    for y=20,36,2 do
      c = c+1
      draw:Pixel(x,y,c%16)
    end
  end


  local size = 32
  c = 1
  for o=0,2 do
    local x = 30
    local y = 64+64 * o
    c=c+1
    draw:Rectangle(x,o+y,x+size,o+y+size,c,false)
    x = 100
    y = 64+64*o
    draw:Rectangle(x,o+y,x+size,o+y+size,c,true)
  end


end
