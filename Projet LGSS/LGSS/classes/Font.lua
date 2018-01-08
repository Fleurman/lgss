--[[
#class Font

|needed Methods:|
-[x] simulate Cache
-[x] initialize
-[x] arguments- name,size
-[ ] way to handle bold,italic
-[x] set parameters

**TODO:**
-() Police de secours ? setFallbacks
-() handle ImageFonts

]]--
Font = class("Font")

function Font:init(name,size)
  
  self._name = name and name or ""
  self._size = size and size or 24
  
  getmetatable(self).__newindex = function(s,k,v)
    if k == "size" or k == "name" then
        local name = "_" .. k
        rawset(s, name, v)
        s.font = Cache:font(s._name,s._size)
        return
    else
      rawset(s, k, v)
    end
  end
  
  getmetatable(self).__index = function(s,k)
    if k == "size" or k == "name"  then
      local name = "_" .. k
      return rawget(s, name)
    end
    return s.class[k]
  end
  
  self._bold = false
  self._italic = false
  self.color = Color("black")
  self.font = Cache:font(self.name,self.size)
  
  getmetatable(self).__tostring = function(s)
    return "" .. s.name .. ", " .. s.size .. ", " .. tostring(s.color)
  end
  
  getmetatable(self).__call = function(s)
    s.font = Cache:font(s.name,s.size)
    return s.font
  end
  
end

function Font:setSize(v)
  self.size = v
  self.font = Cache:font(self.name,self.size)
end
function Font:setFont(v)
  self.name = v
  self.font = Cache:font(self.name,self.size)
end