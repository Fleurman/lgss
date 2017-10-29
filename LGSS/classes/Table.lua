Table = class("Table")

function Table:init(x,y,z)
  
  self._ysize = 1
  self._zsize = 1
  getmetatable(self).__newindex = function(s,k,v)
    if k == "ysize" or k == "zsize" then
      local cv = tonumber(v)
      if cv then
        local name = "_" .. k
        local maxv = math.max(1,cv)
        rawset(s, name, maxv)
        return
      end
    end
    rawset(s, k, v)
  end
  
  getmetatable(self).__index = function(s,k)
    if k == "ysize" or k == "zsize" then
      local name = "_" .. k
      return rawget(s, name)
    end
    return s.class[k]
  end
  
  self.xsize = x
  self.ysize = y and y or 1
  self.zsize = z and z or 1
  self.data = {}
  for row=1,self.xsize do
    for col=1,self.ysize do
        self.data[row*self.ysize +col] = {}
    end
  end
end

function Table:set(x,y,z,v)
  if x > self.xsize or y > self.ysize or z > self.zsize then return false end
  local row = math.max(1,x)
  local col = math.max(1,y)
  local dim = math.max(1,z)
  self.data[row*self.ysize+col][dim] = v
end

function Table:get(x,y,z)
  if x > self.xsize or y > self.ysize or z > self.zsize then return nil end
  local row = math.max(1,x)
  local col = math.max(1,y)
  local dim = math.max(1,z)
  return self.data[row*self.ysize+col][dim]
end