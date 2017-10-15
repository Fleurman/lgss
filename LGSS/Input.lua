--[[
#module Input

**TODO:**
-[ ] repeated?
-[ ] handle mutliple press

]]--
Input = {}

Input.keys = {}
Input._lkey = ""

function Input:trigger(key)
  if self.keys[key] then
    if self.keys[key].state == "trigger" then return true end
  end
  return false
end

function Input:release(key)
  if self.keys[key] then
    if self.keys[key].state == "release" then return true end
  end
  return false
end

function Input:press(key)
  if self.keys[key] then
    if self.keys[key].state == "press" or 
    self.keys[key].state == "repeat" or 
    self.keys[key].state == "trigger" then return true end
  end
  return false 
end

function Input:repeated(key)
  if self.keys.key then
    if self.keys.key.state == "repeat" then return true end
  end
  return false 
end

function love.keypressed( key, scancode, isrepeat )
  local k = {}
  if isrepeat then k.state = "repeat" else k.state = "trigger" end
  Input.keys[key] = k
end

function love.keyreleased( key, scancode )
  local k = {}
  k.state = "release"
  Input.keys[key] = k
end

function Input:update(dt)
  for i,v in pairs(self.keys) do
    if v.state == "trigger" then v.state = "press" end
    if v.state == "release" then v.state = "none" end
  end
end