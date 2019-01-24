TLuaTiled = {}

---------------------------------------------------------------
-- TCellular CONSTRUCTOR --------------------------------------
---------------------------------------------------------------

function TLuaTiled:New(data)

    o = {
          tmx = data or nil,
          animations = {},
          FLIPPED_HORIZONTALLY_FLAG = 0x80000000,
          FLIPPED_VERTICALLY_FLAG = 0x40000000,
          FLIPPED_DIAGONALLY_FLAG = 0x20000000,
          CLEAR_FLAG = 0x0000FFFF
        }

    setmetatable(o, self)
    self.__index = self

    return o

end

---------------------------------------------------------------
-- Set loaded TMX lua data
---------------------------------------------------------------
function TLuaTiled:SetTmx(tmxData)
  self.tmx = tmxData
end

---------------------------------------------------------------
-- Prepare additional properties to tmx structure
---------------------------------------------------------------
function TLuaTiled:PrepareAnimations()

  -- for all tilesets
  for t=1,#self.tmx.tilesets do
    -- and all tiles inside
    for i=1,#self.tmx.tilesets[t].tiles do
      -- if exist animation
      if self.tmx.tilesets[t].tiles[i].animation ~=nil then

        local hash_id = tostring(self.tmx.tilesets[t].tiles[i].id)
        self.animations[hash_id]={}
        self.animations[hash_id].id = self.tmx.tilesets[t].tiles[i].id
        -- current animation frame id
        self.animations[hash_id].frame_id = 1
        -- animations count
        self.animations[hash_id].frames = #self.tmx.tilesets[t].tiles[i].animation
        -- animation timer
        self.animations[hash_id].time = 0
        -- tile id for render
        self.animations[hash_id].tile = self.tmx.tilesets[t].tiles[i].id
        self.animations[hash_id].tiles = self.tmx.tilesets[t].tiles[i].animation
      end
    end
  end
end


function TLuaTiled:DumpData(anim)

  print("Animation ID      : "..anim.id)
  print("  Frame ID        : "..anim.frame_id)
  print("  Frames count    : "..anim.frames)
  print("  Current duration: "..anim.time)
  print("  Anim Tile ID    : "..anim.tile)
  print("---------------------------------------")

end
---------------------------------------------------------------
-- Reset additional animation properties from tmx structure
-- and set exported/default values
---------------------------------------------------------------
function TLuaTiled:ResetAnimations()

  for key,value in pairs(self.animations) do
    self.animations[key].frame_id=1
    self.animations[key].time=0
    self.animations[key].tile=self.animations[key].id
  end

end


---------------------------------------------------------------
-- Get animation data for tile id from tilemap
-- Note: tile id must by dec by -1 !!!!
---------------------------------------------------------------
function TLuaTiled:GetAnimationFrameForTile(tid)

  local hash = tostring(tid)
  return self.animations[hash].tile

end

---------------------------------------------------------------
-- Find TMX layer ID by name
---------------------------------------------------------------
function TLuaTiled:GetLayerID(layerName)
  local id = -1
  for i=1,#self.tmx.layers do
    if self.tmx.layers[i].name == layerName then return i end
  end
  return id
end

---------------------------------------------------------------
-- Find TilsetID ID by map tile id
---------------------------------------------------------------
function TLuaTiled:GetTilsetID(tile_id)
  local tileset_id = 1
  for i=2,#self.tmx.tilesets do
    if (tile_id<=self.tmx.tilesets[i].firstgid) then
      return tileset_id
    end
      tileset_id=tileset_id+1
  end
  return tileset_id
end

---------------------------------------------------------------
-- Find Tilset name ID by map tile id
---------------------------------------------------------------
function TLuaTiled:GetTilsetName(tile_id)
  local tileset_id = 1
  for i=2,#self.tmx.tilesets do
    if (tile_id<=self.tmx.tilesets[i].firstgid) then
      return self.tmx.tilesets[i-1].name
    end
      tileset_id=tileset_id+1
  end
  return nil
end

---------------------------------------------------------------
-- Check if tile has animation
---------------------------------------------------------------
function TLuaTiled:IsAnimated(tid)

  local hash = tostring(tid)

  if (self.animations[hash]~=nil) then
    return true
  end
  return false
end


---------------------------------------------------------------
-- Check if tile has animation
---------------------------------------------------------------
function TLuaTiled:SetNextFrame(animation)

  animation.time=0
  animation.frame_id = animation.frame_id + 1
  if (animation.frame_id>animation.frames) then
    animation.frame_id = 1
  end
  animation.tile = animation.tiles[animation.frame_id].tileid

end

---------------------------------------------------------------
-- Check if tile has animation
---------------------------------------------------------------
function TLuaTiled:Update(deltaTime)

  for key,value in pairs(self.animations) do

    value.time = value.time + (deltaTime*1000)

    if (value.time >= value.tiles[value.frame_id].duration) then
        self:SetNextFrame(value)
    end

  end
end


---------------------------------------------------------------
-- Return Tile data on [X,Y] from definend layer
---------------------------------------------------------------
function TLuaTiled:GetTile(layer,x,y)
  local tid = 0
  local pos = self.tmx.layers[layer].width*y+x
  local fx,fy,fxy = false
  local anim = nil
  local tile =
  {
    id = 0,
    flip_x = false,
    flip_y = false,
    flip_xy = false
  }

  tid = self.tmx.layers[layer].data[1+pos]

  if (bit32.band(tid,self.FLIPPED_HORIZONTALLY_FLAG)==self.FLIPPED_HORIZONTALLY_FLAG) then tile.flip_x = true else tile.flip_x = false end
  if (bit32.band(tid,self.FLIPPED_VERTICALLY_FLAG)==self.FLIPPED_VERTICALLY_FLAG) then tile.flip_y = true else tile.flip_y = false end
  if (bit32.band(tid,self.FLIPPED_HORIZONTALLY_FLAG)==self.FLIPPED_HORIZONTALLY_FLAG) then tile.flip_xy = true else tile.flip_xy = false end

  tile.id = bit32.band(tid,self.CLEAR_FLAG)

  local tileset_id = self:GetTilsetID(tile.id)

  if (tile.id~=0) then

    local real_tile_id = tile.id - self.tmx.tilesets[tileset_id].firstgid
    tile.id = real_tile_id

    if self:IsAnimated(tile.id) then
      tile.id = self:GetAnimationFrameForTile(tile.id)
    end
  end

  return tile
end
---------------------------------------------------------------
-- Draw tilemap in TILE mode
---------------------------------------------------------------
function TLuaTiled:DrawAsTileMap(lid)
  for x=0,self.tmx.layers[lid].width-1 do
    for y=0,self.tmx.layers[lid].height-1 do
      local tile = self:GetTile(lid,x,y)
      Tile(x,y,tile.id,0,0)
    end
  end
end

---------------------------------------------------------------
-- Draw tilemap in SPRITE mode
---------------------------------------------------------------
function TLuaTiled:DrawAsSpriteMap(lid)

  for x=0,self.tmx.layers[lid].width-1 do
    for y=0,self.tmx.layers[lid].height-1 do
      local tile = self:GetTile(lid,x,y)
      DrawSprite(tile.id,x*8,y*8,tile.flip_x,tile.flip_y)
    end
  end

end
