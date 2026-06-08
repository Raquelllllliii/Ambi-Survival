level1 = {}
level1.zeit = 25
level1.zeitTimer = 0

level1.spieler = {x = 80, y = 700, w = 30, h = 30, speed = 450, yv = 0, gravitation = 1400, sprung = -700, springt = false}
level1.ziel = {x = 1490, y = 640, w = 60, h = 60}
level1.item = {x = 350, y = 640, w = 24, h = 24, collected = false}

level1.plattformen = {
    {x = 0, y = 820, w = 1600, h = 80}, {x = 300, y = 700, w = 150, h = 20},
    {x = 550, y = 580, w = 150, h = 20}, {x = 800, y = 480, w = 150, h = 20},
    {x = 1100, y = 380, w = 150, h = 20}, {x = 1350, y = 550, w = 120, h = 20},
    {x = 1450, y = 700, w = 150, h = 20}
}

level1.gefahren = {
    {x = 400, y = 800, w = 150, h = 20}, {x = 850, y = 800, w = 250, h = 20},
    {x = 600, y = 560, w = 50, h = 20}, {x = 850, y = 460, w = 40, h = 20},
    {x = 1150, y = 360, w = 60, h = 20}, {x = 730, y = 640, w = 40, h = 40},
    {x = 1000, y = 500, w = 40, h = 40}, {x = 1300, y = 650, w = 30, h = 170}
}

-- Ganz einfache Sterne-Schleife ohne table.insert
level1.sterne = {}
for i = 1, 80 do
    level1.sterne[i] = {x = math.random(0, 1600), y = math.random(0, 900), speed = math.random(15, 50), size = math.random(1, 3)}
end

-- Simpler Kollisions-Check
function kollision(a, b)
    return a.x < b.x + b.w and a.x + a.w > b.x and a.y < b.y + b.h and a.y + a.h > b.y
end

function pixelstern(x, y, g, farbe)
    love.graphics.setColor(farbe)
    love.graphics.rectangle("fill", x, y - 2*g, g, g)
    love.graphics.rectangle("fill", x - 2*g, y - g, 5*g, g)
    love.graphics.rectangle("fill", x - g, y, 3*g, g)
    love.graphics.rectangle("fill", x - 2*g, y + g, g, g)
    love.graphics.rectangle("fill", x + 2*g, y + g, g, g)
end

function level1.load()
    level1.zeit = 25
    level1.zeitTimer = 0
    level1.spieler.x = 80
    level1.spieler.y = 700
    level1.spieler.yv = 0
    level1.spieler.springt = false
    level1.item.collected = false
    globalStars = 0
end

function level1.update(dt)
    level1.zeitTimer = level1.zeitTimer + dt
    if level1.zeitTimer >= 1 then
        level1.zeit = level1.zeit - 1
        level1.zeitTimer = 0
    end
    if level1.zeit <= 0 then Zustand = "gameover" end

    if love.keyboard.isDown("a") then level1.spieler.x = level1.spieler.x - level1.spieler.speed * dt end
    if love.keyboard.isDown("d") then level1.spieler.x = level1.spieler.x + level1.spieler.speed * dt end

    if level1.spieler.x < 0 then level1.spieler.x = 0 end
    if level1.spieler.x > 1600 - level1.spieler.w then level1.spieler.x = 1600 - level1.spieler.w end

    level1.spieler.yv = level1.spieler.yv + level1.spieler.gravitation * dt
    level1.spieler.y = level1.spieler.y + level1.spieler.yv * dt

    level1.spieler.springt = true

    -- Plattformen checken (normale Schleife)
    for i = 1, #level1.plattformen do
        local p = level1.plattformen[i]
        if kollision(level1.spieler, p) and level1.spieler.yv > 0 then
            level1.spieler.y = p.y - level1.spieler.h
            level1.spieler.yv = 0
            level1.spieler.springt = false
        end
    end

    -- Gefahren checken
    for i = 1, #level1.gefahren do
        if kollision(level1.spieler, level1.gefahren[i]) then Zustand = "gameover" end
    end

    -- Sterne bewegen
    for i = 1, #level1.sterne do
        level1.sterne[i].x = level1.sterne[i].x - level1.sterne[i].speed * dt
        if level1.sterne[i].x < 0 then level1.sterne[i].x = 1600 end
    end

    if not level1.item.collected and kollision(level1.spieler, level1.item) then
        level1.item.collected = true
        if globalStars < 3 then globalStars = globalStars + 1 end
    end

    if kollision(level1.spieler, level1.ziel) then
        Zustand = "level2"
        if level2 and type(level2.load) == "function" then level2.load() end
    end
end

function level1.draw()
    love.graphics.clear(0.03, 0.01, 0.08)

    love.graphics.setColor(0.6, 0.7, 1, 0.5)
    for i = 1, #level1.sterne do
        love.graphics.circle("fill", level1.sterne[i].x, level1.sterne[i].y, level1.sterne[i].size)
    end

    for i = 1, #level1.plattformen do
        local p = level1.plattformen[i]
        love.graphics.setColor(0.08, 0.08, 0.12)
        love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
        love.graphics.setLineWidth(3)
        love.graphics.setColor(1, 0, 0.5)
        love.graphics.rectangle("line", p.x, p.y, p.w, p.h)
    end

    love.graphics.setColor(1, 0, 0)
    for i = 1, #level1.gefahren do
        love.graphics.rectangle("fill", level1.gefahren[i].x, level1.gefahren[i].y, level1.gefahren[i].w, level1.gefahren[i].h)
    end

    if not level1.item.collected then pixelstern(level1.item.x + 12, level1.item.y + 12, 4, {1, 0.9, 0}) end

    love.graphics.setColor(0, 1, 0.6)
    love.graphics.rectangle("fill", level1.ziel.x, level1.ziel.y, level1.ziel.w, level1.ziel.h)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", level1.spieler.x, level1.spieler.y, level1.spieler.w, level1.spieler.h)

    love.graphics.setLineWidth(1)
    love.graphics.setColor(0, 1, 1)
    love.graphics.print("ZEIT: " .. level1.zeit, 15, 15, 0, 1.2, 1.2)

    if (globalStars or 0) >= 1 then pixelstern(1470, 30, 4, {1, 0.9, 0}) else pixelstern(1470, 30, 4, {0.3, 0.3, 0.3}) end
    if (globalStars or 0) >= 2 then pixelstern(1510, 30, 4, {1, 0.9, 0}) else pixelstern(1510, 30, 4, {0.3, 0.3, 0.3}) end
    if (globalStars or 0) >= 3 then pixelstern(1550, 30, 4, {1, 0.9, 0}) else pixelstern(1550, 30, 4, {0.3, 0.3, 0.3}) end
end

function level1.keypressed(key)
    if key == "w" and not level1.spieler.springt then
        level1.spieler.yv = level1.spieler.sprung
        level1.spieler.springt = true
    end
end

return level1