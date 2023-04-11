local class = require('lib.class')

---@class hit_record
---@field p point3
---@field normal vec3
---@field t number
---@field front_face boolean
local hit_record = class()

function hit_record:new()
	self.p = nil
	self.normal = nil
	self.t = nil
	self.front_face = nil
end

---@param new_hit_record hit_record
function hit_record:replace_with(new_hit_record)
	self.p = new_hit_record.p
	self.normal = new_hit_record.normal
	self.t = new_hit_record.t
	self.front_face = new_hit_record.front_face
end

---@param r ray
---@param outward_normal vec3
function hit_record:set_face_normal(r, outward_normal)
	self.front_face = r.direction:dot(outward_normal) < 0
	self.normal = self.front_face and outward_normal or -outward_normal
end

return hit_record
