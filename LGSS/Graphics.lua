--[[
module Graphics

TODO:

-[ ] adjust position when setDimension()

]]--
Graphics = {}

Graphics.width,Graphics.height = love.graphics.getDimensions()
Graphics.frame_count = 0
Graphics.frame_rate = 60

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

function Graphics:update(dt)
  self.frame_count = self.frame_count + 1
  self.frame_rate = love.timer.getFPS()
end