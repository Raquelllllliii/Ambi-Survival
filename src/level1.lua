level1 = {}

figur = { x = 50, y = 500, breite = 40, hoehe = 40, vy = 0, vx = 0, amBoden = true }

schwerkraft = 800
sprungKraft = -400
boden = 500
geschwindigkeit = 300
function level1.load()
    hintergrund = love.graphics.newImage("hintergrund.png")
end
function level1.update(dt)
    -- Links/Rechts Bewegung
    figur.vx = 0
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        figur.vx = -geschwindigkeit
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        figur.vx = geschwindigkeit
    end
    figur.x = figur.x + figur.vx * dt

    -- Schwerkraft
    figur.vy = figur.vy + schwerkraft * dt
    figur.y = figur.y + figur.vy * dt

    -- Boden
    if figur.y >= boden then
        figur.y = boden
        figur.vy = 0
        figur.amBoden = true
    end
end

function level1.keypressed(key)
    if key == "space" and figur.amBoden then
        figur.vy = sprungKraft
        figur.amBoden = false
    end
end

function level1.draw()
    love.graphics.rectangle("fill", figur.x, figur.y, figur.breite, figur.hoehe)
end