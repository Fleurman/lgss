utf8 = require "utf8"

require "run"
require "LGSS/Lgss"

require "Scene_Test"

function love.load()
  scene = Scene_Test()
end

  font = love.graphics.newImageFont( 'Font/font.png', ' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' )
  
function love.update(dt)
  LGSS:update(dt)
  if scene then scene:update(dt) else love.event.quit() end
  love.graphics.setFont(font)
  love.graphics.print('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',16,16)
  love.graphics.print('Text is now drawn using the font',16,32)
end

function love.quit()
  
end

function love.restart()
  LGSS:restart()
  love.load()
end

function table.print(t)
  local printer = ""
  for i,v in pairs(t) do
    pv = ""
    if type(v) == "table" then
      for ni,nv in pairs(v) do pv = pv .. ni .. " - " .. nv end
    else pv = v end
    printer = printer .. "key: " .. i .. " / value: " .. pv .. "\n"
  end
  print(printer)
end