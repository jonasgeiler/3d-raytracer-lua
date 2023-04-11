local class = require('lib.class')
local hittable = require('lib.hittable')
local hit_record = require('lib.hit_record')

---@class hittable_list : hittable
---@field objects hittable[]
local hittable_list = class(hittable)

---@param object hittable
function hittable_list:new(object)
	self.objects = {}

	if object then
		self:add(object)
	end
end

function hittable_list:clear()
	for i = 1, #self.objects do
		self.objects[i] = nil
	end
end

---@param object hittable
function hittable_list:add(object)
	self.objects[#self.objects + 1] = object
end

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
			rec:replace_with(temp_rec)
		end
	end

	return hit_anything
end

return hittable_list
