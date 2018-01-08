--[[
#module Input

**TODO:**
-[ ] repeated?
-[ ] multikeys
-[/] mouse inputs
-[ ] multitouch

]]--
Input = {}

Input.keys = {}
Input.mouse = {}
Input.mouseX = 0
Input.mouseY = 0
Input.mouseDx = 0
Input.mouseDy = 0

function Input:trigger(key)
  if self.keys[key] then if self.keys[key].state == "trigger" then return true end end
  return false
end

function Input:release(key)
  if self.keys[key] then if self.keys[key].state == "release" then return true end end
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

function Input:dir4()
    if self:press("down") then return 2 end
    if self:press("left")  then return 4 end
    if self:press("right") then return 6 end
    if self:press("up") then return 8 end
    return 0
end
  
function Input:dir8()
    if self:press("down") and self:press("left") then return 1 end
    if self:press("down") and self:press("right") then return 3 end
    if self:press("up") and self:press("left") then return 7 end
    if self:press("up") and self:press("right") then return 9 end
    return dir4
end

function Input:mousetrigger(button)
  local but = self.mouse[tostring(button)]
  if but then if but.state == "trigger" then return true,but.hit[1],but.hit[2] end end
  return false
end

function Input:mousedown(button)
  if self.mouse[tostring(button)] then
    if self.mouse[tostring(button)].state == "press" or 
    self.mouse[tostring(button)].state == "repeat" or 
    self.mouse[tostring(button)].state == "trigger" then return true,Input.mouseX,Input.mouseY end
  end
  return false 
end

function Input:mouseup(button)
  local but = self.mouse[tostring(button)]
  if but then if but.state == "release" then return true,but.hit[1],but.hit[2] end end
  return false
end

function love.keypressed( key, scancode, isrepeat )
  local k = {}
  k.state = "pretrigger"
  Input.keys[key] = k
end

function love.keyreleased( key, scancode )
  local k = {}
  k.state = "prerelease"
  Input.keys[key] = k
end

function love.mousepressed( x, y, button, isTouch )
  local k = {}
  k.state = "pretrigger"
  k.hit = {x,y}
  k.touch = isTouch
  Input.mouse[tostring(button)] = k
end

function love.mousereleased( x, y, button, isTouch )
  local k = {}
  k.state = "prerelease"
  k.hit = {x,y}
  k.touch = isTouch
  Input.mouse[tostring(button)] = k
end

function love.mousemoved( x, y, dx, dy, isTouch )
  Input.mouseX = x
  Input.mouseY = y
  Input.mouseDx = dx
  Input.mouseDy = dy
end

function Input:update(dt)
  for i,v in pairs(self.keys) do
    if v.state == "release" then v.state = "none" end
    if v.state == "trigger" then v.state = "press" end
    if v.state == "prerelease" then v.state = "release" end
    if v.state == "pretrigger" then v.state = "trigger" end
  end
  for i,v in pairs(self.mouse) do
    if v.state == "release" then v.state = "none" end
    if v.state == "trigger" then v.state = "press" end
    if v.state == "prerelease" then v.state = "release" end
    if v.state == "pretrigger" then v.state = "trigger" end
  end
end