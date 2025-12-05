-- Ein neues Modul muss genauso heißen wie die Datei selbst.
-- D.h. dieses Modul heißt kreis.
-- Module sollten eigene Callbacks haben, die nicht mit love. starten.
-- Module benötigen eine "Table", um Dinge zu verwalten.
kreis = {}

-- Um der Table etwas hinzuzufügen, damit es verwaltet wird,
-- benutzt man z.B. die Punktschreibweise.
function kreis.load()
    kreisX = -50
    kreisY = 400
end

function kreis.draw()
    zeichneKreis(kreisX, kreisY)
end

function kreis.update(dt)
    kreisX = kreisX + 100*dt
    if kreisX > 200 then
        kreisX = 200
    end
end

function zeichneKreis(x,y)
    love.graphics.setColor(1,0,0)
    love.graphics.circle("fill",x,y,25)
end