-- systems/display.lua
local Display = {}

-- resolusi internal retro (sesuaikan dengan kebutuhan)
Display.gameWidth  = 540
Display.gameHeight = 405

-- canvas internal
Display.canvas = love.graphics.newCanvas(Display.gameWidth, Display.gameHeight)

-- scale & offset untuk letterbox
Display.scaleX, Display.scaleY = 1, 1
Display.offsetX, Display.offsetY = 0, 0

-- hitung scaling dan offset berdasarkan ukuran window
function Display:resize(w, h)
    local scale = math.min(w / self.gameWidth, h / self.gameHeight)
    self.scaleX, self.scaleY = scale, scale
    self.offsetX = math.floor((w - self.gameWidth * scale) / 2)
    self.offsetY = math.floor((h - self.gameHeight * scale) / 2)
end

-- panggil di love.load
function Display:load()
    self:resize(love.graphics.getWidth(), love.graphics.getHeight())
end

-- panggil di awal love.draw
function Display:start()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
end

-- panggil di akhir love.draw
function Display:finish()
    love.graphics.setCanvas()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.canvas, self.offsetX, self.offsetY, 0, self.scaleX, self.scaleY)
end

return Display
