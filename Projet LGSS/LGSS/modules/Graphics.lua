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
  self.width,self.height = love.graphics.getDimensions()
end
function Graphics:getWidth()
  return love.graphics.getWidth()
end

function Graphics:setHeight(v)
  local w,h,f = love.window.getMode()
  love.window.setMode(w,v,f)
  self.width,self.height = love.graphics.getDimensions()
end
function Graphics:getHeight()
  return love.graphics.getHeight()
end

function Graphics:setDimensions(w,h)
  local dw,dh,f = love.window.getMode()
  love.window.setMode(w,h,f)
  self.width,self.height = love.graphics.getDimensions()
end
function Graphics:getDimensions()
  return love.graphics.getDimensions() 
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

function Graphics:addSprite(spr)
  table.insert(self.sprites,spr)
  self:sortSprites()
end

function Graphics:removeSprite(spr)
  for k,v in ipairs(self.sprites) do
    if v == spr then table.remove(self.sprites,k) end
  end
end

function Graphics:sortSprites()
  local comp = function(s1,s2) if s1:realZ() < s2:realZ() then return true end return false end
  table.sort(self.sprites,comp)
end

function Graphics:draw()
  for k,v in ipairs(self.sprites) do
    v:draw()
  end
end

function Graphics:restart()
  love.graphics.clear()
  self.sprites = {}
  self.width,self.height = love.graphics.getDimensions()
  self.frame_count = 0
  self.frame_rate = 60
  self.freezed = false;
end

function Graphics:update(dt)
  self:draw()
  self.frame_count = self.frame_count + 1
  self.frame_rate = love.timer.getFPS()
  if not self.freezed then love.graphics.present() end
  if Input:trigger("f12") then love.restart() end
end

-- Shader by Helvecta (https://love2d.org/forums/viewtopic.php?f=4&t=3733&p=167865#p167865)
Graphics.shaderZoomBlur =love.graphics.newShader([[
  extern float strength;
  vec4 effect(vec4 color, Image tex, vec2 tC, vec2 pC){
  float[10] sample;
  for(int i = 0; i < 10; i++){ sample[i] = (i - 5) / strength; }
  vec2 dir = (.5 - tC) * -1;
  float dist = sqrt(dir.x * dir.x + dir.y * dir.y);
  dir = dir/dist;
  vec4 c = Texel(tex, tC);
  vec4 sum = color;
  for(int i = 0; i < 10; i++){ sum += Texel(tex, tC + dir * sample[i] * strength / 50); }
  sum /= 10;
  float t = dist * strength;
  t = clamp(t, 0, 1);
  return mix(c, sum, t); }
]])
  
-- Shader from vrld's Moonshine (https://github.com/vrld/moonshine/blob/master/boxblur.lua)
Graphics.shaderBoxBlur = love.graphics.newShader([[
  extern vec2 direction;
  extern number radius;
  vec4 effect(vec4 color, Image texture, vec2 tc, vec2 _) {
    vec4 c = vec4(0.0f);
    for (float i = -radius; i <= radius; i += 1.0f) { c += Texel(texture, tc + i * direction); }
    return c / (2.0f * radius + 1.0f) * color; 
  }
]])
  
-- Shader from vrld's Moonshine (https://github.com/vrld/moonshine/blob/master/pixelate.lua)
Graphics.shaderPixelBlur = love.graphics.newShader([[
extern vec2 size;
extern number feedback;
vec4 effect(vec4 color, Image tex, vec2 tc, vec2 _)
{
  vec4 c = Texel(tex, tc);
  // average pixel color over 5 samples
  vec2 scale = love_ScreenSize.xy / size;
  tc = floor(tc * scale + vec2(.5));
  vec4 meanc = Texel(tex, tc/scale);
  meanc += Texel(tex, (tc+vec2( 1.0,  .0))/scale);
  meanc += Texel(tex, (tc+vec2(-1.0,  .0))/scale);
  meanc += Texel(tex, (tc+vec2(  .0, 1.0))/scale);
  meanc += Texel(tex, (tc+vec2(  .0,-1.0))/scale);
  return color * mix(.2*meanc, c, feedback);
}
]])