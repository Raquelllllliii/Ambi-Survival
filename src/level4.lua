level4 = {}

function level4.load()
    Hx = 0
end
function level4.update(dt)
   Hx = Hx + 100 * dt
    if Hx > 1600 then
        Hx = 0
    end


end

function level4.draw()
    love.graphics.setBackgroundColor(0,0,1)
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill",0,50,1600,10)
    love.graphics.setColor(77/255, 53/255, 11/255)
    love.graphics.rectangle("fill", 0, 0,1600,50 )

    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill",50,40,65,5)
    love.graphics.setColor(77/255, 53/255, 11/255)
    love.graphics.rectangle("fill",50,40, 65,20)

    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill",60,50,65,5)
    love.graphics.setColor(77/255, 53/255, 11/255)
    love.graphics.rectangle("fill",60,50, 65,20)

    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill",84,50,65,5)
    love.graphics.setColor(77/255, 53/255, 11/255)
    love.graphics.rectangle("fill",84,50, 65,20)

    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill",Hx,200,50,20)





end