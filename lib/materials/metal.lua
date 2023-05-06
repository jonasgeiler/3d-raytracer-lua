local class = require('lib.class')
local material = require('lib.base.material')
local vec3 = require('lib.vec3')

---Represents a metalic material
---@class metal : material
---@overload fun(albedo: color, fuzz: number): metal
---@field albedo color
---@field fuzz number
local metal = class(material)

---Init the material
---@param albedo color
---@param fuzz number
function metal:new(albedo, fuzz)
	self.albedo = albedo
	self.fuzz = fuzz < 1 and fuzz or 1
end

---Scatter and color a ray that hits the material
---@param r_in ray
---@param rec hit_record
---@param attenuation color
---@param scattered ray
---@return boolean
function metal:scatter(r_in, rec, attenuation, scattered)
	local reflected = r_in.direction:unit_vector():reflect(rec.normal)
	scattered:set(rec.p, reflected + vec3.random_in_unit_sphere() * self.fuzz, r_in.time)
	attenuation:replace(self.albedo)
	return scattered.direction:dot(rec.normal) > 0
end

return metal
