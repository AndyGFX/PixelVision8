


TDraw = {}

---------------------------------------------------------------
-- TCellular CONSTRUCTOR --------------------------------------
---------------------------------------------------------------

function TDraw:New()

    o = {
        }

    setmetatable(o, self)
    self.__index = self

    return o

end

function TDraw:Pixel(x,y,color)
    DrawPixels({color},x,y,1,1);
end

function TDraw:Line(x0, y0, x1,y1,color)
    local steep = false;
    local tmp = 0;
    if math.abs(y1 - y0) > math.abs(x1 - x0) then
        steep = true;
        tmp = x0;
        x0 = y0;
        y0 = tmp;

        tmp = x1;
        x1 = y1;
        y1 = tmp;
    end

    if x0 > x1 then
         tmp = x0;
         x0 = x1;
         x1 = tmp;

         tmp = y0;
         y0 = y1;
         y1 = tmp;
    end

    local deltax = x1 - x0;
    local deltay = math.abs(y1 - y0);
    local error = deltax / 2;

    y = y0
    if y0 < y1  then
       ystep = 1
    else
       ystep = -1
    end
    for x = x0,x1 do
        if steep then
          self:Pixel(y,x,color);
        else
          self:Pixel(x,y,color);
        end
        error = error - deltay
        if error < 0 then
            y = y + ystep
            error = error + deltax
        end
    end
end

------------------------------------------------
--          [x1,y1]
--    D--------C
--    |        |
--    |        |
--    |        |
--    A--------B
-- [x0,y0]
------------------------------------------------

function TDraw:Rectangle(x0,y0,x1,y1,color, filled)

    local Ax = x0;
    local Ay = y0;

    local Bx = x1;
    local By = y0;

    local Cx = x1;
    local Cy = y1;

    local Dx = x0;
    local Dy = y1;

    if (filled) then
      for yy=y0,y1 do
        self:Line(Ax,yy,Bx,yy,color)
      end
    else
      self:Line(Ax,Ay,Bx,By,color)
      self:Line(Bx,By,Cx,Cy,color)
      self:Line(Cx,Cy,Dx,Dy,color)
      self:Line(Dx,Dy,Ax,Ay,color)
    end
  end

function TDraw:PolyLine(points, color, closed)

  local idx = 2;
  for i=1,#points-2,2 do

    if i==1 then
      self:Line(points[1],points[2],points[3],points[4],color)
    else
      self:Line(points[idx-1],points[idx],points[idx+1],points[idx+2],color)
    end

    idx=idx+2
  end

  if closed then
    self:Line(points[1],points[2],points[#points-1],points[#points],color)
  end

end

-- SLOOOOW
--[[
function TDraw:Circle(cx,cy,r,color,filled)

  for x=0,r do
    y = math.sqrt(r*r-x*x)

    if (filled) then
      self:Line(cx+x,cy+y,cx+x,cy-y,color)
      self:Pixel(cx-x,cy-y,color+2)
      self:Pixel(cx-x,cy+y,color+1)

    else
      self:Pixel(cx+x,cy+y,color)
      self:Pixel(cx+x,cy-y,color)
      self:Pixel(cx-x,cy+y,color)
      self:Pixel(cx-x,cy-y,color)
    end

  end

end

function TDraw:Circle2(cx,cy,r,color,filled)

  for A=0,90 do
    x = r*math.sin(A)
    y = r*math.cos(A)

    if (filled) then
      self:Line(cx+x,cy+y,cx+x,cy-y,color)


    else
      self:Pixel(cx+x,cy+y,color)
      self:Pixel(cx+x,cy-y,color)
      self:Pixel(cx-x,cy+y,color)
      self:Pixel(cx-x,cy-y,color)
    end

  end

end
]]
