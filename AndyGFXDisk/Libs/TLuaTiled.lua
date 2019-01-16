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


function TLuaTiled:SetTmx(tmxData)
	self.tmx = tmxData
end


function TLuaTiled:GetLayerID(layerName)
	return 1
end

function TLuaTiled:GetTile(layer,x,y)
	local tid = -1
  local pos = self.tmx.layers[layer].width*y+x
  tid = self.tmx.layers[layer].data[1+pos]
  tid = bit32.band(tid,self.CLEAR_FLAG)
  if (tid~=0) then tid = tid-1 end
  local tile =
  {
    id = tid,
    flip_x = false,
    flip_y = false,
    flip_xy = false
  }
	return tile
end
