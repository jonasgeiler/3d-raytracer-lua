local class = require('lib.middleclass')
local ray = require('lib.ray')
local vec3 = require('lib.vec3')

local point3 = vec3 -- alias
local color = vec3 -- alias

local hit_record = class('hit_record')

function hit_record:initialize()
	self.p = nil
	self.normal = nil
	self.t = nil
	self.front_face = nil
end

function hit_record:replace_with(new_hit_record)
	self.p = new_hit_record.p
	self.normal = new_hit_record.normal
	self.t = new_hit_record.t
	self.front_face = new_hit_record.front_face
end

function hit_record:set_face_normal(r, outward_normal)
	assert(type(r) == 'table' and r.class == ray, 'Invalid ray for face normal: ' .. type(r))
	assert(type(outward_normal) == 'table' and outward_normal.class == vec3, 'Invalid outward normal for face normal: ' .. type(outward_normal))
	self.front_face = r.direction:dot(outward_normal) < 0
	self.normal = self.front_face and outward_normal or -outward_normal
end

return hit_record
