local class = require('lib.class')
local texture = require('lib.base.texture')
local color = require('lib.color')
local perlin  = require('lib.perlin')

---Represents a noise texture
---@class noise_texture : texture
---@overload fun(): noise_texture
---@field noise perlin
local noise_texture = class(texture)

---Init the texture
function noise_texture:new()
	self.noise = perlin()
end

---Get color value of the texture
---@param u number
---@param v number
---@param p point3
---@return color
---@nodiscard
function noise_texture:value(u, v, p)
	return color(1, 1, 1) * self.noise:noise(p)
end

return noise_texture
