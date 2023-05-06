local error = error
local class = require('lib.class')
local color = require('lib.color')

---Represents a material
---@class material
---@overload fun(): material
local material = class()

---Scatter and color a ray that hits the material
---@param r_in ray
---@param rec hit_record
---@param attenuation color
---@param scattered ray
---@return boolean
function material:scatter(r_in, rec, attenuation, scattered)
	error('Not scatter method defined for material')
end

---Returns the emitted color of the material
---@param u number
---@param v number
---@param p point3
---@return color
---@nodiscard
function material:emitted(u, v, p)
	return color(0, 0, 0)
end

return material
