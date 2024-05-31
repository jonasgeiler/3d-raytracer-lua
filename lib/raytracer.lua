local print = print
local math = math
local os = os
local string = string
local class = require('lib.class')
local camera = require('lib.camera')
local color = require('lib.color')
local hit_record = require('lib.hit_record')
local point3 = require('lib.point3')
local ppm = require('lib.ppm')
local ray = require('lib.ray')
local vec3 = require('lib.vec3')

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


---Interface for the whole 3D raytracing system
---@class raytracer
---@overload fun(world: hittable_list): raytracer
---@field aspect_ratio number The aspect ratio of the image
---@field samples_per_pixel integer The number of samples per pixel
---@field max_depth integer The maximum depth of the ray
---@field image_width integer The width of the image
---@field world hittable_list The world to render
---@field background_color color The background color
---@field look_from point3 The look from point
---@field look_at point3 The look at point
---@field up_vector vec3 The up vector
---@field vertical_fov number The vertical field of view
---@field aperture number The aperture
---@field dist_to_focus number The distance to focus
---@field time0 number The start time
---@field time1 number The end time
local raytracer = class()

---Init the raytracer
---@param world hittable_list
function raytracer:new(world)
	self.aspect_ratio = 16 / 9
	self.samples_per_pixel = 100
	self.max_depth = 50
	self.image_width = 400
	self.world = world
	self.background_color = color(0, 0, 0)
	self.look_from = point3(13, 2, 3)
	self.look_at = point3(0, 0, 0)
	self.up_vector = vec3(0, 1, 0)
	self.vertical_fov = 40
	self.aperture = 0
	self.dist_to_focus = 10
	self.time0 = 0
	self.time1 = 1

	---@diagnostic disable-next-line: param-type-mismatch
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6))) -- improve random nums
end

---Set the aspect ratio (default is 16/9)
---@param aspect_ratio number
---@return raytracer
function raytracer:set_aspect_ratio(aspect_ratio)
	self.aspect_ratio = aspect_ratio
	return self
end

---Set the samples per pixel (default is 100)
---@param samples_per_pixel integer
---@return raytracer
function raytracer:set_samples_per_pixel(samples_per_pixel)
	self.samples_per_pixel = samples_per_pixel
	return self
end

---Set the max depth (default is 50)
---@param max_depth integer
---@return raytracer
function raytracer:set_max_depth(max_depth)
	self.max_depth = max_depth
	return self
end

---Set the image width (default is 400)
---@param image_width integer
---@return raytracer
function raytracer:set_image_width(image_width)
	self.image_width = image_width
	return self
end

---Set the background color (default is black)
---@param background_color color
---@return raytracer
function raytracer:set_background_color(background_color)
	self.background_color = background_color
	return self
end

---Set the look from point (default is (13, 2, 3))
---@param look_from point3
---@return raytracer
function raytracer:set_look_from(look_from)
	self.look_from = look_from
	return self
end

---Set the look at point (default is (0, 0, 0))
---@param look_at point3
---@return raytracer
function raytracer:set_look_at(look_at)
	self.look_at = look_at
	return self
end

---Set the up vector (default is (0, 1, 0))
---@param up_vector vec3
---@return raytracer
function raytracer:set_up_vector(up_vector)
	self.up_vector = up_vector
	return self
end

---Set the vertical field-of-view in degrees (default is 40)
---@param vertical_fov number
---@return raytracer
function raytracer:set_vertical_fov(vertical_fov)
	self.vertical_fov = vertical_fov
	return self
end

---Set the aperture (default is 0)
---@param aperture number
---@return raytracer
function raytracer:set_aperture(aperture)
	self.aperture = aperture
	return self
end

---Set the distance to focus (default is 10)
---@param dist_to_focus number
---@return raytracer
function raytracer:set_dist_to_focus(dist_to_focus)
	self.dist_to_focus = dist_to_focus
	return self
end

---Set the time range (default is 0 to 1)
---@param time0 number
---@param time1 number
---@return raytracer
function raytracer:set_time_range(time0, time1)
	self.time0 = time0
	self.time1 = time1
	return self
end

---Render the scene
---@param filename string
function raytracer:render(filename)
	print('--- Starting rendering of', filename, ' ---\n')

	local aspect_ratio = self.aspect_ratio
	local samples_per_pixel = self.samples_per_pixel
	local max_depth = self.max_depth
	local image_width = self.image_width
	local world = self.world
	local background = self.background_color
	local lookfrom = self.look_from
	local lookat = self.look_at
	local vup = self.up_vector
	local vfov = self.vertical_fov
	local aperture = self.aperture
	local dist_to_focus = self.dist_to_focus
	local time0 = self.time0
	local time1 = self.time1

	local image_height = math.floor(image_width / aspect_ratio)
	local cam = camera(lookfrom, lookat, vup, vfov, aspect_ratio, aperture, dist_to_focus, time0, time1)
	local image = ppm(filename, true, image_width, image_height)
	local pixel_color_scale = 1 / samples_per_pixel

	print('Scanlines remaining:', image_height)
	local render_start = os.clock()

	---@diagnostic disable-next-line: no-unknown
	local st1, st2, st3, st4, st5 -- holds the last 5 scanline times
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
		if st1 < st_min then st_min = st1 end -- update shortest scanline time
		if st1 > st_max then st_max = st1 end -- update longest scanline time
		if st5 ~= nil then
			-- try to calculate the remaining seconds by using the average of:
			-- > the average of the last 5 scanline times
			-- > the longest scanline time
			-- > the shortest scanline time
			print('Scanlines remaining:', j, 'Seconds remaining:',
				string.format('%.2fs', ((st1 + st2 + st3 + st4 + st5) / 5 + st_min + st_max) / 3 * j))
		else
			print('Scanlines remaining:', j, 'Seconds remaining:', string.format('%.2fs', st1 * j))
		end
	end

	local render_end = os.clock()
	image:close()

	print(
		'\n--- Finished rendering. Rendering took',
		render_end - render_start,
		'seconds (or',
		(render_end - render_start) / 60,
		'minutes) ---'
	)
end

return raytracer
