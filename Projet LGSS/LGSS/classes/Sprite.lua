--[[
#class Sprite

|Needed methods:|
-[ ]

**TODO:**
-[X] opacity

-[ ] opacity isues (handle Viewport opacity)

]]--

Sprite = class("Sprite")

function Sprite:init(view)
  self._bitmap = nil
  
  getmetatable(self).__newindex = function(s,k,v)
    if k == "bitmap" then
      s:setBitmap(v)
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
  self.zoomX, self.zoomY = 1.0, 1.0
  self.angle = 0
  self.mirror = false
  self.bushDepth = 0
  self.opacity = 255
  self.blendType = "alpha"  -- alpha,replace,screen,add,substract,multiply,lighten,darken
  self.sourceRect = Rect(0, 0, 0, 0)
  Graphics:addSprite(self)
end

function Sprite:realZ()
  if self.viewport then return self.viewport.z + self.z end
  return self.z
end

function Sprite:dispose()
  self.disposed = true
  Graphics:removeSprite(self)
end

function Sprite:disposed()
  return self.disposed
end

function Sprite:setBitmap(bitmap)
  self._bitmap = bitmap
  self.sourceRect.width,self.sourceRect.height = bitmap.width, bitmap.height
end

function Sprite:draw()
  if not self.bitmap then return end
  if not self.visible then return end
  local v = self.viewport
  local op = self.opacity/255
  local col = Color(255*op,255*op,255*op,self.opacity)
  if v then
    love.graphics.translate(v.x,v.y)
    love.graphics.setScissor(v.x,v.y,v.width,v.height)
    col.alpha = col.alpha * (v.opacity/255)
  end
  local b = self.bitmap()
  love.graphics.setBlendMode(self.blendType, "premultiplied")
  love.graphics.setColor(col())
  love.graphics.draw(b,self.x,self.y,self.angle,self.zoomX,self.zoomY,self.ox,self.oy)
  love.graphics.setBlendMode("alpha")
  love.graphics.setScissor()
  love.graphics.setColor(255,255,255,255)
  love.graphics.origin()
end