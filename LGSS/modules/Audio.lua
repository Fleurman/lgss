--[[

##TODO

-[ ] array of se & me for simulate se & me channels
-[ ] me_play()
-[ ] me_stop()
-[ ] se_stop()
-[ ] fade functions for bgm & bgs
-[ ] Apply change to source if play() same source with other params

-() pause methods ?
-() stereo methods ?

]]--
Audio = {}

Audio.bgm = {
  name = "",
  volume = 100,
  pitch = 100,
  source = nil,
  mute = false,
}
Audio.bgs = {
  name = "",
  volume = 100,
  pitch = 100,
  source = nil,
  mute = false,
}
Audio.se = { 
  bank = {},
  mute = false, }
Audio.me = { 
  bank = {},
  mute = false, }

function Audio:bgm_play(name,vol,pitch)
  if name then
    local dum = {}
    --dum.name = name
    local vol = vol and vol or 100
    local pitch = pitch and pitch or 100
    if self.bgm.name == name and self.bgm.volume == vol and self.bgm.pitch == pitch and
    self.bgm.source:isPlaying() then return end
    self.bgm.name,self.bgm.volume,self.bgm.pitch = name,vol,pitch
    
    local filename = LGSS:filename("Audio/BGM/" .. name)
    if not filename then return end
    if self.bgm.source then self.bgm.source:stop() end
    self.bgm.source = love.audio.newSource(filename,"stream")
    self.bgm.source:setLooping(true)
    self.bgm.source:setVolume(self.bgm.volume/100)
    self.bgm.source:setPitch(self.bgm.pitch/100)
    self.bgm.source:play()
    --love.audio.play(Audio.bgm.source)
  end
end

function Audio:bgm_playing()
  if not self.bgm.source then return false end
  return self.bgm.source:isPlaying()
end

function Audio:bgm_fade(time)
  if Audio:bgm_playing() then
    love.thread.newChannel()
    local thread = love.thread.newThread(
      [[
      local vol = Audio.bgm.source:getVolume()
      while vol > 0 do 
        Audio.bgm.source:setVolume(vol-0.1)
      end
      ]]
    )
    thread:start()
  end
end

function Audio:bgm_stop()
  if self.bgm.source then self.bgm.source:stop() end
end

function Audio:bgs_play(name,vol,pitch)
  if name then
    local dum = {}
    local vol = vol and vol or 100
    local pitch = pitch and pitch or 100
    if self.bgs.name == name and self.bgs.volume == vol and self.bgs.pitch == pitch and
    self.bgs.source:isPlaying() then return end
    self.bgs.name,self.bgs.volume,self.bgs.pitch = name,vol,pitch
    
    local filename = LGSS:filename("Audio/BGS/" .. name)
    if not filename then return end
    if self.bgs.source then self.bgs.source:stop() end
    self.bgs.source = love.audio.newSource(filename,"stream")
    self.bgs.source:setLooping(true)
    self.bgs.source:setVolume(self.bgs.volume/100)
    sef.bgs.source:setPitch(self.bgs.pitch/100)
    self.bgs.source:play()
    --love.audio.play(Audio.bgm.source)
  end
end

function Audio:bgs_stop()
  if self.bgs.source then self.bgs.source:stop() end
end

function Audio:se_play(name,vol,pitch)
  if name then
    local volume = vol and vol or 100
    local pitch = pitch and pitch or 100
    
    local filename = LGSS:filename("Audio/SE/" .. name)
    if not filename then return end
    local se = love.audio.newSource(filename,"static")
    se:setVolume(volume/100)
    se:setPitch(pitch/100)
    love.audio.play(se)
  end
end
  
function Audio:update(dt)
  
end