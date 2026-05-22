local gameover = {}

local visualTime = 0

function gameover.update(dt)
    visualTime = visualTime + dt
end

function gameover.draw()
    -- Dunkler Hintergrund für den Game Over Screen
    love.graphics.clear(0.05, 0, 0)

    local flash = math.sin(visualTime * 10) * 0.3 + 0.7
    love.graphics.setColor(1, 0, 0.3, flash)

    -- Wenn wir Scale auf 2 setzen, müssen wir das Width-Limit auf 1600/2 = 800 setzen!
    love.graphics.printf("CRITICAL ERROR: GAME OVER", 0, 380, 800, "center", 0, 2, 2)

    love.graphics.setColor(1, 1, 1, 0.8)
    -- Hier setzen wir Limit auf 1600/1.2, da der Scale 1.2 ist
    love.graphics.printf("Drücke 'R' zum System-Reboot", 0, 480, 1600 / 1.2, "center", 0, 1.2, 1.2)
    love.graphics.printf("Drücke 'M' fürs Menü", 0, 520, 1600 / 1.2, "center", 0, 1.2, 1.2)
end

function gameover.keypressed(key)
    if key == "r" then
        Zustand = "level1"
        level1.load() -- Setzt das Level zurück
    elseif key == "m" then
        Zustand = "menu"
    end
end

return gameover