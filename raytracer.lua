--- TODO: Make classes function more like the book's classes (init without params, define field scopes, etc.)
--- TODO: See if I actually need to use vec3:clone() anywhere (maybe higlight all pointers in the type definition with `&`)
--- TODO: Remove replace() and set() methods (aka. pointer alternatives) and return multiple values instead (`return true, ray, hit_record`)

local print = print
local tonumber = tonumber
local tostring = tostring
local math = math
local os = os
local string = string
local camera = require('lib.camera')
local color = require('lib.color')
local hit_record = require('lib.hit_record')
local point3 = require('lib.point3')
local ppm = require('lib.ppm')
local ray = require('lib.ray')
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
local xy_rect = require('lib.hittables.xy_rect')
local xz_rect = require('lib.hittables.xz_rect')
local yz_rect = require('lib.hittables.yz_rect')
local checker_texture = require('lib.textures.checker_texture')
local image_texture = require('lib.textures.image_texture')
local noise_texture = require('lib.textures.noise_texture')
local dielectric = require('lib.materials.dielectric')
local diffuse_light = require('lib.materials.diffuse_light')
local lambertian = require('lib.materials.lambertian')
local metal = require('lib.materials.metal')

---Get the color of the ray
---@param r ray
---@param background color
---@param world hittable_list
---@param depth number
---@return color
---@nodiscard
local function ray_color(r, background, world, depth)
	--- If we've exceeded the ray bounce limit, no more light is gathered
	if depth <= 0 then
		return color(0, 0, 0)
	end

	local rec = hit_record()

	--- If the ray hits nothing, return the background color
	if not world:hit(r, 0.001, math.huge, rec) then
		return background
	end

	local scattered = ray()
	local attenuation = color()
	local emitted = rec.mat:emitted(rec.u, rec.v, rec.p)

	if not rec.mat:scatter(r, rec, attenuation, scattered) then
		return emitted
	end

	return emitted + attenuation * ray_color(scattered, background, world, depth - 1)
end

---Generate a scene with 3 spheres
---@return hittable_list
---@nodiscard
local function three_spheres_scene()
	local world = hittable_list()

	local material_ground = lambertian(color(0.8, 0.8, 0))
	local material_center = lambertian(color(0.7, 0.3, 0.3))
	local material_left = metal(color(0.8, 0.8, 0.8), 0.3)
	local material_right = metal(color(0.8, 0.6, 0.2), 1)

	world:add(sphere(point3(0, -100.5, -1), 100, material_ground))
	world:add(sphere(point3(0, 0, -1), 0.5, material_center))
	world:add(sphere(point3(-1, 0, -1), 0.5, material_left))
	world:add(sphere(point3(1, 0, -1), 0.5, material_right))

	return world
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

---Generate a scene with some lights
---@return hittable_list
---@nodiscard
local function simple_light_scene()
	local world = hittable_list()

	local pertext = noise_texture(4)
	local material = lambertian(pertext)
	world:add(sphere(point3(0, -1000, 0), 1000, material))
	world:add(sphere(point3(0, 2, 0), 2, material))

	local difflight = diffuse_light(color(4, 4, 4))
	world:add(sphere(point3(0, 7, 0), 2, difflight))
	world:add(xy_rect(3, 5, 1, 3, -2, difflight))

	return world
end

---Generate a scene with a cornell box
---@return hittable_list
---@nodiscard
local function cornell_box()
	local world = hittable_list()

	local red = lambertian(color(0.65, 0.05, 0.05))
	local white = lambertian(color(0.73, 0.73, 0.73))
	local green = lambertian(color(0.12, 0.45, 0.15))
	local light = diffuse_light(color(15, 15, 15))

	-- room
	world:add(yz_rect(0, 555, 0, 555, 555, green))  -- left wall
	world:add(yz_rect(0, 555, 0, 555, 0, red))      -- right wall
	world:add(xz_rect(213, 343, 227, 332, 554, light)) -- roof light
	world:add(xz_rect(0, 555, 0, 555, 0, white))    -- floor
	world:add(xz_rect(0, 555, 0, 555, 555, white))  -- roof
	world:add(xy_rect(0, 555, 0, 555, 555, white))  -- back wall

	-- boxes
	local box1 = box(point3(0, 0, 0), point3(165, 330, 165), white) ---@type hittable
	box1 = rotate_y(box1, 15)
	box1 = translate(box1, vec3(265, 0, 295))
	world:add(box1)

	local box2 = box(point3(0, 0, 0), point3(165, 165, 165), white) ---@type hittable
	box2 = rotate_y(box2, -18)
	box2 = translate(box2, vec3(130, 0, 65))
	world:add(box2)

	return world
end

---Generate a scene with a cornell box and smoke
---@return hittable_list
---@nodiscard
local function cornell_box_smoke()
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

	return world
end

---Generate the final scene
---@return hittable_list
---@nodiscard
local function final_scene()
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

	local emat = lambertian(image_texture('images/earthmap.ppm'))
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

	return world
end


print('\n-------------\n| RAYTRACER |\n-------------\n\nInitiating...')

---@diagnostic disable-next-line: param-type-mismatch
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6))) -- improve random nums

local aspect_ratio = 16 / 9
local samples_per_pixel = 100
local max_depth = 50
local image_width = 400

local world ---@type hittable_list
local background = color(0, 0, 0)
local lookfrom ---@type point3
local lookat ---@type point3
local vup = vec3(0, 1, 0)
local vfov = 40
local aperture = 0
local dist_to_focus = 10

--[[
world = three_spheres_scene()
background = color(0.7, 0.8, 1)
lookfrom = point3(3, 3, 3)
lookat = point3(0, 0, -1)
vfov = 20

world = random_scene()
background = color(0.7, 0.8, 1)
lookfrom = point3(13, 2, 3)
lookat = point3(0, 0, 0)
vfov = 20
aperture = 0.1

world = two_checker_spheres_scene()
background = color(0.7, 0.8, 1)
lookfrom = point3(13, 2, 3)
lookat = point3(0, 0, 0)
vfov = 20

world = two_perlin_spheres_scene()
background = color(0.7, 0.8, 1)
lookfrom = point3(13, 2, 3)
lookat = point3(0, 0, 0)
vfov = 20

world = earth_globe_scene()
background = color(0.7, 0.8, 1)
lookfrom = point3(13, 2, 3)
lookat = point3(0, 0, 0)
vfov = 20

world = simple_light_scene()
samples_per_pixel = 400
lookfrom = point3(26, 3, 6)
lookat = point3(0, 2, 0)
vfov = 20

world = cornell_box()
aspect_ratio = 1
image_width = 600
samples_per_pixel = 200
lookfrom = point3(278, 278, -800)
lookat = point3(278, 278, 0)
vfov = 40

world = cornell_box_smoke()
aspect_ratio = 1
image_width = 600
samples_per_pixel = 200
lookfrom = point3(278, 278, -800)
lookat = point3(278, 278, 0)
vfov = 40
]]
world = final_scene()
aspect_ratio = 1
image_width = 800
samples_per_pixel = 10000
background = color(0, 0, 0)
lookfrom = point3(478, 278, -600)
lookat = point3(278, 278, 0)
vfov = 40

local image_height = math.floor(image_width / aspect_ratio)
local cam = camera(lookfrom, lookat, vup, vfov, aspect_ratio, aperture, dist_to_focus, 0, 1)
local image = ppm('renders/render_' .. os.date('%Y-%m-%d_%H-%M-%S') .. '.ppm', true, image_width, image_height)
local pixel_color_scale = 1 / samples_per_pixel ---@type number

print('Starting rendering...\n')
print('Scanlines remaining: ', image_height)
local render_start = os.clock()

---@diagnostic disable-next-line: no-unknown
local st1, st2, st3, st4, st5       -- holds the last 5 scanline times
local st_min, st_max = math.huge, 0 -- holds the overall longest and shortest scanline times
for j = image_height - 1, 0, -1 do
	local scanline_start = os.clock()

	for i = 0, image_width - 1 do
		local r = 0
		local g = 0
		local b = 0

		for _ = 1, samples_per_pixel do
			local u = (i + math.random()) / (image_width - 1) ---@type number
			local v = (j + math.random()) / (image_height - 1) ---@type number
			local cam_ray = cam:get_ray(u, v)
			local cam_ray_color = ray_color(cam_ray, background, world, max_depth)

			r = r + cam_ray_color.x ---@type number
			g = g + cam_ray_color.y ---@type number
			b = b + cam_ray_color.z ---@type number
		end

		image:set_pixel(i, image_height - 1 - j, color(
			math.sqrt(r * pixel_color_scale),
			math.sqrt(g * pixel_color_scale),
			math.sqrt(b * pixel_color_scale)
		))
	end

	st1, st2, st3, st4, st5 = os.clock() - scanline_start, st1, st2, st3, st4 -- update the last 5 scanline times
	if st1 < st_min then st_min = st1 end                                  -- update shortest scanline time
	if st1 > st_max then st_max = st1 end                                  -- update longest scanline time
	if st5 ~= nil then
		-- try to calculate the remaining seconds by using the average of:
		-- > the average of the last 5 scanline times
		-- > the longest scanline time
		-- > the shortest scanline time
		print('Scanlines remaining: ', j, 'Seconds remaining: ',
			string.format('%.2fs', ((st1 + st2 + st3 + st4 + st5) / 5 + st_min + st_max) / 3 * j))
	else
		print('Scanlines remaining: ', j, 'Seconds remaining: ', string.format('%.2fs', st1 * j))
	end
end

local render_end = os.clock()
print('\nFinished rendering!\nRendering took', render_end - render_start,
	'seconds (or', (render_end - render_start) / 60, 'minutes)\n')

image:close()
