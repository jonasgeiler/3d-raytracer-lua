local utils = {}

function utils.degrees_to_radians(degrees)
	return degrees * math.pi / 180
end

function utils.clamp(x, min, max)
	if x < min then return min end
	if x > max then return max end
	return x
end

return utils
