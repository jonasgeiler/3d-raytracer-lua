local class = require('lib.middleclass')
local vec3 = require('lib.vec3')
local utils= require('lib.utils')

local point3 = vec3 -- alias
local color = vec3 -- alias

local ppm = class('ppm')

function ppm:initialize(path, width, height, use_ascii)
	use_ascii = use_ascii or false
	assert(type(path) == 'string', 'Invalid ppm path: ' .. type(path))
	assert(type(width) == 'number' and type(height) == 'number', 'Invalid ppm width/height: ' .. type(width) .. ', ' .. type(height))
	assert(type(use_ascii) == 'boolean', 'Invalid ppm mode boolean: ' .. type(use_ascii))

	local image, err = io.open(path, use_ascii and 'w' or 'wb')
	assert(image, err)

	image:write(use_ascii and 'P3' or 'P6', '\n', width, ' ', height, '\n255\n')

	self.image = image
	self.use_ascii = use_ascii
end

function ppm:write_color(pixel_color, samples_per_pixel)
	assert(type(pixel_color) == 'table' and pixel_color.class == color, 'Invalid ppm pixel color: ' .. type(pixel_color))
	assert(type(samples_per_pixel) == 'number', 'Invalid samples per pixel: ' .. type(samples_per_pixel))

	local scale = 1 / samples_per_pixel
	local r, g, b = pixel_color.x * scale, pixel_color.y * scale, pixel_color.z * scale

	if self.use_ascii then
		self.image:write(
			math.floor(256 * utils.clamp(r, 0, 0.999)), ' ',
			math.floor(256 * utils.clamp(g, 0, 0.999)), ' ',
			math.floor(256 * utils.clamp(b, 0, 0.999)), '\n'
		)
	else
		self.image:write(
			string.char(math.floor(256 * utils.clamp(r, 0, 0.999))),
			string.char(math.floor(256 * utils.clamp(g, 0, 0.999))),
			string.char(math.floor(256 * utils.clamp(b, 0, 0.999)))
		)
	end
end

function ppm:close()
	self.image:close()
end

return ppm
