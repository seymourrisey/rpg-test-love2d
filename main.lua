local Level1 = require("states.level-1")

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
