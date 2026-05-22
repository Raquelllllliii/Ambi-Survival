-- Module laden
menu = require("menu")
level1 = require("level1")
level2 = require("level2")
level3 = require("level3") -- Das neue Level 3 laden
gameover = require("gameover")
win = require("win")

function love.load()
    -- Garantiert, dass das Fenster im 1600x900 HD-Format startet
    love.window.setMode(1600, 900, {resizable = false})

    -- Globale Variable für den Spielzustand
    Zustand = "menu"
end

function love.update(dt)
    if Zustand == "menu" then
        if menu.update then menu.update(dt) end
    elseif Zustand == "level1" then
        level1.update(dt)
    elseif Zustand == "level2" then
        level2.update(dt)
    elseif Zustand == "level3" then
        level3.update(dt) -- Update-Schleife für Level 3
    elseif Zustand == "gameover" then
        gameover.update(dt)
    elseif Zustand == "win" then
        win.update(dt)
    end
end

function love.keypressed(key)
    -- Leite den Tastendruck an das aktive Modul weiter
    if Zustand == "menu" then
        if menu.keypressed then menu.keypressed(key) end
    elseif Zustand == "level1" then
        level1.keypressed(key)
    elseif Zustand == "level2" then
        level2.keypressed(key)
    elseif Zustand == "level3" then
        level3.keypressed(key) -- Tastatureingaben für Level 3
    elseif Zustand == "gameover" then
        gameover.keypressed(key)
    elseif Zustand == "win" then
        win.keypressed(key)
    end

    -- Ermöglicht es, das Spiel jederzeit mit Escape zu beenden
    if key == "escape" then
        love.event.quit()
    end
end

function love.draw()
    if Zustand == "menu" then
        menu.draw()
    elseif Zustand == "level1" then
        level1.draw()
    elseif Zustand == "level2" then
        level2.draw()
    elseif Zustand == "level3" then
        level3.draw() -- Level 3 auf den Bildschirm zeichnen
    elseif Zustand == "gameover" then
        gameover.draw()
    elseif Zustand == "win" then
        win.draw()
    end
end

function love.mousepressed(x, y, button)
    -- Mausklicks an das jeweilige Modul weiterleiten
    if Zustand == "menu" then
        menu.mousepressed(x, y, button)

        -- Wenn das Menü das erste Level startet:
        if Zustand == "level1" then
            level1.load() -- Startet Level 1 sauber
        end
    elseif Zustand == "level1" then
        if level1.mousepressed then level1.mousepressed(x, y, button) end
    elseif Zustand == "level2" then
        if level2.mousepressed then level2.mousepressed(x, y, button) end
    elseif Zustand == "level3" then
        if level3.mousepressed then level3.mousepressed(x, y, button) end -- Mausklicks für Level 3
    elseif Zustand == "gameover" then
        if gameover.mousepressed then gameover.mousepressed(x, y, button) end
    elseif Zustand == "win" then
        if win.mousepressed then win.mousepressed(x, y, button) end
    end
end