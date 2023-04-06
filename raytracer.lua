local vec3 = require('lib.vec3')

io.write('\n-------------\n| RAYTRACER |\n-------------\n\n')

local image, err = io.open('image.ppm', 'w')
assert(image, err)

local image_width = 256
local image_height = 256

image:write('P3\n' .. image_width .. ' ' .. image_height .. '\n255\n');

local progress_flush = string.rep(' ', string.len(tostring(image_height - 1)))

for j = image_height - 1, 0, -1 do
	io.write('\rScanlines remaining: ' .. j .. progress_flush)

	for i = 0, image_width - 1 do
		local r = i / (image_width - 1)
		local g = j / (image_height - 1)
		local b = 0.25

		local ir = math.floor(255.999 * r)
		local ig = math.floor(255.999 * g)
		local ib = math.floor(255.999 * b)

		image:write(ir .. ' ' .. ig .. ' ' .. ib .. '\n')
	end
end

image:close()
io.write('\nDone.\n\n')
