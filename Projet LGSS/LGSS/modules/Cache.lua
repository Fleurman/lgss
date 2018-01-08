--[[
module Cache

TODO:

-[x] Cache the Font Objects
-[ ] Cache the ImageFont if it is

-[ ] Way to use the same bitmap multiple times

]]--
Cache = {}

Cache.cache = {
  font = {},
  bitmap = {},
  tiles = {}
}
Cache.glyphs = ' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

function Cache:font(name,size)
  name = name or " "
  local filename,ftype = LGSS:filename("Font/" .. name)
  if filename then
    if not self.cache.font[tostring(name) .. size] then
      self.cache.font[tostring(name) .. size] = {}
      self.cache.font[tostring(name) .. size].name = name
      self.cache.font[tostring(name) .. size].size = size
      if ftype == ".png" then
        self.cache.font[tostring(name) .. size].font = love.graphics.newImageFont(filename,Cache.glyphs,0)
        --print(self.cache.font[tostring(name) .. size].font,filename)
      else
        self.cache.font[tostring(name) .. size].font = love.graphics.newFont(filename,size)
      end
    end
    return self.cache.font[tostring(name) .. size].font
  else
    return love.graphics.newFont(size)
    --return love.graphics.getFont()
  end
end

function Cache:animation(name)
  return self:load_bitmap("Graphics/Animations/",name)
end

function Cache:autotile(name)
  return self:load_bitmap("Graphics/Autotiles/",name)
end

function Cache:character(name)
  return self:load_bitmap("Graphics/Characters/",name)
end

function Cache:fog(name)
  return self:load_bitmap("Graphics/Fogs/",name)
end

function Cache:tileset(name)
  return self:load_bitmap("Graphics/Tilesets/",name)
end

function Cache:panorama(name)
  return self:load_bitmap("Graphics/Panoramas/",name)
end

function Cache:picture(name)
  return self:load_bitmap("Graphics/Pictures/",name)
end

function Cache:title(name)
  return self:load_bitmap("Graphics/Titles/",name)
end

function Cache:windowskin(name)
  return self:load_bitmap("Graphics/Windowskins/",name)
end

function Cache:tile(filename, tile_id)
  local key = filename .. tile_id
  if not self.cache.tiles[key] or self.cache.tiles[key].disposed then
    self.cache.tiles[key] = Bitmap(32, 32)
    local x = (tile_id - 384) % 8 * 32
    local y = math.floor((tile_id - 384) / 8) * 32
    local rect = Rect(x, y, 32, 32)
    local bit = self:tileset(filename)
    --print(rect)
    self.cache.tiles[key]:blt(0, 0, bit, rect)
  end
  --print(self.cache.tiles[key])
  return self.cache.tiles[key]
end

function Cache:load_bitmap(folder,name)
  local path = folder .. name
  if love.filesystem.exists(folder) then
    if self.cache.bitmap[path] then
      return self.cache.bitmap[path]
    else
--      local file = LGSS:filename(path)
--      self.cache.bitmap[path] = Bitmap(file)
      --local file = LGSS:filename(path)
      self.cache.bitmap[path] = Bitmap(path)
      return self.cache.bitmap[path]
    end
  else
    return false
  end
end

function Cache:clear()
  self.cache = { font = {}, bitmap = {} }
end

return Cache