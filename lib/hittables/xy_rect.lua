local class = require('lib.class')
local hittable = require('lib.base.hittable')
local aabb = require('lib.aabb')
local point3 = require('lib.point3')
local vec3 = require('lib.vec3')

---Represents an XY axis aligned rectangle
---@class xy_rect : hittable
---@overload fun(x0: number, x1: number, y0: number, y1: number, k: number, mat: material): xy_rect
---@field x0 number
---@field x1 number
---@field y0 number
---@field y1 number
---@field k number
---@field mat material
local xy_rect = class(hittable)

---Init the axis aligned rectangle
---@param x0 number
---@param x1 number
---@param y0 number
---@param y1 number
---@param k number
---@param mat material
function xy_rect:new(x0, x1, y0, y1, k, mat)
	self.x0 = x0
	self.x1 = x1
	self.y0 = y0
	self.y1 = y1
	self.k = k
	self.mat = mat
end

---Check if a ray hits the hittable object
---@param r ray
---@param t_min number
---@param t_max number
---@param rec hit_record
---@return boolean
function xy_rect:hit(r, t_min, t_max, rec)
	local t = (self.k - r.origin.z) / r.direction.z ---@type number
	if t < t_min or t > t_max then
		return false
	end

	local x = r.origin.x + t * r.direction.x ---@type number
	local y = r.origin.y + t * r.direction.y ---@type number
	if x < self.x0 or x > self.x1 or y < self.y0 or y > self.y1 then
		return false
	end

	rec.u = (x - self.x0) / (self.x1 - self.x0)
	rec.v = (y - self.y0) / (self.y1 - self.y0)
	rec.t = t
	local outward_normal = vec3(0, 0, 1)
	rec:set_face_normal(r, outward_normal)
	rec.mat = self.mat
	rec.p = r:at(t)

	return true
end

---Get the bounding box of the hittable object
---@param time0 number
---@param time1 number
---@param output_box aabb
---@return boolean
function xy_rect:bounding_box(time0, time1, output_box)
	--- The bounding box must have non-zero width in each dimension, so pad the Y dimension a small amount.
	output_box:set(point3(self.x0, self.y0, self.k - 0.0001), point3(self.x1, self.y1, self.k + 0.0001))
	return true
end

return xy_rect
