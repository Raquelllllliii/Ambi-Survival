local win = {}

local visualTime = 0

function win.update(dt)
    visualTime = visualTime + dt
end

function win.draw()
    -- Dunkler Hintergrund für den Win Screen
    love.graphics.clear(0, 0.05, 0.05)

    local rainbowR = math.sin(visualTime * 5) * 0.5 + 0.5
    local rainbowG = math.sin(visualTime * 5 + 2) * 0.5 + 0.5
    love.graphics.setColor(rainbowR, rainbowG, 1)

    -- Zentriert mit angepasstem Limit für Skalierung 2
    love.graphics.printf("ACCESS GRANTED: GEWONNEN!", 0, 380, 800, "center", 0, 2, 2)

    love.graphics.setColor(1, 1, 1, 0.8)
    -- Zentriert mit angepasstem Limit für Skalierung 1.2
    love.graphics.printf("Drücke 'R' für eine weitere Simulation", 0, 480, 1600 / 1.2, "center", 0, 1.2, 1.2)
    love.graphics.printf("Drücke 'M' fürs Menü", 0, 520, 1600 / 1.2, "center", 0, 1.2, 1.2)
end

function win.keypressed(key)
    if key == "r" then
        Zustand = "level1"
        level1.load() -- Setzt das Level zurück
    elseif key == "m" then
        Zustand = "menu"
    end
end

return win