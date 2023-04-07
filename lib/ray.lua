local class = require('lib.middleclass')
local vec3 = require('lib.vec3')

local point3 = vec3 -- alias
local color = vec3 -- alias

local ray = class('ray')

function ray:initialize(origin, direction)
	assert(origin.class == point3, 'Invalid ray origin: ' .. type(origin))
	assert(direction.class == vec3, 'Invalid ray direction: ' .. type(direction))
	self.origin = origin
	self.direction = direction
end

function ray:at(t)
	return self.origin + t * self.direction
end

return ray
