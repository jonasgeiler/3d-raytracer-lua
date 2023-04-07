local vec3 = require('lib.vec3')
local ppm = require('lib.ppm')
local ray = require('lib.ray')

local point3 = vec3 -- alias
local color = vec3 -- alias

io.write('\n-------------\n| RAYTRACER |\n-------------\n\n')

local image, err = io.open('image.ppm', 'w')
assert(image, err)

local image_width = 256
local image_height = 256
local image = ppm('image.ppm', image_width, image_height)

local progress_flush = string.rep(' ', string.len(tostring(image_height - 1)))

for j = image_height - 1, 0, -1 do
	io.write('\rScanlines remaining: ' .. j .. progress_flush)

	for i = 0, image_width - 1 do
		local pixel_color = color(i / (image_width - 1), j / (image_height - 1), 0.25)
		image:write_color(pixel_color)
	end
end

image:close()
io.write('\nDone.\n\n')
