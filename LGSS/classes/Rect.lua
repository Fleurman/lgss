--[[
class RECT

Needed methods:

TODO:
-[ ] 

]]--
Rect = class("Rect")

function Rect:init(x,y,width,height)
  if type(x) == "number" then
    self.x,self.y,self.width,self.height = x,y,width,height
  else
    self.x,self.y,self.width,self.height = x.x,x.y,x.width,x.height
  end
  getmetatable(self).__eq = function(rect,nrect)
    if rect.x ~= nrect.x then return false end
    if rect.y ~= nrect.y then return false end
    if rect.width ~= nrect.width then return false end
    if rect.height ~= nrect.height then return false end
    return true
  end
  getmetatable(self).__call = function(s)
    return s.x,s.y,s.width,s.height
  end
  getmetatable(self).__tostring = function(s)
    return tostring(s.x .. "," .. s.y .. "," .. s.width .. "," .. s.height)
  end
end

function Rect:set(x,y,width,height)
  if type(x) == "number" then
    self.x,self.y,self.width,self.height = x,y,width,height
  else
    self = x
  end
end

function Rect:empty()
  self.x,self.y,self.width,self.height = 0,0,0,0
end

function Rect:list()
  return self.x,self.y,self.width,self.height
end