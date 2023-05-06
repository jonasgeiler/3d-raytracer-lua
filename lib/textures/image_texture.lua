local math = math
local class = require('lib.class')
local texture = require('lib.base.texture')
local ppm = require('lib.ppm')
local utils = require('lib.utils')


---Represents an image texture
---@class image_texture : texture
---@overload fun(filename: string): image_texture
---@field image ppm
local image_texture = class(texture)

---Init the texture
---@param filename string A path to a PPM file to use as texture
function image_texture:new(filename)
	self.image = ppm(filename)
end

---Get color value of the texture
---@param u number
---@param v number
---@param p point3
---@return color
---@nodiscard
function image_texture:value(u, v, p)
	u = utils.clamp(u, 0, 1)
	v = 1 - utils.clamp(v, 0, 1)

	local x = math.floor(u * self.image.width)
	local y = math.floor(v * self.image.height)

	if x >= self.image.width then x = self.image.width - 1 end
	if y >= self.image.height then y = self.image.height - 1 end

	return self.image:get_pixel(x, y)
end

return image_texture
