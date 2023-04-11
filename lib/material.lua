local class = require('lib.class')

---@class material
local material = class()

---@param r_in ray
---@param rec hit_record
---@param attenuation color
---@param scattered ray
---@return boolean
function material:scatter(r_in, rec, attenuation, scattered)
	error('Not scatter method defined for material')
	return false
end

return material
