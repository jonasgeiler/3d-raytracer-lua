local class = require('lib.middleclass')
local hittable = require('lib.hittable')
local ray = require('lib.ray')
local hit_record = require('lib.hit_record')

local hittable_list = class('hittable_list', hittable)

function hittable_list:initialize(object)
	self.objects = {}

	if object then
		self:add(object)
	end
end

function hittable_list:clear()
	for i in pairs(self.objects) do
		self.objects[i] = nil
	end
end

function hittable_list:add(object)
	assert(type(object) == 'table' and object.isInstanceOf and object:isInstanceOf(hittable), 'Invalid object for hittable list: ' .. type(object))
	table.insert(self.objects, object)
end

function hittable_list:hit(r, t_min, t_max, rec)
	assert(type(r) == 'table' and r.class == ray, 'Invalid hitable_list hit ray: ' .. type(r))
	assert(type(t_min) == 'number', 'Invalid hitable_list hit t-min: ' .. type(t_min))
	assert(type(t_max) == 'number', 'Invalid hitable_list hit t-max: ' .. type(t_max))
	assert(type(rec) == 'table' and rec.class == hit_record, 'Invalid hitable_list hit record: ' .. type(rec))

	local temp_rec = hit_record()
	local hit_anything = false
	local closest_so_far = t_max

	for i, object in ipairs(self.objects) do
		if object:hit(r, t_min, closest_so_far, temp_rec) then
			hit_anything = true
			closest_so_far = temp_rec.t
			rec:replace_with(temp_rec)
		end
	end

	return hit_anything
end

return hittable_list
