--[[
#class Sprite

|Needed methods:|
-[ ]

**TODO:**
-[ ]

]]--

Sprite = class("Sprite")

function Sprite:init(view)
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
  self.bitmap = bitmap
  self.src_rect = Rect.new(0, 0, bitmap.width, bitmap.height)
end

function Sprite:draw()
  love.graphics.draw(self.bitmap(),self.x,self.y)
end