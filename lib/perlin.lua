local bit = require('bit')
local class = require('lib.class')
local utils = require('lib.utils')

local POINT_COUNT = 256

---Permute a list of numbers
---@param p integer[]
---@param n integer
local function permute(p, n)
	for i = n - 1, 1, -1 do
		local target = math.random(0, i)
		local tmp = p[i]

		p[i] = p[target]
		p[target] = tmp
	end
end

---Generate a perm
---@return integer[]
---@nodiscard
local function perlin_generate_perm()
	local p = {} ---@type integer[]

	for i = 0, POINT_COUNT - 1 do
		p[i] = i
	end

	permute(p, POINT_COUNT)

	return p
end

---Perform trilinear interpolation
---@param c number[][][]
---@param u number
---@param v number
---@param w number
local function trilinear_interp(c, u, v, w)
	local accum = 0.0

	for i = 0, 1 do
		for j = 0, 1 do
			for k = 0, 1 do
				accum = accum +
					(i * u + (1 - i) * (1 - u)) *
					(j * v + (1 - j) * (1 - v)) *
					(k * w + (1 - k) * (1 - w)) *
					c[i][j][k]
			end
		end
	end

	return accum
end


---Represents a perlin noise
---@class perlin
---@overload fun(): perlin
---@field ranfloat number[]
---@field perm_x integer[]
---@field perm_y integer[]
---@field perm_z integer[]
local perlin = class()

---Init the perlin noise
function perlin:new()
	self.ranfloat = {}
	for i = 0, POINT_COUNT - 1 do
		self.ranfloat[i] = math.random()
	end

	self.perm_x = perlin_generate_perm()
	self.perm_y = perlin_generate_perm()
	self.perm_z = perlin_generate_perm()
end

---Get the noise at a specific point
---@param p point3
---@return number
---@nodiscard
function perlin:noise(p)
	local u = p.x - math.floor(p.x)
	local v = p.y - math.floor(p.y)
	local w = p.z - math.floor(p.z)
	u = u * u * (3 - 2 * u)
	v = v * v * (3 - 2 * v)
	w = w * w * (3 - 2 * w)

	local i = math.floor(p.x)
	local j = math.floor(p.y)
	local k = math.floor(p.z)
	local c = {} ---@type number[][][]

	for di = 0, 1 do
		c[di] = {}
		for dj = 0, 1 do
			c[di][dj] = {}
			for dk = 0, 1 do
				c[di][dj][dk] = self.ranfloat[bit.bxor(
					self.perm_x[bit.band(i + di, 255)],
					self.perm_y[bit.band(j + dj, 255)],
					self.perm_z[bit.band(k + dk, 255)]
				)]
			end
		end
	end

	return trilinear_interp(c, u, v, w)
end

return perlin
