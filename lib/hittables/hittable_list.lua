local class = require('lib.class')
local hittable = require('lib.base.hittable')
local aabb = require('lib.aabb')
local hit_record = require('lib.hit_record')

---Represents a list of htitable objects
---@class hittable_list : hittable
---@overload fun(): hittable_list
---@field objects hittable[]
local hittable_list = class(hittable)

---Init the hittable list
function hittable_list:new()
	self.objects = {}
end

---Clear the hittable list
function hittable_list:clear()
	for i = 1, #self.objects do
		self.objects[i] = nil
	end
end

---Add a hittable object to the list
---@param object hittable
function hittable_list:add(object)
	self.objects[#self.objects + 1] = object
end

---Check if a ray hits any of the objects in the list
---@param r ray
---@param t_min number
---@param t_max number
---@param rec hit_record
---@return boolean
function hittable_list:hit(r, t_min, t_max, rec)
	local temp_rec = hit_record()
	local hit_anything = false
	local closest_so_far = t_max

	for i = 1, #self.objects do
		if self.objects[i]:hit(r, t_min, closest_so_far, temp_rec) then
			hit_anything = true
			closest_so_far = temp_rec.t
			rec:replace(temp_rec)
		end
	end

	return hit_anything
end

---Get the bounding box of the objects in the list
---@param time0 number
---@param time1 number
---@param output_box aabb
---@return boolean
function hittable_list:bounding_box(time0, time1, output_box)
	if #self.objects == 0 then return false end

	local temp_box = aabb()
	local first_box = true

	for i = 1, #self.objects do
		if not self.objects[i]:bounding_box(time0, time1, temp_box) then
			return false
		end

		output_box:replace(first_box and temp_box or aabb.surrounding_box(output_box, temp_box))
		first_box = false
	end

	return true
end

return hittable_list
