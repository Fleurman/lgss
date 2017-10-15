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
}
Audio.bgs = {
  name = "",
  volume = 100,
  pitch = 100,
  source = nil,
}
Audio.se = { mute = false, }
Audio.me = { mute = false, }

function Audio:bgm_play(name,vol,pitch)
  if name then
    local dum = {}
    --dum.name = name
    local vol = vol and vol or 100
    local pitch = pitch and pitch or 100
    if Audio.bgm.name == name and Audio.bgm.volume == vol and Audio.bgm.pitch == pitch and
    Audio.bgm.source:isPlaying() then return end
    Audio.bgm.name,Audio.bgm.volume,Audio.bgm.pitch = name,vol,pitch
    
    local filename = LGSS:filename("Audio/BGM/" .. name)
    if not filename then return end
    if Audio.bgm.source then Audio.bgm.source:stop() end
    Audio.bgm.source = love.audio.newSource(filename,"stream")
    Audio.bgm.source:setLooping(true)
    Audio.bgm.source:setVolume(Audio.bgm.volume/100)
    Audio.bgm.source:setPitch(Audio.bgm.pitch/100)
    Audio.bgm.source:play()
    --love.audio.play(Audio.bgm.source)
  end
end

function Audio:bgm_stop()
  if Audio.bgm.source then Audio.bgm.source:stop() end
end

function Audio:bgs_play(name,vol,pitch)
  if name then
    local dum = {}
    local vol = vol and vol or 100
    local pitch = pitch and pitch or 100
    if Audio.bgs.name == name and Audio.bgs.volume == vol and Audio.bgs.pitch == pitch and
    Audio.bgs.source:isPlaying() then return end
    Audio.bgs.name,Audio.bgs.volume,Audio.bgs.pitch = name,vol,pitch
    
    local filename = LGSS:filename("Audio/BGS/" .. name)
    if not filename then return end
    if Audio.bgs.source then Audio.bgs.source:stop() end
    Audio.bgs.source = love.audio.newSource(filename,"stream")
    Audio.bgs.source:setLooping(true)
    Audio.bgs.source:setVolume(Audio.bgs.volume/100)
    Audio.bgs.source:setPitch(Audio.bgs.pitch/100)
    Audio.bgs.source:play()
    --love.audio.play(Audio.bgm.source)
  end
end

function Audio:bgs_stop()
  if Audio.bgs.source then Audio.bgs.source:stop() end
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