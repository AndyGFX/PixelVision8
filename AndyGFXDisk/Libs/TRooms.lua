
LoadScript("class.lua")

TRooms = class()


function TRooms:New(_xc,_yc)
	self.width = _xc
	self.height = _yc
	self.room = {}
	return class(self)
end

function TRooms:Blank()

	for i=1,self.height,1 do
	 	self.room[i]={}
	 	for j=1,self.width,1 do
	 		self.room[i][j]={}
	 	 	self.room[i][j].left = 0
	 	 	self.room[i][j].right = 0
	 	 	self.room[i][j].up = 0
	 	 	self.room[i][j].down = 0
	 	 	self.room[i][j].visited=0
			self.room[i][j].used_data={}
	    end
	end

end

function TRooms:Generate()
	self:Blank()
	for i=1,self.height do
	 	for j=1,self.width do
		  	if ((i==self.height) and (j==self.width)) then
		  	-- do nothing
		  	elseif (i==self.height) then
		   	self.room[i][j].right = 1
		   	self.room[i][j+1].left = 1
		  	elseif (j==self.width) then
		   	self.room[i][j].down = 1
		   	self.room[i+1][j].up = 1
		  	elseif (math.floor(math.random(0,2))==0) then
		   	self.room[i][j].right = 1
		   	self.room[i][j+1].left = 1
		  	else
		   	self.room[i][j].down = 1
		   	self.room[i+1][j].up = 1
		  	end
	 	end
	end
end


function TRooms:DrawMiniMap(sx,sy)
	local mx = 0
	local my = 0

	for x=1,self.width,1 do
		for y=1,self.height,1 do

				mx = sx +x*8
				my = sy +y*8
				DrawRect(mx-3, my-3, 7, 7, 6, DrawMode.Sprite)

				if self.room[y][x].up==1 then
					DrawPixels({6},mx-1, my-4, 1,1)
					DrawPixels({6},mx, my-4, 1,1)
					DrawPixels({6},mx+1, my-4, 1,1)
				end
				if self.room[y][x].right==1 then
					DrawPixels({6},mx+4, my+1, 1,1)
					DrawPixels({6},mx+4, my, 1,1)
					DrawPixels({6},mx+4, my-1, 1,1)
				end
				if self.room[y][x].left==1 then
					DrawPixels({6},mx-4, my+1, 1,1)
					DrawPixels({6},mx-4, my, 1,1)
					DrawPixels({6},mx-4, my-1, 1,1)
				end
				if self.room[y][x].down==1 then
					DrawPixels({6},mx+1, my+4, 1,1)
					DrawPixels({6},mx, my+4, 1,1)
					DrawPixels({6},mx-1, my+4, 1,1)
				end
			end

	end
end
