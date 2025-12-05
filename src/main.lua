-- Lua ist in sogenannte Module eingeteilt - die kann man sich als eigene Dateien vorstellen, die sich um
-- genau eine "Sache" kümmern. Ein Beispiel wäre das Modul graphics!

-- Module müssen über main.lua geladen werden --> das passiert mit dem Schlüsselbegriff require
-- Oft ist es so, dass ein Modul "Dinge" laden soll, von daher
-- sollte es vor load() "required" werden.
require "kreis"
require "rechteck"
require "oink"

function love.load()
    zustand = 1
    zeit = 0

    kreis.load()
    rechteck.load()
    oink.load()
end

function love.draw()
    love.graphics.print("Zeit: " .. math.floor(zeit*100)/100, 375, 0)
    if zustand == 1 then
        kreis.draw()
    end
    if zustand == 2 then
        rechteck.draw()
    end
    if zustand == 3 then
        oink.draw()
    end
end

function love.update(dt)
    zeit = zeit + dt

    --entweder
    if zeit > 4 and zustand == 1 then
        zustand = 2
    end

    if zeit > 8 and zustand == 2 then
        zustand = 3
    end

    if zustand == 1 then
        kreis.update(dt)
    end

    if zustand == 2 then
        rechteck.update(dt)
    end

    if zustand == 3 then
        oink.update(dt)
    end
end