Scene_Test = class(Scene_Test)

function Scene_Test:init()

  self.win = Window()
  self.win.z = 5
  self.win.width,self.win.height = 300,128
  self.win.pause = true
  self.win.active = true
  self.win.x = 200
  self.win.windowskin = Cache:windowskin("window")
  self.win.sprites.contents.bitmap.font.name = "LoveFont"
  --self.win.sprites.contents.bitmap.font.size = 16
  self.win.sprites.contents.bitmap.font.color = Color("white")
  self.win:drawText("Hello World\nHow are you\nI am quite fine THX")
  
--  self.weather = {}
--  for i=1,3 do
--    self.weather[i] = RPG.Weather()
--    self.weather[i]:setMax(50)
--    self.weather[i]:setType(i)
--  end
  
--  self.tile = Sprite()
--  self.tile.bitmap = Cache:tile("DEBUG",384+24)

  self.tilemap = Tilemap()
  map = require "map"
  map2 = require "map2"
  self.tilemap:drawm(map)
  --self.tilemap:map_data(map)
  
end

function Scene_Test:update(dt)
  --for i=1,3 do self.weather[i]:update() end
  
  self.win:update(dt)
  
  if Input:trigger("c") then self.win.pause = not self.win.pause end
  
  if Input:press("lctrl") then
    if Input:press("right") then self.win.contentsOpacity = self.win.contentsOpacity+5 end
    if Input:press("down") then self.win.backOpacity = self.win.backOpacity-5 end
    if Input:press("left") then self.win.contentsOpacity = self.win.contentsOpacity-5 end
    if Input:press("up") then self.win.backOpacity = self.win.backOpacity+5 end
  elseif Input:press("rctrl") then
    if Input:press("right") then self.win.opacity = self.win.opacity+5 end
    if Input:press("down") then self.win.backOpacity = self.win.backOpacity-5 end
    if Input:press("left") then self.win.opacity = self.win.opacity-5 end
    if Input:press("up") then self.win.backOpacity = self.win.backOpacity+5 end
  else
    if Input:press("right") then self.win.x = self.win.x + 5 end
    if Input:press("down") then self.win.y = self.win.y + 5 end
    if Input:press("left") then self.win.x = self.win.x - 5 end
    if Input:press("up") then self.win.y = self.win.y - 5 end
  end
  
  if Input:press("m") then self.tilemap:drawm(map2) end
  if Input:press("n") then self.tilemap:drawm(map) end
  
  if Input:press("b") then self.win.cursorRect = Rect(16,16,240,48) end
  if Input:press("v") then self.win:emptyCursorRect() end
  
  if Input:press("r") then self.win.width,self.win.height = self.win.width+5,self.win.height+5 end
  if Input:trigger("f") then Graphics.freezed = not Graphics.freezed and true or false end
  
  if Input:mousetrigger(1) then print(Input:mousetrigger(1)) end
  
end