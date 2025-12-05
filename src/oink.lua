oink = {}
local zeit --Gibt es Variablen, die in mehreren Modulen vorkommen,
            -- so müssen diesen mit local vor fremden Zugriff geschützt werden.

function oink.load()
    oinkX = 350
    oinkStatus = false
    zeit = 0
end

function oink.draw()
    zeichneOink(oinkX, oinkStatus)
end

function oink.update(dt)
    oinkX = oinkX - 50*dt
    zeit = zeit + dt
    if zeit > 1 then
        oinkStatus = true
    end
    if zeit > 2 then
        oinkStatus = false
        zeit = 0
    end
end


function zeichneOink(x,status)
    love.graphics.setColor(1,1,0)
    if status == false then
        love.graphics.print("Oink",x,x);
    else
        love.graphics.print("DoppelOink",x,x);
    end
end