--[[
#class Viewport

|Needed methods:|
-[ ] dispose
-[ ] disposed?
-[ ] flash
_-[ ] z=_

**TODO:**
-[ ] blend,substract
-[ ] brightness
-[ ] opacity

_args:_
-rect
-visible
-width,height
-x,y,z
-ox,oy
-color,tone

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
    return rawget(s,k)
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
  
  self.x,self.y,self.width,self.height = 0,0,0,0
  self.rect = function() return Rect(self.x,self.y,self.width,self.height) end
  self.z = 0
  self.visible = true
  self.ox,self.oy = 0,0
  self.color = Color("white")
  self.tone = Tone("white")
  
end

function Viewport:dispose()
  
end

function Viewport:disposed()
  
end

function Viewport:flash()
  
end

function Viewport:update(dt)
  
end