level3 = {}

level3.spieler = {x = 80, y = 700, w = 30, h = 30, tempo = 450, yv = 0, grav = 1400, sprung = -700, springt = false}
level3.ziel = {x = 1470, y = 210, w = 60, h = 60}
level3.item = {x = 1158, y = 740, w = 24, h = 24, da = true}

level3.boeden = {
    {x = 0, y = 750, w = 150, h = 20},
    {x = 250, y = 650, w = 120, h = 20},
    {x = 550, y = 650, w = 100, h = 20},
    {x = 800, y = 520, w = 100, h = 20},
    {x = 1150, y = 400, w = 100, h = 20},
    {x = 1450, y = 300, w = 100, h = 20},
    {x = 1150, y = 780, w = 40, h = 20},
    {x = 1260, y = 640, w = 40, h = 20},
    {x = 1360, y = 500, w = 40, h = 20},
    {x = 1400, y = 380, w = 40, h = 20}
}

level3.gefahren = {
    {x = 0, y = 850, w = 1600, h = 50, spike = true},
    {x = 900, y = 400, w = 20, h = 120},
    {x = 1320, y = 280, w = 30, h = 120}
}

level3.beweger = {
    {x = 430, y = 500, start = 500, w = 40, h = 120, distance = 120, tempo = 2.5, diff = 0},
    {x = 980, y = 320, start = 320, w = 40, h = 140, distance = 110, tempo = 3.5, diff = 3.14},
    {x = 1130, y = 580, start = 580, w = 80, h = 20, distance = 120, tempo = 4.5, diff = 0}
}

level3.sterne = {}
for i = 1, 100 do
    level3.sterne[i] = {x = math.random(0, 1600), y = math.random(0, 900), tempo = math.random(10, 60), size = math.random(1, 3)}
end

function level3.load()
    level3.spieler.x = 80
    level3.spieler.y = 700
    level3.spieler.yv = 0
    level3.spieler.springt = false
    level3.item.da = true
end

function level3.update(dt)
    if love.keyboard.isDown("a") then level3.spieler.x = level3.spieler.x - level3.spieler.tempo * dt end
    if love.keyboard.isDown("d") then level3.spieler.x = level3.spieler.x + level3.spieler.tempo * dt end

    if level3.spieler.x < 0 then level3.spieler.x = 0 end
    if level3.spieler.x > 1600 - level3.spieler.w then level3.spieler.x = 1600 - level3.spieler.w end

    level3.spieler.yv = level3.spieler.yv + level3.spieler.grav * dt
    level3.spieler.y = level3.spieler.y + level3.spieler.yv * dt

    if level3.spieler.y > 950 then Zustand = "gameover" end

    level3.spieler.springt = true

    for i = 1, #level3.boeden do
        if kollision(level3.spieler, level3.boeden[i]) and level3.spieler.yv > 0 then
            level3.spieler.y = level3.boeden[i].y - level3.spieler.h
            level3.spieler.yv = 0
            level3.spieler.springt = false
        end
    end

    for i = 1, #level3.gefahren do
        if kollision(level3.spieler, level3.gefahren[i]) then Zustand = "gameover" end
    end

    for i = 1, #level3.beweger do
        level3.beweger[i].y = level3.beweger[i].start + math.sin(love.timer.getTime() * level3.beweger[i].tempo + level3.beweger[i].diff) * level3.beweger[i].distance
        if kollision(level3.spieler, level3.beweger[i]) then Zustand = "gameover" end
    end

    for i = 1, #level3.sterne do
        level3.sterne[i].x = level3.sterne[i].x - level3.sterne[i].tempo * dt
        if level3.sterne[i].x < 0 then level3.sterne[i].x = 1600 end
    end

    if level3.item.da and kollision(level3.spieler, level3.item) then
        level3.item.da = false
        if globalStars < 3 then globalStars = globalStars + 1 end
    end

    if kollision(level3.spieler, level3.ziel) then
        Zustand = "win"
        if type(win) == "table" and win.load then
            win.load()
        end
    end
end

function level3.draw()
    love.graphics.clear(0.03, 0.01, 0.08)

    love.graphics.setColor(0.6, 0.7, 1, 0.5)
    for i = 1, #level3.sterne do
        love.graphics.circle("fill", level3.sterne[i].x, level3.sterne[i].y, level3.sterne[i].size)
    end

    for i = 1, #level3.boeden do
        love.graphics.setColor(0.08, 0.08, 0.12)
        love.graphics.rectangle("fill", level3.boeden[i].x, level3.boeden[i].y, level3.boeden[i].w, level3.boeden[i].h)
        love.graphics.setLineWidth(3)
        love.graphics.setColor(1, 0, 0.5)
        love.graphics.rectangle("line", level3.boeden[i].x, level3.boeden[i].y, level3.boeden[i].w, level3.boeden[i].h)
    end

    for i = 1, #level3.gefahren do
        love.graphics.setColor(1, 0, 0)
        if level3.gefahren[i].spike then
            love.graphics.rectangle("fill", level3.gefahren[i].x, level3.gefahren[i].y + 15, level3.gefahren[i].w, level3.gefahren[i].h - 15)
            for j = 0, level3.gefahren[i].w / 20 - 1 do
                love.graphics.polygon("fill", level3.gefahren[i].x + j * 20, level3.gefahren[i].y + 15, level3.gefahren[i].x + j * 20 + 10, level3.gefahren[i].y, level3.gefahren[i].x + j * 20 + 20, level3.gefahren[i].y + 15)
            end
        else
            love.graphics.rectangle("fill", level3.gefahren[i].x, level3.gefahren[i].y, level3.gefahren[i].w, level3.gefahren[i].h)
        end
    end

    love.graphics.setColor(0.8, 0.2, 1)
    for i = 1, #level3.beweger do
        love.graphics.rectangle("fill", level3.beweger[i].x, level3.beweger[i].y, level3.beweger[i].w, level3.beweger[i].h)
    end

    if level3.item.da then pixelstern(level3.item.x + 12, level3.item.y + 12, 4, {1, 0.9, 0}) end

    love.graphics.setColor(0, 1, 0.6)
    love.graphics.rectangle("fill", level3.ziel.x, level3.ziel.y, level3.ziel.w, level3.ziel.h)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", level3.spieler.x, level3.spieler.y, level3.spieler.w, level3.spieler.h)

    love.graphics.setLineWidth(1)

    if (globalStars or 0) >= 1 then pixelstern(1470, 30, 4, {1, 0.9, 0}) else pixelstern(1470, 30, 4, {0.3, 0.3, 0.3}) end
    if (globalStars or 0) >= 2 then pixelstern(1510, 30, 4, {1, 0.9, 0}) else pixelstern(1510, 30, 4, {0.3, 0.3, 0.3}) end
    if (globalStars or 0) >= 3 then pixelstern(1550, 30, 4, {1, 0.9, 0}) else pixelstern(1550, 30, 4, {0.3, 0.3, 0.3}) end
end

function level3.keypressed(key)
    if key == "w" and not level3.spieler.springt then
        level3.spieler.yv = level3.spieler.sprung
        level3.spieler.springt = true
    end
end

return level3