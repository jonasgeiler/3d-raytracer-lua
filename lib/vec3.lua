local class = require('lib.middleclass')

local vec3 = class('vec3')

function vec3:initialize(x, y, z)
	assert(type(x) == 'number' and type(y) == 'number' and type(z) == 'number', 'Invalid vec3 arguments: ' .. type(x) .. ', ' .. type(y) .. ', ' .. type(z))
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
end

function vec3:length_squared()
	return self.x * self.x + self.y * self.y + self.z * self.z
end

function vec3:length()
	return math.sqrt(self:length_squared())
end

function vec3:__tostring()
	return 'vec3(' .. self.x .. ', ' .. self.y .. ', ' .. self.z .. ')'
end

function vec3:__unm()
	return vec3(-self.x, -self.y, -self.z)
end

function vec3.__add(a, b)
	if type(a) == 'number' then -- if `a` is a number than `b` has to be vec3
		return vec3(a + b.x, a + b.y, a + b.z)
	end

	if type(b) == 'number' then -- if `b` is a number than `a` has to be vec3
		return vec3(a.x + b, a.y + b, a.z + b)
	end

	assert(a.class == vec3 and b.class == vec3, 'Invalid vec3 addition: ' .. type(a) .. ' + ' .. type(b))
	return vec3(a.x + b.x, a.y + b.y, a.z + b.z)
end

function vec3.__sub(a, b)
	if type(a) == 'number' then -- if `a` is a number than `b` has to be vec3
		return vec3(a - b.x, a - b.y, a - b.z)
	end

	if type(b) == 'number' then -- if `b` is a number than `a` has to be vec3
		return vec3(a.x - b, a.y - b, a.z - b)
	end

	assert(a.class == vec3 and b.class == vec3, 'Invalid vec3 subtraction: ' .. type(a) .. ' - ' .. type(b))
	return vec3(a.x - b.x, a.y - b.y, a.z - b.z)
end

function vec3.__mul(a, b)
	if type(a) == 'number' then -- if `a` is a number than `b` has to be vec3
		return vec3(a * b.x, a * b.y, a * b.z)
	end

	if type(b) == 'number' then -- if `b` is a number than `a` has to be vec3
		return vec3(a.x * b, a.y * b, a.z * b)
	end

	assert(a.class == vec3 and b.class == vec3, 'Invalid vec3 multiplication: ' .. type(a) .. ' * ' .. type(b))
	return vec3(a.x * b.x, a.y * b.y, a.z * b.z)
end

function vec3.__div(a, b)
	if type(a) == 'number' then -- if `a` is a number than `b` has to be vec3
		return (1 / a) * b
	end

	if type(b) == 'number' then -- if `b` is a number than `a` has to be vec3
		return a * (1 / b)
	end

	error('Invalid vec3 division: ' .. type(a) .. ' / ' .. type(b))
end

function vec3.dot(a, b)
	assert(a.class == vec3 and b.class == vec3, 'Invalid vec3 dot product: ' .. type(a) .. ' dot ' .. type(b))
	return a.x * b.x + a.y * b.y + a.z * b.z
end

function vec3.cross(a, b)
	assert(a.class == vec3 and b.class == vec3, 'Invalid vec3 cross product: ' .. type(a) .. ' cross ' .. type(b))
	return vec3(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x)
end

function vec3.unit_vector(v)
	assert(v.class == vec3, 'Invalid vec3 unit vector: ' .. type(v))
	return v / v:length()
end

return vec3
