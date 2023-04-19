local class = require('lib.class')
local hittable = require('lib.base.hittable')
local aabb = require('lib.aabb')
local point3 = require('lib.point3')
local ray = require('lib.ray')
local utils = require('lib.utils')
local vec3 = require('lib.vec3')

---Represents a Y-rotated hittable
---@class rotate_y : hittable
---@overload fun(object: hittable, angle: number): rotate_y
---@field object hittable
---@field sin_theta number
---@field cos_theta number
---@field has_box boolean
---@field bbox aabb
local rotate_y = class(hittable)

---Init the Y-rotated hittable
---@param object hittable
---@param angle number
function rotate_y:new(object, angle)
	self.object = object

	local radians = utils.degrees_to_radians(angle)
	self.sin_theta = math.sin(radians)
	self.cos_theta = math.cos(radians)
	self.bbox = aabb()
	self.has_box = self.object:bounding_box(0.0, 1.0, self.bbox)

	local min = point3(math.huge, math.huge, math.huge)
	local max = point3(-math.huge, -math.huge, -math.huge)

	for i = 0, 1 do
		for j = 0, 1 do
			for k = 0, 1 do
				local x = i * self.bbox.maximum.x + (1 - i) * self.bbox.minimum.x
				local y = j * self.bbox.maximum.y + (1 - j) * self.bbox.minimum.y
				local z = k * self.bbox.maximum.z + (1 - k) * self.bbox.minimum.z

				local new_x = self.cos_theta * x + self.sin_theta * z
				local new_z = -self.sin_theta * x + self.cos_theta * z

				local tester = vec3(new_x, y, new_z)

				min.x = math.min(min.x, tester.x)
				min.y = math.min(min.y, tester.y)
				min.z = math.min(min.z, tester.z)

				max.x = math.max(max.x, tester.x)
				max.y = math.max(max.y, tester.y)
				max.z = math.max(max.z, tester.z)
			end
		end
	end

	self.bbox.minimum = min
	self.bbox.maximum = max
end

---Check if a ray hits the hittable object
---@param r ray
---@param t_min number
---@param t_max number
---@param rec hit_record
---@return boolean
function rotate_y:hit(r, t_min, t_max, rec)
	local origin = r.origin
	local direction = r.direction

	origin.x = self.cos_theta * r.origin.x - self.sin_theta * r.origin.z
	origin.z = self.sin_theta * r.origin.x + self.cos_theta * r.origin.z

	direction.x = self.cos_theta * r.direction.x - self.sin_theta * r.direction.z
	direction.z = self.sin_theta * r.direction.x + self.cos_theta * r.direction.z

	local rotated_ray = ray(origin, direction, r.time)

	if not self.object:hit(rotated_ray, t_min, t_max, rec) then
		return false
	end

	local p = rec.p
	local normal = rec.normal

	p.x = self.cos_theta * rec.p.x + self.sin_theta * rec.p.z
	p.z = -self.sin_theta * rec.p.x + self.cos_theta * rec.p.z

	normal.x = self.cos_theta * rec.normal.x + self.sin_theta * rec.normal.z
	normal.z = -self.sin_theta * rec.normal.x + self.cos_theta * rec.normal.z

	rec.p = p
	rec:set_face_normal(rotated_ray, normal)

	return true
end

---Get the bounding box of the hittable object
---@param time0 number
---@param time1 number
---@param output_box aabb
---@return boolean
function rotate_y:bounding_box(time0, time1, output_box)
	output_box:replace_with(self.bbox)
	return self.has_box
end

return rotate_y
