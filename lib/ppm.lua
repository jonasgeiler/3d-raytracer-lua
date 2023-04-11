local class = require('lib.class')
local utils= require('lib.utils')

---@class ppm
---@field image file
---@field use_ascii boolean
local ppm = class()

---@param path string
---@param width number
---@param height number
---@param use_ascii boolean
function ppm:new(path, width, height, use_ascii)
	use_ascii = use_ascii or false

	local image, err = io.open(path, use_ascii and 'w' or 'wb')
	assert(image, err)

	image:write(use_ascii and 'P3' or 'P6', '\n', width, ' ', height, '\n255\n')

	self.image = image
	self.use_ascii = use_ascii
end

---@param pixel_color color
---@param samples_per_pixel number
function ppm:write_color(pixel_color, samples_per_pixel)
	local scale = 1 / samples_per_pixel
	local r = math.floor(256 * utils.clamp(math.sqrt(pixel_color.x * scale), 0.0, 0.999))
	local g = math.floor(256 * utils.clamp(math.sqrt(pixel_color.y * scale), 0.0, 0.999))
	local b = math.floor(256 * utils.clamp(math.sqrt(pixel_color.z * scale), 0.0, 0.999))

	if r ~= r then r = 0 end
	if g ~= g then g = 0 end
	if b ~= b then b = 0 end

	if self.use_ascii then
		self.image:write(r, ' ', g, ' ', b, '\n')
	else
		self.image:write(string.char(r), string.char(g), string.char(b))
	end
end

function ppm:close()
	self.image:close()
end

return ppm
