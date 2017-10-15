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
    if love.filesystem.exists(test) then return test else end
  end
  for i,f in pairs(LGSS.fontFormats) do
    if path:find(f) then return path end
    local test = path .. f
    if love.filesystem.exists(test) then return test else end
  end
  return false 
end

function LGSS:update(dt)
  Graphics:update(dt)
  Audio:update(dt)
  Input:update(dt)
end

--Modules
require "LGSS/Cache"
require "LGSS/Graphics"
require "LGSS/Audio"
require "LGSS/Input"

--Classes
require "LGSS/Rect"
require "LGSS/Font"
require "LGSS/Tone"
require "LGSS/Color"
require "LGSS/Viewport"

require "LGSS/Test"