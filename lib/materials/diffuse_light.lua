local class = require('lib.class')
local material = require('lib.base.material')
local solid_color = require('lib.textures.solid_color')

---Represents a light emitting material
---@class diffuse_light : material
---@overload fun(emit: color|texture): diffuse_light
---@field emit texture
local diffuse_light = class(material)

---Init the material
---@param emit color|texture
function diffuse_light:new(emit)
	if emit.x and emit.y and emit.z then
		---@cast emit color
		self.emit = solid_color(emit)
	else
		---@cast emit texture
		self.emit = emit
	end
end

---Scatter and color a ray that hits the material
---@param r_in ray
---@param rec hit_record
---@param attenuation color
---@param scattered ray
---@return boolean
function diffuse_light:scatter(r_in, rec, attenuation, scattered)
	return false
end

---Returns the emitted color of the material
---@param u number
---@param v number
---@param p point3
---@return color
---@nodiscard
function diffuse_light:emitted(u, v, p)
	return self.emit:value(u, v, p)
end

return diffuse_light
