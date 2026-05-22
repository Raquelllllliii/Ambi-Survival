local level2 = {}
local timeLeft = 30 -- Etwas mehr Zeit, da das Level schwerer und länger ist
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

-- Angepasste Plattformen für flüssigere, machbare Sprünge
local platforms = {
    {x = 0, y = 750, w = 150, h = 20},     -- Start-Plattform
    {x = 280, y = 650, w = 100, h = 20},
    {x = 520, y = 550, w = 80, h = 20},
    {x = 750, y = 600, w = 80, h = 20},    -- Moderaterer Sprung nach unten/vorne
    {x = 1000, y = 500, w = 100, h = 20},
    {x = 1250, y = 400, w = 80, h = 20},
    {x = 1450, y = 280, w = 100, h = 20}   -- Ziel-Plattform (etwas tiefer gesetzt)
}

-- Angepasste Hindernisse (Höhen auf max. 120px Sprunghöhe reduziert)
local obstacles = {
    {x = 0, y = 850, w = 1600, h = 50, isSpike = true}, -- Lava/Spikes am Boden
    {x = 400, y = 530, w = 30, h = 300},                -- Wand zw. P2 und P3 (y = 530 statt 450)
    {x = 550, y = 530, w = 20, h = 20},                 -- Kleines Hindernis auf Plattform 3
    {x = 870, y = 480, w = 40, h = 300},                -- Lange Barriere (y = 480 statt 350)
    {x = 1130, y = 480, w = 30, h = 20},                -- Fliegendes Hindernis vor P6
    {x = 1350, y = 280, w = 30, h = 150}                -- Blockade vorm Ziel (y = 280 statt 200)
}

-- Ziel-Portal passend zur neuen Ziel-Plattform (y = 280) nach unten korrigiert
local goal = {x = 1470, y = 190, w = 60, h = 60}

-- Der Stern liegt auf der angepassten P4
local levelStar = {x = 780, y = 550, w = 24, h = 24, collected = false}

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

function level2.load()
    timeLeft = 30
    visualTime = 0
    player.x = 80
    player.y = 700
    player.y_velocity = 0
    player.is_jumping = false
    player.trail = {}

    levelStar.collected = false
    starsCollected = 0
end

function level2.update(dt)
    visualTime = visualTime + dt

    for _, star in ipairs(stars) do
        star.x = star.x - star.speed * dt
        if star.x < 0 then star.x = 1600 end
    end

    timeLeft = timeLeft - dt
    if timeLeft <= 0 then
        Zustand = "gameover"
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

    if player.y > 950 then
        Zustand = "gameover"
    end

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
            Zustand = "gameover"
        end
    end

    if not levelStar.collected and checkCollision(player, levelStar) then
        levelStar.collected = true
        if starsCollected < maxStars then
            starsCollected = starsCollected + 1
        end
    end

    if checkCollision(player, goal) then
        Zustand = "level3"

        if level3 and type(level3.load) == "function" then
            level3.load()
        end
    end
end

function level2.draw()
    love.graphics.clear(0.03, 0.01, 0.08)

    love.graphics.setColor(0.6, 0.7, 1, 0.6)
    for _, star in ipairs(stars) do
        love.graphics.circle("fill", star.x, star.y, star.size)
    end

    for _, p in ipairs(platforms) do
        love.graphics.setColor(0.08, 0.08, 0.12)
        love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
        love.graphics.setLineWidth(3)
        love.graphics.setColor(1, 0, 0.5)
        love.graphics.rectangle("line", p.x, p.y, p.w, p.h)
    end

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

    if not levelStar.collected then
        local alpha = math.sin(visualTime * 5) * 0.2 + 0.8
        drawPixelStar(levelStar.x + levelStar.w/2, levelStar.y + levelStar.h/2, 4, {1, 0.9, 0, alpha})
    end

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

    for i, point in ipairs(player.trail) do
        local alpha = (1 - (i / #player.trail)) * 0.5
        local r = math.sin(visualTime * 5 + i * 0.2) * 0.5 + 0.5
        local g = math.sin(visualTime * 5 + i * 0.2 + 2) * 0.5 + 0.5
        local b = math.sin(visualTime * 5 + i * 0.2 + 4) * 0.5 + 0.5
        love.graphics.setColor(r, g, b, alpha)
        love.graphics.circle("fill", point.x, point.y, player.radius * (1 - i/#player.trail * 0.5))
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", player.x, player.y, player.radius)
    love.graphics.setColor(0, 0.9, 1, 0.5)
    love.graphics.circle("line", player.x, player.y, player.radius + 3)

    love.graphics.setLineWidth(1)
    love.graphics.setColor(0, 1, 1)
    love.graphics.print("SYSTEM TIME LEFT: " .. string.format("%.2f", math.max(0, timeLeft)), 15, 15, 0, 1.2, 1.2)

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

function level2.keypressed(key)
    if key == "w" and not player.is_jumping then
        player.y_velocity = player.jump_power
        player.is_jumping = true
    end
end

return level2