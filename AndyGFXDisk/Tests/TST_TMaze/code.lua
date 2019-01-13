--[[
	Pixel Vision 8 - New Template Script
	Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
	Created by Jesse Freeman (@jessefreeman)

	This project was designed to display some basic instructions when you create
	a new game.	Simply delete the following code and implement your own Init(),
	Update() and Draw() logic.

	Learn more about making Pixel Vision 8 games at https://www.gitbook.com/@pixelvision8
]]--


LoadScript("TMaze.lua")
local White, Black, Blue, Orange, Grey = 51, 32, 52, 53, 19

-- This this is an empty game, we will the following text. We combined two sets of fonts into
-- the default.font.png. Use uppercase for larger characters and lowercase for a smaller one.
local title = "MAZE CLASS"
local message1 = " Example of using TMaze class."
local message2 = " Press UP to regenerate maze."
local message3 = " TMaze by AndyGFX."

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.
function Init()

	-- Here we are manually changing the background color
	BackgroundColor(32)

	-- Let's draw the title into the tilemap
	DrawText(title, 1, 18, DrawMode.Tile, "large-font",Orange)

	-- We are going to render the message in a box as tiles.
	DrawText(message1, 0, 21, DrawMode.Tile, "small-font",Orange)
	DrawText(message2, 0, 23, DrawMode.Tile, "small-font",Grey)
	DrawText(message3, 0, 27, DrawMode.Tile, "large-font",White)

	maze = TMaze:New(64,64)
	maze:Generate()
end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame
-- before the Draw() method. It accepts one argument, timeDelta, which is the difference in
-- milliseconds since the last frame.
function Update(timeDelta)

	-- TODO add your own update logic here
	if Button(Buttons.Up, InputState.Released, 0) then
		maze:Generate();
		end
end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where
-- all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw()

	-- We can use the RedrawDisplay() method to clear the screen and redraw the tilemap in a
	-- single call.
	RedrawDisplay()

	-- Draw generated cellular automata map
	maze:Preview(1,1);

end
