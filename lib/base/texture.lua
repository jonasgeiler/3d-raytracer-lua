local class = require('lib.class')

---Represents a texture
---@class texture
---@overload fun(): texture
local texture = class()

---Get color value of the texture
---@param u number
---@param v number
---@param p point3
---@return color
function texture:value(u, v, p)
	error('No value method defined for texture')
end

return texture
