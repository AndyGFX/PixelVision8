-- TMarchingSquare v0.5 [AndyGFX] ------------------------------------------------------

--[[

Installation:

copy file TMarchingSquare.lua to Lib folder

Initialization:

apiBridge:LoadLib("TCellular.lua")
apiBridge:LoadLib("TMarchingSquare.lua")

Define theme:

Example:
theme1 = {}

theme1[01] = {tile = 3,flag=-1}
theme1[02] = {tile = 16,flag=-1}
theme1[03] = {tile = 17,flag=-1}
theme1[04] = {tile = 18,flag=-1}
theme1[05] = {tile = 19,flag=-1}
theme1[06] = {tile = 20,flag=-1}
theme1[07] = {tile = 21,flag=-1}
theme1[08] = {tile = 22,flag=-1}
theme1[09] = {tile = 23,flag=-1}
theme1[10] = {tile = 24,flag=-1}
theme1[11] = {tile = 25,flag=-1}
theme1[12] = {tile = 26,flag=-1}
theme1[13] = {tile = 27,flag=-1}
theme1[14] = {tile = 28,flag=-1}
theme1[15] = {tile = 29,flag=-1}
theme1[16] = {tile = 30,flag=-1}

Generate map:

	cave:Generate(32,30,0.6,3,5,5);
	marchingSquares = TMarchingSquare:New();
	marchingSquares.theme = theme1;
	marchingSquares.invert = true;
	marchingSquares.mapData = cave;
	marchingSquares:BuildTilemap();
	

]]

TMarchingSquare = {}

---------------------------------------------------------------
-- TMarchingSquare CONSTRUCTOR --------------------------------
---------------------------------------------------------------

function TMarchingSquare:New() 

    o = { 
            theme = {},
            mapData = {},
			invert = false,			
        } 

    setmetatable(o, self) 
    self.__index = self 

    return o 

end  

---------------------------------------------------------------
-- HELPER for invert map result
---------------------------------------------------------------
function TMarchingSquare:Invert(value)

	if (self.invert) then

		if (value==0) then
			return 1;
		end		
		if (value==1) then
			return 0;
		end
	end
	
	return value;	
end

---------------------------------------------------------------
-- HELPER for analyze cells around [x,y] in map
---------------------------------------------------------------
function TMarchingSquare:GetMarchingSquareAt(x,y)

	local tl = self:Invert(self.mapData:Map(x-1,y-1)) or 0	
	local tr = self:Invert(self.mapData:Map(x,y-1)) or 0	
	local bl = self:Invert(self.mapData:Map(x-1,y)) or 0
	local br = self:Invert(self.mapData:Map(x,y)) or 0 
	
	local res = ((tl + lshift(tr,1) + lshift(br,2) + lshift(bl,3)));

	return res; 

end

---------------------------------------------------------------
-- Build tilemap 
---------------------------------------------------------------
function TMarchingSquare:BuildTilemap()
	for xm=1,cave._w do
		for ym=1,cave._h do		
			idx = self:GetMarchingSquareAt(xm,ym);	
			Tile(xm-1,ym-1,self.theme[idx+1].tile,0,self.theme[idx+1].flag)
		end
	end
end

---------------------------------------------------------------
-- ADD TILE
---------------------------------------------------------------
function TMarchingSquare:AddCell(x,y)
	local cx = math.floor( (x+4)/8 )
	local cy = math.floor( (y+4)/8 )
	
	self.mapData:Set(cx,cy,0)

	for xm=cx-2,cx+2 do
		for ym=cy-2,cy+2 do		
			idx = self:GetMarchingSquareAt(xm,ym);	
			Tile(xm-1,ym-1,self.theme[idx+1].tile,0,self.theme[idx+1].flag)
		end
	end
end
---------------------------------------------------------------
-- DELETE TILE
---------------------------------------------------------------
function TMarchingSquare:DelCell(x,y)
	local cx = math.floor( (x+4)/8 )
	local cy = math.floor( (y+4)/8 )
	
	self.mapData:Set(cx,cy,1)

	for xm=cx-2,cx+2 do
		for ym=cy-2,cy+2 do		
			idx = self:GetMarchingSquareAt(xm,ym);	
			Tile(xm-1,ym-1,self.theme[idx+1].tile,0,self.theme[idx+1].flag)
		end
	end
end

---------------------------------------------------------------
-- Public BITWISE operations
---------------------------------------------------------------
function lshift(x, by)
  return x * 2 ^ by
end

function rshift(x, by)
  return math.floor(x / 2 ^ by)
end
