local class = require('lib.class')
local hittable = require('lib.base.hittable')
local isotropic = require('lib.materials.isotropic')
local hit_record = require('lib.hit_record')
local vec3 = require('lib.vec3')

---Represents a constant medium hittable
---@class constant_medium : hittable
---@overload fun(boundary: hittable, density: number, phase: color|texture): constant_medium
---@field boundary hittable
---@field phase_function material
---@field neg_inv_density number
local constant_medium = class(hittable)

---Init the constant medium hittable
---@param boundary hittable
---@param density number
---@param phase color|texture
function constant_medium:new(boundary, density, phase)
	self.boundary = boundary
	self.neg_inv_density = -1 / density
	self.phase_function = isotropic(phase)
end

---Check if a ray hits the hittable object
---@param r ray
---@param t_min number
---@param t_max number
---@param rec hit_record
---@return boolean
function constant_medium:hit(r, t_min, t_max, rec)
	local rec1, rec2 = hit_record(), hit_record()

	if not self.boundary:hit(r, -math.huge, math.huge, rec1) then
		return false
	end

	if not self.boundary:hit(r, rec1.t + 0.0001, math.huge, rec2) then
		return false
	end

	if rec1.t < t_min then rec1.t = t_min end
	if rec2.t > t_max then rec2.t = t_max end

	if rec1.t >= rec2.t then
		return false
	end

	if rec1.t < 0 then
		rec1.t = 0
	end

	local ray_length = r.direction:length()
	local distance_inside_boundary = (rec2.t - rec1.t) * ray_length
	local hit_distance = self.neg_inv_density * math.log(math.random())

	if hit_distance > distance_inside_boundary then
		return false
	end

	rec.t = rec1.t + hit_distance / ray_length
	rec.p = r:at(rec.t)
	rec.normal = vec3(1, 0, 0) -- arbitary
	rec.front_face = true   -- also arbitary
	rec.mat = self.phase_function

	return true
end

---Get the bounding box of the hittable object
---@param time0 number
---@param time1 number
---@param output_box aabb
---@return boolean
function constant_medium:bounding_box(time0, time1, output_box)
	return self.boundary:bounding_box(time0, time1, output_box)
end

return constant_medium
