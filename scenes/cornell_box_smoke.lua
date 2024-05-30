local color = require('lib.color')
local point3 = require('lib.point3')
local vec3 = require('lib.vec3')
local box = require('lib.hittables.box')
local constant_medium = require('lib.hittables.constant_medium')
local hittable_list = require('lib.hittables.hittable_list')
local rotate_y = require('lib.hittables.rotate_y')
local translate = require('lib.hittables.translate')
local xy_rect = require('lib.hittables.xy_rect')
local xz_rect = require('lib.hittables.xz_rect')
local yz_rect = require('lib.hittables.yz_rect')
local diffuse_light = require('lib.materials.diffuse_light')
local lambertian = require('lib.materials.lambertian')
local raytracer = require('lib.raytracer')

local world = hittable_list()

local red = lambertian(color(0.65, 0.05, 0.05))
local white = lambertian(color(0.73, 0.73, 0.73))
local green = lambertian(color(0.12, 0.45, 0.15))
local light = diffuse_light(color(7, 7, 7))

-- room
world:add(yz_rect(0, 555, 0, 555, 555, green))  -- left wall
world:add(yz_rect(0, 555, 0, 555, 0, red))      -- right wall
world:add(xz_rect(113, 443, 127, 432, 554, light)) -- roof light
world:add(xz_rect(0, 555, 0, 555, 555, white))  -- roof
world:add(xz_rect(0, 555, 0, 555, 0, white))    -- floor
world:add(xy_rect(0, 555, 0, 555, 555, white))  -- back wall

-- boxes
local box1 = box(point3(0, 0, 0), point3(165, 330, 165), white) ---@type hittable
box1 = rotate_y(box1, 15)
box1 = translate(box1, vec3(265, 0, 295))
world:add(constant_medium(box1, 0.01, color(0, 0, 0)))

local box2 = box(point3(0, 0, 0), point3(165, 165, 165), white) ---@type hittable
box2 = rotate_y(box2, -18)
box2 = translate(box2, vec3(130, 0, 65))
world:add(constant_medium(box2, 0.01, color(1, 1, 1)))

local rt = raytracer(world)
	:set_aspect_ratio(1)
	:set_image_width(600)
	:set_samples_per_pixel(200)
	:set_look_from(point3(278, 278, -800))
	:set_look_at(point3(278, 278, 0))
	:set_vertical_fov(40)

rt:render('./renders/cornell_box_smoke.ppm')
