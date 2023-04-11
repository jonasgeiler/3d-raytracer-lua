local class = require('lib.class')
local vec3 = require('lib.vec3')
local point3 = require('lib.point3')
local ray = require('lib.ray')
local utils = require('lib.utils')

---@class camera
---@field origin point3
---@field horizontal vec3
---@field vertical vec3
---@field lower_left_corner vec3
local camera = class()

---@param vfov number @Vertical field-of-view in degrees
---@param aspect_ratio number
function camera:new(vfov, aspect_ratio)
    local theta = utils.degrees_to_radians(vfov)
    local h = math.tan(theta / 2)
    local viewport_height = 2.0 * h
    local viewport_width = aspect_ratio * viewport_height

    local focal_length = 1.0

    self.origin = point3(0, 0, 0)
    self.horizontal = vec3(viewport_width, 0.0, 0.0)
    self.vertical = vec3(0.0, viewport_height, 0.0)
    self.lower_left_corner = self.origin - self.horizontal / 2 - self.vertical / 2 - vec3(0, 0, focal_length)
end

---@param u number
---@param v number
---@return ray
function camera:get_ray(u, v)
    return ray(self.origin, self.lower_left_corner + u * self.horizontal + v * self.vertical - self.origin)
end

return camera
