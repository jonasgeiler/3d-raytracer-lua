local class = require('lib.class')
local vec3 = require('lib.vec3')
local point3 = require('lib.point3')
local ray = require('lib.ray')

---@class camera
---@field origin point3
---@field horizontal vec3
---@field vertical vec3
---@field lower_left_corner vec3
local camera = class()

function camera:new()
    local aspect_ratio = 16 / 9
    local viewport_height = 2
    local viewport_width = aspect_ratio * viewport_height
    local focal_length = 1

    self.origin = point3(0, 0, 0)
    self.horizontal = vec3(viewport_width, 0, 0)
    self.vertical = vec3(0, viewport_height, 0)
    self.lower_left_corner = self.origin - self.horizontal / 2 - self.vertical / 2 - vec3(0, 0, focal_length)
end

---@param u number
---@param v number
---@return ray
function camera:get_ray(u, v)
    return ray(self.origin, self.lower_left_corner + u * self.horizontal + v * self.vertical - self.origin)
end

return camera
