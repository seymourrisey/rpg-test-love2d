-- level-1.lua

local sti = require("assets.lib.sti")
local wf = require("assets.lib.windfield")

local Player = require("entity.player")
local CameraSystem = require("systems.camera")

local Level1 = {}

function Level1:load()
    self.world = wf.newWorld(0, 0)
    self.map = sti("assets/maps/test-map.lua")

    -- kamera system
    self.cameraSystem = CameraSystem.new(self.map, 2)

    -- player spawn
    self.player = Player.new(200, 200)
end

function Level1:update(dt)
    self.world:update(dt)
    self.player:update(dt)

    -- update kamera (ikutin player)
    self.cameraSystem:update(dt, self.player.x, self.player.y)
end

function Level1:draw()
    self.cameraSystem:attach()
        self.map:drawLayer(self.map.layers["Ground"])
        self.map:drawLayer(self.map.layers["Foliage"])
        self.map:drawLayer(self.map.layers["Trees-log"])

        self.player:draw()

        self.map:drawLayer(self.map.layers["Trees-bush"])
    self.cameraSystem:detach()
end

return Level1
