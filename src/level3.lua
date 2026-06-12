level3 = {}

level3.spieler = {x = 80, y = 700, w = 30, h = 30, tempo = 450, yv = 0, gravitation = 1400, springt = false}
level3.ziel = {x = 1470, y = 210, w = 60, h = 60}
level3.item = {x = 1158, y = 740, w = 24, h = 24, collected = false}

level3.plattformen = {
    {x = 0, y = 750, w = 150, h = 20}, {x = 250, y = 650, w = 120, h = 20},
    {x = 550, y = 650, w = 100, h = 20}, {x = 800, y = 520, w = 100, h = 20},
    {x = 1150, y = 400, w = 100, h = 20}, {x = 1450, y = 300, w = 100, h = 20},
    {x = 1150, y = 780, w = 40, h = 20}, {x = 1260, y = 640, w = 40, h = 20},
    {x = 1360, y = 500, w = 40, h = 20}, {x = 1400, y = 380, w = 40, h = 20}
}

level3.gefahren = {
    -- Statisch (haben kein "speed")
    {x = 0, y = 850, w = 1600, h = 50},
    {x = 900, y = 400, w = 20, h = 120},
    {x = 1320, y = 280, w = 30, h = 120},

    -- Beweglich (haben "speed", "min", "max")
    {x = 430, y = 500, w = 40, h = 120, speed = 150, min = 380, max = 620},
    {x = 980, y = 320, w = 40, h = 140, speed = -200, min = 200, max = 430},
    {x = 1130, y = 580, w = 80, h = 20, speed = 250, min = 460, max = 700}
}

function level3.load()
    level3.spieler.x = 80
    level3.spieler.y = 700
    level3.spieler.yv = 0
    level3.spieler.springt = false
    level3.item.collected = false
end

function level3.update(dt)
    -- 1. Steuerung & Bildschirmränder
    if love.keyboard.isDown("a") then level3.spieler.x = level3.spieler.x - level3.spieler.tempo * dt end
    if love.keyboard.isDown("d") then level3.spieler.x = level3.spieler.x + level3.spieler.tempo * dt end
    if level3.spieler.x < 0 then level3.spieler.x = 0 end
    if level3.spieler.x > 1600 - level3.spieler.w then level3.spieler.x = 1600 - level3.spieler.w end

    -- 2. Schwerkraft
    level3.spieler.yv = level3.spieler.yv + level3.spieler.gravitation * dt
    level3.spieler.y = level3.spieler.y + level3.spieler.yv * dt
    level3.spieler.springt = true

    -- Game Over beim Runterfallen
    if level3.spieler.y > 950 then Zustand = "gameover" end

    -- 3. Kollision mit Plattformen
    for i = 1, #level3.plattformen do
        p = level3.plattformen[i]
        if kollision(level3.spieler, p) and level3.spieler.yv > 0 then
            level3.spieler.y = p.y - level3.spieler.h
            level3.spieler.yv = 0
            level3.spieler.springt = false
        end
    end

    -- 4. Kollision mit Gefahren (Laser) - INKLUSIVE BUGFIX
    for i = 1, #level3.gefahren do
        g = level3.gefahren[i]

        -- Wenn die Gefahr "speed" hat, dann bewege sie hoch und runter
        if g.speed then
            g.y = g.y + g.speed * dt

            -- Der Jitter-Bugfix: Nur umdrehen, wenn wir auch in die falsche Richtung fliegen!
            if g.y < g.min and g.speed < 0 then
                g.speed = g.speed * -1
            elseif g.y > g.max and g.speed > 0 then
                g.speed = g.speed * -1
            end
        end

        -- Game Over bei Berührung
        if kollision(level3.spieler, g) then Zustand = "gameover" end
    end

    -- 5. Item einsammeln
    if not level3.item.collected and kollision(level3.spieler, level3.item) then
        level3.item.collected = true
        if globalStars < 3 then globalStars = globalStars + 1 end
    end

    -- 6. Ziel berühren
    if kollision(level3.spieler, level3.ziel) then
        Zustand = "win"
        if type(win) == "table" and win.load then win.load() end
    end
end

function level3.draw()
    love.graphics.clear(0.03, 0.01, 0.08)

    -- Plattformen zeichnen
    for i = 1, #level3.plattformen do
        p = level3.plattformen[i]
        love.graphics.setColor(0.08, 0.08, 0.12)
        love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
        love.graphics.setLineWidth(3)
        love.graphics.setColor(1, 0, 0.5)
        love.graphics.rectangle("line", p.x, p.y, p.w, p.h)
    end

    -- Gefahren zeichnen (Neon-Rot-Pink)
    for i = 1, #level3.gefahren do
        g = level3.gefahren[i]
        love.graphics.setColor(1, 0.1, 0.3, 0.3) -- Glow außen
        love.graphics.rectangle("fill", g.x - 4, g.y - 4, g.w + 8, g.h + 8)
        love.graphics.setColor(1, 0.2, 0.5) -- Heller Kern
        love.graphics.rectangle("fill", g.x, g.y, g.w, g.h)
    end

    -- Item zeichnen (Farbe explizit auf Gelb gesetzt!)
    if not level3.item.collected then
        love.graphics.setColor(1, 0.9, 0)
        pixelstern(level3.item.x + 12, level3.item.y + 12, 4, {1, 0.9, 0})
    end

    -- Ziel zeichnen
    love.graphics.setColor(0, 1, 0.6)
    love.graphics.rectangle("fill", level3.ziel.x, level3.ziel.y, level3.ziel.w, level3.ziel.h)

    -- Spieler zeichnen
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", level3.spieler.x, level3.spieler.y, level3.spieler.w, level3.spieler.h)

    -- UI Sterne oben rechts
    local sterne_punkte = globalStars or 0

    if sterne_punkte >= 1 then love.graphics.setColor(1, 0.9, 0) else love.graphics.setColor(0.3, 0.3, 0.3) end
    pixelstern(1470, 30, 4, sterne_punkte >= 1 and {1, 0.9, 0} or {0.3, 0.3, 0.3})

    if sterne_punkte >= 2 then love.graphics.setColor(1, 0.9, 0) else love.graphics.setColor(0.3, 0.3, 0.3) end
    pixelstern(1510, 30, 4, sterne_punkte >= 2 and {1, 0.9, 0} or {0.3, 0.3, 0.3})

    if sterne_punkte >= 3 then love.graphics.setColor(1, 0.9, 0) else love.graphics.setColor(0.3, 0.3, 0.3) end
    pixelstern(1550, 30, 4, sterne_punkte >= 3 and {1, 0.9, 0} or {0.3, 0.3, 0.3})
end

function level3.keypressed(key)
    if key == "w" and not level3.spieler.springt then
        level3.spieler.yv = -700
        level3.spieler.springt = true
    end
end

return level3