local class = require('lib.class')
local material = require('lib.base.material')
local ray = require('lib.ray')
local vec3 = require('lib.vec3')
local solid_color = require('lib.textures.solid_color')

---Represents a lambertian (matte) material
---@class lambertian : material
---@overload fun(albedo: color|texture): lambertian
---@field albedo texture
local lambertian = class(material)

---Init the material
---@param albedo color|texture
function lambertian:new(albedo)
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
function lambertian:scatter(r_in, rec, attenuation, scattered)
	local scatter_direction = rec.normal + vec3.random_unit_vector()

	if scatter_direction:near_zero() then
		scatter_direction = rec.normal
	end

	scattered:replace(ray(rec.p, scatter_direction, r_in.time))
	attenuation:replace(self.albedo:value(rec.u, rec.v, rec.p))
	return true
end

return lambertian
