-- systems/collision.lua
local wf = require("assets.lib.windfield")

local CollisionSystem = {}
CollisionSystem.__index = CollisionSystem

function CollisionSystem.new()
    local self = setmetatable({}, CollisionSystem)

    -- bikin world
    self.world = wf.newWorld(0, 0, true)

    -- definisi collision class
    self.world:addCollisionClass('Player')
    self.world:addCollisionClass('Enemy')
    self.world:addCollisionClass('Wall')
    self.world:addCollisionClass('Attack')

    return self
end

function CollisionSystem:update(dt)
    self.world:update(dt)
end

function CollisionSystem:drawDebug()
    self.world:draw() -- debug grid collider
end

return CollisionSystem
