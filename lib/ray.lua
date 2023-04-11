local class = require('lib.class')

---@class ray
---@field origin point3
---@field direction vec3
local ray = class()

---@param origin point3
---@param direction vec3
function ray:new(origin, direction)
    self.origin = origin
    self.direction = direction
end

---@param new_ray ray
function ray:replace_with(new_ray)
    self.origin = new_ray.origin
    self.direction = new_ray.direction
end

---@param t number
function ray:at(t)
    return self.origin + t * self.direction
end

return ray
