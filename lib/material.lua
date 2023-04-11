local class = require('lib.class')

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

return material
