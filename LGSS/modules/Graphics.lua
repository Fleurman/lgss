--[[
module Graphics

TODO:

-[ ] adjust position when setDimension()

]]--
Graphics = {}

Graphics.sprites = {}
Graphics.width,Graphics.height = love.graphics.getDimensions()
Graphics.frame_count = 0
Graphics.frame_rate = 60
Graphics.freezed = false;

function Graphics:setWidth(v)
  local w,h,f = love.window.getMode()
  love.window.setMode(v,h,f)
  self.width,self.height = love.window.getMode()
end

function Graphics:setHeight(v)
  local w,h,f = love.window.getMode()
  love.window.setMode(w,v,f)
  self.width,self.height = love.window.getMode()
end

function Graphics:setDimension(w,h)
  local dw,dh,f = love.window.getMode()
  love.window.setMode(w,h,f)
  self.width,self.height = love.window.getMode()
end

function Graphics:switchFullscreen()
  local v = true
  if love.window.getFullscreen() then v = false end
  love.window.setFullscreen(v)
end

function Graphics:setFullscreen(v)
  love.window.setFullscreen(v)
end

function Graphics:getFullscreen()
  love.window.getFullscreen()
end

function Graphics:screenShot()
end

function Graphics:freeze()
  self.freezed = true
end

function Graphics:unfreeze()
  self.freezed = false
end

function Graphics:add_sprite(spr)
  table.insert(self.sprites,spr)
  self:sort_sprites()
end

function Graphics:remove_sprite(spr)
  for k,v in ipairs(self.sprites) do
    if v == spr then table.remove(self.sprites,k) end
  end
end

function Graphics:sort_sprites()
  local comp = function(s1,s2) if s1:realZ() < s2:realZ() then return true end return false end
  table.sort(self.sprites,comp)
end

function Graphics:draw()
  for k,v in ipairs(self.sprites) do
    v:draw()
  end
end

function Graphics:update(dt)
  self:draw()
  self.frame_count = self.frame_count + 1
  self.frame_rate = love.timer.getFPS()
  love.graphics.present()
end