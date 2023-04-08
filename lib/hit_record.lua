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

function hit_record:set_face_normal(r, outward_normal)
	assert(r.class == ray, 'Invalid ray for face normal: ' .. type(r))
	assert(outward_normal.class == vec3, 'Invalid outward normal for face normal: ' .. type(outward_normal))
	self.front_face = r.direction:dot(outward_normal) < 0
	self.normal = self.front_face and outward_normal or -outward_normal
end

return hit_record
