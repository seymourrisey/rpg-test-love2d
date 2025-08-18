-- systems/health.lua
local HealthSystem = {}
HealthSystem.__index = HealthSystem

function HealthSystem.new(maxHp)
    local self = setmetatable({}, HealthSystem)
    self.maxHp = maxHp or 100
    self.hp = self.maxHp
    return self
end

function HealthSystem:takeDamage(amount)
    self.hp = math.max(0, self.hp - amount)
end

function HealthSystem:heal(amount)
    self.hp = math.min(self.maxHp, self.hp + amount)
end

function HealthSystem:isDead()
    return self.hp <= 0
end

return HealthSystem
