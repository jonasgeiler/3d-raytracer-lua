local class = require('lib.class')

---@class hittable
local hittable = class()

function hittable:hit()
	error('Not hit method defined for hittable object')
end

return hittable
