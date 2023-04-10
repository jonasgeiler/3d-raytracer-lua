local vec3 = require('lib.vec3')
local ppm = require('lib.ppm')
local ray = require('lib.ray')
local hittable = require('lib.hittable')
local hit_record = require('lib.hit_record')
local hittable_list = require('lib.hittable_list')
local sphere = require('lib.sphere')
local camera = require('lib.camera')

local point3 = vec3 -- alias
local color = vec3 -- alias

function ray_color(r, world)
	assert(type(r) == 'table' and r.class == ray, 'Invalid ray: ' .. type(r))
	assert(type(world) == 'table' and world.class == hittable_list, 'Invalid world: ' .. type(world))

	local rec = hit_record()
	if world:hit(r, 0, math.huge, rec) then
		return 0.5 * (rec.normal + color(1, 1, 1))
	end

	local unit_direction = r.direction:unit_vector()
	local t = 0.5 * (unit_direction.y + 1)

	return (1 - t) * color(1, 1, 1) + t * color(0.5, 0.7, 1)
end


print('\n-------------\n| RAYTRACER |\n-------------\n')

math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))) -- improve random nums

local aspect_ratio = 16 / 9
local samples_per_pixel = 100
local image_width = 400
local image_height = math.floor(image_width / aspect_ratio)
local image = ppm('image.ppm', image_width, image_height)

local world = hittable_list()
world:add(sphere(point3(0, 0, -1), 0.5))
world:add(sphere(point3(0, -100.5, -1), 100))

local cam = camera()

for j = image_height - 1, 0, -1 do
	print('Scanlines remaining: ', j)

	for i = 0, image_width - 1 do
		local pixel_color = color(0, 0, 0)
		for s = 0, samples_per_pixel - 1 do
			local u = (i + math.random()) / (image_width-1)
			local v = (j + math.random()) / (image_height-1)
			local r = cam:get_ray(u, v)
			pixel_color = pixel_color + ray_color(r, world)
		end
		image:write_color(pixel_color, samples_per_pixel)
	end
end

image:close()
print('\nDone.\n')
