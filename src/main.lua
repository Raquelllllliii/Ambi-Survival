require("menu")
require("level1")

function love.load()
    Zustand = "menu"
    Zeit = 0
end

function love.update(dt)
    if Zustand == "level1" then level1.update(dt)
    end
end

function love.keypressed(key)
    level1.keypressed(key)
end

function love.draw()
    if Zustand == "menu" then menu.draw()
    end
    if Zustand == "level1" then level1.draw()
    end

end

function love.mousepressed(x, y, button)
    if Zustand == "menu" then menu.mousepressed(x, y, button) zeit = 0
    end

end