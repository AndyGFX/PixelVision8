TLuaTiled = {}

---------------------------------------------------------------
-- TCellular CONSTRUCTOR --------------------------------------
---------------------------------------------------------------

function TLuaTiled:New(data)

    o = {
	 		tmx = data or nil
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

	return tid
end

