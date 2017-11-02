--[[
#class Viewport

|Needed methods:|
_-[ ] z=_

**TODO:**
-[ ] brightness
-[ ] opacity

]]--
Viewport = class("Viewport")

function Viewport:init(x,y,width,height)
  self._width = 0
  self._height = 0
  self._z = 0
  
  getmetatable(self).__index = function(s,k)
    if k == "width" or k == "height" then
      local hk = "_" .. k
      return rawget(s,hk)
    elseif k == "z" then
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
    elseif k == "z" then
      local hk = "_" .. k
      rawset(s,hk,v)
      return
    end
    rawset(s,k,v)
  end
  
  if y == nil then 
    self.rect = x
    self.x,self.y,self.width,self.height = x.x,x.y,x.width,x.height
  else
    self.x,self.y,self.width,self.height = x,y,width,height
    self.rect = Rect(self.x,self.y,self.width,self.height)
  end
  
  self.z = 0
  self.visible = true
  self.ox,self.oy = 0,0
  self.color = Color("white")
  self.tone = Tone("white")
  
end

function Viewport:dispose()
  self.disposed = true
end

function Viewport:disposed()
  return self.disposed
end

function Viewport:flash(color,duration)
  self.flash_color = color or Color("white")
  self.flash_duration = duration or 100
end

function Viewport:update(dt)
  self.flash_duration = math.max(self.flash_duration - 1, 0)
  if self.flash_duration == 0 then self.flash_color = nil end
end