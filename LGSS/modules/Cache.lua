--[[
module Cache

TODO:

-[x] Cache the Font Objects
-[ ] Cache the ImageFont if it is

]]--
Cache = {}

Cache.cache = {
  font = {},
  bitmap = {}
}

function Cache:font(name,size)
  name = name or " "
  local filename = LGSS:filename("Font/" .. name)
  if filename then
    if not self.cache.font[tostring(name) .. size] then
      self.cache.font[tostring(name) .. size] = {}
      self.cache.font[tostring(name) .. size].name = name
      self.cache.font[tostring(name) .. size].size = size
      self.cache.font[tostring(name) .. size].font = love.graphics.newFont(filename,size)
    end
    return self.cache.font[tostring(name) .. size].font
  else
    return love.graphics.getFont()
  end
end

function Cache:animation(name)
  self:load_bitmap("Graphics/Animations/",name)
end

function Cache:autotile(name)
  self:load_bitmap("Graphics/Autotiles/",name)
end

function Cache:character(name)
  self:load_bitmap("Graphics/Characters/",name)
end

function Cache:fog(name)
  self:load_bitmap("Graphics/Fogs/",name)
end

function Cache:tileset(name)
  self:load_bitmap("Graphics/Tilesets/",name)
end

function Cache:panorama(name)
  self:load_bitmap("Graphics/Panoramas/",name)
end

function Cache:picture(name)
  return self:load_bitmap("Graphics/Pictures/",name)
end

function Cache:title(name)
  self:load_bitmap("Graphics/Titles/",name)
end

function Cache:windowskin(name)
  self:load_bitmap("Graphics/Windowskins/",name)
end

function Cache:load_bitmap(folder,name)
  local path = folder .. name
  if love.filesystem.exists(folder) then
    if self.cache.bitmap[path] then
      return self.cache.bitmap[path]
    else
      local file = LGSS:filename(path)
      self.cache.bitmap[path] = Bitmap(file)
      return self.cache.bitmap[path]
    end
  else
    return false
  end
end
return Cache