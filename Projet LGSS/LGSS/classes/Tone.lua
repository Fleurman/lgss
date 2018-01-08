--[[
class Tone

TODO:

-[ ] handle 'return' methods and '!' methods

]]--
Tone = class("Tone")


function Tone:init(r,g,b,gr)
  
  getmetatable(self).__newindex = function(s,k,v)
    if k == "r" then
      k = "red"
    elseif k == "g" then
      k = "green"
    elseif k == "b" then
      k = "blue"
    elseif k == "gr" then
      k = "grey"
    end
    if k == "red" or k == "green" or k == "blue" or k == "grey" then
      local cv = tonumber(v)
      if cv then
        local name = "_" .. k
        local maxv = math.max(-255,cv)
        local minv = math.min(maxv,255)
        rawset(s, name, minv)
        return
      end
    end
    rawset(s, k, v)
  end
  
  getmetatable(self).__index = function(s,k,v)
    if k == "r" then
      k = "red"
    elseif k == "g" then
      k = "green"
    elseif k == "b" then
      k = "blue"
    elseif k == "gr" then
      k = "grey"
    end
    if k == "red" or k == "green" or k == "blue" or k == "grey" then
      local name = "_" .. k
      return rawget(s, name)
    end
    return s.class[k]
  end
  
  gr = gr or 255
  
  if type(r) == "number" then
    self.red,self.green,self.blue,self.grey = r,g,b,gr
  elseif r == "black" then
    self.red,self.green,self.blue,self.grey = 0,0,0,0
  elseif r == "white" then
    self.red,self.green,self.blue,self.grey = 255,255,255,0
  elseif r == "grey" then
    self.red,self.green,self.blue,self.grey = 255,255,255,255
  else
    self.red,self.green,self.blue,self.grey = r.r,r.g,r.b,r.gr
  end
  
  getmetatable(self).__tostring = function(s)
    return "" .. s.red .. ", " .. s.green .. ", " .. s.blue .. ", " .. s.grey
  end

  getmetatable(self).__eq = function(col,ncol)
    if col.red ~= ncol.red then return false end
    if col.green ~= ncol.green then return false end
    if col.blue ~= ncol.blue then return false end
    if col.grey ~= ncol.grey then return false end
    return true
  end
  getmetatable(self).__call = function(s)
    return s.red,s.green,s.blue,s.grey
  end
end

function Tone:set(r,g,b,gr)
  gr = gr or self.grey
  if type(r) == "number" then
    self.red,self.green,self.blue,self.grey = r,g,b,gr
  else
    self.red,self.green,self.blue,self.grey = r.red,r.green,r.blue,r.grey
  end
end

function Tone:empty()
  self.red,self.green,self.blue,self.grey = 0,0,0,0
end

function Tone:list()
  return self.red,self.green,self.blue,self.grey
end

function Tone:blend(ncol)
  self.red = self.red + ncol.red
  self.green = self.green + ncol.green
  self.blue = self.blue + ncol.blue
  self.grey = self.grey + ncol.grey
end