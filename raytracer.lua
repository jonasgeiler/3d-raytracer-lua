local vec3 = require('lib.vec3')
local ppm = require('lib.ppm')
local ray = require('lib.ray')
local point3 = require('lib.point3')
local color = require('lib.color')
local hit_record = require('lib.hit_record')
local hittable_list = require('lib.hittable_list')
local sphere = require('lib.sphere')
local camera = require('lib.camera')

---@param r ray
---@param world hittable_list
---@param depth number
---@return color
local function ray_color(r, world, depth)
	if depth <= 0 then
		return color(0, 0, 0)
	end

	local rec = hit_record()
	if world:hit(r, 0.001, math.huge, rec) then
		--local target = rec.p + rec.normal + vec3.random_in_unit_sphere()
		--local target = rec.p + rec.normal + vec3.random_unit_vector()
		local target = rec.p + vec3.random_in_hemisphere(rec.normal)
		return 0.5 * ray_color(ray(rec.p, target - rec.p), world, depth - 1)
	end

	local unit_direction = r.direction:unit_vector()
	local t = 0.5 * (unit_direction.y + 1)

	return (1 - t) * color(1, 1, 1) + t * color(0.5, 0.7, 1)
end


print('\n-------------\n| RAYTRACER |\n-------------\n')

math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))) -- improve random nums

local aspect_ratio = 16 / 9
local samples_per_pixel = 100
local max_depth = 50
local image_width = 400
local image_height = math.floor(image_width / aspect_ratio)
local image = ppm('renders/render_' .. os.date('%Y-%m-%d_%H-%M-%S') .. '.ppm', image_width, image_height, true)

local world = hittable_list()
world:add(sphere(point3(0, 0, -1), 0.5))
world:add(sphere(point3(0, -100.5, -1), 100))

local cam = camera()

local last_scanline_time = 0
for j = image_height - 1, 0, -1 do
	print('Scanlines remaining: ', j, 'Seconds remaining: ', math.floor(last_scanline_time * j))

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
	last_scanline_time = os.clock() - scanline_time
end

image:close()
print('\nDone.\n')
