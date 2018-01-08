--[[
**--------------------------------------------**
#LÖVE Game Scripting System - LGSS
**--------------------------------------------**

This tool is a copycat of the Ruby Game System Script (RGSS) for LÖVE.
Its main purpose is to run a game created in RPG Maker XP with LÖVE.
Its second purpose is to provide a great tool to easily create a game !
The ultimate goal of the project is an RPG Maker-like Editor.

]]--

LGSS = {}

LGSS.audioFormats = {".ogg",".mp3",".wav",}
LGSS.fontFormats = {".ttf",".otf",}
LGSS.imageFormats = {".png",".jpg",".gif",}

function LGSS:filename(path)
  for i,f in pairs(LGSS.audioFormats) do
    if path:find(f) then return path end
    local test = path .. f
    if love.filesystem.exists(test) then return test,f else end
  end
  for i,f in pairs(LGSS.fontFormats) do
    if path:find(f) then return path end
    local test = path .. f
    if love.filesystem.exists(test) then return test,f else end
  end
  for i,f in pairs(LGSS.imageFormats) do
    if path:find(f) then return path end
    local test = path .. f
    if love.filesystem.exists(test) then return test,f else end
  end
  return false 
end

function LGSS:update(dt)
  Graphics:update(dt)
  Audio:update(dt)
  Input:update(dt)
end

function LGSS:restart()
  Cache:clear()
  Graphics:restart()
end

class = require "LGSS/ext/p30Log"

--Modules
require "LGSS/modules/RPG"
require "LGSS/modules/Cache"
require "LGSS/modules/Graphics"
require "LGSS/modules/Audio"
require "LGSS/modules/Input"

--Classes
require "LGSS/classes/Table"
require "LGSS/classes/Font"
require "LGSS/classes/Tone"
require "LGSS/classes/Color"
require "LGSS/classes/Rect"
require "LGSS/classes/Viewport"
require "LGSS/classes/Sprite"
require "LGSS/classes/Plane"
require "LGSS/classes/Bitmap"
require "LGSS/classes/Window"
require "LGSS/classes/Tilemap"

require "LGSS/Test"