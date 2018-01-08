function love.conf(t)
  
    setup = {}
    for s in love.filesystem.lines("setup.ini") do
      local key,value = s:match("(%w+)=(.*)")
      setup[key] = value
    end
    
    t.window.title = setup and setup.title or "Game"
    t.window.icon = setup and setup.icon or nil
    t.window.width = setup and tonumber(setup.width) or 640
    t.window.height = setup and tonumber(setup.height) or 480
    
end