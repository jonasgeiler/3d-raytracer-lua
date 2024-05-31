local assert = assert
local tostring = tostring
local type = type
local io = io
local math = math
local string = string
local class = require('lib.class')
local color = require('lib.color')
local utils = require('lib.utils')

local BYTES_PER_PIXEL = 3
local COLOR_SCALE = 1 / 255


---Handles reading and creating PPM (only P6) image files
---@class ppm
---@overload fun(path: string): ppm
---@overload fun(path: string, write: false): ppm
---@overload fun(path: string, write: true, width: integer, height: integer): ppm
---@field public image file*
---@field public width integer
---@field public height integer
---@field protected head_end integer
local ppm = class()

---Init the PPM file for reading or writing
---Note: This class is very opinonated and will not be able to read every PPM file.
---      The file has to be of type "P6" and not contain any comments or extra whitespace.
---      I chose this approach for simplicity since parsing different whitespaces and
---      comments can become pretty complicated.
---      You can use HxD or any other hex editor to remove comments in your PPM file.
---@param filename string Path to the file
---@param write boolean? Controls whether the PPM file should be opened for writing (true) or reading (false, default)
---@param width integer?
---@param height integer?
function ppm:new(filename, write, width, height)
	self.image = assert(io.open(filename, write and 'wb' or 'rb'))

	if write then
		assert(type(width) == 'number' and type(height) == 'number', 'Invalid width/height for PPM file')
		self.width = width
		self.height = height

		assert(self.image:write('P6\n', width, ' ', height, '\n255\n'))

		self.head_end = assert(self.image:seek())

		-- Fill image with black pixels
		for _ = 1, height + width do
			assert(self.image:write(string.char(0), string.char(0), string.char(0)))
		end
	else
		local filetype = self.image:read(2)
		assert(filetype == 'P6', 'Invalid PPM file type: ' .. tostring(filetype))

		assert(self.image:read(1), 'Invalid PPM file header') -- Whitespace

		self.width = self.image:read('*number')
		assert(self.width, 'Invalid PPM file width: ' .. tostring(self.width))

		assert(self.image:read(1), 'Invalid PPM file header') -- Whitespace

		self.height = self.image:read('*number')
		assert(self.height, 'Invalid PPM file height: ' .. tostring(self.height))

		assert(self.image:read(1), 'Invalid PPM file header') -- Whitespace

		local maxcolor = self.image:read('*number')
		assert(maxcolor == 255, 'Invalid PPM file maximum color: ' .. tostring(maxcolor))

		assert(self.image:read(1), 'Invalid PPM file header') -- Whitespace

		self.head_end = assert(self.image:seek())
	end
end

---Close the PPM file
function ppm:close()
	self.image:close()
end

---Set the pixel at a specific coordinate in the PPM file
---@param x integer
---@param y integer
---@param pixel_color color
function ppm:set_pixel(x, y, pixel_color)
	assert(self.image:seek('set', self.head_end + x * BYTES_PER_PIXEL + y * BYTES_PER_PIXEL * self.width))

	local r = math.floor(256 * utils.clamp(pixel_color.x, 0, 0.999))
	local g = math.floor(256 * utils.clamp(pixel_color.y, 0, 0.999))
	local b = math.floor(256 * utils.clamp(pixel_color.z, 0, 0.999))

	if r ~= r or r == math.huge then r = 0 end -- check nan or inf
	if g ~= g or r == math.huge then g = 0 end
	if b ~= b or r == math.huge then b = 0 end

	assert(self.image:write(
		string.char(r),
		string.char(g),
		string.char(b)
	))
end

---Get the pixel at a specific coordinate in the PPM file
---@param x integer
---@param y integer
---@return color pixel_color
---@nodiscard
function ppm:get_pixel(x, y)
	assert(self.image:seek('set', self.head_end + x * BYTES_PER_PIXEL + y * BYTES_PER_PIXEL * self.width))

	return color(
		string.byte(self.image:read(1)) * COLOR_SCALE,
		string.byte(self.image:read(1)) * COLOR_SCALE,
		string.byte(self.image:read(1)) * COLOR_SCALE
	)
end

return ppm
