local menu = {}

local visualTime = 0
local menuStars = {}

-- Generiert Sterne exakt wie in Level 1 für einen nahtlosen Übergang
for i = 1, 80 do
    table.insert(menuStars, {
        x = math.random(0, 1600),
        y = math.random(0, 900),
        speed = math.random(15, 50),
        size = math.random(1, 3)
    })
end

function menu.update(dt)
    -- Aktualisiert die Zeit für die Puls-Effekte
    visualTime = visualTime + dt

    -- Lässt die Sterne im Hintergrund fliegen
    for _, star in ipairs(menuStars) do
        star.x = star.x - star.speed * dt
        if star.x < 0 then star.x = 1600 end
    end
end

function menu.draw()
    -- Gleicher tiefblauer/violetter Hintergrund wie im Spiel
    love.graphics.clear(0.03, 0.01, 0.08)

    -- 1. Sterne zeichnen
    love.graphics.setColor(0.6, 0.7, 1, 0.5)
    for _, star in ipairs(menuStars) do
        love.graphics.circle("fill", star.x, star.y, star.size)
    end

    -- 2. Pulsierender Spieltitel (Neon-Style)
    love.graphics.push()
    love.graphics.translate(800, 220) -- Zentriert auf dem Bildschirm
    love.graphics.scale(3 + math.sin(visualTime * 3) * 0.08) -- Sanftes Atmen des Titels

    -- Titel-Schatten / Glow (Pink)
    love.graphics.setColor(1, 0, 0.5, 0.4)
    love.graphics.printf("NEON RUNNER", -200, 2, 400, "center")

    -- Titel-Haupttext (Cyan)
    love.graphics.setColor(0, 1, 0.9)
    love.graphics.printf("NEON RUNNER", -200, 0, 400, "center")
    love.graphics.pop()

    -- 3. Interaktiver Start-Button
    local bx, by, bw, bh = 700, 425, 200, 50
    local mx, my = love.mouse.getPosition()

    -- Prüfen, ob die Maus über dem Button schwebt (Hover-Effekt)
    local isHovered = (mx > bx and mx < bx + bw and my > by and my < by + bh)
    local pulse = math.sin(visualTime * 10) * 0.15 + 0.85

    if isHovered then
        -- Hover-Zustand: Leuchtet giftgrün/cyan wie das Ziel
        love.graphics.setColor(0, 1, 0.6, 0.25 * pulse)
        love.graphics.rectangle("fill", bx - 8, by - 8, bw + 16, bh + 16) -- Äußerer Glow

        love.graphics.setLineWidth(4)
        love.graphics.setColor(0, 1, 0.6)
        love.graphics.rectangle("line", bx, by, bw, bh)

        love.graphics.setColor(1, 1, 1) -- Weißer Text bei Hover
    else
        -- Normaler Zustand: Leuchtet pink/magenta wie die Plattformen
        love.graphics.setColor(1, 0, 0.5, 0.15 * pulse)
        love.graphics.rectangle("fill", bx - 5, by - 5, bw + 10, bh + 10) -- Äußerer Glow

        love.graphics.setLineWidth(2)
        love.graphics.setColor(1, 0, 0.5)
        love.graphics.rectangle("line", bx, by, bw, bh)

        love.graphics.setColor(0, 0.9, 1) -- Cyan-farbener Text im Normalzustand
    end

    -- Text im Button sauber zentrieren und leicht vergrößern
    love.graphics.push()
    love.graphics.translate(800, 450)
    love.graphics.scale(1.2)
    love.graphics.printf("START GAME", -100, -7, 200, "center")
    love.graphics.pop()

    -- Reset der Farbe für nachfolgende Zeichenbefehle
    love.graphics.setColor(1, 1, 1)
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