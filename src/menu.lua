local menu = {}

function menu.update(dt)

end

function menu.draw()

    love.graphics.clear(0.03, 0.01, 0.08)

    love.graphics.setColor(1, 0, 0.5)
    love.graphics.printf("NEON RUNNER", -4, 202, 1600 / 3, "center", 0, 3, 3)


    love.graphics.setColor(0, 1, 0.9)
    love.graphics.printf("NEON RUNNER", 0, 200, 1600 / 3, "center", 0, 3, 3)


    local bx, by, bw, bh = 700, 425, 200, 50
    local mx, my = love.mouse.getPosition()


    if mx > bx and mx < bx + bw and my > by and my < by + bh then

        love.graphics.setLineWidth(4)
        love.graphics.setColor(0, 1, 0.6)
        love.graphics.rectangle("line", bx, by, bw, bh)
        love.graphics.setColor(1, 1, 1)
    else

        love.graphics.setLineWidth(2)
        love.graphics.setColor(1, 0, 0.5)
        love.graphics.rectangle("line", bx, by, bw, bh)
        love.graphics.setColor(0, 0.9, 1)
    end

    love.graphics.printf("START GAME", 0, 440, 1600 / 1.2, "center", 0, 1.2, 1.2)
end

function menu.mousepressed(x, y, button)
    if button == 1 then
        if x > 700 and x < 900 and y > 425 and y < 475 then
            Zustand = "level1"
            love.mouse.setPosition(50, 360)
        end
    end
end

return menu