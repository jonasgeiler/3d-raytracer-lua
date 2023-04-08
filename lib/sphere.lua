local class = require('lib.middleclass')
local vec3 = require('lib.vec3')
local hittable = require('lib.hittable')
local ray = require('lib.ray')
local hit_record = require('lib.hit_record')

local point3 = vec3 -- alias
local color = vec3 -- alias

local sphere = class('sphere', hittable)

function sphere:initialize(center, radius)
	assert(type(center) == 'table' and center.class == point3, 'Invalid sphere center: ' .. type(center))
	assert(type(radius) == 'number', 'Invalid sphere radius: ' .. type(radius))

	self.center = center
	self.radius = radius
end

function sphere:hit(r, t_min, t_max, rec)
	assert(type(r) == 'table' and r.class == ray, 'Invalid sphere hit ray: ' .. type(r))
	assert(type(t_min) == 'number', 'Invalid sphere hit t-min: ' .. type(t_min))
	assert(type(t_max) == 'number', 'Invalid sphere hit t-max: ' .. type(t_max))
	assert(type(rec) == 'table' and rec.class == hit_record, 'Invalid sphere hit record: ' .. type(rec))

	local oc = r.origin - self.center
	local a = r.direction:length_squared()
	local half_b = oc:dot(r.direction)
	local c = oc:length_squared() - self.radius*self.radius

	local discriminant = half_b*half_b - a*c
	if discriminant < 0 then return false end
	local sqrtd = math.sqrt(discriminant)

	local root = (-half_b - sqrtd) / a
	if root < t_min or t_max < root then
		root = (-half_b + sqrtd) / a
		if root < t_min or t_max < root then
			return false
		end
	end

	rec.t = root
	rec.p = r:at(rec.t)
	local outward_normal = (rec.p - self.center) / self.radius
	rec:set_face_normal(r, outward_normal)

	return true
end

return sphere
