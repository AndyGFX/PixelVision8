
-- TMaze v0.5 [AndyGFX] ------------------------------------------------------

--[[

Installation:

copy file TMaze.lua to Lib folder

Initialization:

apiBridge:LoadLib("TMaze.lua")

Generate map:

function TMaze:Generate(w,h)

Argumets:

- w = width
- h = height

Example:

	maze = TMaze:New(32,32)
	maze:Generate()

result is stored in 1d vector in field _data, you can get value list via maze:GetMazeData()
each item is structured to:

	 	 	maze[i][j].left = 0
	 	 	maze[i][j].right = 0
	 	 	maze[i][j].up = 0
	 	 	maze[i][j].down = 0
	 	 	maze[i][j].visited=0

	 	 	0 = empty
	 	 	1 = wall

]]

-- Define TMaze class ---------------------------------------------

TMaze = {}

-- TMaze CONSTRUCTOR ------------------------------------------------------

function TMaze:New(w,h)

    o = {
    		width = w,
    		height = h,
            maze={}
        }

    setmetatable(o, self)
    self.__index = self

    return o

end

function TMaze:Blank()

	for i=1,self.height,1 do
	 	self.maze[i]={}
	 	for j=1,self.width,1 do
	 		self.maze[i][j]={}
	 	 	self.maze[i][j].left = 0
	 	 	self.maze[i][j].right = 0
	 	 	self.maze[i][j].up = 0
	 	 	self.maze[i][j].down = 0
	 	 	self.maze[i][j].visited=0
	    end
	end
end

function TMaze:Generate()
	self:Blank()
	for i=1,self.height do
	 	for j=1,self.width do
		  	if ((i==self.height) and (j==self.width)) then
		  	-- do nothing
		  	elseif (i==self.height) then
		   	self.maze[i][j].right = 1
		   	self.maze[i][j+1].left = 1
		  	elseif (j==self.width) then
		   	self.maze[i][j].down = 1
		   	self.maze[i+1][j].up = 1
		  	elseif (math.floor(math.random(0,2))==0) then
		   	self.maze[i][j].right = 1
		   	self.maze[i][j+1].left = 1
		  	else
		   	self.maze[i][j].down = 1
		   	self.maze[i+1][j].up = 1
		  	end
	 	end
	end
end

-- return generated maze data
function TMaze:GetMazeData()
	return self.maze;
end

function TMaze:Preview(ox,oy)
 white=7
 for i=0,#self.maze*2,1 do DrawPixels({14},ox+0,oy+i,1,1);end
 for j=1,#self.maze[1]*2,1 do DrawPixels({14},ox+j,oy+0,1,1); end

 for i=1,#self.maze do
 	for j=1,#self.maze[1] do
 		DrawPixels({14},ox+j*2,oy+i*2,1,1);
 	 	if self.maze[i][j].right==0 then
 	  		DrawPixels({14},ox+j*2,oy+i*2-1,1,1);
 	 	end
 	 	if self.maze[i][j].down==0 then
 	  		DrawPixels({14},ox+j*2-1,oy+i*2,1,1);
 	 	end
 	end
 end
end

print("TMaze class loaded")
