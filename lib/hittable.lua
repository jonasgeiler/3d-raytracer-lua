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

return hittable
