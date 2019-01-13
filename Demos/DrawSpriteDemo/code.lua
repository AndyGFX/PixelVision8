--[[
	Pixel Vision 8 - Draw Sprites Demo
	Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
	Created by Jesse Freeman (@jessefreeman)

	Learn more about making Pixel Vision 8 games at https://www.pixelvision8.com
]]--

-- Let's take a look at how to use Pixel Vision 8's drawing APIs. This Demo will walk you through the basics of drawing a single sprite, then we will look at some basic animation and finally move onto more advanced examples of drawing larger sprites by using multiple smaller ones.

-- To get started, you'll need to download the following sprites at http://github.com/pixelvision8/demo/... Once you have the sprites, create a new Fami System template and copy the sprites into the `Workspace/Sandbox` folder. If you need help finding the `Workspace` on your computer, please take a look at the documentation that outlines how to use the file system at http://pixelvision8.com/docs/...

-- Once you have the project ready to go and the sprites are loaded, we can begin by opening up the `Workspace/Sandbox/code.lua` file for you project. Delete all of the code and we'll start by scratch.

-- In order for our code to work, we are going to need to set up a few variables that will contain information on how we build our sprites. This fist one creates a lua table called fireball1 and adds the following properties: width, total and spriteIDs.
local fireball1 = {width = 1, unique = 1, total = 1, spriteIDs = {6}}

-- Pixel Vision 8 uses ID numbers to reference sprites in memory. You can always open up the Sprite Preview Tool to see the ones that have been loaded into memory.

-- Here we added the second fireball sprite and two more single sprite tables.
local fireball2 = {width = 1, unique = 1, total = 1, spriteIDs = {7}}
local face1 = {width = 1, unique = 1, total = 1, spriteIDs = {24}}
local face2 = {width = 1, unique = 1, total = 1, spriteIDs = {25}}

-- The flower table is set up like our other sprite tables but we are going to reference more sprite IDs to build this larger graphic. As you can see we now have a total of 4 sprites and a width of 2. This means the flower will be laid out in a 2 x 2 grid when we go to draw it later on.
local flower = {width = 2, unique = 4, total = 4, spriteIDs = {16, 17, 26, 27}}

-- Since sprites are 8 x 8 pixels, our flower sprite is going to be 2 x 2 sprites in size or 16 x 16 pixels. It was common on 8-bit systems to use several smaller sprites to build larger sprites for an actual game. We'll talk later about the limitation Pixel Vision 8 has when it comes to how many sprites can be displayed on the screen at one.

-- Now lets create some tables for the last of the sprites we'll need for the demo.
local ghost = {width = 2, unique = 4, total = 4, spriteIDs = {4, 5, 14, 15}}
local pipe = {width = 2, unique = 4, total = 4, spriteIDs = {8, 9, 18, 19}}
local playerframe1 = {width = 2, unique = 6, total = 6, spriteIDs = {0, 1, 10, 11, 20, 21}}
local playerframe2 = {width = 2, unique = 6, total = 6, spriteIDs = {2, 3, 12, 13, 22, 23}}

-- At this point, we now have tables for each set of sprites we are going to display in the demo.

-- We'll use these two variables to store text to display on the screen when we run our demo.
local title = "Drawing API Demo"
local message = "This demo shows off how to draw sprites to the display."

-- Here we are creating a table with two sprite references. We'll use this to help build an animation where each item represents a single frame.
local fireballSprites = { fireball1.spriteIDs[1], fireball2.spriteIDs[1] }

-- Now we are creating an animation table just like before but we are going to include a little more information for each frame such as the sprite variable reference, and booleans for horizontal and vertical flipping.
local fireballAnimation = {
  {sprite = fireballSprites[1], hFlip = false, vFlip = false},
  {sprite = fireballSprites[2], hFlip = false, vFlip = false},
  {sprite = fireballSprites[1], hFlip = true, vFlip = true},
  {sprite = fireballSprites[2], hFlip = true, vFlip = true}
}

-- This variable will store some raw pixel data for a sprite.
local rawSpriteData = {
  00, 00, 00, 00, 00, 00, 00, 00,
  00, - 1, - 1, - 1, - 1, - 1, - 1, 00,
  00, - 1, 00, 00, 00, 00, - 1, 00,
  00, - 1, 00, - 1, - 1, 00, - 1, 00,
  00, - 1, 00, 00, 00, 00, - 1, 00,
  00, - 1, 00, 00, - 1, - 1, - 1, 00,
  00, - 1, 00, - 1, - 1, - 1, - 1, 00,
  00, 00, 00, 00, 00, 00, 00, 00,
}

-- While you can load up sprites from a png, Pixel Vision 8 also allows drawing raw pixel data by supplying just color index values.

-- These variables will store values for our fireball animation.
local fireballDelay = .2
local fireballTime = 0
local fireballFrame = 1

-- This last table stores the ghost sprite's body, face and width along with the position to draw it on the screen.
local ghostSprites = {
  body = ghost.spriteIDs,
  faces = {face1.spriteIDs[1], face2.spriteIDs[1]},
  width = ghost.width
}

-- TODO need to move this into the ghost sprite table above
local ghostPos = {
  x = 8,
  y = 28,
}

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to use this method to configure the demo before it starts running.
function Init()

  -- We can call BackgroundColor() to manually change the background color of the screen at run-time
  BackgroundColor(32)

  -- These calls will draw titles on the screen for each draw example we are using.
  DrawText("Drawing API Demo", 1, 1, DrawMode.Tile, "default")
  DrawText("1. Single Sprites", 1, 4, DrawMode.Tile, "default")
  DrawText("2. Compost Sprites", 1, 8, DrawMode.Tile, "default")
  DrawText("3. Palette Shifting", 1, 13, DrawMode.Tile, "default")
  DrawText("4. Above/Below Tiles", 1, 18, DrawMode.Tile, "default")
  DrawText("5. Raw Pixel Data", 1, 24, DrawMode.Tile, "default")

  -- The final thing we need to do is create a pipe sprite that will be placed in the background map. Here we are setting column and row value for us to position it on the tilemap.
  local pipeX = 1
  local pipeY = 21

  -- Here we are manually drawing each of the pipe sprites into the background map. As you can see, you can update any tile by supplying a sprite ID, column and row position.
  Tile(pipeX, pipeY, pipe.spriteIDs[1], 12)
  Tile(pipeX + 1, pipeY, pipe.spriteIDs[2], 12)
  Tile(pipeX, pipeY + 1, pipe.spriteIDs[3], 12)
  Tile(pipeX + 1, pipeY + 1, pipe.spriteIDs[4], 12)

  -- Finally we are going to draw a second pipe into the background by shifting the column over by 3.
  pipeX = pipeX + 3
  Tile(pipeX, pipeY, pipe.spriteIDs[1], 12)
  Tile(pipeX + 1, pipeY, pipe.spriteIDs[2], 12)
  Tile(pipeX, pipeY + 1, pipe.spriteIDs[3], 12)
  Tile(pipeX + 1, pipeY + 1, pipe.spriteIDs[4], 12)

end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame before the Draw() method. It accepts one argument, timeDelta, which is the difference in milliseconds since the last frame.
function Update(timeDelta)

  -- We are only going to perform a single calculation in our Update() call. We'll focus on manually updating the frame animation for the fireball sprite.

  -- On every frame we want to add the timeDelta to the fireballTime variable we are using to keep track of how much time has passed between each frame of animation.
  fireballTime = fireballTime + timeDelta

  -- Now we need to test if the if the fireballTime is greater than the fireballDelay.
  if(fireballTime > fireballDelay) then

    -- Since the time was greater than the delay, we can now increase the fireballFrame to the next value.
    fireballFrame = fireballFrame + 1

    -- Since we only have a set number of frames, we need to make sure to loop the animation by setting the fireballFrame value to 1 if the current frame value is greater than the total items in the fireballAnimation table.
    if(fireballFrame > #fireballAnimation) then
      fireballFrame = 1
    end

    -- Finally, we need to reset our fireballTime variable back to 0 since it will need to keep track of the time between the last frame change.
    fireballTime = 0

    -- This is a common way to handle animation for sprites. We set a time which tracks the value between frames, a delay to know when to change the animation and a way to track the current frame of the animation. You can use this to synchronize animations between multiple sprites or use different values to track animation frame changes at different speeds.

  end

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw()

  -- At this point we are finally ready to draw something to the screen. Since all of our sprite data has been set up and our animation is being updated, displaying sprites on the screen should be relatively easy.

  -- We need to clear the display on each frame.
  Clear()

  -- Normally in a project you can call RedrawDraw() and it will clear the screen and draw the tilemap for you. In this demo we want to manually draw the tilemap so we are calling Clear() first to make sure the last frame's pixel data is removed before rendering the next frame.

  -- We are going to manually draw the tilemap to the display. We do this by calling DrawTilemap() and passing in the start column, row and the width and hight in tiles.
  DrawTilemap(0, 0, 32, 30)

  -- These two variables will help us know our stat x and y position for drawing our sprites.
  local newX = 8
  local newY = 48

  -- Here we are going to draw a single sprite to the screen.
  DrawSprite(fireballSprites[1], newX, newY)

  newX = newX + 16
  DrawSprite(fireballSprites[2], newX, newY)

  -- Next we will draw the same sprite but flip it horizontally and vertically to create 3 new
  -- animaion frames from the same sprite
  newX = newX + 16
  DrawSprite(fireballSprites[1], newX, newY, true, true)
  newX = newX + 16
  DrawSprite(fireballSprites[2], newX, newY, true, true)

  -- Now we will animate the fireball while trying to use the least amout of sprites possible.
  local frameData = fireballAnimation[fireballFrame]
  newX = newX + 16
  DrawSprite(frameData.sprite, newX, newY, frameData.hFlip, frameData.vFlip)

  -- Now it's time to draw a more complex sprite. First we'll start with the ghost's body. We'll
  -- use DrawSprites which allows us to draw multiple sprites in a grid
  newX = 8
  newY = newY + 32
  DrawSprites(ghostSprites.body, newX, newY, ghostSprites.width)

  newX = newX + 24
  DrawSprite(ghostSprites.faces[1], newX, newY)

  -- Now lets build the full ghost by drawing the body first then the face on top.
  newX = newX + 16
  DrawSprites(ghostSprites.body, newX, newY, ghostSprites.width)
  DrawSprite(ghostSprites.faces[1], newX + 6, newY + 4)

  -- We can also flip the ghost and readjust the face sprite.
  newX = newX + 24
  DrawSprites(ghostSprites.body, newX, newY, ghostSprites.width, true)
  DrawSprite(ghostSprites.faces[1], newX + 2, newY + 4, true)

  -- Finally we could even change the ghosts face since it's just a single sprite on top of the ghost's
  -- body sprites.
  newX = newX + 28
  DrawSprites(ghostSprites.body, newX, newY, ghostSprites.width)
  DrawSprite(ghostSprites.faces[2], newX + 6, newY + 4)

  -- Here is an example of palette shifting. First we draw the sprite based on its normal colors.
  newX = 8
  newY = newY + 40
  DrawSprites(flower.spriteIDs, newX, newY, flower.width)

  -- Now we can shift the flower sprite's color IDs to change the way it looks. Here you'll see the
  -- flower now has color but we need to make the stem green
  newX = newX + 24
  DrawSprites(flower.spriteIDs, newX, newY, flower.width, false, false, DrawMode.SpriteAbove, 3)

  -- To shift the palette for each sprite differently, we'll have to draw them by hand
  newX = newX + 24
  DrawSprite(flower.spriteIDs[1], newX, newY, false, false, DrawMode.SpriteAbove, 3)

  -- Since the top left and top right sprites are the same, we can just flip them horizontally and
  -- move it over by 8 pixels
  DrawSprite(flower.spriteIDs[1], newX + 8, newY, true, false, DrawMode.SpriteAbove, 3)

  -- Since the top left and top right sprites are the same, we can just flip them horizontally and
  -- move it over by 8 pixels
  DrawSprite(flower.spriteIDs[3], newX, newY + 8, false, false, DrawMode.SpriteAbove, 6)
  DrawSprite(flower.spriteIDs[3], newX + 8, newY + 8, true, false, DrawMode.SpriteAbove, 6)

  -- In this demo we will look at rendering a player in front of a background tile.
  newX = 12
  newY = newY + 40
  DrawSprite(playerframe1.spriteIDs[1], newX, newY, false, false, DrawMode.SpriteAbove, 3)
  DrawSprite(playerframe1.spriteIDs[2], newX + 8, newY, false, false, DrawMode.SpriteAbove, 3)
  DrawSprite(playerframe1.spriteIDs[3], newX, newY + 8, false, false, DrawMode.SpriteAbove, 3)
  DrawSprite(playerframe1.spriteIDs[4], newX + 8, newY + 8, false, false, DrawMode.SpriteAbove, 3)
  DrawSprite(playerframe1.spriteIDs[5], newX, newY + 16, false, false, DrawMode.SpriteAbove, 9)
  DrawSprite(playerframe1.spriteIDs[6], newX + 8, newY + 16, false, false, DrawMode.SpriteAbove, 9)

  -- Now we can render the same sprite but have it display behind the tilemap.
  newX = newX + 28
  DrawSprite(playerframe1.spriteIDs[1], newX, newY, false, false, DrawMode.SpriteBelow, 3)
  DrawSprite(playerframe1.spriteIDs[2], newX + 8, newY, false, false, DrawMode.SpriteBelow, 3)
  DrawSprite(playerframe1.spriteIDs[3], newX, newY + 8, false, false, DrawMode.SpriteBelow, 3)
  DrawSprite(playerframe1.spriteIDs[4], newX + 8, newY + 8, false, false, DrawMode.SpriteBelow, 3)
  DrawSprite(playerframe1.spriteIDs[5], newX, newY + 16, false, false, DrawMode.SpriteBelow, 9)
  DrawSprite(playerframe1.spriteIDs[6], newX + 8, newY + 16, false, false, DrawMode.SpriteBelow, 9)

  -- In this demo we are going to push raw pixel data to the display as a sprite
  newX = 8
  newY = newY + 48
  DrawPixels(rawSpriteData, newX, newY, 8, 8)

  newX = newX + 16
  DrawPixels(rawSpriteData, newX, newY, 8, 8, true)

  newX = newX + 16
  DrawPixels(rawSpriteData, newX, newY, 8, 8, false, true)

  newX = newX + 16
  DrawPixels(rawSpriteData, newX, newY, 8, 8, true, true)

  -- Shift the color offset of the pixel data. Also need to set the draw mode manually to sprite
  newX = newX + 16
  DrawPixels(rawSpriteData, newX, newY, 8, 8, false, false, DrawMode.Sprite, 3)

end
