local class = require('lib.class')
local hittable = require('lib.hittable')

---Represents a moving hittable sphere
---@class moving_sphere : hittable
---@overload fun(): moving_sphere
---@field center0 point3
---@field center1 point3
---@field time0 number
---@field time1 number
---@field radius number
---@field mat material
local moving_sphere = class(hittable)

---Init the moving sphere
---@param center0 point3
---@param center1 point3
---@param time0 number
---@param time1 number
---@param radius number
---@param mat material
function moving_sphere:new(center0, center1, time0, time1, radius, mat)
	self.center0 = center0
	self.center1 = center1
	self.time0 = time0
	self.time1 = time1
	self.radius = radius
	self.mat = mat
end

---Check if a ray hits the moving sphere
---@param r ray
---@param t_min number
---@param t_max number
---@param rec hit_record
---@return boolean
function moving_sphere:hit(r, t_min, t_max, rec)
	local oc = r.origin - self:center(r.time)
	local a = r.direction:length_squared()
	local half_b = oc:dot(r.direction)
	local c = oc:length_squared() - self.radius * self.radius

	local discriminant = half_b * half_b - a * c
	if discriminant < 0 then return false end
	local sqrtd = math.sqrt(discriminant)

	local root = (-half_b - sqrtd) / a ---@type number
	if root < t_min or t_max < root then
		root = (-half_b + sqrtd) / a ---@type number
		if root < t_min or t_max < root then
			return false
		end
	end

	rec.t = root
	rec.p = r:at(rec.t)
	local outward_normal = (rec.p - self:center(r.time)) / self.radius
	rec:set_face_normal(r, outward_normal)
	rec.mat = self.mat

	return true
end

---Get the sphere center at a specific time
---@param time number
---@return point3
function moving_sphere:center(time)
	return self.center0 + (self.center1 - self.center0) * ((time - self.time0) / (self.time1 - self.time0))
end

return moving_sphere
