local class = require('lib.middleclass')

local vec3 = class('vec3')

function vec3:initialize(x, y, z)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
end

function vec3:length()
	return math.sqrt(self:length_squared())
end

function vec3:length_squared()
	return self.x*self.x + self.y*self.y + self.z*self.z
end

return vec3
