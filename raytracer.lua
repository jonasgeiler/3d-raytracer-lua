local ppm = require('lib.ppm')
local ray = require('lib.ray')
local point3 = require('lib.point3')
local color = require('lib.color')
local hit_record = require('lib.hit_record')
local hittable_list = require('lib.hittable_list')
local camera = require('lib.camera')
local sphere = require('lib.sphere')
local lambertian = require('lib.lambertian')
local metal = require('lib.metal')
local dielectric = require('lib.dielectric')

---@param r ray
---@param world hittable_list
---@param depth number
---@return color
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

	return (1.0 - t) * color(1.0, 1.0, 1.0) + t * color(0.5, 0.7, 1.0)
end


print('\n-------------\n| RAYTRACER |\n-------------\n\nInitiating...')

math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))) -- improve random nums

local aspect_ratio = 16 / 9
local samples_per_pixel = 100
local max_depth = 50
local image_width = 400
local image_height = math.floor(image_width / aspect_ratio)
local image = ppm('renders/render_' .. os.date('%Y-%m-%d_%H-%M-%S') .. '.ppm', image_width, image_height)

local world = hittable_list()

local material_ground = lambertian(color(0.8, 0.8, 0.0))
local material_center = lambertian(color(0.1, 0.2, 0.5))
local material_left   = dielectric(1.5)
local material_right  = metal(color(0.8, 0.6, 0.2), 0.0)

world:add(sphere(point3( 0.0, -100.5, -1.0), 100.0, material_ground))
world:add(sphere(point3( 0.0,    0.0, -1.0),   0.5, material_center))
world:add(sphere(point3(-1.0,    0.0, -1.0),   0.5, material_left))
world:add(sphere(point3(-1.0,    0.0, -1.0),  -0.4, material_left))
world:add(sphere(point3( 1.0,    0.0, -1.0),   0.5, material_right))

local cam = camera()

print('Starting rendering...\n')
local render_time = os.clock()

print('Scanlines remaining: ', image_height)
for j = image_height - 1, 0, -1 do
	local scanline_time = os.clock()

	for i = 0, image_width - 1 do
		local pixel_color = color(0, 0, 0)
		for _ = 1, samples_per_pixel do
			local u = (i + math.random()) / (image_width-1)
			local v = (j + math.random()) / (image_height-1)
			local r = cam:get_ray(u, v)
			pixel_color = pixel_color + ray_color(r, world, max_depth)
		end
		image:write_color(pixel_color, samples_per_pixel)
	end

	print('Scanlines remaining: ', j, 'Seconds remaining: ', math.floor((os.clock() - scanline_time) * j))
end

image:close()
print('\nFinished rendering!\nRendering took', os.clock() - render_time, 'seconds (or', (os.clock() - render_time) / 60, 'minutes)\n')
