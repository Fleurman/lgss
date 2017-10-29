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
  self.data = Table.new(width, height, 3)
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

--[[RPG.Cache = {}
RPG.Cache.cache = {}
RPG.Cache.load_bitmap(folder_name, filename, hue = 0)
      path = folder_name + filename
      if not @cache.include?(path) or @cache[path].disposed?
        if filename != ""
          @cache[path] = Bitmap.new(path)
        else
          @cache[path] = Bitmap.new(32, 32)
        end
      end
      if hue == 0
        @cache[path]
      else
        key = [path, hue]
        if not @cache.include?(key) or @cache[key].disposed?
          @cache[key] = @cache[path].clone
          @cache[key].hue_change(hue)
        end
        @cache[key]
      end
end

    def self.animation(filename, hue)
      self.load_bitmap("Graphics/Animations/", filename, hue)
    end
    
    def self.autotile(filename)
      self.load_bitmap("Graphics/Autotiles/", filename)
    end
    
    def self.battleback(filename)
      self.load_bitmap("Graphics/Battlebacks/", filename)
    end
    
    def self.battler(filename, hue)
      self.load_bitmap("Graphics/Battlers/", filename, hue)
    end
    
    def self.character(filename, hue)
      self.load_bitmap("Graphics/Characters/", filename, hue)
    end
    
    def self.fog(filename, hue)
      self.load_bitmap("Graphics/Fogs/", filename, hue)
    end
    
    def self.gameover(filename)
      self.load_bitmap("Graphics/Gameovers/", filename)
    end
    
    def self.icon(filename)
      self.load_bitmap("Graphics/Icons/", filename)
    end
    
    def self.panorama(filename, hue)
      self.load_bitmap("Graphics/Panoramas/", filename, hue)
    end
    
    def self.picture(filename)
      self.load_bitmap("Graphics/Pictures/", filename)
    end
    
    def self.tileset(filename)
      self.load_bitmap("Graphics/Tilesets/", filename)
    end
    
    def self.title(filename)
      self.load_bitmap("Graphics/Titles/", filename)
    end
    
    def self.windowskin(filename)
      self.load_bitmap("Graphics/Windowskins/", filename)
    end
    
    def self.tile(filename, tile_id, hue)
      key = [filename, tile_id, hue]
      if not @cache.include?(key) or @cache[key].disposed?
        @cache[key] = Bitmap.new(32, 32)
        x = (tile_id - 384) % 8 * 32
        y = (tile_id - 384) / 8 * 32
        rect = Rect.new(x, y, 32, 32)
        @cache[key].blt(0, 0, self.tileset(filename), rect)
        @cache[key].hue_change(hue)
      end
      @cache[key]
    end
    
    def self.clear
      @cache = {}
      GC.start
    end]]