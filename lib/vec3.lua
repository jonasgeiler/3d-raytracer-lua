local class = require('lib.middleclass')

---@class vec3
---@field x number
---@field y number
---@field z number
local vec3 = class('vec3')

---@field x number
---@field y number
---@field z number
function vec3:initialize(x, y, z)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
end

---@param min number
---@param max number
---@return vec3
function vec3.static:random(min, max)
	if min and max then
		return vec3(math.random(min, max), math.random(min, max), math.random(min, max))
	end

	return vec3(math.random(), math.random(), math.random())
end

---@return vec3
function vec3.static:random_in_unit_sphere()
	while true do
		local p = self:random(-1, 1)

		if p:length_squared() < 1 then
			return p
		end
	end
end

---@return vec3
function vec3.static:random_unit_vector()
	return self:random_in_unit_sphere():unit_vector()
end

---@return number
function vec3:length_squared()
	return self.x * self.x + self.y * self.y + self.z * self.z
end

---@return number
function vec3:length()
	return math.sqrt(self:length_squared())
end

---@return vec3
function vec3:unit_vector()
	return self / self:length()
end

---@return string
function vec3:__tostring()
	return 'vec3(' .. self.x .. ', ' .. self.y .. ', ' .. self.z .. ')'
end

---@return vec3
function vec3:__unm()
	return vec3(-self.x, -self.y, -self.z)
end

---@param a vec3|number
---@param b vec3|number
---@return vec3
function vec3.__add(a, b)
	if type(a) == 'number' then -- if `a` is a number than `b` has to be vec3
		return vec3(a + b.x, a + b.y, a + b.z)
	elseif type(b) == 'number' then -- if `b` is a number than `a` has to be vec3
		return vec3(a.x + b, a.y + b, a.z + b)
	end

	return vec3(a.x + b.x, a.y + b.y, a.z + b.z)
end

---@param a vec3|number
---@param b vec3|number
---@return vec3
function vec3.__sub(a, b)
	if type(a) == 'number' then -- if `a` is a number than `b` has to be vec3
		return vec3(a - b.x, a - b.y, a - b.z)
	elseif type(b) == 'number' then -- if `b` is a number than `a` has to be vec3
		return vec3(a.x - b, a.y - b, a.z - b)
	end

	return vec3(a.x - b.x, a.y - b.y, a.z - b.z)
end

---@param a vec3|number
---@param b vec3|number
---@return vec3
function vec3.__mul(a, b)
	if type(a) == 'number' then -- if `a` is a number than `b` has to be vec3
		return vec3(a * b.x, a * b.y, a * b.z)
	elseif type(b) == 'number' then -- if `b` is a number than `a` has to be vec3
		return vec3(a.x * b, a.y * b, a.z * b)
	end

	return vec3(a.x * b.x, a.y * b.y, a.z * b.z)
end

---@param a vec3|number
---@param b vec3|number
---@return vec3
function vec3.__div(a, b)
	if type(a) == 'number' then -- if `a` is a number than `b` has to be vec3
		return (1 / a) * b
	elseif type(b) == 'number' then -- if `b` is a number than `a` has to be vec3
		return a * (1 / b)
	end

	error('Invalid vec3 division: ' .. type(a) .. ' / ' .. type(b))
end

---@param a vec3
---@param b vec3
---@return number
function vec3.dot(a, b)
	return a.x * b.x + a.y * b.y + a.z * b.z
end

---@param a vec3
---@param b vec3
---@return vec3
function vec3.cross(a, b)
	return vec3(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x)
end

return vec3
