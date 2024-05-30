local color = require('lib.color')
local point3 = require('lib.point3')
local utils = require('lib.utils')
local vec3 = require('lib.vec3')
local box = require('lib.hittables.box')
local bvh_node = require('lib.hittables.bvh_node')
local constant_medium = require('lib.hittables.constant_medium')
local hittable_list = require('lib.hittables.hittable_list')
local moving_sphere = require('lib.hittables.moving_sphere')
local rotate_y = require('lib.hittables.rotate_y')
local sphere = require('lib.hittables.sphere')
local translate = require('lib.hittables.translate')
local xz_rect = require('lib.hittables.xz_rect')
local image_texture = require('lib.textures.image_texture')
local noise_texture = require('lib.textures.noise_texture')
local dielectric = require('lib.materials.dielectric')
local diffuse_light = require('lib.materials.diffuse_light')
local lambertian = require('lib.materials.lambertian')
local metal = require('lib.materials.metal')
local raytracer = require('lib.raytracer')

local boxes1 = hittable_list()
local ground = lambertian(color(0.48, 0.83, 0.53))

local boxes_per_side = 20
for i = 0, boxes_per_side - 1 do
	for j = 0, boxes_per_side - 1 do
		local w = 100.0
		local x0 = -1000.0 + i * w
		local z0 = -1000.0 + j * w
		local y0 = 0.0
		local x1 = x0 + w
		local y1 = utils.random_float(1, 101)
		local z1 = z0 + w

		boxes1:add(box(point3(x0, y0, z0), point3(x1, y1, z1), ground))
	end
end

local world = hittable_list()

world:add(bvh_node(boxes1, 0, 1))

local light = diffuse_light(color(7, 7, 7))
world:add(xz_rect(123, 423, 147, 412, 554, light))

local center1 = point3(400, 400, 200)
local center2 = center1 + vec3(30, 0, 0)
local moving_sphere_material = lambertian(color(0.7, 0.3, 0.1))
world:add(moving_sphere(center1, center2, 0, 1, 50, moving_sphere_material))

world:add(sphere(point3(260, 150, 45), 50, dielectric(1.5)))
world:add(sphere(point3(0, 150, 145), 50, metal(color(0.8, 0.8, 0.9), 1.0)))

local boundary = sphere(point3(360, 150, 145), 70, dielectric(1.5))
world:add(boundary)
world:add(constant_medium(boundary, 0.2, color(0.2, 0.4, 0.9)))
boundary = sphere(point3(0, 0, 0), 5000, dielectric(1.5))
world:add(constant_medium(boundary, 0.0001, color(1, 1, 1)))

local emat = lambertian(image_texture('./scenes/assets/earthmap.ppm'))
world:add(sphere(point3(400, 200, 400), 100, emat))
local pertext = noise_texture(0.1)
world:add(sphere(point3(220, 280, 300), 80, lambertian(pertext)))

local boxes2 = hittable_list()
local white = lambertian(color(0.73, 0.73, 0.73))
local ns = 1000
for j = 0, ns - 1 do
	boxes2:add(sphere(point3.random(0, 165), 10, white))
end

world:add(translate(rotate_y(bvh_node(boxes2, 0.0, 1.0), 15), vec3(-100, 270, 395)))

-- with the "should be" values this took almost a week to render :D
local rt = raytracer(world)
	:set_aspect_ratio(1)
	:set_image_width(200) -- should be 800
	:set_samples_per_pixel(1000) -- should be 10000
	:set_look_from(point3(478, 278, -600))
	:set_look_at(point3(278, 278, 0))
	:set_vertical_fov(40)

rt:render('./renders/final.ppm')
