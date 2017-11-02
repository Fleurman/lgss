--[[
#class Bitmap

TODO:
-[ ] function 'text_size'
-[ ] function 'draw_text' classic

-[ ] function 'gradient', 'clear_rect', 'blur'

]]--
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
  --print("type: " ..type(width))
  if not height then
    if type(width) == "string" then
      local file = LGSS:filename(width)
      local img = love.graphics.newCanvas(32,32)
      if file then img = love.graphics.newImage(file) end
      local w,h = img:getDimensions()
      self.width,self.height = w,h
      self._image = love.graphics.newCanvas(w,h)
      self._image:renderTo( function() love.graphics.draw(img) end)
    elseif type(width) == "number" then
      --print("width")
      height = width
      self.width,self.height = width,height
      self._image = love.graphics.newCanvas(width,height)
    else
      --print("none")
      width,height = 32,32
      self.width,self.height = width,height
      self._image = love.graphics.newCanvas(width,height)
    end
  else
    --print("height")
    self.width,self.height = width,height
    self._image = love.graphics.newCanvas(width,height)
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
    love.graphics.setColor(Color("white")())
  end)
end

function Bitmap:line_rect(x,y,w,h,col,line,round)
  x,y,w,h,col,line,round = prep_rect(x,y,w,h,col,line,round)
  local rx,ry,seg = nil,nil,nil
  if round then rx,ry,seg = round[1],round[2],round[3] end
  self._image:renderTo( function()
    love.graphics.setColor(col())
    love.graphics.setLineWidth(line)
    love.graphics.rectangle("line", x+line*0.5, y+line*0.5, w-line, h-line, rx, ry, seg)
    love.graphics.setColor(Color("white")())
  end)
end

function Bitmap:blt(x,y,sbit,sr,opacity)
  opacity = opacity or 255
  local data = sbit():newImageData(sr.x, sr.y, sr.width, sr.height)
  local texture = love.graphics.newImage(data)
  self._image:renderTo( function()
    love.graphics.setColor(255,255,255,opacity)
    love.graphics.draw(texture,x,y)
    love.graphics.setColor(Color("white")())
  end)
end

function Bitmap:stretch_blt(dr,sbit,sr,opacity)
  opacity = opacity or 255
  local data = sbit():newImageData(sr.x, sr.y, sr.width, sr.height)
  local texture = love.graphics.newImage(data)
  local w,h = texture:getDimensions()
  self._image:renderTo( function()
    love.graphics.setColor(255,255,255,opacity)
    love.graphics.draw(texture,dr.x,dr.y,0,(dr.width/w),(dr.height/h))
    love.graphics.setColor(Color("white")())
  end)
end

function Bitmap:draw_text(x,y,width,height,text,align)
  x,y,width,height,text,align = prep_rect(x,y,width,height,text,align)
  align = align and math.min(3,math.max(0,align)) or 0
  local al = {"left","center","right","justify"}
  local v = Rect(x,y,width,height)
  
  self._image:renderTo( function()
    love.graphics.setScissor(v.x,v.y,v.width,v.height)
    love.graphics.setFont(self.font())
    love.graphics.setColor(self.font.color())
    love.graphics.printf( text, x, y, width, al[align])
    love.graphics.setColor(Color("white")())
    love.graphics.setScissor()
  end)

end
