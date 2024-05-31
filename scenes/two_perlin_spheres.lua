local color = require('lib.color')
local point3 = require('lib.point3')
local hittable_list = require('lib.hittables.hittable_list')
local sphere = require('lib.hittables.sphere')
local noise_texture = require('lib.textures.noise_texture')
local lambertian = require('lib.materials.lambertian')
local raytracer = require('lib.raytracer')

local world = hittable_list()

local pertext = noise_texture(4)
local material = lambertian(pertext)
world:add(sphere(point3(0, -1000, 0), 1000, material))
world:add(sphere(point3(0, 2, 0), 2, material))

local rt = raytracer(world)
	:set_background_color(color(0.7, 0.8, 1))
	:set_look_from(point3(13, 2, 3))
	:set_look_at(point3(0, 0, 0))
	:set_vertical_fov(20)

rt:render('./results/two_perlin_spheres.ppm')
