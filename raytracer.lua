--- TODO: Add a "set" method and use it instead of "replace_with" at some places?
--- TODO: Make classes function more like the book's classes (init without params, define field scopes, etc.)

local camera          = require('lib.camera')
local color           = require('lib.color')
local hit_record      = require('lib.hit_record')
local point3          = require('lib.point3')
local ppm             = require('lib.ppm')
local ray             = require('lib.ray')
local utils           = require('lib.utils')
local vec3            = require('lib.vec3')
local bvh_node        = require('lib.hittables.bvh_node')
local hittable_list   = require('lib.hittables.hittable_list')
local moving_sphere   = require('lib.hittables.moving_sphere')
local sphere          = require('lib.hittables.sphere')
local checker_texture = require('lib.textures.checker_texture')
local image_texture   = require('lib.textures.image_texture')
local noise_texture   = require('lib.textures.noise_texture')
local dielectric      = require('lib.materials.dielectric')
local lambertian      = require('lib.materials.lambertian')
local metal           = require('lib.materials.metal')

---Get the color of the ray
---@param r ray
---@param world hittable_list
---@param depth number
---@return color
---@nodiscard
local function ray_color(r, world, depth)
	if depth <= 0 then
		return color(0.0, 0.0, 0.0)
	end

	local rec = hit_record()
	if world:hit(r, 0.001, math.huge, rec) then
		local scattered = ray()
		local attenuation = color()

		if rec.mat:scatter(r, rec, attenuation, scattered) then
			return attenuation * ray_color(scattered, world, depth - 1)
		end

		return color(0.0, 0.0, 0.0)
	end

	local unit_direction = r.direction:unit_vector()
	local t = 0.5 * (unit_direction.y + 1.0)

	return color(1.0, 1.0, 1.0) * (1.0 - t) + color(0.5, 0.7, 1.0) * t
end

---Generate a random scene
---@return hittable_list
---@nodiscard
local function random_scene()
	local world = hittable_list()

	local checker = checker_texture(color(0.2, 0.3, 0.1), color(0.9, 0.9, 0.9))
	local ground_material = lambertian(checker)
	world:add(sphere(point3(0, -1000, 0), 1000, ground_material))


	local big_spheres = hittable_list()

	local material1 = dielectric(1.5)
	big_spheres:add(sphere(point3(0, 1, 0), 1.0, material1))

	local material2 = lambertian(color(0.4, 0.2, 0.1))
	big_spheres:add(sphere(point3(-4, 1, 0), 1.0, material2))

	local material3 = metal(color(0.7, 0.6, 0.5), 0.0)
	big_spheres:add(sphere(point3(4, 1, 0), 1.0, material3))

	world:add(bvh_node(big_spheres, 0.0, 1.0))


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
					small_spheres:add(moving_sphere(center, center2, 0.0, 1.0, 0.2, sphere_material))
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

	world:add(bvh_node(small_spheres, 0.0, 1.0))


	return world
end

---Generate a scene with two checker textured spheres
---@return hittable_list
---@nodiscard
local function two_checker_spheres_scene()
	local world = hittable_list()

	local checker = checker_texture(color(0.2, 0.3, 0.1), color(0.9, 0.9, 0.9))
	local material = lambertian(checker)

	world:add(sphere(point3(0, -10, 0), 10, material))
	world:add(sphere(point3(0, 10, 0), 10, material))

	return world
end

---Generate a scene with two perlin textured spheres
---@return hittable_list
---@nodiscard
local function two_perlin_spheres_scene()
	local world = hittable_list()

	local pertext = noise_texture(4)
	local material = lambertian(pertext)

	world:add(sphere(point3(0, -1000, 0), 1000, material))
	world:add(sphere(point3(0, 2, 0), 2, material))

	return world
end

---Generate a scene with an earth globe
---@return hittable_list
---@nodiscard
local function earth_globe_scene()
	local world = hittable_list()

	local earth_texture = image_texture('images/earthmap.ppm')
	local earth_surface = lambertian(earth_texture)

	world:add(sphere(point3(0, 0, 0), 2, earth_surface))

	return world
end


print('\n-------------\n| RAYTRACER |\n-------------\n\nInitiating...')

---@diagnostic disable-next-line: param-type-mismatch
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6))) -- improve random nums

local aspect_ratio = 16.0 / 9.0
local samples_per_pixel = 100
local max_depth = 50
local image_width = 400
local image_height = math.floor(image_width / aspect_ratio)

local world ---@type hittable_list
local lookfrom ---@type point3
local lookat ---@type point3
local vup = vec3(0, 1, 0)
local vfov = 40.0
local aperture = 0.0
local dist_to_focus = 10.0

--[[
world = random_scene()
lookfrom = point3(13, 2, 3)
lookat = point3(0, 0, 0)
vfov = 20.0
aperture = 0.1

world = two_checker_spheres_scene()
lookfrom = point3(13, 2, 3)
lookat = point3(0, 0, 0)
vfov = 20.0

world = two_perlin_spheres_scene()
lookfrom = point3(13, 2, 3)
lookat = point3(0, 0, 0)
vfov = 20.0
]]
world = earth_globe_scene()
lookfrom = point3(13, 2, 3)
lookat = point3(0, 0, 0)
vfov = 20.0

local cam = camera(lookfrom, lookat, vup, vfov, aspect_ratio, aperture, dist_to_focus, 0.0, 1.0)

local image = ppm('renders/render_' .. os.date('%Y-%m-%d_%H-%M-%S') .. '.ppm')
image:write_head(image_width, image_height)

print('Starting rendering...\n')
local render_start = os.clock()

print('Scanlines remaining: ', image_height)
for j = image_height - 1, 0, -1 do
	local scanline_time = os.clock()

	for i = 0, image_width - 1 do
		local pixel_color = color(0, 0, 0)
		for _ = 1, samples_per_pixel do
			local u = (i + math.random()) / (image_width - 1) ---@type number
			local v = (j + math.random()) / (image_height - 1) ---@type number
			local r = cam:get_ray(u, v)
			pixel_color = pixel_color + ray_color(r, world, max_depth)
		end
		image:write_color(pixel_color, samples_per_pixel)
	end

	print('Scanlines remaining: ', j, 'Seconds remaining: ', math.floor((os.clock() - scanline_time) * j))
end

local render_end = os.clock()
print('\nFinished rendering!\nRendering took', render_end - render_start,
	'seconds (or', (render_end - render_start) / 60, 'minutes)\n')

image:close()
