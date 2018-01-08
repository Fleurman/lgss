--[[
#class Window

|Needed methods:|
-[X] contents
-[X] contents opacity
-[X] back opacity
-[ ] opacity
-[ ] cursor_rect
-[ ] pause_position
-[ ] self.viewport = Viewport

**TODO:**
-[X] Alpha blend issue
-[X] border tilling issue
-[X] resize methods
-[X] size limit to 1x1
-[X] avoid recreating Bitmaps (:clear() in method refresh)

-[X] dimensions limited to screen

]]--

Window = class("Window")

function Window:init(viewport)
  self._windowskin = nil
  self._cursorRect = nil
  
  getmetatable(self).__newindex = function(s,k,v)
    if k == "windowskin" then
      s:setWindowskin(v)
    elseif k == "pause" then
      s:setPause(v)
    elseif k == "x" or k=="y" or k=="width" or k=="height" then
      s:setViewportValue(k,v)
    elseif k == "cursorRect" then
      s:setCursorRect(v)
    elseif k == "contentsOpacity" then
      v = math.min(255,math.max(0,v))
      s.sprites.contents.opacity = v
    elseif k == "backOpacity" then
      v = math.min(255,math.max(0,v))
      s.sprites.back.opacity = v
    elseif k == "opacity" then
      v = math.min(255,math.max(0,v))
      s.viewport.opacity = v
    else
      rawset(s,k,v)
    end
  end

  getmetatable(self).__index = function(s,k)
    if k == "windowskin" or k == "pause" then
      local name = "_" .. k
      return rawget(s,name)
    elseif k == "x" or k == "y" or k == "width" or k == "height" then
      return s:getViewportValue(k)
    elseif k == "cursorRect" then
      return rawget(s,"_" .. k)
    elseif k == "contentsOpacity" then
      return s.sprites.contents.opacity
    elseif k == "backOpacity" then
      return s.sprites.back.opacity
    elseif k == "opacity" then
      return s.viewport.opacity
    end
    return s.class[k]
  end
  self.viewport = viewport or Viewport(0,0,Graphics.width,Graphics.height)
  self.z, self.ox, self.oy = 0, 0, 0
  self.x,self.y,self.width,self.height = 0,0,0,0
  self.stretch = true
  self.active = false
  self.visible = true
  self._pause = false
  self._pausePosition = "bottom center"
  self._pause_frame = 0
  self._pause_timer = 0
  self._cursorFade = false
  self.contentsViewport = nil
  self.viewports = {
    
    }
  self.sprites = {
    back = Sprite(self.viewport),
    border = Sprite(self.viewport),
    arrow_left = Sprite(self.viewport),
    arrow_up = Sprite(self.viewport),
    arrow_right = Sprite(self.viewport),
    arrow_down = Sprite(self.viewport),
    pause = Sprite(self.viewport),
    cursor = Sprite(self.viewport),
    contents = Sprite(self.contentsViewport)
  }
  for k,v in pairs(self.sprites) do
    Graphics:removeSprite(v)
  end
  Graphics:addSprite(self)
end

function Window:setViewportValue(k,v)
  if k == "width" or k == "height" then v = math.min(Graphics[k],math.max(1,v)) end
  if self.viewport then
    if self.viewport[k] == v then return end
    self.viewport[k] = v
  else
    self.viewport = Viewport(0,0,Graphics.width,Graphics.height)
    self.viewport[k] = v
  end
  if self.contentsViewport then
    self.contentsViewport[k] = (k == "width" or k == "height") and v-48 or v+24
  else
    self.contentsViewport = Viewport(24,24,Graphics.width,Graphics.height)
    self.contentsViewport[k] = (k == "width" or k == "height") and v-48 or v+24
  end
  if not self._windowskin then return end
  if k == "width" or k == "height" then self:refresh() end
  --print(self.viewport.x,k,v)
end
function Window:getViewportValue(k)
  if self.viewport then
    return self.viewport[k]
  else
    self.viewport = Viewport(0,0,Graphics.width,Graphics.height)
    self.contentsViewport = Viewport(24,24,Graphics.width,Graphics.height)
    return self.viewport[k]
  end
end
function Window:setContentOpacity(v)
  self.sprites.contents.opacity = v
end

function Window:realZ()
  if self.viewport then return self.viewport.z + self.z end
  return self.z
end

function Window:dispose()
  self.disposed = true
  Graphics:removeSprite(self)
end

function Window:disposed()
  return self.disposed
end
  
function Window:setWindowskin(bit)
  self._windowskin = bit
  if self._windowskin():getWidth() == 192 then self._oldSkin = true else self._oldSkin = false end
  local bitm = nil
  if not self.stretch then
    self.sprites.back = Plane(self.viewport)
    Graphics:removeSprite(self.sprites.back)
    bitm = Bitmap(128, 128)
  else
    bitm = Bitmap(Graphics.width,Graphics.height)
  end
  self.sprites.back.bitmap = bitm
  if bit then
    if self.stretch then
      bitm:stretch_blt(Rect(0, 0, self.width, self.height), bit, Rect(0, 0, 128, 128))
    else
      bitm:blt(0, 0, bit, Rect(0, 0, 128, 128))
    end
    --setup_arrows
    self:setupContents()
    self:setupPause()
    self:setupBorder()
    --setup_cursor
  end
end

function Window:refresh()
    if self._windowskin then
      self.sprites.back.bitmap:clear()
      if self.stretch then
        self.sprites.back.bitmap:stretch_blt(Rect(0, 0, self.width, self.height), self._windowskin, Rect(0, 0, 128, 128))
      else
        self.sprites.back.bitmap:blt(0, 0, self._windowskin, Rect(0, 0, 128, 128))
      end
      --setup_arrows
      self:refreshPause()
      self:refreshBorder()
      self:refreshContents()
      --setup_cursor
  end
end

function Window:setRect(x,y,w,h)
  if type(x) == "table" then x,y,w,h = x.x,x.y,x.width,x.height end
  self.x,self.y = x,y
  --if w ~= self.width or h ~= self.height then
    self:refresh()
  --end
end

function Window:setupContents()
  local w,h = self.width,self.height
  self.sprites.contents.bitmap = Bitmap(Graphics.width,Graphics.height)
  self:refreshContents()
end
function Window:refreshContents()
  --self.contentsViewport = Viewport(self.x + 24,self.y + 24,self.viewport.width-48,self.viewport.height-48)
  self.sprites.contents.viewport = self.contentsViewport
end

function Window:drawText(text,align)
  local w,h = self.contentsViewport.width,self.contentsViewport.height
  self.sprites.contents.bitmap:draw_text(0,0,w,h,text,4)
end

function Window:setupBorder()
  local w,h = self.width,self.height
  self.sprites.border.bitmap = Bitmap(Graphics.width,Graphics.height)
  self:refreshBorder()
end
function Window:refreshBorder()
  self.sprites.border.bitmap:clear()
  local w,h = self.width,self.height
  local bw = self._oldSkin and 64 or 96
  self.sprites.border.bitmap:blt(0,0,self._windowskin,Rect(128,0,16,16))
  self.sprites.border.bitmap:blt(0,h-16,self._windowskin,Rect(128,bw-16,16,16))
  self.sprites.border.bitmap:blt(w-16,0,self._windowskin,Rect(128+bw-16,0,16,16))
  self.sprites.border.bitmap:blt(w-16,h-16,self._windowskin,Rect(128+bw-16,bw-16,16,16))
  
  self.sprites.border.bitmap:pattern_blt(Rect(0,16,16,h-32),self._windowskin,Rect(128,16,16,bw-32))
  self.sprites.border.bitmap:pattern_blt(Rect(w-16,16,16,h-32),self._windowskin,Rect(128+bw-16,16,16,bw-32))
  self.sprites.border.bitmap:pattern_blt(Rect(16,0,w-32,16),self._windowskin,Rect(128+16,0,bw-32,16))
  self.sprites.border.bitmap:pattern_blt(Rect(16,h-16,w-32,16),self._windowskin,Rect(128+16,bw-16,bw-32,16))
end

function Window:setPause(v)
  self._pause = v
  self.sprites.pause.visible = v
  if not v then self._pause_timer,self._pause_frame = 0,0 end
end

function Window:setupPause()
  if self._oldSkin then
    self.sprites.pause.bitmap = Bitmap(16,16)
  else
    self.otherPause = Bitmap(self._windowskin.name .. "_pause")
    self.sprites.pause.bitmap = Bitmap(self.otherPause.height)
  end
  self:refreshPause()
end
function Window:refreshPause()
  self.sprites.pause.bitmap:clear()
  local w,h = self.width,self.height
  if self._oldSkin then
    self.sprites.pause.x,self.sprites.pause.y = (w/2)-8,h-16
    self.sprites.pause.bitmap:blt(0,0,self._windowskin,Rect(160,64,16,16))
  else
    local s = self.otherPause.height
    self.sprites.pause.x,self.sprites.pause.y = (w/2)-(s*0.5),h-s
    self.sprites.pause.bitmap:blt(0,0,self.otherPause,Rect(0,0,s,s))
  end
end

function Window:updatePause()
  self._pause_timer = self._pause_timer - 1
  if self._pause_timer > 0 then return end
  self._pause_frame = self._pause_frame < 3 and self._pause_frame + 1 or 0
  --if self._pause_frame < 3 then self._pause_frame = self._pause_frame + 1 else self._pause_frame = 0 end
  local col, row = 0,0
  if self._pause_frame%2 == 1 then col = 1 end
  if self._pause_frame > 1 then row = 1 end
  self.sprites.pause.bitmap:clear()
  if self._oldSkin then
    self.sprites.pause.bitmap:blt(0,0,self._windowskin,Rect(160+(row*16),64+(row*16),16,16))
  else
    local s = self.otherPause.height
    self.sprites.pause.bitmap:blt(0,0,self.otherPause,Rect(self._pause_frame*s,0,s,s))
  end
  self._pause_timer = 8
end

function Window:setCursorRect(rect)
  if rect.width < 1 then rect.width = 1 end
  if rect.height < 1 then rect.height = 1 end
  self._cursorRect = rect
  self.sprites.cursor.opacity = 205
  self.sprites._cursorFade = false
  self:setupCursor()
end
function Window:emptyCursorRect(rect)
  self._cursorRect = nil
  self.sprites.cursor.bitmap:clear()
end
function Window:setupCursor()
  self.sprites.cursor.x,self.sprites.cursor.y = self._cursorRect.x,self._cursorRect.y
  self.sprites.cursor.bitmap = Bitmap(self._cursorRect.width,self._cursorRect.height)
  local rect = self._oldSkin and Rect(128,64,34,48) or Rect(128,96,96,32)
  self.sprites.cursor.bitmap:clear()
  self.sprites.cursor.bitmap:stretch_blt(self._cursorRect,self._windowskin,rect)
  --self:refreshCursor()
end
--function Window:refreshCursor()
--  self.sprites.cursor.bitmap:clear()
--  local w,h = self.width,self.height
--  self.sprites.pause.x,self.sprites.pause.y = (w/2)-8,h-16
--  self.sprites.pause.bitmap:blt(0,0,self._windowskin,Rect(160,64,16,16))
--end
function Window:updateCursor()
  if not self._cursorRect then return end
  if self._cursorFade then
    self.sprites.cursor.opacity = self.sprites.cursor.opacity+5
    if self.sprites.cursor.opacity >= 205 then self._cursorFade = false end
  else
    self.sprites.cursor.opacity = self.sprites.cursor.opacity-5
    if self.sprites.cursor.opacity <= 60 then self._cursorFade = true end
  end
end

function Window:draw() 
  self.sprites.back:draw()
  self.sprites.cursor:draw()
  self.sprites.contents:draw()
  self.sprites.border:draw()
  self.sprites.pause:draw()
end

function Window:update(dt)
  if self.pause then self:updatePause() end
  if self.active then self:updateCursor() end
  
end