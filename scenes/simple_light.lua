local color = require('lib.color')
local point3 = require('lib.point3')
local hittable_list = require('lib.hittables.hittable_list')
local sphere = require('lib.hittables.sphere')
local xy_rect = require('lib.hittables.xy_rect')
local noise_texture = require('lib.textures.noise_texture')
local diffuse_light = require('lib.materials.diffuse_light')
local lambertian = require('lib.materials.lambertian')
local raytracer = require('lib.raytracer')

local world = hittable_list()

local pertext = noise_texture(4)
local material = lambertian(pertext)
world:add(sphere(point3(0, -1000, 0), 1000, material))
world:add(sphere(point3(0, 2, 0), 2, material))

local difflight = diffuse_light(color(4, 4, 4))
world:add(sphere(point3(0, 7, 0), 2, difflight))
world:add(xy_rect(3, 5, 1, 3, -2, difflight))

local rt = raytracer(world)
	:set_samples_per_pixel(400)
	:set_look_from(point3(26, 3, 6))
	:set_look_at(point3(0, 2, 0))
	:set_vertical_fov(20)

rt:render('./renders/simple_light.ppm')
