local class = require('lib.middleclass')

local hittable = class('hittable')

function hittable:hit()
	error('Not hit method defined for hittable object')
end

return hittable
