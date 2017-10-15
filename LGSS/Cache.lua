--[[
module Cache

TODO:

-[x] Cache the Font Objects
-[ ] Cache the ImageFont if it is

]]--
Cache = {}

Cache.fonts = {}
Cache.images = {}

function Cache:font(name,size)
  local filename = LGSS:filename("Font/" .. name)
  if filename then
    if not Cache.fonts[tostring(name) .. size] then
      Cache.fonts[tostring(name) .. size] = {}
      Cache.fonts[tostring(name) .. size].name = name
      Cache.fonts[tostring(name) .. size].size = size
      Cache.fonts[tostring(name) .. size].font = love.graphics.newFont(filename,size)
    end
    return Cache.fonts[tostring(name) .. size].font
  else
    return love.graphics.getFont()
  end
end

function Cache:picture(name)
  if love.filesystem.exists("Graphics/Pictures/" .. name) then
    if not Cache.images[tostring(name)] then
      local file = LGSS:filename("Graphics/Pictures/" .. name)
      Cache.images[tostring(name)] = love.graphics.newImage(file)
    end
    return Cache.images[tostring(name) .. size]
  else
    return false
  end
end

return Cache