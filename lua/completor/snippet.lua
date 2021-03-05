
--local log = require("completor.log")

-- snippet模式: $num, ${num}, ${num:placeholder}, ${1:another ${2:placeholder}}

local M = {}

local convert_iter = function(str)
	local start = 1
	return function()
		local s = str:find("%$", start)
		if not s or s == #str then return nil end

		local head, tail = str:find("^%$[0-9]+", s)
		if head then
			start = tail + 1
			return {s - 1, start - 1}
		end

		head, tail = str:find("^%$%b{}", s)
		if not head then start = s + 1; return {} end

		local sub = str:sub(head + 2, tail - 1)
		local ph_str = sub:match("^[0-9]+:(.*)")
		if not ph_str then start = s + 2; return {} end
		start = s + #ph_str 
		str = str:sub(1, head - 1) .. ph_str .. str:sub(tail + 1)
		return {s - 1, start - 1}, str
	end
end

local parse = function(str)
	local placeholders = {}
	local new_str = nil

	for ph, nstr in convert_iter(str) do
		if #ph > 0 then
			table.insert(placeholders, ph)
		end
		if nstr then new_str = nstr end
	end

	return placeholders, new_str
end

return {
	parse = parse
}
