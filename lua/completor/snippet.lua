
--local log = require("completor.log")

-- snippet模式: $num, ${num}, ${num:placeholder}, ${1:another ${2:placeholder}}

local M = {}

local convert_step = function(str)
	local s = str:find("%$")
	if not s or s == #str then return str end
	local next_char = str:sub(s+1, s+1)
	if next_char == "{" then
		local front_str = str:sub(1, s-1)
		local after_str = str:sub(s)

		local ms = after_str:match("^%$%b{}")
		if not ms or #ms == 0 then return front_str .. "${", after_str:sub(3) end

		local next_str = after_str:sub(#ms + 1)
		-- local ph = ms:sub(3, -2):match("^[0-9]+:(.+)")
		local ph = ms:sub(3, -2):match("^[0-9]+:(.*)")
		if not ph then return front_str .. ms, next_str end
		return front_str .. ph, next_str, {col = #front_str, len = #ph}
	end

	if '0' <= next_char and next_char <= '9' then
		local front_str = str:sub(1, s-1)
		local after_str = str:sub(s)

		local ms = after_str:match("^%$[0-9]+")
		return front_str .. ms, after_str:sub(#ms + 1), {col = #front_str, len = #ms}
	end

	return str:sub(1, s), str:sub(s + 1)
end

local convert_iter = function(str)
	local iter_str = str
	return function()
		if not iter_str or #iter_str == 0 then return end
		local ret_str, istr, ph = convert_step(iter_str)
		iter_str = istr
		return ret_str, ph
	end
end

local parse = function(str)
	local phs = {}
	local ret = ""

	for s, ph in convert_iter(str) do
		if ph then ph.col = ph.col + #ret end
		ret = ret .. s
		table.insert(phs, ph)
	end

	return {str = ret, phs = phs}
end

return {
	parse = parse
}
