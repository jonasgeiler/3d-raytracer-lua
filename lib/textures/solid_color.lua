local class       = require('lib.class')
local texture     = require('lib.base.texture')
local color       = require('lib.color')

---Represents a solid color texture
---@class solid_color : texture
---@overload fun(red: number, green: number, blue: number): solid_color
---@overload fun(color: color): solid_color
---@field color_value color
local solid_color = class(texture)

---Init the texture
---@param red_or_color number|color
---@param green number?
---@param blue number?
function solid_color:new(red_or_color, green, blue)
	if type(red_or_color) == 'table' and red_or_color.x and red_or_color.y and red_or_color.z then
		self.color_value = red_or_color
	else
		---@cast red_or_color number
		self.color_value = color(red_or_color, green, blue)
	end
end

---Get color value of the texture
---@param u number
---@param v number
---@param p point3
---@return color
---@nodiscard
function solid_color:value(u, v, p)
	return self.color_value
end

return solid_color
