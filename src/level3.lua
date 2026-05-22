local level3 = {}
local timeLeft = 35 -- Etwas mehr Zeit für die Timing-Sprünge
local visualTime = 0
local starsCollected = 0
local maxStars = 3
local player = {
    x = 80, y = 700, radius = 15, speed = 450,
    y_velocity = 0, gravity = 1400, jump_power = -700,
    is_jumping = false, trail = {}
}

local stars = {}
for i = 1, 100 do
    table.insert(stars, {
        x = math.random(0, 1600),
        y = math.random(0, 900),
        speed = math.random(10, 60),
        size = math.random(1, 3)
    })
end

-- Plattformen für Level 3
local platforms = {
    {x = 0, y = 750, w = 150, h = 20},     -- Start
    {x = 250, y = 650, w = 120, h = 20},
    {x = 550, y = 650, w = 100, h = 20},   -- Dazwischen ist das erste bewegliche Hindernis
    {x = 800, y = 520, w = 100, h = 20},   -- Leicht gesenkt für einen faireren Sprung
    {x = 1150, y = 400, w = 100, h = 20},  -- Dazwischen ist das zweite bewegliche Hindernis
    {x = 1450, y = 300, w = 100, h = 20}   -- Ziel-Plattform
}

-- Statische Hindernisse (Boden-Lava und korrigierte Barrieren)
local obstacles = {
    {x = 0, y = 850, w = 1600, h = 50, isSpike = true}, -- Lava am Boden
    {x = 900, y = 400, w = 20, h = 120},                -- Kleine Wand auf P4 (Höhe an neue P4-Höhe angepasst)
    {x = 1320, y = 280, w = 30, h = 120}                -- Blockade vorm Ziel (Nach unten verschoben, man kann jetzt drüberspringen)
}

-- NEU: Bewegliche Hindernisse (Stampfer / Laser) - Amplituden angepasst für faire Timing-Fenster
local movingObstacles = {
    -- baseY ist der Mittelpunkt der Bewegung, amplitude bestimmt wie weit es hoch/runter geht
    {x = 430, baseY = 500, y = 500, w = 40, h = 120, amplitude = 120, speed = 2.5, offset = 0},
    {x = 980, baseY = 320, y = 320, w = 40, h = 140, amplitude = 110, speed = 3.5, offset = math.pi}
}

-- Ziel-Portal (angepasst an die letzte Plattform)
local goal = {x = 1470, y = 210, w = 60, h = 60}

-- Der Stern liegt jetzt in der optimalen Sprung-Flugbahn zwischen P4 und P5
local levelStar = {x = 1020, y = 340, w = 24, h = 24, collected = false}

-- Kollisionsfunktion (funktioniert für statische und bewegliche Rechtecke)
local function checkCollision(circle, rect)
    local testX = circle.x
    local testY = circle.y

    if circle.x < rect.x then testX = rect.x
    elseif circle.x > rect.x + rect.w then testX = rect.x + rect.w end

    if circle.y < rect.y then testY = rect.y
    elseif circle.y > rect.y + rect.h then testY = rect.y + rect.h end

    local distX = circle.x - testX
    local distY = circle.y - testY
    local distance = math.sqrt((distX * distX) + (distY * distY))

    return distance <= circle.radius
end

local function drawPixelStar(x, y, s, color)
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", x, y - 2*s, s, s)
    love.graphics.rectangle("fill", x - 2*s, y - s, 5*s, s)
    love.graphics.rectangle("fill", x - s, y, 3*s, s)
    love.graphics.rectangle("fill", x - 2*s, y + s, s, s)
    love.graphics.rectangle("fill", x + 2*s, y + s, s, s)
end

function level3.load()
    timeLeft = 35
    visualTime = 0
    player.x = 80
    player.y = 700
    player.y_velocity = 0
    player.is_jumping = false
    player.trail = {}

    levelStar.collected = false
    starsCollected = 0
end

function level3.update(dt)
    visualTime = visualTime + dt

    -- Hintergrund-Sterne bewegen
    for _, star in ipairs(stars) do
        star.x = star.x - star.speed * dt
        if star.x < 0 then star.x = 1600 end
    end

    -- Timer
    timeLeft = timeLeft - dt
    if timeLeft <= 0 then
        Zustand = "gameover"
    end

    -- Spielerbewegung
    if love.keyboard.isDown("a") then
        player.x = player.x - player.speed * dt
    end
    if love.keyboard.isDown("d") then
        player.x = player.x + player.speed * dt
    end

    -- Bildschirmränder begrenzen
    if player.x < player.radius then player.x = player.radius end
    if player.x > 1600 - player.radius then player.x = 1600 - player.radius end

    -- Schwerkraft
    player.y_velocity = player.y_velocity + player.gravity * dt
    player.y = player.y + player.y_velocity * dt

    -- Todeszone (Fallen)
    if player.y > 950 then
        Zustand = "gameover"
    end

    -- Trail-Effekt
    table.insert(player.trail, 1, {x = player.x, y = player.y})
    if #player.trail > 15 then
        table.remove(player.trail)
    end

    -- Kollision Plattformen
    player.is_jumping = true
    for _, p in ipairs(platforms) do
        if checkCollision(player, p) and player.y_velocity > 0 then
            player.y = p.y - player.radius
            player.y_velocity = 0
            player.is_jumping = false
        end
    end

    -- Kollision statische Hindernisse
    for _, obs in ipairs(obstacles) do
        if checkCollision(player, obs) then
            Zustand = "gameover"
        end
    end

    -- Update & Kollision bewegliche Hindernisse
    for _, mob in ipairs(movingObstacles) do
        -- Sinuswelle berechnet die aktuelle Y-Position
        mob.y = mob.baseY + math.sin(visualTime * mob.speed + mob.offset) * mob.amplitude

        if checkCollision(player, mob) then
            Zustand = "gameover"
        end
    end

    -- Stern einsammeln
    if not levelStar.collected and checkCollision(player, levelStar) then
        levelStar.collected = true
        if starsCollected < maxStars then
            starsCollected = starsCollected + 1
        end
    end

    -- Ziel erreicht -> Aufruf des "win" Moduls
    if checkCollision(player, goal) then
        Zustand = "win"

        if win and type(win.load) == "function" then
            win.load()
        end
    end
end

function level3.draw()
    love.graphics.clear(0.03, 0.01, 0.08)

    -- Sterne im Hintergrund
    love.graphics.setColor(0.6, 0.7, 1, 0.6)
    for _, star in ipairs(stars) do
        love.graphics.circle("fill", star.x, star.y, star.size)
    end

    -- Plattformen zeichnen
    for _, p in ipairs(platforms) do
        love.graphics.setColor(0.08, 0.08, 0.12)
        love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
        love.graphics.setLineWidth(3)
        love.graphics.setColor(1, 0, 0.5)
        love.graphics.rectangle("line", p.x, p.y, p.w, p.h)
    end

    -- Statische Hindernisse zeichnen
    local pulse = math.sin(visualTime * 12) * 0.2 + 0.8
    for _, obs in ipairs(obstacles) do
        if obs.isSpike then
            love.graphics.setColor(1, 0, 0, 0.8 * pulse)
            local spikeWidth = 20
            for i = 0, obs.w / spikeWidth - 1 do
                local px = obs.x + i * spikeWidth
                love.graphics.polygon("fill", px, obs.y + obs.h, px + (spikeWidth/2), obs.y, px + spikeWidth, obs.y + obs.h)
            end
            love.graphics.setColor(1, 0.2 * pulse, 0, 0.5)
            love.graphics.rectangle("fill", obs.x, obs.y + 10, obs.w, obs.h - 10)
        else
            love.graphics.setColor(1, 0, 0, 0.2 * pulse)
            love.graphics.rectangle("fill", obs.x - 6, obs.y - 6, obs.w + 12, obs.h + 12)
            love.graphics.setColor(1, 0.2 * pulse, 0)
            love.graphics.rectangle("fill", obs.x, obs.y, obs.w, obs.h)
        end
    end

    -- Bewegliche Hindernisse zeichnen (mit violettem Leuchten)
    for _, mob in ipairs(movingObstacles) do
        local mobPulse = math.sin(visualTime * 15) * 0.2 + 0.8
        love.graphics.setColor(0.7, 0, 1, 0.3 * mobPulse) -- Leuchten
        love.graphics.rectangle("fill", mob.x - 6, mob.y - 6, mob.w + 12, mob.h + 12)
        love.graphics.setColor(0.8, 0.2, 1) -- Solider Kern
        love.graphics.rectangle("fill", mob.x, mob.y, mob.w, mob.h)
    end

    -- Stern im Level
    if not levelStar.collected then
        local alpha = math.sin(visualTime * 5) * 0.2 + 0.8
        drawPixelStar(levelStar.x + levelStar.w/2, levelStar.y + levelStar.h/2, 4, {1, 0.9, 0, alpha})
    end

    -- Ziel-Portal Animation
    love.graphics.push()
    love.graphics.translate(goal.x + goal.w/2, goal.y + goal.h/2)
    for i = 1, 4 do
        love.graphics.rotate(visualTime * 1.5 + i)
        local scale = math.sin(visualTime * 3 + i) * 0.1 + 0.9
        love.graphics.setColor(0, 1, 0.6, 0.3)
        love.graphics.rectangle("line", -goal.w/2 * scale, -goal.h/2 * scale, goal.w * scale, goal.h * scale)
        love.graphics.setColor(0, 0.8, 1, 0.1)
        love.graphics.rectangle("fill", -goal.w/4 * scale, -goal.h/4 * scale, goal.w/2 * scale, goal.h/2 * scale)
    end
    love.graphics.pop()

    -- Spieler-Trail
    for i, point in ipairs(player.trail) do
        local alpha = (1 - (i / #player.trail)) * 0.5
        local r = math.sin(visualTime * 5 + i * 0.2) * 0.5 + 0.5
        local g = math.sin(visualTime * 5 + i * 0.2 + 2) * 0.5 + 0.5
        local b = math.sin(visualTime * 5 + i * 0.2 + 4) * 0.5 + 0.5
        love.graphics.setColor(r, g, b, alpha)
        love.graphics.circle("fill", point.x, point.y, player.radius * (1 - i/#player.trail * 0.5))
    end

    -- Spieler zeichnen
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", player.x, player.y, player.radius)
    love.graphics.setColor(0, 0.9, 1, 0.5)
    love.graphics.circle("line", player.x, player.y, player.radius + 3)

    -- UI: Zeit
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0, 1, 1)
    love.graphics.print("SYSTEM TIME LEFT: " .. string.format("%.2f", math.max(0, timeLeft)), 15, 15, 0, 1.2, 1.2)

    -- UI: Gesammelte Sterne
    for i = 1, maxStars do
        local sx = 1550 - (maxStars - i) * 40
        local sy = 30
        if i <= starsCollected then
            drawPixelStar(sx, sy, 3, {1, 0.9, 0, 1})
        else
            drawPixelStar(sx, sy, 3, {0.3, 0.3, 0.3, 1})
        end
    end

    love.graphics.setColor(1, 1, 1)
end

function level3.keypressed(key)
    if key == "w" and not player.is_jumping then
        player.y_velocity = player.jump_power
        player.is_jumping = true
    end
end

return level3