local class = require('lib.class')

---@class hittable
local hittable = class()

---@param r ray
---@param t_min number
---@param t_max number
---@param rec hit_record
---@return boolean
function hittable:hit(r, t_min, t_max, rec)
	error('Not hit method defined for hittable object')
	return false
end

return hittable
