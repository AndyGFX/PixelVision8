--[[
  Pixel Vision 8 - New Template Script
  Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
  Created by Jesse Freeman (@jessefreeman)

  This project was designed to display some basic instructions when you create
  a new game.  Simply delete the following code and implement your own Init(),
  Update() and Draw() logic.

  Learn more about making Pixel Vision 8 games at https://www.gitbook.com/@pixelvision8
]]--

--

LoadScript("bump.lua")
local bump = GetBumpLib()

local bump_debug = {}
local intensityColors = {8, 9, 10, 11}
local borderColor = 4

local function getCellRect(world, cx, cy)
  local cellSize = world.cellSize
  local l, t = world:toWorld(cx, cy)
  return l, t, cellSize, cellSize
end

function bump_debug.draw(world)
  local cellSize = world.cellSize
  local fontHeight = 6
  local topOffset = (cellSize - fontHeight) / 2
  for cy, row in pairs(world.rows) do
    for cx, cell in pairs(row) do
      local l, t, w, h = getCellRect(world, cx, cy)
      local intensity = math.min(cell.itemCount, #intensityColors)
      local color = intensityColors[intensity]

      DrawRect(l, t, w, h, color)
      DrawText(tostring(cell.itemCount), l + cellSize / 2, t + topOffset, DrawMode.Sprite, "large-font", borderColor)
    end
  end
end


UP = 0
DOWN = 1
LEFT = 2
RIGHT = 3

CELL_SIZE = 32

BLOCK_COLOR = 7
PLAYER_COLOR = 14

local world = bump.newWorld(CELL_SIZE)
local blocks = {}

local function addBlock(block)
  blocks[#blocks + 1] = block
  world:add(block, block.x, block.y, block.w, block.h)
end

local function drawBlocks()
  for _, block in ipairs(blocks) do
    --FES:DrawRect(FES:Rect2i(block.x,block.y,block.w,block.h), block.color)
    DrawRect(block.x, block.y, block.w, block.h, block.color, DrawMode.Sprite)
  end
end

local function drawPlayer(player)
  --FES:DrawRect(FES:Rect2i(player.x,player.y,player.w,player.h), player.color)
  DrawRect(player.x, player.y, player.w, player.h, player.color, DrawMode.Sprite)
end

local function addPlayer(player)
  world:add(player, player.x, player.y, player.w, player.h)
end

local A = {name = "A", x = 80, y = 80, w = 20, h = 20, color = BLOCK_COLOR}
local B = {name = "B", x = 10, y = 10, w = 32, h = 32, color = BLOCK_COLOR}
local C = {name = "B", x = 25, y = 55, w = 15, h = 15, color = BLOCK_COLOR}
local player = {name = "Player", x = 50, y = 50, w = 16, h = 16, color = PLAYER_COLOR, speed = 1}


addBlock(A)
addBlock(B)
addBlock(C)
addPlayer(player)

local dx, dy = 0, 0
local info = ""


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

  local speed = player.speed
  dx, dy = 0, 0
  info = ""


  if Button(Buttons.Up, InputState.Down) then dy = -speed end
  if Button(Buttons.Down, InputState.Down) then dy = speed end
  if Button(Buttons.Left, InputState.Down) then dx = -speed end
  if Button(Buttons.Right, InputState.Down) then dx = speed end

  if dx ~= 0 or dy ~= 0 then
    player.x, player.y, cols, cols_len = world:move(player, player.x + dx, player.y + dy)


    for i = 1, tonumber(cols_len) do
      local col = cols[i]
      info = "col.other: "..col.other.name..", col.type: "..col.type..", col.normal: "..tostring(col.normal.x) ..","..tostring(col.normal.y)
    end
  end


end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where
-- all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw()

  -- We can use the RedrawDisplay() method to clear the screen and redraw the tilemap in a
  -- single call.
  RedrawDisplay()


  drawBlocks()
  drawPlayer(player)
  bump_debug.draw(world)
  DrawText(info, 8, 64, DrawMode.Sprite, "large-font", 2, 0)
end
