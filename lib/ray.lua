local class = require('lib.class')
local point3 = require('lib.point3')
local vec3 = require('lib.vec3')

---Represents a ray
---@class ray
---@overload fun(origin: point3?, direction: vec3?, time: number?): ray
---@field origin point3
---@field direction vec3
---@field time number
local ray = class()

---Init the ray
---@param origin point3?
---@param direction vec3?
---@param time number?
function ray:new(origin, direction, time)
	self.origin = origin or point3()
	self.direction = direction or vec3()
	self.time = time or 0
end

---Set all values of the ray at once
---@param origin point3
---@param direction vec3
---@param time number?
function ray:set(origin, direction, time)
	self.origin = origin
	self.direction = direction
	self.time = time or self.time
end

---Replace the ray with another one
---@param new_ray ray
function ray:replace(new_ray)
	self.origin = new_ray.origin
	self.direction = new_ray.direction
	self.time = new_ray.time
end

---Get a position on the ray at distance t
---@param t number
---@return vec3
---@nodiscard
function ray:at(t)
	return self.origin + self.direction * t
end

return ray
