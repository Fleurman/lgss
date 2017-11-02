--[[
#class Sprite

|Needed methods:|
-[ ]

**TODO:**
-[ ]

]]--

Sprite = class("Sprite")

function Sprite:init(view)
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
    Graphics:add_sprite(self)
end

function Sprite:realZ()
  if self.viewport then return self.viewport.z + self.x end
  return self.z
end

function Sprite:dispose()
    self.disposed = true
    Graphics:remove_sprite(self)
end
  
function Sprite:disposed()
    return self.disposed
end

function Sprite:set_bitmap(bitmap)
  self._bitmap = bitmap
  self.src_rect.width,self.src_rect.height = bitmap.width, bitmap.height
end

function Sprite:draw()
  local v = self.viewport
  if v then love.graphics.setScissor(v.x,v.y,v.width,v.height) end
  love.graphics.draw(self.bitmap(),self.x,self.y)
  love.graphics.origin()
end