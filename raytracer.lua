local vec3 = require('lib.vec3')
local ppm = require('lib.ppm')
local ray = require('lib.ray')

local point3 = vec3 -- alias
local color = vec3 -- alias

function hit_sphere(center, radius, r)
	assert(center.class == point3, 'Invalid sphere center: ' .. type(center))
	assert(type(radius) == 'number', 'Invalid sphere radius: ' .. type(radius))
	assert(r.class == ray, 'Invalid sphere hit ray: ' .. type(r))

	local oc = r.origin - center
	local a = vec3.dot(r.direction, r.direction)
	local b = 2 * vec3.dot(oc, r.direction)
	local c = vec3.dot(oc, oc) - radius*radius
	local discriminant = b*b - 4*a*c

	return discriminant > 0
end

function ray_color(r)
	assert(r.class == ray, 'Invalid ray: ' .. type(r))

	if hit_sphere(point3(0, 0, -1), 0.5, r) then
		return color(1, 0, 0)
	end

	local unit_direction = r.direction:unit_vector()
	local t = 0.5 * (unit_direction.y + 1)

	return (1 - t) * color(1, 1, 1) + t * color(0.5, 0.7, 1)
end


io.write('\n-------------\n| RAYTRACER |\n-------------\n\n')

local aspect_ratio = 16 / 9
local image_width = 400
local image_height = math.floor(image_width / aspect_ratio)
local image = ppm('image.ppm', image_width, image_height)

local viewport_height = 2
local viewport_width = aspect_ratio * viewport_height
local focal_length = 1

local origin = point3(0, 0, 0)
local horizontal = vec3(viewport_width, 0, 0)
local vertical = vec3(0, viewport_height, 0)
local lower_left_corner = origin - horizontal/2 - vertical/2 - vec3(0, 0, focal_length)

local progress_flush = string.rep(' ', #tostring(image_height - 1))

for j = image_height - 1, 0, -1 do
	io.write('\rScanlines remaining: ' .. j .. progress_flush)

	for i = 0, image_width - 1 do
		local u = i / (image_width - 1)
		local v = j / (image_height - 1)
		local r = ray(origin, lower_left_corner + u*horizontal + v*vertical - origin)
		local pixel_color = ray_color(r)

		image:write_color(pixel_color)
	end
end

image:close()
io.write('\nDone.\n\n')
