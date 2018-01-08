--[[
#class Bitmap

|Needed methods:|
-[x] clear
-[x] clear_rect
-[x] zoom_blur,box_blur,pixel_blur

**TODO:**
-[x] function 'text_size'
-[x] function 'draw_text' classic
-[x] function 'gradient'

]]--
Bitmap = class("Bitmap")

function Bitmap:init(width,height)
  self._width = 0
  self._height = 0
  self._name = ""
  
  getmetatable(self).__index = function(s,k)
    if k == "width" or k == "height" or k=="name"then
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
    elseif k=="name" then return
    end
    rawset(s,k,v)
  end
  --print("type: " ..type(width))
  if not height then
    if type(width) == "string" then
      self._name = width
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

--function Bitmap:resize(w,h) end

function Bitmap:dispose()
  if self.disposed then return end
  self.disposed = true
  self._image = love.graphics.newCanvas(self.width,self.height)
end

function Bitmap:clear()  
  self._image:renderTo( function() love.graphics.clear() end)
end

function Bitmap:clear_rect(x,y,w,h)
  if type(x) == "table" then x,y,w,h = x.y,x.y,x.with,x.height end
  self._image:renderTo( function()
    love.graphics.setScissor(x,y,w,h)
    love.graphics.clear()
    love.graphics.setScissor()
  end)
end

local function drawShader(s,shader)  
  local data = s._image:newImageData(0,0,s.width,s.height)
  local texture = love.graphics.newImage(data)
  s:clear()
  s._image:renderTo( function()
    love.graphics.setShader(shader)
    love.graphics.draw(texture,0,0)
    love.graphics.setShader()
  end)
end

function Bitmap:zoom_blur(v)
  local shader = Graphics.shaderZoomBlur
  if v then v = v > 0 and v or 1 else v = 5 end
  shader:send("strength",v*0.5)
  drawShader(self,shader)
end
function Bitmap:box_blur(x,y)
  y = y or x
  self:horizontal_blur(x)
  self:vertical_blur(y)
end
function Bitmap:horizontal_blur(v)
  local shader = Graphics.shaderBoxBlur
  if v then
    if v == 0 then return end
    v = v > 0 and v or 1
  else v = 5 end
  shader:send('direction', {1/self.width,0})
  shader:send('radius', v*0.5)
  drawShader(self,shader)
end
function Bitmap:vertical_blur(v)
  local shader = Graphics.shaderBoxBlur
  if v then
    if v == 0 then return end
    v = v > 0 and v or 1
  else v = 5 end
  shader:send('direction', {0,1/self.height})
  shader:send('radius', v*0.5)
  drawShader(self,shader)
end
function Bitmap:pixel_blur(s,f)
  local shader = Graphics.shaderPixelBlur
  if type(s) == "number" then s = {s,s} end
  assert(type(s) == "table" and #s == 2, "Invalid value for `size'")
  shader:send("size", s)
  shader:send("feedback", math.min(1, math.max(0, tonumber(f) or 0)))
  drawShader(self,shader)
end

function Bitmap:fill_rect(x,y,w,h,col,round)
  if type(x) == "table" then x,y,w,h,col,round = x.x,x.y,x.width,x.height,y,w end
  local rx,ry,seg = nil,nil,nil
  if round then rx,ry,seg = round[1],round[2],round[3] end
  self._image:renderTo( function()
    love.graphics.setColor(col())
    love.graphics.rectangle("fill", x, y, w, h, rx, ry, seg)
    love.graphics.setColor(Color("white")())
  end)
end

function Bitmap:gradient_fill_rect(x,y,w,h,col1,col2,d)
  if type(x) == "table" then x,y,w,h,col1,col2,d = x.x,x.y,x.width,x.height,y,w,h end
  local rx,ry,seg = nil,nil,nil
  if round then rx,ry,seg = round[1],round[2],round[3] end
  local s = d == 0 and w or h
  for i=0,s do
    local color = (col1*(1-(i/s)))+(col2*(i/s))
    self._image:renderTo( function()
      love.graphics.setColor(color())
      if d == 0 then
        love.graphics.rectangle("fill", x+i, y, 1, h)
      else
        love.graphics.rectangle("fill", x, y+i, w, 1)
      end
      love.graphics.setColor(Color("white")())
    end)
  end
end

function Bitmap:line_rect(x,y,w,h,col,line,round)
  if type(x) == "table" then x,y,w,h,col,line,round = x.x,x.y,x.width,x.height,y,w,h end
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
  --local data = sbit():newImageData(sr.x, sr.y, sr.width, sr.height)
  local texture = sbit()--love.graphics.newImage(data)
  local w,h = sbit():getDimensions()
  local q = love.graphics.newQuad(sr.x, sr.y, sr.width, sr.height,w,h)
  self._image:renderTo( function()
    love.graphics.setColor(255,255,255,opacity)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(texture,q,x,y)
    love.graphics.setBlendMode("alpha") 
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
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(texture,dr.x,dr.y,0,(dr.width/w),(dr.height/h))
    love.graphics.setBlendMode("alpha") 
    love.graphics.setColor(Color("white")())
  end)
end

function Bitmap:pattern_blt(dr,sbit,sr,opacity)
  opacity = opacity or 255
  local data = sbit():newImageData(sr.x, sr.y, sr.width, sr.height)
  local texture = love.graphics.newImage(data)
  texture:setWrap("repeat","repeat")
  local w,h = texture:getDimensions()
  local q = love.graphics.newQuad(0,0,dr.width,dr.height,w,h)
  self._image:renderTo( function()
    love.graphics.setColor(255,255,255,opacity)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(texture,q,dr.x,dr.y,0)
    love.graphics.setBlendMode("alpha") 
    love.graphics.setColor(Color("white")())
  end)
end

function Bitmap:draw_text(x,y,width,height,text,align)
  if type(x) == "table" then x,y,width,height,text,align = x.x,x.y,x.width,x.height,y,width end
  --x,y,width,height,text,align = prep_rect(x,y,width,height,text,align)
  align = align and math.min(3,math.max(0,align)) or 0
  local al = {"left","center","right","justify","wleft","wcenter","wright","wjustify"}
  local v = Rect(x,y,width,height)
  
  self._image:renderTo( function()
    love.graphics.setScissor(v.x,v.y,v.width,v.height)
    love.graphics.setFont(self.font())
    love.graphics.setColor(self.font.color())
    if align < 4 then
      local t = love.graphics.newText(self.font(),text)
      local tw = t:getWidth()
      if tw > width then
        local scale = math.max(0.4,(width/tw))
        love.graphics.draw(t,x,y,0,scale,1)
      else
        love.graphics.print(text,x,y)
      end
    else
      love.graphics.printf( text, x, y, width, al[align+1])
    end
    love.graphics.setColor(Color("white")())
    love.graphics.setScissor()
  end)
end

function Bitmap:text_size(text)
  local w,h = 0,0
  text:gsub("([^\n]*)", function(i)
    local tw = self.font():getWidth(i)
    if tw > w then w = tw end
    local th = self.font():getHeight(i)
    if th > h then h = th end
  end)
  return Rect(0,0,w,h)
end
