local class = require('lib.class')
local hittable = require('lib.base.hittable')
local aabb = require('lib.aabb')
local ray = require('lib.ray')

---Represents a translated hittable
---@class translate : hittable
---@overload fun(object: hittable, offset: vec3): translate
---@field object hittable
---@field offset vec3
local translate = class(hittable)

---Init the translated hittable
---@param object hittable
---@param offset vec3
function translate:new(object, offset)
	self.object = object
	self.offset = offset
end

---Check if a ray hits the hittable object
---@param r ray
---@param t_min number
---@param t_max number
---@param rec hit_record
---@return boolean
function translate:hit(r, t_min, t_max, rec)
	local moved_ray = ray(r.origin - self.offset, r.direction, r.time)
	if not self.object:hit(moved_ray, t_min, t_max, rec) then
		return false
	end

	rec.p = rec.p + self.offset
	rec:set_face_normal(moved_ray, rec.normal)

	return true
end

---Get the bounding box of the hittable object
---@param time0 number
---@param time1 number
---@param output_box aabb
---@return boolean
function translate:bounding_box(time0, time1, output_box)
	if not self.object:bounding_box(time0, time1, output_box) then
		return false
	end

	output_box:replace(aabb(output_box.minimum + self.offset, output_box.maximum + self.offset))
	return true
end

return translate
