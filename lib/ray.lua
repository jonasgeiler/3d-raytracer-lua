local class = require('lib.middleclass')

---@class ray
---@field origin point3
---@field direction vec3
local ray = class('ray')

---@param origin point3
---@param direction vec3
function ray:initialize(origin, direction)
    self.origin = origin
    self.direction = direction
end

---@param t number
function ray:at(t)
    return self.origin + t * self.direction
end

return ray
