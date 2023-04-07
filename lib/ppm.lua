local class = require('lib.middleclass')
local vec3 = require('lib.vec3')

local point3 = vec3 -- alias
local color = vec3 -- alias

local ppm = class('ppm')

function ppm:initialize(path, width, height)
	assert(type(path) == 'string', 'Invalid ppm path: ' .. type(path))
	assert(type(width) == 'number' and type(height) == 'number', 'Invalid ppm width/height: ' .. type(width) .. ', ' .. type(height))

	local image, err = io.open(path, 'w')
	assert(image, err)

	image:write('P3\n' .. width .. ' ' .. height .. '\n255\n');

	self.image = image
end

function ppm:write_color(pixel_color)
	assert(pixel_color.class == color, 'Invalid ppm pixel color: ' .. type(pixel_color))
	self.image:write(math.floor(255.999 * pixel_color.x) .. ' ' .. math.floor(255.999 * pixel_color.y) .. ' ' .. math.floor(255.999 * pixel_color.z) .. '\n')
end

function ppm:close()
	self.image:close()
end

return ppm
