RPG = {}

RPG.Map = class("Map")
function RPG.Map:init(width, height)
  self.tileset_id = 1
  self.width = width
  self.height = height
  self.autoplay_bgm = false
  self.bgm = RPG.AudioFile()
  self.autoplay_bgs = false
  self.bgs = RPG.AudioFile("", 80)
  --self.encounter_list = []
  --self.encounter_step = 30
  self.data = Table(width, height, 3)
  self.events = {}
end

RPG.MapInfo = class("MapInfo")
function RPG.MapInfo:init()
  self.name = ""
  self.parent_id = 0
  self.order = 0
  self.expanded = false
  self.scroll_x = 0
  self.scroll_y = 0
end

RPG.Event = class("Event")
function RPG.Event:init(x, y)
  self.id = 0
  self.name = ""
  self.x = x
  self.y = y
  self.pages = {RPG.Event.Page()}
end

RPG.Event.Page = RPG.Event:extend("Page")
function RPG.Event.Page:init()
  self.condition = RPG.Event.Page.Condition()
  self.graphic = RPG.Event.Page.Graphic()
  self.move_type = 0
  self.move_speed = 3
  self.move_frequency = 3
  self.move_route = RPG.MoveRoute()
  self.walk_anime = true
  self.step_anime = false
  self.direction_fix = false
  self.through = false
  self.always_on_top = false
  self.trigger = 0
  self.list = {RPG.EventCommand()}
end

RPG.Event.Page.Condition = RPG.Event.Page:extend("Condition")
function RPG.Event.Page.Condition:init()
  self.switch1_valid = false
  self.switch2_valid = false
  self.variable_valid = false
  self.self_switch_valid = false
  self.switch1_id = 1
  self.switch2_id = 1
  self.variable_id = 1
  self.variable_value = 0
  self.self_switch_ch = "A"
end

RPG.Event.Page.Graphic = RPG.Event.Page:extend("Graphic")
function RPG.Event.Page.Graphic:init()
  self.tile_id = 0
  self.character_name = ""
  self.character_hue = 0
  self.direction = 2
  self.pattern = 0
  self.opacity = 255
  self.blend_type = 0
end

RPG.EventCommand = class("EventCommand")
function RPG.EventCommand:init(code, indent, parameters)
  self.code = code and code or 0
  self.indent = indent and indent or 0
  self.parameters = parameters and parameters or {}
end

RPG.MoveRoute = class("MoveRoute")
function RPG.MoveRoute:init()
  self.dorepeat = true
  self.skippable = false
  self.list = {RPG.MoveCommand()}
end

RPG.MoveCommand = class("MoveCommand")
function RPG.MoveCommand:init(code, parameters)
  self.code = code and code or 0
  self.parameters = parameters and parameters or 0
end

RPG.Item = class("Item")
function RPG.Item:init()
  self.id = 0
  self.name = ""
  self.icon_name = ""
  self.description = ""
  self.menu_se = RPG.AudioFile("", 80)
  self.common_event_id = 0
  self.price = 0
  self.consumable = true
  self.equippable = false
  self.element_set = {}
end

RPG.Animation = class("Animation")
function RPG.Animation:init()
  self.id = 0
  self.name = ""
  self.animation_name = ""
  self.animation_hue = 0
  self.position = 1
  self.frame_max = 1
  self.frames = {RPG.Animation.Frame()}
  self.timings = {}
end

RPG.Animation.Frame = RPG.Animation:extend("Frame")
function RPG.Animation.Frame:init()
  self.cell_max = 0
  self.cell_data = Table(0, 0)
end

RPG.Animation.Timing = RPG.Animation:extend("Timing")
function RPG.Animation.Timing:init()
  self.frame = 0
  self.se = RPG.AudioFile("", 80)
  self.flash_scope = 0
  self.flash_color = Color("white")
  self.flash_duration = 5
  self.condition = 0
end

RPG.Tileset = class("Tileset")
function RPG.Tileset:init()
  self.id = 0
  self.name = ""
  self.tileset_name = ""
  self.autotile_names = {"","","","","","",""}
  self.panorama_name = ""
  self.panorama_hue = 0
  self.fog_name = ""
  self.fog_hue = 0
  self.fog_opacity = 64
  self.fog_blend_type = 0
  self.fog_zoom = 200
  self.fog_sx = 0
  self.fog_sy = 0
  self.battleback_name = ""
  self.passages = Table(384)
  self.priorities = Table(384)
  self.priorities[0] = 5
  self.terrain_tags = Table(384)
end

RPG.CommonEvent = class("CommonEvent")
function RPG.CommonEvent:init()
  self.id = 0
  self.name = ""
  self.trigger = 0
  self.switch_id = 1
  self.list = {RPG.EventCommand()}
end

RPG.AudioFile = class("AudioFile")
function RPG.AudioFile:init(name,volume,pitch)
  self.name = name and name or ""
  self.volume = volume and volume or 100
  self.pitch = pitch and pitch or 100
end

RPG.System = class("System")
function RPG.System:init()
  self.magic_number = 0
  --self.party_members = [1]
  self.elements = {nil, ""}
  self.switches = {nil, ""}
  self.variables = {nil, ""}
  self.windowskin_name = ""
  self.title_name = ""
  self.gameover_name = ""
  --self.battle_transition = ""
  self.title_bgm = RPG.AudioFile()
  --self.battle_bgm = RPG.AudioFile()
  --self.battle_end_me = RPG.AudioFile()
  self.gameover_me = RPG.AudioFile()
  self.cursor_se = RPG.AudioFile("", 80)
  self.decision_se = RPG.AudioFile("", 80)
  self.cancel_se = RPG.AudioFile("", 80)
  self.buzzer_se = RPG.AudioFile("", 80)
  self.equip_se = RPG.AudioFile("", 80)
  --self.shop_se = RPG.AudioFile("", 80)
  self.save_se = RPG.AudioFile("", 80)
  self.load_se = RPG.AudioFile("", 80)
  --self.battle_start_se = RPG.AudioFile("", 80)
  --self.escape_se = RPG.AudioFile("", 80)
  --self.actor_collapse_se = RPG.AudioFile("", 80)
  --self.enemy_collapse_se = RPG.AudioFile("", 80)
  self.words = RPG.System.Words()
  --self.test_battlers = []
  --self.test_troop_id = 1
  self.start_map_id = 1
  self.start_x = 0
  self.start_y = 0
  --self.battleback_name = ""
  --self.battler_name = ""
  --self.battler_hue = 0
  self.edit_map_id = 1
end

RPG.System.Words = RPG.System:extend("Words")
function RPG.System.Words:init()
--  self.gold = ""
--  self.hp = ""
--  self.sp = ""
--  self.str = ""
--  self.dex = ""
--  self.agi = ""
--  self.int = ""
--  self.atk = ""
--  self.pdef = ""
--  self.mdef = ""
--  self.weapon = ""
--  self.armor1 = ""
--  self.armor2 = ""
--  self.armor3 = ""
--  self.armor4 = ""
--  self.attack = ""
--  self.skill = ""
--  self.guard = ""
--  self.item = ""
--  self.equip = ""
end

RPG.Weather = class("Weather")
function RPG.Weather:init(viewport)
  self.type = 0
  self.max = 0
  self.ox = 0
  self.oy = 0
  local color1 = Color(255, 255, 255, 255)
  local color2 = Color(255, 255, 255, 128)
  self.rain_bitmap = Bitmap(7, 56)
  for i=0,6 do self.rain_bitmap:fill_rect(6-i, i*8, 1, 8, color1) end
  self.storm_bitmap = Bitmap(34, 64)
  for i=0,31 do
    self.storm_bitmap:fill_rect(33-i, i*2, 1, 2, color2)
    self.storm_bitmap:fill_rect(32-i, i*2, 1, 2, color1)
    self.storm_bitmap:fill_rect(31-i, i*2, 1, 2, color2)
  end
  self.snow_bitmap = Bitmap(6, 6)
  self.snow_bitmap:fill_rect(0, 1, 6, 4, color2)
  self.snow_bitmap:fill_rect(1, 0, 4, 6, color2)
  self.snow_bitmap:fill_rect(1, 2, 4, 2, color1)
  self.snow_bitmap:fill_rect(2, 1, 2, 4, color1)
  self.sprites = {}
  for i=1,40 do
    local sprite = Sprite(viewport)
    sprite.z = 1000
    sprite.visible = false
    sprite.opacity = 0
    table.insert(self.sprites,sprite)
  end
end
function RPG.Weather:dispose()
  for k,v in ipairs(self.sprites) do
    v:dispose()
  end
  self.rain_bitmap:dispose()
  self.storm_bitmap:dispose()
  self.snow_bitmap:dispose()
end
function RPG.Weather:setType(v)
  if self.type == v then return end
  self.type = v
  local bitmap = Bitmap(1,1)
  if v == 1 then
    bitmap = self.rain_bitmap
  elseif v== 2 then
    bitmap = self.storm_bitmap
  elseif v == 3 then
    bitmap = self.snow_bitmap
  else
    bitmap = nil
  end
  for i=1,40 do
    sprite = self.sprites[i]
    if sprite then
      local b = (i <= self.max) and true or false
      sprite.visible = b
      sprite.bitmap = bitmap
    end
  end
end

--function RPG.Weather:set_ox(ox)
--  return if @ox == ox;
--  @ox = ox
--  for sprite in @sprites
--    sprite.ox = @ox
--  end
--end
--function RPG.Weather:set_oy(oy)
--  return if @oy == oy;
--  @oy = oy
--  for sprite in @sprites
--    sprite.oy = @oy
--  end
--end
function RPG.Weather:setMax(max)
  if self.max == max then return end
  self.max = math.min(40,math.max(0,max))
  for i=1,40 do
    local sprite = self.sprites[i]
    if sprite then
      local b = (i <= self.max) and true or false
      sprite.visible = b
    end
  end
end
function RPG.Weather:update()
  if self.type == 0 then return end
  for i=1,self.max do
    local sprite = self.sprites[i]
    if not sprite then
      break
    end
    if self.type == 1 then
      sprite.x = sprite.x - 2
      sprite.y = sprite.y + 16
      sprite.opacity = sprite.opacity - 8
    end
    if self.type == 2 then
      sprite.x = sprite.x - 8
      sprite.y = sprite.y + 16
      sprite.opacity = sprite.opacity - 12
    end
    if self.type == 3 then
      sprite.x = sprite.x - 2
      sprite.y = sprite.y + 8
      sprite.opacity = sprite.opacity - 8
    end
    local x = sprite.x - self.ox
    local y = sprite.y - self.oy
    if sprite.opacity < 64 or x < -50 or x > 750 or y < -300 or y > 500 then
      sprite.x = math.random(800) - 50 + self.ox
      sprite.y = math.random(800) - 200 + self.oy
      sprite.opacity = 255
    end
  end
    end