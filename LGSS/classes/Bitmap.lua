Bitmap = class("Bitmap")

function Bitmap:init(width,height)
  self._width = 0
  self._height = 0
  
  getmetatable(self).__index = function(s,k)
    if k == "width" or k == "height" then
      local hk = "_" .. k
      return rawget(s,hk)
    end
    return s.class[k]
  end
  
  getmetatable(self).__newindex = function(s,k,v)
    if k == "width" or k == "height" then
      local min = math.max(0,v)
      local hk = "_" .. k
      rawset(s,hk,min)
      return
    end
    rawset(s,k,v)
  end
  
  if not width then width,height = 32,32 end
  if height then
    self.width,self.height = width,height
    self._image = love.graphics.newCanvas(width,height)
  else
    local img = love.graphics.newImage(Cache:picture(width))
    local w,h = img:getDimensions()
    self.width,self.height = w,h
    self._image = love.graphics.newCanvas(width,height)
    self._image:renderTo( function() love.graphics.draw(img) end)
  end
  self.rect = Rect(0,0,self.width,self.height)
  self.font = Font()
  
  getmetatable(self).__call = function(s)
    return s._image
  end
  
end

function Bitmap:dispose()
  self.disposed = true
  self._image = love.graphics.newCanvas(width,height)
end

function Bitmap:disposed()
  return self.disposed
end

local function prep_rect(x,y,w,h,col,line,round)
  if type(x) == "table" then
    return x.x,x.y,x.width,x.height,y,w,h
  end
  return x,y,w,h,col,line,round
end

function Bitmap:fill_rect(x,y,w,h,col,round)
  local line = nil                                          -- That's ugly !
  x,y,w,h,col,line,round = prep_rect(x,y,w,h,col,nil,round)
  local rx,ry,seg = nil,nil,nil
  if round then rx,ry,seg = round[1],round[2],round[3] end
  self._image:renderTo( function() 
    love.graphics.setColor(col())
    love.graphics.rectangle("fill", x, y, w, h, rx, ry, seg)
  end)
end

function Bitmap:line_rect(x,y,w,h,col,line,round)
  x,y,w,h,col,line = prep_rect(x,y,w,h,col,line,round)
  local rx,ry,seg = nil,nil,nil
  if round then rx,ry,seg = round[1],round[2],round[3] end
  self._image:renderTo( function()
    love.graphics.setColor(col())
    love.graphics.setLineWidth(line)
    love.graphics.rectangle("line", x+line*0.5, y+line*0.5, w-line, h-line, rx, ry, seg)
  end)
end
