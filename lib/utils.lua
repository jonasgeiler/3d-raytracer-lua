local utils = {}

---@param min number
---@param max number
---@return number
function utils.random(min, max)
	if min and max then
		return min + (max - min) * math.random()
	end

	return math.random()
end

---@param degrees number
---@return number
function utils.degrees_to_radians(degrees)
	return degrees * math.pi / 180
end

---@param x number
---@param min number
---@param max number
---@return number
function utils.clamp(x, min, max)
	if x < min then return min end
	if x > max then return max end
	return x
end

return utils
