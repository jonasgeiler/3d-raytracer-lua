local class = require('lib.class')
local texture = require('lib.base.texture')
local solid_color = require('lib.textures.solid_color')

---Represents a checker texture
---@class checker_texture : texture
---@overload fun(even: color|texture, odd: color|texture): checker_texture
---@field even texture
---@field odd texture
local checker_texture = class(texture)

---Init the texture
---@param even color|texture
---@param odd color|texture
function checker_texture:new(even, odd)
	if odd.x and odd.y and odd.z then
		---@cast odd color
		self.odd = solid_color(odd)
	else
		---@cast odd texture
		self.odd = odd
	end

	if even.x and even.y and even.z then
		---@cast even color
		self.even = solid_color(even)
	else
		---@cast even texture
		self.even = even
	end
end

---Get color value of the texture
---@param u number
---@param v number
---@param p point3
---@return color
function checker_texture:value(u, v, p)
	local sines = math.sin(p.x * 10) * math.sin(p.y * 10) * math.sin(p.z * 10)

	if sines < 0 then
		return self.odd:value(u, v, p)
	else
		return self.even:value(u, v, p)
	end
end

return checker_texture
