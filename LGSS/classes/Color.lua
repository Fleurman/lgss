--[[
#class Color

TODO:

-[x] better handling of color = Color
-[x] find a way to clamp values between 0-255
-[ ] 

]]--
Color = class("Color")

function Color:init(r,g,b,a)
  
  getmetatable(self).__newindex = function(s,k,v)
    if k == "r" then
      k = "red"
    elseif k == "g" then
      k = "green"
    elseif k == "b" then
      k = "blue"
    elseif k == "a" then
      k = "alpha"
    end
    if k == "red" or k == "green" or k == "blue" or k == "alpha" then
      local cv = tonumber(v)
      if cv then
        local name = "_" .. k
        local maxv = math.max(0,cv)
        local minv = math.min(maxv,255)
        rawset(s, name, minv)
        return
      end
    end
    rawset(s, k, v)
  end
  
  getmetatable(self).__index = function(s,k)
    if k == "r" then
      k = "red"
    elseif k == "g" then
      k = "green"
    elseif k == "b" then
      k = "blue"
    elseif k == "a" then
      k = "alpha"
    end
    if k == "red" or k == "green" or k == "blue" or k == "alpha" then
      local name = "_" .. k
      return rawget(s, name)
    end
    return s.class[k]
  end
  
  a = a or 255
  
  if type(r) == "number" then
    self.red,self.green,self.blue,self.alpha = r,g,b,a
  elseif r == "black" then
    self.red,self.green,self.blue,self.alpha = 0,0,0,255
  elseif r == "white" then
    self.red,self.green,self.blue,self.alpha = 255,255,255,255
  elseif r == "red" then
    self.red,self.green,self.blue,self.alpha = 255,0,0,255
  elseif r == "green" then
    self.red,self.green,self.blue,self.alpha = 0,255,0,255
  elseif r == "blue" then
    self.red,self.green,self.blue,self.alpha = 0,0,255,255
  elseif r == "yellow" then
    self.red,self.green,self.blue,self.alpha = 255,255,0,255
  elseif r == "orange" then
    self.red,self.green,self.blue,self.alpha = 255,127,0,255
  elseif r == "cyan" then
    self.red,self.green,self.blue,self.alpha = 0,255,255,255
  elseif r == "purple" then
    self.red,self.green,self.blue,self.alpha = 255,0,255,255
  elseif r == nil then
    self.red,self.green,self.blue,self.alpha = 0,0,0,0
  else
    self.red,self.green,self.blue,self.alpha = r.red,r.green,r.blue,r.alpha
  end
  
  getmetatable(self).__tostring = function(s)
    return "" .. s.red .. ", " .. s.green .. ", " .. s.blue .. ", " .. s.alpha
  end

  getmetatable(self).__eq = function(col,ncol)
    if col.red ~= ncol.red then return false end
    if col.green ~= ncol.green then return false end
    if col.blue ~= ncol.blue then return false end
    if col.alpha ~= ncol.alpha then return false end
    return true
  end
  
  getmetatable(self).__call = function(s)
    return s.r,s.g,s.b,s.a
  end
  
end

function Color:set(r,g,b,a)
  a = a or self.a
  if r:instanceOf(Color) then
    self.r,self.g,self.b,self.a = r.r,r.g,r.b,r.a
  else
    self.r,self.g,self.b,self.a = r,g,b,a
  end
end

function Color:empty()
  self.r,self.g,self.b,self.a = 0,0,0,0
end

function Color:list()
  return self.r,self.g,self.b,self.a
end

function Color:blend(ncol)
  local col = self + ncol
  self.r,self.g,self.b,self.a = col.r,col.g,col.b,col.a
end

function Color:substract(ncol)
  local col = self - ncol
  self.r,self.g,self.b,self.a = col.r,col.g,col.b,col.a
end

function Color.__add(col1,col2)
  local c = Color()
  c.r = col1.r + col2.r
  c.g = col1.g + col2.g
  c.b = col1.b + col2.b
  c.a = col1.a + col2.a
  return c
end
function Color.__sub(col1,col2)
  local c = Color()
  c.r = col1.r - col2.r
  c.g = col1.g - col2.g
  c.b = col1.b - col2.b
  c.a = col1.a - col2.a
  return c
end

function Color.__mul(col1,col2)
  local c = Color()
  c.r = col1.r * col2.r
  c.g = col1.g * col2.g
  c.b = col1.b * col2.b
  c.a = col1.a * col2.a
  return c
end

function Color.__div(col1,col2)
  local c = Color()
  c.r = col1.r/col2.r
  c.g = col1.g/col2.g
  c.b = col1.b/col2.b
  c.a = col1.a/col2.a
  return c
end