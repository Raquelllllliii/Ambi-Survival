rechteck = {}

function rechteck.load()
    recX = 200
    recY = -100
end

function rechteck.draw()
    zeichneRechteck(recX,recY)
end

function rechteck.update(dt)
    recY = recY + 100*dt
end

function zeichneRechteck(x,y)
    love.graphics.setColor(0,0,1)
    love.graphics.rectangle("fill",x,y,100,50)
end