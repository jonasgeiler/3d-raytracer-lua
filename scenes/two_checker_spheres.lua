local color = require('lib.color')
local point3 = require('lib.point3')
local hittable_list = require('lib.hittables.hittable_list')
local sphere = require('lib.hittables.sphere')
local checker_texture = require('lib.textures.checker_texture')
local lambertian = require('lib.materials.lambertian')
local raytracer = require('lib.raytracer')

local world = hittable_list()

local checker = checker_texture(color(0.2, 0.3, 0.1), color(0.9, 0.9, 0.9))
local material = lambertian(checker)

world:add(sphere(point3(0, -10, 0), 10, material))
world:add(sphere(point3(0, 10, 0), 10, material))

local rt = raytracer(world)
	:set_background_color(color(0.7, 0.8, 1))
	:set_look_from(point3(13, 2, 3))
	:set_look_at(point3(0, 0, 0))
	:set_vertical_fov(20)

rt:render('./renders/two_checker_spheres.ppm')
