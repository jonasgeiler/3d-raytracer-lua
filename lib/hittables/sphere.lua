local math = math
local class = require('lib.class')
local hittable = require('lib.base.hittable')

---Calculate the spherical UV coordinates
--- (1 0 0) yields <0.50 0.50>       (-1  0  0) yields <0.00 0.50>
--- (0 1 0) yields <0.50 1.00>       ( 0 -1  0) yields <0.50 0.00>
--- (0 0 1) yields <0.25 0.50>       ( 0  0 -1) yields <0.75 0.50>
---@param p point3 A given point on the sphere of radius one, centered at the origin
---@return number u Returned value [0,1] of angle around the Y axis from X=-1
---@return number v Returned value [0,1] of angle from Y=-1 to Y=+1
---@nodiscard
local function get_sphere_uv(p)
	local theta = math.acos(-p.y)
	local phi = math.atan2(-p.z, p.x) + math.pi

	return phi / (2 * math.pi), theta / math.pi
end


---Represents a hittable sphere
---@class sphere : hittable
---@overload fun(center: point3, radius: number, mat: material): sphere
---@field center point3
---@field radius number
---@field mat material
local sphere = class(hittable)

---Init the sphere
---@param center point3
---@param radius number
---@param mat material
function sphere:new(center, radius, mat)
	self.center = center
	self.radius = radius
	self.mat = mat
end

---Check if a ray hits the sphere
---@param r ray
---@param t_min number
---@param t_max number
---@param rec hit_record
---@return boolean
function sphere:hit(r, t_min, t_max, rec)
	local oc = r.origin - self.center
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
	local outward_normal = (rec.p - self.center) / self.radius
	rec:set_face_normal(r, outward_normal)
	rec.u, rec.v = get_sphere_uv(outward_normal)
	rec.mat = self.mat

	return true
end

---Get the bounding box of the sphere
---@param time0 number
---@param time1 number
---@param output_box aabb
---@return boolean
function sphere:bounding_box(time0, time1, output_box)
	output_box:set(self.center - self.radius, self.center + self.radius)
	return true
end

return sphere
