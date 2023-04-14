local class = require('lib.class')

---Represents a hittable object
---@class hittable
---@overload fun(): hittable
local hittable = class()

---Check if a ray hits the hittable object
---@param r ray
---@param t_min number
---@param t_max number
---@param rec hit_record
---@return boolean
function hittable:hit(r, t_min, t_max, rec)
	error('Not hit method defined for hittable object')
end

---Get the bounding box of the hittable object
---@param time0 number
---@param time1 number
---@param output_box aabb
---@return boolean
function hittable:bounding_box(time0, time1, output_box)
	error('Not bounding_box method defined for hittable object')
end

return hittable
