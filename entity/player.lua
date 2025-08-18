-- player.lua

local anim8 = require 'assets/lib/anim8'

local Player = {}
Player.__index = Player

function Player.new(x, y)
    local self = setmetatable({}, Player)

    -- Load sprite sheet
    self.image = love.graphics.newImage("assets/sprites/kevin-spritesheets.png")

    -- Ukuran frame LPC (64x64)
    local grid = anim8.newGrid(64, 64, self.image:getWidth(), self.image:getHeight())

    -- Animasi (idle = frame pertama tiap baris, walk = 8 frame)
    self.animations = {
        idleUp     = anim8.newAnimation(grid(1, 9), 0.2),
        idleLeft    = anim8.newAnimation(grid(1, 10), 0.2),
        idleDown    = anim8.newAnimation(grid(1, 11), 0.2),
        idleRight   = anim8.newAnimation(grid(1, 12), 0.2),

        walkUp      = anim8.newAnimation(grid('1-8', 9), 0.12),
        walkLeft    = anim8.newAnimation(grid('1-8', 10), 0.12),
        walkDown    = anim8.newAnimation(grid('1-8', 11), 0.12),
        walkRight   = anim8.newAnimation(grid('1-8', 12), 0.12),
    }

    self.x, self.y = x, y
    self.speed = 100

    -- default menghadap bawah & idle
    self.facing = "Down"
    self.state = "idleDown"

    return self
end

function Player:update(dt)
    local dx, dy = 0, 0
    local moving = false

    -- kontrol vertikal
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

    -- kontrol horizontal
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

    -- Kalau tidak bergerak → idle
    if not moving then
        self.state = "idle" .. self.facing
    end

    -- Normalisasi supaya diagonal tidak lebih cepat
    if dx ~= 0 and dy ~= 0 then
        local len = math.sqrt(dx*dx + dy*dy)
        dx = dx / len
        dy = dy / len
    end

    -- Update posisi
    self.x = self.x + dx * self.speed * dt
    self.y = self.y + dy * self.speed * dt

    -- Update animasi
    self.animations[self.state]:update(dt)
end


function Player:draw()
    -- offset (32,32) biar titik player di tengah sprite
    self.scale = 0.8  -- taruh di constructor Player.new()
    self.animations[self.state]:draw(self.image, self.x, self.y, 0, self.scale, self.scale, 32, 32)
end


return Player
