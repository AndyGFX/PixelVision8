TLuaTiled = {}

---------------------------------------------------------------
-- TCellular CONSTRUCTOR --------------------------------------
---------------------------------------------------------------

function TLuaTiled:New(data)

    o = {
	 		    tmx = data or nil,
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
        -- define additional information
        self.tmx.tilesets[t].tiles[i].frame_id = 1
        self.tmx.tilesets[t].tiles[i].frames = #self.tmx.tilesets[t].tiles[i].animation
        self.tmx.tilesets[t].tiles[i].time = 0
      end
    end
  end
end

---------------------------------------------------------------
-- Reset additional animation properties from tmx structure
-- and set exported/default values
---------------------------------------------------------------
function TLuaTiled:ResetAnimations()

  -- for all tilesets
  for t=1,#self.tmx.tilesets do
    -- and all tiles inside
  	for i=1,#self.tmx.tilesets[t].tiles do
      -- if exist animation
      if self.tmx.tilesets[t].tiles[i].animation ~=nil then
        -- define additional information
        self.tmx.tilesets[t].tiles[i].id = self.tmx.tilesets[t].tiles[i].animation[1]
        self.tmx.tilesets[t].tiles[i].frame_id = 1
        self.tmx.tilesets[t].tiles[i].time = 0
      end
    end
  end
end


---------------------------------------------------------------
-- Find TMX layer ID by name
---------------------------------------------------------------
function TLuaTiled:GetAnimationDataForTile(tid)
  for t=1,#self.tmx.tilesets do
    -- and all tiles inside
  	for i=1,#self.tmx.tilesets[t].tiles do
      -- if exist animation
      if (self.tmx.tilesets[t].tiles[i].id==tid and self.tmx.tilesets[t].tiles[i].animation ~=nil) then
        return self.tmx.tilesets[t].tiles[i]
      end
    end
  end
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
-- Check if tile has animation
---------------------------------------------------------------
function TLuaTiled:IsAnimated(tid)
	for t=1,#self.tmx.tilesets do
    -- and all tiles inside
  	for i=1,#self.tmx.tilesets[t].tiles do
      -- if exist animation
      if (self.tmx.tilesets[t].tiles[i].id==tid and self.tmx.tilesets[t].tiles[i].animation ~=nil) then
        return true
      end
    end
  end

	return false
end

---------------------------------------------------------------
-- Check if tile has animation
---------------------------------------------------------------
function TLuaTiled:Update(deltaTime)

	for t=1,#self.tmx.tilesets do
    -- and all tiles inside
  	for i=1,#self.tmx.tilesets[t].tiles do
      -- if exist animation
      if (self.tmx.tilesets[t].tiles[i].animation ~=nil) then
          -- add delta time
          self.tmx.tilesets[t].tiles[i].time = self.tmx.tilesets[t].tiles[i].time + (deltaTime*100)
          -- if time > 100
          if (self.tmx.tilesets[t].tiles[i].time>100) then
            -- reset timer
            self.tmx.tilesets[t].tiles[i].time = 0
            -- add frame
            self.tmx.tilesets[t].tiles[i].frame_id = self.tmx.tilesets[t].tiles[i].frame_id + 1;
            -- if out of frames
            if (self.tmx.tilesets[t].tiles[i].frame_id>self.tmx.tilesets[t].tiles[i].frames) then
              -- set first frame
              self.tmx.tilesets[t].tiles[i].frame_id = 1
            end
          end
      end
    end
  end

end


---------------------------------------------------------------
-- Return Tile data on [X,Y] from definend layer
---------------------------------------------------------------
function TLuaTiled:GetTile(layer,x,y)
  local tid = -1
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

  tid = bit32.band(tid,self.CLEAR_FLAG)

  -- ???? doesn work when is included here. From main script works !!!! Why ?????????
  if self:IsAnimated(tid) then
    anim = self:GetAnimationDataForTile(tid)
    tile.id = anim.animation[anim.frame_id].tileid
  else

    tile.id = tid
  end

  if (tile.id~=0) then tile.id = tile.id-1 end


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
