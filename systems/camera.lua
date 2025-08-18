local camera = require("assets.lib.camera")

local CameraSystem = {}
CameraSystem.__index = CameraSystem

-- helper lerp
local function lerp(a, b, t)
    return a + (b - a) * t
end

function CameraSystem.new(map, zoom)
    local self = setmetatable({}, CameraSystem)

    self.cam = camera()
    self.cam:zoomTo(zoom or 1)

    self.map = map
    return self
end

function CameraSystem:update(dt, targetX, targetY)
    -- smooth follow
    local smooth = 5 * dt
    self.cam.x = lerp(self.cam.x, targetX, smooth)
    self.cam.y = lerp(self.cam.y, targetY, smooth)

    -- clamp ke ukuran map
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local mapW, mapH = self.map.width * self.map.tilewidth, self.map.height * self.map.tileheight

    local zoom = self.cam.scale or 1
    local viewportW = w / zoom
    local viewportH = h / zoom

    if self.cam.x < viewportW/2 then self.cam.x = viewportW/2 end
    if self.cam.y < viewportH/2 then self.cam.y = viewportH/2 end
    if self.cam.x > (mapW - viewportW/2) then self.cam.x = (mapW - viewportW/2) end
    if self.cam.y > (mapH - viewportH/2) then self.cam.y = (mapH - viewportH/2) end
end

function CameraSystem:attach()
    self.cam:attach()
end

function CameraSystem:detach()
    self.cam:detach()
end

return CameraSystem
