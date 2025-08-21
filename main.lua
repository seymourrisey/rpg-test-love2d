-- main.lua

local Level1 = require("states.level-1")

function love.mousepressed(x, y, button)
    if Level1.player then
        Level1.player:mousepressed(x, y, button)
    end
end

function love.mousereleased(x, y, button)
    if Level1.player then
        Level1.player:mousereleased(x, y, button)
    end
end


function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    Level1:load()
end

function love.update(dt)
    Level1:update(dt)
end

function love.draw()
    Level1:draw()
end
