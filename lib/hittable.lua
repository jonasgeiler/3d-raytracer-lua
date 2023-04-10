local class = require('lib.middleclass')

---@class hittable
local hittable = class('hittable')

function hittable:hit()
	error('Not hit method defined for hittable object')
end

return hittable
