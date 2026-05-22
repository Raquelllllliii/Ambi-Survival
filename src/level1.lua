local level1 = {}
local timeLeft = 25
local visualTime = 0
-- Speichert die gesammelten Sterne (später evtl. als globale Variable für alle Level)
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

local platforms = {
    {x = 0, y = 820, w = 1600, h = 80},
    {x = 300, y = 700, w = 150, h = 20},
    {x = 550, y = 580, w = 150, h = 20},
    {x = 800, y = 480, w = 150, h = 20},
    {x = 1100, y = 380, w = 150, h = 20},
    {x = 1350, y = 550, w = 120, h = 20},
    {x = 1450, y = 700, w = 150, h = 20}
}

local obstacles = {
    {x = 400, y = 800, w = 150, h = 20},
    {x = 850, y = 800, w = 250, h = 20},
    {x = 600, y = 560, w = 50, h = 20},
    {x = 850, y = 460, w = 40, h = 20},
    {x = 1150, y = 360, w = 60, h = 20},
    {x = 730, y = 640, w = 40, h = 40},
    {x = 1000, y = 500, w = 40, h = 40},
    {x = 1300, y = 650, w = 30, h = 170}
}

local goal = {x = 1490, y = 640, w = 60, h = 60}

-- Das einsammelbare Item für dieses Level
local levelStar = {x = 350, y = 640, w = 24, h = 24, collected = false}

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

-- Hilfsfunktion: Zeichnet einen Stern im Blocky/Pixel-Art Stil
local function drawPixelStar(x, y, s, color)
    love.graphics.setColor(color)
    -- Spitze oben
    love.graphics.rectangle("fill", x, y - 2*s, s, s)
    -- Mittlere breite Linie
    love.graphics.rectangle("fill", x - 2*s, y - s, 5*s, s)
    -- Darunter etwas schmaler
    love.graphics.rectangle("fill", x - s, y, 3*s, s)
    -- Beinchen unten links und rechts
    love.graphics.rectangle("fill", x - 2*s, y + s, s, s)
    love.graphics.rectangle("fill", x + 2*s, y + s, s, s)
end

function level1.load()
    timeLeft = 25
    visualTime = 0
    player.x = 80
    player.y = 700
    player.y_velocity = 0
    player.is_jumping = false
    player.trail = {}

    levelStar.collected = false -- Stern beim Neustart wieder hinlegen
    starsCollected = 0          -- Setzt die gesammelten Sterne auf 0 zurück
end

function level1.update(dt)
    visualTime = visualTime + dt

    for _, star in ipairs(stars) do
        star.x = star.x - star.speed * dt
        if star.x < 0 then star.x = 1600 end
    end

    timeLeft = timeLeft - dt
    if timeLeft <= 0 then
        Zustand = "gameover" -- Wechselt ins Game Over Modul
    end

    if love.keyboard.isDown("a") then
        player.x = player.x - player.speed * dt
    end
    if love.keyboard.isDown("d") then
        player.x = player.x + player.speed * dt
    end

    if player.x < player.radius then player.x = player.radius end
    if player.x > 1600 - player.radius then player.x = 1600 - player.radius end

    player.y_velocity = player.y_velocity + player.gravity * dt
    player.y = player.y + player.y_velocity * dt

    table.insert(player.trail, 1, {x = player.x, y = player.y})
    if #player.trail > 15 then
        table.remove(player.trail)
    end

    player.is_jumping = true
    for _, p in ipairs(platforms) do
        if checkCollision(player, p) and player.y_velocity > 0 then
            player.y = p.y - player.radius
            player.y_velocity = 0
            player.is_jumping = false
        end
    end

    for _, obs in ipairs(obstacles) do
        if checkCollision(player, obs) then
            Zustand = "gameover" -- Wechselt ins Game Over Modul
        end
    end

    -- Stern Kollisionsabfrage
    if not levelStar.collected and checkCollision(player, levelStar) then
        levelStar.collected = true
        if starsCollected < maxStars then
            starsCollected = starsCollected + 1
        end
    end

    -- Ziel-Kollision (Portal)
    if checkCollision(player, goal) then
        Zustand = "level2" -- Wechselt in den Zustand für Level 2

        -- Falls du eine globale level2-Variable hast, laden wir das Level hier direkt neu:
        if level2 and type(level2.load) == "function" then
            level2.load()
        end
    end
end

function level1.draw()
    love.graphics.clear(0.03, 0.01, 0.08)

    -- Hintergrundsterne
    love.graphics.setColor(0.6, 0.7, 1, 0.6)
    for _, star in ipairs(stars) do
        love.graphics.circle("fill", star.x, star.y, star.size)
    end

    -- Platforms
    for _, p in ipairs(platforms) do
        love.graphics.setColor(0.08, 0.08, 0.12)
        love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
        love.graphics.setLineWidth(3)
        love.graphics.setColor(1, 0, 0.5)
        love.graphics.rectangle("line", p.x, p.y, p.w, p.h)
    end

    -- Hindernisse
    local pulse = math.sin(visualTime * 12) * 0.2 + 0.8
    for _, obs in ipairs(obstacles) do
        love.graphics.setColor(1, 0, 0, 0.2 * pulse)
        love.graphics.rectangle("fill", obs.x - 6, obs.y - 6, obs.w + 12, obs.h + 12)
        love.graphics.setColor(1, 0.2 * pulse, 0)
        love.graphics.rectangle("fill", obs.x, obs.y, obs.w, obs.h)
    end

    -- Level-Stern zeichnen, falls noch nicht gesammelt
    if not levelStar.collected then
        local alpha = math.sin(visualTime * 5) * 0.2 + 0.8 -- Leichtes pulsieren
        drawPixelStar(levelStar.x + levelStar.w/2, levelStar.y + levelStar.h/2, 4, {1, 0.9, 0, alpha})
    end

    -- Ziel
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

    -- Spieler Trail
    for i, point in ipairs(player.trail) do
        local alpha = (1 - (i / #player.trail)) * 0.5
        local r = math.sin(visualTime * 5 + i * 0.2) * 0.5 + 0.5
        local g = math.sin(visualTime * 5 + i * 0.2 + 2) * 0.5 + 0.5
        local b = math.sin(visualTime * 5 + i * 0.2 + 4) * 0.5 + 0.5
        love.graphics.setColor(r, g, b, alpha)
        love.graphics.circle("fill", point.x, point.y, player.radius * (1 - i/#player.trail * 0.5))
    end

    -- Spieler
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", player.x, player.y, player.radius)
    love.graphics.setColor(0, 0.9, 1, 0.5)
    love.graphics.circle("line", player.x, player.y, player.radius + 3)

    -- Timer UI
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0, 1, 1)
    love.graphics.print("SYSTEM TIME LEFT: " .. string.format("%.2f", math.max(0, timeLeft)), 15, 15, 0, 1.2, 1.2)

    -- UI Sterne Oben Rechts
    for i = 1, maxStars do
        local sx = 1550 - (maxStars - i) * 40 -- Abstand berechnen
        local sy = 30
        if i <= starsCollected then
            drawPixelStar(sx, sy, 3, {1, 0.9, 0, 1}) -- Gelb
        else
            drawPixelStar(sx, sy, 3, {0.3, 0.3, 0.3, 1}) -- Grau
        end
    end

    love.graphics.setColor(1, 1, 1)
end

function level1.keypressed(key)
    if key == "w" and not player.is_jumping then
        player.y_velocity = player.jump_power
        player.is_jumping = true
    end
end

return level1