level2 = {}

level2.spieler = {x = 80, y = 700, w = 30, h = 30, speed = 450, yv = 0, gravitation = 1400, sprung = -700, springt = false}
level2.ziel = {x = 1470, y = 190, w = 60, h = 60}
level2.item = {x = 878, y = 790, w = 24, h = 24, collected = false}

level2.plattformen = {
    {x = 0, y = 750, w = 150, h = 20}, {x = 280, y = 650, w = 100, h = 20},
    {x = 520, y = 550, w = 80, h = 20}, {x = 750, y = 600, w = 80, h = 20},
    {x = 1000, y = 500, w = 100, h = 20}, {x = 1250, y = 400, w = 80, h = 20},
    {x = 1450, y = 280, w = 100, h = 20}, {x = 900, y = 820, w = 40, h = 20},
    {x = 970, y = 660, w = 40, h = 20}
}

level2.gefahren = {
    {x = 0, y = 850, w = 1600, h = 50}, {x = 400, y = 530, w = 30, h = 300},
    {x = 550, y = 530, w = 20, h = 20}, {x = 870, y = 480, w = 40, h = 300},
    {x = 1130, y = 480, w = 30, h = 20}, {x = 1350, y = 280, w = 30, h = 150}
}

level2.sterne = {}
for i = 1, 80 do
    level2.sterne[i] = {x = math.random(0, 1600), y = math.random(0, 900), speed = math.random(15, 50), size = math.random(1, 3)}
end

function level2.load()
    level2.spieler.x = 80
    level2.spieler.y = 700
    level2.spieler.yv = 0
    level2.spieler.springt = false
    level2.item.collected = false
end

function level2.update(dt)
    if love.keyboard.isDown("a") then level2.spieler.x = level2.spieler.x - level2.spieler.speed * dt end
    if love.keyboard.isDown("d") then level2.spieler.x = level2.spieler.x + level2.spieler.speed * dt end

    if level2.spieler.x < 0 then level2.spieler.x = 0 end
    if level2.spieler.x > 1600 - level2.spieler.w then level2.spieler.x = 1600 - level2.spieler.w end

    level2.spieler.yv = level2.spieler.yv + level2.spieler.gravitation * dt
    level2.spieler.y = level2.spieler.y + level2.spieler.yv * dt

    if level2.spieler.y > 950 then Zustand = "gameover" end

    level2.spieler.springt = true

    for i = 1, #level2.plattformen do
        if kollision(level2.spieler, level2.plattformen[i]) and level2.spieler.yv > 0 then
            level2.spieler.y = level2.plattformen[i].y - level2.spieler.h
            level2.spieler.yv = 0
            level2.spieler.springt = false
        end
    end

    for i = 1, #level2.gefahren do
        if kollision(level2.spieler, level2.gefahren[i]) then Zustand = "gameover" end
    end

    for i = 1, #level2.sterne do
        level2.sterne[i].x = level2.sterne[i].x - level2.sterne[i].speed * dt
        if level2.sterne[i].x < 0 then level2.sterne[i].x = 1600 end
    end

    if not level2.item.collected and kollision(level2.spieler, level2.item) then
        level2.item.collected = true
        if globalStars < 3 then globalStars = globalStars + 1 end
    end

    if kollision(level2.spieler, level2.ziel) then
        Zustand = "level3"
        if level3 and type(level3.load) == "function" then level3.load() end
    end
end

function level2.draw()
    love.graphics.clear(0.03, 0.01, 0.08)

    love.graphics.setColor(0.6, 0.7, 1, 0.5)
    for i = 1, #level2.sterne do
        love.graphics.circle("fill", level2.sterne[i].x, level2.sterne[i].y, level2.sterne[i].size)
    end

    for i = 1, #level2.plattformen do
        love.graphics.setColor(0.08, 0.08, 0.12)
        love.graphics.rectangle("fill", level2.plattformen[i].x, level2.plattformen[i].y, level2.plattformen[i].w, level2.plattformen[i].h)
        love.graphics.setLineWidth(3)
        love.graphics.setColor(1, 0, 0.5)
        love.graphics.rectangle("line", level2.plattformen[i].x, level2.plattformen[i].y, level2.plattformen[i].w, level2.plattformen[i].h)
    end

    love.graphics.setColor(1, 0, 0)
    for i = 1, #level2.gefahren do
        love.graphics.rectangle("fill", level2.gefahren[i].x, level2.gefahren[i].y, level2.gefahren[i].w, level2.gefahren[i].h)
    end

    if not level2.item.collected then pixelstern(level2.item.x + 12, level2.item.y + 12, 4, {1, 0.9, 0}) end

    love.graphics.setColor(0, 1, 0.6)
    love.graphics.rectangle("fill", level2.ziel.x, level2.ziel.y, level2.ziel.w, level2.ziel.h)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", level2.spieler.x, level2.spieler.y, level2.spieler.w, level2.spieler.h)

    if (globalStars or 0) >= 1 then pixelstern(1470, 30, 4, {1, 0.9, 0}) else pixelstern(1470, 30, 4, {0.3, 0.3, 0.3}) end
    if (globalStars or 0) >= 2 then pixelstern(1510, 30, 4, {1, 0.9, 0}) else pixelstern(1510, 30, 4, {0.3, 0.3, 0.3}) end
    if (globalStars or 0) >= 3 then pixelstern(1550, 30, 4, {1, 0.9, 0}) else pixelstern(1550, 30, 4, {0.3, 0.3, 0.3}) end
end

function level2.keypressed(key)
    if key == "w" and not level2.spieler.springt then
        level2.spieler.yv = level2.spieler.sprung
        level2.spieler.springt = true
    end
end

return level2