local class       = require('lib.class')
local texture     = require('lib.base.texture')
local color       = require('lib.color')
local ppm         = require('lib.ppm')
local utils       = require('lib.utils')

local COLOR_SCALE = 1.0 / 255.0


---Represents an image texture
---@class image_texture : texture
---@overload fun(filename: string): image_texture
---@field image ppm
---@field image_width integer
---@field image_height integer
local image_texture = class(texture)

---Init the texture
---@param filename string A path to a PPM file to use as texture
function image_texture:new(filename)
	self.image = ppm(filename, true)
	self.image_width, self.image_height = self.image:read_head()
end

---Get color value of the texture
---@param u number
---@param v number
---@param p point3
---@return color
---@nodiscard
function image_texture:value(u, v, p)
	u = utils.clamp(u, 0.0, 1.0)
	v = 1.0 - utils.clamp(v, 0.0, 1.0)

	local x = math.floor(u * self.image_width)
	local y = math.floor(v * self.image_height)

	if x >= self.image_width then x = self.image_width - 1 end
	if y >= self.image_height then y = self.image_height - 1 end

	local pixel_color = self.image:read_color(x, y)
	return color(pixel_color.x * COLOR_SCALE, pixel_color.y * COLOR_SCALE, pixel_color.z * COLOR_SCALE)
end

return image_texture
