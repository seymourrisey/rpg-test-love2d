-- player.lua

local anim8 = require 'assets/lib/anim8'
local HealthSystem = require("systems.health")

local Player = {}
Player.__index = Player

function Player.new(x, y)
    local self = setmetatable({}, Player)

    -- Load sprite sheet
    self.image = love.graphics.newImage("assets/sprites/kevin-spritesheets.png")

    -- Ukuran frame LPC (64x64)
    local grid = anim8.newGrid(64, 64, self.image:getWidth(), self.image:getHeight())

    self.health = HealthSystem.new(100)

    -- Animasi
    self.animations = {
        idleUp     = anim8.newAnimation(grid(1, 9), 0.2),
        idleLeft   = anim8.newAnimation(grid(1, 10), 0.2),
        idleDown   = anim8.newAnimation(grid(1, 11), 0.2),
        idleRight  = anim8.newAnimation(grid(1, 12), 0.2),

        walkUp     = anim8.newAnimation(grid('1-9', 9), 0.12),
        walkLeft   = anim8.newAnimation(grid('1-9', 10), 0.12),
        walkDown   = anim8.newAnimation(grid('1-9', 11), 0.12),
        walkRight  = anim8.newAnimation(grid('1-9', 12), 0.12),

        AttackUp    = anim8.newAnimation(grid('1-6', 13), 0.12),
        AttackLeft  = anim8.newAnimation(grid('1-6', 14), 0.12),
        AttackDown  = anim8.newAnimation(grid('1-6', 15), 0.12),
        AttackRight = anim8.newAnimation(grid('1-6', 16), 0.12),
    }

    self.x, self.y = x, y
    self.speed = 97

    self.facing = "Down"
    self.state = "idleDown"
    self.isAttacking = false
    self.lastMousePressed = false -- default

    return self
end

function Player:update(dt)
    local dx, dy = 0, 0
    local moving = false

    if not self.isAttacking then 
        -- kontrol gerakan
        if love.keyboard.isDown("up", "w") then
            dy = -1
            self.facing = "Up"
            self.state = "walkUp"
            moving = true
        elseif love.keyboard.isDown("down", "s") then
            dy = 1
            self.facing = "Down"
            self.state = "walkDown"
            moving = true
        end

        if love.keyboard.isDown("left", "a") then
            dx = -1
            self.facing = "Left"
            self.state = "walkLeft"
            moving = true
        elseif love.keyboard.isDown("right", "d") then
            dx = 1
            self.facing = "Right"
            self.state = "walkRight"
            moving = true
        end

        if not moving then
            self.state = "idle" .. self.facing
        end

        if dx ~= 0 and dy ~= 0 then
            local len = math.sqrt(dx*dx + dy*dy)
            dx, dy = dx / len, dy / len
        end

        self.x = self.x + dx * self.speed * dt
        self.y = self.y + dy * self.speed * dt
    else
        -- lagi attack → cek kalau animasi udah selesai
        local anim = self.animations[self.state]
        if anim.position == anim.frames then
            self.isAttacking = false
            self.state = "idle" .. self.facing
        end
    end

    -- Update animasi
    self.animations[self.state]:update(dt)
end

function Player:mousepressed(x, y, button)
    if button == 1 and not self.isAttacking then
        -- mulai serangan
        self.state = "Attack" .. self.facing
        local anim = self.animations[self.state]
        anim:gotoFrame(1)
        anim:resume()
        self.isAttacking = true
        self.lastMousePressed = true
    end
end

function Player:mousereleased(x, y, button)
    if button == 1 then
        self.lastMousePressed = false
    end
end


function Player:draw()
    -- offset (32,32) biar titik player di tengah sprite
    self.scale = 0.8
    self.animations[self.state]:draw(self.image, self.x, self.y, 0, self.scale, self.scale, 32, 32)

    -- debug info di atas kepala player
    love.graphics.setColor(1,0,0)
    love.graphics.print("HP: " .. self.health.hp, self.x - 20, self.y - 50)

    -- debug state attack / mouse
    love.graphics.setColor(0,1,0)
    love.graphics.print("isAttacking: " .. tostring(self.isAttacking), self.x - 40, self.y - 65)

    love.graphics.setColor(0,0,1)
    love.graphics.print("MouseLeft: " .. tostring(self.lastMousePressed), self.x - 40, self.y - 80)


    love.graphics.setColor(1,1,1)
end

return Player
