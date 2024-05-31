local error = error
local math = math
local class = require('lib.class')
local hittable = require('lib.base.hittable')
local aabb = require('lib.aabb')
local utils = require('lib.utils')

---Compare two boxes
---@param a hittable
---@param b hittable
---@param axis 'x'|'y'|'z'
---@nodiscard
local function box_compare(a, b, axis)
	local box_a = aabb()
	local box_b = aabb()

	if not a:bounding_box(0, 0, box_a) or not b:bounding_box(0, 0, box_b) then
		error('No bounding box in bvh_node constructor')
	end

	return box_a.minimum[axis] < box_b.minimum[axis]
end

---Compare two boxes by x
---@param a hittable
---@param b hittable
---@nodiscard
local function box_x_compare(a, b)
	return box_compare(a, b, 'x')
end

---Compare two boxes by y
---@param a hittable
---@param b hittable
---@nodiscard
local function box_y_compare(a, b)
	return box_compare(a, b, 'y')
end

---Compare two boxes by z
---@param a hittable
---@param b hittable
---@nodiscard
local function box_z_compare(a, b)
	return box_compare(a, b, 'z')
end


---Represents a Bounding Volume Hierarchy (BVH) Node
---@class bvh_node : hittable
---@overload fun(list: hittable_list, time0: number, time1: number): bvh_node
---@overload fun(src_objects: hittable[], start: integer, end: integer, time0: number, time1: number): bvh_node
---@field left hittable
---@field right hittable
---@field box aabb
local bvh_node = class(hittable)

---Init a new BVH Node
---@param objects hittable_list|hittable[]
---@param from number
---@param to number
---@param time0 number?
---@param time1 number?
function bvh_node:new(objects, from, to, time0, time1)
	local given_hittable_list = objects.objects and true or false
	local _objects = given_hittable_list and objects.objects or objects
	local _from = given_hittable_list and 0 or from
	local _to = given_hittable_list and #objects.objects or to
	local _time0 = given_hittable_list and from or time0
	local _time1 = given_hittable_list and to or time1

	local axis = math.random(0, 2)
	local comparator = axis == 0 and box_x_compare or (axis == 1 and box_y_compare or box_z_compare)

	local object_span = _to - _from

	if object_span == 1 then
		self.left = _objects[_from + 1]
		self.right = _objects[_from + 1]
	elseif object_span == 2 then
		if comparator(_objects[_from + 1], _objects[_from + 2]) then
			self.left = _objects[_from + 1]
			self.right = _objects[_from + 2]
		else
			self.left = _objects[_from + 2]
			self.right = _objects[_from + 1]
		end
	else
		utils.sort_range(_objects, _from, _to, comparator)

		local mid = math.floor(_from + object_span / 2)
		self.left = bvh_node(_objects, _from, mid, _time0, _time1)
		self.right = bvh_node(_objects, mid, _to, _time0, _time1)
	end

	local box_left = aabb()
	local box_right = aabb()
	if not self.left:bounding_box(_time0, _time1, box_left) or not self.right:bounding_box(_time0, _time1, box_right) then
		error('No bounding box in bvh_node constructor')
	end

	self.box = aabb.surrounding_box(box_left, box_right)
end

---Check if a ray hits the BVH Node
---@param r ray
---@param t_min number
---@param t_max number
---@param rec hit_record
---@return boolean
function bvh_node:hit(r, t_min, t_max, rec)
	if not self.box:hit(r, t_min, t_max) then
		return false
	end

	local hit_left = self.left:hit(r, t_min, t_max, rec)
	local hit_right = self.right:hit(r, t_min, hit_left and rec.t or t_max, rec)

	return hit_left or hit_right
end

---Get the bounding box of the BVH Node
---@param time0 number
---@param time1 number
---@param output_box aabb
---@return boolean
function bvh_node:bounding_box(time0, time1, output_box)
	output_box:replace(self.box)
	return true
end

return bvh_node
