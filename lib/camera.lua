local class = require('lib.class')
local vec3 = require('lib.vec3')
local ray = require('lib.ray')
local utils = require('lib.utils')

---@class camera
---@field origin point3
---@field lower_left_corner point3
---@field horizontal vec3
---@field vertical vec3
---@field u vec3
---@field v vec3
---@field w vec3
---@field lens_radius number
local camera = class()

---@param lookfrom point3
---@param lookat point3
---@param vup vec3
---@param vfov number @Vertical field-of-view in degrees
---@param aspect_ratio number
---@param aperture number
---@param focus_dist number
function camera:new(lookfrom, lookat, vup, vfov, aspect_ratio, aperture, focus_dist)
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
end

---@param s number
---@param t number
---@return ray
function camera:get_ray(s, t)
    local rd = self.lens_radius * vec3.random_in_unit_disk()
    local offset = self.u * rd.x + self.v * rd.y

    return ray(
        self.origin + offset,
        self.lower_left_corner + s * self.horizontal + t * self.vertical - self.origin - offset
    )
end

return camera
