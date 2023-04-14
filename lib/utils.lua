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

---Sort a table in a specific range
---@generic T
---@param tbl T[]
---@param from integer?
---@param to integer?
---@param comparator (fun(a: T, b: T): boolean)?
function utils.sort_range(tbl, from, to, comparator)
	from = from or 0
	to = to or #tbl

	local to_sort = {} ---@type any[]
	for i = from, to do
		if i > from and i <= to then
			to_sort[#to_sort + 1] = tbl[i] or 0
		end
	end

	table.sort(to_sort, comparator)

	for i = 1, #to_sort do
		if from + i > #tbl then break end
		tbl[from + i] = to_sort[i]
	end
end

return utils
