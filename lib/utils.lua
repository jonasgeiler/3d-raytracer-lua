local utils = {}

---Get a random float
---@param min number
---@param max number
---@return number
---@nodiscard
function utils.random_float(min, max)
	if min and max then
		return min + (max - min) * math.random()
	end

	return math.random()
end

---Convert degrees to radians
---@param degrees number
---@return number
---@nodiscard
function utils.degrees_to_radians(degrees)
	return degrees * math.pi / 180
end

---Clamp a number between a min and a max
---@param x number
---@param min number
---@param max number
---@return number
---@nodiscard
function utils.clamp(x, min, max)
	if x < min then return min end
	if x > max then return max end
	return x
end

return utils
