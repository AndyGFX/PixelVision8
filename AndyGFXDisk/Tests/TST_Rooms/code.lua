
LoadScript("TRooms.lua")
-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.

local rooms = TRooms:New(20,10)

local title = "ROOMS CLASS"
local message1 = " Example of using TRooms class."
local message2 = " For procedural rooms building ."
local message3 = " TRooms by AndyGFX."

function Init()

  -- Here we are manually changing the background color
  BackgroundColor(0)

  -- Let's draw the title into the tilemap
	DrawText(title, 1, 18, DrawMode.Tile, "large",Orange)

	-- We are going to render the message in a box as tiles.
	DrawText(message1, 0, 21, DrawMode.Tile, "large",Orange)
	DrawText(message2, 0, 23, DrawMode.Tile, "large",Grey)
	DrawText(message3, 0, 27, DrawMode.Tile, "large",White)

  rooms:Generate()

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
  rooms:DrawMiniMap(10,10)

end
