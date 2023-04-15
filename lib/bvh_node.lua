local class = require('lib.class')
local hittable = require('lib.hittable')
local aabb = require('lib.aabb')
local utils = require('lib.utils')

---Compare two boxes
---@param a hittable
---@param b hittable
---@param axis integer
---@nodiscard
local function box_compare(a, b, axis)
	local box_a = aabb()
	local box_b = aabb()

	if not a:bounding_box(0, 0, box_a) or not b:bounding_box(0, 0, box_b) then
		error('No bounding box in bvh_node constructor')
	end

	return box_a.minimum:axis(axis) < box_b.minimum:axis(axis)
end

---Compare two boxes by x
---@param a hittable
---@param b hittable
---@nodiscard
local function box_x_compare(a, b)
	return box_compare(a, b, 0)
end

---Compare two boxes by y
---@param a hittable
---@param b hittable
---@nodiscard
local function box_y_compare(a, b)
	return box_compare(a, b, 1)
end

---Compare two boxes by z
---@param a hittable
---@param b hittable
---@nodiscard
local function box_z_compare(a, b)
	return box_compare(a, b, 2)
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
---@param _objects hittable_list|hittable[]
---@param _from number
---@param _to number
---@param _time0 number?
---@param _time1 number?
---@overload fun(self: bvh_node, list: hittable_list, time0: number, time1: number): bvh_node
---@overload fun(self: bvh_node, src_objects: hittable[], start: integer, end: integer, time0: number, time1: number): bvh_node
function bvh_node:new(_objects, _from, _to, _time0, _time1)
	local given_hittable_list = _objects.objects and true or false
	local objects	= given_hittable_list and _objects.objects or _objects
	local from = given_hittable_list and 0 or _from
	local to = given_hittable_list and #_objects.objects or _to
	local time0 = given_hittable_list and _from or _time0
	local time1 = given_hittable_list and _to or _time1

	local axis = math.random(0, 2)
	local comparator = axis == 0 and box_x_compare or (axis == 1 and box_y_compare or box_z_compare)

	local object_span = to - from

	if object_span == 1 then
		self.left = objects[from + 1]
		self.right = objects[from + 1]
	elseif object_span == 2 then
		if comparator(objects[from + 1], objects[from + 2]) then
			self.left = objects[from + 1]
			self.right = objects[from + 2]
		else
			self.left = objects[from + 2]
			self.right = objects[from + 1]
		end
	else
		utils.sort_range(objects, from, to, comparator)

		local mid = math.floor(from + object_span / 2)
		self.left = bvh_node(objects, from, mid, time0, time1)
		self.right = bvh_node(objects, mid, to, time0, time1)
	end

	local box_left = aabb()
	local box_right = aabb()
	if not self.left:bounding_box(time0, time1, box_left) or not self.right:bounding_box(time0, time1, box_right) then
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
	output_box:replace_with(self.box)
	return true
end

return bvh_node
