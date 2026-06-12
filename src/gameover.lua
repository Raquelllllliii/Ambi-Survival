 gameover = {}

function gameover.draw()
    love.graphics.clear(0.03, 0.03, 0.06)
    love.graphics.setColor(1, 0.1, 0.3)
    love.graphics.printf("GAME OVER", 0, 300, 800, "center", 0, 2, 2)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 500, 450, 600, 140)
    love.graphics.setColor(1, 0.1, 0.3)
    love.graphics.rectangle("fill", 500, 450, 600, 4)
    love.graphics.printf("SYSTEM STATUS: FAILED", 0, 470, 1600, "center")

    love.graphics.printf("> [ R ]  REBOOT SYSTEM", 0, 510, 1600, "center")
    love.graphics.printf("> [ M ]  ABORT MISSION", 0, 540, 1600, "center")
end

function gameover.keypressed(key)
    if key == "r" then
        Zustand = "level1"
        if level1  then
            level1.load()
        end
    elseif key == "m" then
        Zustand = "menu"
    end
end

return gameover