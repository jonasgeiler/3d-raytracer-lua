local class = require('lib.class')

---Stores the hit info on a hittable object
---@class hit_record
---@overload fun(): hit_record
---@field p point3
---@field normal vec3
---@field mat material
---@field t number
---@field u number
---@field v number
---@field front_face boolean
local hit_record = class()

---Init the hit record
function hit_record:new()
	self.p = nil
	self.normal = nil
	self.mat = nil
	self.t = nil
	self.u = nil
	self.v = nil
	self.front_face = nil
end

---Replace the hit record with another one
---@param new_hit_record hit_record
function hit_record:replace(new_hit_record)
	self.p = new_hit_record.p
	self.normal = new_hit_record.normal
	self.mat = new_hit_record.mat
	self.t = new_hit_record.t
	self.u = new_hit_record.u
	self.v = new_hit_record.v
	self.front_face = new_hit_record.front_face
end

---Set the face normal
---@param r ray
---@param outward_normal vec3
function hit_record:set_face_normal(r, outward_normal)
	self.front_face = r.direction:dot(outward_normal) < 0
	self.normal = self.front_face and outward_normal or -outward_normal
end

return hit_record
