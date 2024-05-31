local math = math
local color = require('lib.color')
local point3 = require('lib.point3')
local utils = require('lib.utils')
local vec3 = require('lib.vec3')
local bvh_node = require('lib.hittables.bvh_node')
local hittable_list = require('lib.hittables.hittable_list')
local moving_sphere = require('lib.hittables.moving_sphere')
local sphere = require('lib.hittables.sphere')
local checker_texture = require('lib.textures.checker_texture')
local dielectric = require('lib.materials.dielectric')
local lambertian = require('lib.materials.lambertian')
local metal = require('lib.materials.metal')
local raytracer = require('lib.raytracer')

local world = hittable_list()

local checker = checker_texture(color(0.2, 0.3, 0.1), color(0.9, 0.9, 0.9))
local ground_material = lambertian(checker)
world:add(sphere(point3(0, -1000, 0), 1000, ground_material))

local big_spheres = hittable_list()

local material1 = dielectric(1.5)
big_spheres:add(sphere(point3(0, 1, 0), 1, material1))

local material2 = lambertian(color(0.4, 0.2, 0.1))
big_spheres:add(sphere(point3(-4, 1, 0), 1, material2))

local material3 = metal(color(0.7, 0.6, 0.5), 0)
big_spheres:add(sphere(point3(4, 1, 0), 1, material3))

world:add(bvh_node(big_spheres, 0, 1))

local small_spheres = hittable_list()

for a = -11, 10 do
	for b = -11, 10 do
		local choose_mat = math.random()
		local center = point3(a + 0.9 * math.random(), 0.2, b + 0.9 * math.random())

		if (center - point3(4, 0.2, 0)):length() > 0.9 then
			if choose_mat < 0.8 then
				-- diffuse
				local albedo = color.random() * color.random()
				local sphere_material = lambertian(albedo)
				local center2 = center + vec3(0, utils.random_float(0, 0.5), 0)
				small_spheres:add(moving_sphere(center, center2, 0, 1, 0.2, sphere_material))
			elseif choose_mat < 0.95 then
				-- metal
				local albedo = color.random(0.5, 1)
				local fuzz = utils.random_float(0, 0.5)
				local sphere_material = metal(albedo, fuzz)
				small_spheres:add(sphere(center, 0.2, sphere_material))
			else
				-- glass
				local sphere_material = dielectric(1.5)
				small_spheres:add(sphere(center, 0.2, sphere_material))
			end
		end
	end
end

world:add(bvh_node(small_spheres, 0, 1))

local rt = raytracer(world)
	:set_background_color(color(0.7, 0.8, 1))
	:set_look_from(point3(13, 2, 3))
	:set_look_at(point3(0, 0, 0))
	:set_vertical_fov(20)
	:set_aperture(0.1)

rt:render('./results/random.ppm')
