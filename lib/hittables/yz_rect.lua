local class = require('lib.class')
local hittable = require('lib.base.hittable')
local aabb = require('lib.aabb')
local point3 = require('lib.point3')
local vec3 = require('lib.vec3')

---Represents an YZ axis aligned rectangle
---@class yz_rect : hittable
---@overload fun(y0: number, y1: number, z0: number, z1: number, k: number, mat: material): yz_rect
---@field y0 number
---@field y1 number
---@field z0 number
---@field z1 number
---@field k number
---@field mat material
local yz_rect = class(hittable)

---Init the axis aligned rectangle
---@param y0 number
---@param y1 number
---@param z0 number
---@param z1 number
---@param k number
---@param mat material
function yz_rect:new(y0, y1, z0, z1, k, mat)
	self.y0 = y0
	self.y1 = y1
	self.z0 = z0
	self.z1 = z1
	self.k = k
	self.mat = mat
end

---Check if a ray hits the hittable object
---@param r ray
---@param t_min number
---@param t_max number
---@param rec hit_record
---@return boolean
function yz_rect:hit(r, t_min, t_max, rec)
	local t = (self.k - r.origin.x) / r.direction.x ---@type number
	if t < t_min or t > t_max then
		return false
	end

	local y = r.origin.y + t * r.direction.y ---@type number
	local z = r.origin.z + t * r.direction.z ---@type number
	if y < self.y0 or y > self.y1 or z < self.z0 or z > self.z1 then
		return false
	end

	rec.u = (y - self.y0) / (self.y1 - self.y0)
	rec.v = (z - self.z0) / (self.z1 - self.z0)
	rec.t = t
	local outward_normal = vec3(1, 0, 0)
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
function yz_rect:bounding_box(time0, time1, output_box)
	--- The bounding box must have non-zero width in each dimension, so pad the X dimension a small amount.
	output_box:replace(aabb(point3(self.k - 0.0001, self.y0, self.z0), point3(self.k + 0.0001, self.y1, self.z1)))
	return true
end

return yz_rect
