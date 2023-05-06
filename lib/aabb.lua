local class = require('lib.class')
local point3 = require('lib.point3')

---Represents an Axis-Aligned Bounding Box (AABB)
---@class aabb
---@overload fun(minimum: point3?, maximum: point3?): aabb
---@field minimum point3?
---@field maximum point3?
local aabb = class()

---Init the AABB
---@param minimum point3?
---@param maximum point3?
function aabb:new(minimum, maximum)
	self.minimum = minimum
	self.maximum = maximum
end

---Set all values of the AABB at once
---@param minimum point3?
---@param maximum point3?
function aabb:set(minimum, maximum)
	self.minimum = minimum
	self.maximum = maximum
end

---Replace the AABB with another one
---@param new_aabb aabb
function aabb:replace(new_aabb)
	self.minimum = new_aabb.minimum
	self.maximum = new_aabb.maximum
end

---Check if a ray hits the AABB
---@param r ray
---@param t_min number
---@param t_max number
---@return boolean
---@nodiscard
function aabb:hit(r, t_min, t_max)
	local inv_d = 1 / r.direction.x ---@type number
	local t0 = (self.minimum.x - r.origin.x) * inv_d
	local t1 = (self.maximum.x - r.origin.x) * inv_d
	if inv_d < 0 then
		t0, t1 = t1, t0 ---@type number
	end

	t_min = t0 > t_min and t0 or t_min
	t_max = t1 < t_max and t1 or t_max
	if t_max <= t_min then return false end

	inv_d = 1 / r.direction.y ---@type number
	t0 = (self.minimum.y - r.origin.y) * inv_d
	t1 = (self.maximum.y - r.origin.y) * inv_d
	if inv_d < 0 then
		t0, t1 = t1, t0 ---@type number
	end

	t_min = t0 > t_min and t0 or t_min
	t_max = t1 < t_max and t1 or t_max
	if t_max <= t_min then return false end

	inv_d = 1 / r.direction.z ---@type number
	t0 = (self.minimum.z - r.origin.z) * inv_d
	t1 = (self.maximum.z - r.origin.z) * inv_d
	if inv_d < 0 then
		t0, t1 = t1, t0 ---@type number
	end

	t_min = t0 > t_min and t0 or t_min
	t_max = t1 < t_max and t1 or t_max
	if t_max <= t_min then return false end

	return true
end

---Compute the bounding box of two bounding boxes
---@param box0 aabb
---@param box1 aabb
---@return aabb
---@nodiscard
function aabb.surrounding_box(box0, box1)
	local small = point3(
		math.min(box0.minimum.x, box1.minimum.x),
		math.min(box0.minimum.y, box1.minimum.y),
		math.min(box0.minimum.z, box1.minimum.z)
	)

	local big = point3(
		math.max(box0.maximum.x, box1.maximum.x),
		math.max(box0.maximum.y, box1.maximum.y),
		math.max(box0.maximum.z, box1.maximum.z)
	)

	return aabb(small, big)
end

return aabb
