local class = require('lib.class')
local material = require('lib.base.material')
local vec3 = require('lib.vec3')
local solid_color = require('lib.textures.solid_color')

---Represents a isotropic material
---@class isotropic : material
---@overload fun(albedo: color|texture): isotropic
---@field albedo texture
local isotropic = class(material)

---Init the material
---@param albedo color|texture
function isotropic:new(albedo)
	if albedo.x and albedo.y and albedo.z then
		---@cast albedo color
		self.albedo = solid_color(albedo)
	else
		---@cast albedo texture
		self.albedo = albedo
	end
end

---Scatter and color a ray that hits the material
---@param r_in ray
---@param rec hit_record
---@param attenuation color
---@param scattered ray
---@return boolean
function isotropic:scatter(r_in, rec, attenuation, scattered)
	scattered:set(rec.p, vec3.random_in_unit_sphere(), r_in.time)
	attenuation:replace(self.albedo:value(rec.u, rec.v, rec.p))
	return true
end

return isotropic
