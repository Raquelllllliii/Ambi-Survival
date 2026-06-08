local gameover = {}

local visualTime = 0
local ashParticles = {}
local introAnimation = 0

-- Hilfsfunktion für cleane UI-Ecken (Brackets)
local function drawUIBrackets(x, y, w, h, len)
    love.graphics.setLineWidth(2)
    -- Oben Links
    love.graphics.line(x, y, x + len, y)
    love.graphics.line(x, y, x, y + len)
    -- Oben Rechts
    love.graphics.line(x + w, y, x + w - len, y)
    love.graphics.line(x + w, y, x + w, y + len)
    -- Unten Links
    love.graphics.line(x, y + h, x + len, y + h)
    love.graphics.line(x, y + h, x, y + h - len)
    -- Unten Rechts
    love.graphics.line(x + w, y + h, x + w - len, y + h)
    love.graphics.line(x + w, y + h, x + w, y + h - len)
end

function gameover.load()
    visualTime = 0
    introAnimation = 0
    ashParticles = {}

    -- Feine, minimalistische Asche/Staub-Partikel für cinematische Tiefe
    for i = 1, 40 do
        table.insert(ashParticles, {
            x = math.random(0, 1600),
            y = math.random(900, 1200), -- Starten weiter unten
            size = math.random(2, 4),
            speed = math.random(15, 45),
            sway = math.random(0, 100),
            alpha = math.random(0.2, 0.6)
        })
    end
end

function gameover.update(dt)
    visualTime = visualTime + dt

    -- Smooth einfahrende Animation am Anfang (0 bis 1)
    if introAnimation < 1 then
        introAnimation = math.min(1, introAnimation + dt * 1.5)
    end

    -- Langsame, edle Partikelbewegung nach oben
    for _, p in ipairs(ashParticles) do
        p.y = p.y - p.speed * dt
        p.x = p.x + math.sin(visualTime * 0.5 + p.sway) * 10 * dt

        -- Oben raus? Unten neu spawnen
        if p.y < -20 then
            p.y = 920
            p.x = math.random(0, 1600)
        end
    end
end

function gameover.draw()
    -- Edel-Abgrund: Extrem dunkles, mattes Anthrazit (Kein pures Schwarz)
    love.graphics.clear(0.02, 0.02, 0.03)

    -- 1. Subtiles Vektor-Raster im Hintergrund (Sehr dezent)
    love.graphics.setColor(1, 1, 1, 0.015)
    love.graphics.setLineWidth(1)
    local gridSize = 80
    for x = 0, 1600, gridSize do love.graphics.line(x, 0, x, 900) end
    for y = 0, 900, gridSize do love.graphics.line(0, y, 1600, y) end

    -- 2. Cinematische Kino-Balken (Letterbox) fahren von oben/unten rein
    local boxHeight = 100 * introAnimation
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, 1600, boxHeight)
    love.graphics.rectangle("fill", 0, 900 - boxHeight, 1600, boxHeight)

    -- 3. Schwebende Asche-Partikel zeichnen
    for _, p in ipairs(ashParticles) do
        love.graphics.setColor(1, 1, 1, p.alpha)
        -- Als leicht gedrehte Quadrate für einen edleren Look
        love.graphics.push()
        love.graphics.translate(p.x, p.y)
        love.graphics.rotate(visualTime * 0.2)
        love.graphics.rectangle("fill", -p.size/2, -p.size/2, p.size, p.size)
        love.graphics.pop()
    end

    -- --- UI CENTER BLOCK ---
    -- Alles skaliert smooth rein basierend auf introAnimation
    local uiAlpha = introAnimation

    -- Elegantes, großes Rahmen-Konstrukt in der Mitte
    love.graphics.setColor(1, 0.15, 0.2, uiAlpha * 0.2)
    drawUIBrackets(400, 280, 800, 340, 30)

    -- Eine extrem dünne, scharf abgeschnittene Linie hinter dem Text
    love.graphics.setColor(1, 1, 1, uiAlpha * 0.1)
    love.graphics.line(450, 410, 1150, 410)

    -- 4. Haupt-Text: Deep Crimson Red, komplett ohne Shaking, einfach nur clean
    love.graphics.setColor(0.9, 0.05, 0.1, uiAlpha)
    love.graphics.printf("STATUS: GAME OVER", 0, 340, 800, "center", 0, 2, 2)

    -- Ein ganz kleiner, feiner Subtext (wie bei Militär-Interfaces)
    love.graphics.setColor(1, 1, 1, uiAlpha * 0.4)
    love.graphics.printf("SESSION ID // " .. string.format("%06d", visualTime * 100), 0, 430, 1600 / 0.8, "center", 0, 0.8, 0.8)

    -- 5. Interaktions-Buttons (Clean untereinander angeordnet)
    -- "Reboot" leuchtet in einem satten Weiß, das sanft atmet
    local pulse = math.sin(visualTime * 2.5) * 0.15 + 0.85
    love.graphics.setColor(1, 1, 1, uiAlpha * pulse)
    love.graphics.printf("[ R ]   Restart", 0, 500, 1600 / 1.1, "center", 0, 1.1, 1.1)

    local pulse = math.sin(visualTime * 2.5) * 0.15 + 0.85
    love.graphics.setColor(1, 1, 1, uiAlpha * pulse)
    love.graphics.printf("[ M ] Back to menu", 0, 540, 1600 / 1.0, "center", 0, 1.0, 1.0)
end

function gameover.keypressed(key)
    if key == "r" then
        Zustand = "level1"
        if level1 and type(level1.load) == "function" then
            level1.load()
        end
    elseif key == "m" then
        Zustand = "menu"
    end
end

return gameover