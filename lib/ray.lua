local class = require('lib.class')

---Represents a ray
---@class ray
---@overload fun(): ray
---@field origin point3
---@field direction vec3
local ray = class()

---Init the ray
---@param origin point3
---@param direction vec3
function ray:new(origin, direction)
    self.origin = origin
    self.direction = direction
end

---Replace the ray with another one
---@param new_ray ray
function ray:replace_with(new_ray)
    self.origin = new_ray.origin
    self.direction = new_ray.direction
end

---Get a position on the ray at distance t
---@param t number
---@return vec3
---@nodiscard
function ray:at(t)
    return self.origin + self.direction * t
end

return ray
