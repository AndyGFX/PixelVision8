-- Debugging tools v0.12 by dagondev 
-- Changelog:
-- v0.12
-- * added hack to bigger background and reposition of debug to fight debug font drawing outside background
-- * added support for camera offset so msg is always in topright
-- * switched background color id to 0 by default and added arg to init to specify color 
-- * added ability to init without background
-- v0.11 
-- * made debugging modular to decouple it from game code.
-- * fixed bug where first char of the text would be rendered outside of background.
-- * fixed bug where debug message would be spammed to outside debug by calling print in Logger:Update instead of Logger:Debug, ups.
-- v0.1 
--- * first release 
Logger = {}
Logger.__index = Logger

----------------------
-- global constants --
----------------------
GL_FONT_WIDTH=8
GL_FONT_HEIGHT=7
GL_FONT_SPRITE_SIZE=8

----------------------
-- local variables  --
----------------------
local backgroundBufferArray={} -- table used for drawing background for each debug line
local secondsElapsed=0 -- how long debug is updating
local messageArray={} -- table used for storing messages, don't touch!
local hackOffset=1-- hack: to make sure text is always on background, lets move text one char to the right and one down

------------------------
--   debug methods    --
------------------------
-- use this method to debug something
-- note: no support for bool values atm
-- LoggerDebug("aaaa")
-- LoggerDebug(0)
-- LoggerDebug(nil)
-- LoggerDebug(thisIsBoolVar and 1 or 0)
-- LoggerDebug(thisIsBoolVar and "true" or "false")
function Logger:Debug(msg)     
    local len=#messageArray
    while(len>self.maxHeightChars) do -- remove old messages; everything above GL_DEBUG_MAX_LINES
        local first=messageArray[1]
        table.remove(messageArray,1) 
        msgs = messageArray    
        len=#messageArray
    end
    local m=math.floor(secondsElapsed).."|"..msg or "nil val"
    table.insert(messageArray,m) -- add time in seconds at which message was passed and if msg==nil write about it
    print(m)
end

function Logger:Init(fontName,letterSpacing,maxWidthInPixels,maxLinesDrawn,rebuildScreenBufferInUpdateMethod,useBackground,backgroundColorID)
    self.fontName=fontName
    self.fontWidth=GL_FONT_WIDTH
    self.fontHeight=GL_FONT_HEIGHT
    self.fontLetterSpacing=letterSpacing
    
    maxLinesDrawn=maxLinesDrawn+hackOffset
    self.maxWidthPixels=maxWidthInPixels
    self.maxWidthChars=self.maxWidthPixels/self.fontWidth
    self.maxHeightPixels=maxLinesDrawn*self.fontHeight
    self.maxHeightChars=maxLinesDrawn

    self.xPositionOnScreenPixels=apiBridge.displayWidth-self.maxWidthPixels
    self.xPositionOnScreenChars=self.xPositionOnScreenPixels/self.fontWidth
    self.yPositionOnScreenPixels=0
    self.yPositionOnScreenChars=self.yPositionOnScreenPixels/self.fontHeight

    self.rebuildScreenBufferInUpdateMethod=rebuildScreenBufferInUpdateMethod
    self.useBackground = useBackground or true
    backgroundColorID = backgroundColorID or 0

    if #backgroundBufferArray==0 and self.useBackground then -- get buffer data for one msg background
        for j=1,self.fontHeight do
            for i=1,self.maxWidthPixels do
                table.insert(backgroundBufferArray,backgroundColorID)
            end
        end
    end
end
-- call this function in Update(timeDelta) 
function Logger:Update(timeDelta,cameraX,cameraY)
    cameraX=cameraX or 0
    cameraY=cameraY or 0
    secondsElapsed = secondsElapsed + timeDelta
    -- if true logger can clean screenbuffer manually as that means user is not drawing anything else on buffer. if false, user have to call apiBridge:RebuildScreenBuffer() manually to clear screen and buffer
    if self.rebuildScreenBufferInUpdateMethod then
        apiBridge:RebuildScreenBuffer()
    end
    -- we need to call drawbufferdata in different loop than drawfonttobuffer as having both in same loop makes text behind background for some reason...
    if self.useBackground then
        for n=0,(#messageArray+hackOffset) do
            apiBridge:DrawBufferData(backgroundBufferArray,self.xPositionOnScreenPixels+cameraX,n*self.fontHeight+cameraY,#backgroundBufferArray/self.fontHeight,self.fontHeight)
        end
    end
    local i=0
    local cameraCharsX = math.floor(cameraX/self.fontWidth)
    local cameraCharsY =math.floor(cameraY/GL_FONT_SPRITE_SIZE) -- for camera scrolling we need sprite height, not font
    for k,v in pairs(messageArray) do
        apiBridge:DrawFontToBuffer(v, self.xPositionOnScreenChars+cameraCharsX+hackOffset, self.yPositionOnScreenChars+i+cameraCharsY+hackOffset,self.fontName, self.fontLetterSpacing)  
        i=i+1       
    end
end 