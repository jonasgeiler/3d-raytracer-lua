local class = require('lib.middleclass')
local vec3  = require('lib.vec3')
local ray   = require('lib.ray')

local point3 = vec3 -- alias
local color = vec3 -- alias

local camera = class('camera')

function camera:initialize()
	local aspect_ratio = 16 / 9
	local viewport_height = 2
	local viewport_width = aspect_ratio * viewport_height
	local focal_length = 1

	self.origin = point3(0, 0, 0)
	self.horizontal = vec3(viewport_width, 0, 0)
	self.vertical = vec3(0, viewport_height, 0)
	self.lower_left_corner = self.origin - self.horizontal/2 - self.vertical/2 - vec3(0, 0, focal_length)
end

function camera:get_ray(u, v)
	assert(type(u) == 'number', 'Invalid u for getting camera ray: ' .. type(u))
	assert(type(v) == 'number', 'Invalid v for getting camera ray: ' .. type(v))
	return ray(self.origin, self.lower_left_corner + u*self.horizontal + v*self.vertical - self.origin)
end

return camera
