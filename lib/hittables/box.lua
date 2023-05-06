local class = require('lib.class')
local hittable = require('lib.base.hittable')
local hittable_list = require('lib.hittables.hittable_list')
local xy_rect = require('lib.hittables.xy_rect')
local xz_rect = require('lib.hittables.xz_rect')
local yz_rect = require('lib.hittables.yz_rect')
local aabb = require('lib.aabb')

---Represents a hittable box
---@class box : hittable
---@overload fun(p0: point3, p1: point3, mat: material): box
---@field box_min point3
---@field box_max point3
---@field sides hittable_list
local box = class(hittable)

---Init the box
function box:new(p0, p1, mat)
	self.box_min = p0
	self.box_max = p1

	self.sides = hittable_list()

	self.sides:add(xy_rect(p0.x, p1.x, p0.y, p1.y, p1.z, mat))
	self.sides:add(xy_rect(p0.x, p1.x, p0.y, p1.y, p0.z, mat))

	self.sides:add(xz_rect(p0.x, p1.x, p0.z, p1.z, p1.y, mat))
	self.sides:add(xz_rect(p0.x, p1.x, p0.z, p1.z, p0.y, mat))

	self.sides:add(yz_rect(p0.y, p1.y, p0.z, p1.z, p1.x, mat))
	self.sides:add(yz_rect(p0.y, p1.y, p0.z, p1.z, p0.x, mat))
end

---Check if a ray hits the hittable object
---@param r ray
---@param t_min number
---@param t_max number
---@param rec hit_record
---@return boolean
function box:hit(r, t_min, t_max, rec)
	return self.sides:hit(r, t_min, t_max, rec)
end

---Get the bounding box of the hittable object
---@param time0 number
---@param time1 number
---@param output_box aabb
---@return boolean
function box:bounding_box(time0, time1, output_box)
	output_box:replace(aabb(self.box_min, self.box_max))
	return true
end

return box
