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
	local i = bit.band(math.floor(p.x * 4), 255)
	local j = bit.band(math.floor(p.y * 4), 255)
	local k = bit.band(math.floor(p.z * 4), 255)

	return self.ranfloat[bit.bxor(self.perm_x[i], self.perm_y[j], self.perm_z[k])]
end

return perlin
