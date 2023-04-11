---@param base table
---@return table
local function class(base)
	local cls = {}
	cls.__index = cls

	setmetatable(cls, {
		__index = base,
		__call = function(c, ...)
			local instance = setmetatable({}, c)
			local new = instance.new
			if new then new(instance, ...) end
			return instance
		end
	})

	return cls
end

return class