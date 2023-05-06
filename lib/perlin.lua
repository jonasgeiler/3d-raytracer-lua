local bit = require('bit')
local class = require('lib.class')
local vec3 = require('lib.vec3')

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

---Perform perlin interpolation
---@param c vec3[][][]
---@param u number
---@param v number
---@param w number
---@nodiscard
local function perlin_interp(c, u, v, w)
	local uu = u * u * (3 - 2 * u)
	local vv = v * v * (3 - 2 * v)
	local ww = w * w * (3 - 2 * w)
	local accum = 0

	for i = 0, 1 do
		for j = 0, 1 do
			for k = 0, 1 do
				local weight_v = vec3(u - i, v - j, w - k)

				accum = accum +
					(i * uu + (1 - i) * (1 - uu)) *
					(j * vv + (1 - j) * (1 - vv)) *
					(k * ww + (1 - k) * (1 - ww)) *
					c[i][j][k]:dot(weight_v)
			end
		end
	end

	return accum
end


---Represents a perlin noise
---@class perlin
---@overload fun(): perlin
---@field ranvec vec3[]
---@field perm_x integer[]
---@field perm_y integer[]
---@field perm_z integer[]
local perlin = class()

---Init the perlin noise
function perlin:new()
	self.ranvec = {}
	for i = 0, POINT_COUNT - 1 do
		self.ranvec[i] = vec3.random(-1, 1):unit_vector()
	end

	self.perm_x = perlin_generate_perm()
	self.perm_y = perlin_generate_perm()
	self.perm_z = perlin_generate_perm()
end

---Compute the noise at a specific point
---@param p point3
---@return number
---@nodiscard
function perlin:noise(p)
	local u = p.x - math.floor(p.x)
	local v = p.y - math.floor(p.y)
	local w = p.z - math.floor(p.z)
	local i = math.floor(p.x)
	local j = math.floor(p.y)
	local k = math.floor(p.z)
	local c = {} ---@type vec3[][][]

	for di = 0, 1 do
		c[di] = {}
		for dj = 0, 1 do
			c[di][dj] = {}
			for dk = 0, 1 do
				c[di][dj][dk] = self.ranvec[bit.bxor(
					self.perm_x[bit.band(i + di, 255)],
					self.perm_y[bit.band(j + dj, 255)],
					self.perm_z[bit.band(k + dk, 255)]
				)]
			end
		end
	end

	return perlin_interp(c, u, v, w)
end

---Compute the turbulence at a specific point
---@param p point3
---@param depth integer?
---@return number
---@nodiscard
function perlin:turb(p, depth)
	depth = depth or 7

	local accum = 0
	local temp_p = p
	local weight = 1

	for i = 0, depth - 1 do
		accum = accum + weight * self:noise(temp_p)
		weight = weight * 0.5
		temp_p = temp_p * 2
	end

	return math.abs(accum)
end

return perlin
