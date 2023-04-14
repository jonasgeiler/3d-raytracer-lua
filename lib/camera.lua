local class = require('lib.class')
local vec3 = require('lib.vec3')
local ray = require('lib.ray')
local utils = require('lib.utils')

---Represents the camera
---@class camera
---@overload fun(lookfrom: point3, lookat: point3, vup: vec3, vfov: number, aspect_ratio: number, aperture: number, focus_dist: number, time0: number, time1: number): camera
---@field origin point3
---@field lower_left_corner point3
---@field horizontal vec3
---@field vertical vec3
---@field u vec3
---@field v vec3
---@field w vec3
---@field lens_radius number
---@field time0 number
---@field time1 number
local camera = class()

---Init the camera
---@param lookfrom point3
---@param lookat point3
---@param vup vec3
---@param vfov number Vertical field-of-view in degrees
---@param aspect_ratio number
---@param aperture number
---@param focus_dist number
---@param time0 number
---@param time1 number
function camera:new(lookfrom, lookat, vup, vfov, aspect_ratio, aperture, focus_dist, time0, time1)
	local theta = utils.degrees_to_radians(vfov)
	local h = math.tan(theta / 2)
	local viewport_height = 2.0 * h
	local viewport_width = aspect_ratio * viewport_height

	self.w = (lookfrom - lookat):unit_vector()
	self.u = vup:cross(self.w):unit_vector()
	self.v = self.w:cross(self.u)

	self.origin = lookfrom
	self.horizontal = focus_dist * viewport_width * self.u
	self.vertical = focus_dist * viewport_height * self.v
	self.lower_left_corner = self.origin - self.horizontal / 2 - self.vertical / 2 - focus_dist * self.w

	self.lens_radius = aperture / 2
	self.time0 = time0
	self.time1 = time1
end

---Get a ray from the camera
---@param s number
---@param t number
---@return ray
---@nodiscard
function camera:get_ray(s, t)
	local rd = vec3.random_in_unit_disk() * self.lens_radius
	local offset = self.u * rd.x + self.v * rd.y

	return ray(
		self.origin + offset,
		self.lower_left_corner + self.horizontal * s + self.vertical * t - self.origin - offset,
		utils.random_float(self.time0, self.time1)
	)
end

return camera
