local class = require('lib.class')
local color = require('lib.color')
local utils = require('lib.utils')

local BYTES_PER_PIXEL = 3


---Handles creating PPM (only P6) image files
---@class ppm
---@overload fun(path: string, read: boolean?): ppm
---@field image file*
---@field read boolean
---@field width integer
---@field height integer
---@field head_end integer
local ppm = class()

---Create and open a new PPM file
---@param filename string Path to the file
---@param read boolean? Controls whether the PPM file should be opened for reading (true) or writing (false)
function ppm:new(filename, read)
	local image, err = io.open(filename, read and 'rb' or 'wb')
	assert(image, err)

	self.image = image
end

---Close the PPM file
function ppm:close()
	self.image:close()
end

---Write the head with metadata to the PPM file
---@param width integer
---@param height integer
function ppm:write_head(width, height)
	assert(self.image:seek('set')) -- Reset pointer

	self.image:write('P6\n', width, ' ', height, '\n255\n')

	self.head_end = assert(self.image:seek())
	self.width, self.height = width, height
end

---Write the next pixel to the PPM file
---@param pixel_color color
---@param samples_per_pixel number
function ppm:write_color(pixel_color, samples_per_pixel)
	local scale = 1.0 / samples_per_pixel ---@type number
	local r = math.floor(256 * utils.clamp(math.sqrt(pixel_color.x * scale), 0.0, 0.999))
	local g = math.floor(256 * utils.clamp(math.sqrt(pixel_color.y * scale), 0.0, 0.999))
	local b = math.floor(256 * utils.clamp(math.sqrt(pixel_color.z * scale), 0.0, 0.999))

	if r ~= r then r = 0.0 end
	if g ~= g then g = 0.0 end
	if b ~= b then b = 0.0 end

	self.image:write(
		string.char(r),
		string.char(g),
		string.char(b)
	)
end

---Read the head of the PPM file
---@return integer width
---@return integer height
---@nodiscard
function ppm:read_head()
	assert(self.image:seek('set')) -- Reset pointer

	local filetype = self.image:read(2)
	if filetype ~= 'P6' then error('Invalid PPM file type: ' .. tostring(filetype)) end

	if self.image:read(1) == nil then error('Invalid PPM file header') end -- Whitespace

	local width = self.image:read('*number')
	if not width then error('Invalid PPM file width: ' .. tostring(width)) end

	if self.image:read(1) == nil then error('Invalid PPM file header') end -- Whitespace

	local height = self.image:read('*number')
	if not height then error('Invalid PPM file height: ' .. tostring(height)) end

	if self.image:read(1) == nil then error('Invalid PPM file header') end -- Whitespace

	local maxcolor = self.image:read('*number')
	if maxcolor ~= 255 then error('Invalid PPM file maximum color: ' .. tostring(maxcolor)) end

	if self.image:read(1) == nil then error('Invalid PPM file header') end -- Whitespace

	self.head_end = assert(self.image:seek())
	self.width, self.height = width, height
	return width, height
end

---Read the pixel at specific coordinates
---@param x integer
---@param y integer
---@return color pixel_color
---@nodiscard
function ppm:read_color(x, y)
	if self.head_end and self.width then
		assert(self.image:seek('set', self.head_end + x * BYTES_PER_PIXEL + y * BYTES_PER_PIXEL * self.width))
	else
		local width = self:read_head()
		assert(self.image:seek('cur', x * BYTES_PER_PIXEL + y * BYTES_PER_PIXEL * width))
	end

	return color(
		string.byte(self.image:read(1)),
		string.byte(self.image:read(1)),
		string.byte(self.image:read(1))
	)
end

return ppm
