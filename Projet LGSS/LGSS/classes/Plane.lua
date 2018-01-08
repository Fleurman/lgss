--[[
#class Plane

|Needed methods:|
-[ ]

**TODO:**
-[ ]

]]--

Plane = class("Plane")

function Plane:init(view)
  self._bitmap = nil
  
  getmetatable(self).__newindex = function(s,k,v)
    if k == "bitmap" then
      s:set_bitmap(v)
      return
    end
    rawset(s, k, v)
  end
  
  getmetatable(self).__index = function(s,k)
    if k == "bitmap" then
      local name = "_" .. k
      return rawget(s, name)
    end
    return s.class[k]
  end
  
  self.viewport = view
  self.visible = true
  self.x, self.y, self.z = 0, 0, 0
  self.ox, self.oy = 0, 0
  self.zoom_x, self.zoom_y = 1.0, 1.0
  self.angle = 0
  self.mirror = false
  self.bush_depth = 0
  self.opacity = 255
  self.blend_type = 0
  self.src_rect = Rect(0, 0, 0, 0)
  Graphics:addSprite(self)
end

function Plane:realZ()
  if self.viewport then return self.viewport.z + self.z end
  return self.z
end

function Plane:dispose()
  self.disposed = true
  Graphics:removeSprite(self)
end
  
function Plane:disposed()
  return self.disposed
end

function Plane:set_bitmap(bitmap)
  self._bitmap = bitmap
  self.src_rect.width,self.src_rect.height = bitmap.width, bitmap.height
end

function Plane:draw()
  if not self.bitmap then return end
  local v = self.viewport
  if v then
    love.graphics.translate(v.x,v.y)
    love.graphics.setScissor(v.x,v.y,v.width,v.height)
  end
  local b = self.bitmap()
  b:setWrap("repeat","repeat")
  local gw,gh = Graphics:getDimensions()
  local q = love.graphics.newQuad(0,0,gw,gh,self.src_rect.width,self.src_rect.height)
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.draw(b,q,self.x-self.ox,self.y-self.oy,self.angle,self.zoom_x,self.zoom_y,self.ox,self.oy)
  love.graphics.setBlendMode("alpha")
  love.graphics.origin()
  love.graphics.setScissor()
end