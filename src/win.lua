win = {}
win.sterne = {}

function zeichneStern(x, y, groesse, farbe)
    love.graphics.setColor(farbe)
    love.graphics.rectangle("fill", x, y - 2 * groesse, groesse, groesse)
    love.graphics.rectangle("fill", x - 2 * groesse, y - groesse, 5 * groesse, groesse)
    love.graphics.rectangle("fill", x - groesse, y, 3 * groesse, groesse)
    love.graphics.rectangle("fill", x - 2 * groesse, y + groesse, groesse, groesse)
    love.graphics.rectangle("fill", x + 2 * groesse, y + groesse, groesse, groesse)
end

function win.load()
    win.sterne = {}
    for i = 1, 100 do
        win.sterne[i] = {
            x = math.random(0, 1600),
            y = math.random(0, 900),
            speed = math.random(50, 300),
            angle = math.random() * 6.28,
            distance = math.random(0, 800)
        }
    end
end

function win.update(dt)
    if globalStars == 1 then
        for i = 1, #win.sterne do
            win.sterne[i].y = win.sterne[i].y - win.sterne[i].speed * dt
            if win.sterne[i].y < 0 then win.sterne[i].y = 900 end
        end
    elseif globalStars == 2 then
        for i = 1, #win.sterne do
            win.sterne[i].x = win.sterne[i].x - win.sterne[i].speed * dt
            win.sterne[i].y = win.sterne[i].y + win.sterne[i].speed * 0.5 * dt
            if win.sterne[i].x < 0 or win.sterne[i].y > 900 then
                win.sterne[i].x = 1600
                win.sterne[i].y = math.random(0, 450)
            end
        end
    elseif globalStars == 3 then
        for i = 1, #win.sterne do
            win.sterne[i].distance = win.sterne[i].distance + win.sterne[i].speed * dt
            if win.sterne[i].distance > 1000 then win.sterne[i].distance = 0 end
        end
    end
end

function win.draw()
    love.graphics.clear(0, 0.05, 0.05)

    if globalStars == 1 then
        for i = 1, #win.sterne do
            zeichneStern(win.sterne[i].x, win.sterne[i].y, 2, {1, 0.8, 0.2})
        end
    elseif globalStars == 2 then
        for i = 1, #win.sterne do
            zeichneStern(win.sterne[i].x, win.sterne[i].y, 2, {0.9, 0.9, 1})
        end
    elseif globalStars == 3 then
        for i = 1, #win.sterne do
            zeichneStern(800 + math.cos(win.sterne[i].angle) * win.sterne[i].distance, 450 + math.sin(win.sterne[i].angle) * win.sterne[i].distance, 2, {0, 1, 1})
        end
    end

    love.graphics.setColor(0, 1, 0)
    love.graphics.print("CONGRATULATIONS: YOU WON!", 550, 430, 0, 2, 2)

    if globalStars == 3 then
        love.graphics.setColor(1, 0.8, 0)
        love.graphics.print("Perfect run!", 700, 120, 0, 1.5, 1.5)
    else
        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.print("You can do better...", 650, 120, 0, 1.5, 1.5)
        love.graphics.print("Tipp: collect all stars for the perfect ending", 500, 180, 0, 1.2, 1.2)
    end

    for i = 1, 3 do
        if i <= globalStars then
            zeichneStern(500 + (i - 1) * 200, 280, 10, {1, 0.9, 0})
        else
            zeichneStern(500 + (i - 1) * 200, 280, 10, {0.3, 0.3, 0.3})
        end
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Druecke 'R' fuer Neustart", 650, 530, 0, 1.2, 1.2)
    love.graphics.print("Druecke 'M' fuers Menue", 650, 570, 0, 1.2, 1.2)
end

function win.keypressed(key)
    if key == "r" then
        globalStars = 0    -- FIX: Sterne wieder auf 0 setzen beim Neustart!
        Zustand = "level1"
        if level1
        then level1.load() end
    elseif key == "m" then
        globalStars = 0    -- FIX: Sterne wieder auf 0 setzen, wenn man ins Menü geht!
        Zustand = "menu"
    end
end

return win