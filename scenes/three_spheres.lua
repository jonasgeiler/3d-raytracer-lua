local raytracer = require('lib.raytracer')
local hittable_list = require('lib.hittables.hittable_list')
local lambertian = require('lib.materials.lambertian')
local color = require('lib.color')
local metal = require('lib.materials.metal')
local sphere = require('lib.hittables.sphere')
local point3 = require('lib.point3')

local world = hittable_list()

local material_ground = lambertian(color(0.8, 0.8, 0))
local material_center = lambertian(color(0.7, 0.3, 0.3))
local material_left = metal(color(0.8, 0.8, 0.8), 0.3)
local material_right = metal(color(0.8, 0.6, 0.2), 1)

world:add(sphere(point3(0, -100.5, -1), 100, material_ground))
world:add(sphere(point3(0, 0, -1), 0.5, material_center))
world:add(sphere(point3(-1, 0, -1), 0.5, material_left))
world:add(sphere(point3(1, 0, -1), 0.5, material_right))

local rt = raytracer(world)
	:set_background_color(color(0.7, 0.8, 1))
	:set_look_from(point3(3, 3, 3))
	:set_look_at(point3(0, 0, -1))
	:set_vertical_fov(20)

rt:render('./renders/three_spheres.ppm')
