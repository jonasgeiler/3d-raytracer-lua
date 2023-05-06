local class = require('lib.class')
local hittable = require('lib.base.hittable')
local point3 = require('lib.point3')
local vec3 = require('lib.vec3')

---Represents an XZ axis aligned rectangle
---@class xz_rect : hittable
---@overload fun(x0: number, x1: number, z0: number, z1: number, k: number, mat: material): xz_rect
---@field x0 number
---@field x1 number
---@field z0 number
---@field z1 number
---@field k number
---@field mat material
local xz_rect = class(hittable)

---Init the axis aligned rectangle
---@param x0 number
---@param x1 number
---@param z0 number
---@param z1 number
---@param k number
---@param mat material
function xz_rect:new(x0, x1, z0, z1, k, mat)
	self.x0 = x0
	self.x1 = x1
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
function xz_rect:hit(r, t_min, t_max, rec)
	local t = (self.k - r.origin.y) / r.direction.y ---@type number
	if t < t_min or t > t_max then
		return false
	end

	local x = r.origin.x + t * r.direction.x ---@type number
	local z = r.origin.z + t * r.direction.z ---@type number
	if x < self.x0 or x > self.x1 or z < self.z0 or z > self.z1 then
		return false
	end

	rec.u = (x - self.x0) / (self.x1 - self.x0)
	rec.v = (z - self.z0) / (self.z1 - self.z0)
	rec.t = t
	local outward_normal = vec3(0, 1, 0)
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
function xz_rect:bounding_box(time0, time1, output_box)
	--- The bounding box must have non-zero width in each dimension, so pad the Z dimension a small amount.
	output_box:set(point3(self.x0, self.k - 0.0001, self.z0), point3(self.x1, self.k + 0.0001, self.z1))
	return true
end

return xz_rect
