local class = require('lib.class')
local texture = require('lib.base.texture')
local color = require('lib.color')
local perlin  = require('lib.perlin')

---Represents a noise texture
---@class noise_texture : texture
---@overload fun(scale: number): noise_texture
---@field noise perlin
---@field scale number
local noise_texture = class(texture)

---Init the texture
---@param scale number
function noise_texture:new(scale)
	self.noise = perlin()
	self.scale = scale
end

---Get color value of the texture
---@param u number
---@param v number
---@param p point3
---@return color
---@nodiscard
function noise_texture:value(u, v, p)
	return color(1, 1, 1) * 0.5 * (1.0 + self.noise:noise(p * self.scale))
end

return noise_texture
