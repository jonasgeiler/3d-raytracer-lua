local class = require('lib.class')
local ray = require('lib.ray')
local material = require('lib.material')
local vec3 = require('lib.vec3')

---@class metal : material
---@field albedo color
---@field fuzz number
local metal = class(material)

---@param albedo color
---@param fuzz number
function metal:new(albedo, fuzz)
	self.albedo = albedo
	self.fuzz = fuzz < 1 and fuzz or 1
end

---@param r_in ray
---@param rec hit_record
---@param attenuation color
---@param scattered ray
---@return boolean
function metal:scatter(r_in, rec, attenuation, scattered)
	local reflected = r_in.direction:unit_vector():reflect(rec.normal)
	scattered:replace_with(ray(rec.p, reflected + self.fuzz*vec3.random_in_unit_sphere()))
	attenuation:replace_with(self.albedo)
	return scattered.direction:dot(rec.normal) > 0
end

return metal