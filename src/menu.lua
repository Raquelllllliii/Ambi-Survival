menu = {}

function menu.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 540, 335, 200, 50)
    love.graphics.printf("Start Game", 540, 353, 200, "center")
end

function menu.mousepressed(x, y, button)
    if button == 1 then
        if x > 540 and x < 740 and y > 335 and y < 385 then
            Zustand = "level1"
            love.mouse.setPosition(50, 360)
        end
    end
end
