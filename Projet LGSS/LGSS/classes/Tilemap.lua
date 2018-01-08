Tilemap = class("Tilemap")

Tilemap.windowRect = Rect(0,0,640,480)
Tilemap.bitmapRect = Rect(0,0,640, 480)
Tilemap.bitmapWindowOffset = (Tilemap.bitmapRect.height-Tilemap.windowRect.height)/2/32
Tilemap.autotileLength = 10
Tilemap.autotiles = {
    { {27, 28, 33, 34}, { 5, 28, 33, 34}, {27,  6, 33, 34}, { 5,  6, 33, 34},
      {27, 28, 33, 12}, { 5, 28, 33, 12}, {27,  6, 33, 12}, { 5,  6, 33, 12} },
    { {27, 28, 11, 34}, { 5, 28, 11, 34}, {27,  6, 11, 34}, { 5,  6, 11, 34},
      {27, 28, 11, 12}, { 5, 28, 11, 12}, {27,  6, 11, 12}, { 5,  6, 11, 12} },
    { {25, 26, 31, 32}, {25,  6, 31, 32}, {25, 26, 31, 12}, {25,  6, 31, 12},
      {15, 16, 21, 22}, {15, 16, 21, 12}, {15, 16, 11, 22}, {15, 16, 11, 12} },
    { {29, 30, 35, 36}, {29, 30, 11, 36}, { 5, 30, 35, 36}, { 5, 30, 11, 36},
      {39, 40, 45, 46}, { 5, 40, 45, 46}, {39,  6, 45, 46}, { 5,  6, 45, 46} },
    { {25, 30, 31, 36}, {15, 16, 45, 46}, {13, 14, 19, 20}, {13, 14, 19, 12},
      {17, 18, 23, 24}, {17, 18, 11, 24}, {41, 42, 47, 48}, { 5, 42, 47, 48} },
    { {37, 38, 43, 44}, {37,  6, 43, 44}, {13, 18, 19, 24}, {13, 14, 43, 44},
      {37, 42, 43, 48}, {17, 18, 47, 48}, {13, 18, 43, 48}, { 1,  2,  7,  8} }
  }

function Tilemap:init(viewport, rpgmap)
  
  self.autotiles    = {nil,nil,nil,nil,nil,nil}
  self.oldautotiles = {nil,nil,nil,nil,nil,nil}
  self.viewport   = viewport or Viewport(Tilemap.windowRect)
  self.region     = Rect(0,0,Tilemap.bitmapRect.width/32, Tilemap.bitmapRect.height/32)
  self.oldregion  = nil
  self.sprite     = nil
  --Set FlashingSprite and bitmap
--    if SingleFlashingSprite
--      @flashsprite = Sprite.new(@viewport)
--      @flashsprite.bitmap = Bitmap.new(BitmapRect.width, BitmapRect.height)
--    end

  self.priority_ids     = {}
  self.normal_tiles     = {}
  self.auto_tiles       = {}
  self.priority_sprites = {}
  self.autotile_sprites = {}
  self.flashing_sprites = {}
  
  self.disposed   = false
  self.visible    = true
  --self.flashing   = true
  self.can_draw   = true
  self.ox, self.oy = 0, 0
  self.z = 0
  
  if rpgmap then create_tilemap(rpgmap) end
  
  Graphics:addSprite(self)
end

function Tilemap:autotiles_changed()
  if self.oldautotiles == self.autotiles then return false else return true end
end

function Tilemap:setTileset(value)
  if self.tileset == value then return end
  if value.isclass(RPG.Tileset) then value = value.tileset_name end
  if type(value) == "string" then self.tileset = Cache:tileset(value) end
  if value.isClass(Bitmap) then self.tileset = value end
  if self.can_draw then self:redraw_tileset() end
end

function Tilemap:clear()
  self.sprite.bitmap:clear()
end

function Tilemap:drawww(map)
  local data = map.data.data
  self.tileset = Cache:tileset(map.tileset_id)
  for x=0,19 do
    for y=0,14 do
      for z=1,3 do
        self:drawTile(x,y,data["x" .. x .. "y" .. y][z])
      end
    end
  end
end


local function getQuad(id)
    local x = (id - 384) % 8 * 32
    local y = math.floor((id - 384) / 8) * 32
    return x,y
end

function Tilemap:drawm(map)
  local data = map.data
  self.tileset = Cache:tileset(map.tileset_id)
  local w,h = self.tileset():getDimensions()
  self.sprite = love.graphics.newSpriteBatch(self.tileset(),1000)
  
  for x=0,19 do
    for y=0,14 do
      for z=1,3 do
        local id = data[x+1][y+1][z]
        if id > 0 then
          local xx,yy = getQuad(id)
          --print(id,xx,yy,z,x*32,y*32)
          local q = love.graphics.newQuad(xx,yy,32, 32,w,h)
          self.sprite:add(q, x*32, y*32)
        end
      end
    end
  end
end

function Tilemap:drawTile(x,y,tile_id,tx,ty,tz,src_bit)
  if x<0 or y<0 or not tile_id then return end
  if tile_id<384 then return self:drawAutotile(x,y,tile_id,tx,ty,tz,src_bit) end
    self.sprite.bitmap:blt(x*32,y*32,Cache:tile("2",tile_id),Rect(0,0,32,32))
--  if not self.normal_tiles[tile_id] then
--    src_bit = Bitmap(32,32)
--    local rx = (tile_id-384)%8*32
--    local ry = math.floor((tile_id-384)/8)*32
--    local src_rect = Rect(rx,ry,32,32)
--    src_bit:blt(0,0,self.tileset,src_rect)
--    self.normal_tiles[tile_id] = src_bit
--  else
--    src_bit = self.normal_tiles[tile_id]
--  end
--  self.sprite.bitmap:blt(x*32,y*32,src_bit,Rect(0,0,32,32))
end

function Tilemap:drawRegion()
  self.sprite.bitmap:clear()
  for k,v in ipairs(self.priority_sprites) do v:dispose() end
  for k,v in ipairs(self.autotile_sprites) do v:dispose() end
  self.priority_sprites,self.autotile_sprites = {},{}
  local leftX, topY = self.ox/32,self.oy/32
  local offset = Tilemap.bitmapWindowOffset
  self.sprite.ox = offset*32
  self.sprite.oy = offset*32
  self.region.x,self.region.y = leftX,topY
  for x=0,self.region.width-1 do
    for y=0,self.region.height-1 do
      for z=0,2 do
        self:drawTile( x, y , 
                        self:tile_id(1+x + leftX - offset,1+y + topY - offset,z+1), 
                        x + leftX - offset , y + topY - offset, 
                        z)
      end
    end
  end
  self.oldregion = Rect(leftX,topY,self.region.width,self.region.height)
  --@sprite:update() ???
  --Graphics.frame_reset ???
end

function Tilemap:map_data(value)
  if self.map_data == value then return end
  self.map_data = value
  if self.can_draw then self:drawRegion() end --and self.priorities and self.tileset
end

function Tilemap:realZ()
  if self.viewport then return self.viewport.z + self.z end
  return self.z
end
  
-- DO MAP_DATA & OTHERS
function Tilemap:tile_id(x, y, z)
  print(x,y,z)
  return self.map_data.data.data["x" .. x .. "y" .. y][z+1]
end

function Tilemap:draw()
  if not self.sprite then return end
  if not self.visible then return end
  local v = self.viewport
  local col = Color(255,255,255,255)
  if v then
    love.graphics.translate(v.x,v.y)
    love.graphics.setScissor(v.x,v.y,v.width,v.height)
    col.alpha = col.alpha * (v.opacity/255)
  end
  local b = self.sprite
  --love.graphics.setBlendMode(self.blendType, "premultiplied")
  love.graphics.setColor(col())
  love.graphics.draw(b,self.x,self.y,self.angle,self.zoomX,self.zoomY,self.ox,self.oy)
  --love.graphics.setBlendMode("alpha")
  love.graphics.setScissor()
  love.graphics.setColor(255,255,255,255)
  love.graphics.origin()
end
