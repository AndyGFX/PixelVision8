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
function TLuaTiled:Prepare()

  -- for all tilesets
  for t=1,#self.tmx.tilesets do
    -- and all tiles inside
  	for i=1,#self.tmx.tilesets[t].tiles do
      -- if exist animation
      if self.tmx.tilesets[t].tiles[i].animation ~=nil then
        -- define additional information
        self.tmx.tilesets[t].tiles[i].animation.frame_id = 1
        self.tmx.tilesets[t].tiles[i].animation.frames = #self.tmx.tilesets[t].tiles[i].animation
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
-- Return Tile data on [X,Y] from definend layer
---------------------------------------------------------------
function TLuaTiled:GetTile(layer,x,y)
  local tid = -1
  local pos = self.tmx.layers[layer].width*y+x
  local fx,fy,fxy = false

  tid = self.tmx.layers[layer].data[1+pos]

  if (bit32.band(tid,self.FLIPPED_HORIZONTALLY_FLAG)==self.FLIPPED_HORIZONTALLY_FLAG) then fx = true else fx = false end
  if (bit32.band(tid,self.FLIPPED_VERTICALLY_FLAG)==self.FLIPPED_VERTICALLY_FLAG) then fy = true else fy = false end
  if (bit32.band(tid,self.FLIPPED_HORIZONTALLY_FLAG)==self.FLIPPED_HORIZONTALLY_FLAG) then fxy = true else fxy = false end

  tid = bit32.band(tid,self.CLEAR_FLAG)

  if (tid~=0) then tid = tid-1 end

  local tile =
  {
    id = tid,
    flip_x = fx,
    flip_y = fy,
    flip_xy = fxy
  }
	return tile
end

function TLuaTiled:DrawAsTileMap(lid)
  for x=0,self.tmx.layers[lid].width-1 do
    for y=0,self.tmx.layers[lid].height-1 do
      local tile = self:GetTile(lid,x,y)
      Tile(x,y,tile.id,0,0)
    end
  end
end

function TLuaTiled:DrawAsSpriteMap(lid)

  for x=0,self.tmx.layers[lid].width-1 do
    for y=0,self.tmx.layers[lid].height-1 do
      local tile = self:GetTile(lid,x,y)
      DrawSprite(tile.id,x*8,y*8,tile.flip_x,tile.flip_y)
    end
  end

end
